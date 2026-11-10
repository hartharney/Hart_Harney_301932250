-- Lost-update race WITHOUT SELECT FOR UPDATE (unsafe pattern)
-- Two sessions both read balance, then both write balance - amount.
SET search_path TO lcb, public;

-- Reset demo account Funke savings to a known balance
UPDATE accounts SET balance = 10000.00 WHERE account_number = '1002003100';
SELECT account_number, balance AS starting_balance FROM accounts WHERE account_number = '1002003100';
