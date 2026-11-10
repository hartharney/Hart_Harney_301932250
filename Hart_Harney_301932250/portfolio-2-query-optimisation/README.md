# Portfolio 2 — Query Optimisation

**Student:** Hart Harney · **ID:** 301932250

## Focus

Business SQL for Lagos Community Bank, a ~30k-row synthetic ledger load, and a
measured `EXPLAIN (ANALYZE, BUFFERS)` before/after a composite index on
`(account_id, posted_at)`.

## Deliverables

| Artefact | Path |
| --- | --- |
| Business queries | [sql/01_business_queries.sql](sql/01_business_queries.sql) |
| Synthetic load | [sql/02_load_synthetic_ledger.sql](sql/02_load_synthetic_ledger.sql) |
| Index experiment | [sql/03_index_experiment.sql](sql/03_index_experiment.sql) |
| Analysis | [docs/Hart_Harney_301932250_Performance_Analysis.md](docs/Hart_Harney_301932250_Performance_Analysis.md) |
| Evidence | [screenshots/](screenshots/) |

## Result summary

- Ledger rows after load: **30,022**
- BEFORE plan: sequential scan (median ≈ **1.842 ms**)
- AFTER plan: bitmap index scan on `(account_id, posted_at)` (median ≈ **0.201 ms**)

See the analysis document for plan excerpts and trade-offs.
