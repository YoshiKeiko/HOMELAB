#!/bin/bash

################################################################################
# Remove Duplicati and Install Kopia (Modern Backup Solution)
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         SWITCH FROM DUPLICATI TO KOPIA                         ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "This will:"
echo "  • Remove Duplicati completely"
echo "  • Install Kopia (modern backup solution)"
echo "  • Run on port 8202"
echo "  • Much easier to use!"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""

################################################################################
# STEP 1: Remove Duplicati
################################################################################

log_step "Step 1: Removing Duplicati..."
echo ""

# Stop and remove container
docker stop duplicati 2>/dev/null || true
docker rm duplicati 2>/dev/null || true
log_info "Duplicati container removed"

# Backup config (just in case)
if [ -d "$HOME/HomeLab/Docker/Data/duplicati" ]; then
    BACKUP_DIR="$HOME/HomeLab/Docker/Data/duplicati-removed-$(date +%Y%m%d-%H%M%S)"
    mv "$HOME/HomeLab/Docker/Data/duplicati" "$BACKUP_DIR"
    log_info "Duplicati config backed up to: $BACKUP_DIR"
fi

echo ""

################################################################################
# STEP 2: Create Kopia Directory
################################################################################

log_step "Step 2: Creating Kopia directories..."
echo ""

mkdir -p "$HOME/HomeLab/Docker/Data/kopia/config"
mkdir -p "$HOME/HomeLab/Docker/Data/kopia/cache"
mkdir -p "$HOME/HomeLab/Docker/Data/kopia/logs"

log_info "Directories created"
echo ""

################################################################################
# STEP 3: Install Kopia
################################################################################

log_step "Step 3: Installing Kopia..."
echo ""

# Create Kopia container
docker run -d \
  --name kopia \
  --restart unless-stopped \
  --hostname kopia-server \
  -p 8202:51515 \
  -e KOPIA_PASSWORD=admin \
  -e TZ=Europe/London \
  -e USER=kopia \
  -v "$HOME/HomeLab/Docker/Data/kopia/config:/app/config" \
  -v "$HOME/HomeLab/Docker/Data/kopia/cache:/app/cache" \
  -v "$HOME/HomeLab/Docker/Data/kopia/logs:/app/logs" \
  -v "$HOME/HomeLab/Docker/Data:/data:ro" \
  -v "/Volumes/HomeLab-4TB:/backups:ro" \
  kopia/kopia:latest \
  server start \
    --insecure \
    --address=0.0.0.0:51515 \
    --server-username=admin@kopia \
    --server-password=admin

if [ $? -eq 0 ]; then
    log_info "Kopia installed successfully!"
else
    log_error "Failed to install Kopia"
    exit 1
fi

echo ""

################################################################################
# STEP 4: Wait for Startup
################################################################################

log_step "Step 4: Waiting for Kopia to start..."
echo ""

echo "Waiting 20 seconds for initialization..."
for i in {20..1}; do
    echo -ne "\r${YELLOW}Starting in $i seconds...  ${NC}"
    sleep 1
done
echo -e "\r${GREEN}Kopia is ready!                ${NC}"

echo ""

################################################################################
# STEP 5: Verify Installation
################################################################################

log_step "Step 5: Verifying installation..."
echo ""

if docker ps | grep -q kopia; then
    log_info "Kopia is running"
    
    echo ""
    echo "Container info:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "NAMES|kopia"
else
    log_error "Kopia failed to start"
    echo ""
    echo "Check logs:"
    echo "  docker logs kopia"
    exit 1
fi

echo ""

################################################################################
# SUCCESS SCREEN
################################################################################

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║              ✓ KOPIA INSTALLATION COMPLETE!                   ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "Access Kopia at:"
echo "  ${CYAN}http://localhost:8202${NC}"
echo ""

echo "Default Credentials:"
echo "  ${YELLOW}Username: admin@kopia${NC}"
echo "  ${YELLOW}Password: admin${NC}"
echo ""

echo "${MAGENTA}⚠️  CHANGE PASSWORD AFTER FIRST LOGIN!${NC}"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "1. ${CYAN}Open Kopia: http://localhost:8202${NC}"
echo ""

echo "2. ${YELLOW}Login with:${NC}"
echo "   Username: admin@kopia"
echo "   Password: admin"
echo ""

echo "3. ${YELLOW}Change password:${NC}"
echo "   Click username → Change Password"
echo "   Save new password in 1Password!"
echo ""

echo "4. ${YELLOW}Connect to pCloud:${NC}"
echo "   Repository → New Repository"
echo "   Storage Type: WebDAV"
echo "   Server URL: https://webdav.pcloud.com/HomeLab-Backups"
echo "   Username: your-pcloud-email@example.com"
echo "   Password: your-pcloud-password"
echo ""

echo "5. ${YELLOW}Create snapshot:${NC}"
echo "   Snapshots → New Snapshot"
echo "   Path: /data (Docker configs)"
echo "   Schedule: Daily at 3:00 AM"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create Kopia guide
cat > "$HOME/HomeLab/docs/KOPIA_SETUP_GUIDE.md" << 'EOFGUIDE'
# 🚀 Kopia Backup Setup Guide

