#!/usr/bin/env bash
# Orchestrate dual-session PostgreSQL demos for Portfolio 3.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SS="$ROOT/screenshots"
SQL="$ROOT/sql"
mkdir -p "$SS"
PSQL=(sudo -u postgres psql -d lagos_community_bank -v ON_ERROR_STOP=0)

echo "=== Atomic transfer ==="
"${PSQL[@]}" -f "$SQL/01_atomic_transfer.sql" | tee "$SS/Hart_Harney_301932250_atomic_transfer.txt"

echo "=== Rollback demo ==="
"${PSQL[@]}" -f "$SQL/01b_rollback_demo.sql" > "$SS/Hart_Harney_301932250_rollback_demo.txt" 2>&1 || true
"${PSQL[@]}" -c "SET search_path TO lcb, public; SELECT account_number, balance FROM accounts WHERE account_number = '1002003090';" \
  | tee -a "$SS/Hart_Harney_301932250_rollback_demo.txt"

echo "=== Isolation dual session ==="
rm -f /tmp/p3_iso_a.txt /tmp/p3_iso_b.txt
("${PSQL[@]}" -f "$SQL/02_isolation_session_a.sql" > /tmp/p3_iso_a.txt 2>&1) &
PID_A=$!
("${PSQL[@]}" -f "$SQL/02_isolation_session_b.sql" > /tmp/p3_iso_b.txt 2>&1) &
PID_B=$!
wait $PID_A $PID_B || true
{
  echo '===== SESSION A ====='
  cat /tmp/p3_iso_a.txt
  echo
  echo '===== SESSION B ====='
  cat /tmp/p3_iso_b.txt
} | tee "$SS/Hart_Harney_301932250_isolation_dual_session.txt"

echo "=== Lost update WITHOUT FOR UPDATE ==="
"${PSQL[@]}" -c "SET search_path TO lcb, public; UPDATE accounts SET balance = 10000.00 WHERE account_number = '1002003100';"
python3 "$ROOT/scripts/lost_update_race.py" --mode unlocked | tee "$SS/Hart_Harney_301932250_lost_update_unlocked.txt"

echo "=== Lost update WITH FOR UPDATE ==="
"${PSQL[@]}" -c "SET search_path TO lcb, public; UPDATE accounts SET balance = 10000.00 WHERE account_number = '1002003100';"
python3 "$ROOT/scripts/lost_update_race.py" --mode locked | tee "$SS/Hart_Harney_301932250_lost_update_locked.txt"

echo "Done. Evidence in $SS"
