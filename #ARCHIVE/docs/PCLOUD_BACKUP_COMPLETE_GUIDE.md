# ☁️ Complete pCloud Backup Solution for HomeLab

**Automatic encrypted backups of all your Docker configs to pCloud**

---

## 🎯 What Gets Backed Up

### Critical Data (MUST Backup):

```
/Users/homelab/HomeLab/Docker/Data/
├── vaultwarden/          🔴 CRITICAL - All your passwords!
├── homeassistant/        🔴 CRITICAL - Smart home config
├── grafana/              🟡 Important - Dashboards
├── nextcloud/            🟡 Important - Cloud data
├── plex/config/          🟡 Important - Plex metadata (large!)
├── radarr/               🟢 Good to have - Movie settings
├── sonarr/               🟢 Good to have - TV settings
├── prowlarr/             🟢 Good to have - Indexer config
├── adguard/              🟡 Important - DNS settings
├── paperless/            🟡 Important - Documents
├── photoprism/           🟡 Important - Photo metadata
├── gitea/                🟡 Important - Git repos
└── [all other services]  🟢 Config files
```

**Total size:** ~5-20GB (depending on Plex metadata)

### What NOT to Backup:

❌ **Media files** (Movies/TV on HomeLab-4TB) - Too large, can be re-downloaded
❌ **Plex transcode folder** - Temporary files
❌ **Download cache** - Temporary files

---

## 🔧 Duplicati - Your Backup Solution

**What is Duplicati?**
- Encrypted backups
- Automatic scheduling
- Incremental backups (only changes)
- Supports pCloud via WebDAV
- Web-based management

**Already installed!**
- Port: 8200
- Access: http://localhost:8200

---

## 📍 Step 1: Get pCloud WebDAV Credentials

### A. Login to pCloud Web

1. Go to: https://www.pcloud.com
2. Login to your account

### B. Enable WebDAV Access

1. **Settings** → **Security**
2. Find **"WebDAV Access"** section
3. **Enable WebDAV** if not already enabled

### C. Get WebDAV Details

**WebDAV URL:**
```
https://webdav.pcloud.com
```

**Username:** Your pCloud email
**Password:** Your pCloud password

**OR (More Secure) - Use App Password:**
1. pCloud → Settings → Security
2. Create App Password
3. Name it: "HomeLab Backup"
4. Use this instead of main password

### D. Create Backup Folder in pCloud

1. In pCloud web interface
2. Create folder: **"HomeLab-Backups"**
3. This is where all backups will go

**Your full path will be:**
```
https://webdav.pcloud.com/HomeLab-Backups
```

---

## 📍 Step 2: Configure Duplicati

### A. Open Duplicati

**Access:** http://localhost:8200

### B. Add Backup Job

1. Click **"Add backup"**
2. Choose **"Configure a new backup"**
3. Click **"Next"**

---

### C. General Settings (Page 1)

**Name:** HomeLab Docker Configs
**Description:** All Docker configuration files and critical data
**Encryption:** AES-256 encryption

**Passphrase:** Create a STRONG passphrase
```
Example: HomeLab-Backup-2024-SecurePassword!
```

⚠️ **SAVE THIS PASSPHRASE IN 1PASSWORD!** Without it, backups are useless!

**Passphrase strength:** Must be VERY strong (30+ characters recommended)

Click **"Next"**

---

### D. Destination Settings (Page 2)

**Storage Type:** Select **"WebDAV"**

**Server and path:**
```
https://webdav.pcloud.com
```

**Path on server:**
```
/HomeLab-Backups
```

**Username:** Your pCloud email
**Password:** Your pCloud password (or app password)

**Test connection:** Click **"Test connection"**
- Should show: ✅ "Connection worked!"

**Advanced options:**
- Use SSL: ✅ Yes (already in URL)

Click **"Next"**

---

### E. Source Data (Page 3)

**What to backup:**

Click **"Add path"** and add these directories:

