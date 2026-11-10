-- Lagos Community Bank — Portfolio 1 schema
-- Hart_Harney_301932250
-- PostgreSQL 16

DROP SCHEMA IF EXISTS lcb CASCADE;
CREATE SCHEMA lcb;
SET search_path TO lcb, public;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE staff (
    staff_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    staff_number  TEXT NOT NULL UNIQUE,
    full_name     TEXT NOT NULL,
    role          TEXT NOT NULL CHECK (role IN ('teller', 'supervisor', 'auditor', 'admin')),
    branch_code   TEXT NOT NULL,
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE customers (
    customer_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_number  TEXT NOT NULL UNIQUE,
    first_name       TEXT NOT NULL,
    last_name        TEXT NOT NULL,
    email            TEXT NOT NULL UNIQUE,
    phone            TEXT NOT NULL,
    bvn_hash         TEXT NOT NULL,
    kyc_status       TEXT NOT NULL CHECK (kyc_status IN ('pending', 'verified', 'rejected')),
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE accounts (
    account_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_number  TEXT NOT NULL UNIQUE,
    customer_id     UUID NOT NULL REFERENCES customers(customer_id),
    product_type    TEXT NOT NULL CHECK (product_type IN ('savings', 'current', 'fixed_deposit')),
    branch_code     TEXT NOT NULL,
    currency        CHAR(3) NOT NULL DEFAULT 'NGN',
    balance         NUMERIC(18, 2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
    status          TEXT NOT NULL CHECK (status IN ('active', 'frozen', 'closed')),
    opened_by       UUID REFERENCES staff(staff_id),
    opened_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE transfers (
    transfer_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transfer_ref      TEXT NOT NULL UNIQUE,
    from_account_id   UUID NOT NULL REFERENCES accounts(account_id),
    to_account_id     UUID NOT NULL REFERENCES accounts(account_id),
    amount            NUMERIC(18, 2) NOT NULL CHECK (amount > 0),
    status            TEXT NOT NULL CHECK (status IN ('initiated', 'posted', 'failed', 'reversed')),
    initiated_by      UUID REFERENCES staff(staff_id),
    failure_reason    TEXT,
    requested_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at      TIMESTAMPTZ,
    CONSTRAINT transfers_distinct_accounts CHECK (from_account_id <> to_account_id)
);

CREATE TABLE transactions (
    txn_id         BIGSERIAL PRIMARY KEY,
    account_id     UUID NOT NULL REFERENCES accounts(account_id),
    transfer_id    UUID REFERENCES transfers(transfer_id),
    txn_type       TEXT NOT NULL CHECK (txn_type IN ('deposit', 'withdrawal', 'transfer_debit', 'transfer_credit', 'reversal')),
    amount         NUMERIC(18, 2) NOT NULL CHECK (amount > 0),
    balance_after  NUMERIC(18, 2) NOT NULL CHECK (balance_after >= 0),
    reference      TEXT NOT NULL UNIQUE,
    narration      TEXT NOT NULL,
    posted_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE audit_log (
    audit_id     BIGSERIAL PRIMARY KEY,
    staff_id     UUID REFERENCES staff(staff_id),
    action       TEXT NOT NULL,
    entity_type  TEXT NOT NULL,
    entity_id    TEXT NOT NULL,
    detail       JSONB NOT NULL DEFAULT '{}'::jsonb,
    occurred_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_transactions_account_posted ON transactions(account_id, posted_at DESC);
CREATE INDEX idx_transfers_status ON transfers(status);
CREATE INDEX idx_audit_staff ON audit_log(staff_id, occurred_at DESC);

COMMENT ON TABLE customers IS 'Retail customers of Lagos Community Bank';
COMMENT ON TABLE accounts IS 'Deposit accounts; balance is maintained transactionally';
COMMENT ON TABLE transactions IS 'Append-only ledger of money movements';
COMMENT ON TABLE transfers IS 'Fund-transfer requests linking debit and credit legs';
