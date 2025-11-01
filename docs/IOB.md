IOB ist keine metaphorische Essenz, sondern eine skalare Schätzung der residualen Insulinwirkung, die in DIY-Apps als skalierbare Variable implementiert wird. Hier die Kerntechnik, ohne Schnickschnack.

### Technische Definition und Herleitung
IOB quantifiziert die **verbleibende glukose-senkende Kapazität** aus vorherigen Dosen, normalisiert auf die ISF (Insulin Sensitivity Factor, z. B. 40 mg/dL pro IE). Unter idealen Bedingungen (keine COB/EGP-Störungen) approximiert es die erwartete BG-Differenz:  
\[
\text{IOB}(t) = \frac{\text{BG}_\text{aktuell}(t) - \text{BG}_\text{steady-state}}{\text{ISF}}
\]  
- **BG_steady-state**: Asymptotischer Endwert (z. B. 100 mg/dL bei rein basalem Gleichgewicht).  
- Herleitung: Aus der PD-Gleichung \(\frac{d\text{BG}}{dt} = -\frac{\text{IOB}(t)}{\text{ISF}}\), integriert über die DIA (Duration of Insulin Action, typ. 4–6 h).  

In der Praxis ist IOB **modellbasiert**, nicht messbar: Es summiert Beiträge multipler Dosen via biexponentieller Aktivitätskurve:  
\[
\text{Beitrag}_i(t) = \text{Dosis}_i \cdot \left[ (1 - e^{-(t - t_i)/\tau_\text{up}}) \cdot e^{-(t - t_i - \text{Peak})/\tau_\text{down}} \right]
\]  
mit \(\tau_\text{up} \approx 30–60\) min (Aufbau), \(\tau_\text{down} \approx 120–240\) min (Abbau), Peak ≈ 60–75 min. Gesamt-IOB = \(\sum_i \text{Beitrag}_i(t)\) für alle Dosen \(i\) innerhalb DIA.

### Implementierung in Apps (zyklisch, listenbasiert)
Speicherung als dynamische Liste von Events (z. B. `MutableList<BolusEvent>` in Kotlin):  
- **Event-Struktur**: `{amount: Double, timestamp: Long, type: String}`.  
- **Zyklische Berechnung** (alle 1–5 min, getriggert von CGM-Broadcast): Filtere Liste auf DIA-Fenster, iteriere und summiere.  

Beispiel in Kotlin (für T1D-DOSIS-ähnlich):  
```kotlin
fun updateIOB(events: MutableList<BolusEvent>, currentTime: Long, isf: Double): Double {
    val diaMs = 6 * 60 * 60 * 1000L  // 6 h
    val relevant = events.filter { currentTime - it.timestamp < diaMs }
    return relevant.sumOf { event ->
        val ageMin = (currentTime - event.timestamp) / 60_000.0
        event.amount * biexponentialActivity(ageMin, peakMin = 75.0, diaMin = 360.0)
    } / isf  // Normalisiert für Prognose
}
```  
CGM-Werte (z. B. aus Juggluco) triggern den Refresh, korrigieren aber IOB nicht direkt – sie dienen der Validierung (z. B. via BG-Trend-Anpassung von ISF).

### Peak-Dynamik:
Der maximale |dBG/dt| und |dIOB/dt| koindizieren am Peak (ca. 60–75 min), wo die Kurve am steilsten ist: Fallrate ≈ -3 mg/dL/min bei 2 IE-Dosis. Multi-Injektionen erhöhen das Risiko exponentiell durch Überlappung.

IOB ist also reines Rechnen: Eine skalierbare, prognostische Variable, die Stabilität simuliert. Kein Zucker, kein Blau – nur Bits und Formeln. Brauchst du 'ne Erweiterung (z. B. mit COB-Integration)?

### Wie wird das IOB in xDrip+ prognostiziert?