```
✅ /Users/homelab/HomeLab/Docker/Data/vaultwarden
✅ /Users/homelab/HomeLab/Docker/Data/homeassistant
✅ /Users/homelab/HomeLab/Docker/Data/grafana
✅ /Users/homelab/HomeLab/Docker/Data/nextcloud
✅ /Users/homelab/HomeLab/Docker/Data/radarr
✅ /Users/homelab/HomeLab/Docker/Data/sonarr
✅ /Users/homelab/HomeLab/Docker/Data/prowlarr
✅ /Users/homelab/HomeLab/Docker/Data/overseerr
✅ /Users/homelab/HomeLab/Docker/Data/adguard
✅ /Users/homelab/HomeLab/Docker/Data/gitea
✅ /Users/homelab/HomeLab/Docker/Data/paperless
✅ /Users/homelab/HomeLab/Docker/Data/photoprism
✅ /Users/homelab/HomeLab/Docker/Data/calibre
✅ /Users/homelab/HomeLab/Docker/Data/freshrss
```

**OR (Easier) - Backup entire Data folder:**
```
✅ /Users/homelab/HomeLab/Docker/Data
```

**Exclude these patterns:**
```
❌ */transcode/*
❌ */cache/*
❌ */logs/*
❌ */.tmp/*
❌ */Cache/*
❌ */Backups/*
```

