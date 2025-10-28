# T1D-DOSIS (Type 1 Diabetes - Decision Optimization Support and Information System)

## Table of Contents

* [Overview](#overview)
* [I. Vision and Objectives](#i-vision-and-objectives)
* [II. Methodology and Architecture](#ii-methodology-and-architecture)
  * [II.I Data Protocol (Cloud Communication)](#ii.i-data-protocol-cloud-communication)
  * [II.II UX Principles and Transparency](#ii.ii-ux-principles-and-transparency)
* [III. Phases and Roadmap](#iii-phases-and-roadmap)
  * [Key Tasks in Phase 3 (App Core Logic)](#key-tasks-in-phase-3-app-core-logic)
* [IV. Technical Components (Kotlin / Julia)](#iv-technical-components-kotlin--julia)
* [V. Legal Strategy and Disclaimer (Highest Warning Level)](#v-legal-strategy-and-disclaimer-highest-warning-level)
* [VI. License](#vi-license)

***

## Overview

**T1D-DOSIS** is an open-source project aimed at developing a **Computer-Aided Decision Support System (DSS)**, whose ultimate goal is to significantly enhance the quality of life and safety for individuals with T1D. **This is an open-source prototype intended primarily for private development and as an auditable source of inspiration for future certified medical devices.** The app **reads live glucose data from Juggluco, performs intelligent analysis of historical values, and generates improved safety warnings in the event of a significant deviation.**

The app is primarily designed as a **secondary safety check** ("Second Opinion") to validate human dosing decisions and detect potential errors based on data-driven patterns.

## I. Vision and Objectives

The central vision of T1D-DOSIS is to significantly improve the **quality of life** and safety of individuals with T1D through enhanced control.

| **Metric** | **Goal** | **Rationale** | 
 | ----- | ----- | ----- | 
| **Safety** | Reduce Hypo-Risk by 50% | Especially crucial at night. | 
| **Quality of Life** | Increase sleep without wake-up calls to >90% of nights | The most important qualitative goal. | 
| **Frequency** | Reduce manual factor corrections by users by 70% | Maximum transparency and automated alignment. | 
| **Integration** | Handover and integration of core logic into xDrip+/Juggluco | Maximum reach and manpower for the ultimate goal. | 

## II. Methodology and Architecture

The system follows a strict separation between data acquisition (Android/Kotlin) and analysis (Cloud/Julia).

### II.I Data Protocol (Cloud Communication)

An **asynchronous, stateless protocol** is used for data transmission, ensuring maximum data protection:

* **REQUEST.json:** Contains encrypted, time-series-based raw data. Sent only upon request.

* **RESPONSE.json:** Contains exclusively the **new calculated factors** (ICR, ISF, Targets) and an explanatory message.

* **Integrity:** Every transmission is secured by a **SHA256 hash** of the payload to detect manipulation or data loss.

### II.II UX Principles and Transparency

1. **Background Transparency (UX):** The process of data acquisition, export, and factor updating runs **completely invisibly and automatically** in the background. The user is not interrupted by pop-ups or manual actions. The IOB display in the foreground service is the only constant feedback.

2. **Explainable Transparency (XAI):** The **time-series analysis** is not a black box. The AI (Julia backend) must clearly and traceably justify the **derivation of the new factors** (e.g., "ISF increased by 5% because the nocturnal drop rate was too strong in the trend") in the `RESPONSE.json`.

## III. Phases and Roadmap

The project is divided into 5 main phases:

| **Phase** | **Goal** | **Status** | 
 | ----- | ----- | ----- | 
| **Phase 1** | Data Acquisition and IOB Detection (Kotlin/Android) | **IMPLEMENTED** | 
| **Phase 2** | AI Analysis Backend (Julia) and Factor Optimization | PENDING | 
| **Phase 3** | App Core Logic (Factor Update, UI) | PENDING | 
| **Phase 4** | Beta Testing, Debugging, Audit Preparation | PENDING | 
| **Phase 5** | Strategic Handover for Community Integration | PENDING | 

### Key Tasks in Phase 3 (App Core Logic)

* **Task 3.2: Safety Check ("Check Mode")**

  * Implementation of a function that checks the **user's planned dose** against the AI-optimized dose.

  * **Central Safety Mechanism:** In case of a **significant deviation** between the dose planned by the user and the dose suggested by **T1D-DOSIS**, the app **must** actively advise the user to **review their decision again**.

## IV. Technical Components (Kotlin / Julia)

| **Component** | **Language** | **Purpose** | 
 | ----- | ----- | ----- | 
| **Client** | Kotlin/Android | Live data reception (Juggluco BroadcastReceiver), Local DB (Room), IOB Service, Data Export. | 
| **Backend** | Julia | Protocol Parser, Time-Series Analysis, AI/Optimization Algorithm, Factor Recalculation. | 

## V. Legal Strategy and Disclaimer (Highest Warning Level)

This section is the most important part of the entire project.

* **Danger to Life:** Since the system intervenes in therapy and faulty decisions are **life-threatening and potentially fatal**, this is the most critical section.

* **Complete Personal Responsibility:** The user bears full and unrestricted responsibility for every decision made based on the app's calculations.

* **Discouragement of Therapy Use:** Users are explicitly **discouraged** from using the app for direct therapy decision-making. **T1D-DOSIS** is a prototype and not a medical device.

* **Licensing Strategy:** The choice of the **GNU General Public License (GPLv3)** prevents third parties from using the code for commercial, proprietary applications without reciprocity or a separate licensing agreement.

* **Auditability:** The entire project serves as a **transparent, auditable prototype development (Proof-of-Concept)**. The GPLv3 license supports this goal by ensuring public review.

## VI. License

This project is licensed under the **GNU General Public License, Version 3 (GPLv3)**. This ensures the source code remains open and transparent and prevents proprietary appropriation of the system. The license terms (including the comprehensive disclaimer) are fully detailed in the [`LICENSE`](LICENSE) file and must be retained in all copies or substantial portions of the software.

*(This document was last updated on 2025-10-28)*
