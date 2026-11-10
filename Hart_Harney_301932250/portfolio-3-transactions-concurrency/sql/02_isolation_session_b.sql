-- Session B — concurrent updater for isolation demo
SET search_path TO lcb, public;
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

\echo '[B] Waiting 1s so Session A starts first'
SELECT pg_sleep(1);

\echo '[B] BEGIN update Musa savings (+1000 deposit)'
BEGIN;
UPDATE accounts
SET balance = balance + 1000.00
WHERE account_number = '1002003011'
RETURNING account_number, balance;

INSERT INTO transactions (account_id, txn_type, amount, balance_after, reference, narration)
SELECT account_id, 'deposit', 1000.00, balance, 'P3-ISO-DEP-01', 'Isolation demo deposit'
FROM accounts WHERE account_number = '1002003011';

COMMIT;
\echo '[B] COMMIT finished — Session A should now see 46000 on re-read'
