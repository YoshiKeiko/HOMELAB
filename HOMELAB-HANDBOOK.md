---
title: HOMELAB Handbook
tags: [homelab, handbook, index, overview]
created: 2025-11-19
updated: 2025-11-26
type: index
---

# 🏠 HOMELAB Handbook

**Enterprise-grade self-hosted infrastructure on M4 Mac Mini**

---

## Quick Links

| Action | Link |
|--------|------|
| 🚀 Start Here | [[Getting-Started-From-Scratch]] |
| 📋 All Services | [[Master-Service-List]] |
| ❤️ Health Check | [[Health-Check-Guide]] |
| 🤖 AI Automation | [[Claude-Code-Setup]] |
| 💾 Backups | [[Kopia-Backup-Setup]] |
| 📹 Surveillance | [[Agent-DVR-Tapo-C310-Setup]] |

---

## System Overview

### Hardware
| Component | Specification |
|-----------|---------------|
| Server | Mac Mini M4 |
| RAM | 32GB |
| Storage | 512GB SSD (system) |
| External | 4TB SSD (media/recordings) |
| Network | 10GbE |
| IP Address | 192.168.50.50 |

### Software Stack
| Component | Technology |
|-----------|------------|
| Container Runtime | OrbStack (Docker) |
| Total Containers | 53 |
| Orchestration | Docker Compose |
| Monitoring | Grafana + Prometheus + Loki |
| Backup | Kopia → pCloud |

---

## Service Categories

### 🏠 Dashboards (4)
Central access points for all services.
- **Heimdall** (8090) - Primary dashboard
- **Homer** (8091) - Static dashboard
- **Organizr** (8092) - Tab-based dashboard
- **Dashy** (4000) - Modern dashboard

### 🔧 Core Infrastructure (5)
Essential management and network services.
- **Portainer** (9000) - Container management
- **Nginx Proxy Manager** (81) - Reverse proxy
- **AdGuard Home** (8084) - DNS ad blocking
- **Filebrowser** (8087) - Web file manager
- **Watchtower** - Auto-updates

### 🎬 Media Stack (9)
Complete media automation and streaming.
- **Plex** (32400) - Media streaming
- **Jellyfin** (8096) - Open-source alternative
- **Sonarr** (8989) - TV automation
- **Radarr** (7878) - Movie automation
- **Prowlarr** (9696) - Indexer management
- **Overseerr** (5055) - Media requests
- **Tautulli** (8181) - Plex statistics
- **Transmission** (9091) - Downloads
- **Flaresolverr** (8191) - Cloudflare bypass

### 🏡 Smart Home & IoT (5)
Home automation and device control.
- **Home Assistant** (8123) - Central hub
- **Node-RED** (1880) - Flow automation
- **Zigbee2MQTT** (8080) - Zigbee bridge
- **ESPHome** (6052) - ESP firmware
- **Mosquitto** (1883) - MQTT broker

### 🤖 AI & Development (6)
Local AI and development tools.
- **Ollama** (11434) - Local LLMs
- **Open WebUI** (3000) - Chat interface
- **Jupyter** (8888) - Notebooks
- **Code Server** (8443) - VS Code
- **Gitea** (3001) - Git server
- **KASM VNC** (3050) - Remote desktop

### 📄 Productivity (7)
Document and file management.
- **Nextcloud** (8097) - Cloud storage
- **Paperless** (8093) - Document OCR
- **Calibre** (8094) - E-books
- **FreshRSS** (8098) - RSS reader
- **PhotoPrism** (2342) - Photo management
- **Vaultwarden** (8088) - Passwords
- **Syncthing** (8384) - File sync

### 📊 Monitoring (8)
System and container monitoring.
- **Grafana** (3003) - Dashboards
- **Prometheus** (9090) - Metrics
- **Uptime Kuma** (3004) - Uptime monitoring
- **Netdata** (19999) - Real-time metrics
- **cAdvisor** (8085) - Container metrics
- **Loki** (3100) - Log aggregation
- **Promtail** - Log shipping
- **Node Exporter** (9100) - System metrics

### 🗄️ Databases (5)
Data storage backends.
- **InfluxDB** (8086) - Time-series
- **MariaDB** (3306) - MySQL compatible
- **PostgreSQL** (5432) - Advanced SQL
- **MongoDB** (27017) - NoSQL
- **Redis** (6379) - Cache

### 🔒 Security (2)
Intrusion detection and prevention.
- **CrowdSec** (8089) - IDS/IPS
- **Fail2ban** - IP blocking

