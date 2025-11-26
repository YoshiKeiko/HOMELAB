# STEP C: BACKUP SETUP

**Time Required:** 5 minutes  
**Goal:** Automated daily backups to pCloud

---

## What Gets Backed Up

✅ **Included:**
- Docker Compose files (service definitions)
- Container configurations
- Heimdall settings
- AdGuard settings
- Grafana dashboards
- Home Assistant config
- Scripts and automation
- This handbook

❌ **Excluded (too large):**
- Media files (movies, TV shows)
- Photo libraries
- Database data (use service-specific backups)

---

## Step 1: Run Backup Script (2 minutes)

```bash
cd ~/homelab-deployment
chmod +x pcloud-backup-setup.sh
./pcloud-backup-setup.sh
```

**What This Does:**
1. Creates backup of all configs
2. Compresses to `.tar.gz` file
3. Installs pCloud CLI (if needed)
4. Guides you through upload
5. Creates automated backup script

---

## Step 2: Upload to pCloud (2 minutes)

### Option A: Using pCloud CLI (Recommended)

**After script finishes, it will prompt you:**

```bash
# Login to pCloud
pcloud

# You'll be asked for:
# - Email: your-email@example.com
# - Password: your-pcloud-password

# Upload the backup
pcloud upload ~/homelab-backups/homelab-config-YYYYMMDD-HHMMSS.tar.gz /HomeLab-Backups/
```

### Option B: Using pCloud Web Interface

1. Go to https://my.pcloud.com
2. Login with your credentials
3. Create folder: `HomeLab-Backups`
4. Upload file from: `~/homelab-backups/homelab-config-YYYYMMDD-HHMMSS.tar.gz`

---

## Step 3: Set Up Automated Daily Backups (1 minute)

The script creates an automated backup script. Now schedule it:

```bash
# Edit crontab
crontab -e

# Add this line (runs at 2 AM daily):
0 2 * * * ~/homelab/Scripts/auto-backup-pcloud.sh

# Save and exit (ESC, :wq, ENTER)
```

**What This Does:**
- Runs every night at 2 AM
- Creates new backup
- Uploads to pCloud (after initial setup)
- Keeps last 7 days of backups
- Deletes older backups automatically

---

## Step 4: Verify Backup (30 seconds)

```bash
# Check backup was created
ls -lh ~/homelab-backups/

# Should see:
# homelab-config-YYYYMMDD-HHMMSS.tar.gz
```

**Check file size:**
- Should be 10-50 MB (configs only)
- If larger, it included data files

---

## Restore Procedure (When Needed)

### Full System Restore

```bash
# 1. Download backup from pCloud
cd ~/Downloads

# 2. Extract backup
tar xzf homelab-config-YYYYMMDD-HHMMSS.tar.gz
cd homelab-config-YYYYMMDD-HHMMSS

# 3. Review what's included
ls -la

# 4. Copy compose files
cp -r compose/* ~/homelab/Docker/

# 5. Redeploy services
cd ~/homelab/Docker
docker compose -f service-name.yml up -d

# 6. Restore individual configs (if needed)
# Each service has its config in configs/ folder
```

### Restore Single Service Config

```bash
# Extract backup
tar xzf homelab-config-YYYYMMDD-HHMMSS.tar.gz

# Find service config
cd homelab-config-YYYYMMDD-HHMMSS/configs

# Copy to running container
docker cp service-config.tar.gz container-name:/config/

# Restart container
docker restart container-name
```

---

## Testing Your Backup

### Test Backup Integrity

```bash
# Verify tar file is valid
tar tzf ~/homelab-backups/homelab-config-*.tar.gz | head

# Should show list of files
```

### Test Restore (Dry Run)

```bash
# Extract to temp location
cd /tmp
tar xzf ~/homelab-backups/homelab-config-*.tar.gz

# Verify contents
ls -la homelab-config-*/
```

---

## Backup Locations

**Local Mac:**
```
~/homelab-backups/
├── homelab-config-20251119-140523.tar.gz
├── homelab-config-20251118-020000.tar.gz
└── homelab-config-20251117-020000.tar.gz
```

**pCloud:**
```
/HomeLab-Backups/
├── homelab-config-20251119-140523.tar.gz
├── homelab-config-20251118-020000.tar.gz
└── (older backups...)
```

---

## Backup Schedule

**Manual Backup:**
```bash
~/homelab-deployment/pcloud-backup-setup.sh
```

**Automated Backup:**
- Runs: 2:00 AM daily
- Retention: 7 days local, unlimited on pCloud
- Size: ~10-50 MB per backup

---

## What's Included in Each Backup

### Compose Files
- All Docker Compose YAML files
- Service definitions
- Network configurations

### Container Configs
- AdGuard Home settings
- Heimdall layout and links
- Grafana dashboards
- Prometheus configs
- Nginx Proxy Manager configs
- Home Assistant configuration
- Vaultwarden settings

### Scripts
- Installation scripts
- Automation scripts
- Testing scripts

### Documentation
- This handbook
- Service lists
- Network configuration

---

## ✅ COMPLETION CHECKLIST

- [ ] Backup script executed successfully
- [ ] Backup file created in ~/homelab-backups/
- [ ] Backup uploaded to pCloud
- [ ] Automated backup scheduled (crontab)
- [ ] Backup tested (extracted successfully)
- [ ] Restore procedure understood

---

## 🔐 Security Note

**Backups contain:**
- Service configurations
- Some passwords/API keys
- Network settings

**Keep secure:**
- ✅ pCloud uses encryption
- ✅ Keep pCloud password secure in 1Password
- ✅ Enable 2FA on pCloud
- ❌ Don't share backup files publicly

---

## Troubleshooting

### "pCloud command not found"

```bash
# Install pCloud CLI manually
curl -L -o /tmp/pcloud https://p-def8.pcloud.com/cBZHNzLboZZJ37ZZZvAgjX7Z0ZydZZZZkZ5ZZZ0HZZo5ZkZvx0ZsHZGUZDUZikZzHZxUZqHZ7kZTHZEXZq9ZZaHZ01ZrcH0ZGJHZfsZR5H0aZ15ZkpfUZCjnx/pcloudcc
chmod +x /tmp/pcloud
sudo mv /tmp/pcloud /usr/local/bin/pcloud
```

### "Permission denied"

```bash
chmod +x pcloud-backup-setup.sh
```

### "Backup too large"

```bash
# Check what's being backed up
du -sh ~/homelab-backups/*

# Should be < 100 MB
# If larger, check for data files in configs
```

---

## Next Step

When ready, move to **STEP B: FIX BROKEN SERVICES**
