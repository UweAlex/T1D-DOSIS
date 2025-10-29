# T1D-DOSIS: Intelligente Therapie-Optimierung für MDI

**Open-Source System für Pen-Nutzer mit CGM**

---

## Was ist T1D-DOSIS?

T1D-DOSIS ist ein **DIY-Projekt** zur Optimierung der Insulintherapie bei **Multiple Daily Injections (MDI)** – also für Menschen, die mit Pen oder Spritze behandelt werden.

### Das Problem

Wenn du mit Pen spritzt und CGM nutzt, siehst du zwar deine Glukosewerte in Echtzeit, aber:
- Standard-Alarme warnen oft zu spät (erst bei 70 mg/dl)
- Closed-Loop-Systeme (AndroidAPS/Loop) funktionieren nur mit Pumpe
- Therapie-Faktoren (ISF, ICR) musst du manuell optimieren

### Die Lösung: Zwei Komponenten

**📱 Android-App: Intelligente Hypo-Frühwarnung**
Standard-Alarm: "70 mg/dl erreicht" → Zu spät!

T1D-DOSIS: "95 mg/dl, aber:
            - 2.5 IE IOB aktiv
            - Fallrate: -3 mg/dl/min  
            - Deine ISF: 1:40
            → Hypo in ~15 Min wahrscheinlich
            → Jetzt 15g KH essen"

**💻 Desktop-Backend: Langfristige Optimierung**
- Analysiert Wochen/Monate deiner Daten
- Berechnet optimale ISF, ICR, Basalraten
- Berücksichtigt Tageszeit, Muster, individuelle Faktoren
- Gibt konkrete Dosierungsempfehlungen

**Beispiel-Output:**
Analyse der letzten 4 Wochen:
✓ ISF variiert: Morgens 1:35, Abends 1:45
✓ ICR bei Pizza: 1:10 → 1:8 empfohlen
✓ Basalrate: 16 IE → 18 IE
✓ Nächtliche Hypos: Basal -1 IE

---

## Für wen?

### ✅ T1D-DOSIS ist für dich, wenn du:
- Mit **Pen oder Spritze** behandelt wirst (MDI)
- CGM nutzt (z.B. Freestyle Libre via Juggluco)
- Deine Therapie datenbasiert optimieren willst
- Bereit bist, neue Software auszuprobieren (Beta-Tester-Mentalität)
- Eigenverantwortung für deine Therapie übernimmst

### ❌ T1D-DOSIS ist NICHT für:
- **Pumpen-Nutzer** → Nutze AndroidAPS/Loop/OpenAPS (bessere Optionen!)
- Menschen ohne CGM
- Personen die fertige, zertifizierte Lösungen erwarten
- Menschen ohne Grundverständnis von T1D-Management (ISF, IOB, etc.)

### 🤔 Warum nicht Pumpe + Closed-Loop?

**Closed-Loop mit Pumpe ist objektiv besser**, aber nicht für jeden möglich/gewünscht:
- 💰 Kosten / keine Kassenübernahme
- 👕 Lifestyle (keine sichtbaren Geräte am Körper)
- 🏊 Sport (Schwimmen, Kontaktsport)
- 🧠 Präferenz für bewusste manuelle Kontrolle

→ **T1D-DOSIS macht MDI so intelligent wie möglich**

---

## Architektur

### Komponente 1: Android-App (Kotlin)

**Echtzeit-Funktionen:**
- Empfängt Glukose-Broadcasts von Juggluco (oder xDrip+)
- **IOB-Berechnung** (nutzt bewährte xDrip+ Algorithmen)
- **ML-basierte Hypo-Prädiktion** (geht über Standard-Alarme hinaus)
- Zeigt Empfehlungen vom Desktop-Backend
- Speichert Historie lokal (Room Database)

### Warum eine eigene App?

T1D-DOSIS ist **NICHT** xDrip+ Konkurrenz, sondern ergänzt es:

**Was xDrip+ exzellent macht (wird übernommen):**
- ✅ IOB-Berechnung (bewährte Algorithmen)
- ✅ CGM-Datenverarbeitung
- ✅ Umfangreiche Sensor-Unterstützung

**Was T1D-DOSIS hinzufügt:**
- 🆕 ML-basierte Hypo-Prädiktion (15-30 Min Vorhersage)
- 🆕 Desktop-Backend für Langzeit-Optimierung
- 🆕 Adaptive ISF/ICR-Berechnung aus Wochen/Monaten Daten
- 🆕 Konkrete Dosierungsempfehlungen

**Alternative Architektur denkbar:**
- T1D-DOSIS als xDrip+ Plugin/Erweiterung statt standalone App
- Wird in früher Entwicklungsphase evaluiert

