---
title: Master Service List
tags: [homelab, services, reference, ports]
created: 2025-11-26
updated: 2025-11-26
type: reference
---

# Master Service List

**53 containers running on M4 Mac Mini (192.168.50.50)**

---

## 🏠 Dashboards

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Heimdall | http://192.168.50.50:8090 | 8090 | Application dashboard with quick-launch icons for all services |
| Homer | http://192.168.50.50:8091 | 8091 | Simple static dashboard with service links and health checks |
| Organizr | http://192.168.50.50:8092 | 8092 | Tab-based dashboard that embeds other services in iframes |
| Dashy | http://192.168.50.50:4000 | 4000 | Modern customizable dashboard with widgets and status checks |

---

## 🔧 Core Infrastructure

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Portainer | http://192.168.50.50:9000 | 9000 | Docker container management GUI - start/stop/manage containers |
| Nginx Proxy Manager | http://192.168.50.50:81 | 81 | Reverse proxy with SSL certificates for external access |
| AdGuard Home | http://192.168.50.50:8084 | 8084 | Network-wide DNS ad blocker and privacy protection |
| Filebrowser | http://192.168.50.50:8087 | 8087 | Web-based file manager for browsing server files |
| Watchtower | - | - | Auto-updates Docker containers to latest versions |

---

## 🎬 Media Stack

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Plex | http://192.168.50.50:32400/web | 32400 | Media server for streaming movies/TV to all devices |
| Jellyfin | http://192.168.50.50:8096 | 8096 | Open-source media server alternative to Plex |
| Sonarr | http://192.168.50.50:8989 | 8989 | TV show automation - monitors and downloads episodes |
| Radarr | http://192.168.50.50:7878 | 7878 | Movie automation - monitors and downloads films |
| Prowlarr | http://192.168.50.50:9696 | 9696 | Indexer manager for Sonarr/Radarr - manages torrent sources |
| Overseerr | http://192.168.50.50:5055 | 5055 | Media request system - family can request movies/shows |
| Tautulli | http://192.168.50.50:8181 | 8181 | Plex statistics and monitoring - who watched what |
| Transmission | http://192.168.50.50:9091 | 9091 | BitTorrent download client for media acquisition |
| Flaresolverr | http://192.168.50.50:8191 | 8191 | Cloudflare bypass proxy for indexers |

---

## 🏡 Smart Home & IoT

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Home Assistant | http://192.168.50.50:8123 | 8123 | Central smart home hub - controls all devices and automations |
| Node-RED | http://192.168.50.50:1880 | 1880 | Flow-based automation builder for complex automations |
| Zigbee2MQTT | http://192.168.50.50:8080 | 8080 | Zigbee device bridge - connects Zigbee devices to Home Assistant |
| ESPHome | http://192.168.50.50:6052 | 6052 | ESP32/ESP8266 firmware builder for DIY sensors |
| Mosquitto | - | 1883 | MQTT message broker for IoT device communication |

---

## 🤖 AI & Development

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Ollama API | http://192.168.50.50:11434 | 11434 | Local LLM server - runs AI models like Llama, Mistral |
| Open WebUI | http://192.168.50.50:3000 | 3000 | ChatGPT-like interface for Ollama models |
| Jupyter | http://192.168.50.50:8888 | 8888 | Python notebook environment for data science |
| Code Server | http://192.168.50.50:8443 | 8443 | VS Code in the browser for remote development |
| Gitea | http://192.168.50.50:3001 | 3001 | Self-hosted Git repository server |
| KASM VNC | http://192.168.50.50:3050 | 3050 | Remote desktop streaming in browser |

---

## 📄 Productivity & Documents

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Nextcloud | http://192.168.50.50:8097 | 8097 | Self-hosted cloud storage - like Google Drive/Dropbox |
| Paperless | http://192.168.50.50:8093 | 8093 | Document management with OCR - digitize and search paper docs |
| Calibre | http://192.168.50.50:8094 | 8094 | E-book library manager and reader |
| FreshRSS | http://192.168.50.50:8098 | 8098 | RSS feed reader for news aggregation |
| PhotoPrism | http://192.168.50.50:2342 | 2342 | AI-powered photo management with face recognition |
| Vaultwarden | http://192.168.50.50:8088 | 8088 | Self-hosted Bitwarden password manager |
| Syncthing | http://192.168.50.50:8384 | 8384 | Peer-to-peer file sync between devices |

