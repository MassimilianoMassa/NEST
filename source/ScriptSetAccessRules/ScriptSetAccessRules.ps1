####################################################################
#              Creazione Dinamica Permessi Soggetto                #
#                             v1.e.25                              #
#                   Made by: Massimiliano Massa                    #
####################################################################
Start-Transcript -Path .\log\SetAccessRules\logSetAccessRules.log
$Permessi = Import-Csv -Path .\config\SetAccessRules.csv

foreach ($Perm in $Permessi){
	$VariabileEnv = $Perm.VariabileEnv
    $Percorso = $Perm.Percorso
    $Soggetto = $Perm.Soggetto
	$Permesso = $Perm.Permesso #tipo di permesso (FullControl, Modify, Read)
	$FlagEreditaCont = $Perm.FlagEreditaCont #ContainerInherit
	$FlagEreditaObj = $Perm.FlagEreditaObj #ObjectInherit
	$FlagPropaga = $Perm.FlagPropaga # none = tutti https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.propagationflags?view=net-9.0
	$TipoAC = $Perm.TipoAC #se sono abilitazioni o negazioni
	
	#blocco if per identificare e definire la variabile che stabilisce l'ereditarieta', in quanto la definizione di eredita accetta solamente (val1,val2) o (val) o (none)
	if (($FlagEreditaCont -eq "none") -and ($FlagEreditaObj -eq "none")){
		#se entrambi i flag sono a none, allora definisco il flag eridita' a none in quanto se passo entrami i valori none al comando per definire i permessi esso va in errore
		$FlagEredita = "none"
		
	}else{
		
		if (($FlagEreditaCont -ne "none") -and ($FlagEreditaObj -ne "none")){
			#verifico se entrambe le flag non sono a none, in tal caso le concateno intervallandole con una virgola
			$FlagEredita = $FlagEreditaCont + "," + $FlagEreditaObj
			
		}else{
			#rilevo se la prima flag non e' a non in tal caso setto la FlagEredita con quel valore, in alterntiva faccio l'opposto
			if ($FlagEreditaCont -ne "none"){
				$FlagEredita = $FlagEreditaCont
			}else{
				$FlagEredita = $FlagEreditaObj
			}
			
		}
	
	}
	

	if (-not ([string]::IsNullOrEmpty($VariabileEnv) -and [string]::IsNullOrEmpty($Percorso))) {

		if (-not [string]::IsNullOrEmpty($VariabileEnv)){
			
			$Indirizzo = ([Environment]::GetEnvironmentVariable($VariabileEnv)) #ottenere il path di una variabile di sistema
			$Indirizzo = $Indirizzo + $Percorso
			
			if(Test-Path -path $Indirizzo){
				#Indirizzo risolto
				try {
					# Impostazione Permessi
					
					# Prelevo i permessi dal percorso
					$acl = Get-Acl -Path $Indirizzo

					# Aggiunta del nuovo permesso
					$Regola = $Soggetto, $Permesso, $FlagEredita, $FlagPropaga, $TipoAC
					$NuovaRegola = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $Regola
					$acl.SetAccessRule($NuovaRegola)

					# Imposto l'acl con la nuova regola aggiunta sul percorso di destinazione
					$acl | Set-Acl -Path $Indirizzo 
					
                    Write-Host ("*** Abilitazioni per: " + $Soggetto + " su: " + $Indirizzo + " ***") -ForegroundColor Green
					Write-Host ("Permessi: " + $Permesso + "`nFlagEredita: " + $FlagEredita + "`nFlagPropaga: " + $FlagPropaga + "`nTipo: " + $TipoAC) -ForegroundColor Green

				} catch [System.Security.Principal.IdentityNotMappedException] {

                    #Soggetto non esiste
					Write-Host ("Soggetto: " + $Soggetto + " non esiste Eccezione: " + $_.Exception.GetType().FullName) -ForegroundColor Red

                } catch {

                    Write-Host ("Eccezione non gestita: " + $_.Exception.GetType().FullName)

                }
				
			}else{
				#Indirizzo non valido
				Write-Host ("Indirizzo: " + $Indirizzo + " ottenuto da Variabile di sistema: " + $VariabileEnv + " e Percorso: " + $Percorso + " non valido") -ForegroundColor Red
			}
			
			
		}else{ 
				if ((Test-Path -path $Percorso)){
				
				    $Indirizzo = $Percorso

                    try {
                        # Impostazione Permessi
						# Prelevo i permessi dal percorso
						$acl = Get-Acl -Path $Indirizzo

						# Aggiunta del nuovo permesso
						$Regola = $Soggetto, $Permesso, $FlagEredita, $FlagPropaga, $TipoAC
						$NuovaRegola = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $Regola
						$acl.SetAccessRule($NuovaRegola)

						# Imposto l'acl con la nuova regola aggiunta sul percorso di destinazione
						$acl | Set-Acl -Path $Indirizzo 
						
						Write-Host ("*** Abilitazioni per: " + $Soggetto + " su: " + $Indirizzo + " ***") -ForegroundColor Green
					    Write-Host ("Permessi: " + $Permesso + "`nFlagEredita: " + $FlagEredita + "`nFlagPropaga: " + $FlagPropaga + "`nTipo: " + $TipoAC) -ForegroundColor Green

                        } catch [System.Security.Principal.IdentityNotMappedException] {
                            #Soggetto non esiste
						    Write-Host ("Soggetto: " + $Soggetto + " non esiste Eccezione: " + $_.Exception.GetType().FullName) -ForegroundColor Red
                        } catch {

                            Write-Host ("Eccezione non gestita: " + $_.Exception.GetType().FullName)

                        }
				
			}else{

				Write-Host ("Percorso: " + $Percorso + " non valido") -ForegroundColor Red
			
			}
		}	
	}else{
		Write-Host ("Parametri VariabileEnv e Percorso impostati a NULL") -ForegroundColor Red
	}
}

Stop-Transcript
#Pause