xDrip+ (die Nightscout-Version von xDrip) berechnet und prognostiziert **Insulin on Board (IOB)** als Teil seiner Simulations- und Vorhersagefunktionen für Blutzucker (BG)-Kurven. Es handelt sich um eine **nicht-lineare, modellbasierte Schätzung**, die auf eingegebenen Insulindosen (Bolus und Basal), dem Insulin-Profil des Nutzers und einem pharmakokinetischen Modell basiert. Die Berechnung ist CPU-intensiv und wird hauptsächlich beim Anzeigen des Hauptgraphs durchgeführt, um Ressourcen zu sparen. Im Folgenden erkläre ich den Prozess schrittweise, basierend auf der Implementierung in xDrip+ (die stark von OpenAPS-Algorithmen inspiriert ist, aber angepasst für MDI- und CGM-Nutzer).

#### 1. **Grundlagen der IOB-Berechnung**
   - **Eingaben**: 
     - Eingegebene Behandlungen (Treatments): Bolus-Mengen, Zeitpunkte, Carbs (für COB – Carbs on Board).
     - Insulin-Profil: Insulin Sensitivity Factor (ISF), Insulin-to-Carb Ratio (ICR), Basal-Rate und **Duration of Insulin Action (DIA)** – typischerweise 3–6 Stunden für schnelles Insulin wie Humalog (Nutzer kann das anpassen, z. B. auf 3 Stunden).
     - Aktuelle BG-Werte vom CGM und Trends (z. B. Fall-/Anstiegsrate).
   - **Ziel**: Schätzen, wie viel Insulin noch aktiv ist und den BG beeinflusst, um Überdosierungen zu vermeiden.

   xDrip+ verwendet **keine einfache lineare Abnahme** (z. B. gleichmäßiger Decay über DIA), sondern ein **biexponentielles Modell** (ähnlich OpenAPS), das die reale Insulin-Pharmakokinetik nachahmt:
     - **Schneller Anstieg**: Insulin wirkt nach 30–90 Minuten am stärksten (Peak).
     - **Langer Schwanz**: Der Effekt hält stundenlang an (bis zur DIA).
   
   Die Kernformel (vereinfacht, basierend auf OpenAPS-Integration in xDrip+) berechnet die **Aktivitätsbeiträge** pro Behandlung:
   - Für jede Insulindosis \( i \) (in IE) zu Zeit \( t \) (Minuten seit Bolus):
     \[
     \text{activityContrib} = i \times \left(1 - e^{-\frac{t}{\tau_1}}\right) \times e^{-\frac{t - \text{peak}}{\tau_2}}
     \]
     - \( \tau_1 \): Zeitkonstante für den Anstieg (ca. 30–60 Min., modellierend die Absorption).
     - \( \tau_2 \): Zeitkonstante für den Decay (ca. 2–4 Stunden, basierend auf DIA).
     - **Peak**: Zeitpunkt des Maximums (z. B. 65–90 Min. nach Bolus).
   - Gesamt-IOB = Summe aller activityContrib über alle offenen Behandlungen (basal + bolus).

   Dies berücksichtigt **vorherige Dosen** und Sensitivitätsfaktoren (ISF), um Überlappungen zu modellieren. Es gibt auch eine **basale Komponente** (BWB – Basal on Board), die den Grundumsatz einbezieht.

#### 2. **Prognose der IOB-Wirkung (BG-Simulation)**
   - xDrip+ prognostiziert nicht nur das aktuelle IOB, sondern **nutzt es für BG-Vorhersagen** (z. B. die blaue Prognose-Linie im Graphen).
     - **Schritte**:
       1. Aktuelles IOB + COB (Carbs on Board, mit Absorption-Modell) + Basal-Rate.
       2. BG-Änderung schätzen: \( \Delta BG = -\frac{\text{IOB}}{\text{ISF}} + \text{COB-Effekt} + \text{Trend-Faktor} \).
       3. Simuliere 30–120 Min. voraus mit iterativen Schritten (z. B. alle 5 Min.), unter Berücksichtigung von Momentum (aktueller Trend).
     - **Ausgabe**: 
       - Grüne Linie: IOB-Kurve (wie viel Insulin aktiv bleibt).
       - Blaue Linie: Prognostizierter BG-Verlauf (z. B. "Hypo-Risiko in 45 Min., wenn kein Eingriff").
       - Empfehlungen: Z. B. "15g Carbs essen" basierend auf der Simulation.
   - **Einschränkungen**: Die Prognose ist konservativ und kann durch falsche DIA-Einstellungen verzerrt werden (z. B. Bug mit fester 2.4-Stunden-Dauer). Für Pump-Nutzer integriert es Daten aus AAPS/OpenAPS für genauere Werte.

