# T1D-DOSIS: Computer-Aided Insulin Injection

**AI-Supported Optimization of Therapeutic Factors for Type 1 Diabetics**

## 1. Project Overview

T1D-DOSIS is a lean, modular system designed to calculate and optimize personalized therapeutic factors (Insulin Sensitivity Factor – ISF, Carbohydrate Factor) from historical glucose and activity data. The goal: To noticeably improve the lives of people with Type 1 Diabetes (T1D) by making insulin injections more precise and the administration of glucose (e.g., for hypoglycemia) safer and more dosed. Through data-based predictions and adjustments, T1D-DOSIS reduces uncertainties in everyday life, minimizes complications, and promotes greater autonomy – without real-time dosing, but as a smart calibration aid.

The project is divided into two main components:

| Component | Language/Technology | Task | 
 | ----- | ----- | ----- | 
| **Client/Data Acquisition** | Kotlin (Android) | Receives glucose broadcasts (e.g., from Juggluco), stores data (Room DB), and manages IPC (Inter-Process Communication) with the backend. | 
| **Analysis/Optimization** | Julia (Backend) | Performs complex time series analysis, Machine Learning, and optimization of therapeutic factors. Operates in isolation via file protocols. | 

## 2. Development Status

### Phase 1: Data Acquisition and IPC (Android/Kotlin)

* **1.1 Glucose Receiver:** 🚧 Implementation pending (`GlucoseReceiver.kt`)

* **1.2 Data Persistence (Room):** 🚧 Entities and DAOs to be defined.

* **1.3 IPC Protocols:** 🚧 Implementation of the `REQUEST.json` / `RESPONSE.json` logic is pending.

### Phase 2: Core Analytics and Optimization (Julia)

* **2.1 Protocol Parser:** 🚧 Julia script for reading `REQUEST.json`.

* **2.2 Data Preparation:** 🚧 Feature Engineering (Glucose velocity, IOB estimation).

* **2.3 Optimization:** 🚧 Development of the Julia routine for ISF/ICR adjustment.

## 3. File Protocols (IPC)

Data exchange between the client and backend is performed via defined, file-based protocols.

| Protocol | Direction | Purpose | 
 | ----- | ----- | ----- | 
| `REQUEST.json` | Client → Julia | Contains historical glucose and event data for analysis. | 
| `RESPONSE.json` | Julia → Client | Contains the optimized factors (ISF, CarbFactor, etc.) calculated by the Julia backend. | 

---

## 4. References / License Notes

### 4.1 Primary Data Source: Juggluco

T1D-DOSIS relies on the ability to receive data directly from the **Juggluco** app, which provides readings from Freestyle Libre sensors via its Android Broadcasts.

* **Project Website:** <https://www.juggluco.nl/Juggluco/index.html>

* **Functionality:** The T1D-DOSIS Client app listens for the `luciad.com.juice.android.action.NEWVALUE` Intent sent by Juggluco to receive current glucose values in real-time.

### 4.2 T1D-DOSIS (This Project)

This project is licensed under the **GNU General Public License, Version 3 (GPLv3)**.

* **License Goal:** All modifications and extensions to the core logic must also be published under the GPLv3. This guarantees that the life-critical algorithms for insulin calculation remain open, verifiable, and auditable at all times.

### 4.3 GlucoDataHandler (GDH)

The design of the **Glucose Broadcast Receiver** was inspired by GlucoDataHandler (Author: pachi81), particularly regarding the handling of Juggluco broadcasts.

* **Project:** GlucoDataHandler (GDH)

