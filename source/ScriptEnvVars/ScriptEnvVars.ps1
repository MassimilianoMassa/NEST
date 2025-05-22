####################################################################
#             Creazione Dinamica Variabili di Ambiente             #
#                             v1.e.25                              #
#                   Made by: Massimiliano Massa                    #
####################################################################
Start-Transcript -Path .\log\EnvVars\logEnvVars.log
$variabili = Import-csv -Path .\config\EnvVars.csv
Add-Content -Path .\log\EnvVars\BKPATH.txt -Value ([Environment]::GetEnvironmentVariable("PATH")) -Force -Verbose

foreach ($Varia in $variabili){
    $Variabile = $Varia.Variabile
    $Valore = $Varia.Valore
    
    if($Variabile -ne "PATH"){
        if((([Environment]::GetEnvironmentVariable($Variabile)).Length) -eq 0){
            [Environment]::SetEnvironmentVariable($Variabile, $Valore, "Machine")
            Write-Host ("Variabile: " + $Variabile + " Impostata con il Valore: " + $Valore) -ForegroundColor Green
        } else {
            Write-Host ("Variabile " + $Variabile + " gia' presente a sitema") -ForegroundColor Red
        }
    } else {
        $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
        if(-not ($currentPath.Contains($Valore))){
            [Environment]::SetEnvironmentVariable($Variabile, $currentPath + ";" + $Valore, "Machine")
            Write-Host ("Variabile: " + $Variabile + " Impostata con il Valore: " + $currentPath + ";" + $Valore) -ForegroundColor Green
        } else {
            Write-Host ("Valore: " + $Valore + " gia' presente all'interno della variabile " + $Variabile) -ForegroundColor Red
        }
    }

}
Stop-Transcript    
#pause