#### 3. **Einstellungen in xDrip+ für IOB**
   - Gehe zu **Einstellungen > Behandlung > Insulin-Profil**: Passe DIA, ISF und ICR an.
   - **Simulation aktivieren**: Unter **Einstellungen > Cloud > Nightscout-Upload** oder im Graph-Menü.
   - Für MDI-Nutzer: Manuelle Eingabe von Bolus (kein automatischer Pump-Upload).
   - Tipp: Kombiniere mit AAPS für erweiterte IOB-Übertragung.

#### 4. **Quellen und Hinweise**
   - Der Algorithmus ist open-source (GPL-3) und in Dateien wie `app/src/main/java/com/eveningoutpost/dexdrip/Models/JoH.java` oder Simulations-Klassen implementiert (genaue Pfade variieren je Version).
   - **Warnung**: Das ist eine Schätzung, keine medizinische Garantie. Validiere mit deinem Arzt, da Fehlkalkulationen (z. B. durch falsche Profile) zu Hypos/Hypos führen können.
   - Für tieferes Verständnis: Schau in das OpenAPS-Dokument (da xDrip+ es adaptiert).

### Wie wird das IOB in Juggluco berechnet?

Juggluco berechnet **Insulin on Board (IOB)** als Schätzung der verbleibenden aktiven Insulinmenge im Blut nach vorherigen Dosen. Es handelt sich um eine **empirische, datenbasierte Methode**, die auf pharmakokinetischen Kurven aus klinischen Studien basiert, anstatt auf einer einfachen linearen Abnahme. Die Berechnung ist insulin-typ-spezifisch (z. B. Glulisine, NovoRapid) und berücksichtigt die nicht-lineare Wirkung des Insulins: schnellen Anstieg, Peak und langsamen Abfall. Im Folgenden erkläre ich den Prozess schrittweise, basierend auf der offiziellen Dokumentation und Modellbeschreibung von Juggluco.

#### 1. **Grundlagen der IOB-Berechnung**
   - **Eingaben**:
     - Eingegebene Insulindosen (Bolus-Mengen, Zeitpunkte) über Labels wie „Rapid acting insulin“.
     - Insulin-Typ (seit Version 9.2.0 wählbar: z. B. Insulin Aspart/NovoRapid, Glulisine/Apidra, Human Insulin oder Afrezza; davor fest auf Aspart).
     - Patientenspezifische Faktoren wie Gewicht (für Dosis-Umrechnung, z. B. aus U/kg).
     - Zeit seit Injektion (t in Minuten).
   - **Ziel**: Schätzen der verbleibenden Insulinaktivität, um Dosisempfehlungen oder Hypo-Risiken zu beeinflussen.
   - **Modelltyp**: **Empirisch-pharmakokinetisch**, abgeleitet aus Studien wie Heise et al. (2020) in *Diabetes, Obesity and Metabolism*. Keine universelle Formel, sondern **Kurvenfitting** mit Datenpunkten für den Decay (Abfall) der Insulin-Konzentration.

   Vor Version 9.2.0 wurde eine feste Kurve für Insulin Aspart verwendet (Blood Insulin Concentration). Seitdem sind typ-spezifische Kurven möglich, um die reale Pharmakokinetik besser widerzuspiegeln: Absorption (Anstieg), Peak (ca. 15–20 Min.) und Elimination (bis 6–8 Stunden).