### 📹 Surveillance (1)
CCTV and recording.
- **Agent DVR** (8099) - Camera management

### 💾 Backup (1)
Data protection.
- **Kopia** (8202) - Encrypted backups

---

## Key URLs

```
Main Dashboard:    http://192.168.50.50:8090
Docker Management: http://192.168.50.50:9000
Home Assistant:    http://192.168.50.50:8123
Plex:              http://192.168.50.50:32400/web
Grafana:           http://192.168.50.50:3003
AdGuard:           http://192.168.50.50:8084
```

---

## Management Tools

### Claude Code
AI-powered terminal automation:
```bash
claude --dangerously-skip-permissions "your task"
```

### Health Check
Verify all services:
```bash
bash ~/Documents/Obsidian/HOMELAB/scripts/health-check.sh
```

### Restart Services
```bash
cd ~/HomeLab/Docker/Compose
docker-compose -f <stack>.yml restart
```

---

## Backup Strategy

### Three Layers
1. **Kopia → pCloud** - Encrypted cloud backup
2. **Git** - Version control for configs
3. **Local Snapshots** - Quick recovery

### Backup Schedule
| Data | Frequency | Retention |
|------|-----------|-----------|
| Docker configs | Daily 03:00 | 12 months |
| Compose files | Daily 03:05 | 2 years |
| Obsidian vault | Daily 03:10 | 2 years |
| DVR recordings | Weekly | 1 month |

---

## Folder Structure

```
~/HomeLab/
├── Docker/
│   ├── Compose/     # Docker compose files
│   └── Data/        # Container data

/Volumes/HomeLab-4TB/
├── Media/           # Plex/Jellyfin content
├── Downloads/       # Transmission downloads
├── AgentDVR/        # Camera recordings
└── Backups/         # Local backups

~/Documents/Obsidian/HOMELAB/
├── 00-START-HERE/   # Getting started
├── 01-Services/     # Service documentation
├── 02-How-To-Guides/# Setup guides
├── 03-Deployment/   # Deploy scripts
├── 04-Disaster-Recovery/
├── 06-Network/      # Network docs
├── 09-Reference/    # Reference material
├── scripts/         # Automation scripts
└── reports/         # Session logs
```

---

## Smart Home Integration

### Connected Devices
- 10x Sonos speakers
- 5x Nest cameras
- Tesla Model Y
- Cupra Born EV
- Easee charger
- 40+ other devices

### Automation Platform
- Home Assistant (primary)
- Node-RED (complex flows)
- Zigbee2MQTT (Zigbee devices)

---

## Network Configuration

### DNS
- **Primary**: AdGuard Home (192.168.50.50:53)
- **Upstream**: Cloudflare DoH
- **Fallback**: Sky Shield (parental controls)

### IP Allocation
| Range | Purpose |
|-------|---------|
| .1-.49 | Network equipment |
| .50 | Homelab server |
| .51-.100 | Static devices |
| .101-.200 | DHCP pool |
| .201-.254 | IoT devices |

---

## Maintenance Tasks

### Daily (Automated)
- [ ] Kopia backups run
- [ ] Watchtower checks updates
- [ ] Uptime Kuma monitors services

### Weekly
- [ ] Review Grafana dashboards
- [ ] Check disk usage
- [ ] Review security logs

### Monthly
- [ ] Test backup restoration
- [ ] Update containers manually if needed
- [ ] Review and clean Docker images

---

## Troubleshooting Quick Reference

### Container Won't Start
```bash
docker logs <container> --tail 100
docker inspect <container>
```

### Service Unreachable
```bash
curl -I http://192.168.50.50:<port>
docker port <container>
```

### Disk Space Issues
```bash
docker system df
docker system prune -a
```

---

## Documentation Index

### Setup Guides
- [[Getting-Started-From-Scratch]]
- [[Claude-Code-Setup]]
- [[Kopia-Backup-Setup]]
- [[Health-Check-Guide]]
- [[Agent-DVR-Tapo-C310-Setup]]

### Reference
- [[Master-Service-List]]
- [[SERVICE_REFERENCE_DETAILED]]

### Logs
- [[Session-Changes-2025-11-26]]

---

## External Resources

- [Docker Documentation](https://docs.docker.com)
- [Home Assistant](https://www.home-assistant.io)
- [LinuxServer.io Images](https://fleet.linuxserver.io)
- [Anthropic Claude](https://claude.ai)

---

## Credentials

All credentials stored in **1Password Teams** vault under "HomeLab" tag.

---

*Last Updated: 2025-11-26*
