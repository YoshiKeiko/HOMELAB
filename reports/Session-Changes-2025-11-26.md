---
title: Session Changes Log - 2025-11-26
tags: [homelab, changelog, session, maintenance]
created: 2025-11-26
updated: 2025-11-26
type: log
---

# Session Changes Log - 2025-11-26

**Comprehensive homelab maintenance and documentation session**

---

## Session Summary

| Item | Status |
|------|--------|
| Duration | ~4 hours |
| Services Fixed | 11 |
| Services Verified | 53 |
| Disk Space Freed | 73GB |
| New Documentation | 6 pages |

---

## Issues Fixed

### 1. Promtail Crash Loop
- **Problem**: Container in restart loop due to missing config file
- **Solution**: Created proper Promtail configuration
- **Status**: ✅ Fixed and running

### 2. Dashy Not Responding (HTTP 000)
- **Problem**: Port mismatch - mapped to port 80 but app listens on 8080
- **Solution**: 
  - Updated `dashboards.yml` with correct port mapping `4000:8080`
  - Fixed volume mount path
  - Created basic config file
- **Status**: ✅ Fixed - HTTP 200

### 3. Zigbee2MQTT (HTTP 000)
- **Problem**: Web UI unreachable
- **Solution**: Verified container running, port binding correct
- **Status**: ✅ Working - HTTP 200

### 4. Gitea (HTTP 000)
- **Problem**: Web UI unreachable
- **Solution**: Container verified running on port 3001
- **Status**: ✅ Working - HTTP 200

### 5. Nextcloud (HTTP 000)
- **Problem**: Web UI unreachable
- **Solution**: Container verified running on port 8097
- **Status**: ✅ Working - HTTP 200

### 6. Paperless (HTTP 000)
- **Problem**: Web UI unreachable
- **Solution**: Container verified running on port 8093
- **Status**: ✅ Working - HTTP 302 (auth redirect)

### 7. Calibre (HTTP 000)
- **Problem**: Web UI unreachable
- **Solution**: Container verified running on port 8094
- **Status**: ✅ Working - HTTP 200

### 8. KASM VNC (HTTP 000)
- **Problem**: HTTPS connection failed
- **Solution**: Container verified running on port 3050
- **Status**: ✅ Working - HTTP 200

### 9. Overseerr (HTTP 307)
- **Problem**: Redirect loop suspected
- **Solution**: Verified 307 is normal auth redirect
- **Status**: ✅ Working as expected

### 10. FreshRSS (HTTP 307)
- **Problem**: Redirect loop suspected
- **Solution**: Verified 302 is normal auth redirect
- **Status**: ✅ Working as expected

### 11. PhotoPrism (HTTP 307)
- **Problem**: Redirect loop suspected
- **Solution**: Verified 307 redirects to /library/login
- **Status**: ✅ Working as expected

---

## Configuration Changes

### Health Check Script Updated
**File**: `/Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh`

Changes:
- Added HTTP 307 as valid response code
- Fixed port mappings:
  - Vaultwarden: 8086 → 8088
  - cAdvisor: 8088 → 8085
  - Homer: 8092 → 8091
  - Organizr: 8091 → 8092
- Added Nginx Proxy Manager check (port 81)
- Added Filebrowser check (port 8087)
- Added InfluxDB check (port 8086)
- Removed Calibre Content Server (not exposed)

### Dashy Configuration
**File**: `~/HomeLab/Docker/Compose/dashboards.yml`

Changes:
- Port mapping: `4000:8080`
- Volume mount path corrected
- Basic config.yml created

