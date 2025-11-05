# ==========================================
# Julia Closed-Loop T1D Simulator mit Pen
# ==========================================
# Ziel: Simuliere Typ-1-Diabetes Patient inkl.
# - Glukose-Insulin Dynamik
# - Mahlzeiten-Absorption
# - Basal-Bolus Therapie
# - Subkutanes Pen-Depot für Bolus-Injektionen
# ==========================================

using DifferentialEquations
using Plots

# ==========================================
# 1. Patientenparameter
# ==========================================
# Basierend auf UVA/Padova Typ-1 Diabetes Simulator Papers
# Quelle: Cobelli et al., 2009, 2014
struct Patient
    Gb::Float64       # Basaler Blutzucker (mg/dL)
    Ib::Float64       # Basales Insulin (µU/mL)
    SI::Float64       # Insulinsensitivität (L/µU/min)
    SG::Float64       # Glukoselösungsrate (1/min)
    kx::Float64       # Insulin-Effekt Abbaukonstante (1/min)
    kI::Float64       # Plasmaspiegel Insulin Abbau (1/min)
end

# Beispielpatient (Jugendlicher)
patient = Patient(
    Gb = 90.0,       
    Ib = 15.0,      
    SI = 0.0001,    
    SG = 0.02,      
    kx = 0.03,      
    kI = 0.05       
)

# ==========================================
# 2. Mahlzeiten-Szenario
# ==========================================
# Jede Mahlzeit ist ein Tupel: (Zeit in min seit Tagesbeginn, Kohlenhydrate in g)
struct Meal
    time::Float64
    CH::Float64
end

# Beispiel: Frühstück, Mittagessen, Abendessen
meals = [
    Meal(8*60, 60.0),   # Frühstück 08:00 Uhr
    Meal(13*60, 70.0),  # Mittag 13:00 Uhr
    Meal(19*60, 80.0)   # Abend 19:00 Uhr
]

# ==========================================
# 3. Mahlzeiten-Absorption: Zwei Magenkompartimente + Dünndarm
# ==========================================
# Parameter für Magen-Darm-Absorption
struct MealAbsorption
    kmax::Float64   # maximale Magenentleerung (1/min)
    kmin::Float64   # minimale Magenentleerung (1/min)
    b::Float64      # Sättigungskonstante Magenentleerung
    f::Float64      # Fraktion der Mahlzeit in Kompartment 1
end

meal_params = MealAbsorption(
    kmax = 0.055, 
    kmin = 0.008, 
    b    = 0.9, 
    f    = 0.9
)

# ==========================================
# 4. Pen-Depot für subkutane Bolus-Injektionen
# ==========================================
# PenDepot simuliert das subkutane Depot:
# - I_sc: Insulin im Depot (IE)
# - k_abs: Absorptionsrate ins Plasma (1/min)
struct PenDepot
    I_sc::Float64      # Insulinmenge im Depot
    k_abs::Float64     # Absorptionskonstante
end

# Funktion zur Aktualisierung Depot über dt Minuten
function update_pen!(pen::PenDepot, dose::Float64, dt::Float64)
    """
    - pen: PenDepot-Struct
    - dose: Bolus-Dosis in IE (zum Zeitpunkt der Injektion)
    - dt: Zeitschritt (min)
    
    Rückgabe: Menge Insulin, die ins Plasma geht
    """
    pen.I_sc += dose             # Bolus in Depot injizieren
    absorbed = pen.k_abs * pen.I_sc * dt   # Anteil wird ins Plasma freigesetzt
    pen.I_sc -= absorbed         # Depot abziehen
    return absorbed
end

# Beispiel: 10 IE Bolus, 30 min Halbwertszeit
pen = PenDepot(0.0, log(2)/30.0)  # k_abs so gewählt, dass T1/2 ≈ 30 min

