#!/bin/bash

################################################################################
# Generate HomeLab Service Reference Guide (Markdown)
################################################################################

set -euo pipefail

HOMELAB_DIR="$HOME/HomeLab"
OUTPUT_FILE="$HOMELAB_DIR/docs/SERVICE_REFERENCE.md"

# Get Tailscale IP
TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "YOUR_TAILSCALE_IP")

# Get credentials
GRAFANA_PASSWORD=$(docker exec grafana printenv GF_SECURITY_ADMIN_PASSWORD 2>/dev/null || echo "CHECK_CREDENTIALS_FILE")
NEXTCLOUD_PASSWORD=$(docker exec nextcloud printenv NEXTCLOUD_ADMIN_PASSWORD 2>/dev/null || echo "CHECK_CREDENTIALS_FILE")

# Count services
TOTAL_SERVICES=$(docker ps --format '{{.Names}}' | wc -l | tr -d ' ')

echo "Generating service reference guide..."

cat > "$OUTPUT_FILE" << 'MDEOF'
# 🏠 HomeLab Service Reference Guide

**Last Updated:** TIMESTAMP  
**Total Services Running:** TOTAL_COUNT  
**Mac Tailscale IP:** TAILSCALE_IP_ADDRESS

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
| **Heimdall** | [localhost:8090](http://localhost:8090) | [TAILSCALE_IP_ADDRESS:8090](http://TAILSCALE_IP_ADDRESS:8090) | Main Dashboard - Start Here! |
| **Portainer** | [localhost:9000](http://localhost:9000) | [TAILSCALE_IP_ADDRESS:9000](http://TAILSCALE_IP_ADDRESS:9000) | Docker Management |
| **Home Assistant** | [localhost:8123](http://localhost:8123) | [TAILSCALE_IP_ADDRESS:8123](http://TAILSCALE_IP_ADDRESS:8123) | Smart Home Control |
| **OpenWebUI** | [localhost:3000](http://localhost:3000) | [TAILSCALE_IP_ADDRESS:3000](http://TAILSCALE_IP_ADDRESS:3000) | AI Chat Interface |
| **Grafana** | [localhost:3003](http://localhost:3003) | [TAILSCALE_IP_ADDRESS:3003](http://TAILSCALE_IP_ADDRESS:3003) | Monitoring Dashboard |

---

## 🔧 Core Infrastructure

### Portainer
- **Purpose:** Docker container management UI
- **Local:** [http://localhost:9000](http://localhost:9000)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:9000](http://TAILSCALE_IP_ADDRESS:9000)
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
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:32400/web](http://TAILSCALE_IP_ADDRESS:32400/web)
- **Setup:** Sign in with Plex account
- **Media Location:** `/Users/homelab/HomeLab/Docker/Data/plex/media`

### Jellyfin
- **Purpose:** Open-source media server (Plex alternative)
- **Local:** [http://localhost:8096](http://localhost:8096)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8096](http://TAILSCALE_IP_ADDRESS:8096)
- **Setup:** Create admin account on first access
- **Media Location:** Shared with Plex

### Radarr
- **Purpose:** Movie collection manager
- **Local:** [http://localhost:7878](http://localhost:7878)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:7878](http://TAILSCALE_IP_ADDRESS:7878)
- **Setup:** Connect to Prowlarr for indexers

### Sonarr
- **Purpose:** TV show collection manager
- **Local:** [http://localhost:8989](http://localhost:8989)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8989](http://TAILSCALE_IP_ADDRESS:8989)
- **Setup:** Connect to Prowlarr for indexers

### Prowlarr
- **Purpose:** Indexer manager for Radarr/Sonarr
- **Local:** [http://localhost:9696](http://localhost:9696)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:9696](http://TAILSCALE_IP_ADDRESS:9696)
- **Setup:** Add indexers here first

### Overseerr
- **Purpose:** Media request management
- **Local:** [http://localhost:5055](http://localhost:5055)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:5055](http://TAILSCALE_IP_ADDRESS:5055)
- **Setup:** Connect to Plex and Radarr/Sonarr

### Transmission
- **Purpose:** BitTorrent client
- **Local:** [http://localhost:9091](http://localhost:9091)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:9091](http://TAILSCALE_IP_ADDRESS:9091)
- **Downloads:** `/Users/homelab/HomeLab/Docker/Data/transmission/downloads`

---

## 🤖 AI & Development

### OpenWebUI
- **Purpose:** ChatGPT-like interface for Ollama
- **Local:** [http://localhost:3000](http://localhost:3000)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:3000](http://TAILSCALE_IP_ADDRESS:3000)
- **Setup:** Create account on first access
- **Connected to:** Ollama (localhost:11434)

### Ollama
- **Purpose:** Local LLM server
- **API:** [http://localhost:11434](http://localhost:11434)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:11434](http://TAILSCALE_IP_ADDRESS:11434)
- **Models:** Download via OpenWebUI or CLI
- **CLI:** `docker exec ollama ollama pull llama2`

### Code Server (VS Code)
- **Purpose:** Browser-based VS Code
- **Local:** [http://localhost:8443](http://localhost:8443)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8443](http://TAILSCALE_IP_ADDRESS:8443)
- **Password:** `changeme` (CHANGE THIS!)

### Jupyter Notebook
- **Purpose:** Interactive Python notebooks
- **Local:** [http://localhost:8888](http://localhost:8888)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8888](http://TAILSCALE_IP_ADDRESS:8888)
- **Token:** Check logs: `docker logs jupyter`

### Gitea
- **Purpose:** Self-hosted Git server
- **Local:** [http://localhost:3001](http://localhost:3001)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:3001](http://TAILSCALE_IP_ADDRESS:3001)
- **SSH:** Port 2222
- **Setup:** Create admin account on first access

---

## 🏠 Smart Home

### Home Assistant
- **Purpose:** Smart home automation hub
- **Local:** [http://localhost:8123](http://localhost:8123)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8123](http://TAILSCALE_IP_ADDRESS:8123)
- **Setup:** Create account and connect devices
- **Integrations:** Sonos, Nest, Tesla, etc.

### Node-RED
- **Purpose:** Visual automation flows
- **Local:** [http://localhost:1880](http://localhost:1880)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:1880](http://TAILSCALE_IP_ADDRESS:1880)
- **Use with:** Home Assistant for complex automations

### Mosquitto MQTT
- **Purpose:** MQTT message broker
- **Port:** 1883
- **WebSocket:** 9001
- **Config:** `/Users/homelab/HomeLab/Docker/Data/mosquitto/config`

### Zigbee2MQTT
- **Purpose:** Zigbee device bridge to MQTT
- **Local:** [http://localhost:8080](http://localhost:8080)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8080](http://TAILSCALE_IP_ADDRESS:8080)
- **Requires:** Zigbee USB adapter

### ESPHome
- **Purpose:** ESP8266/ESP32 device management
- **Local:** [http://localhost:6052](http://localhost:6052)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:6052](http://TAILSCALE_IP_ADDRESS:6052)

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
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:81](http://TAILSCALE_IP_ADDRESS:81)
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
- **Mac IP:** TAILSCALE_IP_ADDRESS
- **Status:** `tailscale status`
- **Android App:** [Play Store](https://play.google.com/store/apps/details?id=com.tailscale.ipn)

---

## 📊 Monitoring

### Grafana
- **Purpose:** Metrics visualization
- **Local:** [http://localhost:3003](http://localhost:3003)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:3003](http://TAILSCALE_IP_ADDRESS:3003)
- **Username:** `admin`
- **Password:** `GRAFANA_PASS`
- **Data Sources:** Prometheus, Loki, InfluxDB

### Prometheus
- **Purpose:** Metrics collection
- **Local:** [http://localhost:9090](http://localhost:9090)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:9090](http://TAILSCALE_IP_ADDRESS:9090)
- **Scrapes:** Node Exporter, cAdvisor

### Loki
- **Purpose:** Log aggregation
- **Local:** [http://localhost:3100](http://localhost:3100)
- **Query via:** Grafana

### Uptime Kuma
- **Purpose:** Service uptime monitoring
- **Local:** [http://localhost:3004](http://localhost:3004)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:3004](http://TAILSCALE_IP_ADDRESS:3004)
- **Setup:** Create admin account

### Netdata
- **Purpose:** Real-time system monitoring
- **Local:** [http://localhost:19999](http://localhost:19999)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:19999](http://TAILSCALE_IP_ADDRESS:19999)
- **No login required**

### cAdvisor
- **Purpose:** Container resource monitoring
- **Local:** [http://localhost:8085](http://localhost:8085)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8085](http://TAILSCALE_IP_ADDRESS:8085)

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
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8097](http://TAILSCALE_IP_ADDRESS:8097)
- **Username:** `admin`
- **Password:** `NEXTCLOUD_PASS`
- **Storage:** `/Users/homelab/HomeLab/Docker/Data/nextcloud/data`

### Syncthing
- **Purpose:** File synchronization
- **Local:** [http://localhost:8384](http://localhost:8384)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8384](http://TAILSCALE_IP_ADDRESS:8384)
- **Sync folders:** Configure in web UI

### Duplicati
- **Purpose:** Encrypted backups
- **Local:** [http://localhost:8200](http://localhost:8200)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8200](http://TAILSCALE_IP_ADDRESS:8200)
- **Setup:** Configure backup destinations

### File Browser
- **Purpose:** Web-based file manager
- **Local:** [http://localhost:8087](http://localhost:8087)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8087](http://TAILSCALE_IP_ADDRESS:8087)
- **Root:** `/Users/homelab/HomeLab`
- **Default:** `admin` / `admin` (change immediately)

---

## 🔒 Security

### Vaultwarden
- **Purpose:** Password manager (Bitwarden)
- **Local:** [http://localhost:8088](http://localhost:8088)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8088](http://TAILSCALE_IP_ADDRESS:8088)
- **Setup:** Create account for password vault
- **Apps:** Bitwarden clients compatible

### Fail2ban
- **Purpose:** Intrusion prevention
- **Status:** Running (no web interface)
- **Logs:** `/var/log`

### CrowdSec
- **Purpose:** Collaborative security
- **Local:** [http://localhost:8089](http://localhost:8089)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8089](http://TAILSCALE_IP_ADDRESS:8089)
- **Setup:** Register at crowdsec.net

---

## 🎨 Dashboards

### Heimdall
- **Purpose:** Application dashboard (RECOMMENDED)
- **Local:** [http://localhost:8090](http://localhost:8090)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8090](http://TAILSCALE_IP_ADDRESS:8090)
- **Setup:** Add all your services here for easy access

### Homer
- **Purpose:** Static dashboard
- **Local:** [http://localhost:8091](http://localhost:8091)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8091](http://TAILSCALE_IP_ADDRESS:8091)
- **Config:** YAML-based

### Dashy
- **Purpose:** Modern dashboard
- **Local:** [http://localhost:4000](http://localhost:4000)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:4000](http://TAILSCALE_IP_ADDRESS:4000)
- **Config:** YAML-based

### Organizr
- **Purpose:** Dashboard with tabs
- **Local:** [http://localhost:8092](http://localhost:8092)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8092](http://TAILSCALE_IP_ADDRESS:8092)
- **Setup:** Create admin account

---

## 🛠️ Utilities

### Paperless-ngx
- **Purpose:** Document management system
- **Local:** [http://localhost:8093](http://localhost:8093)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8093](http://TAILSCALE_IP_ADDRESS:8093)
- **Setup:** Create superuser account
- **Upload:** Place documents in consume folder

### PhotoPrism
- **Purpose:** Photo management
- **Local:** [http://localhost:2342](http://localhost:2342)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:2342](http://TAILSCALE_IP_ADDRESS:2342)
- **Username:** `admin`
- **Password:** `NEXTCLOUD_PASS`

### Calibre
- **Purpose:** eBook management
- **Local:** [http://localhost:8094](http://localhost:8094)
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8094](http://TAILSCALE_IP_ADDRESS:8094)
- **Content Server:** Port 8095

### FreshRSS
- **Purpose:** RSS feed reader
- **Local:** [http://localhost:8098](http://localhost:8098) *(Port changed)*
- **Tailscale:** [http://TAILSCALE_IP_ADDRESS:8098](http://TAILSCALE_IP_ADDRESS:8098)
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
| Grafana | `admin` | `GRAFANA_PASS` | From credentials file |
| Nextcloud | `admin` | `NEXTCLOUD_PASS` | From credentials file |
| PhotoPrism | `admin` | `NEXTCLOUD_PASS` | Same as Nextcloud |
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
   http://TAILSCALE_IP_ADDRESS:PORT
   ```

4. **For Screen Sharing:**
   - Install VNC Viewer app
   - Connect to: `TAILSCALE_IP_ADDRESS:5900`
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

**Generated:** TIMESTAMP  
**For:** HomeLab M4 Mac Mini  
**Total Services:** TOTAL_COUNT

MDEOF

# Replace placeholders
sed -i '' "s/TIMESTAMP/$(date)/" "$OUTPUT_FILE"
sed -i '' "s/TOTAL_COUNT/${TOTAL_SERVICES}/" "$OUTPUT_FILE"
sed -i '' "s/TAILSCALE_IP_ADDRESS/${TAILSCALE_IP}/g" "$OUTPUT_FILE"
sed -i '' "s/GRAFANA_PASS/${GRAFANA_PASSWORD}/" "$OUTPUT_FILE"
sed -i '' "s/NEXTCLOUD_PASS/${NEXTCLOUD_PASSWORD}/" "$OUTPUT_FILE"

echo ""
echo "✓ Service reference guide created!"
echo ""
echo "Location: $OUTPUT_FILE"
echo ""
echo "View in terminal:"
echo "  cat '$OUTPUT_FILE'"
echo ""
echo "Or open in your markdown editor (e.g., Obsidian, Typora, VS Code)"
echo ""

# Also create a simple HTML version
HTML_FILE="$HOMELAB_DIR/docs/SERVICE_REFERENCE.html"

if command -v pandoc &> /dev/null; then
    pandoc "$OUTPUT_FILE" -o "$HTML_FILE" --standalone --css=https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css
    echo "✓ HTML version created: $HTML_FILE"
    echo "  Open: open '$HTML_FILE'"
    echo ""
fi

# Create a quick bookmarks HTML file for browsers
BOOKMARKS_FILE="$HOMELAB_DIR/docs/BOOKMARKS.html"

cat > "$BOOKMARKS_FILE" << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <title>HomeLab Services - Quick Bookmarks</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background: #1e1e1e;
            color: #e0e0e0;
        }
        h1 {
            color: #4CAF50;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        h2 {
            color: #2196F3;
            margin-top: 30px;
        }
        .service-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .service-card {
            background: #2d2d2d;
            border: 1px solid #444;
            border-radius: 8px;
            padding: 15px;
            transition: all 0.3s;
        }
        .service-card:hover {
            background: #363636;
            border-color: #4CAF50;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(76, 175, 80, 0.2);
        }
        .service-card h3 {
            margin: 0 0 10px 0;
            color: #4CAF50;
            font-size: 18px;
        }
        .service-card p {
            margin: 5px 0;
            font-size: 12px;
            color: #999;
        }
        a {
            color: #2196F3;
            text-decoration: none;
            display: block;
            margin: 5px 0;
        }
        a:hover {
            color: #4CAF50;
            text-decoration: underline;
        }
        .info-box {
            background: #2d2d2d;
            border-left: 4px solid #FF9800;
            padding: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <h1>🏠 HomeLab Services - Quick Access</h1>
    
    <div class="info-box">
        <strong>Tailscale IP:</strong> TAILSCALE_IP_ADDRESS<br>
        <strong>Total Services:</strong> TOTAL_COUNT<br>
        <strong>Last Updated:</strong> TIMESTAMP
    </div>

    <h2>🚀 Quick Start</h2>
    <div class="service-grid">
        <div class="service-card">
            <h3>Heimdall</h3>
            <p>Main Dashboard</p>
            <a href="http://localhost:8090" target="_blank">→ Open Local</a>
            <a href="http://TAILSCALE_IP_ADDRESS:8090" target="_blank">→ Open Remote</a>
        </div>
        <div class="service-card">
            <h3>Portainer</h3>
            <p>Docker Management</p>
            <a href="http://localhost:9000" target="_blank">→ Open Local</a>
            <a href="http://TAILSCALE_IP_ADDRESS:9000" target="_blank">→ Open Remote</a>
        </div>
        <div class="service-card">
            <h3>Home Assistant</h3>
            <p>Smart Home Control</p>
            <a href="http://localhost:8123" target="_blank">→ Open Local</a>
            <a href="http://TAILSCALE_IP_ADDRESS:8123" target="_blank">→ Open Remote</a>
        </div>
        <div class="service-card">
            <h3>OpenWebUI</h3>
            <p>AI Chat Interface</p>
            <a href="http://localhost:3000" target="_blank">→ Open Local</a>
            <a href="http://TAILSCALE_IP_ADDRESS:3000" target="_blank">→ Open Remote</a>
        </div>
    </div>

    <h2>🎬 Media</h2>
    <div class="service-grid">
        <div class="service-card">
            <h3>Plex</h3>
            <p>Media Server</p>
            <a href="http://localhost:32400/web" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Jellyfin</h3>
            <p>Open Source Media</p>
            <a href="http://localhost:8096" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Radarr</h3>
            <p>Movies</p>
            <a href="http://localhost:7878" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Sonarr</h3>
            <p>TV Shows</p>
            <a href="http://localhost:8989" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Prowlarr</h3>
            <p>Indexer Manager</p>
            <a href="http://localhost:9696" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Overseerr</h3>
            <p>Request Management</p>
            <a href="http://localhost:5055" target="_blank">→ Open Local</a>
        </div>
    </div>

    <h2>📊 Monitoring</h2>
    <div class="service-grid">
        <div class="service-card">
            <h3>Grafana</h3>
            <p>Dashboards</p>
            <a href="http://localhost:3003" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Prometheus</h3>
            <p>Metrics</p>
            <a href="http://localhost:9090" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Uptime Kuma</h3>
            <p>Uptime Monitor</p>
            <a href="http://localhost:3004" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Netdata</h3>
            <p>Real-time Monitor</p>
            <a href="http://localhost:19999" target="_blank">→ Open Local</a>
        </div>
    </div>

    <h2>💾 Storage</h2>
    <div class="service-grid">
        <div class="service-card">
            <h3>Nextcloud</h3>
            <p>Cloud Storage</p>
            <a href="http://localhost:8097" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Syncthing</h3>
            <p>File Sync</p>
            <a href="http://localhost:8384" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Duplicati</h3>
            <p>Backups</p>
            <a href="http://localhost:8200" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>File Browser</h3>
            <p>Web File Manager</p>
            <a href="http://localhost:8087" target="_blank">→ Open Local</a>
        </div>
    </div>

    <h2>🛠️ Development</h2>
    <div class="service-grid">
        <div class="service-card">
            <h3>Code Server</h3>
            <p>VS Code</p>
            <a href="http://localhost:8443" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Jupyter</h3>
            <p>Notebooks</p>
            <a href="http://localhost:8888" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>Gitea</h3>
            <p>Git Server</p>
            <a href="http://localhost:3001" target="_blank">→ Open Local</a>
        </div>
    </div>

    <h2>🔒 Security</h2>
    <div class="service-grid">
        <div class="service-card">
            <h3>Vaultwarden</h3>
            <p>Password Manager</p>
            <a href="http://localhost:8088" target="_blank">→ Open Local</a>
        </div>
        <div class="service-card">
            <h3>AdGuard</h3>
            <p>DNS Ad Blocker</p>
            <a href="http://localhost:3002" target="_blank">→ Open Local</a>
        </div>
    </div>

</body>
</html>
HTMLEOF

sed -i '' "s/TIMESTAMP/$(date)/" "$BOOKMARKS_FILE"
sed -i '' "s/TOTAL_COUNT/${TOTAL_SERVICES}/" "$BOOKMARKS_FILE"
sed -i '' "s/TAILSCALE_IP_ADDRESS/${TAILSCALE_IP}/g" "$BOOKMARKS_FILE"

echo "✓ HTML bookmarks page created: $BOOKMARKS_FILE"
echo "  Open in browser: open '$BOOKMARKS_FILE'"
echo ""
echo "🎉 All reference files created successfully!"