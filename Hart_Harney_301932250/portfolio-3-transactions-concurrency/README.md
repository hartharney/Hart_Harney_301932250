# Portfolio 3 — Transactions & Concurrency

**Student:** Hart Harney · **ID:** 301932250

## Focus

Real Lagos Community Bank fund transfers under PostgreSQL transactions:
atomic debit/credit, rollback on failure, READ COMMITTED dual-session behaviour,
and a lost-update race with and without `SELECT FOR UPDATE`.

## Deliverables

| Artefact | Path |
| --- | --- |
| Atomic transfer | [sql/01_atomic_transfer.sql](sql/01_atomic_transfer.sql) |
| Rollback demo | [sql/01b_rollback_demo.sql](sql/01b_rollback_demo.sql) |
| Isolation sessions | [sql/02_isolation_session_a.sql](sql/02_isolation_session_a.sql), [sql/02_isolation_session_b.sql](sql/02_isolation_session_b.sql) |
| Race runner | [scripts/lost_update_race.py](scripts/lost_update_race.py) |
| Orchestrator | [scripts/run_dual_session_demos.sh](scripts/run_dual_session_demos.sh) |
| Runbook | [docs/Hart_Harney_301932250_Concurrency_Runbook.md](docs/Hart_Harney_301932250_Concurrency_Runbook.md) |
| Evidence | [screenshots/](screenshots/) |

## Live results (this machine)

- Successful transfer moved ₦7,500 with both ledger legs committed together.
- Failed oversized debit rolled back; balance unchanged.
- Isolation demo: Session A saw Session B’s commit mid-transaction on re-read.
- Unlocked race ended at **6000**; locked race ended at **3000**.
