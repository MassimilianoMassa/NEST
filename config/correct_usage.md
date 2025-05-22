# Documentazione `LocalUsers.csv`

Questo file CSV definisce la lista di utenti locali da creare e i gruppi locali a cui aggiungerli tramite lo script `ScriptLocalUsers.ps1`. Ogni riga rappresenta un utente che sarà gestito dallo script.

## Struttura dei campi

| Campo     | Descrizione                                                                 | Esempio         |
|-----------|----------------------------------------------------------------------------|-----------------|
| Username  | Nome dell’utente locale da creare o gestire.                               | `pippo`         |
| Password  | Password da assegnare all’utente (in chiaro).                              | `Password123!`  |
| Gruppo    | Nome del gruppo locale a cui aggiungere l’utente.<br>Se non va aggiunto a nessun gruppo, inserire il valore `NessunGruppo`. | `Administrators`<br>`NessunGruppo`|

> **Nota:**  
> Se l’utente esiste già, lo script non lo ricrea ma può aggiungerlo al gruppo specificato.  
> Se il gruppo non esiste, l’utente viene creato ma non aggiunto ad alcun gruppo.  
> Se il campo `Gruppo` è impostato a `NessunGruppo`, l’utente non verrà aggiunto a nessun gruppo.

---

## Esempi di compilazione

### Esempio 1: Creazione utente e aggiunta al gruppo Administrators

```csv
Username,Password,Gruppo
pippo,Password123!,Administrators
```

### Esempio 2: Creazione utente senza aggiunta a gruppi

```csv
Username,Password,Gruppo
pluto,Password456!,NessunGruppo
```

### Esempio 3: Creazione utente e aggiunta al gruppo Users

```csv
Username,Password,Gruppo
paperino,Paperino2024,Users
```

---

## Note aggiuntive

- Il campo `Gruppo` deve essere sempre valorizzato: usare `NessunGruppo` se non si desidera aggiungere l’utente a nessun gruppo.
- La password deve rispettare i criteri di complessità del sistema.
- Lo script richiede privilegi amministrativi per creare utenti e modificarne l’appartenenza ai gruppi.
- Se si inserisce lo stesso utente in più righe con gruppi diversi, verrà aggiunto all’ultimo gruppo specificato.

---

Per ulteriori dettagli, consulta la documentazione Microsoft su [New-LocalUser](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/new-localuser) e [Add-LocalGroupMember](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.localaccounts/add-localgroupmember).

---

# Documentazione `EnvVars.csv`

Questo file CSV definisce le variabili di ambiente da creare o aggiornare tramite lo script `ScriptEnvVars.ps1`. Ogni riga rappresenta una variabile che sarà gestita dallo script.

## Struttura dei campi

| Campo     | Descrizione                                                                 | Esempio                |
|-----------|----------------------------------------------------------------------------|------------------------|
| Variabile | Nome della variabile di ambiente da creare o aggiornare.                    | `JAVA_HOME`            |
| Valore    | Valore da assegnare alla variabile.<br>Per la variabile `PATH`, il valore viene aggiunto solo se non già presente. | `C:\Program Files\Java\jdk-21` |

> **Nota:**  
> Se la variabile è `PATH`, il valore viene aggiunto solo se non già presente e viene effettuato un backup della variabile `PATH` prima della modifica.  
> Per tutte le altre variabili, il valore viene impostato o aggiornato direttamente.

---

## Esempi di compilazione

### Esempio 1: Impostare JAVA_HOME

```csv
Variabile,Valore
JAVA_HOME,C:\Program Files\Java\jdk-21
```

### Esempio 2: Aggiungere una cartella a PATH

```csv
Variabile,Valore
PATH,C:\MyApp\bin
```

### Esempio 3: Impostare una variabile custom

```csv
Variabile,Valore
MY_CUSTOM_VAR,C:\Custom\Path
```

---

## Note aggiuntive

- Le modifiche vengono applicate alle variabili di ambiente di sistema.
- Per modificare le variabili di ambiente di sistema sono necessari privilegi amministrativi.
- Se la variabile esiste già (diversa da `PATH`), il valore viene sovrascritto.
- Per la variabile `PATH`, il valore viene aggiunto solo se non già presente tra i percorsi.
- Prima di modificare `PATH`, viene creato un backup della variabile in un file di log.
- Dopo l’esecuzione dello script, potrebbe essere necessario riavviare la sessione per rendere effettive le modifiche.

