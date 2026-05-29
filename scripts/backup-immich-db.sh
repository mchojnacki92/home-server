#!/bin/bash
# scripts/backup-immich-db.sh
# Backs up the Immich Postgres database to a compressed .sql.gz file
# Recommended: run via cron daily
#
# Usage: ./backup-immich-db.sh
# Cron example (daily at 3am):
#   0 3 * * * /home/YOUR_USER/homeserver/scripts/backup-immich-db.sh

set -euo pipefail

# --- Config ---
CONTAINER="immich_postgres"
DB_USER="postgres"
DB_NAME="immich"
BACKUP_DIR="/home/$USER/backups/immich-db"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/immich-db_$DATE.sql.gz"
KEEP_DAYS=7   # delete backups older than this

# --- Create backup dir if missing ---
mkdir -p "$BACKUP_DIR"

echo "[$(date)] Starting Immich DB backup..."

# --- Dump and compress ---
docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

echo "[$(date)] Backup saved: $BACKUP_FILE"
echo "[$(date)] Size: $(du -sh "$BACKUP_FILE" | cut -f1)"

# --- Remove old backups ---
find "$BACKUP_DIR" -name "immich-db_*.sql.gz" -mtime +$KEEP_DAYS -delete
echo "[$(date)] Cleaned up backups older than $KEEP_DAYS days"

echo "[$(date)] Done ✅"
