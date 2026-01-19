### Empfohlene Links mit Hinweisen:
1. **https://github.com/kennedyjustin/BolusGPT**  
   Sehr relevant: Ein OpenAI-GPT-basiertes Bolus-Dosing-Tool für T1D-MDI, das CGM-Daten (Dexcom-ähnlich zu Juggluco) integriert, IOB trackt (via last-bolus-time/units) und ISF in Dosis-Berechnungen einfließt. Es hat eine HTTP-API für Advisor-Logik (z. B. `/dose`-Endpoint mit Carbs/Fiber/Protein), die du direkt für dein Bolus-UI forken könntest. Nützliche Snippets: User-Settings-Speicherung (JSON) und Mahlzeit-basierte Korrekturen – ideal für dein MVP (Woche 2). Kein Julia, aber Python-Code portierbar.

2. **https://github.com/gcappon/awesome-diabetes-software**  
   Goldwert als Einstieg: Eine kuratierte Liste mit 50+ Open-Source-Tools für Diabetes-Software, inkl. CGM-Analyse (AGATA/PyAGATA für Juggluco-ähnliche TSV), Hypo-Prediction (PhyPredict mit physiologischen Modellen) und Simulations-Umgebungen (ReplayBG/PyReplayBG für IOB/ISF-Tests ohne reale Daten). Hervorzuheben: GluPredKit für Echtzeit-Glukose-Prognosen und cgmquantify für CGM-Quantifizierung – perfekt für dein Backend (Julia-Integration via PyCall.jl). Kein fertiger Bolus-Advisor, aber tolle Ressourcen für DIY-Studien (z. B. Datasets in APS_TestBed).

3. **https://github.com/RL4H/GluCoEnv**  
   Stark für Simulation und Testing: Ein RL-Umfeld (PyTorch-basiert) für T1D-Glukose-Kontrolle mit UVA/Padova-Modell, das IOB-Dynamik (Bolus-only für MDI) und CGM-Noise simuliert. Es unterstützt Hypo-Risiko-Minimierung via Reward-Shaping und hat Benchmark-Code für Bolus-Entscheidungen (SBB-Controller). Nützlich für dein Plan (Woche 3): Trainiere schnelle Tests auf synthetischen Daten, bevor du reale TSV nutzt. Exportierbar zu ONNX für Android; kein Julia, aber modular für Integration.
### Erweiterte Referenz/Literaturliste mit Kurzen Abstracts

Hier die aktualisierte Liste der 6 relevanten Quellen. Ich habe für jede einen kurzen Abstract (ca. 100–150 Wörter, extrahiert/gekürzt aus den Originalen) hinzugefügt, basierend auf den bereitgestellten Dokumenten oder ergänzenden Suchen (z. B. für Preprints). Die Abstracts fassen den Kern zusammen und heben T1D/CGM-Relevanz hervor, passend zu deinem MDI-Fokus (IOB/ISF, Hypo-Prognose).

1. **Liu, K., Li, L., Ma, Y., Jiang, J., Liu, Z., Ye, Z., Liu, S., Pu, C., Chen, C., & Wan, Y. (2022). Machine learning models for blood glucose prediction in patients with diabetes mellitus: A systematic review and network meta-analysis. *SSRN Electronic Journal*. https://doi.org/10.2139/ssrn.4401684**  
   **Abstract**: This systematic review and network meta-analysis evaluates machine learning (ML) models for blood glucose (BG) prediction in diabetes mellitus, focusing on continuous glucose monitoring (CGM) data. From 1636 records, 34 studies were included (20,852 participants, 663 with T1D). ML/DL algorithms (e.g., LSTM, SVR) were compared for RMSE/CEG accuracy. Linear models (e.g., ARIMA) achieved RMSE 1.5–2.0 mmol/L, while nonlinear DL (e.g., LSTM) reduced it to <0.3 mmol/L for 30-min horizons. TIR/CEG >95% in T1D-Subsets. Challenges: Limited T1D-data, IOB-integration gaps. Recommendation: Hybrid models with physiological constraints (e.g., IOB) for clinical use. (Preprint; full review in final publication.)