**To exclude Plex metadata** (it's large - 10GB+):
```
❌ /Users/homelab/HomeLab/Docker/Data/plex/config/Library
```
(Keep `/Users/homelab/HomeLab/Docker/Data/plex/config/Preferences.xml` though!)

Click **"Next"**

---

### F. Schedule (Page 4)

**When to run backups:**

**Recommended schedule:**
```
⏰ Daily at 3:00 AM
```

**Settings:**
- Run backup automatically: ✅ Yes
- Schedule: Daily
- Time: 03:00 (3 AM)

**Why 3 AM?**
- Low system usage
- Before Watchtower runs (4 AM)
- Won't interfere with streaming

**Alternative schedules:**
- Twice daily: 3 AM and 3 PM
- Every 6 hours (for paranoid protection)
- Weekly (for less critical data)

Click **"Next"**

---

### G. Options (Page 5)

**Backup retention:**

**Keep backups for:** 30 days
**Keep 1 backup per day for:** 7 days
**Keep 1 backup per week for:** 4 weeks
**Delete old backups:** Automatic cleanup

**This gives you:**
- Daily backups for a week
- Weekly backups for a month
- Protection from ransomware (30-day history)

**Upload options:**
- Upload chunk size: 50MB (default is fine)
- Number of async uploads: 4

**Compression:**
- Compression level: High (saves pCloud space)

**Advanced options (important!):**

Scroll down and add:
```
--number-of-retries=5
--retry-delay=10s
--log-retention=30D
```

Click **"Save"**

---

### H. Run First Backup

**Before leaving the wizard:**

1. Click **"Run now"** 
2. Watch progress
3. First backup takes longest (uploads everything)
4. Subsequent backups are FAST (only changes)

**Monitor progress:**
- Status shows: "Running"
- See files being uploaded
- Check pCloud web - files appearing!

**First backup:** 30-60 minutes (depending on size and internet speed)
**Daily backups:** 1-5 minutes (only changes)

---

## 📍 Step 3: Verify Backup Works

### A. Check pCloud

1. Login to pCloud web
2. Go to **HomeLab-Backups** folder
3. Should see files like:
   ```
   duplicati-[timestamp].dblock.zip.aes
   duplicati-[timestamp].dindex.zip.aes
   ```

✅ Files are encrypted! (.aes extension)

### B. Test Restore (IMPORTANT!)

**Why test?** Backups are useless if you can't restore!

**Test restore single file:**

1. In Duplicati → **Restore** tab
2. Select backup job: **HomeLab Docker Configs**
3. Choose timestamp (latest)
4. Browse to: `/vaultwarden/data/db.sqlite3`
5. Restore to: `/Users/homelab/test-restore/`
6. Click **"Restore"**
7. Enter encryption passphrase
8. Verify file appears in test-restore folder

✅ If file restored successfully, backups work!

**Delete test folder:**
```bash
rm -rf /Users/homelab/test-restore
```

---

## 📍 Step 4: Notifications (Get Alerted!)

### Setup Email Alerts

**When to get notified:**
- ✅ Backup fails
- ✅ Backup completes (optional)
- ✅ Backup warnings

### Configure Email:

1. Duplicati → Click backup job → **Edit**
2. Go to **Options** tab
3. Scroll to **Email notification**

**Settings:**

**Send email after backup:**
- On success: No (too many emails)
- On warning: Yes
- On error: Yes

**SMTP settings (Gmail):**

```
SMTP Server:    smtp.gmail.com
Port:           587
Use TLS:        Yes
Username:       your-email@gmail.com
Password:       (Gmail App Password)
From:           your-email@gmail.com
To:             your-email@gmail.com
```

**Get Gmail App Password:**
1. https://myaccount.google.com/apppasswords
2. Generate password
3. Use in Duplicati

**Test email:** Click **"Send test email"**

✅ Should receive test email!

---

## 📍 Step 5: Advanced Configuration

### A. Backup Multiple Destinations (Recommended!)

**Don't put all eggs in one basket!**

**Create second backup to:**
- Backblaze B2 (cheap cloud storage)
- Google Drive
- External USB drive
- Another pCloud account

**Setup:**
1. Add new backup job
2. Same source files
3. Different destination
4. Different schedule (offset by 1 hour)

**Result:** Two copies of everything!

### B. Backup Docker Compose Files

**Also backup your compose files!**

Add these to backup:
```
✅ /Users/homelab/HomeLab/Docker/Compose/*.yml
✅ /Users/homelab/HomeLab/docs/*.md
✅ /Users/homelab/HomeLab/scripts/*.sh
```

These are SMALL but CRITICAL for rebuilding!

### C. Database Backups

**For critical databases, export before backup:**

**Create pre-backup script:**

```bash
cat > ~/backup-databases.sh << 'EOFDB'
#!/bin/bash

# Backup PostgreSQL
docker exec postgres pg_dumpall -U postgres > \
  /Users/homelab/HomeLab/Docker/Data/postgres-backup.sql

# Backup MariaDB
docker exec mariadb mysqldump -u root -p'password' --all-databases > \
  /Users/homelab/HomeLab/Docker/Data/mariadb-backup.sql

# Backup MongoDB
docker exec mongodb mongodump --out \
  /Users/homelab/HomeLab/Docker/Data/mongodb-backup
EOFDB

chmod +x ~/backup-databases.sh
```

**Run before Duplicati:**
```bash
# Add to crontab at 2:55 AM (before 3 AM backup)
crontab -e

# Add:
55 2 * * * /Users/homelab/backup-databases.sh
```

Now database dumps are included in backup!

---

## 🔒 Security Best Practices

### 1. Use Strong Encryption Passphrase

**Bad:** password123
**Good:** HomeLab-Secure-Backup-2024-pCloud-Encrypted!

**Store passphrase in 1Password:**
- Title: Duplicati Backup Encryption
- Password: [your passphrase]
- Notes: "pCloud HomeLab backups - CRITICAL!"

### 2. Use pCloud App Password

Don't use main pCloud password in Duplicati.

**Create app password:**
- pCloud → Settings → Security
- App Passwords → Create
- Name: "Duplicati HomeLab"
- Use this instead

### 3. Test Restores Regularly

**Monthly test:**
1. Restore random file
2. Verify contents correct
3. Delete test restore

**Why?** Catch corruption/issues early!

### 4. Monitor Backup Success

**Check weekly:**
- Duplicati → View logs
- Last backup succeeded?
- Any errors?

**Setup Uptime Kuma monitor:**
- Monitor Duplicati endpoint
- Alert if backup fails

---

## 📊 Backup Size & pCloud Space

### Estimated Sizes:

```
Service              Size    Critical?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Vaultwarden         10MB     🔴 CRITICAL
Home Assistant      50MB     🔴 CRITICAL
Grafana             100MB    🟡 Important
Radarr/Sonarr       50MB     🟢 Config
Prowlarr            10MB     🟢 Config
AdGuard             20MB     🟡 Important
Nextcloud           500MB    🟡 Important
Plex metadata       10GB     🟠 Optional
Other services      500MB    🟢 Config
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL (w/o Plex)    1-2GB    
TOTAL (w/ Plex)     12-15GB  
```

**pCloud free:** 10GB
**pCloud Lifetime:** 500GB / 2TB

**Recommendation:**
- Skip Plex metadata OR
- Get pCloud Premium (cheap)

**Compression helps:**
- 2GB becomes ~500MB after compression + deduplication

---

## 🧪 Testing Your Backup

### Complete Test Procedure:

**1. Verify backup completed:**
```bash
# Check Duplicati logs
open http://localhost:8200
# Go to backup job → Show log
```

**2. Check pCloud:**
```
Login to pCloud
Go to HomeLab-Backups
See .aes encrypted files
```

**3. Test restore critical file:**
```
Duplicati → Restore
Select Vaultwarden database
Restore to temp location
Verify file exists and correct size
```

**4. Test restore everything (disaster recovery simulation):**
```bash
# Create test directory
mkdir /Users/homelab/test-full-restore

# In Duplicati → Restore
Select all files
Restore to: /Users/homelab/test-full-restore
Wait for completion
Verify all folders present

# Clean up
rm -rf /Users/homelab/test-full-restore
```

✅ **If full restore works, you're protected!**

---

## 🚨 Disaster Recovery Procedure

**What if M4 Mac dies completely?**

### Recovery Steps:

**1. Setup new Mac (or rebuild M4):**
```bash
# Install OrbStack
brew install orbstack

# Create directories
mkdir -p ~/HomeLab/Docker/Data
mkdir -p ~/HomeLab/Docker/Compose
```

**2. Install Duplicati:**
```bash
docker run -d \
  --name duplicati \
  -p 8200:8200 \
  -v ~/HomeLab/Docker/Data:/source \
  -v ~/duplicati-config:/config \
  lscr.io/linuxserver/duplicati:latest
```

**3. Restore from pCloud:**
```
Open Duplicati: http://localhost:8200
Restore → Direct restore from backup files
Connection: WebDAV → https://webdav.pcloud.com
Path: /HomeLab-Backups
Enter encryption passphrase (from 1Password!)
Select all files
Restore to: /Users/homelab/HomeLab/Docker/Data
Wait 30-60 minutes
```

**4. Restore Docker Compose files:**
```
(If you backed them up)
Restore from: /HomeLab/Docker/Compose
To: ~/HomeLab/Docker/Compose
```

**5. Start all services:**
```bash
cd ~/HomeLab/Docker/Compose
docker compose -f core.yml up -d
docker compose -f media.yml up -d
# etc.
```

**6. Verify everything works:**
```
Open Plex → All metadata restored!
Open Home Assistant → All automations work!
Open Vaultwarden → All passwords intact!
```

✅ **Back online in 1-2 hours!**

---

## 💡 Pro Tips

### 1. Backup Before Major Changes

**Before updating services:**
```bash
# Force backup now
docker exec duplicati duplicati-cli backup \
  --backup-name="HomeLab Docker Configs"
```

### 2. Multiple Backup Jobs

**Create separate jobs for:**
- Critical (daily): Vaultwarden, Home Assistant
- Important (daily): Configs, databases  
- Media metadata (weekly): Plex, PhotoPrism
- Documents (daily): Paperless, Nextcloud

**Different schedules = less load**

### 3. Bandwidth Throttling

**Limit upload speed** (don't saturate connection):

Duplicati Options:
```
--throttle-upload=5MB
```

Uploads max 5MB/s, leaves bandwidth for streaming

### 4. Retention Strategy

**For critical data:**
- Keep hourly backups: 24 hours
- Keep daily backups: 30 days
- Keep weekly backups: 6 months
- Keep monthly backups: 2 years

**For configs:**
- Keep daily: 7 days
- Keep weekly: 4 weeks
- Keep monthly: 6 months

### 5. Verify Backups Automatically

**Create verification script:**

```bash
cat > ~/verify-backups.sh << 'EOFVERIFY'
#!/bin/bash

# Check last backup time
LAST_BACKUP=$(docker exec duplicati cat /config/last-backup-time)
NOW=$(date +%s)
DIFF=$((NOW - LAST_BACKUP))

# If last backup > 26 hours ago
if [ $DIFF -gt 93600 ]; then
    echo "Backup FAILED or delayed!"
    # Send alert
    osascript -e 'display notification "Backup check failed!" with title "HomeLab Alert"'
fi
EOFVERIFY

chmod +x ~/verify-backups.sh

# Run daily at 5 AM
crontab -e
# Add: 0 5 * * * ~/verify-backups.sh
```

---

## 📝 Backup Checklist

### Initial Setup:
- [ ] Duplicati accessible at :8200
- [ ] pCloud WebDAV credentials obtained
- [ ] Backup job created
- [ ] Encryption passphrase set (STRONG!)
- [ ] Passphrase saved in 1Password
- [ ] Source directories configured
- [ ] Exclusions set (transcode, cache, logs)
- [ ] Schedule set (3 AM daily)
- [ ] Retention policy configured (30 days)
- [ ] First backup completed
- [ ] Verified files in pCloud
- [ ] Email notifications configured
- [ ] Test restore completed successfully

### Monthly Maintenance:
- [ ] Check backup logs (all successful?)
- [ ] Verify pCloud storage not full
- [ ] Test restore random file
- [ ] Check encryption passphrase still in 1Password
- [ ] Review backup size (growing too fast?)

### After Major Changes:
- [ ] Manual backup before updates
- [ ] Verify backup after adding services
- [ ] Test restore after configuration changes

---

## 🎯 Quick Commands

**Manual backup now:**
```bash
# Via web UI: Duplicati → Run now

# Or visit:
open http://localhost:8200
```

**Check last backup:**
```bash
docker logs duplicati | grep "backup completed"
```

**View backup size:**
```bash
# In pCloud web interface
# Or Duplicati → About → Database size
```

**Test connection:**
```bash
# In Duplicati → Edit job → Test connection
```

**View logs:**
```bash
docker logs duplicati --tail 100
```

---

## 🆘 Troubleshooting

### Backup Fails with "Connection Timeout"

**Solution:**
- Check pCloud credentials
- Test WebDAV URL in browser
- Check internet connection
- Increase timeout in options

### "Access Denied" Error

**Solution:**
- Verify pCloud username/password
- Check WebDAV is enabled in pCloud
- Try app password instead

### Backup Takes Forever

**Solutions:**
- Exclude large files (Plex metadata)
- Reduce upload bandwidth
- Check pCloud upload speed
- Split into multiple jobs

### Can't Restore - "Wrong Passphrase"

**Solution:**
- Double-check passphrase (case-sensitive!)
- Check 1Password for correct one
- Make sure no extra spaces
- Try copying/pasting instead of typing

### pCloud Storage Full

**Solutions:**
- Clean old backups (retention policy)
- Exclude large files
- Upgrade pCloud plan
- Use compression (already on)

---

## 📊 Summary

**You now have:**
- ✅ Automatic daily backups at 3 AM
- ✅ Encrypted backups to pCloud
- ✅ 30-day retention (rollback capability)
- ✅ All critical configs backed up
- ✅ Email alerts on failure
- ✅ Tested restore procedure
- ✅ Disaster recovery plan

**Your HomeLab is PROTECTED! 🛡️**

**What gets backed up:**
- All Docker configs
- All database files
- All critical data
- All your work!

**What happens automatically:**
- Daily backups at 3 AM
- Incremental (only changes)
- Compressed & encrypted
- Old backups cleaned up
- Email if any issues

**Restoration:**
- Single file: 30 seconds
- Full restore: 30-60 minutes
- Complete rebuild: 1-2 hours

**Sleep well knowing your HomeLab is backed up! 😴**