### Komponente 2: Desktop-Backend (Julia)

**Langfristige Analyse:**
- Liest historische Daten via Cloud-Sync
- Machine Learning zur Mustererkennung
- Optimierung therapeutischer Faktoren
- Generiert Dosierungsempfehlungen

**Warum Julia?**
- Perfekt für wissenschaftliche Berechnungen
- Schnell für komplexe Optimierungen
- Elegante Syntax für pharmakokinetische Modelle

### Komponente 3: Cloud-Sync (Google Drive API)

**Datenfluss:**
Android → Google Drive (REQUEST.json)
            ↓
         Desktop Julia (Analyse)
            ↓
Android ← Google Drive (RESPONSE.json)

**Latenz:** 5-60 Minuten (vollkommen ausreichend für Langzeit-Optimierung)

---

## Entwicklungsstatus

**Aktuell: Frühe Entwicklungsphase (Stand Oktober 2025)**

### ✅ Abgeschlossen:
- Konzept und Architektur definiert
- Technologie-Stack festgelegt
- Algorithmen recherchiert
- Dokumentation erstellt
- GitHub Repository eingerichtet
- Erste Code-Commits (Android Basics)

### 🚧 In Arbeit (Q4 2025):
- Android: Juggluco Broadcast-Empfänger
- Android: Room Database Schema
- Android: IOB-Berechnung
- Julia: Datenparser für REQUEST.json
- Google Drive API Integration

### 📋 Geplant (Q1-Q2 2026):
- Intelligente Hypo-Prädiktion (ML-Modell)
- ISF/ICR-Optimierung aus historischen Daten
- Android UI für Alarme und Empfehlungen
- Umfangreiches Testing mit Simulationsdaten

### 🎯 Langfristig:
- Vorsichtige Selbsttests mit eigenen Daten
- Dokumentation für technisch versierte Community
- Iterative Verbesserung basierend auf Feedback

**Realistisch:** Erste funktionsfähige Version in 6-12 Monaten denkbar.

---

## Technische Details

### IOB-Berechnung

**Grundlage: xDrip+ Algorithmus**
- xDrip+ hat eine hervorragende, erprobte IOB-Berechnung
- T1D-DOSIS nutzt die gleichen Algorithmen (Open-Source GPL-3)
- Kein "Rad neu erfinden" bei bewährten Komponenten

**Erweiterungen für T1D-DOSIS:**
- Integration mit ISF-Optimierung (adaptive Faktoren)
- Verknüpfung mit Hypo-Prädiktion (ML-basiert)
- Langfristige IOB-Muster-Analyse im Julia-Backend

### ISF-Optimierung

**Multi-faktoriell:**
- Tageszeit (zirkadianer Rhythmus)
- Wochentag (Arbeit vs. Wochenende)
- Aktivitätslevel
- Hormonzyklen, Stress, Krankheit

**Machine Learning Ansatz:**
- Zeitreihen-Analyse über Wochen/Monate
- Erkennung von Mustern und Anomalien
- Adaptive Anpassung der Faktoren

### Hypo-Prädiktion

**Spezifisch für MDI:**
- Längere Vorhersage-Horizonte (15-30 Min)
- Konservative Schwellwerte (kein Sicherheitsnetz wie bei Pumpe)
- Berücksichtigung von Mahlzeiten-Absorption
- Reduktion von Fehlalarmen durch ML

---

## Einordnung im DIY-Ökosystem

| System | Hardware | Zielgruppe | Status | Automatisierung |
|--------|----------|------------|--------|-----------------|
| **AndroidAPS** | Insulinpumpe | Pumpen-Nutzer | Etabliert, aktiv | Closed-Loop |
| **Loop** | Insulinpumpe | iOS/Pumpe | Etabliert, aktiv | Closed-Loop |
| **OpenAPS** | Insulinpumpe | Pumpen-Nutzer | Etabliert, aktiv | Closed-Loop |
| **xDrip+** | CGM | Alle | Etabliert, weit verbreitet | Anzeige + Basis-Alarme |
| **Juggluco** | CGM (Libre) | Libre-Nutzer | Etabliert, maintained | CGM + Standard-Alarme |
| **T1D-DOSIS** | Pen/MDI | MDI-Nutzer | **In Entwicklung** | Intelligente Assistenz |

**Komplementär, nicht konkurrierend:**
- Pumpen-Nutzer → AndroidAPS/Loop (deutlich besser!)
- MDI-Nutzer → T1D-DOSIS (füllt Lücke)

---

## Technologie-Stack

**Android-App:**
- Kotlin + Jetpack Compose
- Room Database (lokale Speicherung)
- Broadcast Receiver (Juggluco Integration)
- Google Drive API (Cloud-Sync)
- AlarmManager (intelligente Warnungen)

