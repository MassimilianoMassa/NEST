# Nest.ps1
# Menu di selezione per avviare gli script nella cartella 'source' e sottocartelle

$asciiTitle = @'
 /\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \/\\\///////////////////////////////////////////////////////////////////////////////////\\\
  \/\\\                                                                                 \/\\\
   \/\\\  ___/\\\\\_____/\\\____/\\\\\\\\\\\\\\_____/\\\\\\\\\\\_____/\\\\\\\\\\\\\\\\_  \/\\\
    \/\\\  __\/\\\\\\___\/\\\___\/\\\//////////____/\\\/////////\\\__\///////\\\//////__  \/\\\
     \/\\\  __\/\\\/\\\__\/\\\___\/\\\_____________\//\\\______\///_________\/\\\________  \/\\\
      \/\\\  __\/\\\//\\\_\/\\\___\/\\\\\\\\\\\______\////\\\________________\/\\\________  \/\\\
       \/\\\  __\/\\\\//\\\\/\\\___\/\\\///////__________\////\\\_____________\/\\\________  \/\\\
        \/\\\  __\/\\\_\//\\\/\\\___\/\\\____________________\////\\\\_________\/\\\________  \/\\\
         \/\\\  __\/\\\__\//\\\\\\___\/\\\______________/\\\_____\//\\\\________\/\\\________  \/\\\
          \/\\\  __\/\\\___\//\\\\\___\/\\\\\\\\\\\\\\__\///\\\\\\\\\\\/_________\/\\\________  \/\\\
           \/\\\  __\///_____\/////____\//////////////_____\///////////___________\///_________  \/\\\
            \/\\\                                                                                 \/\\\
             \/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
              \/////////////////////////////////////////////////////////////////////////////////////////
  _  _              ___         _                            _     ___      _               _____         _
 | \| |_____ __ __ | __|_ ___ _(_)_ _ ___ _ _  _ __  ___ _ _| |_  / __| ___| |_ _  _ _ __  |_   _|__  ___| |
 | .` / -_) V  V / | _|| ' \ V / | '_/ _ \ ' \| '  \/ -_) ' \  _| \__ \/ -_)  _| || | '_ \   | |/ _ \/ _ \ |
 |_|\_\___|\_/\_/  |___|_||_\_/|_|_| \___/_||_|_|_|_\___|_||_\__| |___/\___|\__|\_,_| .__/   |_|\___/\___/_|
                                                                                    |_|                     
                                              (Version 1.e.25)
'@

$host.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.ForegroundColor = 'White'
Clear-Host
Write-Host $asciiTitle -ForegroundColor Cyan

$sourcePath = Join-Path -Path $PSScriptRoot -ChildPath "source"
if (-not (Test-Path $sourcePath)) {
        Write-Host "La cartella 'source' non esiste: $sourcePath"
        exit
}

# Trova tutti gli script .ps1 nella cartella source e sottocartelle
$scripts = Get-ChildItem -Path $sourcePath -Filter *.ps1 -Recurse | Select-Object -ExpandProperty FullName

if ($scripts.Count -eq 0) {
        Write-Host "Nessuno script trovato nella cartella 'source'."
        exit
}

do {
        Write-Host "`nSeleziona uno script da eseguire:"
        for ($i = 0; $i -lt $scripts.Count; $i++) {
                $relativePath = $scripts[$i].Substring($sourcePath.Length + 1)
                Write-Host "$($i+1)) $relativePath"
        }
        Write-Host "X) Esci"

        $selection = Read-Host "`nInserisci il numero dello script da avviare oppure 'X' per uscire"
        if ($selection -eq 'X' -or $selection -eq 'x') {
                Write-Host "Uscita dal programma."
                break
        } elseif ($selection -match '^\d+$' -and $selection -ge 1 -and $selection -le $scripts.Count) {
                $scriptToRun = $scripts[$selection - 1]
                Write-Host "`nAvvio: $scriptToRun`n"
                & $scriptToRun
                Write-Host "`nScript terminato. Premi INVIO per continuare..."
                [void][System.Console]::ReadLine()
        } else {
                Write-Host "Selezione non valida."
        }
} while ($true)