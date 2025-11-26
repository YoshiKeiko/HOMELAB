---
title: Volume 12: Backup Strategy (Day 13)
tags: [homelab, backup, disaster-recovery, kopia]
created: 2025-11-11
type: homelab-guide
---

# Volume 12: Backup Strategy (Day 13)

**Automated Encrypted Backups to pCloud**

This volume covers complete backup automation and disaster recovery.

## What You'll Complete

- Kopia backup client
- pCloud offsite storage
- Automated daily backups
- Encrypted backups (AES-256)
- Backup verification
- Disaster recovery plan
- Restore procedures

## Prerequisites

- Volumes 01-11 complete
- pCloud account (2TB)
- External 4TB SSD for local cache
- Backup locations planned

---

# Guide 81: Kopia Setup

## Deploy Kopia

```bash
docker compose -f docker-compose-master.yml up -d kopia
```

Access: http://192.168.50.10:51515

## Initial Setup

1. Create repository
2. Choose storage: WebDAV (for pCloud)
3. Configuration:
   ```
   URL: https://webdav.pcloud.com
   Username: steve-smithit@outlook.com
   Password: [from 1Password]
   Path: /Backups/M4-HomeLab
   ```

4. Encryption:
   - Enable: Yes
   - Password: [strong passphrase]
   - **Save to 1Password immediately!**

**⚠️ CRITICAL: Without encryption password, backups are unrecoverable!**

---

# Guide 82: Backup Configuration

## What to Backup

**Critical Data:**
```
Priority 1 (Daily):
├─ Docker configs: ~/HomeLab/Docker/Configs/
├─ Scripts: ~/HomeLab/Scripts/
├─ 1Password exports: ~/HomeLab/Documentation/
├─ Home Assistant: ~/HomeLab/Docker/Data/homeassistant/
└─ Databases: ~/HomeLab/Docker/Data/*/

Priority 2 (Weekly):
├─ Media metadata: ~/HomeLab/Docker/Data/plex/
├─ Photos: /Volumes/External4TB/Photos/
└─ Documents: /Volumes/External4TB/Documents/

Priority 3 (Monthly):
├─ Media: /Volumes/External4TB/Media/ (optional - large)
└─ VM snapshots: /Volumes/External4TB/VMs/Backups/
```

## Create Backup Policies

**Policy 1: Critical Daily**
```
Name: Critical-Daily
Paths: 
  - ~/HomeLab/Docker/Configs
  - ~/HomeLab/Scripts
  - ~/HomeLab/Documentation
Schedule: Daily at 02:00
Retention:
  - Keep daily for 7 days
  - Keep weekly for 4 weeks
  - Keep monthly for 12 months
```

**Policy 2: Data Weekly**
```
Name: Data-Weekly
Paths:
  - /Volumes/External4TB/Photos
  - ~/HomeLab/Docker/Data
Schedule: Weekly on Sunday at 03:00
Retention:
  - Keep weekly for 8 weeks
  - Keep monthly for 6 months
```

---

# Guide 83: Automation Scripts

## Pre-Backup Script

Create: ~/HomeLab/Scripts/Backup/pre-backup.sh

```bash
#!/bin/bash

# Pre-backup script - prepare data for backup

echo "Starting pre-backup tasks..."

# Export 1Password vault
op document get "HomeLab Backup" --output ~/HomeLab/Documentation/1password-export.json

# Stop services that need consistent backup
docker stop mariadb postgres
sleep 5

# Dump databases
docker exec mariadb mysqldump --all-databases > ~/HomeLab/Documentation/mariadb-backup.sql
docker exec postgres pg_dumpall > ~/HomeLab/Documentation/postgres-backup.sql

# Create service list
docker ps --format "{{.Names}}" > ~/HomeLab/Documentation/running-containers.txt

# Export Docker compose files
cp ~/HomeLab/Docker/Compose/*.yml ~/HomeLab/Documentation/compose-backup/

echo "Pre-backup complete!"
```

## Post-Backup Script

Create: ~/HomeLab/Scripts/Backup/post-backup.sh

