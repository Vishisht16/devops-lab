#!/usr/bin/env bash
set -euo pipefail

# Check if URL argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <URL>" >&2
    exit 1
fi

URL="$1"

# Perform curl request with a 2-second timeout, suppressing progress bar
# Capture both the HTTP status code and the curl exit code/error message
HTTP_CODE=""
CURL_ERROR=""
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S")

# We use curl with --max-time 2 for the 2-second timeout
# -s -S: silent but show errors
# -o /dev/null: discard response body
# -w "%{http_code}": output only the HTTP status code
RESPONSE=$(curl -s -S --max-time 2 -o /dev/null -w "%{http_code}" "$URL" 2>&1)
CURL_EXIT=$?

if [ "$CURL_EXIT" -eq 0 ]; then
    if [ "$RESPONSE" -ge 200 ] && [ "$RESPONSE" -lt 300 ]; then
        echo "$TIMESTAMP $URL UP"
        exit 0
    else
        echo "$TIMESTAMP $URL DOWN (status code: $RESPONSE)"
        exit 1
    fi
else
    # Parse curl exit code to give an accurate reason
    # Exit code 28 is timeout in curl
    # Exit code 7 is failed to connect (connection refused)
    if [ "$CURL_EXIT" -eq 28 ]; then
        REASON="timeout"
    elif [ "$CURL_EXIT" -eq 7 ]; then
        REASON="connection refused"
    else
        REASON="connection error (curl exit code $CURL_EXIT)"
    fi

    echo "$TIMESTAMP $URL DOWN ($REASON)"
    exit 1
fi