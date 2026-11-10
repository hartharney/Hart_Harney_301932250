# Portfolio 5 — Distributed / Cloud (Live MongoDB Replica Set)

**Student:** Hart Harney · **ID:** 301932250

## Focus

A **live** three-member MongoDB replica set for Lagos Community Bank
`transfer_events`: primary write, secondary read, controlled failover with
evidence, plus architecture notes on majority writes, lag, sharding, and why
PostgreSQL still needs its own HA.

## Deliverables

| Artefact | Path |
| --- | --- |
| Compose | [docker/docker-compose.yml](docker/docker-compose.yml) |
| Init / seed / failover scripts | [scripts/](scripts/) |
| Architecture | [docs/Hart_Harney_301932250_Architecture.md](docs/Hart_Harney_301932250_Architecture.md) |
| Runbook | [docs/Hart_Harney_301932250_Runbook.md](docs/Hart_Harney_301932250_Runbook.md) |
| Evidence | [screenshots/](screenshots/) |

## Live verification summary

| Check | Result |
| --- | --- |
| Members | `27017 PRIMARY`, `27018 SECONDARY`, `27019 SECONDARY` |
| Primary write | 2 seed events inserted |
| Secondary read | `hello.secondary=true`, count=2 |
| Failover | stepDown → `27018 PRIMARY`; post-failover majority write OK (count=4) |