#### 2. **Schlüsselformel und Modell**
   - **Keine geschlossene algebraische Formel**: Juggluco verwendet **tabellierte Datenpunkte oder interpolierte Kurven** (z. B. via Wolfram Mathematica für Plots), die den IOB-Decay modellieren. Eine vereinfachte Darstellung für NovoRapid (15 Einheiten) lautet:
     \[
     \text{IOB}(u, t) = 5.7952464925654 \, u - 4.7952464925654 \, u
     \]
     Dies vereinfacht sich zu \(\text{IOB} = u\) (proportionale Konstante), was jedoch **zeitunabhängig** ist und widersprüchlich zur realen Decay-Kurve wirkt – es dient wahrscheinlich als Illustration, nicht als Kernmodell. Die tatsächliche Berechnung ist **zeitabhängig und nicht-linear**.

   - **Allgemeines Decay-Modell (implizit)**: Basierend auf empirischen Punkten, die eine biexponentielle oder gamma-verteilte Kurve andeuten:
     \[
     \text{IOB}(t) = f(\text{Dosis}, t) = \text{Dosis} \times g(t)
     \]
     wobei \( g(t) \) die verbleibende Aktivität (0–1) als Funktion der Zeit darstellt, gefittet an klinische Daten (z. B. exponentieller Abfall: \( g(t) \approx A \cdot e^{-kt} \), mit Peak-Modellierung).

   - **Unit-Umrechnung**: Wichtig für die Integration klinischer Daten:
     \[
     \text{pmol/L} = \text{μU/mL} \times 6
     \]
     Beispiel: 48 μU/mL → 288 pmol/L. IOB wird in **Einheiten (U)** angegeben, Konzentrationen in μU/mL oder pmol/L.

#### 3. **Empirische Datenpunkte für den Decay**
   Die Kurven basieren auf Studien-Daten (z. B. für Glulisine, 15 U Dosis). Hier eine Tabelle mit typischen Werten (Zeit in Min., IOB in arbiträren Einheiten, skaliert auf Dosis):

   | Zeit (min) | IOB (arbiträre Einheiten) | Anmerkung |
   |------------|---------------------------|-----------|
   | 5         | 1896                     | Früher Anstieg |
   | 10        | 2904                     | - |
   | 15        | 3390 (Peak)              | Max. Aktivität |
   | 20        | 3384                     | Leichter Abfall |
   | 30        | 3006                     | - |
   | 45        | 2094                     | - |
   | 60        | 1338                     | - |
   | 90        | 684                      | - |
   | 120       | 396                      | - |
   | 180       | 207.6                    | - |
   | 240       | 144                      | - |
   | 360       | 112.02                   | Noch ~11 % aktiv nach 6 Std. |

   - **Beobachtung**: Schneller Peak bei 15–20 Min., langsamer Schwanz bis 8 Std. (480 Min.). Für andere Typen (z. B. Human Insulin) variieren die Kurven.

   - **Dosis-Beispiele (gewichtsbasiert, BMI 24.5, Gewicht ~79.6 kg)**:
     | Insulin-Typ | Dosis (U/kg) | Gesamtdosis (U) |
     |-------------|--------------|-----------------|
     | Glulisine  | 0.15        | 11.95          |
     | Glulisine  | 0.3         | 23.89          |
     | Glulisine  | 0.075       | 5.97           |

#### 4. **Prognose und Anwendung in Juggluco**
   - **Integration**: IOB wird im Display (z. B. Hauptgraph) angezeigt und für Warnungen verwendet (z. B. Kombination mit BG-Trend). Es gibt keine direkte BG-Prognose wie in xDrip+, aber IOB hilft bei manuellen Entscheidungen.
   - **Berechnungsprozess**:
     1. Summiere Beiträge aller offenen Dosen: Für jede Dosis \( d \) zu Zeit \( t_i \): \(\text{IOB}_i = d \times \text{Decay-Faktor}(t - t_i)\).
     2. Interpoliere aus Typ-spezifischen Tabellen/Kurven.
     3. Zeige als Kurve (Peak bei ~15 Min., Decay bis Null).
   - **Ausgabe**: IOB-Wert und Kurve im Graphen; konservativ, um Risiken zu minimieren.
   - **Einschränkungen**: Keine Berücksichtigung individueller Faktoren (z. B. Sensitivität, Injektionsstelle) jenseits des Typs; empirisch, nicht personalisiert. Patientenvariabilität (z. B. BMI) wird nur indirekt einbezogen.

