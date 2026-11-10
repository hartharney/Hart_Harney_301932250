-- Lagos Community Bank — Portfolio 1 seed data
-- Hart_Harney_301932250
SET search_path TO lcb, public;

INSERT INTO staff (staff_id, staff_number, full_name, role, branch_code) VALUES
    ('11111111-1111-1111-1111-111111111101', 'STF-001', 'Chidi Bello', 'teller', 'VI'),
    ('11111111-1111-1111-1111-111111111102', 'STF-002', 'Amaka Ude', 'teller', 'YABA'),
    ('11111111-1111-1111-1111-111111111103', 'STF-003', 'Ibrahim Sanni', 'supervisor', 'IKEJA'),
    ('11111111-1111-1111-1111-111111111104', 'STF-004', 'Ngozi Eze', 'auditor', 'HQ'),
    ('11111111-1111-1111-1111-111111111105', 'STF-005', 'Tunde Ajayi', 'teller', 'SURULERE'),
    ('11111111-1111-1111-1111-111111111106', 'STF-006', 'Fatima Yusuf', 'admin', 'HQ');

INSERT INTO customers (customer_id, customer_number, first_name, last_name, email, phone, bvn_hash, kyc_status) VALUES
    ('22222222-2222-2222-2222-222222222201', 'CUS-0001', 'Ada', 'Okeke', 'ada.okeke@example.com', '+2348010000001', 'bvn_h_ada', 'verified'),
    ('22222222-2222-2222-2222-222222222202', 'CUS-0002', 'Musa', 'Bello', 'musa.bello@example.com', '+2348010000002', 'bvn_h_musa', 'verified'),
    ('22222222-2222-2222-2222-222222222203', 'CUS-0003', 'Chioma', 'Nwosu', 'chioma.nwosu@example.com', '+2348010000003', 'bvn_h_chioma', 'verified'),
    ('22222222-2222-2222-2222-222222222204', 'CUS-0004', 'Emeka', 'Okafor', 'emeka.okafor@example.com', '+2348010000004', 'bvn_h_emeka', 'verified'),
    ('22222222-2222-2222-2222-222222222205', 'CUS-0005', 'Zainab', 'Abdullahi', 'zainab.abdullahi@example.com', '+2348010000005', 'bvn_h_zainab', 'verified'),
    ('22222222-2222-2222-2222-222222222206', 'CUS-0006', 'Tolu', 'Adeyemi', 'tolu.adeyemi@example.com', '+2348010000006', 'bvn_h_tolu', 'pending'),
    ('22222222-2222-2222-2222-222222222207', 'CUS-0007', 'Blessing', 'Okoro', 'blessing.okoro@example.com', '+2348010000007', 'bvn_h_blessing', 'verified'),
    ('22222222-2222-2222-2222-222222222208', 'CUS-0008', 'Hassan', 'Ibrahim', 'hassan.ibrahim@example.com', '+2348010000008', 'bvn_h_hassan', 'verified'),
    ('22222222-2222-2222-2222-222222222209', 'CUS-0009', 'Nneka', 'Umeh', 'nneka.umeh@example.com', '+2348010000009', 'bvn_h_nneka', 'verified'),
    ('22222222-2222-2222-2222-222222222210', 'CUS-0010', 'David', 'Ojo', 'david.ojo@example.com', '+2348010000010', 'bvn_h_david', 'verified'),
    ('22222222-2222-2222-2222-222222222211', 'CUS-0011', 'Funke', 'Balogun', 'funke.balogun@example.com', '+2348010000011', 'bvn_h_funke', 'verified'),
    ('22222222-2222-2222-2222-222222222212', 'CUS-0012', 'Ifeanyi', 'Chukwu', 'ifeanyi.chukwu@example.com', '+2348010000012', 'bvn_h_ifeanyi', 'rejected');

