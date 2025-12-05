# 🔄 Complete rclone Guide for HomeLab

**Cloud storage sync, backup, and migration using rclone**

---

## 🎯 What is rclone?

**rclone** is the "Swiss Army knife" for cloud storage:
- Sync files to/from 70+ cloud providers
- Encrypt files on the fly
- Mount cloud storage as local drives
- Transfer between cloud providers directly
- Command-line tool with powerful scripting support

**Perfect for:**
- Migrating from Google Drive to local storage
- Backing up to cloud providers
- Syncing folders across services
- Mounting cloud storage locally

---

## 📋 Supported Cloud Providers

```
Provider                Use Case
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Google Drive            Migration, backup, sync
OneDrive                Microsoft 365 integration
Dropbox                 Cross-platform sync
pCloud                  Encrypted backup destination
Backblaze B2            Cheap cloud backup
Amazon S3               Enterprise backup
Cloudflare R2           S3-compatible, no egress fees
SFTP/FTP                Server transfers
Local/network drives    NAS sync
WebDAV                  Generic cloud access
Mega                    Encrypted storage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🔧 Installation

### Install via Homebrew (Recommended)

```bash
brew install rclone
```

### Verify Installation

```bash
rclone version
```

**Expected output:**
```
rclone v1.xx.x
- os/version: darwin 14.x (arm64)
- os/kernel: 24.x.x
```

---

## 📍 Step 1: Configure Cloud Remotes

### Interactive Setup

```bash
rclone config
```

**Menu options:**
```
n) New remote
s) Set configuration password
q) Quit config
```

### Quick Remote Setup Commands

**Google Drive:**
```bash
rclone config create gdrive drive \
    scope=drive \
    --drive-acknowledge-abuse=true
```

**OneDrive:**
```bash
rclone config create onedrive onedrive
```

**pCloud:**
```bash
rclone config create pcloud pcloud
```

**Backblaze B2:**
```bash
rclone config create b2 b2 \
    account=YOUR_KEY_ID \
    key=YOUR_APP_KEY
```

**SFTP (Server):**
```bash
rclone config create myserver sftp \
    host=server.example.com \
    user=username \
    port=22
```

### Verify Remote Works

```bash
# List remotes
rclone listremotes

# Test connection
rclone lsd gdrive:

# Show storage info
rclone about gdrive:
```

---

## 📍 Step 2: Using the Google Drive Download Script

### Location

```
~/Documents/Obsidian/HOMELAB/scripts/download_gdrive.sh
```

### What It Does

1. ✅ Checks if rclone is installed (installs if missing)
2. ✅ Checks if Google Drive remote is configured (sets up if not)
3. ✅ Verifies destination drive is mounted
4. ✅ Estimates total download size
5. ✅ Downloads all files with progress logging
6. ✅ Converts Google Docs to Office formats

### Prerequisites

- HomeLab-4TB drive mounted at `/Volumes/HomeLab-4TB`
- Destination folder exists: `/Volumes/HomeLab-4TB/TRANSFER_FROM_GD`

### Running the Script

```bash
# Make executable (first time only)
chmod +x ~/Documents/Obsidian/HOMELAB/scripts/download_gdrive.sh

# Run the script
~/Documents/Obsidian/HOMELAB/scripts/download_gdrive.sh
```

### First Run Experience

**1. Google Authorization:**
- Browser opens automatically
- Sign in to Google account
- Authorize rclone access
- Return to terminal

**2. Size Estimation:**
- Script calculates total download size
- May take a few minutes for large drives

**3. Confirmation:**
- Shows source and destination
- Press `y` to start download

**4. Progress:**
- Real-time progress display
- Stats every 30 seconds
- Log file created in destination

### Log Files

Each run creates a timestamped log:
```
/Volumes/HomeLab-4TB/TRANSFER_FROM_GD/download_log_20241204_143022.txt
```

---

## 📍 Step 3: Core rclone Commands

### Listing Commands

```bash
# List directories (shallow)
rclone lsd remote:

