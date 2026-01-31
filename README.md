# REBO
📍 WebApp Locali – Menu, Ordini & Community (Working Title)
📌 Obiettivo del progetto

Questa webapp è una piattaforma web per locali fisici (bar, pub, ristoranti, caffetterie) che consente ai clienti presenti fisicamente nel locale di:

visualizzare il profilo del locale

consultare il menù digitale

creare e inviare una comanda

interagire tramite chat del locale

lasciare recensioni

ottenere sconti tramite QR / codice

Il focus non è la consegna o il delivery, ma l’esperienza in loco, semplice, veloce e sociale.

🧠 Concetti chiave (da NON tradire)

Local-first: l’esperienza è pensata per chi è vicino o dentro il locale.

Menù come core feature: tutto ruota attorno al menù e alla comanda.

Ruoli distinti: cliente ≠ proprietario ≠ staff.

Semplicità prima di tutto: UX immediata, pochi click.

Beta-oriented: MVP chiaro, niente overengineering.

👥 Tipologie di utenti
👤 Cliente

Visualizza locali vicini

Consulta menù

Aggiunge prodotti alla comanda

Invia ordini

Partecipa alla chat del locale

Scrive recensioni

Ottiene sconti

🧑‍💼 Proprietario / Staff

Gestisce il menù (categorie e prodotti)

Modifica prezzi, disponibilità e immagini

Pubblica una pagina descrittiva del locale

Visualizza ordini ricevuti

Modera chat (in futuro)

🧭 Flusso principale (Happy Path)

L’utente apre la webapp

Vede una lista di locali (ordinata per distanza)

Entra nel profilo di un locale

Consulta il menù diviso per categorie

Aggiunge prodotti alla comanda

Visualizza la comanda in una tendina

Invia l’ordine

(Opzionale) chatta, recensisce, ottiene sconti

🏪 Profilo del locale

Il profilo del locale è il contenitore centrale dell’esperienza e include:

Informazioni base (nome, foto, descrizione)

Pagina scritta dal proprietario

Menù

Chat pubblica del locale

Recensioni

Indicazione “Regulars” (utenti abituali)

Layout concettuale:

Colonna sinistra → pagina del locale / info

Colonna destra → menù / interazioni

📖 Menù (feature centrale)

Il menù è strutturato come segue:

Categorie (es. Colazione, Pranzo, Drink)

Prodotti con:

nome

descrizione

prezzo

immagine

disponibilità

Interazioni:

Click su prodotto → modal dettaglio

Pulsanti + / - per quantità

Possibilità di “fissare” 1–2 prodotti preferiti

🧾 Comanda

La comanda:

È sempre accessibile tramite una tendina

Mostra prodotti selezionati e quantità

Permette invio ordine

Ha uno storico ordini per l’utente

⚠️ Nota: NON è pagamento online (almeno nell’MVP).

💬 Chat
Chat del locale

Visibile solo a chi è vicino/presente

Messaggi pubblici

Scopo: socialità leggera, avvisi, atmosfera

Chat private

Lista conversazioni

Direct messages tra utenti

⭐ Recensioni

Positiva / Negativa

Eventuale commento testuale

Visualizzazione elenco recensioni

Calcolo rating sintetico

🎟️ Sconti

Generazione codice o QR

Codice a 5 cifre

Scadenza temporale

Validazione lato staff

🧑‍💻 Stack tecnologico (decisioni attuali)

Frontend: Next.js (App Router)

Linguaggio: TypeScript

Styling: Tailwind CSS

Backend: integrato (API / server actions)

Database: relazionale (da definire)

Hosting: Vercel

Versionamento: GitHub

🧱 Struttura del progetto (attesa)
src/
  app/          → routing e pagine
  components/   → componenti UI riutilizzabili
    ui/
  lib/          → helpers e utilities
  server/       → db, auth, server logic
  types/        → tipi TypeScript

🛑 Fuori scope (per ora)

Pagamenti online

Prenotazioni tavoli

Delivery

Gamification avanzata

Analytics complessi

🚧 Stato del progetto

🟡 Fase: Bootstrap & MVP planning

Il progetto è in fase iniziale.
Le priorità attuali sono:

Struttura tecnica solida

Menù + Comanda funzionanti

Ruoli base

UX semplice e coerente

🤖 Nota per Antigravity

Questo README definisce la visione, i vincoli e il comportamento atteso della webapp.
Ogni contributo automatico o assistito deve:

rispettare questo flusso

evitare feature non richieste

mantenere semplicità e leggibilità del codice

privilegiare chiarezza > astrazione