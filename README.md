# T1D-DOSIS: Computer-Aided Insulin Injection

**AI-Supported Optimization of Therapeutic Factors for Type 1 Diabetics**

## 1. Project Overview

T1D-DOSIS is a lean, modular system designed to calculate and optimize personalized therapeutic factors (Insulin Sensitivity Factor, Carbohydrate Factor) from historical glucose and activity data.

The project is divided into two main components:

| Component | Language/Technology | Task | 
 | ----- | ----- | ----- | 
| **Client/Data Acquisition** | Kotlin (Android) | Receives glucose broadcasts (e.g., from Juggluco), stores data (Room DB), and manages IPC (Inter-Process Communication) with the backend. | 
| **Analysis/Optimization** | Julia (Backend) | Performs complex time series analysis, Machine Learning, and optimization of therapeutic factors. Operates in isolation via file protocols. | 

## 2. Development Status

### Phase 1: Data Acquisition and IPC (Android/Kotlin)

* **1.1 Glucose Receiver:** ✅ Implemented (`GlucoseReceiver.kt`)

* **1.2 Data Persistence (Room):** ✅ Entities and DAOs defined.

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

T1D-DOSIS positions itself as a **Semi-Automatic Control System with Counter-Regulation** that optimizes the efficiency of therapeutic factors without controlling insulin delivery in real-time.

### 5.1 Distinction from Fully Automatic Closed-Loop Systems (DIY-APS)

T1D-DOSIS complements the ecosystem of **Do-It-Yourself Artificial Pancreas Systems (DIY-APS)**, whose core function is minute-by-minute dosage control.

| System | Focus and License | GitHub / Primary Source | 
 | ----- | ----- | ----- | 
| **OpenAPS** | Active, continuous insulin dose control. (GPLv3) | <https://openaps.org/> | 
| **AndroidAPS** | Active, continuous control via Android devices. (GPLv3) | [https://github.com/androidaps/androidaps](https://www.google.com/search?q=https://github.com/androidaps/androidaps) | 
| **Loop** | Active, continuous control via iOS/Watch devices. (MIT License) | <https://loopandlearn.org/> | 

### 5.2 The Role of T1D-DOSIS (Intelligent Calibration)

T1D-DOSIS serves as an **upstream optimization stage** for these systems or for manual dosing strategies:

1. **Goal of APS:** Short-term glucose control, based on the ISF and CarbFactor values *set by the user*.

2. **Goal of T1D-DOSIS:** The optimization and updating of the **underlying constants** (ISF, CarbFactor), ensuring that the *basis* for control is more precise.

**Synergy:** T1D-DOSIS improves the accuracy of the factors that form the basis for any dosing calculation or APS system. The optimized ISF or CarbFactor value calculated by the Julia backend could, for example, be adopted by the user in AndroidAPS or Loop once a week.
