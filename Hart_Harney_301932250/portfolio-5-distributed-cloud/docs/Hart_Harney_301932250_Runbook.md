# Portfolio 5 — Replica Set Runbook

**Document:** Hart_Harney_301932250_Runbook

## Start (host path used for evidence)

```bash
./scripts/05_run_host_replica.sh
mongosh --port 27017 scripts/02_seed_and_read.js
mongosh --port 27018 --eval '...'   # secondary read
./scripts/04_failover_demo.sh
```

## Start (Docker Compose / host network)

```bash
cd docker
docker compose up -d
mongosh --port 27017 scripts/01_init_replica_set.js
# wait for PRIMARY, then seed + failover as above
```

## Expected failover outcome

- Before: `:27017 PRIMARY`, `:27018/:27019 SECONDARY`
- `rs.stepDown(60)` on primary
- After: a former secondary becomes PRIMARY (observed `:27018`)
- Insert with `w: "majority"` succeeds on the new primary
