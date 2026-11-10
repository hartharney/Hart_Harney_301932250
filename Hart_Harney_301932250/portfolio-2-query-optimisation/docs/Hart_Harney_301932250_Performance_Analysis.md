# Portfolio 2 — Query Optimisation Analysis

**Document:** Hart_Harney_301932250_Performance_Analysis  
**Case:** Lagos Community Bank account statement over a date range

## Workload

I loaded 30,000 synthetic ledger rows on top of the Portfolio 1 seed (30,022
total `transactions` rows). The measured query fetches one account’s statement
between 1 Mar 2024 and 1 Sep 2024 — the shape a customer or teller uses daily.

```sql
SELECT t.posted_at, t.reference, t.txn_type, t.amount, t.balance_after
FROM transactions t
WHERE t.account_id = '33333333-3333-3333-3333-333333333301'
  AND t.posted_at >= TIMESTAMPTZ '2024-03-01 00:00:00+01'
  AND t.posted_at <  TIMESTAMPTZ '2024-09-01 00:00:00+01'
ORDER BY t.posted_at;
```

For a fair BEFORE plan I dropped the Portfolio 1 helper index
`idx_transactions_account_posted` so only the primary key remained.

## Plan shape

| Phase | Plan | Notable buffers |
| --- | --- | --- |
| BEFORE | Seq Scan on `transactions` → Sort | shared hit ≈ 462; removed 29,372 rows by filter |
| AFTER | Bitmap Index Scan on `(account_id, posted_at)` → Bitmap Heap Scan → Sort | shared hit/read ≈ 195; index condition selects ~650 rows |

AFTER execution time from `EXPLAIN (ANALYZE, BUFFERS)` fell from **2.410 ms** to
**0.456 ms** on the captured run. The planner stopped reading nearly the whole
heap just to discard most rows.

## Median wall-clock timings (`\timing`)

Five warm runs of an equivalent `COUNT(*)` filter (same predicates):

| Phase | Run times (ms) | Median |
| --- | --- | --- |
| BEFORE (seq scan) | 2.268, 1.909, 1.788, 1.775, 1.842 | **1.842 ms** |
| AFTER (index) | 0.568, 0.215, 0.201, 0.179, 0.196 | **0.201 ms** |

Roughly a **9×** median improvement on this machine for a 30k-row ledger. Absolute
milliseconds are small because the table still fits in shared buffers; the
important change is plan shape and buffer traffic, which will dominate once the
ledger grows into millions of postings.

## Trade-offs

- The composite index speeds statement and transfer-history lookups by account
  and time — the bank’s hottest read path.
- Write cost rises slightly on every ledger insert; that is acceptable because
  postings are append-only and already transactional.
- I would not index every filter column on `transactions`; product/branch
  aggregates are better served by pre-aggregations or covering indexes only if
  reporting SLAs demand it.

Evidence files: `screenshots/Hart_Harney_301932250_explain_before_after.*` and
`screenshots/Hart_Harney_301932250_timing_median.*`.