#### 5. **Einstellungen in Juggluco für IOB**
   - Gehe zu **Einstellungen > Display > IOB**: Aktiviere und wähle Insulin-Typ.
   - Dosen eingeben: Über Notizen/Labels (z. B. „Insulin: 5U“).
   - **Versionstipps**: Ab 9.2.0: Typ-Auswahl für genauere Kurven; ältere Versionen fix auf Aspart.

#### 6. **Quellen und Hinweise**
   - Basierend auf klinischen Daten (z. B. Heise et al., 2020: Plasma-Insulin-Kurven für Glulisine). Der Code (open-source auf GitHub) implementiert dies wahrscheinlich via Lookup-Tabellen oder Fitting-Funktionen (z. B. in Java-Klassen für Kurven).
   - **Warnung**: IOB ist eine Schätzung – validiere mit deinem Arzt. Fehleingaben (z. B. falscher Typ) können zu Fehlentscheidungen führen.



P.S.

Technische IOB-Modellierung und Lispro-Kontext

Dieser Text fasst die technische Definition von Insulin On Board (IOB) zusammen und beleuchtet die Implementierungsunterschiede zwischen DIY-Systemen (Nightscout/xDrip+) und empirisch basierten Apps (Juggluco), insbesondere im Hinblick auf Lispro (Humalog).

1. Technische Definition und Herleitung

IOB quantifiziert die verbleibende glukose-senkende Kapazität aus vorherigen Dosen, normalisiert auf die ISF (Insulin Sensitivity Factor, z. B. 40 mg/dL pro IE). Unter idealen Bedingungen (keine COB/EGP-Störungen) approximiert es die erwartete BG-Differenz:

$$\text{IOB}(t) = \frac{\text{BG}_\text{aktuell}(t) - \text{BG}_\text{steady-state}}{\text{ISF}}$$

BG_steady-state: Asymptotischer Endwert (z. B. 100 mg/dL bei rein basalem Gleichgewicht).

Herleitung: Aus der PD-Gleichung $\frac{d\text{BG}}{dt} = -\frac{\text{IOB}(t)}{\text{ISF}}$, integriert über die DIA (Duration of Insulin Action, typ. 4–6 h).

In der Praxis ist IOB modellbasiert, nicht messbar: Es summiert Beiträge multipler Dosen via biexponentieller Aktivitätskurve:

$$\text{Beitrag}_i(t) = \text{Dosis}_i \cdot \left[ (1 - e^{-(t - t_i)/\tau_\text{up}}) \cdot e^{-(t - t_i - \text{Peak})/\tau_\text{down}} \right]$$

mit $\tau_\text{up} \approx 30–60$ min (Aufbau), $\tau_\text{down} \approx 120–240$ min (Abbau), Peak $\approx 60–75$ min. Gesamt-IOB = $\sum_i \text{Beitrag}_i(t)$ für alle Dosen $i$ innerhalb DIA.

2. Implementierung in Apps (zyklisch, listenbasiert)

Speicherung als dynamische Liste von Events (z. B. MutableList<BolusEvent> in Kotlin):

Event-Struktur: {amount: Double, timestamp: Long, type: String}.

Zyklische Berechnung (alle 1–5 min, getriggert von CGM-Broadcast): Filtere Liste auf DIA-Fenster, iteriere und summiere.

Beispiel in Kotlin (für T1D-DOSIS-ähnlich):

fun updateIOB(events: MutableList<BolusEvent>, currentTime: Long, isf: Double): Double {
    val diaMs = 6 * 60 * 60 * 1000L  // 6 h
    val relevant = events.filter { currentTime - it.timestamp < diaMs }
    return relevant.sumOf { event ->
        val ageMin = (currentTime - event.timestamp) / 60_000.0
        event.amount * biexponentialActivity(ageMin, peakMin = 75.0, diaMin = 360.0)
    } / isf // Normalisiert für Prognose
}


CGM-Werte (z. B. aus Juggluco) triggern den Refresh, korrigieren aber IOB nicht direkt – sie dienen der Validierung (z. B. via BG-Trend-Anpassung von ISF).