**Desktop-Backend:**
- Julia 1.9+
- using DataFrames (Datenverarbeitung)
- using Flux, MLJ (Machine Learning)
- using GoogleDrive (Cloud-Sync)
- using DifferentialEquations (Pharmakokinetik)

**IPC-Protokoll (JSON via Google Drive):**

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

## Für Entwickler & Forschende

### Mitarbeit am Projekt

**Gesucht werden:**
- 👨‍💻 **Kotlin/Android Entwickler** (Broadcast-Handling, Room DB, UI)
- 📊 **Julia/ML Experten** (Zeitreihen-Analyse, Optimierung, pharmakokinetische Modelle)
- 🩺 **Medizinisches Feedback** (Diabetologen, erfahrene T1Ds zur Algorithmen-Validierung)
- 🔬 **Wissenschaftler** (Studiendesign, statistische Validierung)
- 🧪 **Beta-Tester** (Keine Programmierkenntnisse nötig! Nur: Erfahrung mit T1D + Bereitschaft zu testen)

**Für Mitentwickler:**
- GitHub Issues für technische Diskussionen
- Code-Reviews und PRs willkommen
- Feedback zu Algorithmen und Implementierung
- Hinweise auf wissenschaftliche Literatur

**Für Beta-Tester (später):**
- Installation der fertigen App (kein Coding nötig)
- Feedback zu Usability und Genauigkeit
- Meldung von Bugs oder unplausiblen Empfehlungen
- Geduld mit experimenteller Software

### Akademische Nutzung

**Dieses Projekt eignet sich für:**
- Bachelor/Master-Arbeiten (ML in Diabetestherapie)
- Forschungsprojekte (MDI-Optimierung)
- Algorithmische Studien (Hypo-Prädiktion)
- Vergleichsstudien (MDI vs. Closed-Loop)

### Kommerzielle Weiterentwicklung

**Interesse von Institutionen?**
- Medizinprodukte-Hersteller
- Forschungseinrichtungen
- Universitätskliniken

→ Kontakt über GitHub (sobald verfügbar)

---

## Verwandte Projekte

### Inspiriert von / Kompatibel mit:

**Juggluco** - CGM-Daten von Freestyle Libre
- Website: https://www.juggluco.nl/Juggluco/index.html
- T1D-DOSIS empfängt Broadcasts von Juggluco

**GlucoDataHandler (GDH)** - Broadcast-Handling
- Autor: pachi81 | Lizenz: MIT
- Inspiration für Android-Architektur

**OpenAPS / AndroidAPS / Loop** - Closed-Loop Systeme
- Etablierte APS für Pumpen-Nutzer
- Lizenzen: GPL-3 / AGPL / MIT
- Komplementär zu T1D-DOSIS

**xDrip+** - CGM-App mit IOB-Berechnung
- Lizenz: GPL-3
- **Hervorragende IOB-Berechnung** (wird in T1D-DOSIS übernommen)
- Alternative CGM-Datenquelle (falls kein Juggluco)
- Broadcast-kompatibel mit T1D-DOSIS

---

## Lizenz

**GNU General Public License v3 (GPL-3)**

**Begründung:**
- Lebenskritische Algorithmen müssen transparent sein
- Community-Verbesserungen kommen allen zugute
- Kein proprietäres "Black Box" System

**Bedeutet:**
- ✅ Frei nutzbar, modifizierbar, verteilbar
- ✅ Modifikationen müssen ebenfalls GPL-3 sein
- ✅ Quellcode bleibt verfügbar
- ❌ Keine proprietäre kommerzielle Nutzung

---

## Disclaimer & Wichtige Hinweise

### Status: DIY-Projekt in Entwicklung

T1D-DOSIS ist ein **Do-It-Yourself (DIY) Projekt** von T1D-Betroffenen für T1D-Betroffene:
- ❌ Kein zertifiziertes Medizinprodukt (CE/FDA)
- ❌ Keine klinischen Studien durchgeführt
- ❌ Nicht von medizinischen Fachkräften validiert
- ❌ Kein professioneller Support

**Ähnlich wie:** OpenAPS, AndroidAPS, Loop – etablierte DIY-Systeme, die funktionieren und genutzt werden, aber nie medizinisch zertifiziert wurden oder werden.

### Eigenverantwortung

**Du bist selbst verantwortlich für:**
- Die Entscheidung, dieses System zu bauen/nutzen
- Das Verständnis aller Algorithmen und deren Validierung
- Alle therapeutischen Entscheidungen
- Die Zusammenarbeit mit deinem Diabetesteam