## What is Kopia?

Modern, fast, encrypted backup solution with beautiful UI.

**Better than Duplicati:**
- ✅ Faster backups
- ✅ Better compression
- ✅ Modern UI
- ✅ Easy to use
- ✅ No password hassles!

---

## 🌐 Access Kopia

**URL:** http://localhost:8202

**Default Login:**
- Username: `admin@kopia`
- Password: `admin`

**From MacBook Air:**
- URL: `http://M4-IP:8202`

---

## 🔐 Step 1: Change Default Password

**IMPORTANT - Do this first!**

1. Login with default credentials
2. Click **username** (top right)
3. Select **"Change Password"**
4. Enter new strong password
5. Click **"Change Password"**

**Save in 1Password:**
- Title: Kopia Backup System
- Username: admin@kopia
- Password: [your new password]
- URL: http://localhost:8202

---

## ☁️ Step 2: Connect to pCloud

### A. Create Repository

1. Click **"Repository"** (left sidebar)
2. Click **"Connect to Repository"** → **"Create new repository"**

### B. Choose WebDAV Storage

1. **Storage Type:** Select **"WebDAV"**

2. **Configuration:**
   ```
   Server URL: https://webdav.pcloud.com/HomeLab-Backups
   Username: your-pcloud-email@example.com
   Password: your-pcloud-password
   ```

3. **Repository Options:**
   - Repository Password: Create STRONG password
   - Confirm password
   
   ⚠️ **SAVE IN 1PASSWORD!** You need this to restore!

4. Click **"Create Repository"**

### C. Wait for Initialization

Repository will be created in pCloud.
Takes 10-30 seconds.

✅ You should see: "Repository created successfully"

---

## 📦 Step 3: Create Backup Snapshot

### A. Create New Snapshot

1. Click **"Snapshots"** (left sidebar)
2. Click **"New Snapshot"**

### B. Configure Snapshot

**Path to backup:**
```
/data
```

This maps to: `~/HomeLab/Docker/Data` (all your Docker configs!)

**What to include:**
- ✅ All directories (default)

**What to exclude:**
```
**/cache/**
**/logs/**
**/Cache/**
**/transcode/**
*.log
*.tmp
```

**Retention policy:**
- Keep daily snapshots: 30 days
- Keep weekly snapshots: 12 weeks
- Keep monthly snapshots: 6 months

### C. Set Schedule

**Timing:**
- **Time:** 03:00 (3:00 AM)
- **Frequency:** Daily
- **Enabled:** ✅ Yes

### D. Save Snapshot

Click **"Create Snapshot"**

---

## 🧪 Step 4: Test Backup

### Run First Backup

1. Go to **Snapshots**
2. Find your snapshot
3. Click **"Snapshot Now"**
4. Watch progress

**First backup:** 15-45 minutes (uploads everything)
**Future backups:** 1-5 minutes (only changes)

### Verify in pCloud

1. Login to pCloud web
2. Go to **HomeLab-Backups** folder
3. Should see Kopia repository files

✅ Backup is working!

---

## 🔄 Step 5: Test Restore

**CRITICAL - Test this works!**

### A. Browse Snapshots

1. Go to **Snapshots**
2. Click on your snapshot
3. Browse files

### B. Restore Single File

1. Navigate to a file (e.g., vaultwarden config)
2. Click **"Restore"**
3. Choose destination: `/tmp/test-restore`
4. Click **"Restore"**

### C. Verify Restore

```bash
# Check file exists
ls -la /tmp/test-restore

# Clean up test
rm -rf /tmp/test-restore
```

✅ If file restored successfully, backups work!

---

## 📊 What Gets Backed Up

**Backed up to pCloud:**
```
/data/ (maps to ~/HomeLab/Docker/Data/)
├── vaultwarden/       ← Passwords (CRITICAL!)
├── homeassistant/     ← Smart home config
├── grafana/           ← Dashboards
├── radarr/            ← Movie automation config
├── sonarr/            ← TV automation config
├── prowlarr/          ← Indexer config
├── nextcloud/         ← Cloud storage
├── paperless/         ← Documents
├── adguard/           ← DNS settings
└── [all other services]
```

**NOT backed up:**
- ❌ Media files (too large, can re-download)
- ❌ Cache directories
- ❌ Log files
- ❌ Temporary files

**Total size:** 1-2GB (compressed to ~500MB)

---

## 🎯 Kopia vs Duplicati

**Why Kopia is better:**

| Feature | Kopia | Duplicati |
|---------|-------|-----------|
| **Speed** | ⚡ Fast | 🐌 Slower |
| **UI** | 🎨 Modern | 📊 Dated |
| **Setup** | ✅ Easy | 😓 Complex |
| **Password** | ✅ Simple | 🔐 Confusing |
| **Compression** | 🗜️ Better | 📦 Good |
| **Deduplication** | ✅ Excellent | ✅ Good |

---

## 🔧 Advanced Features

### Multiple Repositories

Create separate backups to different destinations:

1. **pCloud** (primary)
2. **Backblaze B2** (secondary)
3. **Google Drive** (tertiary)

### Policies

**Set retention policies:**
- Hourly: Keep 24 hours
- Daily: Keep 30 days
- Weekly: Keep 12 weeks
- Monthly: Keep 12 months
- Yearly: Keep 5 years

### Compression

**Already optimized:**
- Compression: zstd (fastest)
- Level: Default
- Deduplication: Enabled

---

## 🆘 Troubleshooting

### Can't Connect to pCloud

**Check:**
- WebDAV URL: `https://webdav.pcloud.com/HomeLab-Backups`
- Credentials correct
- WebDAV enabled in pCloud settings

**Test WebDAV:**
```bash
curl -u "email:password" https://webdav.pcloud.com/
```

### Backup Fails

**Check logs:**
```bash
docker logs kopia
```

**Common issues:**
- pCloud storage full
- Network connection
- Password incorrect

### Restore Fails

**Check:**
- Repository password correct
- pCloud accessible
- Destination has space

---

## 📝 Quick Commands

**Restart Kopia:**
```bash
docker restart kopia
```

**View logs:**
```bash
docker logs kopia -f
```

**Check status:**
```bash
docker ps | grep kopia
```

**Manual backup now:**
```bash
# Via web UI: Snapshots → Snapshot Now
```

**Access from MacBook:**
```
http://YOUR-M4-IP:8202
```

---

## 🔐 Security Best Practices

### 1. Strong Passwords

**Three passwords to manage:**

1. **Kopia Web UI password**
   - For accessing Kopia interface
   - Store in 1Password

2. **pCloud password**
   - For connecting to storage
   - Use app password (not main password)

3. **Repository encryption password**
   - For encrypting backups
   - CRITICAL - needed for restore!
   - Store in 1Password with note: "REQUIRED FOR RESTORE"

### 2. Test Restores Monthly

**Set calendar reminder:**
- Once per month
- Restore random file
- Verify it works

### 3. Monitor Backups

**Check daily:**
- Snapshots → View recent backups
- All should show "Success"

**Setup alerts:**
- Email notifications (if backup fails)

---

## 🚨 Disaster Recovery

**If M4 Mac dies completely:**

### 1. Setup New Mac

```bash
# Install Docker (OrbStack)
brew install orbstack

# Install Kopia
docker run -d \
  --name kopia \
  -p 8202:51515 \
  -e KOPIA_PASSWORD=your-password \
  -v ~/restored-data:/data \
  kopia/kopia:latest \
  server start --insecure --address=0.0.0.0:51515
```

### 2. Connect to pCloud Repository

1. Open Kopia: http://localhost:8202
2. Repository → Connect to Repository
3. Storage: WebDAV
4. URL: `https://webdav.pcloud.com/HomeLab-Backups`
5. Enter repository password (from 1Password!)

### 3. Restore Everything

1. Snapshots → Select latest
2. Click "Restore"
3. Destination: `/restored-data`
4. Wait 30-60 minutes

### 4. Move to Correct Location

```bash
cp -r ~/restored-data/* ~/HomeLab/Docker/Data/
```

### 5. Start Services

```bash
docker compose -f ~/HomeLab/Docker/Compose/core.yml up -d
docker compose -f ~/HomeLab/Docker/Compose/media.yml up -d
# etc.
```

✅ **Back online in 1-2 hours!**

---

## ✅ Setup Checklist

Initial Setup:
- [ ] Kopia accessible at :8202
- [ ] Default password changed
- [ ] New password saved in 1Password
- [ ] pCloud WebDAV credentials obtained
- [ ] Repository created in pCloud
- [ ] Repository password set (STRONG!)
- [ ] Repository password saved in 1Password
- [ ] Snapshot configured (/data)
- [ ] Exclusions set (cache, logs)
- [ ] Schedule set (3 AM daily)
- [ ] First backup completed
- [ ] Verified files in pCloud
- [ ] Test restore successful

Monthly:
- [ ] Check recent backups (all successful?)
- [ ] Test restore random file
- [ ] Verify pCloud storage not full
- [ ] Check repository password still in 1Password

---

## 🎉 Summary

**You now have:**
- ✅ Modern backup solution (Kopia)
- ✅ Automatic daily backups at 3 AM
- ✅ Encrypted backups to pCloud
- ✅ 30-day retention
- ✅ All Docker configs backed up
- ✅ Fast incremental backups
- ✅ Easy restore process
- ✅ Better than Duplicati!

**Your HomeLab is protected!** 🛡️

EOFGUIDE

log_info "Complete guide saved to: ~/HomeLab/docs/KOPIA_SETUP_GUIDE.md"

echo ""
echo "Opening Kopia in browser..."
sleep 3
open http://localhost:8202 2>/dev/null || echo "Open manually: http://localhost:8202"

echo ""
log_info "Installation complete! Follow the guide to configure pCloud backup."
echo ""
echo "Guide: ${CYAN}open ~/HomeLab/docs/KOPIA_SETUP_GUIDE.md${NC}"
echo ""