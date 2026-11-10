# Lagos Community Bank — Normalisation Walkthrough (1NF → 3NF)

**Document:** Hart_Harney_301932250_Normalisation  
**Portfolio:** 1 — Database Design

I started from a flat teller worksheet that a branch might keep in a spreadsheet,
then pushed it through 1NF, 2NF, and 3NF until every non-key attribute depended
only on the whole primary key.

## Unnormalised starting point

Imagine one row per teller action with repeating customer and account facts:

| transfer_ref | customer_name | customer_email | from_acct | to_acct | amount | product | branch | teller_name | teller_role |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TRF-1001 | Ada Okeke, Ada Okeke | ada@… | 1002003001 | 1002003002 | 25000 | Savings, Current | VI, Yaba | Chidi Bello | Teller |
| TRF-1002 | Musa Bello | musa@… | 1002003010 | 1002003001 | 5000 | Current | Ikeja | Amaka Ude | Teller |

Problems visible here:

- Repeating groups (two products and two branches jammed into one cell).
- Customer email and teller role stored on every transfer row.
- Updating Ada’s email would require rewriting every historical transfer.

## First Normal Form (1NF)

Atomic values, no repeating groups. Split multi-account facts into separate rows
and give each transfer a single from/to pair.

| transfer_ref | customer_id | customer_name | customer_email | from_account | to_account | amount | product_from | branch_from | staff_id | teller_name | teller_role |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TRF-1001 | C001 | Ada Okeke | ada@… | 1002003001 | 1002003002 | 25000 | Savings | VI | S01 | Chidi Bello | Teller |
| TRF-1002 | C002 | Musa Bello | musa@… | 1002003010 | 1002003001 | 5000 | Current | Ikeja | S02 | Amaka Ude | Teller |

1NF removes cell-level lists, but customer and teller attributes still ride along
with every transfer.

## Second Normal Form (2NF)

Assume a composite key such as `(transfer_ref, from_account)`. Attributes that
depend only on part of that key move out:

- `customer_name`, `customer_email` → depend on `customer_id`
- `product_from`, `branch_from` → depend on `from_account`
- `teller_name`, `teller_role` → depend on `staff_id`

Resulting relations:

1. **customers**(customer_id, customer_name, customer_email, …)
2. **accounts**(account_number, customer_id, product_type, branch_code, balance, …)
3. **staff**(staff_id, teller_name, teller_role, branch_code, …)
4. **transfers**(transfer_ref, from_account, to_account, amount, staff_id, status, …)

Partial-key dependencies are gone. Transfer rows now hold foreign keys only.

## Third Normal Form (3NF)

Remove transitive dependencies. In my draft, `branch_name` and `branch_city`
hung off `branch_code` inside accounts. I kept `branch_code` as a coded attribute
on accounts/staff (enough for this portfolio) rather than introducing a full
branches table, because city/name never appear elsewhere in the workload. If
branch master data grew, I would extract a **branches** relation next.

Ledger postings also needed their own relation. A transfer is a business request;
a transaction is an immutable money movement on one account. Keeping them separate
avoids stuffing debit and credit amounts into one wide transfer row.

Final 3NF set used in the schema:

| Relation | Primary key | Notes |
| --- | --- | --- |
| customers | customer_id | Identity and KYC status |
| accounts | account_id | Balance, product, branch |
| transactions | txn_id | Append-only ledger |
| transfers | transfer_id | Request linking two accounts |
| staff | staff_id | Teller / auditor identity |
| audit_log | audit_id | Operational attribution |

## Why this matters for the bank

Atomic fund transfers (Portfolio 3) depend on clean account and transfer keys.
Query optimisation (Portfolio 2) joins customer → account → ledger without
denormalised name columns. MongoDB events (Portfolio 4) can reference the same
`transfer_ref` without becoming the balance source of truth.
