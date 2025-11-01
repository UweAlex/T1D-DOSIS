# ==============================================================================
# Juggluco Datenabruf-Programm in Julia (Zyklische Version)
# Zweck: Sicheres Abrufen von Glukose- und Behandlungsdaten von Juggluco
# DIESE VERSION IST EINE RUDIMENTÄRE DEMO NUR FÜR DEN KONTAKT-TEST.
# IOB-BERECHNUNG WURDE ENTFERNT.
# ==============================================================================

using HTTP
using JSON3
using Dates
using SHA

# --- 1. KONFIGURATION (WICHTIG!) ---

# HINWEIS: Aktualisieren Sie IP-Adresse und Port, falls Ihr Gerät gewechselt hat.
const JUGGLUCO_BASE_URL = "http://192.168.178.48:17580" 

# >>>>>>>>>>>>>>>>>> HIER MUSS DER WERT GEÄNDERT WERDEN <<<<<<<<<<<<<<<<<<
# API_SECRET: Muss exakt mit dem in Juggluco konfigurierten Webserver-Schlüssel 
# übereinstimmen. Groß-/Kleinschreibung ist relevant!
const API_SECRET = "token-ottoottootto" # <--- HIER Ihren echten Schlüssel einfügen!
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Anzahl der Einträge, die abgerufen werden sollen (Glukose und Behandlungen). 
const COUNT = 20

# Das Intervall, in dem die Daten neu geladen werden (in Sekunden).
const REFRESH_INTERVAL_SECONDS = 300 # 300 Sekunden = 5 Minuten

# --- 2. EMPFOHLENE JUGGLUCO-WEBSERVER-EINSTELLUNGEN ---
# Für eine erfolgreiche Verbindung sollten in Juggluco unter Einstellungen > Webserver
# folgende Punkte gesetzt sein:
# [X] Aktiviert (On activ)
# [ ] Nur Lokales Netz (Off only local) -> Kann auf 'On' stehen, wenn PC/Skript im selben WLAN
# [ ] SSL verwenden (Off use SSL)
# [X] Mengen geben (On Mengen geben) -> Erlaubt das Senden von Behandlungsdaten

# ==============================================================================

"""
Führt einen gesicherten HTTP-GET-Request zum Juggluco-Server aus.
Verwendet SHA-1 Hashing des API_SECRET zur Authentifizierung (Nightscout-Standard).
"""
function fetch_data(endpoint::String)
    url = JUGGLUCO_BASE_URL * endpoint
    
    # 1. API Secret in SHA1-Hash umwandeln
    sha1_hash = bytes2hex(sha1(API_SECRET))

    # 2. Den SHA1-Hash über den 'api-secret' Header übermitteln
    headers = ["api-secret" => sha1_hash]

    println("Lade Daten von: $url (Verwende SHA1-Hash zur Authentifizierung)")

    try
        # HTTP-GET-Anfrage mit 10 Sekunden Timeout
        response = HTTP.get(url, headers=headers, readtimeout=10)

        if response.status == 200
            # Erfolgreiche Antwort: JSON-Daten lesen
            return JSON3.read(String(response.body))
        elseif response.status == 403
            # FEHLER: Falscher API-Schlüssel oder fehlende Berechtigung
            println(stderr, "AUTHENTIFIZIERUNGSFEHLER (403 Forbidden).")
            println(stderr, "-> Der in JUGGLUCO konfigurierte API_SECRET stimmt NICHT mit dem im Julia-Skript überein.")
            return nothing
        else
            println(stderr, "Fehler beim Abrufen der Daten. Status: $(response.status)")
            return nothing
        end
    catch e
        # FEHLER: Netzwerkproblem (z.B. falsche IP, Juggluco nicht aktiv, WLAN-Verbindung unterbrochen)
        println(stderr, "Verbindungsfehler (Überprüfe IP, Port, API_SECRET und WLAN-Verbindung): $e")
        return nothing
    end
end


