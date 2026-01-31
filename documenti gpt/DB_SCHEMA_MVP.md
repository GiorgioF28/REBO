# Rebo — Database (PostgreSQL) MVP

**Scope:** documentare cosa abbiamo creato finora nel database (schema MVP + seed), come è stato creato, e cosa manca per renderlo “production-ready”.

---

## 1) Stato attuale (cosa abbiamo fatto)

### Ambiente
- **DB:** PostgreSQL (in Docker / docker-compose)
- **Client:** DBeaver per eseguire script SQL e ispezionare tabelle/relazioni

### Azioni eseguite
1. **Creazione schema MVP (V1)**
   - Eseguito uno script SQL “V1” come **Execute Script** in DBeaver (non singolo statement).
   - Lo script fa **reset dello schema `public`** (dev only) e ricrea tutte le tabelle con vincoli e indici base.
2. **Popolamento dati demo (V2)**
   - Eseguito uno script di seed (V2).
   - È stato eseguito due volte: sono comparsi duplicati con `id` diversi.
3. **Pulizia duplicati**
   - Duplicati ripuliti manualmente (approccio dev).
   - In futuro rendiamo V2 **idempotente** (vedi checklist).

---

## 2) Schema MVP: tabelle e relazioni

### Vista d’insieme (domini)
- **Identity & access**: `users`
- **Locali**: `locales`, `locale_staff`, `locale_pages`, `locale_regulars`
- **Menu**: `menu_categories`, `products`
- **Ordini**: `orders`, `order_items`
- **Feedback**: `reviews`
- **Media**: `images`

---

## 3) Dettaglio tabelle

> Nota: i campi “created_at / updated_at” sono timestamp per audit base.
> Il DB usa PK `BIGSERIAL` per tutte le entità principali.

### 3.1 `users`
**Scopo:** utenti dell’app (cliente, owner, staff, admin)

**Campi principali**
- `id` (PK)
- `email` (UNIQUE, NOT NULL)
- `display_name` (NULL)
- `role` (NOT NULL, default `CUSTOMER`, check: `CUSTOMER|OWNER|STAFF|ADMIN`)
- `created_at`, `updated_at`

**Vincoli**
- `UNIQUE(email)`
- check su `role`

---

### 3.2 `locales`
**Scopo:** locali / attività

**Campi principali**
- `id` (PK)
- `name` (NOT NULL)
- `address` (NULL)
- `lat`, `lng` (NULL)
- `owner_user_id` (FK → `users.id`, ON DELETE RESTRICT)
- `created_at`, `updated_at`

**Indici**
- `idx_locales_owner(owner_user_id)`

---

### 3.3 `locale_staff`
**Scopo:** associazione staff ↔ locale (molti-a-molti)

**Campi principali**
- `locale_id` (FK → `locales.id`, ON DELETE CASCADE)
- `user_id` (FK → `users.id`, ON DELETE CASCADE)
- `staff_role` (default `STAFF`, check: `STAFF|MANAGER`)
- `created_at`

**Vincoli**
- `PRIMARY KEY(locale_id, user_id)`

---

### 3.4 `menu_categories`
**Scopo:** categorie menu per locale

**Campi principali**
- `id` (PK)
- `locale_id` (FK → `locales.id`, ON DELETE CASCADE)
- `name` (NOT NULL)
- `sort_order` (default 0)
- `created_at`

**Vincoli / Indici**
- `UNIQUE(locale_id, name)`
- `idx_menu_categories_locale(locale_id)`

---

### 3.5 `products`
**Scopo:** prodotti menu

**Campi principali**
- `id` (PK)
- `locale_id` (FK → `locales.id`, ON DELETE CASCADE)
- `category_id` (FK → `menu_categories.id`, ON DELETE SET NULL)
- `name` (NOT NULL)
- `description` (NULL)
- `price_cents` (NOT NULL, check >= 0)
- `image_url` (NULL) *(nota: in futuro preferire `images`)*
- `is_available` (default TRUE)
- `sort_order` (default 0)
- `created_at`, `updated_at`

**Vincoli / Indici**
- `UNIQUE(locale_id, name)`
- `idx_products_locale(locale_id)`
- `idx_products_category(category_id)`

---

### 3.6 `orders`
**Scopo:** ordini/comande

**Campi principali**
- `id` (PK)
- `locale_id` (FK → `locales.id`, ON DELETE RESTRICT)
- `user_id` (FK → `users.id`, ON DELETE RESTRICT)
- `status` (default `DRAFT`, check: `DRAFT|SUBMITTED|ACCEPTED|COMPLETED|CANCELED`)
- `total_cents` (default 0, check >=0)
- `submitted_at` (NULL)
- `created_at`, `updated_at`

**Indici**
- `idx_orders_locale(locale_id)`
- `idx_orders_user(user_id)`
- `idx_orders_status(status)`

---

### 3.7 `order_items`
**Scopo:** righe ordine (prodotti acquistati)

**Campi principali**
- `id` (PK)
- `order_id` (FK → `orders.id`, ON DELETE CASCADE)
- `product_id` (FK → `products.id`, ON DELETE RESTRICT)
- `quantity` (check > 0)
- `unit_cents` (check >= 0)
- `line_cents` (check >= 0)
- `created_at`