INSERT INTO accounts (account_id, account_number, customer_id, product_type, branch_code, balance, status, opened_by) VALUES
    ('33333333-3333-3333-3333-333333333301', '1002003001', '22222222-2222-2222-2222-222222222201', 'savings', 'VI', 150000.00, 'active', '11111111-1111-1111-1111-111111111101'),
    ('33333333-3333-3333-3333-333333333302', '1002003002', '22222222-2222-2222-2222-222222222201', 'current', 'VI', 85000.00, 'active', '11111111-1111-1111-1111-111111111101'),
    ('33333333-3333-3333-3333-333333333303', '1002003010', '22222222-2222-2222-2222-222222222202', 'current', 'IKEJA', 220000.00, 'active', '11111111-1111-1111-1111-111111111103'),
    ('33333333-3333-3333-3333-333333333304', '1002003011', '22222222-2222-2222-2222-222222222202', 'savings', 'IKEJA', 45000.00, 'active', '11111111-1111-1111-1111-111111111103'),
    ('33333333-3333-3333-3333-333333333305', '1002003020', '22222222-2222-2222-2222-222222222203', 'savings', 'YABA', 98000.00, 'active', '11111111-1111-1111-1111-111111111102'),
    ('33333333-3333-3333-3333-333333333306', '1002003030', '22222222-2222-2222-2222-222222222204', 'current', 'SURULERE', 310000.00, 'active', '11111111-1111-1111-1111-111111111105'),
    ('33333333-3333-3333-3333-333333333307', '1002003040', '22222222-2222-2222-2222-222222222205', 'savings', 'VI', 67000.00, 'active', '11111111-1111-1111-1111-111111111101'),
    ('33333333-3333-3333-3333-333333333308', '1002003050', '22222222-2222-2222-2222-222222222206', 'savings', 'YABA', 12000.00, 'frozen', '11111111-1111-1111-1111-111111111102'),
    ('33333333-3333-3333-3333-333333333309', '1002003060', '22222222-2222-2222-2222-222222222207', 'current', 'IKEJA', 54000.00, 'active', '11111111-1111-1111-1111-111111111103'),
    ('33333333-3333-3333-3333-333333333310', '1002003070', '22222222-2222-2222-2222-222222222208', 'savings', 'SURULERE', 175000.00, 'active', '11111111-1111-1111-1111-111111111105'),
    ('33333333-3333-3333-3333-333333333311', '1002003080', '22222222-2222-2222-2222-222222222209', 'fixed_deposit', 'VI', 500000.00, 'active', '11111111-1111-1111-1111-111111111101'),
    ('33333333-3333-3333-3333-333333333312', '1002003090', '22222222-2222-2222-2222-222222222210', 'current', 'YABA', 33000.00, 'active', '11111111-1111-1111-1111-111111111102'),
    ('33333333-3333-3333-3333-333333333313', '1002003100', '22222222-2222-2222-2222-222222222211', 'savings', 'IKEJA', 41000.00, 'active', '11111111-1111-1111-1111-111111111103'),
    ('33333333-3333-3333-3333-333333333314', '1002003110', '22222222-2222-2222-2222-222222222203', 'current', 'YABA', 27000.00, 'active', '11111111-1111-1111-1111-111111111102'),
    ('33333333-3333-3333-3333-333333333315', '1002003120', '22222222-2222-2222-2222-222222222204', 'savings', 'SURULERE', 90000.00, 'active', '11111111-1111-1111-1111-111111111105');