# List all files (recursive)
rclone ls remote:

# List with sizes
rclone lsl remote:

# List in JSON format
rclone lsjson remote:

# Tree view
rclone tree remote: --max-depth 2
```

### Copy Commands

```bash
# Copy files (doesn't delete destination extras)
rclone copy source:path dest:path

# Copy single file
rclone copyto source:file.txt dest:file.txt

# Copy with progress
rclone copy source: dest: --progress

# Copy with bandwidth limit
rclone copy source: dest: --bwlimit 10M
```

### Sync Commands

```bash
# Sync (mirror - DELETES extras in destination!)
rclone sync source:path dest:path

# Sync with dry run first
rclone sync source: dest: --dry-run

# Sync with backup of deleted files
rclone sync source: dest: --backup-dir old-files
```

### Move Commands

```bash
# Move files (delete after copy)
rclone move source:path dest:path

# Move with delete-empty-src-dirs
rclone move source: dest: --delete-empty-src-dirs
```

### Delete Commands

```bash
# Delete files (keeps directory structure)
rclone delete remote:path

# Delete with rmdirs (removes empty dirs)
rclone delete remote:path --rmdirs

# Purge (delete everything including dirs)
rclone purge remote:path
```

⚠️ **WARNING:** `sync` and `purge` are destructive! Always use `--dry-run` first!

---

## 📍 Step 4: Useful Flags Reference

### Progress & Logging

```bash
--progress              # Show progress
--stats 30s             # Stats interval
--stats-one-line        # Compact stats
--log-file=log.txt      # Log to file
--log-level INFO        # Log level (DEBUG/INFO/NOTICE/ERROR)
-v                      # Verbose (same as --log-level INFO)
-vv                     # Very verbose (DEBUG level)
```

### Performance Tuning

```bash
--transfers 4           # Parallel file transfers (default 4)
--checkers 8            # Parallel checkers (default 8)
--buffer-size 64M       # Buffer size per transfer
--drive-chunk-size 64M  # Google Drive chunk size
--bwlimit 10M           # Bandwidth limit
--bwlimit "08:00,10M 18:00,off"  # Time-based limits
```

### Filtering

```bash
--include "*.jpg"       # Include only matching files
--exclude "*.tmp"       # Exclude matching files
--include-from file.txt # Include patterns from file
--exclude-from file.txt # Exclude patterns from file
--min-size 100k         # Minimum file size
--max-size 1G           # Maximum file size
--min-age 7d            # Older than 7 days
--max-age 24h           # Newer than 24 hours
```

### Safety

```bash
--dry-run               # Show what would happen
--interactive           # Confirm before actions
--backup-dir path       # Backup deleted/changed files
--suffix .bak           # Suffix for backups
--immutable             # Don't modify destination
```

### Google Drive Specific

```bash
--drive-acknowledge-abuse        # Download flagged files
--drive-export-formats docx,xlsx # Convert Google Docs
--drive-skip-gdocs               # Skip Google Docs entirely
--drive-shared-with-me           # Include shared files
--drive-trashed-only             # Only trashed files
```

---

## 📍 Step 5: Script Templates

### Template: Download from Cloud

```bash
#!/bin/bash
# download_from_PROVIDER.sh
# Downloads from PROVIDER to local storage

set -e

REMOTE="provider_name"
DEST_DIR="/path/to/destination"
LOG_FILE="${DEST_DIR}/download_log_$(date +%Y%m%d_%H%M%S).txt"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check destination exists
if [ ! -d "$DEST_DIR" ]; then
    echo_error "Destination $DEST_DIR does not exist!"
    exit 1
fi

# Check rclone installed
if ! command -v rclone &> /dev/null; then
    echo_error "rclone not installed. Run: brew install rclone"
    exit 1
fi

