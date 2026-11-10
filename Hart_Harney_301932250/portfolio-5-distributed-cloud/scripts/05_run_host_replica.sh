#!/usr/bin/env bash
# Fallback/local host runner for a 3-member replica set when Docker bridge
# networking cannot pass MongoDB traffic between containers.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SS="$ROOT/screenshots"
mkdir -p "$SS" /tmp/lcb-rs/{mongo1,mongo2,mongo3}
sudo chown -R mongodb:mongodb /tmp/lcb-rs

start_one() {
  local port=$1 dir=$2
  if mongosh --port "$port" --quiet --eval 'db.adminCommand({ping:1})' >/dev/null 2>&1; then
    echo "port $port already up"
    return
  fi
  sudo -u mongodb mongod --replSet lcbRS --port "$port" --dbpath "/tmp/lcb-rs/$dir" \
    --bind_ip 127.0.0.1 --fork --logpath "/tmp/lcb-rs/${dir}.log"
}

start_one 27017 mongo1
start_one 27018 mongo2
start_one 27019 mongo3
sleep 2

if ! mongosh --port 27017 --quiet --eval 'rs.status().ok' >/dev/null 2>&1; then
  mongosh --port 27017 --quiet --eval 'rs.initiate({_id:"lcbRS", members:[{_id:0,host:"127.0.0.1:27017",priority:2},{_id:1,host:"127.0.0.1:27018",priority:1},{_id:2,host:"127.0.0.1:27019",priority:1}]})'
  sleep 8
fi

mongosh --port 27017 --quiet --eval 'rs.status().members.forEach(m => print(m.name+" "+m.stateStr))' \
  | tee "$SS/Hart_Harney_301932250_replica_status.txt"
