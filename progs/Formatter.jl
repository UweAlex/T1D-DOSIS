# ==============================================================================
# Custom Workflow Formatter für Julia-Code
# ZWECK: Führt den Standard-Formatter aus und fügt danach automatisch End-Kommentare hinzu.
# ==============================================================================

using JuliaFormatter # WICHTIG: Erlaubt den Aufruf des Standard-Formatters

"""
Führt zuerst den offiziellen JuliaFormatter auf der Datei aus und fügt danach
automatisch Kommentare (z.B. `# if`, `# for`) zum 'end'-Schlüsselwort hinzu.

@param filepath: Der Pfad zur zu formatierenden Julia-Datei.
"""
function format_and_add_end_comments(filepath::String)
    println("--- SCHRITT 1: Standard-Formatierung durch JuliaFormatter.jl ---")
    
    try
        # 1. Den offiziellen JuliaFormatter anwenden, um den Code zu standardisieren
        JuliaFormatter.format(filepath)
        println("Standard-Formatierung erfolgreich.")
    catch e
        println("FEHLER: JuliaFormatter.jl konnte die Datei $filepath nicht verarbeiten. $(e)")
        return
    end

    # ----------------------------------------------------------------------
    println("\n--- SCHRITT 2: Hinzufügen von End-Kommentaren (Post-Formatierung) ---")
    
    # 2. Datei komplett NEU einlesen (da sie in Schritt 1 geändert wurde)
    lines = readlines(filepath)
    new_lines = []
    
    # Mapping von Schlüsselwörtern zu Kommentaren.
    # Muss die wichtigsten blockbildenden Keywords abdecken.
    block_keywords = Dict(
        "function " => "# function",
        "for " => "# for",
        "while " => "# while",
        "if " => "# if",
        "elseif " => "# elseif/else block", # Muss nach if geprüft werden
        "else" => "# else block",
        "try" => "# try",
        "catch" => "# catch block",
        "module " => "# module",
        "struct " => "# struct",
        "begin" => "# begin",
        "do" => "# do" # Für anonyme Funktionen/Ressourcen
    )

    # 3. Zeilen durchlaufen und Kommentare hinzufügen
    for i in 1:length(lines)
        line = lines[i]

        # Wenn die aktuelle Zeile NUR ein "end" enthält (mit beliebiger Einrückung)
        if occursin(r"^\s*end\s*$", line) 
            
            comment_added = false
            current_indent = length(match(r"^\s*", line).match)

            # Rückwärts-Suche nach der öffnenden Zeile
            for j in (i - 1):-1:1
                prev_line = lines[j]
                
                # Ignoriere leere Zeilen und reine Kommentarzeilen
                if !isempty(strip(prev_line)) && !startswith(strip(prev_line), "#")
                    
                    prev_indent = length(match(r"^\s*", prev_line).match)
                    
                    # Überprüfung der Einrückung: Block-Start muss 4 Leerzeichen weniger haben
                    if prev_indent == current_indent - 4
                        
                        # Suche das passende Block-Keyword in der Startzeile
                        for (keyword, comment) in block_keywords
                            # Prüft, ob die Zeile mit dem Keyword beginnt (nach Einrückung)
                            if occursin(Regex(string("^\\s*", keyword)), prev_line)
                                # Füge den Kommentar zum 'end' hinzu
                                line = line * " " * comment
                                comment_added = true
                                break
                            end
                        end # for keywords
                        
                        # Wenn ein passender Block-Typ gefunden wurde, stoppe die Rückwärtssuche
                        if comment_added
                            break
                        end

                    # Wir ignorieren Zeilen mit gleicher Einrückung (wie 'else' oder 'catch'),
                    # da wir den Start des UMSCHLIESSENDEN Blocks (wie 'if' oder 'try') suchen.
                    end
                end 
            end # for j (backward search)
            
            if !comment_added
                println("WARNUNG: Konnte kein passendes Block-Keyword für 'end' in Zeile $i finden. (Keine Einrückungsstufe gefunden)")
                line = line * " # block" # Füge einen allgemeinen Kommentar hinzu
            end

        end # if occursin end

        push!(new_lines, line)
    end # for line

    # 4. Datei mit neuen Kommentaren überschreiben
    open(filepath, "w") do io
        for line in new_lines
            println(io, line)
        end
    end # do open

    println("Gesamter Formatierungs-Workflow abgeschlossen für $filepath.")

end # function format_and_add_end_comments


# --- ANWENDUNG DES WORKFLOW-FORMATTERS ---

# Wichtig: Vor der Ausführung müssen Sie sicherstellen, dass die Pakete 
# JuliaFormatter installiert sind und die Datei existiert.

# Beispiel der Anwendung:
# format_and_add_end_comments("path/to/ihre_datei.jl")
