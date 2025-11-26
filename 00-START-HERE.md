---
title: Start Here
tags: [homelab, index, start]
created: 2025-11-19
updated: 2025-11-26
type: index
---

# 🏠 Welcome to the HomeLab Vault

**Complete documentation for the M4 Mac Mini homelab infrastructure**

---

## Quick Access

| I want to... | Go to... |
|--------------|----------|
| See all services | [[Master-Service-List]] |
| Check system health | [[Health-Check-Guide]] |
| Build this from scratch | [[Getting-Started-From-Scratch]] |
| Use AI automation | [[Claude-Code-Setup]] |
| Configure backups | [[Kopia-Backup-Setup]] |
| Set up cameras | [[Agent-DVR]] |

---

## System Status

| Metric | Value |
|--------|-------|
| Total Containers | 53 |
| Server IP | 192.168.50.50 |
| Last Health Check | 2025-11-26 ✅ All services healthy |

### Key URLs
- **Dashboard**: http://192.168.50.50:8090 (Heimdall)
- **Docker**: http://192.168.50.50:9000 (Portainer)
- **Monitoring**: http://192.168.50.50:3003 (Grafana)

---

## Documentation Structure

```
📁 HOMELAB Vault
├── 📄 HOMELAB-HANDBOOK.md     ← Main handbook
├── 📁 00-START-HERE/          ← You are here
│   └── Getting-Started-From-Scratch.md
├── 📁 01-Services/            ← Individual service docs
├── 📁 02-How-To-Guides/       ← Setup and config guides
├── 📁 03-Deployment/          ← Docker compose files
├── 📁 04-Disaster-Recovery/   ← Recovery procedures
├── 📁 06-Network/             ← Network documentation
├── 📁 09-Reference/           ← Reference materials
├── 📁 scripts/                ← Automation scripts
└── 📁 reports/                ← Session logs
```

---

## Essential Documents

### 📋 Reference
- [[HOMELAB-HANDBOOK]] - Complete system overview
- [[Master-Service-List]] - All 53 services with URLs and ports

### 🛠️ Guides
- [[Getting-Started-From-Scratch]] - Build from nothing
- [[Claude-Code-Setup]] - AI-powered automation
- [[Health-Check-Guide]] - Monitoring and troubleshooting
- [[Kopia-Backup-Setup]] - Backup to pCloud
- [[Agent-DVR]] - Surveillance setup

### 📊 Logs
- [[Session-Changes-2025-11-26]] - Latest maintenance session

---

## Service Categories

| Category | Count | Key Services |
|----------|-------|--------------|
| 🏠 Dashboards | 4 | Heimdall, Homer, Dashy, Organizr |
| 🔧 Core | 5 | Portainer, NPM, AdGuard, Filebrowser |
| 🎬 Media | 9 | Plex, Sonarr, Radarr, Jellyfin |
| 🏡 Smart Home | 5 | Home Assistant, Node-RED, Zigbee2MQTT |
| 🤖 AI | 6 | Ollama, Open WebUI, Jupyter |
| 📄 Productivity | 7 | Nextcloud, Paperless, Vaultwarden |
| 📊 Monitoring | 8 | Grafana, Prometheus, Uptime Kuma |
| 🗄️ Databases | 5 | MariaDB, PostgreSQL, Redis |
| 🔒 Security | 2 | CrowdSec, Fail2ban |
| 📹 Surveillance | 1 | Agent DVR |
| 💾 Backup | 1 | Kopia |

---

## Quick Commands

### Health Check
```bash
bash ~/Documents/Obsidian/HOMELAB/scripts/health-check.sh
```

### AI Automation (Claude Code)
```bash
claude --dangerously-skip-permissions "your task"
```

### Restart Container
```bash
docker restart <container_name>
```

### View Logs
```bash
docker logs <container_name> --tail 100
```

---

## Credentials

All credentials stored in **1Password Teams** under "HomeLab" tag.

---

## Getting Help

1. Check [[HOMELAB-HANDBOOK]] for overview
2. Search this vault for specific topics
3. Use Claude Code for troubleshooting:
   ```bash
   claude "Help me fix <issue>"
   ```

---

## Recent Updates

| Date | Change |
|------|--------|
| 2025-11-26 | Fixed 11 services, installed Claude Code, comprehensive docs update |
| 2025-11-26 | Kopia backup to pCloud configured |
| 2025-11-26 | Agent DVR motion detection configured |
| 2025-11-26 | Obsidian Git cleanup (freed 73GB) |

---

*Last Updated: 2025-11-26*
