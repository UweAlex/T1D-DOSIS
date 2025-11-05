# ==========================================
# Erweiterung: Mahlzeiten-Absorptionsmodell
# Zwei Kompartimente Magen + Dünndarm
# Quelle: SimGlucose / UVA-Padova Papers
# ==========================================

struct MealAbsorption
    kmax::Float64   # Maximaler Magen-Entleerungsrate (1/min)
    kmin::Float64   # Minimaler Magen-Entleerungsrate (1/min)
    b::Float64      # Parameter Sättigung der Magenentleerung
    f::Float64      # Fraktion der Mahlzeit im Magen
end

# Beispielparameter für Jugendliche
meal_params = MealAbsorption(
    kmax = 0.055, 
    kmin = 0.008, 
    b    = 0.9, 
    f    = 0.9
)

# ------------------------------------------
# Differentialgleichungen inkl. Mahlzeiten
# Zustände:
# u = [G, X, I, Qsto1, Qsto2, Qgut]
# G = Blutzucker (mg/dL)
# X = Insulinwirkung (1/min)
# I = Insulinspiegel (µU/mL)
# Qsto1, Qsto2 = Magenkompartimente (g CH)
# Qgut = Glukose im Dünndarm (g CH)
# ------------------------------------------
function glucose_insulin_meal!(du, u, p, t)
    G, X, I, Qsto1, Qsto2, Qgut = u
    patient, meals, meal_params = p

    # --------------------------
    # Mahlzeiten zuführen
    # --------------------------
    for meal in meals
        if t ≥ meal.time && t < meal.time + 1  # Mahlzeit einmalig einfügen
            Qsto1 += meal.CH * meal_params.f
            Qsto2 += meal.CH * (1 - meal_params.f)
        end
    end

    # --------------------------
    # Magenentleerung
    # --------------------------
    # Nichtlinearer Magenentleerungsprozess
    kemp = meal_params.kmin + (meal_params.kmax - meal_params.kmin) * (Qsto1 / (Qsto1 + meal_params.b))
    dQsto1 = -kemp * Qsto1
    dQsto2 = -kemp * Qsto2
    dQgut   = kemp * (Qsto1 + Qsto2) - 0.05 * Qgut  # 0.05: Dünndarmabsorption

    Ra = 0.05 * Qgut  # Glukoserate in Blut (mg/dL/min)

    # --------------------------
    # Glukose-Insulin Differentialgleichungen
    # --------------------------
    du[1] = -patient.SG*(G - patient.Gb) - X*G + Ra
    du[2] = -patient.kx*X + patient.SI*(I - patient.Ib)
    du[3] = -patient.kI*(I - patient.Ib)
    du[4] = dQsto1
    du[5] = dQsto2
    du[6] = dQgut
end

# ------------------------------------------
# 5 Zustände initialisieren
# G, X, I, Qsto1, Qsto2, Qgut
u0 = [110.0, 0.0, patient.Ib, 0.0, 0.0, 0.0]

# Parameter-Tuple
p = (patient, meals, meal_params)

# Zeitspanne 24h
tspan = (0.0, 1440.0)

# ODEProblem erstellen
prob = ODEProblem(glucose_insulin_meal!, u0, tspan, p)
sol = solve(prob, Tsit5())

# ------------------------------------------
# Ergebnisse plotten
# ------------------------------------------
plot(sol.t, sol[1,:], xlabel="Zeit (min)", ylabel="Glukose (mg/dL)",
     title="T1D Simulation mit Mahlzeiten-Absorption")
