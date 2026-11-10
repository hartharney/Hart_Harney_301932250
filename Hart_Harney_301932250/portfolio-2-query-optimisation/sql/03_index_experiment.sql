-- Lagos Community Bank — Portfolio 2 index experiment
-- Hart_Harney_301932250
-- Target query: statement for one account over a date range (common teller/customer view)
SET search_path TO lcb, public;

-- Drop supporting indexes so the BEFORE plan cannot cheat with Portfolio 1 indexes.
DROP INDEX IF EXISTS idx_txn_account_posted_exp;
DROP INDEX IF EXISTS idx_transactions_account_posted;
ANALYZE transactions;

\echo '=== BEFORE: EXPLAIN (ANALYZE, BUFFERS) without experimental index ==='
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT t.posted_at, t.reference, t.txn_type, t.amount, t.balance_after
FROM transactions t
WHERE t.account_id = '33333333-3333-3333-3333-333333333301'
  AND t.posted_at >= TIMESTAMPTZ '2024-03-01 00:00:00+01'
  AND t.posted_at <  TIMESTAMPTZ '2024-09-01 00:00:00+01'
ORDER BY t.posted_at;

\echo '=== Create experimental composite index ==='
CREATE INDEX idx_txn_account_posted_exp ON transactions (account_id, posted_at);

ANALYZE transactions;

\echo '=== AFTER: EXPLAIN (ANALYZE, BUFFERS) with experimental index ==='
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT t.posted_at, t.reference, t.txn_type, t.amount, t.balance_after
FROM transactions t
WHERE t.account_id = '33333333-3333-3333-3333-333333333301'
  AND t.posted_at >= TIMESTAMPTZ '2024-03-01 00:00:00+01'
  AND t.posted_at <  TIMESTAMPTZ '2024-09-01 00:00:00+01'
ORDER BY t.posted_at;
