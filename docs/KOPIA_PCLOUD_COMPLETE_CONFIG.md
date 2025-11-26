# ☁️ Complete Kopia → pCloud Configuration Guide

**Step-by-step setup for automatic encrypted backups to pCloud**

---

## 📋 Prerequisites Checklist

Before starting, have these ready:

### ✅ pCloud Account
- [ ] Active pCloud account
- [ ] Login credentials ready
- [ ] Minimum 10GB free space (20GB+ recommended)

### ✅ Kopia Running
- [ ] Kopia accessible at http://localhost:8202
- [ ] Default password changed
- [ ] New password saved in 1Password

### ✅ Information Needed
- [ ] pCloud email address
- [ ] pCloud password (or app password)
- [ ] Strong repository encryption password (create new)

---

## 🚀 STEP 1: Prepare pCloud

### A. Login to pCloud Web

1. Go to: **https://www.pcloud.com**
2. Login with your credentials

### B. Enable WebDAV Access

1. Click **Settings** (top right gear icon)
2. Go to **Security** tab
3. Scroll to **"WebDAV Access"** section
4. Toggle **"Enable WebDAV"** → ON

**What is WebDAV?**
- Protocol that lets Kopia connect to pCloud
- Like FTP but more secure
- Required for backup software

### C. Get WebDAV Credentials

**Your WebDAV URL:**
```
https://webdav.pcloud.com
```

**Username:** Your pCloud email address
```
Example: your-email@gmail.com
```

**Password Options:**

**Option 1: Main Password (Simple)**
- Use your pCloud login password
- ⚠️ Less secure (gives full account access)

**Option 2: App Password (Recommended!)**
1. pCloud Settings → Security
2. Scroll to **"App Passwords"**
3. Click **"Create App Password"**
4. Name it: **"Kopia Backup"**
5. Click **"Create"**
6. Copy the generated password
7. **Save in 1Password!**

**Why app password?**
- ✅ More secure (limited access)
- ✅ Can revoke without changing main password
- ✅ Best practice for backup tools

### D. Create Backup Folder in pCloud

1. In pCloud web interface
2. Click **"New Folder"**
3. Name: **"HomeLab-Backups"**
4. Click **"Create"**

**Your full WebDAV path:**
```
https://webdav.pcloud.com/HomeLab-Backups
```

**Test WebDAV Connection (Optional):**
```bash
# Test from Mac terminal
curl -u "your-email@gmail.com:your-password" \
  https://webdav.pcloud.com/HomeLab-Backups

# Should return: empty directory listing (XML)
```

---

## 🔧 STEP 2: Configure Kopia Repository

### A. Open Kopia

**Access:** http://localhost:8202

**Login:**
- Username: `admin@kopia`
- Password: [your new password]

### B. Create New Repository

1. Click **"Repository"** in left sidebar
2. Click **"Create new repository"**

**What is a repository?**
- Storage location for your backups
- Encrypted container in pCloud
- Holds all backup data

### C. Select Storage Type

**Choose:** **WebDAV**

**Why WebDAV?**
- ✅ Works with pCloud
- ✅ Industry standard
- ✅ Secure HTTPS connection

### D. Enter WebDAV Configuration

**WebDAV URL:**
```
https://webdav.pcloud.com/HomeLab-Backups
```

**Important:**
- ✅ Include `https://`
- ✅ Include `/HomeLab-Backups` (folder name)
- ❌ Don't add trailing `/`

**Username:**
```
your-email@gmail.com
```
(Your pCloud email address)

**Password:**
```
[Your pCloud password or app password]
```

**Test Connection:**
- Click **"Test Connection"** button
- Should show: ✅ "Connection successful"

**If test fails:**
- Check WebDAV URL is correct
- Verify username/password
- Confirm WebDAV is enabled in pCloud
- Try removing `/HomeLab-Backups` and just use base URL

### E. Configure Repository Encryption

**This is CRITICAL - encrypts ALL your backups!**

