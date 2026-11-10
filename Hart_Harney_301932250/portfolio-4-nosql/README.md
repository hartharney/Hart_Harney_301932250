# Portfolio 4 — NoSQL (MongoDB Transfer Events)

**Student:** Hart Harney · **ID:** 301932250

## Focus

Document model for Lagos Community Bank transfer lifecycle events, with JSON
Schema validation, sample inserts tied to the same `transfer_ref` values as
PostgreSQL, four queries, and a suitability comparison.

## Deliverables

| Artefact | Path |
| --- | --- |
| Collection + validation | [scripts/01_create_collection.js](scripts/01_create_collection.js) |
| Sample inserts | [scripts/02_sample_inserts.js](scripts/02_sample_inserts.js) |
| Queries | [scripts/03_queries.js](scripts/03_queries.js) |
| Suitability note | [docs/Hart_Harney_301932250_Suitability.md](docs/Hart_Harney_301932250_Suitability.md) |
| Evidence | [screenshots/](screenshots/) |

## Verified live

- Collection created with strict validation.
- Invalid `amount: 0` insert rejected (`Document failed validation`).
- Queries returned lifecycle for TRF-1001, failed TRF-1004, volume by channel,
  and latest status per transfer.
