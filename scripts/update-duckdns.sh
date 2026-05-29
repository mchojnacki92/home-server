#!/bin/bash
# scripts/update-duckdns.sh
# Manually updates DuckDNS with the current public IP
# Normally runs via cron every 5 minutes:
#   */5 * * * * /usr/local/bin/update-duckdns.sh >/dev/null 2>&1
#
# Set DUCKDNS_DOMAIN and DUCKDNS_TOKEN in your .env
# or export them before running this script

DOMAIN="${DUCKDNS_DOMAIN:-your-domain}"
TOKEN="${DUCKDNS_TOKEN:-your-token-here}"

RESULT=$(curl -s "https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip=")

if [ "$RESULT" = "OK" ]; then
    echo "[$(date)] DuckDNS updated successfully ✅"
else
    echo "[$(date)] DuckDNS update failed: $RESULT ❌"
    exit 1
fi