**Repository Password:**
```
Create a STRONG password
Example: HomeLab-Backup-2024-Kopia-Secure-P@ssw0rd!
```

**Requirements:**
- ✅ At least 20 characters
- ✅ Mix of upper/lower case
- ✅ Numbers and symbols
- ✅ Unique (don't reuse)

**Confirm Password:**
- Enter same password again

**⚠️ CRITICAL - SAVE IN 1PASSWORD NOW!**

**1Password Entry:**
- Title: Kopia Repository Encryption Password
- Password: [your strong password]
- Category: Secure Note
- Notes: "CRITICAL - Required to restore HomeLab backups from pCloud. Without this, all backups are useless!"
- Tags: homelab, backup, critical

**Why so important?**
- Without this password, backups are UNRECOVERABLE
- No password recovery option
- No backdoor
- Lost password = lost data

### F. Advanced Repository Options (Optional)

**Click "Advanced Options" to customize:**

**Compression:**
- Algorithm: `zstd-fastest` (default)
- Good balance of speed vs size
- Recommended: Keep default

**Splitter:**
- Algorithm: `DYNAMIC-4M-BUZHASH` (default)
- For deduplication
- Recommended: Keep default

**Hash Algorithm:**
- `BLAKE2B-256-128` (default)
- Secure and fast
- Recommended: Keep default

**Encryption:**
- `AES256-GCM-HMAC-SHA256` (default)
- Military-grade encryption
- Recommended: Keep default

**Most users: Skip advanced options, defaults are excellent!**

### G. Create Repository

1. Review all settings
2. Click **"Create Repository"**
3. Wait for initialization (10-30 seconds)
4. Should see: ✅ "Repository created successfully"

**What just happened?**
- Kopia created encrypted repository in pCloud
- Generated encryption keys
- Created index structure
- Ready to accept backups

---

## 📦 STEP 3: Create Backup Snapshot Policy

### A. Go to Snapshots

1. Click **"Snapshots"** in left sidebar
2. Click **"New Snapshot"** button

**What is a snapshot?**
- Point-in-time backup of files
- Incremental (only changes)
- Can restore any version

### B. Configure Snapshot Path

**Path to backup:**
```
/data
```

**What does /data contain?**
```
/data maps to: ~/HomeLab/Docker/Data

Contains:
├── vaultwarden/       ← All passwords (CRITICAL!)
├── homeassistant/     ← Smart home config
├── grafana/           ← Dashboards
├── prometheus/        ← Metrics data
├── radarr/            ← Movie automation
├── sonarr/            ← TV automation
├── prowlarr/          ← Indexers
├── overseerr/         ← Request system
├── plex/              ← Media server config
├── nextcloud/         ← Cloud storage
├── paperless/         ← Document management
├── photoprism/        ← Photo library metadata
├── adguard/           ← DNS settings
└── [all other services]
```

**Total size:** ~1-2GB (or 10-15GB with Plex metadata)

### C. Configure What to Include/Exclude

**Include (default):**
- ✅ Everything in /data

**Exclude patterns:**

Click **"Add Pattern"** for each:

```
**/cache/**
**/Cache/**
**/logs/**
**/log/**
**/*.log
**/tmp/**
**/.tmp/**
**/temp/**
**/transcode/**
**/Transcode/**
**/transcodes/**
**/Backups/**
**/backups/**
**/.recycle/**
**/.Trash/**
```

**Why exclude these?**
- Cache: Temporary files (rebuild automatically)
- Logs: Not needed for restore
- Transcode: Plex temporary files (huge!)
- Backups: Don't backup backups

**Optional: Exclude Plex metadata (saves 10GB+)**

If Plex metadata is too large:
```
**/plex/config/Library/**
```

Keep Plex preferences but skip library:
```
✅ Include: /data/plex/config/Preferences.xml
❌ Exclude: /data/plex/config/Library
```

### D. Set Retention Policy

**How long to keep backups:**

**Option 1: Simple (Recommended for most users)**
```
Keep latest:           30 snapshots
Keep daily:            30 days
Keep weekly:           8 weeks
Keep monthly:          6 months
Keep yearly:           3 years
```

**Option 2: Paranoid (Maximum protection)**
```
Keep latest:           50 snapshots
Keep hourly:           48 hours
Keep daily:            60 days
Keep weekly:           24 weeks
Keep monthly:          24 months
Keep yearly:           10 years
```

**Option 3: Minimal (Save space)**
```
Keep latest:           10 snapshots
Keep daily:            7 days
Keep weekly:           4 weeks
Keep monthly:          3 months
```

**Recommendation:** Use Option 1 (Simple)

**What does this mean?**
- You can restore from any day in last 30 days
- Any week in last 8 weeks
- Any month in last 6 months
- Protects against ransomware (can go back in time)

### E. Configure Scheduling

**When to run backups:**

**Recommended schedule:**
```
⏰ Daily at 03:00 (3:00 AM)
```

**Why 3 AM?**
- ✅ Low system usage
- ✅ Before Watchtower runs (4 AM)
- ✅ Won't interfere with streaming
- ✅ Internet not congested
- ✅ You're asleep!

**Enable Schedule:**
- Toggle: **ON** ✅

**Alternative schedules:**

**Option 1: Twice Daily**
```
03:00 (3 AM)
15:00 (3 PM)
```

**Option 2: Every 6 Hours (Paranoid)**
```
00:00, 06:00, 12:00, 18:00
```

**Option 3: Weekly (Minimal)**
```
Sunday 03:00
```

### F. Configure Upload Limits (Optional)

**Bandwidth Throttling:**

If you want to limit backup upload speed:

```
Max upload speed: 50 Mbps
(or leave unlimited)
```

**When to throttle?**
- Limited internet bandwidth
- Don't want to saturate connection
- Share bandwidth with family

**For 5Gbps CityFibre:** Leave unlimited (you have plenty!)

### G. Set Snapshot Description

**Description:**
```
HomeLab Docker Configurations - Daily Backup
```

**Tags (optional):**
```
homelab, docker, production, critical
```

### H. Save Snapshot Policy

1. Review all settings
2. Click **"Create Snapshot"**
3. Snapshot policy is saved

✅ Automatic backups configured!

---

## 🧪 STEP 4: Run First Backup (Test!)

### A. Manual Snapshot

**Don't wait for 3 AM - test now!**

1. Go to **Snapshots**
2. Find your snapshot policy
3. Click **"Snapshot Now"** button

### B. Watch Progress

**Monitor the backup:**

**You'll see:**
- Files being scanned
- Upload progress
- Data transferred
- Time remaining

**First backup timing:**
- Small setup (1GB): 5-15 minutes
- Medium setup (5GB): 15-45 minutes
- Large setup (15GB): 45-90 minutes

**Depends on:**
- Total data size
- Upload speed (5Gbps = fast!)
- pCloud server speed
- Number of files

### C. View Backup Details

**After completion, you'll see:**

```
✅ Snapshot completed successfully

Stats:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Files:              12,847 files
Directories:        1,253 folders
Total Size:         2.3 GB
Compressed Size:    892 MB (61% compression)
Upload Time:        12 minutes 34 seconds
Deduplicated:       0 bytes (first backup)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Good compression?**
- Text/configs: 70-90% compression
- Databases: 50-80% compression
- Images: 10-20% compression (already compressed)

### D. Verify in pCloud

1. Login to **pCloud web**
2. Go to **HomeLab-Backups** folder
3. Should see files:
   ```
   kopia.repository
   _session/
   _log/
   p[hash]/    ← Encrypted data blocks
   q[hash]/    ← Encrypted data blocks
   ```

✅ Files are encrypted! Can't read them without password.

---

## ✅ STEP 5: Verify Backup Works (Critical!)

**IMPORTANT: Backups are useless if you can't restore!**

### A. Test Single File Restore

**Restore vaultwarden database:**

1. Go to **Snapshots**
2. Click on latest snapshot
3. Navigate to: `data/vaultwarden/data/db.sqlite3`
4. Click **"Restore"** button

**Restore options:**

**Destination:**
```
/tmp/test-restore
```

**Overwrite existing:** No
**Restore permissions:** Yes

Click **"Restore Files"**

### B. Verify Restored File

```bash
# Check file exists
ls -la /tmp/test-restore/db.sqlite3

# Check size is correct
du -h /tmp/test-restore/db.sqlite3

# Should see your Vaultwarden database
```

✅ If file exists and size looks right, restore works!

### C. Clean Up Test

```bash
# Remove test restore
rm -rf /tmp/test-restore
```

### D. Test Full Directory Restore

**Restore entire service config:**

1. Snapshots → Latest snapshot
2. Navigate to: `data/homeassistant`
3. Click **"Restore"**
4. Destination: `/tmp/test-full-restore`
5. Click **"Restore Files"**

**Verify:**
```bash
# Check directory structure
ls -la /tmp/test-full-restore/

# Should see all Home Assistant configs
# configuration.yaml, automations.yaml, etc.

# Clean up
rm -rf /tmp/test-full-restore
```

✅ **If both tests work, your backup is SOLID!**

---

## 📊 STEP 6: Configure Monitoring & Alerts

### A. Enable Email Notifications

**Get notified when backups fail:**

1. Click **Settings** (gear icon)
2. Go to **"Notifications"** tab

**SMTP Settings (for Gmail):**

```
SMTP Server:    smtp.gmail.com
Port:           587
Security:       STARTTLS
Username:       your-email@gmail.com
Password:       [Gmail App Password]
From Address:   your-email@gmail.com
To Address:     your-email@gmail.com
```

**Get Gmail App Password:**
1. https://myaccount.google.com/apppasswords
2. Create password for "Kopia"
3. Copy password
4. Use in Kopia settings

**Notification triggers:**
```
✅ Snapshot failed
✅ Snapshot warnings
⬜ Snapshot success (too many emails!)
✅ Repository errors
```

**Save settings**

### B. Test Email Notification

**Send test email:**

1. In notification settings
2. Click **"Send Test Email"**
3. Check your inbox

✅ Should receive test email from Kopia

### C. View Backup Logs

**Check backup history:**

1. Go to **Tasks** (left sidebar)
2. See all backup runs
3. Click any task to see details

**What to monitor:**
- ✅ All recent backups successful
- ❌ Any failures or warnings
- 📊 Backup duration (should be consistent)
- 📊 Data transferred (small after first backup)

---

## 🔐 STEP 7: Security Best Practices

### A. Save All Passwords in 1Password

**You need these saved:**

**Entry 1: Kopia Web Interface**
```
Title:    Kopia Web Interface
Username: admin@kopia
Password: [your Kopia password]
URL:      http://localhost:8202
Notes:    Access to Kopia backup system
```

**Entry 2: Kopia Repository Encryption**
```
Title:    Kopia Repository Encryption Password
Password: [your repository password]
Category: Secure Note
Notes:    ⚠️ CRITICAL - Required to restore backups!
          Without this, all backups are permanently lost.
          DO NOT lose this password!
Tags:     homelab, backup, critical, kopia
```

**Entry 3: pCloud WebDAV Credentials**
```
Title:    pCloud WebDAV for Kopia
Username: your-email@gmail.com
Password: [pCloud app password]
URL:      https://webdav.pcloud.com/HomeLab-Backups
Notes:    WebDAV access for Kopia backups
```

### B. Test Password Recovery

**Make sure you can access 1Password:**

1. Open 1Password
2. Search for "Kopia"
3. Find all 3 entries
4. Verify passwords are readable

**Backup 1Password itself:**
- Export Emergency Kit (PDF)
- Store securely (safe, bank deposit box)

### C. Document Recovery Procedure

**Create recovery document:**

```bash
cat > ~/HomeLab/docs/DISASTER_RECOVERY.md << 'EOFDOC'
# 🚨 HomeLab Disaster Recovery Procedure

## If M4 Mac Dies Completely

1. Get new Mac (or rebuild M4)
2. Install OrbStack: brew install orbstack
3. Install Kopia container
4. Connect to pCloud repository
5. Restore all files
6. Start Docker services

## Repository Connection Details

- Storage: WebDAV
- URL: https://webdav.pcloud.com/HomeLab-Backups
- Username: [in 1Password: "pCloud WebDAV"]
- Password: [in 1Password: "pCloud WebDAV"]
- Encryption: [in 1Password: "Kopia Repository Encryption"]

## Full procedure in: KOPIA_SETUP_GUIDE.md
EOFDOC
```

---

## 🎯 STEP 8: Ongoing Maintenance

### A. Monthly Checks

**Set calendar reminder - 1st of each month:**

**Checklist:**
- [ ] Check last backup successful
- [ ] Test restore random file
- [ ] Verify pCloud storage not full
- [ ] Check repository password still in 1Password
- [ ] Review backup size (growing as expected?)

**Commands:**
```bash
# Check Kopia status
docker ps | grep kopia

# View recent logs
docker logs kopia --tail 50
```

### B. Before Major Updates

**Manual backup before changes:**

1. Kopia → Snapshots
2. Click **"Snapshot Now"**
3. Wait for completion
4. Now safe to update services!

**Why?**
- ✅ Rollback point if update breaks something
- ✅ Peace of mind
- ✅ Extra protection

### C. Monitor pCloud Storage

**Check available space:**

1. pCloud web → Storage info
2. Should have plenty free
3. Upgrade plan if needed

**Storage estimates:**
```
Current backups:    1-2 GB
Compressed:         500-800 MB
30-day retention:   ~15-20 GB total
With Plex metadata: ~50-100 GB total
```

**pCloud plans:**
- Free: 10 GB (tight, no Plex metadata)
- Premium 500GB: Plenty for everything
- Lifetime 2TB: Never worry again!

### D. Verify Snapshot Schedule

**Check it's running:**

1. Kopia → Snapshots
2. View recent snapshots
3. Should see daily backups at 3 AM

**If backups missing:**
- Check schedule is enabled
- View Tasks → Check for errors
- Check email for failure alerts

---

## 🆘 Troubleshooting

### Issue 1: Can't Connect to pCloud

**Error:** "Connection failed" or "Authentication failed"

**Solutions:**

1. **Verify WebDAV enabled:**
   - pCloud → Settings → Security
   - Toggle WebDAV ON

2. **Check credentials:**
   - Username: Exact email address
   - Password: No typos
   - Try main password vs app password

3. **Test WebDAV directly:**
   ```bash
   curl -u "email:password" https://webdav.pcloud.com/
   # Should return XML directory listing
   ```

4. **Check URL format:**
   ```
   ✅ https://webdav.pcloud.com/HomeLab-Backups
   ❌ http://webdav.pcloud.com/HomeLab-Backups (no https)
   ❌ webdav.pcloud.com/HomeLab-Backups (no https://)
   ❌ https://webdav.pcloud.com/HomeLab-Backups/ (trailing slash)
   ```

### Issue 2: Backup Takes Forever

**First backup is slow - normal!**

**Subsequent backups slow:**

**Solutions:**

1. **Check upload speed:**
   ```bash
   # Test speed to pCloud
   curl -o /dev/null https://webdav.pcloud.com/test-file
   ```

2. **Exclude large unnecessary files:**
   - Plex metadata
   - Transcodes
   - Cache directories

3. **Check pCloud server status:**
   - May be temporary slowdown
   - Try again in 1 hour

4. **Reduce backup frequency:**
   - Change from daily to every 2-3 days
   - Temporary until upload speeds improve

### Issue 3: Backup Fails with "Out of Space"

**Error:** "No space left" or "Quota exceeded"

**Solutions:**

1. **Check pCloud storage:**
   - Login to pCloud
   - View available space
   - Upgrade plan if full

2. **Clean old snapshots:**
   - Kopia → Snapshots
   - Delete very old snapshots
   - Adjust retention policy

3. **Reduce backup scope:**
   - Exclude Plex metadata
   - Exclude large logs
   - Backup only critical data

### Issue 4: Can't Restore Files

**Error:** "Wrong password" or "Decryption failed"

**Solutions:**

1. **Verify repository password:**
   - Check 1Password entry
   - Case-sensitive!
   - No extra spaces

2. **Re-connect to repository:**
   - Kopia → Repository → Disconnect
   - Connect again with correct password

3. **Check repository integrity:**
   - Kopia → Repository → Verify
   - Runs integrity check

### Issue 5: Container Won't Start

**Error:** Kopia container keeps restarting

**Solutions:**

1. **Check logs:**
   ```bash
   docker logs kopia
   ```

2. **Verify directories exist:**
   ```bash
   ls -la ~/HomeLab/Docker/Data/kopia
   ```

3. **Check permissions:**
   ```bash
   sudo chown -R $(whoami) ~/HomeLab/Docker/Data/kopia
   ```

4. **Recreate container:**
   ```bash
   docker stop kopia
   docker rm kopia
   # Run install script again
   ```

---

## 📝 Complete Configuration Checklist

### pCloud Preparation:
- [ ] pCloud account active
- [ ] Logged into pCloud web
- [ ] WebDAV enabled
- [ ] App password created (recommended)
- [ ] HomeLab-Backups folder created
- [ ] Credentials saved in 1Password

### Kopia Setup:
- [ ] Kopia running on port 8202
- [ ] Default password changed
- [ ] New password saved in 1Password
- [ ] Repository created (WebDAV)
- [ ] Connected to pCloud successfully
- [ ] Repository encryption password set
- [ ] Repository password saved in 1Password

### Backup Configuration:
- [ ] Snapshot policy created
- [ ] Path set to /data
- [ ] Exclusions configured
- [ ] Retention policy set (30 days)
- [ ] Schedule set (3 AM daily)
- [ ] First backup completed
- [ ] Files visible in pCloud

### Verification:
- [ ] Test restore single file successful
- [ ] Test restore directory successful
- [ ] Email notifications configured
- [ ] Test email received
- [ ] Monthly reminder set

### Security:
- [ ] All 3 passwords in 1Password
- [ ] 1Password Emergency Kit backed up
- [ ] Recovery procedure documented
- [ ] Family member knows where passwords are

---

## 🎉 You're Done!

**Your HomeLab is now fully backed up!**

**What happens automatically:**
- ✅ Daily backups at 3 AM
- ✅ Only changed files uploaded (incremental)
- ✅ Encrypted before leaving your Mac
- ✅ 30-day rollback capability
- ✅ Email alerts if anything fails
- ✅ Compressed to save space

**Backup time:**
- First backup: 15-45 minutes
- Daily backups: 1-5 minutes (only changes)

**You can:**
- 🔄 Restore any file from any day
- 💾 Recover from complete Mac failure
- 🛡️ Protected from ransomware
- ☁️ Access backups from anywhere

**Sleep well - your HomeLab is protected!** 😴

---

## 📚 Quick Reference

**Access Kopia:**
```
http://localhost:8202
Username: admin@kopia
Password: [in 1Password]
```

**pCloud Repository:**
```
https://webdav.pcloud.com/HomeLab-Backups
```

**Manual backup now:**
```
Kopia → Snapshots → Snapshot Now
```

**Check status:**
```bash
docker ps | grep kopia
docker logs kopia
```

**Restart Kopia:**
```bash
docker restart kopia
```

**Emergency restore:**
```
See: ~/HomeLab/docs/DISASTER_RECOVERY.md
```

---

**Complete configuration guide!**
**Everything you need to backup HomeLab to pCloud!**