# ==========================================
# 5. Basal-Bolus Controller
# ==========================================
# Controller entscheidet:
# - Basalinsulin (konstant)
# - Bolus zu Mahlzeiten + Korrekturbolus
struct BBController
    basal::Float64       # Basalinsulinrate (IE/min)
    ICR::Float64         # Insulin-Carb-Ratio (g CH / IE)
    CF::Float64          # Correction Factor (mg/dL pro IE)
    Gtarget::Float64     # Ziel-Blutzucker (mg/dL)
end

# Berechne Bolus
function bolus(controller::BBController, G::Float64, CH::Float64)
    """
    Berechnet Bolusdosis in IE für gegebene Kohlenhydrate und aktuellen Glukosewert
    - Korrekturbolus, falls G > Gtarget
    """
    I_bolus = CH / controller.ICR
    I_corr = max((G - controller.Gtarget) / controller.CF, 0.0)
    return I_bolus + I_corr
end

# Beispielcontroller
controller = BBController(basal=0.02, ICR=10.0, CF=50.0, Gtarget=110.0)

# ==========================================
# 6. Differentialgleichungen inkl. Glukose, Insulin, Mahlzeiten, Pen
# Zustände:
# u = [G, X, I, Qsto1, Qsto2, Qgut]
# ------------------------------------------
function glucose_insulin_pen!(du, u, p, t)
    G, X, I, Qsto1, Qsto2, Qgut = u
    patient, meals, meal_params, pen, controller = p

    # --------------------------
    # Mahlzeiteneingabe
    # --------------------------
    for meal in meals
        # einmalige Mahlzeit zum Zeitpunkt
        if t ≥ meal.time && t < meal.time + 1
            Qsto1 += meal.CH * meal_params.f
            Qsto2 += meal.CH * (1 - meal_params.f)
        end
    end

    # --------------------------
    # Magen-Darm-Absorption
    # --------------------------
    kemp = meal_params.kmin + (meal_params.kmax - meal_params.kmin) * (Qsto1 / (Qsto1 + meal_params.b))
    dQsto1 = -kemp * Qsto1
    dQsto2 = -kemp * Qsto2
    dQgut   = kemp * (Qsto1 + Qsto2) - 0.05 * Qgut

    Ra = 0.05 * Qgut  # Rate of Appearance in Blut (mg/dL/min)

    # --------------------------
    # Basalinsulin
    # --------------------------
    U_basal = controller.basal

    # --------------------------
    # Bolus Pen-Injektion
    # --------------------------
    # Prüfe, ob eine Mahlzeit aktuell ist
    for meal in meals
        if t ≥ meal.time && t < meal.time + 1
            dose = bolus(controller, G, meal.CH)
            U_bolus = update_pen!(pen, dose, 1.0)  # Zeitschritt 1 min
        else
            U_bolus = update_pen!(pen, 0.0, 1.0)
        end
    end

    # --------------------------
    # Glukose-Insulin-Differentialgleichungen
    # --------------------------
    du[1] = -patient.SG*(G - patient.Gb) - X*G + Ra
    du[2] = -patient.kx*X + patient.SI*(I - patient.Ib)
    du[3] = -patient.kI*(I - patient.Ib) + U_basal + U_bolus
    du[4] = dQsto1
    du[5] = dQsto2
    du[6] = dQgut
end

# ==========================================
# 7. Simulation Setup
# ==========================================
# Anfangszustände: G, X, I, Qsto1, Qsto2, Qgut
u0 = [110.0, 0.0, patient.Ib, 0.0, 0.0, 0.0]

# Parameter-Tuple
p = (patient, meals, meal_params, pen, controller)

# Zeitspanne: 24 Stunden (0 bis 1440 min)
tspan = (0.0, 1440.0)

# ODEProblem erstellen
prob = ODEProblem(glucose_insulin_pen!, u0, tspan, p)
sol = solve(prob, Tsit5())

# ==========================================
# 8. Ergebnisse plotten
# ==========================================
plot(sol.t, sol[1,:], xlabel="Zeit (min)", ylabel="Blutzucker (mg/dL)",
     title="T1D Closed-Loop Simulation mit Pen-Injektionen")