* **Author:** T1D-DOSIS (Inspired by pachi81's design)

* **License:** **MIT License**

* **Disclaimer:** The source code of GDH itself is not part of this project but served only as a reference for inter-process communication in the Android environment. The entire analytics component in Julia is independently developed.

---

## 5. Positioning: Semi-Automatic Control System and Synergy

T1D-DOSIS positions itself as a **Semi-Automatic Control System with Counter-Regulation** that optimizes the efficiency of therapeutic factors without controlling insulin delivery in real-time. It improves the daily lives of T1D individuals by making insulin injections more precise (through adjusted ISF/CarbFactor) and hypo-management safer (e.g., via predictions for glucose dosing).

### 5.1 Distinction from Fully Automatic Closed-Loop Systems (DIY-APS)

T1D-DOSIS complements the ecosystem of **Do-It-Yourself Artificial Pancreas Systems (DIY-APS)**, whose core function is minute-by-minute dosage control.

| System | Focus and License | GitHub / Primary Source | 
 | ----- | ----- | ----- | 
| **OpenAPS** | Active, continuous insulin dose control. (GPLv3) | <https://openaps.org/> | 
| **AndroidAPS** | Active, continuous control via Android devices. (GPLv3) | <https://github.com/androidaps/androidaps> | 
| **Loop** | Active, continuous control via iOS/Watch devices. (MIT License) | <https://loopandlearn.org/> | 
| **Trio** | iOS-based AID system based on OpenAPS algorithm, strong in pediatrics and low-resource settings. (AGPLv3) | <https://github.com/nightscout/Trio> | 

### 5.2 The Role of T1D-DOSIS (Intelligent Calibration)

T1D-DOSIS serves as an **upstream optimization stage** for these systems or for manual dosing strategies:

1. **Goal of APS:** Short-term glucose control, based on the ISF and CarbFactor values *set by the user*.

2. **Goal of T1D-DOSIS:** The optimization and updating of the **underlying constants** (ISF, CarbFactor), ensuring that the *basis* for control is more precise. Additionally: Precise suggestions for insulin doses and glucose administrations to manage hypos more safely.

**Synergy:** T1D-DOSIS improves the accuracy of the factors that form the basis for any dosing calculation or APS system. The optimized ISF or CarbFactor value calculated by the Julia backend could, for example, be adopted by the user in AndroidAPS or Loop once a week.

### 5.3 Further Synergies in the Open-Source Ecosystem

T1D-DOSIS integrates seamlessly into the broader open-source ecosystem for T1D management. Here is an overview of additional relevant projects that provide data flows, visualization, or extensions and can be combined with T1D-DOSIS (e.g., for exporting/importing factors or as alternative data sources):

| Project | Focus and License | GitHub / Primary Source | Synergy with T1D-DOSIS |
|---------|-------------------|--------------------------|------------------------|
| **Nightscout** | Cloud-based CGM visualization and sharing tool. (AGPLv3) | <https://github.com/nightscout/cgm-remote-monitor> | Standard bridge for data export/import; enables weekly factor syncs with APS systems. |
| **xDrip+** | Android app for CGM data from various sensors (e.g., Libre, Dexcom). (GPLv3) | <https://github.com/Nightwing789/xDrip> | Backup data source to Juggluco; broadcast-compatible for robust input into the Room DB. |
| **Awesome-Diabetes-Software** | Curated list of diabetes tools and resources. (Variable) | <https://github.com/openaps/awesome-diabetes> | Discovery of further tools; ideal for ML tests in Julia (e.g., with Simglucose simulator). |

**Note:** This ecosystem is growing rapidly – check for updates regularly. T1D-DOSIS avoids dependencies but remains compatible to promote adoption.

## 6. Notes on Development and Usage

**Feasibility Study and Personal Use:**  
For legal reasons, it should be emphasized that T1D-DOSIS is currently to be understood as a feasibility study (Proof-of-Concept). The project was primarily developed for the personal use of the author and is not intended as a finished, certified medical product. It serves to explore concepts for optimizing therapeutic factors and is kept in an early development stage.  

**Call for Further Development:**  
Nevertheless, the project is open-source (GPLv3) and is intended to inspire competent developers, researchers, or T1D community members to continue or expand it. Contributions, feedback, and collaborations are welcome – let's create something lasting together! Feel free to open Issues or Pull Requests on GitHub.

**Disclaimer:** T1D-DOSIS is not a medical device and does not replace professional medical advice. Users are responsible for all dosing decisions. Always consult a healthcare professional.
