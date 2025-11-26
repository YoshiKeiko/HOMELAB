#!/usr/bin/env bash

CONFIG="/Users/homelab/Documents/Obsidian/backup_config.sh"
source "$CONFIG"

LOG_FILE="/Users/homelab/Documents/Obsidian/sync_log.txt"

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "=== Starting sync cycle ==="

for VAULT in "${VAULTS[@]}"; do
    VAULT_PATH="/Users/homelab/Documents/Obsidian/$VAULT"
    
    if [ ! -d "$VAULT_PATH" ]; then
        log "⚠️  Vault not found: $VAULT_PATH"
        continue
    fi
    
    cd "$VAULT_PATH"
    
    # Check if it's a git repo
    if [ ! -d .git ]; then
        log "⚠️  Not a git repo: $VAULT"
        continue
    fi
    
    # Stash any local changes (shouldn't happen, but safe)
    LOCAL_CHANGES=$(git status --porcelain)
    if [ -n "$LOCAL_CHANGES" ]; then
        log "📝 Local changes detected in $VAULT, stashing..."
        git stash --include-untracked
    fi
    
    # Pull latest changes
    log "⬇️  Pulling $VAULT..."
    PULL_OUTPUT=$(git pull origin main 2>&1)
    
    if [ $? -eq 0 ]; then
        if echo "$PULL_OUTPUT" | grep -q "Already up to date"; then
            log "✓ $VAULT already up to date"
        else
            log "✓ $VAULT updated: $(echo "$PULL_OUTPUT" | head -n 1)"
        fi
    else
        log "❌ Error pulling $VAULT: $PULL_OUTPUT"
    fi
    
    # Pop stash if we had local changes
    if [ -n "$LOCAL_CHANGES" ]; then
        git stash pop
    fi
done

log "=== Sync cycle complete ==="