-- Opening deposits and a few early movements
INSERT INTO transactions (account_id, transfer_id, txn_type, amount, balance_after, reference, narration, posted_at) VALUES
    ('33333333-3333-3333-3333-333333333301', NULL, 'deposit', 150000.00, 150000.00, 'DEP-0001', 'Opening deposit savings Ada', '2025-10-01 09:00:00+01'),
    ('33333333-3333-3333-3333-333333333302', NULL, 'deposit', 100000.00, 100000.00, 'DEP-0002', 'Opening deposit current Ada', '2025-10-01 09:05:00+01'),
    ('33333333-3333-3333-3333-333333333303', NULL, 'deposit', 250000.00, 250000.00, 'DEP-0003', 'Opening deposit Musa current', '2025-10-01 10:00:00+01'),
    ('33333333-3333-3333-3333-333333333304', NULL, 'deposit', 45000.00, 45000.00, 'DEP-0004', 'Opening deposit Musa savings', '2025-10-01 10:10:00+01'),
    ('33333333-3333-3333-3333-333333333305', NULL, 'deposit', 98000.00, 98000.00, 'DEP-0005', 'Opening deposit Chioma', '2025-10-02 11:00:00+01'),
    ('33333333-3333-3333-3333-333333333306', NULL, 'deposit', 310000.00, 310000.00, 'DEP-0006', 'Opening deposit Emeka', '2025-10-02 12:00:00+01'),
    ('33333333-3333-3333-3333-333333333307', NULL, 'deposit', 67000.00, 67000.00, 'DEP-0007', 'Opening deposit Zainab', '2025-10-03 09:30:00+01'),
    ('33333333-3333-3333-3333-333333333308', NULL, 'deposit', 12000.00, 12000.00, 'DEP-0008', 'Opening deposit Tolu (later frozen)', '2025-10-03 14:00:00+01'),
    ('33333333-3333-3333-3333-333333333309', NULL, 'deposit', 54000.00, 54000.00, 'DEP-0009', 'Opening deposit Blessing', '2025-10-04 09:00:00+01'),
    ('33333333-3333-3333-3333-333333333310', NULL, 'deposit', 175000.00, 175000.00, 'DEP-0010', 'Opening deposit Hassan', '2025-10-04 10:00:00+01'),
    ('33333333-3333-3333-3333-333333333311', NULL, 'deposit', 500000.00, 500000.00, 'DEP-0011', 'Fixed deposit Nneka', '2025-10-05 09:00:00+01'),
    ('33333333-3333-3333-3333-333333333312', NULL, 'deposit', 33000.00, 33000.00, 'DEP-0012', 'Opening deposit David', '2025-10-05 11:00:00+01'),
    ('33333333-3333-3333-3333-333333333313', NULL, 'deposit', 41000.00, 41000.00, 'DEP-0013', 'Opening deposit Funke', '2025-10-06 09:00:00+01'),
    ('33333333-3333-3333-3333-333333333314', NULL, 'deposit', 27000.00, 27000.00, 'DEP-0014', 'Opening deposit Chioma current', '2025-10-06 10:00:00+01'),
    ('33333333-3333-3333-3333-333333333315', NULL, 'deposit', 90000.00, 90000.00, 'DEP-0015', 'Opening deposit Emeka savings', '2025-10-06 11:00:00+01'),
    ('33333333-3333-3333-3333-333333333302', NULL, 'withdrawal', 15000.00, 85000.00, 'WDR-0001', 'ATM withdrawal Ada current', '2025-10-07 16:20:00+01');

-- Posted transfers with matching ledger legs
INSERT INTO transfers (transfer_id, transfer_ref, from_account_id, to_account_id, amount, status, initiated_by, requested_at, completed_at) VALUES
    ('44444444-4444-4444-4444-444444444401', 'TRF-1001',
     '33333333-3333-3333-3333-333333333303', '33333333-3333-3333-3333-333333333301',
     25000.00, 'posted', '11111111-1111-1111-1111-111111111101',
     '2025-10-08 10:00:00+01', '2025-10-08 10:00:01+01'),
    ('44444444-4444-4444-4444-444444444402', 'TRF-1002',
     '33333333-3333-3333-3333-333333333306', '33333333-3333-3333-3333-333333333305',
     12000.00, 'posted', '11111111-1111-1111-1111-111111111105',
     '2025-10-09 11:15:00+01', '2025-10-09 11:15:01+01'),
    ('44444444-4444-4444-4444-444444444403', 'TRF-1003',
     '33333333-3333-3333-3333-333333333310', '33333333-3333-3333-3333-333333333309',
     8000.00, 'posted', '11111111-1111-1111-1111-111111111102',
     '2025-10-10 09:40:00+01', '2025-10-10 09:40:01+01'),
    ('44444444-4444-4444-4444-444444444404', 'TRF-1004',
     '33333333-3333-3333-3333-333333333301', '33333333-3333-3333-3333-333333333307',
     5000.00, 'failed', '11111111-1111-1111-1111-111111111101',
     '2025-10-11 13:00:00+01', '2025-10-11 13:00:02+01');

UPDATE transfers SET failure_reason = 'destination KYC review hold (simulated)'
 WHERE transfer_ref = 'TRF-1004';

-- Adjust balances for posted transfers to stay consistent with seed story
-- Musa current 250000 - 25000 = 225000, then we keep seed balance at 220000 after later withdrawal narrative;
-- For clarity, reset balances to match posted legs after openings:
UPDATE accounts SET balance = 175000.00 WHERE account_number = '1002003001'; -- Ada savings +25000 from Musa -5000 failed no change, wait:
-- TRF-1001: Musa current -25000, Ada savings +25000 => Ada 175000, Musa 225000
-- Then ATM already applied on Ada current. Musa later fictional 5000 fee not modelled.
-- Simpler: set final balances explicitly after legs below.

