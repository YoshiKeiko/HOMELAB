# 🔄 HOMELAB BACKUP GUIDE

## Quick Backup (Run Anytime)

```bash
cd ~/homelab-deployment
./pcloud-backup-enhanced.sh
```

**This backs up:**
- ✅ All Docker Compose files
- ✅ Container configurations (8 key services)
- ✅ Scripts and documentation
- ✅ **Obsidian vault (full backup)**

**Output locations:**
- Main backup: `~/homelab-backups/homelab-config-TIMESTAMP.tar.gz`
- Obsidian backup: `~/Documents/Obsidian/BACKUPS/vault-backup-TIMESTAMP.zip`

---

## Upload to pCloud

### Option 1: Web Upload (Easiest)
1. Go to https://my.pcloud.com
2. Navigate to `HomeLab-Backups` folder (create if needed)
3. Upload the `.tar.gz` file from `~/homelab-backups/`
4. Done! (takes 3-5 minutes on your 5Gbps connection)

### Option 2: Command Line (if pCloud CLI installed)
```bash
pcloud upload ~/homelab-backups/homelab-config-TIMESTAMP.tar.gz /HomeLab-Backups/
```

---

## Automated Daily Backups

The script created: `~/homelab/Scripts/auto-backup-pcloud.sh`

**To schedule automatic daily backups at 2 AM:**

```bash
# Edit crontab
crontab -e

# Add this line:
0 2 * * * ~/homelab/Scripts/auto-backup-pcloud.sh

# Save and exit
```

**What the automated backup does:**
- Runs every night at 2 AM
- Backs up all configs + Obsidian vault
- Keeps last 7 days of backups locally
- Can optionally auto-upload to pCloud (configure pcloud CLI first)

---

## Restore from Backup

### Restore Docker Configs
```bash
# Extract backup
cd ~/homelab-backups
tar xzf homelab-config-TIMESTAMP.tar.gz

# Copy configs back
cp -r homelab-config-TIMESTAMP/compose/* ~/homelab/Docker/
cp -r homelab-config-TIMESTAMP/configs/* ~/homelab/configs/
```

### Restore Container Configs
```bash
# Example: Restore Heimdall config
docker cp homelab-config-TIMESTAMP/configs/heimdall-config.tar.gz heimdall:/tmp/
docker exec heimdall tar xzf /tmp/heimdall-config.tar.gz -C /
docker restart heimdall
```

### Restore Obsidian Vault
```bash
# Extract vault backup
cd ~/Documents/Obsidian/BACKUPS
unzip vault-backup-TIMESTAMP.zip -d ~/Documents/
```

---

## Backup Schedule Recommendation

- **Daily:** Automated backup at 2 AM (configs only, quick)
- **Weekly:** Manual full backup + pCloud upload (configs + vault)
- **Before changes:** Always backup before major updates

---

## What's Included in Backups

### Docker Configs ✅
- All compose files from `~/homelab/Docker/`
- Service configuration files
- Environment variables

### Container Configs ✅
- AdGuard Home settings
- Heimdall dashboard layout
- Grafana dashboards
- Prometheus configs
- Nginx Proxy Manager configs
- Vaultwarden data
- Home Assistant config
- Node-RED flows

### Documentation ✅
- All deployment scripts
- Homelab handbook
- Status reports
- This backup guide

### Obsidian Vault ✅
- All notes and markdown files
- Attachments and images
- Templates and configs
- Graph connections preserved

### NOT Included ❌
- Media files (Plex/Jellyfin libraries) - too large
- Download cache (Transmission)
- Database dumps (separate backup needed)
- Log files

---

## Storage Requirements

- **Config backup:** ~20-50 MB
- **Obsidian vault:** ~600 MB
- **Total per backup:** ~650 MB
- **7 days retention:** ~4.5 GB

---

## Quick Commands

```bash
# Run backup now
~/homelab-deployment/pcloud-backup-enhanced.sh

# Check backup size
du -sh ~/homelab-backups/

# List all backups
ls -lh ~/homelab-backups/

# Check Obsidian vault backups
ls -lh ~/Documents/Obsidian/BACKUPS/

# Remove old backups (older than 14 days)
find ~/homelab-backups/ -name "*.tar.gz" -mtime +14 -delete
find ~/Documents/Obsidian/BACKUPS/ -name "*.zip" -mtime +14 -delete
```

---

## Troubleshooting

**"Script not found"**
```bash
cd ~/homelab-deployment
ls -l pcloud-backup-enhanced.sh
# If missing, re-download from outputs folder
```

**"Permission denied"**
```bash
chmod +x ~/homelab-deployment/pcloud-backup-enhanced.sh
chmod +x ~/homelab/Scripts/auto-backup-pcloud.sh
```

**"Backup taking too long"**
- Normal for first Obsidian vault backup (600MB)
- Subsequent backups are faster
- Compress time: ~30 seconds
- Upload time: ~2-3 minutes on 5Gbps

**"pCloud upload fails"**
- Use web upload instead (always works)
- Check internet connection
- Verify pCloud storage space available

---

## Emergency Recovery

If everything fails and you need to rebuild:

1. Download backup from pCloud
2. Extract to temporary location
3. Review HOMELAB-HANDBOOK.md for service setup
4. Restore configs one service at a time
5. Verify each service before moving to next

**The handbook contains complete rebuild instructions!**