---

## 📊 Monitoring & Logging

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Grafana | http://192.168.50.50:3003 | 3003 | Dashboard visualization for metrics and logs |
| Prometheus | http://192.168.50.50:9090 | 9090 | Metrics collection and alerting system |
| Uptime Kuma | http://192.168.50.50:3004 | 3004 | Service uptime monitoring with notifications |
| Netdata | http://192.168.50.50:19999 | 19999 | Real-time system performance monitoring |
| cAdvisor | http://192.168.50.50:8085 | 8085 | Container resource usage and performance metrics |
| Loki | http://192.168.50.50:3100 | 3100 | Log aggregation system - collects logs from all containers |
| Promtail | - | - | Log shipper - sends container logs to Loki |
| Node Exporter | - | 9100 | System metrics exporter for Prometheus |

---

## 🗄️ Databases

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| InfluxDB | http://192.168.50.50:8086 | 8086 | Time-series database for metrics and IoT data |
| MariaDB | - | 3306 | MySQL-compatible database for apps |
| PostgreSQL | - | 5432 | Advanced SQL database for Paperless, Gitea |
| MongoDB | - | 27017 | NoSQL document database |
| Redis | - | 6379 | In-memory cache and message broker |

---

## 🔒 Security

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| CrowdSec | http://192.168.50.50:8089 | 8089 | Collaborative intrusion detection and prevention |
| Fail2ban | - | - | Blocks IPs after failed login attempts |

---

## 📹 Surveillance

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Agent DVR | http://192.168.50.50:8099 | 8099 | CCTV recording and management for Tapo cameras |

---

## 💾 Backup

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| Kopia | http://192.168.50.50:8202 | 8202 | Encrypted backup to pCloud - Docker configs and Obsidian |

---

## Quick Stats

| Category | Count |
|----------|-------|
| Dashboards | 4 |
| Core Infrastructure | 5 |
| Media Stack | 9 |
| Smart Home & IoT | 5 |
| AI & Development | 6 |
| Productivity & Documents | 7 |
| Monitoring & Logging | 8 |
| Databases | 5 |
| Security | 2 |
| Surveillance | 1 |
| Backup | 1 |
| **TOTAL** | **53** |

---

## Port Quick Reference

```
81    - Nginx Proxy Manager  8086  - InfluxDB
1880  - Node-RED             8087  - Filebrowser
1883  - Mosquitto (MQTT)     8088  - Vaultwarden
2342  - PhotoPrism           8089  - CrowdSec
3000  - Open WebUI           8090  - Heimdall
3001  - Gitea                8091  - Homer
3003  - Grafana              8092  - Organizr
3004  - Uptime Kuma          8093  - Paperless
3050  - KASM VNC             8094  - Calibre
3100  - Loki                 8096  - Jellyfin
3306  - MariaDB              8097  - Nextcloud
4000  - Dashy                8098  - FreshRSS
5055  - Overseerr            8099  - Agent DVR
5432  - PostgreSQL           8123  - Home Assistant
6052  - ESPHome              8181  - Tautulli
6379  - Redis                8191  - Flaresolverr
7878  - Radarr               8202  - Kopia
8080  - Zigbee2MQTT          8384  - Syncthing
8084  - AdGuard Home         8443  - Code Server
8085  - cAdvisor             8888  - Jupyter
                             8989  - Sonarr
9000  - Portainer            9696  - Prowlarr
9090  - Prometheus           11434 - Ollama
9091  - Transmission         19999 - Netdata
9100  - Node Exporter        27017 - MongoDB
                             32400 - Plex
```

---

## Related Pages

- [[Health-Check-Guide]]
- [[Claude-Code-Setup]]
- [[Kopia-Backup-Setup]]
- [[Agent-DVR-Tapo-C310-Setup]]

---

*Last Updated: 2025-11-26*
