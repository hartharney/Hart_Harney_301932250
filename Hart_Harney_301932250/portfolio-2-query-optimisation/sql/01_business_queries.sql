-- Lagos Community Bank — Portfolio 2 business queries
-- Hart_Harney_301932250
SET search_path TO lcb, public;

\echo '=== Q1: Customer → accounts → recent ledger (multi-table join) ==='
SELECT c.customer_number,
       c.first_name || ' ' || c.last_name AS customer_name,
       a.account_number,
       a.product_type,
       t.txn_type,
       t.amount,
       t.balance_after,
       t.posted_at
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
JOIN transactions t ON t.account_id = a.account_id
WHERE c.customer_number = 'CUS-0001'
ORDER BY t.posted_at DESC
LIMIT 20;

\echo '=== Q2: Date-range account statement for one account ==='
SELECT t.posted_at,
       t.reference,
       t.txn_type,
       t.amount,
       t.balance_after,
       t.narration
FROM transactions t
JOIN accounts a ON a.account_id = t.account_id
WHERE a.account_number = '1002003001'
  AND t.posted_at >= TIMESTAMPTZ '2025-10-01 00:00:00+01'
  AND t.posted_at <  TIMESTAMPTZ '2025-11-01 00:00:00+01'
ORDER BY t.posted_at;

\echo '=== Q3: Transfer volume and count by product (source account) ==='
SELECT a.product_type,
       a.branch_code,
       COUNT(*) AS transfer_count,
       SUM(tr.amount) AS total_volume
FROM transfers tr
JOIN accounts a ON a.account_id = tr.from_account_id
WHERE tr.status = 'posted'
GROUP BY a.product_type, a.branch_code
ORDER BY total_volume DESC;

\echo '=== Q4: Branch deposit balances by product ==='
SELECT branch_code,
       product_type,
       COUNT(*) AS accounts,
       SUM(balance) AS total_balance
FROM accounts
WHERE status = 'active'
GROUP BY branch_code, product_type
ORDER BY branch_code, product_type;
