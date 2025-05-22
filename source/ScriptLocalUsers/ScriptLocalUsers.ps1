####################################################################
#             Creazione Dinamica di Utenti da File CSV             #
#                             v1.e.25                              #
#                   Made by: Massimiliano Massa                    #
####################################################################
Start-Transcript -Path .\log\LocalUsers\logLocalUsers.log
$NewUsers = Import-csv -Path .\config\LocalUsers.csv
$logonSRV = ($env:LOGONSERVER.Replace("\",""))

foreach ($User in $NewUsers) {
    $username = $User.Username
    $password = $User.Password
    $group = $user.Gruppo

    #Creazione Utente
    #creo un flag (checkUE) se 0 l'utente non esiste se 1 e' gia' presente
    $checkUE = Get-LocalUser | where-Object Name -eq $username | Measure-Object
    if ($checkUE.Count -eq 0) {
         #se l'utente non esiste procedo alla sua creazione e all'output che ne conferma la creazione
         New-LocalUser -Name $username -Password (ConvertTo-SecureString $password -AsPlainText -Force) -UserMayNotChangePassword -PasswordNeverExpires
         Write-Host ("Creato utente denominato: " + $user.Username) -ForegroundColor green
    } else {
         #se l'utente esiste gia', non lo creo e passo all'output seguente
         Write-Host ("Esiste gia' un utente denominato: " + $user.Username) -ForegroundColor red
    }

    #Aggiunta Utente al Gruppo
    if (((Get-LocalGroup).Name -contains $group) -or (($group -eq "NessunGruppo"))){
        #se il gruppo esiste o se il gruppo associato e' "NessunGruppo" passo all'aggiunta dell'utente al gruppo selezionato
        if ($group -eq "NessunGruppo") {
             #se il gruppo selezionato e' "NessunGruppo" scrivo che l'utente non e' stato aggiunto a nessun gruppo
             Write-Host ("Utente: " + $user.Username + " non aggiunto ad alcun gruppo") -ForegroundColor yellow
        } else {
            #alternativamente verifico se l'utente e' gia' presente all'interno del gruppo
             if (!((Get-LocalGroupMember $group).Name -contains $logonSRV+"\"+$user.Username)){
                #se l'utente non e' presente all'interno del gruppo lo aggiungo e scrivo in output di averlo fatto
                Add-LocalGroupMember -Group $group -Member $username
                Write-Host ("Aggiunto utente: " + $user.Username + " al gruppo: " + $group) -ForegroundColor green
             } else {
                #se l'utente e' gia' presente all'interno del gruppo selezionato lo riporto in output
                Write-Host ("Utente: " + $user.Username + " gia' presente nel gruppo: " + $group) -ForegroundColor red
             }
        }
    } else {
       #se il gruppo non esiste lo riporto in output
       Write-Host ("Gruppo: " + $group + " non esiste") -ForegroundColor red
    }
    
}
Stop-Transcript
#pause