# Portfolio 3 — Concurrency Runbook

**Document:** Hart_Harney_301932250_Concurrency_Runbook

## 1. Atomic fund transfer

```bash
sudo -u postgres psql -d lagos_community_bank \
  -f sql/01_atomic_transfer.sql
```

Observed: Ada current `85000 → 77500`, Zainab savings `67000 → 74500`, with paired
ledger legs and a `posted` transfer row inside one `BEGIN … COMMIT`.

## 2. Rollback on insufficient funds

```bash
sudo -u postgres psql -d lagos_community_bank \
  -f sql/01b_rollback_demo.sql
```

Observed: `RAISE EXCEPTION insufficient funds … have 33000.00`, transaction
`ROLLBACK`, David current still `33000.00`.

## 3. READ COMMITTED isolation (two sessions)

```bash
# terminal 1
psql -d lagos_community_bank -f sql/02_isolation_session_a.sql
# terminal 2 (start within ~1s)
psql -d lagos_community_bank -f sql/02_isolation_session_b.sql
```

Or run `scripts/run_dual_session_demos.sh`. Session A read `45000`, slept,
re-read `46000` after Session B’s committed +1000 deposit — classic READ
COMMITTED behaviour (non-repeatable read across statements in one transaction).

## 4. Lost update without / with `SELECT FOR UPDATE`

```bash
python3 scripts/lost_update_race.py --mode unlocked
python3 scripts/lost_update_race.py --mode locked
```

| Mode | Final balance | Interpretation |
| --- | --- | --- |
| unlocked | **6000.00** | Both sessions read 10000; last writer wins; 3000 withdrawal lost |
| locked | **3000.00** | Row locks serialize; both withdrawals apply |

No temporary counter tables — the race is on a real account balance.
