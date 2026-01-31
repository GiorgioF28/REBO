# ADR 0002 — Stack Angular + Spring Boot + Postgres + Docker

**Stato:** Accettato  
**Sostituisce:** ADR 0001 (Next.js fullstack)

## Decisione
- Frontend: Angular
- Backend: Spring Boot
- DB: PostgreSQL
- Container: Docker + Docker Compose
- Tooling: Antigravity per modifiche/PR/commit

## Motivazione
- Separazione chiara FE/BE, tipica enterprise, scalabile e manutenibile.
- Docker standardizza dev e deploy.
- Postgres adatto a relazioni (locali, menu, ordini).

## Conseguenze
- CI deve buildare 2 progetti (npm + maven/gradle)
- Hosting: Vercel ok per FE, backend su host container separato.