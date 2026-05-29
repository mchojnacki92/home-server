#!/bin/bash
# scripts/renew-ssl.sh
# Renews Let's Encrypt SSL certificate and reloads Nginx
# Run this before certificate expiry (check: sudo certbot certificates)
#
# Usage: sudo ./renew-ssl.sh
# Or automate with cron (runs monthly, certbot skips if not due):
#   0 3 1 * * /home/YOUR_USER/homeserver/scripts/renew-ssl.sh

set -euo pipefail

DOMAIN="YOUR_DOMAIN"   # Replace with your domain (e.g. from .env)

echo "[$(date)] Starting SSL renewal for $DOMAIN..."

# --- Attempt renewal ---
sudo certbot renew --nginx --non-interactive --quiet

# --- Reload Nginx to pick up new cert ---
if sudo nginx -t; then
    sudo systemctl reload nginx
    echo "[$(date)] Nginx reloaded with new certificate ✅"
else
    echo "[$(date)] ❌ Nginx config test failed — not reloading"
    exit 1
fi

# --- Show cert expiry ---
echo "[$(date)] Current certificate status:"
sudo certbot certificates 2>/dev/null | grep -A3 "$DOMAIN" || true

echo "[$(date)] Done ✅"
