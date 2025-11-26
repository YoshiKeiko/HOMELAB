# 🏠 HomeLab Service Reference Guide

**Last Updated:** Mon 17 Nov 2025 10:42:32 GMT  
**Total Services Running:** 47  
**Mac Tailscale IP:** 100.96.129.29

---

## 📋 Table of Contents

- [Quick Access Links](#quick-access-links)
- [Core Infrastructure](#core-infrastructure)
- [Media Services](#media-services)
- [AI & Development](#ai--development)
- [Smart Home](#smart-home)
- [Network Services](#network-services)
- [Monitoring](#monitoring)
- [Storage & Backup](#storage--backup)
- [Security](#security)
- [Dashboards](#dashboards)
- [Utilities](#utilities)
- [Databases](#databases)
- [Default Credentials](#default-credentials)
- [Remote Access Guide](#remote-access-guide)
- [Port Reference](#port-reference)

---

## 🚀 Quick Access Links

| Service | Local URL | Tailscale URL | Purpose |
|---------|-----------|---------------|---------|
| **Heimdall** | [localhost:8090](http://localhost:8090) | [100.96.129.29:8090](http://100.96.129.29:8090) | Main Dashboard - Start Here! |
| **Portainer** | [localhost:9000](http://localhost:9000) | [100.96.129.29:9000](http://100.96.129.29:9000) | Docker Management |
| **Home Assistant** | [localhost:8123](http://localhost:8123) | [100.96.129.29:8123](http://100.96.129.29:8123) | Smart Home Control |
| **OpenWebUI** | [localhost:3000](http://localhost:3000) | [100.96.129.29:3000](http://100.96.129.29:3000) | AI Chat Interface |
| **Grafana** | [localhost:3003](http://localhost:3003) | [100.96.129.29:3003](http://100.96.129.29:3003) | Monitoring Dashboard |

---

## 🔧 Core Infrastructure

### Portainer
- **Purpose:** Docker container management UI
- **Local:** [http://localhost:9000](http://localhost:9000)
- **Tailscale:** [http://100.96.129.29:9000](http://100.96.129.29:9000)
- **First Login:** Create admin account on first access
- **Notes:** Manage all Docker containers from web interface

### Watchtower
- **Purpose:** Automatic container updates
- **Status:** Running (no web interface)
- **Schedule:** Daily at 4:00 AM
- **Notes:** Automatically updates Docker images

---

## 🎬 Media Services

### Plex Media Server
- **Purpose:** Media streaming server
- **Local:** [http://localhost:32400/web](http://localhost:32400/web)
- **Tailscale:** [http://100.96.129.29:32400/web](http://100.96.129.29:32400/web)
- **Setup:** Sign in with Plex account
- **Media Location:** `/Users/homelab/HomeLab/Docker/Data/plex/media`

### Jellyfin
- **Purpose:** Open-source media server (Plex alternative)
- **Local:** [http://localhost:8096](http://localhost:8096)
- **Tailscale:** [http://100.96.129.29:8096](http://100.96.129.29:8096)
- **Setup:** Create admin account on first access
- **Media Location:** Shared with Plex

### Radarr
- **Purpose:** Movie collection manager
- **Local:** [http://localhost:7878](http://localhost:7878)
- **Tailscale:** [http://100.96.129.29:7878](http://100.96.129.29:7878)
- **Setup:** Connect to Prowlarr for indexers

### Sonarr
- **Purpose:** TV show collection manager
- **Local:** [http://localhost:8989](http://localhost:8989)
- **Tailscale:** [http://100.96.129.29:8989](http://100.96.129.29:8989)
- **Setup:** Connect to Prowlarr for indexers

### Prowlarr
- **Purpose:** Indexer manager for Radarr/Sonarr
- **Local:** [http://localhost:9696](http://localhost:9696)
- **Tailscale:** [http://100.96.129.29:9696](http://100.96.129.29:9696)
- **Setup:** Add indexers here first

### Overseerr
- **Purpose:** Media request management
- **Local:** [http://localhost:5055](http://localhost:5055)
- **Tailscale:** [http://100.96.129.29:5055](http://100.96.129.29:5055)
- **Setup:** Connect to Plex and Radarr/Sonarr

### Transmission
- **Purpose:** BitTorrent client
- **Local:** [http://localhost:9091](http://localhost:9091)
- **Tailscale:** [http://100.96.129.29:9091](http://100.96.129.29:9091)
- **Downloads:** `/Users/homelab/HomeLab/Docker/Data/transmission/downloads`

---

## 🤖 AI & Development

### OpenWebUI
- **Purpose:** ChatGPT-like interface for Ollama
- **Local:** [http://localhost:3000](http://localhost:3000)
- **Tailscale:** [http://100.96.129.29:3000](http://100.96.129.29:3000)
- **Setup:** Create account on first access
- **Connected to:** Ollama (localhost:11434)

### Ollama
- **Purpose:** Local LLM server
- **API:** [http://localhost:11434](http://localhost:11434)
- **Tailscale:** [http://100.96.129.29:11434](http://100.96.129.29:11434)
- **Models:** Download via OpenWebUI or CLI
- **CLI:** `docker exec ollama ollama pull llama2`

### Code Server (VS Code)
- **Purpose:** Browser-based VS Code
- **Local:** [http://localhost:8443](http://localhost:8443)
- **Tailscale:** [http://100.96.129.29:8443](http://100.96.129.29:8443)
- **Password:** `changeme` (CHANGE THIS!)

### Jupyter Notebook
- **Purpose:** Interactive Python notebooks
- **Local:** [http://localhost:8888](http://localhost:8888)
- **Tailscale:** [http://100.96.129.29:8888](http://100.96.129.29:8888)
- **Token:** Check logs: `docker logs jupyter`

### Gitea
- **Purpose:** Self-hosted Git server
- **Local:** [http://localhost:3001](http://localhost:3001)
- **Tailscale:** [http://100.96.129.29:3001](http://100.96.129.29:3001)
- **SSH:** Port 2222
- **Setup:** Create admin account on first access

---

## 🏠 Smart Home

### Home Assistant
- **Purpose:** Smart home automation hub
- **Local:** [http://localhost:8123](http://localhost:8123)
- **Tailscale:** [http://100.96.129.29:8123](http://100.96.129.29:8123)
- **Setup:** Create account and connect devices
- **Integrations:** Sonos, Nest, Tesla, etc.

### Node-RED
- **Purpose:** Visual automation flows
- **Local:** [http://localhost:1880](http://localhost:1880)
- **Tailscale:** [http://100.96.129.29:1880](http://100.96.129.29:1880)
- **Use with:** Home Assistant for complex automations

### Mosquitto MQTT
- **Purpose:** MQTT message broker
- **Port:** 1883
- **WebSocket:** 9001
- **Config:** `/Users/homelab/HomeLab/Docker/Data/mosquitto/config`

### Zigbee2MQTT
- **Purpose:** Zigbee device bridge to MQTT
- **Local:** [http://localhost:8080](http://localhost:8080)
- **Tailscale:** [http://100.96.129.29:8080](http://100.96.129.29:8080)
- **Requires:** Zigbee USB adapter

### ESPHome
- **Purpose:** ESP8266/ESP32 device management
- **Local:** [http://localhost:6052](http://localhost:6052)
- **Tailscale:** [http://100.96.129.29:6052](http://100.96.129.29:6052)

---

## 🌐 Network Services

### AdGuard Home
- **Purpose:** Network-wide ad blocking
- **Local:** [http://localhost:3002](http://localhost:3002)
- **Admin:** [http://localhost:8084](http://localhost:8084)
- **DNS:** Port 53
- **Setup:** Initial setup wizard on first access

### Nginx Proxy Manager
- **Purpose:** Reverse proxy with SSL
- **Local:** [http://localhost:81](http://localhost:81)
- **Tailscale:** [http://100.96.129.29:81](http://100.96.129.29:81)
- **Default Login:** `admin@example.com` / `changeme`
- **HTTP:** Port 80
- **HTTPS:** Port 443

### WireGuard VPN
- **Purpose:** VPN server
- **Port:** 51820/udp
- **Config:** `/Users/homelab/HomeLab/Docker/Data/wireguard/config`
- **Peers:** 5 configured

### Tailscale
- **Purpose:** Zero-config VPN mesh network
- **Mac IP:** 100.96.129.29
- **Status:** `tailscale status`
- **Android App:** [Play Store](https://play.google.com/store/apps/details?id=com.tailscale.ipn)

---

## 📊 Monitoring

### Grafana
- **Purpose:** Metrics visualization
- **Local:** [http://localhost:3003](http://localhost:3003)
- **Tailscale:** [http://100.96.129.29:3003](http://100.96.129.29:3003)
- **Username:** `admin`
- **Password:** `xb2iOX5675f39XZeQqt3tK2khtD2NJ`
- **Data Sources:** Prometheus, Loki, InfluxDB

### Prometheus
- **Purpose:** Metrics collection
- **Local:** [http://localhost:9090](http://localhost:9090)
- **Tailscale:** [http://100.96.129.29:9090](http://100.96.129.29:9090)
- **Scrapes:** Node Exporter, cAdvisor

### Loki
- **Purpose:** Log aggregation
- **Local:** [http://localhost:3100](http://localhost:3100)
- **Query via:** Grafana

### Uptime Kuma
- **Purpose:** Service uptime monitoring
- **Local:** [http://localhost:3004](http://localhost:3004)
- **Tailscale:** [http://100.96.129.29:3004](http://100.96.129.29:3004)
- **Setup:** Create admin account

### Netdata
- **Purpose:** Real-time system monitoring
- **Local:** [http://localhost:19999](http://localhost:19999)
- **Tailscale:** [http://100.96.129.29:19999](http://100.96.129.29:19999)
- **No login required**

### cAdvisor
- **Purpose:** Container resource monitoring
- **Local:** [http://localhost:8085](http://localhost:8085)
- **Tailscale:** [http://100.96.129.29:8085](http://100.96.129.29:8085)

### Node Exporter
- **Purpose:** System metrics for Prometheus
- **Local:** [http://localhost:9100](http://localhost:9100)
- **Metrics endpoint:** `/metrics`

### Promtail
- **Purpose:** Log shipper for Loki
- **Status:** Running (no web interface)

---

## 💾 Storage & Backup

### Nextcloud
- **Purpose:** Personal cloud storage
- **Local:** [http://localhost:8097](http://localhost:8097) *(Port changed)*
- **Tailscale:** [http://100.96.129.29:8097](http://100.96.129.29:8097)
- **Username:** `admin`
- **Password:** `NgYbA3RJYb7he1PRaERRXZektQvevPQ`
- **Storage:** `/Users/homelab/HomeLab/Docker/Data/nextcloud/data`

### Syncthing
- **Purpose:** File synchronization
- **Local:** [http://localhost:8384](http://localhost:8384)
- **Tailscale:** [http://100.96.129.29:8384](http://100.96.129.29:8384)
- **Sync folders:** Configure in web UI

### Duplicati
- **Purpose:** Encrypted backups
- **Local:** [http://localhost:8200](http://localhost:8200)
- **Tailscale:** [http://100.96.129.29:8200](http://100.96.129.29:8200)
- **Setup:** Configure backup destinations

### File Browser
- **Purpose:** Web-based file manager
- **Local:** [http://localhost:8087](http://localhost:8087)
- **Tailscale:** [http://100.96.129.29:8087](http://100.96.129.29:8087)
- **Root:** `/Users/homelab/HomeLab`
- **Default:** `admin` / `admin` (change immediately)

---

## 🔒 Security

### Vaultwarden
- **Purpose:** Password manager (Bitwarden)
- **Local:** [http://localhost:8088](http://localhost:8088)
- **Tailscale:** [http://100.96.129.29:8088](http://100.96.129.29:8088)
- **Setup:** Create account for password vault
- **Apps:** Bitwarden clients compatible

### Fail2ban
- **Purpose:** Intrusion prevention
- **Status:** Running (no web interface)
- **Logs:** `/var/log`

### CrowdSec
- **Purpose:** Collaborative security
- **Local:** [http://localhost:8089](http://localhost:8089)
- **Tailscale:** [http://100.96.129.29:8089](http://100.96.129.29:8089)
- **Setup:** Register at crowdsec.net

---

## 🎨 Dashboards

### Heimdall
- **Purpose:** Application dashboard (RECOMMENDED)
- **Local:** [http://localhost:8090](http://localhost:8090)
- **Tailscale:** [http://100.96.129.29:8090](http://100.96.129.29:8090)
- **Setup:** Add all your services here for easy access

### Homer
- **Purpose:** Static dashboard
- **Local:** [http://localhost:8091](http://localhost:8091)
- **Tailscale:** [http://100.96.129.29:8091](http://100.96.129.29:8091)
- **Config:** YAML-based

### Dashy
- **Purpose:** Modern dashboard
- **Local:** [http://localhost:4000](http://localhost:4000)
- **Tailscale:** [http://100.96.129.29:4000](http://100.96.129.29:4000)
- **Config:** YAML-based

### Organizr
- **Purpose:** Dashboard with tabs
- **Local:** [http://localhost:8092](http://localhost:8092)
- **Tailscale:** [http://100.96.129.29:8092](http://100.96.129.29:8092)
- **Setup:** Create admin account

---

## 🛠️ Utilities

### Paperless-ngx
- **Purpose:** Document management system
- **Local:** [http://localhost:8093](http://localhost:8093)
- **Tailscale:** [http://100.96.129.29:8093](http://100.96.129.29:8093)
- **Setup:** Create superuser account
- **Upload:** Place documents in consume folder

### PhotoPrism
- **Purpose:** Photo management
- **Local:** [http://localhost:2342](http://localhost:2342)
- **Tailscale:** [http://100.96.129.29:2342](http://100.96.129.29:2342)
- **Username:** `admin`
- **Password:** `NgYbA3RJYb7he1PRaERRXZektQvevPQ`

### Calibre
- **Purpose:** eBook management
- **Local:** [http://localhost:8094](http://localhost:8094)
- **Tailscale:** [http://100.96.129.29:8094](http://100.96.129.29:8094)
- **Content Server:** Port 8095

### FreshRSS
- **Purpose:** RSS feed reader
- **Local:** [http://localhost:8098](http://localhost:8098) *(Port changed)*
- **Tailscale:** [http://100.96.129.29:8098](http://100.96.129.29:8098)
- **Setup:** Create account on first access

---

## 🗄️ Databases

### PostgreSQL
- **Port:** 5432
- **Database:** `homelab`
- **Username:** `postgres`
- **Used by:** Nextcloud, Paperless-ngx

### MariaDB
- **Port:** 3306
- **Database:** `homelab`
- **Username:** `root`
- **Used by:** PhotoPrism

### MongoDB
- **Port:** 27017
- **Username:** `root`

### Redis
- **Port:** 6379
- **Used by:** Paperless-ngx (caching)

### InfluxDB
- **Local:** [http://localhost:8086](http://localhost:8086)
- **Purpose:** Time-series database
- **Used by:** Monitoring services

---

## 🔑 Default Credentials

> ⚠️ **IMPORTANT:** Change all default passwords immediately!

| Service | Username | Password | Notes |
|---------|----------|----------|-------|
| Grafana | `admin` | `xb2iOX5675f39XZeQqt3tK2khtD2NJ` | From credentials file |
| Nextcloud | `admin` | `NgYbA3RJYb7he1PRaERRXZektQvevPQ` | From credentials file |
| PhotoPrism | `admin` | `NgYbA3RJYb7he1PRaERRXZektQvevPQ` | Same as Nextcloud |
| Code Server | - | `changeme` | **CHANGE THIS!** |
| File Browser | `admin` | `admin` | **CHANGE THIS!** |
| Nginx Proxy | `admin@example.com` | `changeme` | **CHANGE THIS!** |

**Get all passwords:**
```bash
cat ~/HomeLab/docs/FINAL_CREDENTIALS.txt
```

---

## 📱 Remote Access Guide

### Via Tailscale (Recommended)

1. **Install Tailscale on your device**
   - Android: [Play Store](https://play.google.com/store/apps/details?id=com.tailscale.ipn)
   - iOS: [App Store](https://apps.apple.com/app/tailscale/id1470499037)

2. **Sign in with the same account**

3. **Access services using:**
   ```
   http://100.96.129.29:PORT
   ```

4. **For Screen Sharing:**
   - Install VNC Viewer app
   - Connect to: `100.96.129.29:5900`
   - Use your Mac's VNC password

### Via Local Network

Simply use `http://localhost:PORT` when on the same network as your Mac.

---

## 🔢 Port Reference

### Quick Reference Table

| Port | Service | Protocol |
|------|---------|----------|
| 53 | AdGuard DNS | TCP/UDP |
| 80 | Nginx HTTP | TCP |
| 443 | Nginx HTTPS | TCP |
| 81 | Nginx Admin | TCP |
| 1883 | Mosquitto MQTT | TCP |
| 1880 | Node-RED | TCP |
| 2342 | PhotoPrism | TCP |
| 3000 | OpenWebUI | TCP |
| 3001 | Gitea | TCP |
| 3002 | AdGuard | TCP |
| 3003 | Grafana | TCP |
| 3004 | Uptime Kuma | TCP |
| 3100 | Loki | TCP |
| 4000 | Dashy | TCP |
| 5055 | Overseerr | TCP |
| 5432 | PostgreSQL | TCP |
| 6052 | ESPHome | TCP |
| 6379 | Redis | TCP |
| 6767 | Bazarr | TCP |
| 7878 | Radarr | TCP |
| 8080 | Zigbee2MQTT | TCP |
| 8082 | qBittorrent | TCP |
| 8084 | AdGuard Admin | TCP |
| 8085 | cAdvisor | TCP |
| 8086 | InfluxDB | TCP |
| 8087 | File Browser | TCP |
| 8088 | Vaultwarden | TCP |
| 8089 | CrowdSec | TCP |
| 8090 | Heimdall | TCP |
| 8091 | Homer | TCP |
| 8092 | Organizr | TCP |
| 8093 | Paperless-ngx | TCP |
| 8094 | Calibre | TCP |
| 8096 | Jellyfin | TCP |
| 8097 | Nextcloud | TCP |
| 8098 | FreshRSS | TCP |
| 8123 | Home Assistant | TCP |
| 8200 | Duplicati | TCP |
| 8384 | Syncthing | TCP |
| 8443 | Code Server | TCP |
| 8888 | Jupyter | TCP |
| 8989 | Sonarr | TCP |
| 9000 | Portainer | TCP |
| 9090 | Prometheus | TCP |
| 9091 | Transmission | TCP |
| 9100 | Node Exporter | TCP |
| 9696 | Prowlarr | TCP |
| 11434 | Ollama | TCP |
| 19999 | Netdata | TCP |
| 27017 | MongoDB | TCP |
| 32400 | Plex | TCP |
| 51820 | WireGuard | UDP |

---

## 📚 Additional Resources

### Configuration Files
- **Location:** `/Users/homelab/HomeLab/Docker/Data/`
- **Compose Files:** `/Users/homelab/HomeLab/Docker/Compose/`
- **Documentation:** `/Users/homelab/HomeLab/docs/`

### Useful Commands

```bash
# View all running containers
docker ps

# View logs for a service
docker logs <container-name>

# Restart a service
docker restart <container-name>

# Stop all services
docker stop $(docker ps -q)

# Start all services
cd ~/HomeLab/Docker/Compose
docker compose -f databases.yml up -d
docker compose -f portainer.yml up -d
docker compose -f media-arm64.yml up -d
docker compose -f ai-dev.yml up -d
docker compose -f smarthome.yml up -d
docker compose -f network.yml up -d
docker compose -f monitoring.yml up -d
docker compose -f storage.yml up -d
docker compose -f security.yml up -d
docker compose -f dashboards.yml up -d
docker compose -f utilities.yml up -d

# Check Tailscale status
tailscale status

# View disk usage
df -h ~/HomeLab
```

### Backup Locations
- **Docker Data:** `/Users/homelab/HomeLab/Docker/Data/`
- **Media:** `/Users/homelab/HomeLab/Docker/Data/plex/media/`
- **Documents:** `/Users/homelab/HomeLab/docs/`

---

**Generated:** Mon 17 Nov 2025 10:42:32 GMT  
**For:** HomeLab M4 Mac Mini  
**Total Services:** 47