"""
Verarbeitet die abgerufenen Glukosewerte und Behandlungen und erstellt den Bericht.
"""
function process_and_display_data()
    # 1. Glukosewerte (SGV) abrufen
    entries = fetch_data("/api/v1/entries.json?count=$COUNT")
    
    # 2. Behandlungen (Insulin, Carbs, Notizen) abrufen
    treatments = fetch_data("/api/v1/treatments.json?count=$COUNT")

    if isnothing(entries) && isnothing(treatments)
        println("Es konnten keine Daten abgerufen werden.")
        return
    end
    
    all_data = []

    # Verarbeite Glukosewerte
    if !isnothing(entries)
        for entry in entries
            # Zeitstempel: date ist in Millisekunden seit 1970
            ts = DateTime(1970, 1, 1) + Millisecond(entry.date)
            sgv = entry.sgv
            direction = get(entry, :direction, "N/A")
            
            push!(all_data, (ts=ts, type="Glukose", value="$sgv mg/dL", details="Trend: $direction"))
        end
    end

    # Verarbeite Behandlungen
    if !isnothing(treatments)
        for treatment in treatments
            raw_ts = get(treatment, :date, nothing)
            
            if isnothing(raw_ts)
                println(stderr, "Warnung: Ein Treatment-Eintrag enthielt keinen gültigen Zeitstempel und wurde übersprungen.")
                continue
            end
            
            ts = DateTime(1970, 1, 1) + Millisecond(raw_ts)
            details = []
            
            # --- ROBUSTE FEHLERBEHANDLUNG FÜR NULL-WERTE ---
            
            # Insulin
            raw_insulin = get(treatment, :insulin, nothing)
            insulin_val = isnothing(raw_insulin) ? 0.0 : Float64(raw_insulin)
            
            if insulin_val > 0.0
                push!(details, "Insulin: $(insulin_val) IE")
            end
            
            # Kohlenhydrate (Carbs)
            raw_carbs = get(treatment, :carbs, nothing)
            carbs_val = isnothing(raw_carbs) ? 0 : Int(raw_carbs)
            
            if carbs_val > 0
                push!(details, "Kohlenhydrate: $(carbs_val) g")
            end
            
            # Notizen
            notes_val = get(treatment, :notes, "")
            if !isempty(notes_val)
                 if isempty(details)
                     push!(details, "Notiz: $(notes_val)")
                 else
                     push!(details, "Anmerkung: $(notes_val)")
                 end
            end

            if !isempty(details)
                push!(all_data, (ts=ts, type="Behandlung", value=join(details, ", "), details=""))
            end
        end
    end

    # Sortiere alle Einträge nach der Zeit (neueste zuerst)
    sort!(all_data, by = x -> x.ts, rev=true)

    # --- DATEN ALS FLIESSTEXT AUSGEBEN ---
    
    println("\n==================================================")
    println("Zusammenfassender Bericht der Juggluco-Daten (Demo)")
    println("Abgerufen von: $JUGGLUCO_BASE_URL (Letzter Abruf: $(Dates.format(now(), "dd.mm.yyyy HH:MM:ss")))")
    println("==================================================\n")

    for entry in all_data
        time_str = Dates.format(entry.ts, "dd.mm.yyyy HH:MM")
        
        if entry.type == "Glukose"
            print("Um $time_str wurde ein Glukosewert von **$(entry.value)** gemessen ($(entry.details)). ")
        elseif entry.type == "Behandlung"
            print("Zur Zeit $time_str wurde eine Behandlung protokolliert: **$(entry.value)**. ")
        end
    end
    println("\n")
end


"""
Startet die Hauptschleife für den zyklischen Abruf.
"""
function run_cyclic_fetcher()
    # Hauptschleife für die zyklische Ausführung
    println("Starte den zyklischen Datenabruf (Intervall: $(REFRESH_INTERVAL_SECONDS) Sekunden)...")
    
    while true
        # 1. Daten abrufen und anzeigen
        process_and_display_data()
        
        # 2. Warten bis zum nächsten Abruf
        println("Nächster Abruf in $(REFRESH_INTERVAL_SECONDS) Sekunden...")
        sleep(REFRESH_INTERVAL_SECONDS) 
    end
end

# Führe die zyklische Funktion aus
run_cyclic_fetcher()
