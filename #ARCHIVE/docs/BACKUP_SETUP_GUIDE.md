# 💾 Backup Configuration Guide

## Quick Setup for pCloud

### Step 1: Get pCloud Credentials

**If you have 2FA enabled:**
1. pCloud → Settings → Security
2. App Passwords → Create
3. Name: "Duplicati HomeLab"
4. Copy generated password
5. Save in 1Password

**WebDAV Details:**
- URL: `https://webdav.pcloud.com/HomeLab-Backups`
- Username: your-pcloud-email@example.com
- Password: [app password or main password]

### Step 2: Configure Duplicati

1. Open http://localhost:8200
2. Add backup → Configure new backup

**General:**
- Name: HomeLab Docker Configs
- Encryption: AES-256
- Passphrase: [create strong password - save in 1Password!]

**Destination:**
- Type: WebDAV
- Server: `https://webdav.pcloud.com/HomeLab-Backups`
- Username: [your pCloud email]
- Password: [app password]
- Test connection ✓

**Source:**
- Path: `/source`
- Exclude: `*/cache/*`, `*/logs/*`, `*/transcode/*`

**Schedule:**
- Daily at 03:00

**Options:**
- Keep 30 days
- Compression: High

3. Save and run first backup

### Step 3: Verify

1. Check pCloud for encrypted files
2. Test restore of single file
3. Verify in Duplicati logs

### Automatic Operation

Backups run automatically at 3 AM daily.

No maintenance needed!

**Important Files to Save:**
- Duplicati encryption passphrase (1Password)
- pCloud credentials (1Password)
- Encryption key: ~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
