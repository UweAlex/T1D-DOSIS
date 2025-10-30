# Glossar zu Begriffen, Abkürzungen und Formeln im T1D-Management

Dieses Glossar basiert auf den offiziellen Dokumentationen von OpenAPS, AndroidAPS und Loop. Es deckt die wichtigsten Begriffe, Abkürzungen und Faktoren ab, die in Algorithmen wie oref0/oref1 oder MPC für Dosing, Vorhersagen und Closed-Loop-Logik vorkommen. Fokussiert auf MDI-Optimierung (z. B. für T1D-DOSIS).

## Inhaltsverzeichnis

- [1. Messwerte & Vorhersagen](#1-messwerte--vorhersagen)
- [2. Insulin-Faktoren](#2-insulin-faktoren)
- [3. Carb- & Mahlzeit-Modelle](#3-carb--mahlzeit-modelle)
- [4. System- & Modi](#4-system--modi)
- [5. Sicherheits- & Anpassungs-Features](#5-sicherheits--anpassungs-features)
- [Hinweise zur Nutzung in T1D-DOSIS](#hinweise-zur-nutzung-in-t1d-dosis)

## 1. Messwerte & Vorhersagen

| Abkürzung | Vollform (Englisch / Deutsch) | Beschreibung | Formel/Verwendung | Beispiel (mit Schritt-für-Schritt) | MDI-Relevanz für T1D-DOSIS |
|-----------|-------------------------------|--------------|-------------------|------------------------------------|----------------------------|
| **BG** (aktueller BG) | Blood Glucose (Current) / Blutzucker (aktuell) | Der aktuell gemessene Glukosewert aus CGM (z. B. Freestyle Libre) oder BGM. Immer der Einstiegspunkt für Prognosen. Oft als "Current BG" in Apps bezeichnet. | Basis: Delta = aktueller BG - vorheriger BG. Mittelwert (Avg. Delta) für Trends (z. B. -2 mg/dL/min = Fall). | **Szenario: Nach-Mahlzeit-Anstieg.** Aktueller BG = 180 mg/dL (gemessen um 12:00). Vorheriger BG (11:55) = 150 mg/dL. **Schritte**: 1. Delta = 180 - 150 = +30 mg/dL (über 5 Min → +6 mg/dL/min). 2. Trend: Steigend → Warte auf Peak. **Empfehlung**: Kein Bolus, wenn COB hoch. | In MDI: Direkter Input via Juggluco-Broadcast. Nutze für sofortige Checks: "Aktueller BG 180 → +30 Delta → Mahlzeit-Absorption läuft." |
| **BGI** | Blood Glucose Impact / Blutzucker-Impact | Erwarteter BG-Wechsel durch aktuelles Insulin (ohne Carbs). Negativ = Fall, positiv = Anstieg (z. B. durch Basal). | BGI = - (IOB × ISF) / Zeit (pro Minute). **Schritte**: 1. IOB-Decay berechnen. 2. × ISF. 3. / Intervall (z. B. 5 Min). | **Szenario: Post-Bolus.** Aktueller BG = 120 mg/dL, IOB = 2 IE, ISF = 50 mg/dL/IE. **Schritte**: 1. Insulin-Effekt = 2 × 50 = 100 mg/dL. 2. BGI = -100 / 60 Min ≈ -1.67 mg/dL/min. **Ergebnis**: Erwarteter Fall um 100 mg/dL in 1 Std. → Eventual BG ~20 mg/dL (Hypo-Risiko!). | Für Pens: Hilft bei "Wie wirkt mein letzter Bolus?" – Integriere in App-Alarm: "BGI -1.7/min → Carbs bald nötig?" |
| **Delta** | Delta / Delta (Differenz) | Differenz zwischen zwei aufeinanderfolgenden BG-Werten (über 5 Min). Zeigt aktuellen Trend (Rise/Fall). | Delta = aktueller BG - BG_{t-5min}. Avg. Delta = Mittelwert über 3–5 Werte. | **Szenario: Exercise-Effekt.** Aktueller BG = 90 mg/dL, vorheriger = 110 mg/dL. **Schritte**: 1. Delta = 90 - 110 = -20 mg/dL (über 5 Min → -4 mg/dL/min). 2. Avg. Delta (letzte 15 Min) = -3 mg/dL/min. **Empfehlung**: Bei < -2/min: 10–15g KH. | MDI-spezifisch: Kein automatischer Basal, also manuell tracken – z. B. "Delta -4/min → Preemptiver Carb-Alarm in App." |
| **Eventual BG** | Eventual Blood Glucose / Erwarteter Blutzucker | Prognostizierter BG nach vollständiger Wirkung von IOB und COB (nach DIA, typ. 3–5 Std.). Kern für Hypo/Hyper-Alarme. | Eventual BG = aktueller BG - (ISF × IOB) + (COB × CSF). **Schritte**: 1. Subtrahiere Insulin-Pull (ISF × IOB). 2. Addiere Carb-Push (COB × CSF). 3. Vergleiche mit Threshold (z. B. 70 mg/dL). | **Szenario: Abendroutine.** Aktueller BG = 100 mg/dL, IOB = 1.5 IE, ISF = 40 mg/dL/IE, COB = 20g, CSF = 4 mg/dL/g. **Schritte**: 1. Insulin-Effekt = 1.5 × 40 = 60 mg/dL. 2. Carb-Effekt = 20 × 4 = 80 mg/dL. 3. Eventual BG = 100 - 60 + 80 = 120 mg/dL (>70 → Kein Hypo-Risiko, aber monitoren). **Alternative (kein COB)**: 100 - 60 = 40 mg/dL (<70 → 15g KH empfehlen). | Perfekt für MDI: "Eventual BG 40 → Hypo in 1–2 Std. erwartet – iss jetzt!" Als Layer 1 in deiner App, vor ML-Refinement. |
| **PredBGs** | Predicted Blood Glucose / Prognostizierter Blutzucker | Kurven-Vorhersage über 15–180 Min. (in 5-Min-Schritten), inkl. Min/Max. | Basierend auf ODE: dBG/dt = BGI + COB-Impact - Basal. MINpredBG = Minimum der Kurve. | **Szenario: Nachts.** Aktueller BG = 110 mg/dL, BGI = -0.5 mg/dL/min, COB = 0. **Schritte**: 1. Prognose 60 Min: BG(t) = 110 + ∫ BGI dt ≈ 110 - 30 = 80 mg/dL. 2. MINpredBG = 75 mg/dL (bei Fall). **Empfehlung**: Wenn <80: Reduziere Basal (MDI: Nächste Dosis anpassen). | In T1D-DOSIS: Erweitere zu Stunden-Prognose für "bundled Dosing" – z. B. "PredBGs zeigt Dip in 90 Min → Warte mit Korrektur." |

## 2. Insulin-Faktoren

| Abkürzung | Vollform (Englisch / Deutsch) | Beschreibung | Formel/Verwendung |
|-----------|-------------------------------|--------------|-------------------|
| **BR** | Basal Rate / Basalrate | Stundenweise Grundinsulindosis (IE/h), um BG stabil zu halten. | TBB = ∑ BR (über 24h). **Schritte**: Passe an (z. B. TBR = BR × Multiplikator via Autosens). In MDI: Manuell anpassen. |
| **DIA** | Duration of Insulin Action / Wirkdauer des Insulins | Zeit bis Insulin abgebaut ist (typ. 3–6 Std.). Beeinflusst IOB-Decay. | IOB-Decay = IOB × e^{-t / (DIA/2)} (exponentiell; 50% nach DIA/2). **Schritte**: 1. Setze Peak (z. B. 75 Min für Rapid). 2. Integriere Kurve für verbleibende Wirkung. |
| **IOB** | Insulin On Board / Insulin an Bord | Aktives Insulin aus Bolus/Basal (Net IOB berücksichtigt Abweichungen). | Net IOB = Bolus IOB + Basal IOB. **Schritte**: 1. Berechne Bolus-Decay (via DIA). 2. Addiere Basal-Differenz (TBR vs. BR). 3. Limit via maxIOB (Sicherheit). |
| **ISF** | Insulin Sensitivity Factor / Insulinsensitivitätsfaktor | MG/dl-Senkung pro IE (z. B. 1:40). Dynamisch anpassbar. | ISF = 1800 / TDD (Rule of 1800). **Schritte**: 1. Teile 1800 durch TDD. 2. Passe via Autosens (z. B. × Ratio 0.7–1.2). 3. DynISF: Multipliziere mit Adjustment Factor (1–300%). |
| **TDD** | Total Daily Dose / Tägliche Gesamtdosis | Summe Basal + Bolus pro Tag (IE). Basis für Sensitivitäts-Schätzungen. | TDD = TBB + Bolus. **Schritte**: Tracke 24h; skaliere ISF/ICR (z. B. DynISF aggressiver bei hohem TDD). |

## 3. Carb- & Mahlzeit-Modelle

| Abkürzung | Vollform (Englisch / Deutsch) | Beschreibung | Formel/Verwendung |
|-----------|-------------------------------|--------------|-------------------|
| **COB** | Carbs On Board / Kohlenhydrate an Bord | Unabsorbierte Carbs, die BG noch beeinflussen (mit Decay). | COB-Impact = COB × CSF. **Schritte**: 1. Subtrahiere absorbierte Carbs (via BGI). 2. Decay: min_5m_carbimpact (z. B. 5–8g/5min bei Lücken). 3. Prognose: S-Kurve (flat → sharp rise). |
| **CR** (ICR) | Carb Ratio / Kohlenhydrat-Verhältnis | Gramm Carbs pro IE (z. B. 1:10). | Bolus = Carbs / CR. **Schritte**: 1. Teile Carbs durch CR. 2. Addiere Korrektur: + (BG - Target) / ISF. 3. Passe via Autosens. |
| **CSF** | Carb Sensitivity Factor / Kohlenhydrat-Sensitivitätsfaktor | BG-Anstieg pro g absorbierter Carbs (z. B. 5 mg/dL/g). | Delta BG = COB × CSF. **Schritte**: Schätze aus Historie; nutze für UAM (Unannounced Meals). |

## 4. System- & Modi

| Abkürzung | Vollform (Englisch / Deutsch) | Beschreibung | Formel/Verwendung |
|-----------|-------------------------------|--------------|-------------------|
| **AMA** | Advanced Meal Assist / Erweiterte Mahlzeitenhilfe | Algorithmus für aggressive Basal-Anpassung nach Bolus (in oref0). | Erhöht Basal post-Bolus. **Schritte**: Basierend auf COB; kombiniert mit SMB für schnelle Korrektur. |
| **APS** | Artificial Pancreas System / Künstliches Pankreas-System | Closed-Loop-System (z. B. OpenAPS, AndroidAPS, Loop) für automatisierte Dosing. | N/A – Übergeordneter Begriff. |
| **Closed Loop** | Closed Loop / Geschlossene Schleife | Automatische Anpassungen ohne User-Bestätigung (basierend auf Vorhersagen). | In Loop: MPC-Modell (Model Predictive Control) prognostiziert 30–180 Min. **Schritte**: 1. CGM-Input. 2. Berechne IOB/COB. 3. Passe TBR/SMB. |
| **LGS** | Low Glucose Suspend / Niedriger-Glukose-Suspend | Reduziert Basal bei fallendem BG; kein Anstieg bei Rising (bis IOB negativ). | Basal = 0% bei BG < Threshold. **Schritte**: Überwache Delta; suspendiere bei Hypo-Risiko. |
| **MPC** | Model Predictive Control / Modellprädiktive Kontrolle | Algorithmus in Loop für Vorhersagen und Dosing (über 30 Min–3 Std.). | Prognose = f(IOB, COB, EGP, Settings). **Schritte**: 1. Modelliere Glukose-Dynamik. 2. Optimiere Insulin unter Limits. 3. RC (Retrospective Correction) passt an reale BG an. |
| **Oref0 / Oref1** | OpenAPS Reference Design 0/1 / OpenAPS-Referenzdesign | Kern-Algorithmen: oref0 (Basal-only), oref1 (mit SMB). | In oref1: SMB = min((BG - Target)/ISF, maxIOB). **Schritte**: 1. Berechne Eventual BG. 2. Wenn > Target und niedriges IOB: SMB dosieren. |
| **Open Loop** | Open Loop / Offene Schleife | Empfehlungen, aber manuelle Umsetzung (z. B. für MDI in T1D-DOSIS). | N/A – Manuelle Overrides. |
| **SMB** | Super Micro Bolus / Super-Mikro-Bolus | Kleiner automatischer Bolus für schnelle Korrektur (in oref1). | SMB = min((BG - Target)/ISF, maxIOB/5). **Schritte**: 1. Prüfe Deviation >0. 2. Wenn IOB < maxIOB: Dosieren (z. B. 40% automatisch in Loop). 3. Limit: max 1–3 IE. |
| **TT** | Temporary Target / Temporäres Ziel | Vorübergehendes BG-Ziel (z. B. 140 mg/dL für Activity). | Korrektur = (BG - TT)/ISF. **Schritte**: Setze Dauer (z. B. 90 Min); reduziert Überkorrekturen. |
| **UAM** | Unannounced Meal / Unangekündigte Mahlzeit | Detektiert BG-Rises (z. B. versteckte Carbs) und dosiert via SMB. | Floating Carbs = Rise / CSF. **Schritte**: 1. Erkenne unerwarteten Anstieg. 2. Schätze COB. 3. SMB dosieren. |

## 5. Sicherheits- & Anpassungs-Features

| Abkürzung | Vollform (Englisch / Deutsch) | Beschreibung | Formel/Verwendung |
|-----------|-------------------------------|--------------|-------------------|
| **Autosens** | Autosens / Automatische Sensitivitätsanpassung | Dynamische Anpassung von ISF/ICR basierend auf 8–24h-Daten (z. B. via Exercise). | Ratio = 0.7–1.2 (min/max). **Schritte**: 1. Analysiere Deviationen. 2. Multipliziere Faktoren (z. B. ISF × Ratio). 3. In Loop: Integriert in MPC. |
| **maxIOB** | Maximum Insulin On Board / Maximales Insulin an Bord | Sicherheitsgrenze für IOB (z. B. 3 IE), um Stacks zu vermeiden. | Wenn IOB > maxIOB: Kein SMB. **Schritte**: Setze Limit; prüfe vor Dosing. |
| **min_5m_carbimpact** | Minimum 5-Minute Carb Impact / Minimaler 5-Min-Carb-Impact | Default-Decay bei CGM-Lücken (z. B. 5–8g/5min). | Absorbed = min_5m_carbimpact × (t/5min). **Schritte**: Bei fehlendem BGI: Annahme für COB-Reduktion. |
| **TBR** | Temporary Basal Rate / Temporäre Basalrate | Temporäre Änderung der BR (z. B. 120% für 30 Min.). | TBR = BR × Faktor (via BGI). **Schritte**: In Closed Loop: Automatisch; in MDI: Manuell simulieren. |

## Hinweise zur Nutzung in T1D-DOSIS

- **Integrationstipps**: Starte mit Eventual BG als Baseline für Hypo-Alarme (wie in deiner Formel). Erweitere mit ML (Julia/Flux) für dynamische ISF (z. B. Zeit-of-Day-Anpassung).
- **Sicherheit**: Alle Formeln sind konservativ (Puffer einbauen, z. B. +20% Carbs). Validiere mit Simulationen (z. B. OhioT1DM-Dataset).
- **Quellen**: Basierend auf AndroidAPS-Glossar, OpenAPS-Docs und Loop-Glossar.

**Zuletzt aktualisiert:** Oktober 2025