**Vincoli / Indici**
- `UNIQUE(order_id, product_id)` *(una riga per prodotto per ordine)*
- `idx_order_items_order(order_id)`

---

### 3.8 `reviews`
**Scopo:** recensioni locali (semplice: positivo/negativo + note)

**Campi principali**
- `id` (PK)
- `locale_id` (FK → `locales.id`, ON DELETE CASCADE)
- `user_id` (FK → `users.id`, ON DELETE RESTRICT)
- `is_positive` (NOT NULL)
- `note` (NULL)
- `created_at`

**Indici**
- `idx_reviews_locale(locale_id)`
- `idx_reviews_user(user_id)`

---

### 3.9 `locale_regulars`
**Scopo:** “regular/follow” tra user e locale

**Campi principali**
- `locale_id` (FK → `locales.id`, ON DELETE CASCADE)
- `user_id` (FK → `users.id`, ON DELETE CASCADE)
- `created_at`

**Vincoli**
- `PRIMARY KEY(locale_id, user_id)`

---

### 3.10 `locale_pages`
**Scopo:** contenuto pagina del locale (testo markdown)

**Campi principali**
- `locale_id` (PK + FK → `locales.id`, ON DELETE CASCADE)
- `content_md` (default '')
- `updated_at`

---

### 3.11 `images`
**Scopo:** immagini “polimorfiche” collegate a più tipi di entità

**Campi principali**
- `id` (PK)
- `owner_type` (NOT NULL, check: `LOCALE|PRODUCT|USER`)
- `owner_id` (NOT NULL)
- `url` (NOT NULL)
- `alt` (NULL)
- `sort_order` (default 0)
- `created_at`

**Indici**
- `idx_images_owner(owner_type, owner_id)`

**Nota importante (technical debt):**
`owner_id` non è una FK reale perché è polimorfico: per ora va bene in MVP, ma in futuro va gestito meglio (vedi checklist).

---

## 4) Checklist: cosa manca / cosa fare “bene” in futuro

### A) Versioning serio dello schema (OBBLIGATORIO)
- [ ] Spostare V1 e V2 nel backend con **Flyway** (o Liquibase)
  - `backend/src/main/resources/db/migration/V1__init.sql`
  - `.../V2__seed_dev.sql`
- [ ] Disattivare in prod lo “schema reset” (niente `DROP SCHEMA` in migrazioni reali)

### B) Seed idempotente (evita doppioni)
- [ ] Rendere V2 idempotente con `ON CONFLICT DO NOTHING` dove possibile
- [ ] Aggiungere vincoli `UNIQUE` su business key dove serve
  - es: su `locales` valutare `UNIQUE(owner_user_id, name)` oppure includere `address`

### C) Integrità dati & business rules
- [ ] Calcolo `total_cents` dell’ordine
  - opzione 1: calcolato in backend (source of truth)
  - opzione 2: trigger DB che ricalcola su insert/update/delete di `order_items`
- [ ] Vincolo “recensione unica per user+locale” (se desiderato)
  - `UNIQUE(locale_id, user_id)` su `reviews`

### D) Migliorare il modello immagini (polymorphic)
Scegliere uno di questi approcci:
- [ ] **Tabelle specifiche**: `locale_images(locale_id, image_id)`, `product_images(...)` ecc. (integrità FK reale)
- [ ] Tenere `images(owner_type, owner_id)` ma aggiungere verifiche lato applicazione + cleanup job

### E) Soft delete / archiviazione
- [ ] Aggiungere `deleted_at` a `products` e forse `locales` (se volete “archiviare”)
- [ ] Politica di cancellazione (GDPR / audit): cosa si può cancellare davvero?

### F) Tipi e normalizzazione
- [ ] Valutare `ENUM` Postgres per `role`, `order.status`, `images.owner_type` (oppure continuare con check constraint)
- [ ] Se serve full-text search su locale/prodotti: `GIN` + `to_tsvector(...)`

### G) Performance
- [ ] Indici aggiuntivi guidati da query reali (non “a caso”)
  - es: `orders(locale_id, created_at)` se filtrate per locale e data
- [ ] Analizzare query lente con `EXPLAIN ANALYZE` quando avremo traffico

### H) Sicurezza & accesso
- [ ] Definire ruoli applicativi (owner/staff/customer) in backend e relative policy
- [ ] Stabilire chi può leggere/modificare `locale_pages`, `products`, `orders` ecc.

---

## 5) Comandi e procedure operative (dev)

### Vedere le tabelle in DBeaver
- Dopo DDL (CREATE/DROP), fare **Refresh** su `Schemas → public` (o F5).
- Eseguire script completi con “Execute Script” (non singolo statement).

### Ripartire da zero (DEV)
Se vuoi azzerare dati e riprovare seed:
- opzione hard: rilanciare V1 (fa già `DROP SCHEMA public CASCADE`)
- opzione soft: `TRUNCATE ... RESTART IDENTITY CASCADE;` (senza cambiare schema)

---

## 6) “Definition of Done” del DB MVP
- [x] Schema V1 creato e visibile in DBeaver
- [x] Seed V2 eseguito con dati demo
- [x] Duplicati ripuliti
- [ ] Migrazioni Flyway in repo (prossimo step)
- [ ] Seed idempotente (prossimo step)