```bash
#!/bin/bash

# Post-backup script - restart services

echo "Starting post-backup tasks..."

# Restart stopped services
docker start mariadb postgres

# Verify backup completed
if [ $? -eq 0 ]; then
    echo "Backup completed successfully!"
    curl -d "HomeLab backup completed successfully" ntfy.sh/stevehomelab-alerts-x7k9m2
else
    echo "Backup FAILED!"
    curl -d "⚠️ HomeLab backup FAILED! Check logs." ntfy.sh/stevehomelab-alerts-x7k9m2
fi

echo "Post-backup complete!"
```

Make executable:
```bash
chmod +x ~/HomeLab/Scripts/Backup/*.sh
```

---

# Guide 84: Backup Scheduling

## Automated Backups

**Daily critical backup:**
```bash
# Create LaunchAgent
cat > ~/Library/LaunchAgents/com.homelab.backup.daily.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.homelab.backup.daily</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/steve/HomeLab/Scripts/Backup/daily-backup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>2</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/Users/steve/HomeLab/Documentation/backup-daily.log</string>
</dict>
</plist>
EOF

launchctl load ~/Library/LaunchAgents/com.homelab.backup.daily.plist
```

## Create Backup Scripts

~/HomeLab/Scripts/Backup/daily-backup.sh:
```bash
#!/bin/bash

# Run pre-backup
~/HomeLab/Scripts/Backup/pre-backup.sh

# Run Kopia backup
docker exec kopia kopia snapshot create ~/HomeLab/Docker/Configs \
  --description "Daily critical backup"

docker exec kopia kopia snapshot create ~/HomeLab/Scripts \
  --description "Daily scripts backup"

# Run post-backup
~/HomeLab/Scripts/Backup/post-backup.sh
```

---

# Guide 85: Backup Verification

## Verify Backups

```bash
# List snapshots
docker exec kopia kopia snapshot list

# Verify repository
docker exec kopia kopia repository validate-provider

# Check last backup
docker exec kopia kopia snapshot list --latest

# Check backup size
docker exec kopia kopia snapshot estimate ~/HomeLab/Docker/Configs
```

## Test Restore

**Regularly test restores:**
```bash
# Restore to test location
docker exec kopia kopia restore [snapshot-id] /tmp/restore-test

# Verify files
ls -la /tmp/restore-test

# Clean up
rm -rf /tmp/restore-test
```

**Do this monthly!**

---

# Guide 86: Disaster Recovery Plan

## Scenario 1: Single Service Failure

**Example: Plex container corrupted**

```bash
# Stop container
docker stop plex

# Restore config from backup
docker exec kopia kopia restore [snapshot-id] ~/HomeLab/Docker/Data/plex

# Start container
docker start plex
```

Time: 5-10 minutes

---

## Scenario 2: M4 Mac Mini Failure

**Full system restore:**

1. **Get new M4 or repair**

2. **Install macOS** (Volume 02)

3. **Setup network** (Volume 02)

4. **Install Docker** (Volume 03)

5. **Install Kopia:**
```bash
docker run -d --name kopia \
  -v ~/HomeLab/Docker/Data/kopia:/app/config \
  kopia/kopia:latest server start \
  --insecure
```

6. **Connect to pCloud:**
```bash
docker exec kopia kopia repository connect webdav \
  --url https://webdav.pcloud.com \
  --username steve-smithit@outlook.com \
  --password [from 1Password]

# Enter encryption password from 1Password
```

7. **List available snapshots:**
```bash
docker exec kopia kopia snapshot list
```

8. **Restore Docker configs:**
```bash
docker exec kopia kopia restore [snapshot-id] ~/HomeLab/
```

9. **Start all services:**
```bash
cd ~/HomeLab/Docker/Compose
docker compose -f docker-compose-master.yml up -d
```

10. **Verify everything works**

Time: 2-4 hours

---

## Scenario 3: External SSD Failure

**4TB drive dies:**

1. **Get new 4TB SSD**

2. **Format** (Volume 02, Guide 04)

3. **Restore photos:**
```bash
docker exec kopia kopia restore [photos-snapshot] /Volumes/External4TB/Photos
```

4. **Restore media metadata:**
```bash
docker exec kopia kopia restore [plex-snapshot] ~/HomeLab/Docker/Data/plex
```

