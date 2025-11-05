==============================================================
Typ-1 Diabetes Closed-Loop Simulator in Julia
==============================================================

Projektname:
------------
T1D Closed-Loop Simulator (Julia-Version)
Dateien:
--------
1. simulator.jl  : Kernmodell der Glukose-Insulin-Dynamik
2. meal.jl       : Mahlzeiten-Absorptionsmodell (Magen/Dünndarm)
3. loop.jl       : Closed-Loop Controller (Basal-Bolus) mit Pen-Depot

Ziel:
-----
Dieses Projekt simuliert das physiologische System eines Typ-1-Diabetes Patienten
unter Basal-Bolus Therapie inklusive subkutaner Pen-Injektionen. Die Simulation
nutzt Differentialgleichungen zur Modellierung von Glukose- und Insulin-Dynamik,
Mahlzeitenabsorption und Controller-Logik.

Referenzen:
-----------
1. Cobelli C, et al. "The UVA/Padova Type 1 Diabetes Simulator: New Features." 
   Diabetes Technology & Therapeutics, 2014.
2. Cobelli C, et al. "Artificial pancreas: diabetes simulator for in silico trials." 
   Diabetes Technology & Therapeutics, 2009.
3. SimGlucose Python Open-Source Implementation (MIT License)

Installation:
-------------
1. Julia installieren: https://julialang.org/downloads/
2. Benötigte Pakete:
   - DifferentialEquations.jl
   - Plots.jl
3. In Julia REPL:
   ```julia
   using Pkg
   Pkg.add("DifferentialEquations")
   Pkg.add("Plots")

