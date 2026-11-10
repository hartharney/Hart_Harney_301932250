#!/usr/bin/env python3
"""Dual-session lost-update demo against Lagos Community Bank accounts."""
from __future__ import annotations

import argparse
import subprocess
import threading
import time


ACCOUNT = "1002003100"
BASE = ["sudo", "-u", "postgres", "psql", "-d", "lagos_community_bank", "-v", "ON_ERROR_STOP=1", "-At", "-F", ","]


def psql_val(sql: str) -> str:
    result = subprocess.run(
        BASE + ["-c", sql],
        check=True,
        capture_output=True,
        text=True,
    )
    lines = [ln for ln in result.stdout.strip().splitlines() if ln and ln != "SET"]
    return lines[-1] if lines else ""


def worker(name: str, withdraw: float, mode: str, barrier: threading.Barrier, log: list[str]) -> None:
    barrier.wait()
    if mode == "unlocked":
        bal = float(
            psql_val(
                "SET search_path TO lcb, public; "
                f"SELECT balance FROM accounts WHERE account_number = '{ACCOUNT}';"
            )
        )
        log.append(f"[{name}] READ balance={bal:.2f} (no lock)")
        time.sleep(0.5)
        new_bal = bal - withdraw
        psql_val(
            "SET search_path TO lcb, public; "
            f"UPDATE accounts SET balance = {new_bal:.2f} "
            f"WHERE account_number = '{ACCOUNT}'; "
            f"SELECT balance FROM accounts WHERE account_number = '{ACCOUNT}';"
        )
        log.append(f"[{name}] WRITE balance={new_bal:.2f} after withdrawing {withdraw:.2f}")
    else:
        script = f"""
SET search_path TO lcb, public;
BEGIN;
SELECT balance FROM accounts WHERE account_number = '{ACCOUNT}' FOR UPDATE;
SELECT pg_sleep(0.5);
UPDATE accounts
SET balance = balance - {withdraw:.2f}
WHERE account_number = '{ACCOUNT}'
RETURNING balance;
COMMIT;
"""
        result = subprocess.run(
            ["sudo", "-u", "postgres", "psql", "-d", "lagos_community_bank", "-v", "ON_ERROR_STOP=1"],
            input=script,
            capture_output=True,
            text=True,
            check=True,
        )
        log.append(f"[{name}] FOR UPDATE withdraw {withdraw:.2f}\n{result.stdout.strip()}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--mode", choices=["unlocked", "locked"], required=True)
    args = parser.parse_args()

    start = psql_val(
        "SET search_path TO lcb, public; "
        f"SELECT balance FROM accounts WHERE account_number = '{ACCOUNT}';"
    )
    print(f"Starting balance for {ACCOUNT}: {start}")
    print(f"Mode: {args.mode}")
    print("Session A withdraws 3000; Session B withdraws 4000.")
    print("Correct final balance if both apply: 10000 - 3000 - 4000 = 3000")

    logs: list[str] = []
    barrier = threading.Barrier(2)
    threads = [
        threading.Thread(target=worker, args=("A", 3000.0, args.mode, barrier, logs)),
        threading.Thread(target=worker, args=("B", 4000.0, args.mode, barrier, logs)),
    ]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    for line in logs:
        print(line)

    final = psql_val(
        "SET search_path TO lcb, public; "
        f"SELECT balance FROM accounts WHERE account_number = '{ACCOUNT}';"
    )
    print(f"Final balance: {final}")
    if args.mode == "unlocked":
        print("Expected anomaly without locking: one withdrawal is lost (final often 6000 or 7000).")
    else:
        print("With SELECT FOR UPDATE both withdrawals serialize; final should be 3000.00.")


if __name__ == "__main__":
    main()
