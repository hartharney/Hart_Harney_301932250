-- Lagos Community Bank — Portfolio 2 synthetic ledger load (~30k rows)
-- Hart_Harney_301932250
SET search_path TO lcb, public;

-- Remove prior synthetic rows if re-running
DELETE FROM transactions WHERE reference LIKE 'SYN-%';

WITH acct AS (
    SELECT array_agg(account_id ORDER BY account_number) AS ids,
           array_agg(balance ORDER BY account_number) AS bals
    FROM accounts
),
gen AS (
    SELECT g,
           ((g - 1) % array_length(acct.ids, 1)) + 1 AS idx
    FROM generate_series(1, 30000) AS g
    CROSS JOIN acct
)
INSERT INTO transactions (account_id, transfer_id, txn_type, amount, balance_after, reference, narration, posted_at)
SELECT
    acct.ids[gen.idx],
    NULL,
    CASE WHEN gen.g % 5 = 0 THEN 'withdrawal' ELSE 'deposit' END,
    ROUND((50 + (gen.g % 5000))::numeric, 2),
    GREATEST(acct.bals[gen.idx], 0),
    'SYN-' || lpad(gen.g::text, 6, '0'),
    'Synthetic load row ' || gen.g::text,
    TIMESTAMPTZ '2024-01-01 00:00:00+01'
        + ((gen.g % 600) || ' days')::interval
        + (((gen.g * 17) % 86400) || ' seconds')::interval
FROM gen
CROSS JOIN acct;

\echo '=== Synthetic load complete ==='
SELECT COUNT(*) AS ledger_rows FROM transactions;
SELECT COUNT(*) AS synthetic_rows FROM transactions WHERE reference LIKE 'SYN-%';
SELECT MIN(posted_at) AS earliest, MAX(posted_at) AS latest FROM transactions WHERE reference LIKE 'SYN-%';