# Check remote configured
if ! rclone listremotes | grep -q "^${REMOTE}:$"; then
    echo_error "Remote '${REMOTE}' not configured."
    echo_info "Run: rclone config"
    exit 1
fi

# Show info
echo ""
echo_info "Source: ${REMOTE}:"
echo_info "Destination: ${DEST_DIR}"
echo_info "Log: ${LOG_FILE}"
echo ""

read -p "Start download? (y/n): " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && exit 0

# Run download
rclone copy "${REMOTE}:" "${DEST_DIR}" \
    --progress \
    --transfers 4 \
    --checkers 8 \
    --log-file="${LOG_FILE}" \
    --log-level INFO \
    --stats 30s \
    --stats-one-line

echo_info "Download complete!"
```

### Template: Upload Backup to Cloud

```bash
#!/bin/bash
# backup_to_PROVIDER.sh
# Backup local folder to cloud storage

set -e

SOURCE_DIR="/Users/homelab/HomeLab/Docker/Data"
REMOTE="pcloud"
REMOTE_PATH="HomeLab-Backups/Docker"
LOG_FILE="/tmp/backup_log_$(date +%Y%m%d_%H%M%S).txt"

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

# Check source exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory not found: $SOURCE_DIR"
    exit 1
fi

echo_info "Backing up: ${SOURCE_DIR}"
echo_info "To: ${REMOTE}:${REMOTE_PATH}"
echo_info "Log: ${LOG_FILE}"

rclone sync "${SOURCE_DIR}" "${REMOTE}:${REMOTE_PATH}" \
    --progress \
    --transfers 4 \
    --exclude "*/cache/*" \
    --exclude "*/logs/*" \
    --exclude "*/transcode/*" \
    --log-file="${LOG_FILE}" \
    --log-level INFO \
    --stats 30s

echo_info "Backup complete!"
```

### Template: Sync Between Clouds

```bash
#!/bin/bash
# sync_cloud_to_cloud.sh
# Sync between two cloud providers

set -e

SOURCE_REMOTE="gdrive"
SOURCE_PATH="Photos"
DEST_REMOTE="pcloud"
DEST_PATH="Photos-Backup"

echo "Syncing ${SOURCE_REMOTE}:${SOURCE_PATH} → ${DEST_REMOTE}:${DEST_PATH}"

# Dry run first
echo ""
echo "=== DRY RUN ==="
rclone sync "${SOURCE_REMOTE}:${SOURCE_PATH}" "${DEST_REMOTE}:${DEST_PATH}" \
    --dry-run \
    --progress

echo ""
read -p "Execute sync? (y/n): " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && exit 0

# Real sync
rclone sync "${SOURCE_REMOTE}:${SOURCE_PATH}" "${DEST_REMOTE}:${DEST_PATH}" \
    --progress \
    --transfers 4

echo "Sync complete!"
```

### Template: Mount Cloud as Local Drive

```bash
#!/bin/bash
# mount_cloud.sh
# Mount cloud storage as local filesystem

REMOTE="gdrive"
MOUNT_POINT="/Users/homelab/GoogleDrive"
CACHE_DIR="/tmp/rclone-cache"

# Create mount point
mkdir -p "$MOUNT_POINT"
mkdir -p "$CACHE_DIR"

echo "Mounting ${REMOTE}: at ${MOUNT_POINT}"
echo "Press Ctrl+C to unmount"

rclone mount "${REMOTE}:" "${MOUNT_POINT}" \
    --vfs-cache-mode full \
    --vfs-cache-max-size 10G \
    --cache-dir "$CACHE_DIR" \
    --allow-other \
    --daemon

echo "Mounted! Access files at: ${MOUNT_POINT}"
echo ""
echo "To unmount: umount ${MOUNT_POINT}"
```

---

## 📍 Step 6: Common Use Cases

### Use Case 1: Migrate Google Drive to Local Storage

**Script:** `download_gdrive.sh` (already created)

```bash
# Run the migration
~/Documents/Obsidian/HOMELAB/scripts/download_gdrive.sh
```

### Use Case 2: Backup Docker Configs to pCloud

```bash
#!/bin/bash
# backup_docker_pcloud.sh