---

Per ulteriori dettagli, consulta la documentazione Microsoft su [Environment Variables](https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables).

---

# Documentazione `SetAccessRules.csv`

Questo file CSV definisce le regole di accesso (ACL) che verranno applicate a file o cartelle tramite lo script `ScriptSetAccessRules.ps1`. Ogni riga rappresenta una regola che sarà convertita in un oggetto `System.Security.AccessControl.FileSystemAccessRule` tramite i valori forniti.

## Struttura dei campi

| Campo            | Descrizione                                                                                       | Esempio                          |
|------------------|--------------------------------------------------------------------------------------------------|----------------------------------|
| VariabileEnv     | Nome della variabile di ambiente da risolvere come base del percorso. Lasciare vuoto se non usata.| `ProgramData`                    |
| Percorso         | Percorso relativo (se VariabileEnv è valorizzata) o assoluto della cartella/file da modificare.   | `\MyApp\Logs` oppure `C:\Temp`   |
| Soggetto         | Utente o gruppo a cui assegnare il permesso.                                                     | `Everyone`, `Administrators`     |
| Permesso         | Tipo di permesso da assegnare. Valori tipici: `FullControl`, `Modify`, `Read`.                   | `FullControl`                    |
| FlagEreditaCont  | Ereditarietà su contenitori (cartelle). `ContainerInherit` oppure `none`.                        | `ContainerInherit`               |
| FlagEreditaObj   | Ereditarietà su oggetti (file). `ObjectInherit` oppure `none`.                                   | `ObjectInherit`                  |
| FlagPropaga      | Propagazione permessi. Valori: `None`, `NoPropagateInherit`, `InheritOnly`.                      | `None`                           |
| TipoAC           | Tipo di regola: `Allow` (consenti) o `Deny` (nega).                                              | `Allow`                          |

> **Nota:**  
> Se `VariabileEnv` è valorizzata, il percorso finale sarà la concatenazione del valore della variabile di ambiente e del campo `Percorso`.  
> Se `VariabileEnv` è vuoto, `Percorso` deve essere un percorso assoluto.

---

## Esempi di compilazione

### Esempio 1: Permesso FullControl a Everyone su una cartella in ProgramData

```csv
VariabileEnv,Percorso,Soggetto,Permesso,FlagEreditaCont,FlagEreditaObj,FlagPropaga,TipoAC
ProgramData,\MyApp\Logs,Everyone,FullControl,ContainerInherit,ObjectInherit,None,Allow
```

### Esempio 2: Permesso Read agli Users su una cartella assoluta

```csv
VariabileEnv,Percorso,Soggetto,Permesso,FlagEreditaCont,FlagEreditaObj,FlagPropaga,TipoAC
,C:\Temp,Users,Read,ContainerInherit,ObjectInherit,None,Allow
```

### Esempio 3: Negazione permesso Modify a un utente specifico solo sui file (non sulle cartelle)

```csv
VariabileEnv,Percorso,Soggetto,Permesso,FlagEreditaCont,FlagEreditaObj,FlagPropaga,TipoAC
,C:\Dati,utente1,Modify,none,ObjectInherit,None,Deny
```

### Esempio 4: Permesso FullControl agli Administrators solo sulla cartella (non sui file)

```csv
VariabileEnv,Percorso,Soggetto,Permesso,FlagEreditaCont,FlagEreditaObj,FlagPropaga,TipoAC
,C:\Dati,Administrators,FullControl,ContainerInherit,none,None,Allow
```

---

## Valori accettati per i flag

- **FlagEreditaCont:** `ContainerInherit` oppure `none`
- **FlagEreditaObj:** `ObjectInherit` oppure `none`
- **FlagPropaga:** `None`, `NoPropagateInherit`, `InheritOnly`
- **TipoAC:** `Allow` oppure `Deny`

---

## Note aggiuntive

- I permessi vengono applicati solo se il percorso risolto esiste.
- Se sia `VariabileEnv` che `Percorso` sono vuoti, la riga viene ignorata.
- Il campo `Soggetto` deve corrispondere a un utente o gruppo esistente sul sistema.

---

Per ulteriori dettagli sui valori possibili, consulta la documentazione Microsoft per [`FileSystemAccessRule`](https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.filesystemaccessrule).

---