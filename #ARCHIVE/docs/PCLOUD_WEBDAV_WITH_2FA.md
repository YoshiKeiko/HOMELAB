# 🔐 pCloud WebDAV Access with 2FA Enabled

**How to connect Kopia to pCloud when you have 2FA enabled**

---

## ⚠️ The Problem

**With 2FA enabled, you CANNOT use:**
- ❌ Your regular pCloud password
- ❌ WebDAV with main credentials
- ❌ Direct authentication

**You MUST use:**
- ✅ App Password (special password for applications)

---

## 🔑 Solution: Create App Password

### Step 1: Login to pCloud Web

1. Go to: **https://www.pcloud.com**
2. Login with your email + password + 2FA code

### Step 2: Navigate to App Passwords

**Path:**
```
Settings → Security → App Passwords
```

**Detailed steps:**

1. Click **Settings** (gear icon, top right)
2. Click **Security** tab (left sidebar)
3. Scroll down to **"App Passwords"** section

### Step 3: Create New App Password

1. Click **"+ Create App Password"**

2. **Name the password:**
   ```
   Kopia HomeLab Backup
   ```
   
   (So you know what it's for later)

3. Click **"Create"**

4. **pCloud generates a special password:**
   ```
   Example: Ab3xK9mP2qR7sT4vW8yZ
   ```

5. **⚠️ COPY THIS IMMEDIATELY!**
   - You can only see it ONCE
   - pCloud won't show it again
   - If you lose it, create a new one

### Step 4: Save App Password in 1Password

**Create 1Password entry NOW:**

```
Title:    pCloud App Password for Kopia
Username: your-email@gmail.com
Password: [the app password you just copied]
URL:      https://webdav.pcloud.com
Notes:    App password for Kopia backup access
          Created: [today's date]
Tags:     pcloud, kopia, backup, homelab
```

**⚠️ Save before continuing!**

---

## ☁️ Configure Kopia with App Password

### Step 1: Open Kopia

**Access:** http://localhost:8202

**Login:**
- Username: admin
- Password: [your Kopia password, or just open if no password]

### Step 2: Create Repository

1. Click **"Repository"** (left sidebar)
2. Click **"Create new repository"**

### Step 3: Select WebDAV Storage

**Storage Type:** Select **"WebDAV"**

### Step 4: Enter WebDAV Configuration

**Server URL:**
```
https://webdav.pcloud.com/HomeLab-Backups
```

**Important notes:**
- ✅ Include `https://`
- ✅ Include folder name `/HomeLab-Backups`
- ✅ No trailing slash
- ✅ Exact URL as shown

**Username:**
```
your-email@gmail.com
```
(Your pCloud email address - exact same email you login with)

**Password:**
```
[Paste the APP PASSWORD - NOT your main password!]
```

**⚠️ Use the App Password you just created, NOT your regular pCloud password!**

### Step 5: Test Connection

1. Click **"Test Connection"** button

2. **Should show:**
   ```
   ✅ Connection successful
   ```

3. **If it fails, check:**
   - Using App Password (not main password)
   - Email address is exact
   - URL includes https://
   - Folder name is correct
   - No extra spaces in password

### Step 6: Set Repository Encryption

**Repository Password:**
```
Create a NEW strong password
Example: HomeLab-Kopia-Backup-2024-Secure!
```

**⚠️ THIS IS DIFFERENT from App Password!**

**This password:**
- Encrypts your backup data
- Required to restore backups
- CANNOT be recovered if lost
- Must be VERY strong

**Confirm Password:**
- Enter same password again

**⚠️ SAVE IN 1PASSWORD IMMEDIATELY!**

**1Password Entry:**
```
Title:    Kopia Repository Encryption Password
Password: [your new encryption password]
Category: Secure Note
Notes:    ⚠️ CRITICAL - Required to restore all backups!
          Without this password, backups are permanently lost!
          This is NOT the same as pCloud app password!
Tags:     kopia, backup, critical, encryption
```

### Step 7: Create Repository

1. Review all settings
2. Click **"Create Repository"**
3. Wait 10-30 seconds
4. Should see: ✅ "Repository created successfully"

---

## 📦 Create Backup Snapshot

### Now configure what to backup:

1. Click **"Snapshots"** (left sidebar)
2. Click **"New Snapshot"**

3. **Path to backup:**
   ```
   /data
   ```

4. **Exclude patterns:**
   ```
   **/cache/**
   **/logs/**
   **/transcode/**
   ```

5. **Schedule:**
   ```
   Daily at 03:00
   ```

6. **Retention:**
   ```
   Keep 30 days
   ```

7. Click **"Create Snapshot"**

8. Click **"Snapshot Now"** to run first backup

---

## 🔍 Verify It's Working

### Check pCloud

1. Login to pCloud web
2. Go to **HomeLab-Backups** folder
3. Should see Kopia files:
   ```
   kopia.repository
   _session/
   p[hash]/
   q[hash]/
   ```

✅ Backup is working!

---

## 🔐 Three Passwords to Remember

**Summary of what you need saved in 1Password:**

### 1. Kopia Web Interface (optional)
```
Title:    Kopia Backup System
Username: admin
Password: [your Kopia UI password]
URL:      http://localhost:8202
```

### 2. pCloud App Password (for connection)
```
Title:    pCloud App Password for Kopia
Username: your-email@gmail.com
Password: [pCloud app password - random characters]
URL:      https://webdav.pcloud.com
```

### 3. Kopia Repository Encryption (CRITICAL!)
```
Title:    Kopia Repository Encryption Password
Password: [your strong encryption password]
Notes:    ⚠️ REQUIRED TO RESTORE BACKUPS!
```

---

## 🆘 Troubleshooting

### Error: "Authentication Failed"

**Solution:**
1. Verify you're using **App Password**, NOT main password
2. Check email address is exact
3. Check no extra spaces in app password
4. Recreate app password if needed

### Error: "Connection Failed"

**Solution:**
1. Check URL: `https://webdav.pcloud.com/HomeLab-Backups`
2. Verify HomeLab-Backups folder exists in pCloud
3. Test internet connection
4. Try removing `/HomeLab-Backups` from URL (use base)

### Can't Find App Passwords in pCloud

**pCloud Location:**
```
Settings → Security → App Passwords
```

**If section missing:**
- Log out and back in
- Try desktop app Settings
- Contact pCloud support

### Lost App Password

**Solution:**
1. Go to pCloud → Settings → Security → App Passwords
2. Find "Kopia HomeLab Backup"
3. Click **"Delete"**
4. Create new app password
5. Update in Kopia repository settings

---

## 📊 What Gets Backed Up

**Your /data folder contains:**

```
~/HomeLab/Docker/Data/
├── vaultwarden/       ← All passwords (CRITICAL!)
├── homeassistant/     ← Smart home config
├── grafana/           ← Dashboards
├── prometheus/        ← Metrics
├── radarr/            ← Movie automation
├── sonarr/            ← TV automation
├── prowlarr/          ← Indexers
├── overseerr/         ← Requests
├── plex/              ← Media config
├── nextcloud/         ← Cloud storage
├── paperless/         ← Documents
├── photoprism/        ← Photos metadata
├── adguard/           ← DNS settings
└── [all services]
```

**Total:** 1-2GB (or 10-15GB with Plex metadata)
**Compressed:** ~500MB-1GB
**Upload time:** 15-45 minutes first time, 1-5 minutes daily

---

## ✅ Success Checklist

Setup Complete:
- [ ] pCloud 2FA enabled (good security!)
- [ ] App password created in pCloud
- [ ] App password saved in 1Password
- [ ] Kopia repository created
- [ ] Connected to pCloud via WebDAV
- [ ] Repository encryption password set
- [ ] Encryption password saved in 1Password
- [ ] Snapshot policy created
- [ ] First backup completed
- [ ] Verified files in pCloud
- [ ] Test restore successful

Monthly Maintenance:
- [ ] Check backups running daily
- [ ] Test restore random file
- [ ] Verify pCloud storage not full
- [ ] All passwords still in 1Password

---

## 🎉 You're Done!

**Your HomeLab is now backing up to pCloud with 2FA security!**

**What happens automatically:**
- ✅ Daily backups at 3 AM
- ✅ Encrypted before upload
- ✅ Only changed files uploaded
- ✅ 30-day retention
- ✅ Protected by 2FA + App Password

**Security layers:**
1. 🔐 pCloud 2FA
2. 🔑 App Password (revocable)
3. 🔒 Repository encryption
4. 🛡️ End-to-end encryption

**Sleep well - your data is VERY secure!** 😴

---

## 📝 Quick Reference

**WebDAV URL:**
```
https://webdav.pcloud.com/HomeLab-Backups
```

**Credentials:**
```
Username: your-email@gmail.com
Password: [App Password from 1Password]
```

**Create new App Password:**
```
pCloud → Settings → Security → App Passwords → Create
```

**Access Kopia:**
```
http://localhost:8202
```

**Manual backup:**
```
Kopia → Snapshots → Snapshot Now
```

---

**Complete setup with 2FA protection!** 🔐

