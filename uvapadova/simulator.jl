# ==========================================
# Julia Skeleton: UVA/Padova T1D Simulator
# ==========================================
# Autor: [dein Name]
# Lizenz: Frei verwendbar (inspiriert von SimGlucose, MIT License)
# Referenzen:
# 1. Cobelli C, et al. "The UVA/Padova Type 1 Diabetes Simulator: New Features." Diabetes Technology & Therapeutics, 2014.
# 2. Cobelli C, et al. "Artificial pancreas: diabetes simulator for in silico trials." Diabetes Technology & Therapeutics, 2009.
# 3. SimGlucose: Python Open-Source Implementation (MIT License)
# ==========================================

using DifferentialEquations
using Plots

# ------------------------------------------
# 1. Patientenparameter
# Diese Parameter stammen aus den UVA/Padova Publikationen
# und werden typischerweise aus CSV-Dateien geladen.
# Hier exemplarisch für einen Jugendlichen ("adolescent#001")
# ------------------------------------------
struct Patient
    Gb::Float64       # Basaler Glukosewert (mg/dL)
    Ib::Float64       # Basaler Insulinwert (µU/mL)
    SI::Float64       # Insulinsensitivität (L/µU/min)
    SG::Float64       # Glukoselösungsrate (1/min)
    kx::Float64       # Insulin-Effekt Abbaukonstante (1/min)
    kI::Float64       # Insulin Abbau (1/min)
end

# Beispielpatient
patient = Patient(
    Gb = 90.0,       # basaler Glukosewert
    Ib = 15.0,       # basales Insulin
    SI = 0.0001,     # Insulinsensitivität
    SG = 0.02,       # Glukose-Abbau
    kx = 0.03,       # Insulinwirkungskonstante
    kI = 0.05        # Insulin-Abbau
)

# ------------------------------------------
# 2. Mahlzeiten-Szenario
# Liste von Mahlzeiten als Tupel: (Zeit in min, Kohlenhydrate in g)
# Kann beliebig erweitert werden
# ------------------------------------------
struct Meal
    time::Float64     # Minuten seit Tagesbeginn
    CH::Float64       # Kohlenhydrate in Gramm
end

# Beispiel: drei Mahlzeiten am Tag
meals = [
    Meal(8*60, 60.0),   # Frühstück um 08:00 Uhr
    Meal(13*60, 70.0),  # Mittagessen um 13:00 Uhr
    Meal(19*60, 80.0)   # Abendessen um 19:00 Uhr
]

# ------------------------------------------
# 3. Differentialgleichungen (Minimalmodell)
# Basierend auf:
# - Cobelli et al., 2009 & 2014
# - SimGlucose Python Implementation
# Zustände:
# 1. G = Blutzucker (mg/dL)
# 2. X = Insulin-Effekt (1/min)
# 3. I = Plasmaspiegel Insulin (µU/mL)
# ------------------------------------------
function glucose_insulin!(du, u, p, t)
    G, X, I = u
    D = 0.0    # Glukosezufuhr aus Mahlzeiten (mg/dL/min)
    U = 0.0    # extern appliziertes Insulin (µU/mL/min)

    # --- Mahlzeiteneinfluss ---
    # Wir modellieren die Glukoseaufnahme als Dirac-Impulse mit Glukose-Ra
    for meal in p.meals
        # einfache Approximation: 1 g CH → 1 mg/dL über 30 min verteilt
        if t ≥ meal.time && t < meal.time + 30
            D += meal.CH / 30.0
        end
    end

    # --- Differentialgleichungen ---
    # Glukosedynamik
    du[1] = -p.SG*(G - p.Gb) - X*G + D
    # Insulinwirkung
    du[2] = -p.kx*X + p.SI*(I - p.Ib)
    # Plasmaspiegel Insulin
    du[3] = -p.kI*(I - p.Ib) + U
end

# ------------------------------------------
# 4. Simulation Setup
# ------------------------------------------
# Anfangszustände
G0 = 110.0   # Startblutzucker
X0 = 0.0     # Anfangsinsulineffekt
I0 = patient.Ib  # basales Insulin
u0 = [G0, X0, I0]

# Parameter für ODE
p = (Gb=patient.Gb, Ib=patient.Ib, SI=patient.SI, SG=patient.SG,
     kx=patient.kx, kI=patient.kI, meals=meals)

# Zeitspanne: 24 Stunden (0 bis 1440 min)
tspan = (0.0, 1440.0)

# ODEProblem
prob = ODEProblem(glucose_insulin!, u0, tspan, p)

# Solve ODE
sol = solve(prob, Tsit5())

# ------------------------------------------
# 5. Plot Ergebnisse
# ------------------------------------------
plot(sol.t, sol[1,:], xlabel="Zeit (min)", ylabel="Glukose (mg/dL)", title="T1D Simulation")
