#!/bin/bash
set -e

HOSTNAME="${1:-localhost}"
URL="http://${HOSTNAME}/api/forecast/tel%20aviv"

RESPONSE=$(curl -s "$URL")

if echo "$RESPONSE" | jq . > /dev/null 2>&1; then
    echo "✅ Got valid JSON"
    exit 0
else
    echo "❌ Invalid JSON response:"
    echo "$RESPONSE"
    exit 1
fi