INSERT INTO transactions (account_id, transfer_id, txn_type, amount, balance_after, reference, narration, posted_at) VALUES
    ('33333333-3333-3333-3333-333333333303', '44444444-4444-4444-4444-444444444401', 'transfer_debit', 25000.00, 225000.00, 'TRF-1001-DR', 'Transfer to Ada Okeke', '2025-10-08 10:00:01+01'),
    ('33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444401', 'transfer_credit', 25000.00, 175000.00, 'TRF-1001-CR', 'Transfer from Musa Bello', '2025-10-08 10:00:01+01'),
    ('33333333-3333-3333-3333-333333333306', '44444444-4444-4444-4444-444444444402', 'transfer_debit', 12000.00, 298000.00, 'TRF-1002-DR', 'Transfer to Chioma Nwosu', '2025-10-09 11:15:01+01'),
    ('33333333-3333-3333-3333-333333333305', '44444444-4444-4444-4444-444444444402', 'transfer_credit', 12000.00, 110000.00, 'TRF-1002-CR', 'Transfer from Emeka Okafor', '2025-10-09 11:15:01+01'),
    ('33333333-3333-3333-3333-333333333310', '44444444-4444-4444-4444-444444444403', 'transfer_debit', 8000.00, 167000.00, 'TRF-1003-DR', 'Transfer to Blessing Okoro', '2025-10-10 09:40:01+01'),
    ('33333333-3333-3333-3333-333333333309', '44444444-4444-4444-4444-444444444403', 'transfer_credit', 8000.00, 62000.00, 'TRF-1003-CR', 'Transfer from Hassan Ibrahim', '2025-10-10 09:40:01+01');

UPDATE accounts SET balance = 175000.00 WHERE account_number = '1002003001';
UPDATE accounts SET balance = 85000.00  WHERE account_number = '1002003002';
UPDATE accounts SET balance = 225000.00 WHERE account_number = '1002003010';
UPDATE accounts SET balance = 45000.00  WHERE account_number = '1002003011';
UPDATE accounts SET balance = 110000.00 WHERE account_number = '1002003020';
UPDATE accounts SET balance = 298000.00 WHERE account_number = '1002003030';
UPDATE accounts SET balance = 67000.00  WHERE account_number = '1002003040';
UPDATE accounts SET balance = 12000.00  WHERE account_number = '1002003050';
UPDATE accounts SET balance = 62000.00  WHERE account_number = '1002003060';
UPDATE accounts SET balance = 167000.00 WHERE account_number = '1002003070';
UPDATE accounts SET balance = 500000.00 WHERE account_number = '1002003080';
UPDATE accounts SET balance = 33000.00  WHERE account_number = '1002003090';
UPDATE accounts SET balance = 41000.00  WHERE account_number = '1002003100';
UPDATE accounts SET balance = 27000.00  WHERE account_number = '1002003110';
UPDATE accounts SET balance = 90000.00  WHERE account_number = '1002003120';

INSERT INTO audit_log (staff_id, action, entity_type, entity_id, detail, occurred_at) VALUES
    ('11111111-1111-1111-1111-111111111101', 'OPEN_ACCOUNT', 'account', '1002003001', '{"product":"savings"}', '2025-10-01 09:00:00+01'),
    ('11111111-1111-1111-1111-111111111101', 'POST_TRANSFER', 'transfer', 'TRF-1001', '{"amount":25000}', '2025-10-08 10:00:01+01'),
    ('11111111-1111-1111-1111-111111111105', 'POST_TRANSFER', 'transfer', 'TRF-1002', '{"amount":12000}', '2025-10-09 11:15:01+01'),
    ('11111111-1111-1111-1111-111111111102', 'POST_TRANSFER', 'transfer', 'TRF-1003', '{"amount":8000}', '2025-10-10 09:40:01+01'),
    ('11111111-1111-1111-1111-111111111101', 'FAIL_TRANSFER', 'transfer', 'TRF-1004', '{"reason":"KYC hold"}', '2025-10-11 13:00:02+01'),
    ('11111111-1111-1111-1111-111111111104', 'REVIEW_BALANCE', 'account', '1002003001', '{"observed_balance":175000}', '2025-10-12 08:00:00+01'),
    ('11111111-1111-1111-1111-111111111103', 'FREEZE_ACCOUNT', 'account', '1002003050', '{"reason":"pending KYC"}', '2025-10-12 15:00:00+01'),
    ('11111111-1111-1111-1111-111111111106', 'CREATE_STAFF', 'staff', 'STF-005', '{"branch":"SURULERE"}', '2025-09-20 10:00:00+01');
