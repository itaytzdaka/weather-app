# #!/bin/bash

# set -e

# URL="http://nginx/api/forecast/tel%20aviv"

# RESPONSE=$(curl -s "$URL")

# if echo "$RESPONSE" | jq . > /dev/null 2>&1; then
#     echo "✅ Got valid JSON"
#     exit 0
# else
#     echo "❌ Invalid JSON response:"
#     exit 1
# fi


#!/bin/bash
set -e

HOSTNAME="${1:-localhost}"
URL="http://${HOSTNAME}/api/forecast/tel%20aviv"

RESPONSE=$(curl -s "$URL")


if echo "$RESPONSE" | grep -q '"name":"Tel Aviv-Yafo"'; then
    echo "✅ Found expected location in JSON response"
    exit 0
else
    echo "❌ Expected value not found in response:"
    exit 1
fi