rclone sync /Users/homelab/HomeLab/Docker/Data pcloud:HomeLab-Backups/Docker \
    --progress \
    --exclude "*/cache/*" \
    --exclude "*/logs/*" \
    --exclude "*/transcode/*" \
    --exclude "plex/config/Library/Application Support/Plex Media Server/Cache/**"
```

### Use Case 3: Download Specific Folder from OneDrive

```bash
#!/bin/bash
# download_onedrive_folder.sh

FOLDER="Documents/Work"
DEST="/Users/homelab/Downloads/OneDrive-Work"

mkdir -p "$DEST"

rclone copy "onedrive:${FOLDER}" "${DEST}" \
    --progress \
    --transfers 8
```

### Use Case 4: Sync Photos Between Clouds

```bash
#!/bin/bash
# sync_photos.sh

# Sync Google Photos to pCloud (preserves both)
rclone copy gdrive:Photos pcloud:Photos-Archive \
    --progress \
    --include "*.jpg" \
    --include "*.png" \
    --include "*.heic" \
    --include "*.mov" \
    --include "*.mp4"
```

### Use Case 5: Encrypted Backup to Backblaze B2

```bash
# First, create encrypted remote
rclone config create b2-crypt crypt \
    remote=b2:homelab-backup \
    password=YOUR_ENCRYPTION_PASSWORD \
    password2=YOUR_SALT_PASSWORD

# Then backup to encrypted remote
rclone sync /Users/homelab/HomeLab/Docker/Data b2-crypt: \
    --progress \
    --transfers 8
```

### Use Case 6: Daily Scheduled Backup

**Create script:** `daily_backup.sh`
```bash
#!/bin/bash

LOG="/Users/homelab/logs/backup_$(date +%Y%m%d).log"

rclone sync /Users/homelab/HomeLab/Docker/Data pcloud:HomeLab-Daily \
    --log-file="$LOG" \
    --log-level INFO \
    --exclude "*/cache/*" \
    --exclude "*/logs/*"

# Optional: Send notification
osascript -e 'display notification "Daily backup complete" with title "HomeLab Backup"'
```

**Add to crontab:**
```bash
crontab -e

# Add this line (runs at 3 AM daily)
0 3 * * * /Users/homelab/Documents/Obsidian/HOMELAB/scripts/daily_backup.sh
```

---

## 🔒 Security Best Practices

### 1. Use Encrypted Remotes

```bash
# Create encrypted wrapper around any remote
rclone config create secure-backup crypt \
    remote=pcloud:encrypted-backups \
    password=STRONG_PASSWORD \
    password2=SALT_PASSWORD
```

**Store passwords in 1Password:**
- Title: rclone Encryption Keys
- Note: Both passwords needed to decrypt!

### 2. Protect rclone Config

```bash
# rclone config location
~/.config/rclone/rclone.conf

# Set restrictive permissions
chmod 600 ~/.config/rclone/rclone.conf
```

### 3. Use App Passwords Where Possible

- Google: Use OAuth (built-in)
- pCloud: Create app password
- Dropbox: Create app key

### 4. Encrypt Config File

```bash
# Set config password
rclone config
# Choose: s) Set configuration password
```

---

## 🧪 Testing & Verification

### Verify Downloads

```bash
# Check file counts match
rclone lsf gdrive: | wc -l
ls -la /Volumes/HomeLab-4TB/TRANSFER_FROM_GD | wc -l

# Compare checksums
rclone check gdrive: /Volumes/HomeLab-4TB/TRANSFER_FROM_GD
```

### Test Backup Integrity

```bash
# Verify backup matches source
rclone check /source/path pcloud:backup/path

