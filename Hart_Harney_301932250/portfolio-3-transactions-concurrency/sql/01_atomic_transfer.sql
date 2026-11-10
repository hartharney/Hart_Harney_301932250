-- Lagos Community Bank — Portfolio 3 atomic fund transfer
-- Hart_Harney_301932250
SET search_path TO lcb, public;

\echo '=== Balances BEFORE successful transfer ==='
SELECT account_number, balance FROM accounts
WHERE account_number IN ('1002003002', '1002003040')
ORDER BY account_number;

BEGIN;

SELECT account_id, balance
FROM accounts
WHERE account_id IN (
    '33333333-3333-3333-3333-333333333302',
    '33333333-3333-3333-3333-333333333307'
)
ORDER BY account_id
FOR UPDATE;

DO $$
DECLARE
    src_bal NUMERIC(18,2);
BEGIN
    SELECT balance INTO src_bal FROM accounts
    WHERE account_id = '33333333-3333-3333-3333-333333333302';
    IF src_bal < 7500.00 THEN
        RAISE EXCEPTION 'insufficient funds: have %, need 7500.00', src_bal;
    END IF;
END $$;

INSERT INTO transfers (transfer_id, transfer_ref, from_account_id, to_account_id, amount, status, initiated_by, requested_at, completed_at)
VALUES (
    '44444444-4444-4444-4444-444444444501',
    'TRF-P3-OK-01',
    '33333333-3333-3333-3333-333333333302',
    '33333333-3333-3333-3333-333333333307',
    7500.00,
    'posted',
    '11111111-1111-1111-1111-111111111101',
    now(),
    now()
);

UPDATE accounts SET balance = balance - 7500.00
WHERE account_id = '33333333-3333-3333-3333-333333333302';

UPDATE accounts SET balance = balance + 7500.00
WHERE account_id = '33333333-3333-3333-3333-333333333307';

INSERT INTO transactions (account_id, transfer_id, txn_type, amount, balance_after, reference, narration)
SELECT '33333333-3333-3333-3333-333333333302',
       '44444444-4444-4444-4444-444444444501',
       'transfer_debit', 7500.00, balance, 'TRF-P3-OK-01-DR', 'P3 demo debit to Zainab'
FROM accounts WHERE account_id = '33333333-3333-3333-3333-333333333302';

INSERT INTO transactions (account_id, transfer_id, txn_type, amount, balance_after, reference, narration)
SELECT '33333333-3333-3333-3333-333333333307',
       '44444444-4444-4444-4444-444444444501',
       'transfer_credit', 7500.00, balance, 'TRF-P3-OK-01-CR', 'P3 demo credit from Ada'
FROM accounts WHERE account_id = '33333333-3333-3333-3333-333333333307';

COMMIT;

\echo '=== Balances AFTER successful transfer ==='
SELECT account_number, balance FROM accounts
WHERE account_number IN ('1002003002', '1002003040')
ORDER BY account_number;
