# Lagos Community Bank — MIT 8103 Database Portfolio

**Student:** Hart Harney · **ID:** 301932250  
**Repository:** [github.com/hartharney/Hart_Harney_301932250](https://github.com/hartharney/Hart_Harney_301932250)

## Case study

Lagos Community Bank is a fictional Nigerian retail bank that serves walk-in customers
and branch tellers. The platform must keep customer identity, deposit accounts, a
double-entry ledger, and fund transfers consistent under concurrent teller activity.

| Dimension | Detail |
| --- | --- |
| Organisation | Lagos Community Bank (fictional retail bank) |
| Users | Customers, branch tellers, and back-office auditors |
| Major data | Customers, accounts, ledger transactions, transfer requests, staff/audit records |
| Key operations | Open account, deposit/withdraw, atomic fund transfer, reverse failed transfer, audit balances |

PostgreSQL is the source of truth for balances and ledger rows. MongoDB stores
transfer lifecycle event documents for operational audit and fan-out reads. Portfolio 5
demonstrates a live three-member MongoDB replica set with controlled failover.

## Portfolios

| # | Folder | Focus |
| --- | --- | --- |
| 1 | [portfolio-1-database-design](portfolio-1-database-design/) | ER model, normalisation, PostgreSQL schema, seed, constraints |
| 2 | [portfolio-2-query-optimisation](portfolio-2-query-optimisation/) | Business SQL, synthetic load, `EXPLAIN (ANALYZE, BUFFERS)` |
| 3 | [portfolio-3-transactions-concurrency](portfolio-3-transactions-concurrency/) | Atomic transfer, isolation, `SELECT FOR UPDATE` |
| 4 | [portfolio-4-nosql](portfolio-4-nosql/) | MongoDB transfer-event documents and suitability |
| 5 | [portfolio-5-distributed-cloud](portfolio-5-distributed-cloud/) | Live replica set, failover, architecture |

## Final documentation

- [Hart_Harney_301932250_FinalSummary.md](Hart_Harney_301932250_FinalSummary.md)
- PDF export (added with final docs)

## How to run (high level)

1. PostgreSQL 16 for Portfolios 1–3 (`sql/` scripts under each portfolio folder).
2. MongoDB 7+ for Portfolios 4–5.
3. Docker Compose under `portfolio-5-distributed-cloud/docker/` for the three-member replica set.

Evidence screenshots and captured plans live in each portfolio’s `screenshots/` folder.
