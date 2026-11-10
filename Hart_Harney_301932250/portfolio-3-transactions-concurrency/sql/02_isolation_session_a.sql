-- Session A — READ COMMITTED isolation demo
SET search_path TO lcb, public;
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

\echo '[A] BEGIN and read Musa savings balance'
BEGIN;
SELECT account_number, balance FROM accounts WHERE account_number = '1002003011';

\echo '[A] Sleeping 5s while Session B updates and commits...'
SELECT pg_sleep(5);

\echo '[A] Re-read same row inside still-open transaction (READ COMMITTED sees B commit)'
SELECT account_number, balance FROM accounts WHERE account_number = '1002003011';

COMMIT;
\echo '[A] COMMIT done'