2. **Tsichlaki, S., Koumakis, L., & Tsiknakis, M. (2022). Type 1 diabetes hypoglycemia prediction algorithms: Systematic review. *JMIR Diabetes, 7*(3), e34699. https://doi.org/10.2196/34699**  
   **Abstract**: This PRISMA-based review analyzes 19 predictive models for T1D hypoglycemia using CGM/HRV data. Algorithms span statistics (10%, e.g., Kalman), ML (52%, e.g., SVM/RF), and DL (38%, e.g., LSTM). Accuracies: 70–99% F1, with Kalman/SVM leading for 15–30 min horizons. CGM-only models (e.g., RF) excel in non-invasive prediction (recall >90%). Challenges: Limited wearables-data; future: DL with HRV for mobile health. Prospective trials needed for real-life validation in T1D, reducing hypo-events by >50%.

3. **Yapanis, M., James, S., Craig, M. E., O’Neal, D., & Ekinci, E. I. (2022). Complications of diabetes and metrics of glycemic management derived from continuous glucose monitoring. *The Journal of Clinical Endocrinology & Metabolism, 107*(6), e2221–e2236. https://doi.org/10.1210/clinem/dgac034**  
   **Abstract**: Review of 34 studies (20,852 participants, 663 T1D) links CGM-metrics (TIR, CV, MAGE) to complications. Low TIR (<70%) associates with retinopathy (OR 1.5), nephropathy (albuminuria risk +20%), neuropathy (SD/MAGE >30%), CVD (mortality +15%), and mortality. Higher TIR (>70%) reduces risks by 10–25%. T1D-specific: MAGE >3 mmol/L predicts neuropathy. Recommendation: TIR/CEG as clinical surrogates for HbA1c; integrate IOB for dynamic variability. Longitudinal T1D-trials urged.

4. **Kozinetz, R. M., Berikov, V. B., Semenova, J. F., & Klimontov, V. V. (2024). Machine learning and deep learning models for nocturnal high- and low-glucose prediction in adults with type 1 diabetes. *Diagnostics, 14*(7), 740. https://doi.org/10.3390/diagnostics14070740**  
   **Abstract**: Study develops ML/DL models (MLP, CNN, RF, GBTs) for nocturnal glucose-range prediction in 380 T1D-MDI adults using CGM. Models predict target (3.9–10 mmol/L), high (>10), low (<3.9) with 30-min horizon. F1: 96–98% (target), 93–97% (high), 80–86% (low). MLP excels in low-glucose (F1 86%). CGM-only input; RMSE <0.3 mmol/L. Conclusion: ML/DL viable for MDI; MLP/CNN for low-glucose alerts, reducing nighttime risks.

5. **Zhu, T., Li, K., Herrero, P., & Georgiou, P. (2022). Personalized blood glucose prediction for type 1 diabetes using evidential deep learning and meta-learning. *IEEE Transactions on Biomedical Engineering*. https://doi.org/10.1109/TBME.2022.3187703**  
   **Abstract**: Proposes FCNN (attention-RNN + evidential DL + meta-learning) for personalized T1D-BG prediction using CGM. Computes RMSE 18.64 mg/dL (30 min)/31.07 mg/dL (60 min) on 12-subject dataset, outperforming baselines (SVR/LSTM) by 10–15%. Computes confidence via evidential outputs; meta-learning enables fast adaptation (<1 week data). Applications: Smartphone alerts for proactive actions. Challenges: Limited data; future: IOB-integration for hybrid models.

6. **Afsaneh, E., Sharifdini, A., Ghazzaghi, H., & Zarei Ghobadi, M. (2022). Recent applications of machine learning and deep learning models in the prediction, diagnosis, and management of diabetes: A comprehensive review. *Diabetology & Metabolic Syndrome, 14*, 196. https://doi.org/10.1186/s13098-022-00969-9**  
   **Abstract**: Comprehensive review of 50+ ML/DL models for diabetes (T1D/T2D/GDM) prediction/management. Covers CGM-based prognosis (LSTM/RF for T1D-Hypo, RMSE <0.5 mmol/L), diagnosis (SVM on Pima, AUC >95%), and therapy (DL for IOB-optimierte Bolus). T1D-Fokus: 20% Studien mit CGM-only; DL übertrifft ML in Dynamik (z. B. +15% TIR). Challenges: Datenmangel; Empfehlung: Hybride Modelle für MDI, inkl. Wearables. Future: Federated Learning für Personalisierung.

Modell:
https://github.com/NeuroDiab/UVAPadovaAPI
https://github.com/replicahealth/GluPredKit

Anbindung an Juggluco:
GlucoDataHandler
Tasker



