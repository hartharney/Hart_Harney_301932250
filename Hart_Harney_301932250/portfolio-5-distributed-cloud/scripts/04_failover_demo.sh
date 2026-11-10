#!/usr/bin/env bash
set -euo pipefail
SS="$(cd "$(dirname "$0")/.." && pwd)/screenshots"
mkdir -p "$SS"
OUT="$SS/Hart_Harney_301932250_failover.txt"
: > "$OUT"

log() { echo -e "$*" | tee -a "$OUT"; }

log "=== Replica status BEFORE stepDown ==="
docker exec lcb-mongo1 mongosh --quiet --eval 'rs.status().members.forEach(m => print(m.name + " " + m.stateStr))' | tee -a "$OUT"

PRIMARY=$(docker exec lcb-mongo1 mongosh --quiet --eval 'rs.status().members.find(m => m.stateStr==="PRIMARY").name' | tr -d '\r')
log "Current PRIMARY: $PRIMARY"

log "=== Write with majority writeConcern on primary ==="
docker exec lcb-mongo1 mongosh --quiet --eval '
db = db.getSiblingDB("lagos_community_bank");
const r = db.transfer_events.insertOne({
  event_id: "EVT-RS-BEFORE-FAILOVER",
  transfer_ref: "TRF-RS-FAILOVER",
  from_account: "1002003001",
  to_account: "1002003010",
  amount: 999,
  currency: "NGN",
  status: "initiated",
  channel: "api",
  occurred_at: new Date()
}, { writeConcern: { w: "majority", wtimeout: 5000 }});
printjson(r);
' | tee -a "$OUT"

log "=== Step down primary (force election) ==="
docker exec lcb-mongo1 mongosh --quiet --eval 'try { rs.stepDown(60); } catch(e) { print(e); }' | tee -a "$OUT" || true

log "=== Waiting for new PRIMARY ==="
for i in $(seq 1 30); do
  STATE=$(docker exec lcb-mongo1 mongosh --quiet --eval 'rs.status().members.map(m => m.name+":"+m.stateStr).join(", ")' 2>/dev/null || echo 'unavailable')
  log "poll $i: $STATE"
  if echo "$STATE" | grep -q PRIMARY; then
    break
  fi
  sleep 2
done

log "=== Replica status AFTER election ==="
docker exec lcb-mongo2 mongosh --quiet --eval 'rs.status().members.forEach(m => print(m.name + " " + m.stateStr + " health=" + m.health))' | tee -a "$OUT" || \
docker exec lcb-mongo1 mongosh --quiet --eval 'rs.status().members.forEach(m => print(m.name + " " + m.stateStr + " health=" + m.health))' | tee -a "$OUT"

log "=== Write resumes on current primary ==="
# Discover primary container
NEW_PRIMARY_HOST=$(docker exec lcb-mongo1 mongosh --quiet --eval 'const p=rs.status().members.find(m=>m.stateStr==="PRIMARY"); print(p?p.name:"none")' 2>/dev/null | tr -d '\r' || true)
if [[ -z "${NEW_PRIMARY_HOST}" || "${NEW_PRIMARY_HOST}" == "none" ]]; then
  NEW_PRIMARY_HOST=$(docker exec lcb-mongo2 mongosh --quiet --eval 'const p=rs.status().members.find(m=>m.stateStr==="PRIMARY"); print(p?p.name:"none")' | tr -d '\r')
fi
log "New PRIMARY host: $NEW_PRIMARY_HOST"
PRIMARY_CONTAINER=$(echo "$NEW_PRIMARY_HOST" | cut -d: -f1 | sed 's/mongo/lcb-mongo/')
# mongo1 -> lcb-mongo1 mapping
case "$NEW_PRIMARY_HOST" in
  mongo1:*) PRIMARY_CONTAINER=lcb-mongo1 ;;
  mongo2:*) PRIMARY_CONTAINER=lcb-mongo2 ;;
  mongo3:*) PRIMARY_CONTAINER=lcb-mongo3 ;;
esac
log "Using container: $PRIMARY_CONTAINER"

docker exec "$PRIMARY_CONTAINER" mongosh --quiet --eval '
db = db.getSiblingDB("lagos_community_bank");
const r = db.transfer_events.insertOne({
  event_id: "EVT-RS-AFTER-FAILOVER",
  transfer_ref: "TRF-RS-FAILOVER",
  from_account: "1002003001",
  to_account: "1002003010",
  amount: 999,
  currency: "NGN",
  status: "posted",
  channel: "api",
  occurred_at: new Date()
}, { writeConcern: { w: "majority", wtimeout: 10000 }});
printjson(r);
print("count=" + db.transfer_events.countDocuments());
' | tee -a "$OUT"

log "Failover demo complete."
