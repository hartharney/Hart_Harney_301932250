-- Demonstrate ROLLBACK when funds are insufficient
SET search_path TO lcb, public;

\echo '=== David current balance before failed attempt ==='
SELECT account_number, balance FROM accounts WHERE account_number = '1002003090';

BEGIN;

SELECT balance FROM accounts
WHERE account_id = '33333333-3333-3333-3333-333333333312'
FOR UPDATE;

DO $$
DECLARE
    src_bal NUMERIC(18,2);
BEGIN
    SELECT balance INTO src_bal FROM accounts
    WHERE account_id = '33333333-3333-3333-3333-333333333312';
    IF src_bal < 999999.00 THEN
        RAISE EXCEPTION 'insufficient funds for TRF-P3-FAIL-01: have %', src_bal;
    END IF;
    UPDATE accounts
    SET balance = balance - 999999.00
    WHERE account_id = '33333333-3333-3333-3333-333333333312';
END $$;

COMMIT;
