# ADR 0001 — Scelta Stack & CI/CD (Punto 1.3 e 1.6)

**Stato:** Proposto (da approvare e poi fissare come “Accettato”)

## Contesto
Dobbiamo impostare una base tecnica che consenta di rilasciare velocemente un MVP, mantenendo costi e complessità bassi, con una pipeline automatica per evitare rilasci manuali e regressioni.

## Decisione — Stack
- Monorepo
- Fullstack TypeScript
- Next.js (App Router) per UI e API
- PostgreSQL come database
- Prisma come ORM/migrazioni
- Auth: Auth.js (oppure provider esterno in fase 2)
- Storage immagini: S3 compatibile + CDN
- Realtime (chat): provider gestito per MVP (es. Supabase Realtime / Pusher/Ably), valutazione self-hosted dopo

## Decisione — CI/CD
- GitHub Actions (o GitLab CI se usate GitLab)
- Workflow CI su Pull Request: install+cache, lint, typecheck, test, build
- Deploy automatico su Staging su merge in `develop`
- Deploy su Production su merge in `main` (approvazione manuale opzionale)
- Branch protection: richiesti status check + review minima

## Motivazione
Riduce il numero di tecnologie, accelera lo sviluppo (frontend e backend condividono tipi e modelli), e permette di scalare gradualmente senza introdurre microservizi o infrastrutture complesse troppo presto.

## Alternative considerate (scartate per ora)
- FE+BE separati subito (più overhead per MVP)
- Microservizi (prematuro)
- NoSQL come DB primario (meno adatto a ordini/relazioni)
- CI/CD manuale (rischio regressioni e rilasci instabili)

## Conseguenze
- **Pro:** time-to-market rapido, codebase unica, deploy frequenti e sicuri.
- **Contro:** Next fullstack può diventare denso; mitigazione: separazione per moduli e boundary chiari (`app/`, `lib/`, `services/`).

## Collocazione nel progetto
- `docs/adr/0001-stack-cicd.md`
- (opzionale) `docs/adr/0001-stack-cicd.docx`

## Checklist di accettazione
- Repo creato con branch `main`/`develop` e protezioni
- Stack deciso e riportato qui
- CI su PR attivo e richiesto per merge
- Staging deploy automatico da `develop`
- Prod deploy controllato da `main`
