# Portfolio 1 — Database Design (Lagos Community Bank)

**Student:** Hart Harney · **ID:** 301932250

## What this portfolio shows

I designed a relational model for a fictional retail bank: customers, deposit
accounts, an append-only ledger, transfer requests, staff, and audit entries.
The schema is loaded into PostgreSQL with realistic seed data and deliberate
constraint-failure tests.

## Deliverables

| Artefact | Path |
| --- | --- |
| ER diagram (Mermaid + PNG) | [docs/Hart_Harney_301932250_ER_Diagram.md](docs/Hart_Harney_301932250_ER_Diagram.md), [screenshots/Hart_Harney_301932250_ER_Diagram.png](screenshots/Hart_Harney_301932250_ER_Diagram.png) |
| Normalisation 1NF→3NF | [docs/Hart_Harney_301932250_Normalisation.md](docs/Hart_Harney_301932250_Normalisation.md) |
| Schema | [sql/01_schema.sql](sql/01_schema.sql) |
| Seed data | [sql/02_seed.sql](sql/02_seed.sql) |
| Constraint tests | [sql/03_constraint_tests.sql](sql/03_constraint_tests.sql) |
| Evidence | [screenshots/](screenshots/) |

## How I loaded and verified

```bash
sudo -u postgres psql -c "CREATE DATABASE lagos_community_bank;"
sudo -u postgres psql -d lagos_community_bank -f sql/01_schema.sql
sudo -u postgres psql -d lagos_community_bank -f sql/02_seed.sql
sudo -u postgres psql -d lagos_community_bank -c '\d lcb.accounts'
sudo -u postgres psql -d lagos_community_bank -f sql/03_constraint_tests.sql
```

Seed counts captured live: 12 customers, 15 accounts, 22 ledger rows, 4 transfers,
6 staff, 8 audit events. All six constraint probes failed with the expected
UNIQUE / CHECK / FK errors (see `screenshots/Hart_Harney_301932250_constraint_failures.png`).

## Design choices worth noting

- Balances live on `accounts` but every money movement is also recorded in
  `transactions` so statements and audits do not invent history.
- `transfers` is the business request; successful posting creates paired debit
  and credit ledger rows linked by `transfer_id`.
- `balance >= 0` and `amount > 0` are enforced in the database, not only in app code.