**T1D-DOSIS gibt Empfehlungen, DU triffst Entscheidungen.**

### Haftungsausschluss

Der Autor übernimmt **keine Haftung** für:
- Fehler in Software oder Algorithmen
- Falsche Dosierungsempfehlungen
- Medizinische Komplikationen
- Schäden jeglicher Art

**Nutzung erfolgt auf eigenes Risiko.**

### Medizinischer Hinweis

T1D-DOSIS ist **kein Ersatz** für:
- Professionelle medizinische Beratung
- Regelmäßige Diabetologen-Termine
- Notfall-Protokolle bei Hyper/Hypo
- Gesunden Menschenverstand

**Bei medizinischen Fragen:** Konsultiere immer deinen Arzt.

### Zertifizierung & Regulatorische Zulassung

**Realität:** T1D-DOSIS wird höchstwahrscheinlich **nie** regulatorisch zugelassen werden.

**Warum?**
- Zulassung dauert Jahre und kostet Millionen
- DIY-Projekte können diesen Aufwand nicht leisten
- Ähnliche Systeme (OpenAPS, AndroidAPS, Loop) sind auch nicht zertifiziert

**Aber:** Diese Systeme funktionieren, werden weltweit genutzt, und haben vielen Menschen geholfen – auf eigene Verantwortung.

**T1D-DOSIS folgt diesem Modell.**

---

## Roadmap

### Q4 2025
- [x] Konzept finalisieren
- [x] Dokumentation erstellen
- [x] GitHub Repository einrichten
- [x] Erste Code-Commits (Android Basics)
- [ ] Android: Juggluco Broadcast-Empfänger
- [ ] Android: Room Database Schema
- [ ] Android: IOB-Berechnung
- [ ] Julia: Datenparser für REQUEST.json
- [ ] Google Drive API Integration

### Q1-Q2 2026
- [ ] Intelligente Hypo-Prädiktion (ML-Modell)
- [ ] ISF/ICR-Optimierung aus historischen Daten
- [ ] Android UI für Alarme und Empfehlungen
- [ ] Erste Tests mit Simulationsdaten

### Q3-Q4 2026
- [ ] Umfangreiche Tests und Validierung
- [ ] Alpha-Version für Selbsttest

### 2027+
- [ ] Community-Feedback integrieren
- [ ] Iterative Verbesserungen
- [ ] Dokumentation für DIY-Builder
- [ ] Mögliche Publikation (wissenschaftlich)

**Disclaimer:** Zeitpläne sind Schätzungen und können sich ändern.

---

## FAQ

**Q: Wann kann ich T1D-DOSIS nutzen?**  
A: Erste funktionsfähige Version vermutlich Mitte 2026. Aber: Selbsttest, keine Garantien.

**Q: Ist das sicherer als AndroidAPS?**  
A: Nein. Closed-Loop mit Pumpe ist überlegen. T1D-DOSIS ist nur für MDI-Nutzer sinnvoll.

**Q: Brauche ich Programmierkenntnisse?**  
A: **Als Nutzer:** Nein, nur Verständnis von T1D-Management. **Als Entwickler/Mitarbeiter:** Ja, Kotlin und/oder Julia.

**Q: Wie installiere ich T1D-DOSIS?**  
A: Noch nicht verfügbar. Später: APK-Download + einfache Installation wie bei jeder Android-App.

**Q: Kostet es etwas?**  
A: Nein. Open Source und kostenlos. Aber: Du brauchst Android-Gerät, PC, Google Drive.

**Q: Kann ich helfen?**  
A: Ja! Besonders gesucht: Kotlin/Julia-Entwickler, ML-Experten, medizinisches Feedback.

**Q: Wird das jemals zertifiziert?**  
A: Sehr unwahrscheinlich. Wie OpenAPS/AndroidAPS/Loop: DIY für immer.

**Q: Was wenn es Fehler hat?**  
A: Als **Nutzer** meldest du Bugs und prüfst Empfehlungen kritisch. Als **Entwickler** hilfst du beim Fixen. In beiden Fällen: Eigenverantwortung bei allen Dosierungsentscheidungen.

**Q: Ist das kompliziert zu bedienen?**  
A: Nein. Ziel ist eine intuitive App wie Juggluco oder xDrip+. Komplexität bleibt im Backend.

---

## Kontakt

**GitHub:** [Wird ergänzt sobald Repository online]  
**Diskussion:** GitHub Issues (für technische/algorithmische Fragen)  
**Support:** Keiner. DIY = Do It Yourself.

---

**Letzte Aktualisierung:** Oktober 2025  
**Status:** In Entwicklung (frühe Phase)  
**Lizenz:** GPL-3  
**Autor:** Persönliches DIY-Projekt