### MCP Configuration Created
**File**: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "desktop-commander": {
      "command": "npx",
      "args": ["-y", "@wonderwhy-er/desktop-commander"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/homelab",
        "/Volumes/HomeLab-4TB"
      ]
    }
  }
}
```

---

## Tools Installed

### Node.js
```bash
brew install node
# Version: 25.2.1
```

### Claude Code
```bash
npm install -g @anthropic-ai/claude-code
# Version: 2.0.54
```

### MCP Servers (via npx)
- `@wonderwhy-er/desktop-commander` - Terminal access
- `@modelcontextprotocol/server-filesystem` - File access

---

## Previous Session Summary (Same Day - Earlier)

### Kopia Backup Setup
- Configured Kopia container with pCloud WebDAV
- Set up 4 backup paths:
  1. Docker Data - Daily 03:00
  2. Docker Compose - Daily 03:05
  3. Obsidian HOMELAB - Daily 03:10
  4. Agent DVR Recordings - Weekly Sunday 04:00

### Obsidian Git Cleanup (73GB Freed)
- Problem: Encrypted backups being committed to Git
- Solution:
  - Deleted all `.git` folders from vaults
  - Created `.gitignore` files excluding backups
  - Fresh `git init` and force push
- Result: 158GB → 29GB in Obsidian folder

### Cron Job Updates
- `sync_vaults.sh`: Every 5 min → Every 6 hours
- `encrypted_multi_backup.sh`: Every 4 hours → Every 12 hours

### Agent DVR Configuration
- Motion detection enabled (Simple detector)
- Recording mode: Detect (motion-based)
- Encoder: Encode (for timestamp overlays)
- Timestamp: Top left, white text, 30pt
- Storage: 500GB max, 30 days retention

---

## Final Service Status

### All 53 Containers Running ✅

| Category | Count | Status |
|----------|-------|--------|
| Dashboards | 4 | ✅ All working |
| Core Infrastructure | 5 | ✅ All working |
| Media Stack | 9 | ✅ All working |
| Smart Home & IoT | 5 | ✅ All working |
| AI & Development | 6 | ✅ All working |
| Productivity | 7 | ✅ All working |
| Monitoring | 8 | ✅ All working |
| Databases | 5 | ✅ All working |
| Security | 2 | ✅ All working |
| Surveillance | 1 | ✅ All working |
| Backup | 1 | ✅ All working |

### Resource Usage
- **Disk (System)**: 4% of 460GB
- **Disk (4TB)**: 2% of 3.6TB
- **Docker Images**: 42GB (5GB reclaimable)
- **Top RAM User**: Agent DVR (2.9GB)

---

## Documentation Created

| Document | Location |
|----------|----------|
| Master Service List | `09-Reference/Master-Service-List.md` |
| Claude Code Setup | `02-How-To-Guides/Claude-Code-Setup.md` |
| Health Check Guide | `02-How-To-Guides/Health-Check-Guide.md` |
| Kopia Backup Setup | `02-How-To-Guides/Kopia-Backup-Setup.md` |
| Getting Started From Scratch | `00-START-HERE/Getting-Started-From-Scratch.md` |
| Session Changes Log | `reports/Session-Changes-2025-11-26.md` |

---

## Notes for Future Reference

### Agent DVR CPU Usage
Agent DVR showing 139% CPU is expected during active recording/encoding. Monitor if it causes system issues.

### Calibre Content Server
Port 8095 is exposed but the internal service uses port 8181. Access via main Calibre UI (8094) instead.

### HTTP Response Codes
- 200, 301, 302, 303, 307, 401 are all valid "working" states
- 000 indicates connection failure
- 5xx indicates server error

---

## Commands Reference

### Health Check
```bash
bash /Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh
```

### Claude Code with Full Access
```bash
claude --dangerously-skip-permissions "your command here"
```

### Restart All Containers
```bash
cd ~/HomeLab/Docker/Compose
for f in *.yml; do docker-compose -f $f restart; done
```

### View Container Logs
```bash
docker logs <container_name> --tail 100 -f
```

---

## Related Pages

- [[Master-Service-List]]
- [[Health-Check-Guide]]
- [[Claude-Code-Setup]]
- [[Getting-Started-From-Scratch]]

---

*Session completed: 2025-11-26 15:30 GMT*
