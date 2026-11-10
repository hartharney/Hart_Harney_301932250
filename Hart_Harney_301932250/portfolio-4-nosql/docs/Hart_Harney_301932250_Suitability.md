# Portfolio 4 — Relational Ledger vs Document Event Store

**Document:** Hart_Harney_301932250_Suitability

## What each store owns

| Concern | PostgreSQL (`transactions` / `accounts`) | MongoDB (`transfer_events`) |
| --- | --- | --- |
| Balances | Source of truth | Never authoritative |
| Debit/credit atomicity | Multi-row ACID transaction | Eventual narrative of what happened |
| Transfer lifecycle | Status column on `transfers` | Append-only initiated → posted/failed docs |
| Flexible metadata | Possible via JSONB, but ledger stays narrow | Natural home for channel, device, notes |
| Statement queries | Strong joins and indexes | Secondary analytics / ops timelines |

## Why I kept money in PostgreSQL

A retail bank cannot afford a document that “says” a transfer posted while the
account balances disagree. Portfolio 3 showed that debit and credit must commit
together under row locks. That is a relational strength: constraints, foreign
keys, and `SELECT FOR UPDATE` protect customer funds.

## Why MongoDB still earns a place

Transfer ops teams ask different questions: “show me every status change for
TRF-1004”, “which USSD transfers failed today”, “what metadata arrived from
mobile”. Document events let me store uneven payloads (device id, KYC flags,
retry hints) without widening the ledger schema. Aggregation pipelines answered
posted volume by channel in one pass.

## Hybrid rule I would run in production

1. PostgreSQL posts the money movement.
2. Only after commit, emit a `posted` (or `failed`) event into MongoDB.
3. Consumers read Mongo for timelines and alerts; they never update balances.

Portfolio 5 then replicates those events for read availability, while PostgreSQL
keeps its own HA story for the ledger.
