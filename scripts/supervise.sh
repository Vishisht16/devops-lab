#!/usr/bin/env bash
set -euo pipefail

HEALTH_URL="http://localhost:8000/"
CHECK_SCRIPT="./scripts/check.sh"
CHECK_INTERVAL=5
MAX_FAILURES=3

# Track PID for cleanup
PID=""

cleanup() {
    echo "Stopping supervisor..."
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        kill "$PID" 2>/dev/null || true
        wait "$PID" 2>/dev/null || true
    fi
    exit 0
}

trap cleanup SIGINT SIGTERM

while true; do
    echo "[Supervisor] Starting Python app..."
    python3 app.py &
    PID=$!

    fail_count=0

    # Monitor the running process and perform periodic health checks
    while kill -0 "$PID" 2>/dev/null; do
        sleep "$CHECK_INTERVAL"

        # Check if the process is still alive before testing
        if ! kill -0 "$PID" 2>/dev/null; then
            break
        fi

        if "$CHECK_SCRIPT" "$HEALTH_URL" >/dev/null 2>&1; then
            fail_count=0
        else
            fail_count=$((fail_count + 1))
            echo "[Supervisor] Health check failed ($fail_count/$MAX_FAILURES)"
            
            if [ "$fail_count" -ge "$MAX_FAILURES" ]; then
                echo "[Supervisor] 3 consecutive failures reached. Killing app (PID: $PID)..."
                kill -9 "$PID" 2>/dev/null || true
                break
            fi
        fi
    done

    echo "[Supervisor] App exited or was terminated. Restarting in 2 seconds..."
    sleep 2
done