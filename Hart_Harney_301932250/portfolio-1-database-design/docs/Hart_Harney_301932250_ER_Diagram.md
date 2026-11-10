# Lagos Community Bank — Entity-Relationship Model

**Document:** Hart_Harney_301932250_ER_Diagram  
**Portfolio:** 1 — Database Design

## Design intent

I modelled the core retail-banking surface that tellers touch every day: who the
customer is, which accounts they hold, every ledger movement, and the transfer
request that ties a debit leg to a credit leg. Staff and audit_log sit beside
the money tables so branch actions remain attributable without polluting the
ledger itself.

## Mermaid ER diagram

```mermaid
erDiagram
    STAFF ||--o{ ACCOUNTS : "opened_by"
    STAFF ||--o{ TRANSFERS : "initiated_by"
    STAFF ||--o{ AUDIT_LOG : "performs"
    CUSTOMERS ||--o{ ACCOUNTS : "owns"
    ACCOUNTS ||--o{ TRANSACTIONS : "posts"
    ACCOUNTS ||--o{ TRANSFERS : "from_account"
    ACCOUNTS ||--o{ TRANSFERS : "to_account"
    TRANSFERS ||--o{ TRANSACTIONS : "generates"

    CUSTOMERS {
        uuid customer_id PK
        text customer_number UK
        text first_name
        text last_name
        text email UK
        text phone
        text bvn_hash
        text kyc_status
        timestamptz created_at
    }

    ACCOUNTS {
        uuid account_id PK
        text account_number UK
        uuid customer_id FK
        text product_type
        text branch_code
        text currency
        numeric balance
        text status
        uuid opened_by FK
        timestamptz opened_at
    }

    TRANSACTIONS {
        bigserial txn_id PK
        uuid account_id FK
        uuid transfer_id FK
        text txn_type
        numeric amount
        numeric balance_after
        text reference UK
        text narration
        timestamptz posted_at
    }

    TRANSFERS {
        uuid transfer_id PK
        text transfer_ref UK
        uuid from_account_id FK
        uuid to_account_id FK
        numeric amount
        text status
        uuid initiated_by FK
        timestamptz requested_at
        timestamptz completed_at
    }

    STAFF {
        uuid staff_id PK
        text staff_number UK
        text full_name
        text role
        text branch_code
        boolean is_active
    }

    AUDIT_LOG {
        bigserial audit_id PK
        uuid staff_id FK
        text action
        text entity_type
        text entity_id
        jsonb detail
        timestamptz occurred_at
    }
```

## Cardinality notes

- One customer may hold many accounts (savings, current, fixed deposit).
- One account posts many ledger transactions; each transaction belongs to exactly one account.
- A transfer references exactly two accounts and, on success, produces two ledger rows
  (debit on source, credit on destination) linked by `transfer_id`.
- Staff open accounts, initiate transfers, and leave audit entries.

## Export

Render the Mermaid block above to PNG as
`screenshots/Hart_Harney_301932250_ER_Diagram.png` (see generation script in
`docs/` if needed). The same diagram is also stored under `images/` at the
portfolio root for the final summary.
