# T1D-DOSIS: Intelligent Therapy Optimization for MDI

**Open-Source Conceptual Feasibility Study for Pen Users with CGM**

*Note: This project is a personal feasibility study and exploratory concept, developed as a proof-of-concept for optimizing MDI tVerstanden. Hier ist der vollständige Text des READMEs, ohne jegliche Verwendung von Triple-Backticks (Code-Blöcken), damit du ihn ohne Formatierungsprobleme kopieren kannst.

Code-Abschnitte und JSON-Beispiele habe ich stattdessen eingerückt dargestellt.

---

# T1D-DOSIS: Intelligent Therapy Optimization for MDI

**Open-Source Conceptual Feasibility Study for Pen Users with CGM**

*Note: This project is a personal feasibility study and exploratory concept, developed as a proof-of-concept for optimizing MDI therapy. It aims to inspire fellow developers, researchers, and experienced T1D individuals to explore similar ideas. It is **NOT** a ready-to-use system and should never be implemented or relied upon without extensive personal validation, professional medical oversight, and rigorous testing. Misuse could be potentially life-threatening. Proceed only if you have deep expertise in T1D management and software development.*

---

## Inhaltsverzeichnis

* [What is T1D-DOSIS?](https://www.google.com/search?q=%23what-is-t1d-dosis)
* [The Problem](https://www.google.com/search?q=%23the-problem)
* [The Solution: Conceptual Components](https://www.google.com/search?q=%23the-solution-conceptual-components)


* [Who is it for?](https://www.google.com/search?q=%23who-is-it-for)
* [Why Not Pump + Closed-Loop?](https://www.google.com/search?q=%23why-not-pump--closed-loop)


* [Architecture](https://www.google.com/search?q=%23architecture)
* [Component 1: Conceptual Android App (Kotlin)](https://www.google.com/search?q=%23component-1-conceptual-android-app-kotlin)
* [Why a Separate App?](https://www.google.com/search?q=%23why-a-separate-app)
* [Component 2: Conceptual Desktop Backend (Julia)](https://www.google.com/search?q=%23component-2-conceptual-desktop-backend-julia)
* [Component 3: Virtual Mesh Networking (Tailscale)](https://www.google.com/search?q=%23component-3-virtual-mesh-networking-tailscale)


* [Development Status](https://www.google.com/search?q=%23development-status)
* [Technical Details](https://www.google.com/search?q=%23technical-details)
* [IOB Calculation](https://www.google.com/search?q=%23iob-calculation)
* [ISF Optimization](https://www.google.com/search?q=%23isf-optimization)
* [Hypo Prediction](https://www.google.com/search?q=%23hypo-prediction)
* [Glossar (GLOSSAR.md)](https://www.google.com/search?q=GLOSSAR.md)


* [Positioning in the DIY Ecosystem](https://www.google.com/search?q=%23positioning-in-the-diy-ecosystem)
* [Technology Stack](https://www.google.com/search?q=%23technology-stack)
* [For Developers & Researchers](https://www.google.com/search?q=%23for-developers--researchers)
* [Contributing to the Project](https://www.google.com/search?q=%23contributing-to-the-project)
* [Academic Use](https://www.google.com/search?q=%23academic-use)
* [Commercial Development](https://www.google.com/search?q=%23commercial-development)


* [Related Projects & Scientific Foundation](https://www.google.com/search?q=%23related-projects--scientific-foundation)
* [License](https://www.google.com/search?q=%23license)
* [Disclaimer & Important Notes](https://www.google.com/search?q=%23disclaimer--important-notes)
* [Status: Personal DIY Feasibility Study](https://www.google.com/search?q=%23status-personal-diy-feasibility-study)
* [Personal Responsibility](https://www.google.com/search?q=%23personal-responsibility)
* [Liability Disclaimer](https://www.google.com/search?q=%23liability-disclaimer)
* [Medical Note](https://www.google.com/search?q=%23medical-note)
* [Certification & Regulatory Approval](https://www.google.com/search?q=%23certification--regulatory-approval)


* [Implementation Plan](https://www.google.com/search?q=%23implementation-plan)
* [Roadmap](https://www.google.com/search?q=%23roadmap)
* [FAQ](https://www.google.com/search?q=%23faq)
* [Contact](https://www.google.com/search?q=%23contact)

---

## What is T1D-DOSIS?

T1D-DOSIS is a **DIY conceptual project** to explore insulin therapy optimization for **Multiple Daily Injections (MDI)** – ideal for people using pens or syringes. As a personal feasibility study, it investigates how data-driven tools could enhance MDI for those not using pumps, but it remains in early ideation and is shared primarily as inspiration for the community.

### The Problem

With MDI (pens or syringes) and CGM, the trend direction (rising or falling BG) is usually clear – but predicting *how far it goes* and handling external factors like meals or exercise is the real nightmare:

* **Connectivity Obstacles**: Public Wi-Fi (e.g., campgrounds) often blocks ports (like 17580) or isolates devices via "Client Isolation", preventing the laptop from reaching the phone's Juggluco server to retrieve data.
* **Amplitude uncertainty**: Will that -2 mg/dL/min drop bottom out at 80 mg/dL or crash to 50? Even with IOB and ISF knowledge, you only get a rough estimate of the pull – not enough for spot-on dosing without risks.
* **Meal mysteries**: You never know the exact insulin-required components – not just digestible carbs, but also protein and fat, which contribute delayed, partial insulin needs (e.g., gluconeogenesis from protein, slowed absorption from fat). Variable timing (fatty meals delay peaks by hours, stress alters it) turns ICR calculations into guesswork, causing sneaky post-meal spikes or crashes. Even when digestion is underway and more insulin is surely needed, the dilemma persists: Inject small doses immediately (risking too many shots and potential over-correction) or wait to bundle into fewer injections for similar results (but risking prolonged highs)?
* **Exercise unpredictability**: Depending on type (e.g., HIIT vs. steady cardio) and intensity, it can dramatically swing BG – instant drops from heightened insulin sensitivity, delayed hypos hours later, or even spikes from stress hormones. Adjusting doses pre/post-workout is a blind guess without pattern data.
* **Dosing guesswork**: Rising? Inject correction insulin – but how many units to avoid rebound? Falling? Swallow glucose tabs/KH – but 15g or 10g to not overshoot? It's all approximations, leading to over/under-corrections and instability.
* **Late alarms**: Standard alerts (e.g., at 70 mg/dL) still hit too late; you're scrambling to react, not prevent.
* **No closed-loop for pens**: Systems like AndroidAPS/Loop need a pump – leaving MDI users without predictive smarts.
* **Manual tweaks**: Therapy factors (ISF, ICR, basal) demand constant, imprecise fiddling from logs.

Every trend, every bite, every workout becomes a high-stakes gamble. This study explores how layered forecasts could sharpen those edges – but remember, it's conceptual only.

### The Solution: Conceptual Components

This feasibility study envisions components to estimate insulin and carb needs as safely as possible, using layered forecasts – from traditional metrics to AI-driven predictions – for the leanest, most targeted interventions. These are high-level ideas, not implemented code.

**📱 Conceptual Android App: Intelligent Hypo Early Warning**
Standard alarm: "70 mg/dL reached" → Too late!

Envisioned T1D-DOSIS: "95 mg/dL, but:

* 2.5 IU IOB active
* Fall rate: -3 mg/dL/min
* Your ISF: 1:40 (adjusted for recent drift)
* Current BG trajectory
→ Hypo risk building over next 1-2 hours (AI-refined for precision)
→ Eat 15g carbs now – minimal dose for quick stabilization"

**💻 Conceptual Desktop Backend: Long-Term Optimization**

* Analyzes weeks/months of your data for patterns (e.g., sport-induced drops, protein/fat delays)
* Calculates optimal ISF, ICR, basal rates with safety buffers
* Accounts for time of day, meals, exercise intensity, and individual factors
* Provides concrete, prognosis-based dosing recommendations (e.g., "Reduce basal by 1 IU for evening runs to prevent delayed hypos")

**Example Output:**
Analysis of the last 4 weeks:
✓ ISF varies: Morning 1:35, Evening 1:45 (with 10% safety margin)
✓ ICR for pizza (fat/protein mix): 1:10 → Recommend 1:8, bolus 50% now + 50% in 2h (to match delayed absorption, minimizing injections while covering the rise)
✓ Basal rate: 16 IU → 18 IU, but -20% pre-HIIT to counter sensitivity spike
✓ Nighttime hypos: Forecast shows 80% risk from residual IOB – adjust to 15 IU
✓ Post-meal corrections: During digestion, predict need for +2 IU total; suggest waiting 45 min for bundled dose instead of multiple small ones (reduces shots by 50%, same stabilization)

**Safety First:** All conceptual forecasts prioritize conservative estimates (e.g., overestimating carbs slightly to avoid hypos), with user overrides and clear confidence scores. But this is exploratory – **never base real decisions on untested ideas**.

---

## Who is it for?

### ✅ T1D-DOSIS (as a Study) is for you if you:

* Use **pens or syringes** for treatment (MDI)
* Use CGM (e.g., Freestyle Libre via Juggluco)
* Want to explore data-driven therapy optimization conceptually
* Are willing to try new software (beta-tester mindset)
* Take personal responsibility for your therapy
* Are experienced developers/researchers seeking inspiration

### ❌ T1D-DOSIS is ABSOLUTELY NOT for:

* **Pump users** → Use AndroidAPS/Loop/OpenAPS (better options!)
* People without CGM
* Those expecting certified, ready-to-use solutions
* **Beginners or anyone without advanced T1D management expertise** (ISF, IOB, etc.) – this could be life-threatening if misinterpreted
* Unprepared individuals hoping for a "quick fix" – this is a study, not a product

### 🤔 Why Not Pump + Closed-Loop?

**Closed-loop with a pump is objectively better**, but not feasible or desirable for everyone:

* 💰 Cost / no insurance coverage
* 👕 Lifestyle (no visible devices on the body)
* 🏊 Sports (swimming, contact sports)
* 🧠 Preference for conscious manual control

→ This study explores making MDI as intelligent as possible – purely as a thought experiment and inspiration.

---

## Architecture

### Component 1: Conceptual Android App (Kotlin)

**Envisioned Real-Time Features:**

* Receives glucose broadcasts from Juggluco (or xDrip+) as the primary real-time input source
* **IOB calculation**: Initially sourced from Juggluco for baseline estimates; later refined by fitting individualized curves from accumulated historical data (via backend integration) – inspired by xDrip+ algorithms, but customized for personal patterns
* **ML-based hypo prediction** (beyond standard alarms): Uses all known and estimable parameters (e.g., current fall rate, residual IOB, ISF drifts, meal absorption, recent activity) to forecast future trajectories and suggest the optimal intervention – e.g., if BG is falling, preemptively recommend timely carb intake (15g KH) to avoid dipping below 70 mg/dL, minimizing risks like rebounds
* Displays recommendations from the desktop backend
* Stores history locally (Room Database) for ongoing data accumulation

This conceptual design aims to compute the best future prognosis for the most targeted treatment (insulin correction vs. carb intervention), but remains untested – for inspiration only.

### Why a Separate App?

T1D-DOSIS is **NOT** a competitor to xDrip+ but a conceptual complement:

**What xDrip+ excels at (adopted in T1D-DOSIS):**

* ✅ IOB calculation (proven algorithms)
* ✅ CGM data processing
* ✅ Extensive sensor support

**What T1D-DOSIS conceptually adds:**

* 🆕 ML-based hypo prediction (15-30 min forecast, extensible to hours)
* 🆕 Desktop backend for long-term optimization
* 🆕 Adaptive ISF/ICR calculation from weeks/months of data
* 🆕 Concrete dosing recommendations

**Alternative Architecture (under consideration):**

* T1D-DOSIS as an xDrip+ plugin/extension instead of a standalone app
* To be evaluated in early development

### Component 2: Conceptual Desktop Backend (Julia)

**Envisioned Long-Term Analysis:**

* Reads historical data via mesh sync
* Machine learning for pattern recognition
* Optimization of therapy factors
* Generates dosing recommendations

**Why Julia?**

* Ideal for scientific computations
* Fast for complex optimizations
* Elegant syntax for pharmacokinetic models

### Component 3: Virtual Mesh Networking (Tailscale)

**Data Flow:** Android (Juggluco Webserver) <---> Tailscale Tunnel (Port 17580) <---> Desktop Julia (Analysis)

To ensure seamless communication between phone and desktop backend – especially in restrictive environments like camping site WLANs or public hotspots – T1D-DOSIS uses **Tailscale**.

* **Firewall Bypass:** Tailscale creates an encrypted point-to-point network that bypasses "Client Isolation" and port blocking in public WLANs.
* **MagicDNS:** The Desktop Backend addresses the phone via a fixed name (e.g., http://handy:17580), independent of the current IP address or network type (WLAN/5G).
* **Security:** Transmission of sensitive health data is end-to-end encrypted within the private mesh network.
* **No Cloud Latency:** Direct P2P connection replaces the slower Google Drive sync.

---

## Development Status

**Current: Early Conceptual Feasibility Study (as of October 2025)**

This is not a software project in active development – it's a personal exploration to assess viability. Code snippets and ideas are shared for inspiration only.

### ✅ Completed:

* Concept and architecture defined
* Technology stack finalized
* Algorithms researched
* Documentation created
* GitHub repository set up (with basic sketches)

### 🚧 In Progress (Q4 2025):

* Android: Juggluco broadcast receiver
* Android: Room Database schema
* Android: IOB calculation
* Tailscale Setup & Connectivity Tests
* Julia: Data parser for JSON over HTTP

### 📋 Planned (Q1-Q2 2026):

* Intelligent hypo prediction (ML model)
* ISF/ICR optimization from historical data
* Android UI for alarms and recommendations
* Extensive testing with simulation data

### 🎯 Long-Term:

* Cautious self-testing with personal data
* Documentation for technically savvy community
* Iterative improvements based on feedback

**Realistic Timeline:** First functional version in 6-12 months – but treat as aspirational; this remains a study.

---

## Technical Details

### IOB Calculation

**Basis: xDrip+ Algorithm**

* xDrip+ has excellent, battle-tested IOB calculation
* T1D-DOSIS uses the same algorithms (open-source GPL-3)
* No need to reinvent the wheel for proven components

**Extensions for T1D-DOSIS:**

* Integration with ISF optimization (adaptive factors)
* Linking to hypo prediction (ML-based)
* Long-term IOB pattern analysis in the Julia backend

### ISF Optimization

**Multi-Factorial:**

* Time of day (circadian rhythm)
* Weekday (work vs. weekend)
* Activity level
* Hormonal cycles, stress, illness

**Machine Learning Approach:**

* Time-series analysis over weeks/months
* Pattern and anomaly detection
* Adaptive factor adjustments

### Hypo Prediction

**MDI-Specific:**

* **Layered Approach**: Start with traditional metrics (ISF, IOB, current BG) for baseline calculations – e.g., rough multi-hour projections like "tight spot in 2 hours" based on fall rate and residual insulin pull.
* **Advanced Refinements**: Incorporate drifts in insulin sensitivity (e.g., circadian variations or long-term trends from data) to fine-tune estimates, reducing uncertainty in amplitude and timing.
* **AI-Enhanced Methods**: Leverage machine learning (e.g., time-series models in Julia) for the best possible forecasts – integrating meal absorption, exercise effects, and personal patterns to enable the sparsest (minimal intervention), most targeted (precise dosing), and fastest (preemptive) responses.
* Extended horizons (15 min to hours), conservative thresholds (no pump safety net), and reduced false alarms via these layers.

### Glossar (https://www.google.com/search?q=GLOSSAR.md)

* [Glossar zu Begriffen, Abkürzungen und Formeln im T1D-Management](https://www.google.com/search?q=GLOSSAR.md): Detailliertes Glossar mit Erklärungen zu Schlüsselbegriffen wie BG, IOB, ISF, EGP und mehr, inklusive Formeln und Beispielen. Nützlich für tieferes Verständnis der technischen Details.

---

## Positioning in the DIY Ecosystem

| System | Hardware | Target Group | Status | Automation Level |
| --- | --- | --- | --- | --- |
| **AndroidAPS** | Insulin Pump | Pump Users | Established, Active | Closed-Loop |
| **Loop** | Insulin Pump | iOS/Pump Users | Established, Active | Closed-Loop |
| **OpenAPS** | Insulin Pump | Pump Users | Established, Active | Closed-Loop |
| **xDrip+** | CGM | All | Established, Widespread | Display + Basic Alarms |
| **Juggluco** | CGM (Libre) | Libre Users | Established, Maintained | CGM + Standard Alarms |
| **T1D-DOSIS** | Pen/MDI | MDI Users | **Conceptual Study** | Intelligent Assistance (Exploratory) |

**Complementary, Not Competitive:**

* Pump users → AndroidAPS/Loop (clearly superior!)
* MDI users → T1D-DOSIS (fills a gap conceptually – but unproven)

---

## Technology Stack

**Connectivity:**

* **Tailscale:** WireGuard®-based Mesh-VPN for secure device coupling.
* **MagicDNS:** Stable name resolution for the Juggluco data source.

**Android App:**

* Kotlin + Jetpack Compose
* Room Database (local storage)
* Broadcast Receiver (Juggluco integration)
* AlarmManager (intelligent alerts)

**Desktop Backend:**

* Julia 1.9+
* using DataFrames (data processing)
* using Flux, MLJ (machine learning)
* using DifferentialEquations (pharmacokinetics)

**IPC Protocol (JSON via Tailscale):**

REQUEST (Julia → Android via HTTP):
GET http://handy:17580/x/json

RESPONSE (Android → Julia):
{
"glucose_data": [...],
"insulin_injections": [...],
"meals": [...],
"current_factors": { "isf": 40, "icr": 10 }
}

---

## For Developers & Researchers

### Contributing to the Project

**We're Looking For:**

* 👨‍💻 **Kotlin/Android Developers** (broadcast handling, Room DB, UI)
* 📊 **Julia/ML Experts** (time-series analysis, optimization, pharmacokinetic models)
* 🩺 **Medical Feedback** (endocrinologists, experienced T1Ds for algorithm validation)
* 🔬 **Scientists** (study design, statistical validation)
* 🧪 **Beta Testers** (No coding required! Just: T1D experience + willingness to test – but only in controlled, conceptual phases)

**For Contributors:**

* GitHub Issues for technical discussions
* Code reviews and PRs welcome
* Feedback on algorithms and implementation
* Tips on scientific literature

**For Beta Testers (later):**

* Install the built app (no coding needed)
* Feedback on usability and accuracy
* Report bugs or implausible recommendations
* Patience with experimental software
* **Mandatory: Deep T1D knowledge and medical oversight – no beginners**

### Academic Use

**This project is suitable for:**

* Bachelor's/Master's theses (ML in diabetes therapy)
* Research projects (MDI optimization)
* Algorithmic studies (hypo prediction)
* Comparative studies (MDI vs. closed-loop)

### Commercial Development

**Interest from Institutions?**

* Medical device manufacturers
* Research institutions
* University clinics

→ Contact via GitHub (once available)

---

## Related Projects & Scientific Foundation

### Inspired by / Compatible with:

**Juggluco** - CGM data from Freestyle Libre

* Website: https://www.juggluco.nl/Juggluco/index.html
* GitHub: https://github.com/j-kaltes/Juggluco
* T1D-DOSIS receives broadcasts from Juggluco

**GlucoDataHandler (GDH)** - Broadcast handling

* Author: pachi81 | License: MIT
* GitHub: https://github.com/pachi81/GlucoDataHandler
* Inspiration for Android architecture

**GluPredKit** - Glucose Prediction Framework

* GitHub: https://www.google.com/search?q=https://github.com/replicahealth/GluPredKit
* Evaluation framework for different prediction models.

**UVAPadovaAPI** - Simulation

* GitHub: https://www.google.com/search?q=https://github.com/NeuroDiab/UVAPadovaAPI
* Implementation of the Simglucose / UVA-Padova simulator.

**GluCoEnv** - Reinforcement Learning

* GitHub: https://github.com/RL4H/GluCoEnv
* RL environments for diabetes therapy optimization.

**xDrip+** - CGM app with IOB calculation

* License: GPL-3
* GitHub: https://github.com/NightscoutFoundation/xDrip
* **Excellent IOB calculation** (adopted in T1D-DOSIS)

### Scientific Research (Foundations & Models)

* **Basal-Bolus Optimization**: *Self-Learning Algorithms for T1D* ([SSRN: 4401684](https://doi.org/10.2139/ssrn.4401684)).
* **Predictive Models**: Using Deep Learning and LSTM for BG forecasting ([JMIR: 34699](https://doi.org/10.2196/34699)).
* **MDI Logic**: Strategies for improving MDI outcomes without pumps ([JCEM: dgac034](https://doi.org/10.1210/clinem/dgac034)).
* **ML Accuracy**: Evaluating machine learning performance in CGM-based systems ([Diagnostics: 14070740](https://doi.org/10.3390/diagnostics14070740) & [TBME: 3187703](https://doi.org/10.1109/TBME.2022.3187703)).
* **Pharmacokinetics**: Models for insulin absorption and action ([Diabetology: 00969-9](https://doi.org/10.1186/s13098-022-00969-9)).

---

## License

**GNU General Public License v3 (GPL-3)**

**Rationale:**

* Life-critical algorithms must be transparent
* Community improvements benefit everyone
* No proprietary "black box" system

**Implications:**

* ✅ Free to use, modify, distribute
* ✅ Modifications must also be GPL-3
* ✅ Source code remains available
* ❌ No proprietary commercial use

---

## Disclaimer & Important Notes

### Status: Personal DIY Feasibility Study

T1D-DOSIS is a **Do-It-Yourself (DIY) feasibility study** by and for people with T1D – a personal exploration to test ideas, not a deployable tool:

* ❌ Not a certified medical device (CE/FDA)
* ❌ No clinical studies conducted
* ❌ Not validated by medical professionals
* ❌ No professional support
* ❌ **Potentially life-threatening if any ideas are applied without expert validation** – this is conceptual inspiration only

**Similar to:** OpenAPS, AndroidAPS, Loop – established DIY systems that work and are used worldwide, but never medically certified. However, T1D-DOSIS is far earlier: a study to spark ideas, not to build upon directly.

### Personal Responsibility

**You are responsible for:**

* Deciding to build/use this system
* Understanding and validating all algorithms
* All therapeutic decisions
* Collaborating with your diabetes care team
* Recognizing that even conceptual errors could lead to harm if misinterpreted

**T1D-DOSIS provides recommendations; YOU make decisions.** But as a study, even those are unproven – treat as hypotheses.

### Liability Disclaimer

The author assumes **no liability** for:

* Software or algorithm errors
* Incorrect dosing recommendations
* Medical complications
* Any damages
* **Misuse of ideas leading to life-threatening situations**

**Use at your own risk – and only if you fully grasp the dangers.**

### Medical Note

T1D-DOSIS is **not a substitute** for:

* Professional medical advice
* Regular endocrinologist visits
* Emergency protocols for hypo/hyper
* Common sense

**For medical questions:** Always consult your doctor. Do not experiment based on this study without their guidance.

### Certification & Regulatory Approval

**Reality:** T1D-DOSIS will likely **never** receive regulatory approval.

**Why?**

* Approval takes years and costs millions
* DIY projects can't afford this effort
* Similar systems (OpenAPS, AndroidAPS, Loop) are also uncertified

**But:** These systems work for experienced users – at their own risk. T1D-DOSIS is not there yet; it's a study to inspire safer paths.

---

## Implementation Plan

To rapidly reach a halfway usable system (MVP) focused on IOB/ISF for syringe users with Compression Low handling, follow this 4-week plan. It starts with data collection (your Step 1) and builds a rule-based Bolus-Advisor, testable on Juggluco TSV and OhioT1DM MD-subset (syringe-only data). Use Julia for desktop analysis and a simple Android app for real-time input. Goal: By Week 4, a tool that suggests Bolus, tracks IOB, and filters Lows (~85–90% accuracy, RMSE <1.0 mmol/L).

### Week 1: Connectivity & Data Setup (Tailscale)

* **1.1: Connectivity via Tailscale**
Install Tailscale on Handy and Laptop. Verify access to Juggluco web interface via `http://handy:17580`. This is critical for bypassing firewall restrictions (e.g., Camping WLAN).
* **1.2: Download Juggluco Data**
Export 7–14 days TSV (glucose_mmol, timestamp, roc) via the Tailscale tunnel (`curl http://handy:17580/x/json`). Note manual Bolus (U, Carbs g, Timing) via app notes or separate CSV. Save as `syringe_bolus_week1.tsv`.
* **1.3: Secure Study Data (Syringe-Focused)**
OhioT1DM MD-subset (manual injections): Kaggle ([kaggle.com/datasets/ryanmouton/ohiot1dm](https://www.google.com/search?q=https://kaggle.com/datasets/ryanmouton/ohiot1dm) – CSV with CGM/Bolus/Carbs, filter "MD"). AZT1D MD-subset: Mendeley ([data.mendeley.com/datasets/gk9m674wcx/1](https://www.google.com/search?q=https://data.mendeley.com/datasets/gk9m674wcx/1) – CSV, select "manual_injection"). Local storage in `/data/syringe/`; test Julia import: `using CSV; df = CSV.read("ohio_md.csv", DataFrame)`.
* **Output**: 5–10 GB folder; Julia import script.
* **Time**: 2–3 hours; Metric: 100% data integrity.

### Week 2: Build Basemodel (IOB/ISF + Low Detection, Syringe-Only)

* **2.1: Implement IOB/ISF Logic (Julia)**
IOB: Bolus-only (IOB(t) = ∑ Bolus * e^{-t/4}). ISF = 100 / TDD (estimate from TSV Bolus sum/day). Advisor: (BG - Target) / ISF - IOB + Carbs / ICR.
Code Snippet (Julia):
using DataFrames, Dates
function spray_iob_isf_advisor(df::DataFrame, bolus_u::Float64, carbs_g::Float64, timing::DateTime, tdd::Float64=30.0)
isf = 100 / tdd / 18  # mmol/L
time_diff = Dates.value(now() - timing) / 3600
iob = bolus_u * exp(-time_diff / 4.0)
recent = df[end-3:end, :glucose_mmol]
if length(recent) >1 && (recent[end] - recent[end-1] < -1.1) && any(diff(recent) > 0.3)
println("Low detected – pause Bolus!")
return 0.0, 0.0
end
icr = 10.0
carb_bolus = carbs_g / icr
current_bg = df[end, :glucose_mmol]
target = 5.5
correction = (current_bg - target) / isf
total = max(0, carb_bolus + correction - iob)
return total, iob
end
* **2.2: Mobile Prototype (Android)**
UI: Input fields for Bolus/Carbs; Button → Calculation (local or JSON from Julia via Tailscale). Low filter from Juggluco stream.
* **Output**: Working script + app sketch; RMSE <1.0 on Ohio MD.
* **Time**: 8–12 hours; Metric: 80% accurate suggestions.

### Week 3: Tests & Adjustment (Real-Data Loop)

* Collect 1-week TSV with manual Bolus notes.
* Validate: Compare predictions vs. actual BG (e.g., 85% correct).
* Adjust ISF dynamically (day/night variation).
* **Output**: Calibrated prototype; app with alarms.
* **Time**: 6–10 hours; Metric: CEG >90% A+B.

### Week 4: MVP Finalization & Next Steps

* Automate: Julia cron for weekly ISF update from TSV.
* App: Build APK with IOB tracker ("Next Bolus in 2h recommended").
* Extension: Add Carbs photo recognition (Google ML Kit).
* **Output**: Deployable MVP; GitHub repo with code/data.
* **Time**: 5–8 hours; Metric: TIR >70% in simulations.

**Risks & Tips**: Start with OhioT1DM MD for quick tests (has Bolus data). Budget: 0€. For manual Bolus, use app notes or CSV – no pump needed.

---

## Roadmap

### Q4 2025

* [x] Finalize concept
* [x] Create documentation
* [x] Set up GitHub repository
* [x] Initial code commits (Android basics)
* [ ] Android: Juggluco broadcast receiver
* [ ] Android: Room Database schema
* [ ] Android: IOB calculation
* [ ] Tailscale Setup & Verification
* [ ] Julia: Data parser for JSON

### Q1-Q2 2026

* [ ] Intelligent hypo prediction (ML model)
* [ ] ISF/ICR optimization from historical data
* [ ] Android UI for alarms and recommendations
* [ ] Extensive testing with simulation data

### Q3-Q4 2026

* [ ] Extensive testing and validation
* [ ] Alpha version for self-testing

### 2027+

* [ ] Integrate community feedback
* [ ] Iterative improvements
* [ ] Documentation for DIY builders
* [ ] Possible scientific publication

**Disclaimer:** Timelines are estimates and subject to change. This is aspirational for a personal study.

---

## FAQ

**Q: When can I use T1D-DOSIS?**
A: You cannot – this is a feasibility study, not a product. First functional version likely mid-2026 for personal testing only, no guarantees.

**Q: Is this ready for me to use?**
A: Absolutely not. It's a conceptual exploration for inspiration. Implementing any part without deep expertise could be dangerous or fatal.

**Q: Is it safer than AndroidAPS?**
A: No. Closed-loop with a pump is superior. T1D-DOSIS is only a conceptual idea for MDI users.

**Q: Do I need programming skills?**
A: **As a user:** Irrelevant – do not use it. **As a contributor:** Yes, Kotlin and/or Julia.

**Q: How do I install T1D-DOSIS?**
A: Not available. Later: APK download + simple installation like any Android app – but only for validated testing.

**Q: Does it cost anything?**
A: No. Open source and free. But: You need an Android device, PC, and Google Drive.

**Q: How can I help?**
A: Yes! Especially needed: Kotlin/Julia developers, ML experts, medical feedback – to evolve this study safely.

**Q: Will it ever be certified?**
A: Highly unlikely. Like OpenAPS/AndroidAPS/Loop: DIY forever – but this starts as a study.

**Q: What if there are errors?**
A: **As a user:** Do not use it. **As a developer:** Help fix them. In both cases: Personal responsibility for all dosing decisions.

**Q: Is it complicated to use?**
A: Irrelevant for now. Goal is an intuitive app like Juggluco or xDrip+. Complexity stays in the backend.

---

## Contact

**GitHub:** [To be added once repository is online]
**Discussion:** GitHub Issues (for technical/algorithmic questions)
**Support:** None. DIY = Do It Yourself.

---

**Last Update:** October 2025
**Status:** Conceptual Feasibility Study (Early Phase)
**License:** GPL-3
**Author:** Personal DIY Explorationherapy. It aims to inspire fellow developers, researchers, and experienced T1D individuals to explore similar ideas. It is **NOT** a ready-to-use system and should never be implemented or relied upon without extensive personal validation, professional medical oversight, and rigorous testing. Misuse could be potentially life-threatening. Proceed only if you have deep expertise in T1D management and software development.*

---

## Inhaltsverzeichnis

- [What is T1D-DOSIS?](#what-is-t1d-dosis)
  - [The Problem](#the-problem)
  - [The Solution: Conceptual Components](#the-solution-conceptual-components)
- [Who is it for?](#who-is-it-for)
  - [Why Not Pump + Closed-Loop?](#why-not-pump--closed-loop)
- [Architecture](#architecture)
  - [Component 1: Conceptual Android App (Kotlin)](#component-1-conceptual-android-app-kotlin)
  - [Why a Separate App?](#why-a-separate-app)
  - [Component 2: Conceptual Desktop Backend (Julia)](#component-2-conceptual-desktop-backend-julia)
  - [Component 3: Conceptual Cloud Sync (Google Drive API)](#component-3-conceptual-cloud-sync-google-drive-api)
- [Development Status](#development-status)
- [Technical Details](#technical-details)
  - [IOB Calculation](#iob-calculation)
  - [ISF Optimization](#isf-optimization)
  - [Hypo Prediction](#hypo-prediction)
  - [Glossar (GLOSSAR.md)](GLOSSAR.md)
- [Positioning in the DIY Ecosystem](#positioning-in-the-diy-ecosystem)
- [Technology Stack](#technology-stack)
- [For Developers & Researchers](#for-developers--researchers)
  - [Contributing to the Project](#contributing-to-the-project)
  - [Academic Use](#academic-use)
  - [Commercial Development](#commercial-development)
- [Related Projects](#related-projects)
- [License](#license)
- [Disclaimer & Important Notes](#disclaimer--important-notes)
  - [Status: Personal DIY Feasibility Study](#status-personal-diy-feasibility-study)
  - [Personal Responsibility](#personal-responsibility)
  - [Liability Disclaimer](#liability-disclaimer)
  - [Medical Note](#medical-note)
  - [Certification & Regulatory Approval](#certification--regulatory-approval)
- [Implementation Plan](#implementation-plan)
- [Roadmap](#roadmap)
- [FAQ](#faq)
- [Contact](#contact)

---

## What is T1D-DOSIS?

T1D-DOSIS is a **DIY conceptual project** to explore insulin therapy optimization for **Multiple Daily Injections (MDI)** – ideal for people using pens or syringes. As a personal feasibility study, it investigates how data-driven tools could enhance MDI for those not using pumps, but it remains in early ideation and is shared primarily as inspiration for the community.

### The Problem

With MDI (pens or syringes) and CGM, the trend direction (rising or falling BG) is usually clear – but predicting *how far it goes* and handling external factors like meals or exercise is the real nightmare:

- **Amplitude uncertainty**: Will that -2 mg/dL/min drop bottom out at 80 mg/dL or crash to 50? Even with IOB and ISF knowledge, you only get a rough estimate of the pull – not enough for spot-on dosing without risks.
- **Meal mysteries**: You never know the exact insulin-required components – not just digestible carbs, but also protein and fat, which contribute delayed, partial insulin needs (e.g., gluconeogenesis from protein, slowed absorption from fat). Variable timing (fatty meals delay peaks by hours, stress alters it) turns ICR calculations into guesswork, causing sneaky post-meal spikes or crashes. Even when digestion is underway and more insulin is surely needed, the dilemma persists: Inject small doses immediately (risking too many shots and potential over-correction) or wait to bundle into fewer injections for similar results (but risking prolonged highs)?
- **Exercise unpredictability**: Depending on type (e.g., HIIT vs. steady cardio) and intensity, it can dramatically swing BG – instant drops from heightened insulin sensitivity, delayed hypos hours later, or even spikes from stress hormones. Adjusting doses pre/post-workout is a blind guess without pattern data.
- **Dosing guesswork**: Rising? Inject correction insulin – but how many units to avoid rebound? Falling? Swallow glucose tabs/KH – but 15g or 10g to not overshoot? It's all approximations, leading to over/under-corrections and instability.
- **Late alarms**: Standard alerts (e.g., at 70 mg/dL) still hit too late; you're scrambling to react, not prevent.
- **No closed-loop for pens**: Systems like AndroidAPS/Loop need a pump – leaving MDI users without predictive smarts.
- **Manual tweaks**: Therapy factors (ISF, ICR, basal) demand constant, imprecise fiddling from logs.

Every trend, every bite, every workout becomes a high-stakes gamble. This study explores how layered forecasts could sharpen those edges – but remember, it's conceptual only.

### The Solution: Conceptual Components

This feasibility study envisions two components to estimate insulin and carb needs as safely as possible, using layered forecasts – from traditional metrics to AI-driven predictions – for the leanest, most targeted interventions. These are high-level ideas, not implemented code.

**📱 Conceptual Android App: Intelligent Hypo Early Warning**  
Standard alarm: "70 mg/dL reached" → Too late!

Envisioned T1D-DOSIS: "95 mg/dL, but:  
            - 2.5 IU IOB active  
            - Fall rate: -3 mg/dL/min  
            - Your ISF: 1:40 (adjusted for recent drift)  
            - Current BG trajectory  
            → Hypo risk building over next 1-2 hours (AI-refined for precision)  
            → Eat 15g carbs now – minimal dose for quick stabilization"

**💻 Conceptual Desktop Backend: Long-Term Optimization**  
- Analyzes weeks/months of your data for patterns (e.g., sport-induced drops, protein/fat delays)  
- Calculates optimal ISF, ICR, basal rates with safety buffers  
- Accounts for time of day, meals, exercise intensity, and individual factors  
- Provides concrete, prognosis-based dosing recommendations (e.g., "Reduce basal by 1 IU for evening runs to prevent delayed hypos")  

**Example Output:**  
Analysis of the last 4 weeks:  
✓ ISF varies: Morning 1:35, Evening 1:45 (with 10% safety margin)  
✓ ICR for pizza (fat/protein mix): 1:10 → Recommend 1:8, bolus 50% now + 50% in 2h (to match delayed absorption, minimizing injections while covering the rise)  
✓ Basal rate: 16 IU → 18 IU, but -20% pre-HIIT to counter sensitivity spike  
✓ Nighttime hypos: Forecast shows 80% risk from residual IOB – adjust to 15 IU  
✓ Post-meal corrections: During digestion, predict need for +2 IU total; suggest waiting 45 min for bundled dose instead of multiple small ones (reduces shots by 50%, same stabilization)  

**Safety First:** All conceptual forecasts prioritize conservative estimates (e.g., overestimating carbs slightly to avoid hypos), with user overrides and clear confidence scores. But this is exploratory – **never base real decisions on untested ideas**.

---

## Who is it for?

### ✅ T1D-DOSIS (as a Study) is for you if you:
- Use **pens or syringes** for treatment (MDI)  
- Use CGM (e.g., Freestyle Libre via Juggluco)  
- Want to explore data-driven therapy optimization conceptually  
- Are willing to try new software (beta-tester mindset)  
- Take personal responsibility for your therapy  
- Are experienced developers/researchers seeking inspiration  

### ❌ T1D-DOSIS is ABSOLUTELY NOT for:
- **Pump users** → Use AndroidAPS/Loop/OpenAPS (better options!)  
- People without CGM  
- Those expecting certified, ready-to-use solutions  
- **Beginners or anyone without advanced T1D management expertise** (ISF, IOB, etc.) – this could be life-threatening if misinterpreted  
- Unprepared individuals hoping for a "quick fix" – this is a study, not a product  

### 🤔 Why Not Pump + Closed-Loop?

**Closed-loop with a pump is objectively better**, but not feasible or desirable for everyone:  
- 💰 Cost / no insurance coverage  
- 👕 Lifestyle (no visible devices on the body)  
- 🏊 Sports (swimming, contact sports)  
- 🧠 Preference for conscious manual control  

→ This study explores making MDI as intelligent as possible – purely as a thought experiment and inspiration.

---

## Architecture

### Component 1: Conceptual Android App (Kotlin)

**Envisioned Real-Time Features:**  
- Receives glucose broadcasts from Juggluco (or xDrip+) as the primary real-time input source  
- **IOB calculation**: Initially sourced from Juggluco for baseline estimates; later refined by fitting individualized curves from accumulated historical data (via backend integration) – inspired by xDrip+ algorithms, but customized for personal patterns  
- **ML-based hypo prediction** (beyond standard alarms): Uses all known and estimable parameters (e.g., current fall rate, residual IOB, ISF drifts, meal absorption, recent activity) to forecast future trajectories and suggest the optimal intervention – e.g., if BG is falling, preemptively recommend timely carb intake (15g KH) to avoid dipping below 70 mg/dL, minimizing risks like rebounds  
- Displays recommendations from the desktop backend  
- Stores history locally (Room Database) for ongoing data accumulation  

This conceptual design aims to compute the best future prognosis for the most targeted treatment (insulin correction vs. carb intervention), but remains untested – for inspiration only.

### Why a Separate App?

T1D-DOSIS is **NOT** a competitor to xDrip+ but a conceptual complement:  

**What xDrip+ excels at (adopted in T1D-DOSIS):**  
- ✅ IOB calculation (proven algorithms)  
- ✅ CGM data processing  
- ✅ Extensive sensor support  

**What T1D-DOSIS conceptually adds:**  
- 🆕 ML-based hypo prediction (15-30 min forecast, extensible to hours)  
- 🆕 Desktop backend for long-term optimization  
- 🆕 Adaptive ISF/ICR calculation from weeks/months of data  
- 🆕 Concrete dosing recommendations  

**Alternative Architecture (under consideration):**  
- T1D-DOSIS as an xDrip+ plugin/extension instead of a standalone app  
- To be evaluated in early development  

### Component 2: Conceptual Desktop Backend (Julia)

**Envisioned Long-Term Analysis:**  
- Reads historical data via cloud sync  
- Machine learning for pattern recognition  
- Optimization of therapy factors  
- Generates dosing recommendations  

**Why Julia?**  
- Ideal for scientific computations  
- Fast for complex optimizations  
- Elegant syntax for pharmacokinetic models  

### Component 3: Conceptual Cloud Sync (Google Drive API)

**Data Flow:**  
Android → Google Drive (REQUEST.json)  
            ↓  
         Desktop Julia (Analysis)  
            ↓  
Android ← Google Drive (RESPONSE.json)  

**Latency:** 5-60 minutes (sufficient for long-term optimization)

---

## Development Status

**Current: Early Conceptual Feasibility Study (as of October 2025)**  

This is not a software project in active development – it's a personal exploration to assess viability. Code snippets and ideas are shared for inspiration only.

### ✅ Completed:  
- Concept and architecture defined  
- Technology stack finalized  
- Algorithms researched  
- Documentation created  
- GitHub repository set up (with basic sketches)  

### 🚧 In Progress (Q4 2025):  
- Android: Juggluco broadcast receiver  
- Android: Room Database schema  
- Android: IOB calculation  
- Julia: Data parser for REQUEST.json  
- Google Drive API integration  

### 📋 Planned (Q1-Q2 2026):  
- Intelligent hypo prediction (ML model)  
- ISF/ICR optimization from historical data  
- Android UI for alarms and recommendations  
- Extensive testing with simulation data  

### 🎯 Long-Term:  
- Cautious self-testing with personal data  
- Documentation for technically savvy community  
- Iterative improvements based on feedback  

**Realistic Timeline:** First functional version in 6-12 months – but treat as aspirational; this remains a study.

---

## Technical Details

### IOB Calculation

**Basis: xDrip+ Algorithm**  
- xDrip+ has excellent, battle-tested IOB calculation  
- T1D-DOSIS uses the same algorithms (open-source GPL-3)  
- No need to reinvent the wheel for proven components  

**Extensions for T1D-DOSIS:**  
- Integration with ISF optimization (adaptive factors)  
- Linking to hypo prediction (ML-based)  
- Long-term IOB pattern analysis in the Julia backend  

### ISF Optimization

**Multi-Factorial:**  
- Time of day (circadian rhythm)  
- Weekday (work vs. weekend)  
- Activity level  
- Hormonal cycles, stress, illness  

**Machine Learning Approach:**  
- Time-series analysis over weeks/months  
- Pattern and anomaly detection  
- Adaptive factor adjustments  

### Hypo Prediction

**MDI-Specific:**  
- **Layered Approach**: Start with traditional metrics (ISF, IOB, current BG) for baseline calculations – e.g., rough multi-hour projections like "tight spot in 2 hours" based on fall rate and residual insulin pull.  
- **Advanced Refinements**: Incorporate drifts in insulin sensitivity (e.g., circadian variations or long-term trends from data) to fine-tune estimates, reducing uncertainty in amplitude and timing.  
- **AI-Enhanced Methods**: Leverage machine learning (e.g., time-series models in Julia) for the best possible forecasts – integrating meal absorption, exercise effects, and personal patterns to enable the sparsest (minimal intervention), most targeted (precise dosing), and fastest (preemptive) responses.  
- Extended horizons (15 min to hours), conservative thresholds (no pump safety net), and reduced false alarms via these layers.

### Glossar (GLOSSAR.md)

- [Glossar zu Begriffen, Abkürzungen und Formeln im T1D-Management](GLOSSAR.md): Detailliertes Glossar mit Erklärungen zu Schlüsselbegriffen wie BG, IOB, ISF, EGP und mehr, inklusive Formeln und Beispielen. Nützlich für tieferes Verständnis der technischen Details.

---

## Positioning in the DIY Ecosystem

| System       | Hardware    | Target Group     | Status              | Automation Level     |
|--------------|-------------|------------------|---------------------|----------------------|
| **AndroidAPS** | Insulin Pump | Pump Users      | Established, Active | Closed-Loop         |
| **Loop**     | Insulin Pump | iOS/Pump Users  | Established, Active | Closed-Loop         |
| **OpenAPS**  | Insulin Pump | Pump Users      | Established, Active | Closed-Loop         |
| **xDrip+**   | CGM         | All             | Established, Widespread | Display + Basic Alarms |
| **Juggluco** | CGM (Libre) | Libre Users     | Established, Maintained | CGM + Standard Alarms |
| **T1D-DOSIS**| Pen/MDI     | MDI Users       | **Conceptual Study**| Intelligent Assistance (Exploratory) |

**Complementary, Not Competitive:**  
- Pump users → AndroidAPS/Loop (clearly superior!)  
- MDI users → T1D-DOSIS (fills a gap conceptually – but unproven)

---

## Technology Stack

**Android App:**  
- Kotlin + Jetpack Compose  
- Room Database (local storage)  
- Broadcast Receiver (Juggluco integration)  
- Google Drive API (cloud sync)  
- AlarmManager (intelligent alerts)  

**Desktop Backend:**  
- Julia 1.9+  
- using DataFrames (data processing)  
- using Flux, MLJ (machine learning)  
- using GoogleDrive (cloud sync)  
- using DifferentialEquations (pharmacokinetics)  

**IPC Protocol (JSON via Google Drive):**  

REQUEST.json (Android → Cloud):  
{  
  "glucose_data": [...],  
  "insulin_injections": [...],  
  "meals": [...],  
  "current_factors": {  
    "isf": 40, "icr": 10, "basal": 16  
  }  
}  

RESPONSE.json (Desktop → Cloud):  
{  
  "optimized_factors": {...},  
  "dosing_recommendations": [...],  
  "alarm_thresholds": {...}  
}  

---

## For Developers & Researchers

### Contributing to the Project

**We're Looking For:**  
- 👨‍💻 **Kotlin/Android Developers** (broadcast handling, Room DB, UI)  
- 📊 **Julia/ML Experts** (time-series analysis, optimization, pharmacokinetic models)  
- 🩺 **Medical Feedback** (endocrinologists, experienced T1Ds for algorithm validation)  
- 🔬 **Scientists** (study design, statistical validation)  
- 🧪 **Beta Testers** (No coding required! Just: T1D experience + willingness to test – but only in controlled, conceptual phases)  

**For Contributors:**  
- GitHub Issues for technical discussions  
- Code reviews and PRs welcome  
- Feedback on algorithms and implementation  
- Tips on scientific literature  

**For Beta Testers (later):**  
- Install the built app (no coding needed)  
- Feedback on usability and accuracy  
- Report bugs or implausible recommendations  
- Patience with experimental software  
- **Mandatory: Deep T1D knowledge and medical oversight – no beginners**

### Academic Use

**This project is suitable for:**  
- Bachelor's/Master's theses (ML in diabetes therapy)  
- Research projects (MDI optimization)  
- Algorithmic studies (hypo prediction)  
- Comparative studies (MDI vs. closed-loop)  

### Commercial Development

**Interest from Institutions?**  
- Medical device manufacturers  
- Research institutions  
- University clinics  

→ Contact via GitHub (once available)

---

## Related Projects

### Inspired by / Compatible with:

**Juggluco** - CGM data from Freestyle Libre  
- Website: https://www.juggluco.nl/Juggluco/index.html  
- GitHub: https://github.com/j-kaltes/Juggluco  
- T1D-DOSIS receives broadcasts from Juggluco  

**GlucoDataHandler (GDH)** - Broadcast handling  
- Author: pachi81 | License: MIT  
- GitHub: https://github.com/pachi81/GlucoDataHandler  
- Inspiration for Android architecture  

**OpenAPS** - Closed-loop systems  
- Established APS for pump users  
- License: GPL-3  
- GitHub: https://github.com/openaps/oref0  
- Complementary to T1D-DOSIS  

**AndroidAPS** - Closed-loop systems  
- Established APS for pump users  
- License: AGPL-3.0  
- GitHub: https://github.com/nightscout/AndroidAPS  
- Complementary to T1D-DOSIS  

**Loop** - Closed-loop systems  
- Established APS for pump users  
- License: MIT  
- GitHub: https://github.com/LoopKit/Loop  
- Complementary to T1D-DOSIS  

**xDrip+** - CGM app with IOB calculation  
- License: GPL-3  
- GitHub: https://github.com/NightscoutFoundation/xDrip  
- **Excellent IOB calculation** (adopted in T1D-DOSIS)  
- Alternative CGM data source (if no Juggluco)  
- Broadcast-compatible with T1D-DOSIS
---

## License

**GNU General Public License v3 (GPL-3)**  

**Rationale:**  
- Life-critical algorithms must be transparent  
- Community improvements benefit everyone  
- No proprietary "black box" system  

**Implications:**  
- ✅ Free to use, modify, distribute  
- ✅ Modifications must also be GPL-3  
- ✅ Source code remains available  
- ❌ No proprietary commercial use  

---

## Disclaimer & Important Notes

### Status: Personal DIY Feasibility Study

T1D-DOSIS is a **Do-It-Yourself (DIY) feasibility study** by and for people with T1D – a personal exploration to test ideas, not a deployable tool:  
- ❌ Not a certified medical device (CE/FDA)  
- ❌ No clinical studies conducted  
- ❌ Not validated by medical professionals  
- ❌ No professional support  
- ❌ **Potentially life-threatening if any ideas are applied without expert validation** – this is conceptual inspiration only  

**Similar to:** OpenAPS, AndroidAPS, Loop – established DIY systems that work and are used worldwide, but never medically certified. However, T1D-DOSIS is far earlier: a study to spark ideas, not to build upon directly.

### Personal Responsibility

**You are responsible for:**  
- Deciding to build/use this system  
- Understanding and validating all algorithms  
- All therapeutic decisions  
- Collaborating with your diabetes care team  
- Recognizing that even conceptual errors could lead to harm if misinterpreted  

**T1D-DOSIS provides recommendations; YOU make decisions.** But as a study, even those are unproven – treat as hypotheses.

### Liability Disclaimer

The author assumes **no liability** for:  
- Software or algorithm errors  
- Incorrect dosing recommendations  
- Medical complications  
- Any damages  
- **Misuse of ideas leading to life-threatening situations**  

**Use at your own risk – and only if you fully grasp the dangers.**

### Medical Note

T1D-DOSIS is **not a substitute** for:  
- Professional medical advice  
- Regular endocrinologist visits  
- Emergency protocols for hypo/hyper  
- Common sense  

**For medical questions:** Always consult your doctor. Do not experiment based on this study without their guidance.

### Certification & Regulatory Approval

**Reality:** T1D-DOSIS will likely **never** receive regulatory approval.  

**Why?**  
- Approval takes years and costs millions  
- DIY projects can't afford this effort  
- Similar systems (OpenAPS, AndroidAPS, Loop) are also uncertified  

**But:** These systems work for experienced users – at their own risk. T1D-DOSIS is not there yet; it's a study to inspire safer paths.

---

## Implementation Plan

To rapidly reach a halfway usable system (MVP) focused on IOB/ISF for syringe users with Compression Low handling, follow this 4-week plan. It starts with data collection (your Step 1) and builds a rule-based Bolus-Advisor, testable on Juggluco TSV and OhioT1DM MD-subset (syringe-only data). Use Julia for desktop analysis and a simple Android app for real-time input. Goal: By Week 4, a tool that suggests Bolus, tracks IOB, and filters Lows (~85–90% accuracy, RMSE <1.0 mmol/L).

### Week 1: Data Security & Setup (Download & Organization)
- **1.1: Download Juggluco Data**  
  Install Juggluco v9.7.7 (Play Store or APK from juggluco.nl). Export 7–14 days TSV (glucose_mmol, timestamp, roc); note manual Bolus (U, Carbs g, Timing) via app notes or separate CSV. Save as `syringe_bolus_week1.tsv`.  
- **1.2: Secure Study Data (Syringe-Focused)**  
  OhioT1DM MD-subset (manual injections): Kaggle (kaggle.com/datasets/ryanmouton/ohiot1dm – CSV with CGM/Bolus/Carbs, filter "MD"). AZT1D MD-subset: Mendeley (data.mendeley.com/datasets/gk9m674wcx/1 – CSV, select "manual_injection"). Local storage in `/data/syringe/`; test Julia import: `using CSV; df = CSV.read("ohio_md.csv", DataFrame)`.  
- **Output**: 5–10 GB folder; Julia import script.  
- **Time**: 2–3 hours; Metric: 100% data integrity.

### Week 2: Build Basemodel (IOB/ISF + Low Detection, Syringe-Only)
- **2.1: Implement IOB/ISF Logic (Julia)**  
  IOB: Bolus-only (IOB(t) = ∑ Bolus * e^{-t/4}). ISF = 100 / TDD (estimate from TSV Bolus sum/day). Advisor: (BG - Target) / ISF - IOB + Carbs / ICR.  
  Code Snippet (Julia):  
  using DataFrames, Dates  
  function spray_iob_isf_advisor(df::DataFrame, bolus_u::Float64, carbs_g::Float64, timing::DateTime, tdd::Float64=30.0)  
      isf = 100 / tdd / 18  # mmol/L  
      time_diff = Dates.value(now() - timing) / 3600  
      iob = bolus_u * exp(-time_diff / 4.0)  
      recent = df[end-3:end, :glucose_mmol]  
      if length(recent) >1 && (recent[end] - recent[end-1] < -1.1) && any(diff(recent) > 0.3)  
          println("Low detected – pause Bolus!")  
          return 0.0, 0.0  
      end  
      icr = 10.0  
      carb_bolus = carbs_g / icr  
      current_bg = df[end, :glucose_mmol]  
      target = 5.5  
      correction = (current_bg - target) / isf  
      total = max(0, carb_bolus + correction - iob)  
      return total, iob  
  end  
- **2.2: Mobile Prototype (Android)**  
  UI: Input fields for Bolus/Carbs; Button → Calculation (local or JSON from Julia). Low filter from Juggluco stream.  
- **Output**: Working script + app sketch; RMSE <1.0 on Ohio MD.  
- **Time**: 8–12 hours; Metric: 80% accurate suggestions.

### Week 3: Tests & Adjustment (Real-Data Loop)
- Collect 1-week TSV with manual Bolus notes.  
- Validate: Compare predictions vs. actual BG (e.g., 85% correct).  
- Adjust ISF dynamically (day/night variation).  
- **Output**: Calibrated prototype; app with alarms.  
- **Time**: 6–10 hours; Metric: CEG >90% A+B.

### Week 4: MVP Finalization & Next Steps
- Automate: Julia cron for weekly ISF update from TSV.  
- App: Build APK with IOB tracker ("Next Bolus in 2h recommended").  
- Extension: Add Carbs photo recognition (Google ML Kit).  
- **Output**: Deployable MVP; GitHub repo with code/data.  
- **Time**: 5–8 hours; Metric: TIR >70% in simulations.

**Risks & Tips**: Start with OhioT1DM MD for quick tests (has Bolus data). Budget: 0€. For manual Bolus, use app notes or CSV – no pump needed.

---

## Roadmap

### Q4 2025  
- [x] Finalize concept  
- [x] Create documentation  
- [x] Set up GitHub repository  
- [x] Initial code commits (Android basics)  
- [ ] Android: Juggluco broadcast receiver  
- [ ] Android: Room Database schema  
- [ ] Android: IOB calculation  
- [ ] Julia: Data parser for REQUEST.json  
- [ ] Google Drive API integration  

### Q1-Q2 2026  
- [ ] Intelligent hypo prediction (ML model)  
- [ ] ISF/ICR optimization from historical data  
- [ ] Android UI for alarms and recommendations  
- [ ] Extensive testing with simulation data  

### Q3-Q4 2026  
- [ ] Extensive testing and validation  
- [ ] Alpha version for self-testing  

### 2027+  
- [ ] Integrate community feedback  
- [ ] Iterative improvements  
- [ ] Documentation for DIY builders  
- [ ] Possible scientific publication  

**Disclaimer:** Timelines are estimates and subject to change. This is aspirational for a personal study.

---

## FAQ

**Q: When can I use T1D-DOSIS?**  
A: You cannot – this is a feasibility study, not a product. First functional version likely mid-2026 for personal testing only, no guarantees.  

**Q: Is this ready for me to use?**  
A: Absolutely not. It's a conceptual exploration for inspiration. Implementing any part without deep expertise could be dangerous or fatal.  

**Q: Is it safer than AndroidAPS?**  
A: No. Closed-loop with a pump is superior. T1D-DOSIS is only a conceptual idea for MDI users.  

**Q: Do I need programming skills?**  
A: **As a user:** Irrelevant – do not use it. **As a contributor:** Yes, Kotlin and/or Julia.  

**Q: How do I install T1D-DOSIS?**  
A: Not available. Later: APK download + simple installation like any Android app – but only for validated testing.  

**Q: Does it cost anything?**  
A: No. Open source and free. But: You need an Android device, PC, and Google Drive.  

**Q: How can I help?**  
A: Yes! Especially needed: Kotlin/Julia developers, ML experts, medical feedback – to evolve this study safely.  

**Q: Will it ever be certified?**  
A: Highly unlikely. Like OpenAPS/AndroidAPS/Loop: DIY forever – but this starts as a study.  

**Q: What if there are errors?**  
A: **As a user:** Do not use it. **As a developer:** Help fix them. In both cases: Personal responsibility for all dosing decisions.  

**Q: Is it complicated to use?**  
A: Irrelevant for now. Goal is an intuitive app like Juggluco or xDrip+. Complexity stays in the backend.  

---

## Contact

**GitHub:** [To be added once repository is online]  
**Discussion:** GitHub Issues (for technical/algorithmic questions)  
**Support:** None. DIY = Do It Yourself.  

---

**Last Update:** October 2025  
**Status:** Conceptual Feasibility Study (Early Phase)  
**License:** GPL-3  
**Author:** Personal DIY Exploration
