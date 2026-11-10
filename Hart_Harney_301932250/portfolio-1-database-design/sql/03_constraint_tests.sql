-- Lagos Community Bank — Portfolio 1 constraint failure tests
-- Hart_Harney_301932250
-- Each block is expected to FAIL. Capture the error text as evidence.
SET search_path TO lcb, public;

\echo '=== TEST 1: duplicate account_number (UNIQUE) ==='
INSERT INTO accounts (account_number, customer_id, product_type, branch_code, balance, status)
VALUES (
    '1002003001',
    '22222222-2222-2222-2222-222222222201',
    'savings', 'VI', 0, 'active'
);

\echo '=== TEST 2: negative balance (CHECK) ==='
INSERT INTO accounts (account_number, customer_id, product_type, branch_code, balance, status)
VALUES (
    '1002999999',
    '22222222-2222-2222-2222-222222222201',
    'savings', 'VI', -10.00, 'active'
);

\echo '=== TEST 3: transfer amount <= 0 (CHECK) ==='
INSERT INTO transfers (transfer_ref, from_account_id, to_account_id, amount, status)
VALUES (
    'TRF-BAD-AMT',
    '33333333-3333-3333-3333-333333333301',
    '33333333-3333-3333-3333-333333333302',
    0,
    'initiated'
);

\echo '=== TEST 4: same from/to account (CHECK) ==='
INSERT INTO transfers (transfer_ref, from_account_id, to_account_id, amount, status)
VALUES (
    'TRF-BAD-SAME',
    '33333333-3333-3333-3333-333333333301',
    '33333333-3333-3333-3333-333333333301',
    100.00,
    'initiated'
);

\echo '=== TEST 5: invalid FK customer_id ==='
INSERT INTO accounts (account_number, customer_id, product_type, branch_code, balance, status)
VALUES (
    '1002888888',
    '99999999-9999-9999-9999-999999999999',
    'savings', 'VI', 0, 'active'
);

\echo '=== TEST 6: invalid kyc_status ==='
INSERT INTO customers (customer_number, first_name, last_name, email, phone, bvn_hash, kyc_status)
VALUES (
    'CUS-BAD', 'Bad', 'Status', 'bad@example.com', '+2348099999999', 'x', 'unknown'
);

\echo '=== All constraint tests attempted ==='
