# Sistema di Prenotazione Laboratori

Una web app moderna per gestire le prenotazioni ai laboratori creativi, costruita con Astro, Vue.js e Supabase.

## 🎯 Funzionalità Principali

### 🎨 **Interfaccia Utente Moderna**
- **Design a bottoni**: Selezione sessioni tramite bottoni interattivi invece di radio button
- **Visualizzazione avatar**: Indicatori visivi con faccine per posti occupati e cerchi grigi per posti liberi
- **Contatori in tempo reale**: Monitoraggio live della capacità per il Laboratorio di Psicologia
- **Interfaccia responsive**: Design ottimizzato per desktop e mobile

### 📝 **Sistema di Prenotazione**
- **Form intuitivo**: Prenotazione semplice per tutti e tre i laboratori
- **Validazione avanzata**: Controlli lato client e server per dati corretti
- **Gestione capacità automatica**: Limite di 15 partecipanti per sessione di Psicologia
- **Prevenzione duplicati**: Controllo email per evitare prenotazioni multiple

### ✅ **Pagina di Conferma**
- **Riepilogo completo**: Visualizzazione dettagliata della prenotazione effettuata
- **Azioni rapide**: Bottoni per nuova prenotazione o cancellazione
- **Design elegante**: Interfaccia pulita con icone e colori tematici

### 🛠️ **Dashboard Amministratore**
- **Statistiche in tempo reale**: Conteggi aggiornati per ogni laboratorio e sessione
- **Gestione partecipanti**: Aggiunta e rimozione manuale dei partecipanti
- **Esportazione dati**: Export CSV completo delle prenotazioni
- **Autenticazione sicura**: Accesso protetto alla sezione admin

## 🏗️ Laboratori Disponibili

1. **Laboratorio di Quilling** (3 sessioni, senza limite)
2. **Laboratorio di Ricamo** (3 sessioni, senza limite)  
3. **Laboratorio di Psicologia** (3 sessioni, max 15 partecipanti per sessione)

## 🚀 Setup del Progetto

### Prerequisiti

- Node.js (versione 18 o superiore)
- Account Supabase

### 1. Installazione Dipendenze

```bash
npm install
```

### 2. Configurazione Supabase

1. Crea un nuovo progetto su [Supabase](https://supabase.com)
2. Copia il file `.env.example` in `.env`:
   ```bash
   cp .env.example .env
   ```
3. Compila il file `.env` con le tue credenziali Supabase:
   ```
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

### 3. Setup Database

1. Vai nella sezione SQL Editor del tuo progetto Supabase
2. Esegui lo script contenuto in `database/schema.sql`
3. Questo creerà tutte le tabelle, trigger e policy necessarie

### 4. Avvio Sviluppo

```bash
npm run dev
```

L'applicazione sarà disponibile su `http://localhost:4321`

## 📁 Struttura del Progetto

```
/
├── database/
│   └── schema.sql          # Schema del database Supabase
├── src/
│   ├── components/
│   │   ├── RegistrationForm.vue    # Form di prenotazione con design moderno
│   │   ├── AdminDashboard.vue      # Dashboard amministratore
│   │   ├── AdminLogin.vue          # Componente login admin
│   │   └── ProtectedAdmin.vue      # Wrapper per protezione admin
│   ├── layouts/
│   │   └── Layout.astro            # Layout principale
│   ├── lib/
│   │   └── supabase.ts             # Configurazione Supabase
│   ├── pages/
│   │   ├── index.astro             # Pagina principale con form
│   │   ├── conferma.astro          # Pagina di conferma prenotazione
│   │   └── admin.astro             # Dashboard amministratore protetta
│   └── env.d.ts                    # Tipi TypeScript per env
├── .env.example                    # Template variabili ambiente
└── README.md
```

## 🎨 Pagine Disponibili

- **`/`** - Form di prenotazione principale con selezione interattiva delle sessioni
- **`/conferma`** - Pagina di conferma post-prenotazione con riepilogo e azioni
- **`/admin`** - Dashboard amministratore con gestione completa dei partecipanti

## 🔧 Comandi Disponibili

| Comando                   | Azione                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installa le dipendenze                          |
| `npm run dev`             | Avvia il server di sviluppo                     |
| `npm run build`           | Costruisce il sito per la produzione            |
| `npm run preview`         | Anteprima del build di produzione               |

## 🗄️ Database Schema

Il database include:

- **workshops**: Informazioni sui laboratori
- **sessions**: Sessioni di ogni laboratorio con conteggio partecipanti
- **registrations**: Iscrizioni degli utenti

### Funzionalità Automatiche

- **Trigger automatici** per aggiornare il conteggio partecipanti
- **Controllo capacità** per il Laboratorio di Psicologia
- **Validazione email** per evitare duplicati

## 🔒 Sicurezza

- Row Level Security (RLS) abilitato su tutte le tabelle
- Policy configurate per accesso pubblico controllato
- Validazione lato client e server

## 🚀 Deploy

Per il deploy in produzione:

1. Costruisci il progetto:
   ```bash
   npm run build
   ```

2. Configura le variabili d'ambiente sul tuo hosting provider

3. Carica i file dalla cartella `dist/`

## 🛠️ Tecnologie Utilizzate

- **Astro** - Framework web moderno
- **Vue.js** - Framework reattivo per i componenti
- **Tailwind CSS** - Framework CSS utility-first
- **Supabase** - Backend-as-a-Service per database e autenticazione
- **TypeScript** - Tipizzazione statica

## 🎨 Caratteristiche UI/UX

### **Design Moderno e Intuitivo**
- **Bottoni interattivi**: Selezione sessioni tramite bottoni grandi e colorati invece di radio button tradizionali
- **Indicatori visivi**: Avatar generati dinamicamente per posti occupati e cerchi grigi per posti liberi
- **Feedback in tempo reale**: Contatori live che mostrano "X/15 posti occupati" e "X posti disponibili"
- **Animazioni fluide**: Transizioni smooth per hover e selezione con `transition-all duration-200`
- **Colori tematici**: Blu per Quilling, Verde per Ricamo, Viola/Rosso per Psicologia

### **Esperienza Utente Ottimizzata**
- **Flusso completo**: Dalla prenotazione alla conferma senza interruzioni
- **Pagina di conferma dedicata**: Riepilogo elegante con possibilità di nuova prenotazione o cancellazione
- **Gestione errori**: Messaggi chiari per sessioni piene o errori di validazione
- **Responsive design**: Perfetto su desktop, tablet e mobile

## 📊 Funzionalità Admin Avanzate

La dashboard amministratore include:

- **Statistiche in tempo reale**: Conteggi aggiornati automaticamente per ogni laboratorio
- **Gestione manuale partecipanti**: Aggiunta e rimozione diretta dalla dashboard
- **Tabella interattiva**: Filtri, ricerca e ordinamento dei partecipanti
- **Esportazione CSV**: Download completo dei dati per analisi esterne
- **Monitoraggio capacità**: Controllo visivo dello stato delle sessioni di Psicologia
- **Autenticazione sicura**: Login protetto per accesso amministratore

## 🤝 Supporto

Per domande o problemi, controlla la documentazione di:
- [Astro](https://docs.astro.build)
- [Vue.js](https://vuejs.org/guide/)
- [Supabase](https://supabase.com/docs)