5. **Media files:**
   - If backed up: Restore from Kopia
   - If not: Re-download from sources
   - Or: Accept loss (media is replaceable)

Time: Hours to days (depending on data size)

---

## Scenario 4: Complete Disaster

**House fire, theft, etc. - everything lost:**

1. **Get new hardware** (M4 + storage)

2. **Access pCloud from any device**
   - Login to pCloud.com
   - All backups safe in cloud!

3. **Follow Scenario 2** (M4 restore)

4. **All data recovered!** ✅

**This is why offsite backups matter!**

---

# Guide 87: Backup Monitoring

## Add to Grafana

**Create Backup Dashboard:**

1. **Panel: Last Backup Time**
```
Query: Check Kopia logs for last backup timestamp
Visualization: Stat
Alert: If > 25 hours ago
```

2. **Panel: Backup Size Trend**
```
Query: Track backup size over time
Visualization: Time series
```

3. **Panel: Backup Success Rate**
```
Query: Count successful vs failed backups
Visualization: Gauge
```

## Add to Uptime Kuma

1. Add monitor: Kopia Web UI
2. Type: HTTP
3. URL: http://192.168.50.10:51515

---

# Guide 88: Backup Best Practices

## The 3-2-1 Rule

**3 copies of data:**
- ✅ Original: M4 Mac Mini
- ✅ Local backup: External 4TB SSD
- ✅ Offsite: pCloud (2TB)

**2 different media:**
- ✅ Internal SSD
- ✅ External SSD
- ✅ Cloud storage

**1 offsite:**
- ✅ pCloud (encrypted)

## Security

- ✅ Encryption enabled (AES-256)
- ✅ Password in 1Password
- ✅ Test restores monthly
- ✅ Verify backups weekly
- ✅ Monitor backup jobs
- ✅ Alert on failures

## What NOT to Backup

**Skip these (save space):**
- Docker images (can re-pull)
- Media files (can re-download)
- Temp files
- Caches
- Logs (keep recent only)

---

# Guide 89: Backup Costs

## pCloud Storage

**Current plan: 2TB**
- Cost: ~£175 lifetime OR ~£8/month
- Used for: Critical data + photos
- Encrypted before upload

**If need more:**
- Consider additional cloud provider
- Or local NAS backup
- Or external HDDs rotated offsite

## Time Investment

**Initial setup:** 4 hours (this volume)
**Daily maintenance:** 0 minutes (automated!)
**Monthly verification:** 15 minutes
**Yearly testing:** 2 hours (full restore test)

**Worth it!** Data is irreplaceable.

---

# Guide 90: Emergency Contacts

**Save to 1Password:**

```
HomeLab Emergency Contacts:

Kopia Encryption Password: [IN 1PASSWORD!]
pCloud Login: [IN 1PASSWORD!]
Last Backup: [Check Grafana]

Restore Command:
docker exec kopia kopia restore [snapshot-id] /restore-path

Support:
- Kopia: https://kopia.io/docs
- pCloud: support@pcloud.com

This Document Location:
pCloud: /Backups/M4-HomeLab/documentation.md
1Password: HomeLab Vault → Disaster Recovery
```

---

## Volume 12 Complete!

You now have:
- ✅ Kopia backing up to pCloud (encrypted)
- ✅ Daily automated backups
- ✅ Pre/post backup scripts
- ✅ 3-2-1 backup strategy
- ✅ Disaster recovery plan
- ✅ Tested restore procedures
- ✅ Monitoring and alerts
- ✅ Peace of mind! 😌

**Backup Summary:**
```
Critical Data (Daily @ 2AM):
├─ Docker configs
├─ Scripts
├─ Documentation
└─ Service databases

Photos/Docs (Weekly):
├─ Immich photos
├─ Paperless documents
└─ Personal files

Destination:
├─ pCloud (2TB) - encrypted, offsite
└─ External SSD - local cache

Recovery Time:
├─ Single service: 5-10 minutes
├─ Full system: 2-4 hours
└─ Complete disaster: 1 day

All encrypted with AES-256 ✅
Password safely in 1Password ✅
```

**Next: Volume 13 - Maintenance & Action1 RMM**



---

#homelab #backup #disaster-recovery #kopia