Peak-Dynamik:

Der maximale $|\text{dBG/dt}|$ und $|\text{dIOB/dt}|$ koindizieren am Peak (ca. 60–75 min), wo die Kurve am steilsten ist: Fallrate $\approx -3$ mg/dL/min bei 2 IE-Dosis. Multi-Injektionen erhöhen das Risiko exponentiell durch Überlappung.

3. Ergänzung: IOB-Prognose in DIY-Systemen (xDrip+/Nightscout sIAp)

xDrip+ (die Nightscout-Version von xDrip) berechnet und prognostiziert Insulin on Board (IOB) als Teil seiner Simulations- und Vorhersagefunktionen für Blutzucker (BG)-Kurven.

Modell: Nightscout sIAp (Glockenkurve)

xDrip+ verwendet ein biexponentielles Modell (auch sIAp-Modell oder Glockenkurve genannt), das die reale Insulin-Pharmakokinetik nachahmt. Dieses Modell wird auch in der juggluco_fetcher.jl-Datei verwendet, um IOB zu schätzen, da Juggluco den internen Wert nicht über die API bereitstellt.

Parameter für Lispro (Humalog 100/200):
| Parameter | Beschreibung | Typischer Wert |
| :--- | :--- | :--- |
| DIA | Duration of Insulin Action | 360 Minuten (6 Stunden) |
| TTP | Time to Peak (Wirkungsmaximum) | 75 Minuten |

Kernformel:

Für jede Insulindosis $ i $ (in IE) zu Zeit $ t $ (Minuten seit Bolus):

Die Berechnung verwendet Zeitkonstanten $\tau$ und $a$, die aus TTP und DIA abgeleitet werden.

$\text{IOB} = \text{Dosis} \times (1 - \text{Activity Factor})$

$$\text{Activity Factor} = \frac{2 \cdot t \cdot \tau - t^2}{\tau \cdot \text{DIA}}$$

Gesamt-IOB = Summe aller IOB-Beiträge über alle offenen Behandlungen (basal + bolus) innerhalb der DIA.

4. Ergänzung: IOB-Berechnung in Juggluco (Empirische PK-Kurven)

Juggluco berechnet IOB nicht über das sIAp-Modell, sondern als Schätzung der verbleibenden aktiven Insulinmenge im Blut basierend auf empirischen, datenbasierten pharmakokinetischen (PK) Kurven aus klinischen Studien.

Modell: Empirisch-Pharmakokinetisch

Keine geschlossene algebraische Formel: Juggluco verwendet tabellierte Datenpunkte oder interpolierte Kurven (z. B. via Wolfram Mathematica für Plots), die den IOB-Decay modellieren.

Typ-Spezifisch: Die Kurve ist seit Version 9.2.0 wählbar und hängt vom Insulin-Typ ab (z. B. Aspart/NovoRapid, Glulisine/Apidra). Konzentriertes Lispro 200 (Humalog) verwendet in der Regel dasselbe oder ein sehr ähnliches Wirkprofil wie Lispro 100.

Peak-Zeitpunkt: Der Peak ist typischerweise schneller als bei sIAp-Modellen und liegt oft bei ca. 15–20 Minuten, gefolgt von einem sehr langen Abfall (bis zu 6–8 Stunden).

Empirische Datenpunkte für den Decay (Glulisine, beispielhaft)

Zeit (min)

IOB (arbiträre Einheiten)

Anmerkung

5

1896

Früher Anstieg

15

3390 (Peak)

Max. Aktivität

60

1338



360

112.02

Noch ~11 % aktiv nach 6 Std.

Fazit zur IOB-Berechnung:

Die IOB-Schätzung ist reines Rechnen, eine skalierbare, prognostische Variable. Da die Juggluco-API den internen, empirischen IOB-Wert nicht herausgibt, ist die Verwendung der Nightscout-sIAp-Glockenkurve mit Lispro-Parametern (DIA=360, TTP=75) die genaueste verfügbare Näherung in DIY-Integrationen.
   - Für Code-Details: Schau in die Juggluco-Repo (z. B. Dateien mit „IOB“-Suche).
