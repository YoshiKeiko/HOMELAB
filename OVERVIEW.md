---
tags: [overview, index, services, homelab]
created: 2025-12-06
updated: 2025-12-06
---

# 🏠 HomeLab Services Overview

> Complete reference of all services running on the M4 Mac Mini homelab infrastructure.

## Quick Stats
| Metric | Value |
|--------|-------|
| **Total Containers** | 70+ |
| **Server** | M4 Mac Mini (32GB RAM) |
| **Storage** | 4TB External SSD |
| **Network** | 10GbE / 5Gbps Internet |
| **IP Address** | 192.168.50.50 |

---

# 📂 Services by Category

## 🎬 Media & Entertainment

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Plex]] | - | [app.plex.tv](https://app.plex.tv) | Premium media server with apps for all devices |
| [[Jellyfin]] | 8096 | [Link](http://192.168.50.50:8096) | Free open-source media server alternative to Plex |
| [[Sonarr]] | 8989 | [Link](http://192.168.50.50:8989) | TV show collection manager and automated downloader |
| [[Radarr]] | 7878 | [Link](http://192.168.50.50:7878) | Movie collection manager and automated downloader |
| [[Prowlarr]] | 9696 | [Link](http://192.168.50.50:9696) | Indexer manager for Sonarr/Radarr/Lidarr |
| [[Bazarr]] | 6767 | [Link](http://192.168.50.50:6767) | Automatic subtitle downloader for Sonarr/Radarr |
| [[Overseerr]] | 5055 | [Link](http://192.168.50.50:5055) | Media request management for Plex |
| [[Tautulli]] | 8181 | [Link](http://192.168.50.50:8181) | Plex monitoring and statistics |
| [[Transmission]] | 9091 | [Link](http://192.168.50.50:9091) | Lightweight BitTorrent client |
| [[FlareSolverr]] | 8191 | [Link](http://192.168.50.50:8191) | Proxy for bypassing Cloudflare protection |
| [[Audiobookshelf]] | 13378 | [Link](http://192.168.50.50:13378) | Audiobook and podcast server with mobile apps |
| [[Navidrome]] | 4533 | [Link](http://192.168.50.50:4533) | Music streaming server (Subsonic compatible) |
| [[Komga]] | 25600 | [Link](http://192.168.50.50:25600) | Comics and manga server with OPDS |
| [[Kavita]] | 5004 | [Link](http://192.168.50.50:5004) | eBooks, comics, and manga reader |
| [[MakeMKV]] | 5800 | [Link](http://192.168.50.50:5800) | DVD/Blu-ray to MKV ripper with web GUI |

## 🎮 Gaming

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[RetroArch]] | 3090 | [Link](http://192.168.50.50:3090) | Multi-system retro gaming emulator in browser |
## 🏠 Smart Home

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Home-Assistant]] | 8123 | [Link](http://192.168.50.50:8123) | Central smart home automation hub |
| [[Node-RED]] | 1880 | [Link](http://192.168.50.50:1880) | Flow-based automation and programming |
| [[Zigbee2MQTT]] | 8080 | [Link](http://192.168.50.50:8080) | Zigbee device bridge to MQTT |
| [[ESPHome]] | 6052 | [Link](http://192.168.50.50:6052) | ESP device firmware and management |
| [[Mosquitto]] | 1883 | - | MQTT message broker |

## 📊 Monitoring & Metrics

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Grafana]] | 3003 | [Link](http://192.168.50.50:3003) | Metrics visualization and dashboards |
| [[Prometheus]] | 9090 | [Link](http://192.168.50.50:9090) | Time-series metrics database |
| [[Uptime-Kuma]] | 3004 | [Link](http://192.168.50.50:3004) | Service uptime monitoring |
| [[Netdata]] | 19999 | [Link](http://192.168.50.50:19999) | Real-time system performance monitoring |
| [[cAdvisor]] | 8085 | [Link](http://192.168.50.50:8085) | Docker container metrics |
| [[InfluxDB]] | 8086 | [Link](http://192.168.50.50:8086) | Time-series database |
| [[Loki]] | 3100 | [Link](http://192.168.50.50:3100) | Log aggregation (Grafana stack) |
| [[SpeedTest-Tracker]] | 8765 | [Link](http://192.168.50.50:8765) | Internet speed monitoring over time |

## 🔐 Security & Surveillance

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Frigate-NVR]] | 5001 | [Link](http://192.168.50.50:5001) | AI-powered NVR with object detection |
| [[Agent-DVR]] | 8099 | [Link](http://192.168.50.50:8099) | Alternative DVR for IP cameras |
| [[Vaultwarden]] | 8088 | [Link](http://192.168.50.50:8088) | Bitwarden-compatible password manager |
| [[CrowdSec]] | 8089 | [Link](http://192.168.50.50:8089) | Collaborative security engine |
| [[AdGuard-Home]] | 8084 | [Link](http://192.168.50.50:8084) | Network-wide ad blocking and DNS |
| [[Nginx-Proxy-Manager]] | 81 | [Link](http://192.168.50.50:81) | Reverse proxy with SSL management |

## 📁 Storage & Documents

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[File-Browser]] | 8087 | [Link](http://192.168.50.50:8087) | Web-based file manager |
| [[Calibre-web]] | 8083 | [Link](http://192.168.50.50:8083) | eBook library and web reader |
| [[Calibre]] | 8194 | [Link](https://192.168.50.50:8194) | Full Calibre desktop in browser |
| [[PhotoPrism]] | 2342 | [Link](http://192.168.50.50:2342) | AI-powered photo management |
| [[Nextcloud]] | 8097 | [Link](http://192.168.50.50:8097) | Self-hosted cloud storage |
| [[Syncthing]] | 8384 | [Link](http://192.168.50.50:8384) | Peer-to-peer file synchronization |
| [[Kopia]] | 8202 | [Link](http://192.168.50.50:8202) | Encrypted backup solution |
| [[Paperless-ngx]] | 8093 | [Link](http://192.168.50.50:8093) | Document management with OCR |
| [[FreshRSS]] | 8098 | [Link](http://192.168.50.50:8098) | RSS feed aggregator |

## 🤖 AI & Development

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Open-WebUI]] | 3000 | [Link](http://192.168.50.50:3000) | ChatGPT-like interface for local LLMs |
| [[Ollama]] | 11434 | [Link](http://192.168.50.50:11434) | Local LLM runtime (Llama, Mistral, etc.) |
| [[Jupyter]] | 8888 | [Link](http://192.168.50.50:8888) | Interactive Python notebooks |
| [[Code-Server]] | 8443 | [Link](http://192.168.50.50:8443) | VS Code in the browser |
| [[Gitea]] | 3001 | [Link](http://192.168.50.50:3001) | Self-hosted Git service |

## 🛠️ Tools & Utilities

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Stirling-PDF]] | 8078 | [Link](http://192.168.50.50:8078) | All-in-one PDF manipulation tool |
| [[IT-Tools]] | 8079 | [Link](http://192.168.50.50:8079) | 80+ developer/IT utilities |
| [[ChangeDetection]] | 5005 | [Link](http://192.168.50.50:5005) | Website change monitoring and alerts |
| [[VNC-Desktop]] | 3050 | [Link](http://192.168.50.50:3050) | Remote desktop access |

## 🏡 Home Management

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Mealie]] | 9925 | [Link](http://192.168.50.50:9925) | Recipe manager with meal planning |
| [[Grocy]] | 9283 | [Link](http://192.168.50.50:9283) | Household/grocery ERP system |
| [[Actual-Budget]] | 5006 | [Link](http://192.168.50.50:5006) | Personal finance (YNAB alternative) |

## 🔔 Notifications

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Ntfy]] | 8280 | [Link](http://192.168.50.50:8280) | Push notifications to mobile/desktop |

## 💾 Databases

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[MariaDB]] | 3306 | - | MySQL-compatible database |
| [[PostgreSQL]] | 5432 | - | Advanced SQL database |
| [[MongoDB]] | 27017 | - | NoSQL document database |
| [[Redis]] | 6379 | - | In-memory key-value store |

## 📋 Dashboards

| Service | Port | URL | Description |
|---------|------|-----|-------------|
| [[Portainer]] | 9000 | [Link](http://192.168.50.50:9000) | Docker management UI |
| [[Heimdall]] | 8090 | [Link](http://192.168.50.50:8090) | Application dashboard |
| [[Homer]] | 8091 | [Link](http://192.168.50.50:8091) | Simple static dashboard |
| [[Dashy]] | 4000 | [Link](http://192.168.50.50:4000) | Feature-rich dashboard |
| [[Organizr]] | 8092 | [Link](http://192.168.50.50:8092) | HTPC/Homelab organizer |

---

# 🗂️ Data Storage Locations

## Primary Paths

| Type | Location |
|------|----------|
| Docker Compose Files | `/Users/homelab/HomeLab/Docker/Compose/` |
| Container Configs | `/Users/homelab/HomeLab/Docker/Data/` |
| Extended Storage | `/Volumes/HomeLab-4TB/Docker-Data/` |
| Media Library | `/Volumes/HomeLab-4TB/Media/` |
| Obsidian Vaults | `/Users/homelab/Documents/Obsidian/` |

## Media Folders

| Folder | Purpose |
|--------|---------|
| `/Volumes/HomeLab-4TB/Media/Movies` | Movie files |
| `/Volumes/HomeLab-4TB/Media/TV Shows` | TV series |
| `/Volumes/HomeLab-4TB/Media/Music` | Music library |
| `/Volumes/HomeLab-4TB/Media/Books` | eBooks |
| `/Volumes/HomeLab-4TB/Media/Comics` | Comics/Manga |
| `/Volumes/HomeLab-4TB/Media/Audiobooks` | Audiobooks |
| `/Volumes/HomeLab-4TB/Media/Podcasts` | Podcasts |
| `/Volumes/HomeLab-4TB/Media/Photos` | Photo library |
| `/Volumes/HomeLab-4TB/Media/ROMs` | Game ROMs |

---

# 🔗 Quick Reference


## Port Ranges

| Range | Category |
|-------|----------|
| 80-443 | Web/Proxy |
| 1880-1883 | Smart Home |
| 3000-3100 | AI/Dev/Dashboards |
| 5000-5500 | Security/Home |
| 6767-7878 | Media *Arr Stack |
| 8000-8999 | General Services |
| 9000-9999 | Infrastructure |
| 11434+ | Specialty |

---

# 📚 Related Documentation

- [[00-START-HERE]] - Getting started guide
- [[00-SERVICE-INDEX]] - Alphabetical service index
- [[HOMELAB-HANDBOOK]] - Operations handbook
- [[BOOKMARKS.html]] - Web dashboard

---

*Last updated: December 6, 2025*
