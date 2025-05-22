# NEST

NEST (New Environment Setup Tool) è una suite di script PowerShell per la gestione automatizzata di variabili di ambiente, utenti locali e permessi su file/cartelle tramite file CSV di configurazione.

---

## Funzionalità principali

1. **Menu interattivo**
   - Avvio tramite [NEST.ps1](NEST.ps1)
   - Permette di selezionare ed eseguire gli script disponibili nella cartella `source/` e sottocartelle.

2. **Gestione variabili di ambiente**
   - Script: [source/ScriptEnvVars/ScriptEnvVars.ps1](source/ScriptEnvVars/ScriptEnvVars.ps1)
   - Legge le variabili da configurare da [config/EnvVars.csv](config/EnvVars.csv)
   - Crea nuove variabili di ambiente o aggiorna la variabile `PATH` solo se il valore non è già presente.
   - Effettua backup della variabile `PATH` prima delle modifiche.

3. **Gestione utenti locali**
   - Script: [source/ScriptLocalUsers/ScriptLocalUsers.ps1](source/ScriptLocalUsers/ScriptLocalUsers.ps1)
   - Legge utenti e gruppi da [config/LocalUsers.csv](config/LocalUsers.csv)
   - Crea utenti locali se non esistenti e li aggiunge ai gruppi specificati (se esistenti).
   - Gestisce il caso in cui l’utente o il gruppo esista già.

4. **Gestione permessi su file/cartelle**
   - Script: [source/ScriptSetAccessRules/ScriptSetAccessRules.ps1](source/ScriptSetAccessRules/ScriptSetAccessRules.ps1)
   - Legge le regole di accesso da [config/SetAccessRules.csv](config/SetAccessRules.csv)
   - Imposta permessi (FullControl, Modify, Read) su percorsi specificati o risolti tramite variabili di ambiente.
   - Gestisce ereditarietà e propagazione dei permessi.

---

## Struttura delle cartelle

- `source/` — Contiene gli script PowerShell principali.
- `config/` — File CSV di configurazione per variabili, utenti e permessi.
- `log/` — Log delle operazioni suddivisi per funzionalità.

---

## Metodo d'uso

1. **Preparare i file CSV** in `config/` secondo le necessità e seguendo le indicazioni di [config/correct_usage.md](config/correct_usage.md)
2. **Avviare** il menu principale con una sessione amministrativa di powershell:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\Nest.ps1
   ```
3. **Selezionare** lo script desiderato dal menu.

---

## Requisiti

- PowerShell 5.1 o superiore
- Permessi amministrativi per modifiche a utenti, variabili di ambiente e permessi file

---

## Licenza

Questo software è distribuito sotto licenza GNU GPL v3. Vedi [LICENSE](LICENSE) per dettagli.
