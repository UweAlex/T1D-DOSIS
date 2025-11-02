### Empfohlene Links mit Hinweisen:
1. **https://github.com/kennedyjustin/BolusGPT**  
   Sehr relevant: Ein OpenAI-GPT-basiertes Bolus-Dosing-Tool für T1D-MDI, das CGM-Daten (Dexcom-ähnlich zu Juggluco) integriert, IOB trackt (via last-bolus-time/units) und ISF in Dosis-Berechnungen einfließt. Es hat eine HTTP-API für Advisor-Logik (z. B. `/dose`-Endpoint mit Carbs/Fiber/Protein), die du direkt für dein Bolus-UI forken könntest. Nützliche Snippets: User-Settings-Speicherung (JSON) und Mahlzeit-basierte Korrekturen – ideal für dein MVP (Woche 2). Kein Julia, aber Python-Code portierbar.

2. **https://github.com/gcappon/awesome-diabetes-software**  
   Goldwert als Einstieg: Eine kuratierte Liste mit 50+ Open-Source-Tools für Diabetes-Software, inkl. CGM-Analyse (AGATA/PyAGATA für Juggluco-ähnliche TSV), Hypo-Prediction (PhyPredict mit physiologischen Modellen) und Simulations-Umgebungen (ReplayBG/PyReplayBG für IOB/ISF-Tests ohne reale Daten). Hervorzuheben: GluPredKit für Echtzeit-Glukose-Prognosen und cgmquantify für CGM-Quantifizierung – perfekt für dein Backend (Julia-Integration via PyCall.jl). Kein fertiger Bolus-Advisor, aber tolle Ressourcen für DIY-Studien (z. B. Datasets in APS_TestBed).

3. **https://github.com/RL4H/GluCoEnv**  
   Stark für Simulation und Testing: Ein RL-Umfeld (PyTorch-basiert) für T1D-Glukose-Kontrolle mit UVA/Padova-Modell, das IOB-Dynamik (Bolus-only für MDI) und CGM-Noise simuliert. Es unterstützt Hypo-Risiko-Minimierung via Reward-Shaping und hat Benchmark-Code für Bolus-Entscheidungen (SBB-Controller). Nützlich für dein Plan (Woche 3): Trainiere schnelle Tests auf synthetischen Daten, bevor du reale TSV nutzt. Exportierbar zu ONNX für Android; kein Julia, aber modular für Integration.
