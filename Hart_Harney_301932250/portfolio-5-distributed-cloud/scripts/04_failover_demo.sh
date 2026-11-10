#!/usr/bin/env bash
set -euo pipefail
SS="$(cd "$(dirname "$0")/.." && pwd)/screenshots"
mkdir -p "$SS"
OUT="$SS/Hart_Harney_301932250_failover.txt"
: > "$OUT"

log() { echo -e "$*" | tee -a "$OUT"; }

primary_port() {
  for p in 27017 27018 27019; do
    if mongosh --port "$p" --quiet --eval 'db.isMaster().ismaster' 2>/dev/null | grep -q true; then
      echo "$p"
      return
    fi
  done
  echo ""
}

log "=== Replica status BEFORE stepDown ==="
mongosh --port 27017 --quiet --eval 'rs.status().members.forEach(m => print(m.name + " " + m.stateStr))' | tee -a "$OUT"
PPORT=$(primary_port)
log "Current PRIMARY port: $PPORT"

log "=== Write with majority writeConcern on primary ==="
mongosh --port "$PPORT" --quiet --eval '
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
mongosh --port "$PPORT" --quiet --eval 'try { rs.stepDown(60); } catch(e) { print(String(e)); }' | tee -a "$OUT" || true

log "=== Waiting for new PRIMARY ==="
for i in $(seq 1 30); do
  STATE=$(mongosh --port 27018 --quiet --eval 'rs.status().members.map(m => m.name+":"+m.stateStr).join(", ")' 2>/dev/null || echo unavailable)
  log "poll $i: $STATE"
  if echo "$STATE" | grep -q PRIMARY; then
    break
  fi
  sleep 2
done

log "=== Replica status AFTER election ==="
mongosh --port 27018 --quiet --eval 'rs.status().members.forEach(m => print(m.name + " " + m.stateStr + " health=" + m.health))' | tee -a "$OUT"

NEW=$(primary_port)
log "New PRIMARY port: $NEW"

log "=== Write resumes on current primary ==="
mongosh --port "$NEW" --quiet --eval '
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
