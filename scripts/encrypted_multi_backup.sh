#!/bin/bash

CONFIG="/Users/homelab/Documents/Obsidian/backup_config.sh"
source "$CONFIG"

NOW_TS=$(date +%s)
NOW_HR=$(date "+%Y-%m-%d %H:%M:%S")

for VAULT in "${VAULTS[@]}"; do
    VAULT_PATH="/Users/homelab/Documents/Obsidian/$VAULT"
    BACKUP_DIR="$VAULT_PATH/BACKUP"
    KEY_FILE="$BACKUP_DIR/key.txt"
    LAST_BACKUP_FILE="$BACKUP_DIR/last_backup.txt"

    echo "============================================"
    echo "🔐 Processing vault: $VAULT"
    echo "Path: $VAULT_PATH"
    echo "============================================"

    # Ensure backup directory exists
    mkdir -p "$BACKUP_DIR"

    # Check last backup time
    if [ -f "$LAST_BACKUP_FILE" ]; then
        LAST_TS=$(date -jf "%Y-%m-%d %H:%M:%S" "$(cat "$LAST_BACKUP_FILE")" +%s)
        DIFF_HOURS=$(( (NOW_TS - LAST_TS) / 3600 ))

        if [ "$DIFF_HOURS" -lt "$MIN_HOURS" ]; then
            echo "⏱ Skipping $VAULT — last backup was $DIFF_HOURS hours ago."
            continue
        fi
    fi

    # Require encryption key
    if [ ! -f "$KEY_FILE" ]; then
        echo "❌ Missing key file: $KEY_FILE"
        echo "Create one using: echo 'PASSWORD' > $KEY_FILE"
        continue
    fi

    cd "$VAULT_PATH"

    # Create encrypted archive
    echo "[1/3] 📦 Creating archive..."
    tar -czf vault.tar.gz . --exclude="BACKUP" --exclude="BACKUPS"

    echo "[2/3] 🔐 Encrypting..."
    openssl enc -aes-256-cbc -salt \
        -in vault.tar.gz \
        -out "$BACKUP_DIR/vault.tar.gz.enc" \
        -pass file:"$KEY_FILE"

    rm vault.tar.gz

    # Commit and push encrypted blob
    echo "[3/3] 🚀 Pushing Git backup..."
    git add .
    git commit -m "Automated encrypted backup ($NOW_HR)" --allow-empty
    git push

    # Create local snapshot
    SNAP="$LOCAL_BACKUP_ROOT/${VAULT}_$(date "+%Y-%m-%d_%H-%M-%S").tar.gz"
    echo "📁 Creating local snapshot: $SNAP"
    tar -czf "$SNAP" "$VAULT_PATH"

    # Update timestamp
    echo "$NOW_HR" > "$LAST_BACKUP_FILE"

    echo "✔ Finished $VAULT"
done

echo "🎉 All vaults processed."