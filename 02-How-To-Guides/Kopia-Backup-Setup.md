---
title: Kopia Backup Setup Guide
tags: [homelab, backup, kopia, pcloud]
created: 2025-11-26
updated: 2025-11-26
type: guide
---

# Kopia Backup Setup Guide

**Encrypted backups to pCloud with versioning and retention**

---

## Overview

| Component | Detail |
|-----------|--------|
| Software | Kopia |
| Destination | pCloud WebDAV |
| Encryption | AES-256 |
| Web UI | http://192.168.50.50:8202 |

---

## Docker Deployment

### Compose File
`~/HomeLab/Docker/Compose/kopia.yml`

```yaml
version: '3.8'
services:
  kopia:
    image: kopia/kopia:latest
    container_name: kopia
    restart: unless-stopped
    ports:
      - "8202:51515"
    environment:
      - TZ=Europe/London
      - USER=admin
    command:
      - server
      - start
      - --insecure
      - --without-password
      - --address=0.0.0.0:51515
      - --server-username=admin
      - --server-password=admin123
    volumes:
      # Kopia config and cache
      - ~/HomeLab/Docker/Data/kopia/config:/app/config
      - ~/HomeLab/Docker/Data/kopia/cache:/app/cache
      - ~/HomeLab/Docker/Data/kopia/logs:/app/logs
      # Data to backup (read-only)
      - ~/HomeLab/Docker/Data:/data/docker-data:ro
      - ~/HomeLab/Docker/Compose:/data/docker-compose:ro
      - ~/Documents/Obsidian/HOMELAB:/data/obsidian-homelab:ro
      - /Volumes/HomeLab-4TB/AgentDVR/media:/data/agentdvr-recordings:ro
      - /Volumes/HomeLab-4TB:/data/homelab-4tb:ro
```

### Deploy
```bash
docker-compose -f kopia.yml up -d
```

---

## Repository Setup

### Connect to pCloud WebDAV

1. Go to http://192.168.50.50:8202
2. Click **Repository** → **Connect to Repository**
3. Select **WebDAV**
4. Enter:

| Field | Value |
|-------|-------|
| URL | `https://webdav.pcloud.com/HomeLab-Backups` |
| Username | Your pCloud email |
| Password | Your pCloud password |

5. Set **Repository Password** (encryption key)
6. Click **Connect**

### Store Credentials
Save repository password in 1Password as "Kopia Repository Password"

---

## Backup Paths Configuration

### Path 1: Docker Data (Critical)

| Setting | Value |
|---------|-------|
| Path | `/data/docker-data` |
| Schedule | Daily 03:00 |
| Compression | zstd |
| Description | Docker container configs |

**Retention Policy:**
- Latest: 10
- Daily: 7
- Weekly: 4
- Monthly: 12
- Annual: 1

**Ignore Patterns:**
```
cache
Cache
tmp
logs
transcode
.tmp
```

### Path 2: Docker Compose (Critical)

| Setting | Value |
|---------|-------|
| Path | `/data/docker-compose` |
| Schedule | Daily 03:05 |
| Compression | zstd (compress all) |
| Description | Docker compose YAML files |

**Retention Policy:**
- Latest: 20
- Daily: 7
- Weekly: 4
- Monthly: 12
- Annual: 2

### Path 3: Obsidian HOMELAB

| Setting | Value |
|---------|-------|
| Path | `/data/obsidian-homelab` |
| Schedule | Daily 03:10 |
| Compression | zstd |
| Description | HomeLab documentation vault |

**Retention Policy:**
- Latest: 20
- Daily: 14
- Weekly: 8
- Monthly: 12
- Annual: 2

**Ignore Patterns:**
```
.obsidian/cache
.trash
.DS_Store
```

### Path 4: Agent DVR Recordings

| Setting | Value |
|---------|-------|
| Path | `/data/agentdvr-recordings` |
| Schedule | Weekly Sunday 04:00 |
| Compression | none |
| Description | Surveillance recordings |

**Retention Policy:**
- Latest: 3
- Daily: 3
- Weekly: 2
- Monthly: 1

**Upload Settings:**
- Parallel uploads: 2
- Max bandwidth: 10 MB/s

---

## Create Snapshot Policy

### Via Web UI

1. Go to http://192.168.50.50:8202
2. Click **Snapshots** → **New Snapshot**
3. Enter path (e.g., `/data/docker-data`)
4. Click **Snapshot Now** for first backup

### Configure Schedule

1. Click **Policies** → Select path
2. Set scheduling and retention
3. Save policy

---

## Manual Operations

### Create Snapshot Now
```bash
docker exec kopia kopia snapshot create /data/docker-data
```

### List Snapshots
```bash
docker exec kopia kopia snapshot list
```

### Restore Files
```bash
docker exec kopia kopia restore <snapshot-id> /path/to/restore
```

### Check Repository Status
```bash
docker exec kopia kopia repository status
```

---

## Monitoring Backups

### Via Web UI
1. Go to http://192.168.50.50:8202
2. Check **Tasks** for recent activity
3. Check **Snapshots** for backup history

### Via CLI
```bash
# Recent snapshots
docker exec kopia kopia snapshot list --all

# Repository size
docker exec kopia kopia repository status
```

---

## Restore Procedures

### Restore Single File

1. Go to Kopia Web UI
2. Click **Snapshots**
3. Browse to snapshot date
4. Navigate to file
5. Click **Restore**

### Full Disaster Recovery

1. Install Kopia on new system
2. Connect to pCloud repository with password
3. List available snapshots
4. Restore required paths

```bash
# Connect to existing repository
kopia repository connect webdav \
  --url=https://webdav.pcloud.com/HomeLab-Backups \
  --webdav-username=your@email.com \
  --webdav-password='pcloud_password'

# List snapshots
kopia snapshot list --all

# Restore Docker data
kopia restore <snapshot-id> ~/HomeLab/Docker/Data/
```

---

## pCloud WebDAV Notes

### WebDAV URL
```
https://webdav.pcloud.com/
```

### Folder Structure in pCloud
```
pCloud/
└── HomeLab-Backups/
    └── kopia/
        ├── kopia.repository.f
        ├── p/
        ├── q/
        └── n/
```

### pCloud Limits
- Free: 10GB
- Premium: 500GB
- Premium Plus: 2TB

---

## Troubleshooting

### Connection Failed

1. Verify pCloud credentials
2. Check WebDAV URL format
3. Test pCloud WebDAV access:
```bash
curl -u 'email:password' https://webdav.pcloud.com/
```

### Snapshot Failed

1. Check container logs:
```bash
docker logs kopia --tail 100
```

2. Verify path exists:
```bash
docker exec kopia ls -la /data/
```

3. Check disk space:
```bash
docker exec kopia df -h
```

### Slow Uploads

1. Reduce parallel uploads
2. Set bandwidth limit
3. Check network connectivity

---

## Security Best Practices

1. **Use strong repository password** - This encrypts all backups
2. **Store password in 1Password** - Never lose it!
3. **Test restores regularly** - Verify backups work
4. **Mount data read-only** - Prevents accidental modification

---

## Backup Schedule Summary

| Time | Backup |
|------|--------|
| 03:00 | Docker Data |
| 03:05 | Docker Compose |
| 03:10 | Obsidian HOMELAB |
| Sunday 04:00 | Agent DVR Recordings |

---

## Related Pages

- [[Master-Service-List]]
- [[Health-Check-Guide]]
- [[Agent-DVR-Tapo-C310-Setup]]
- [[Getting-Started-From-Scratch]]

---

*Last Updated: 2025-11-26*