# Show differences
rclone check /source pcloud:backup --combined=-
```

### Dry Run Everything First

```bash
# ALWAYS test with dry-run before sync
rclone sync source: dest: --dry-run -v
```

---

## 🚨 Troubleshooting

### "Rate Limit Exceeded" (Google Drive)

**Solution:**
```bash
# Reduce parallel operations
rclone copy gdrive: /dest \
    --transfers 1 \
    --checkers 1 \
    --tpslimit 2
```

### "Token Expired"

**Solution:**
```bash
# Re-authorize the remote
rclone config reconnect gdrive:
```

### "File Name Too Long"

**Solution:**
```bash
# Use --local-encoding flag
rclone copy source: dest: --local-encoding None
```

### "Out of Memory" on Large Transfers

**Solution:**
```bash
# Reduce buffer sizes
rclone copy source: dest: \
    --buffer-size 16M \
    --drive-chunk-size 32M
```

### Slow Transfer Speeds

**Solutions:**
```bash
# Increase parallelism
--transfers 8
--checkers 16

# Increase chunk sizes
--drive-chunk-size 128M

# Use faster checksum
--checksum
```

### Connection Drops

**Solutions:**
```bash
# Add retry options
--retries 5
--retries-sleep 10s
--low-level-retries 10
```

---

## 📊 Monitoring Progress

### Real-time Stats

```bash
rclone copy source: dest: \
    --progress \
    --stats 10s \
    --stats-one-line
```

### Output Meaning

```
Transferred:    5.000G / 10.000 GBytes, 50%, 25.000 MBytes/s, ETA 3m20s
Transferred:        50 / 100, 50%
Elapsed time:    3m20.0s
```

### Log File Analysis

```bash
# Count errors
grep -c ERROR backup_log.txt

# Show only errors
grep ERROR backup_log.txt

# Show transfer summary
grep "Transferred:" backup_log.txt | tail -1
```

---

## 📝 Quick Reference Card

```bash
# === ESSENTIAL COMMANDS ===

# Setup
brew install rclone          # Install
rclone config               # Configure remotes
rclone listremotes          # List configured remotes

# Information
rclone lsd remote:          # List directories
rclone ls remote:           # List files
rclone about remote:        # Storage info
rclone size remote:         # Calculate size

# Transfer
rclone copy source dest     # Copy (additive)
rclone sync source dest     # Sync (mirror)
rclone move source dest     # Move (delete source)

# Safety
--dry-run                   # Preview only
--progress                  # Show progress
--log-file=log.txt          # Log to file

# Performance
--transfers 8               # Parallel transfers
--checkers 16               # Parallel checks
--bwlimit 10M               # Bandwidth limit

# Filtering
--include "*.jpg"           # Include pattern
--exclude "*.tmp"           # Exclude pattern
--max-size 1G               # Size limit
```

---

## 🔗 Related Documentation

- [[PCLOUD_BACKUP_COMPLETE_GUIDE]] - pCloud backup with Duplicati
- [[BACKUP_SETUP_GUIDE]] - General backup strategy
- [[Kopia-Backup-Setup]] - Kopia backup alternative

---

## 📁 Script Locations

All rclone scripts are stored in:
```
~/Documents/Obsidian/HOMELAB/scripts/
```

**Available scripts:**
- `download_gdrive.sh` - Download entire Google Drive

---

## 🎯 Summary

**rclone gives you:**
- ✅ Universal cloud storage access
- ✅ High-speed parallel transfers
- ✅ Encryption support
- ✅ Scriptable automation
- ✅ Mount cloud as local drives

**Common workflows:**
- Migrate away from Google Drive
- Backup to multiple clouds
- Sync folders across services
- Mount cloud storage locally

**Key commands:**
- `copy` - Safe copy without deleting
- `sync` - Mirror with deletion
- `--dry-run` - Always test first!

**Your HomeLab has cloud superpowers! ☁️🚀**
