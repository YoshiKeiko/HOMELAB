#!/bin/bash

cat > "$HOME/HomeLab/docs/COMPLETE_SERVICES_GUIDE.md" << 'EOF'
# 🏠 Complete HomeLab Services Guide

**Your 40+ Service Enterprise HomeLab**
**M4 Mac Mini Server + MacBook Air Client**

---

# 📑 Table of Contents

1. [Media Services](#media-services) (Plex, Jellyfin, Radarr, Sonarr, etc.)
2. [Smart Home](#smart-home) (Home Assistant, Zigbee2MQTT, etc.)
3. [Monitoring & Dashboards](#monitoring--dashboards) (Grafana, Prometheus, etc.)
4. [Security & Privacy](#security--privacy) (Vaultwarden, AdGuard, CrowdSec)
5. [Storage & Backup](#storage--backup) (Nextcloud, Syncthing, Duplicati)
6. [AI & Development](#ai--development) (OpenWebUI, Ollama, Jupyter)
7. [Utilities](#utilities) (File Browser, Gitea, etc.)
8. [System Services](#system-services) (Portainer, Nginx Proxy Manager)
9. [Access from MacBook Air](#access-from-macbook-air)
10. [Power Management & Auto-Start](#power-management)
11. [Testing Checklist](#complete-testing-checklist)

---

# Media Services

## 🎬 Plex - Your Personal Netflix

**What it does:** Stream your movies, TV shows, music, and photos to any device.

**Port:** 32400
**Access:** http://M4-IP:32400/web

### Configuration Steps:

1. **Open Plex:** http://localhost:32400/web (on M4)
2. **Sign in** with Plex account (create if needed)
3. **Add Libraries:**
   - Movies: `/movies` → `/Volumes/HomeLab-4TB/Media/Movies`
   - TV Shows: `/tv` → `/Volumes/HomeLab-4TB/Media/TV Shows`
   - Music: `/music` → `/Volumes/HomeLab-4TB/Media/Music`
   - Photos: `/photos` → `/Volumes/HomeLab-4TB/Media/Photos`

4. **Settings → Remote Access:**
   - ✅ Enable "Manually specify public port: 32400"
   - This allows streaming outside home

5. **Settings → Network:**
   - Custom server access URLs: `http://M4-IP:32400`

### Test:
- [ ] Add test movie to `/Volumes/HomeLab-4TB/Media/Movies/Test (2024)/`
- [ ] Scan library
- [ ] Play test movie in Plex
- [ ] **From MacBook:** Open http://M4-IP:32400/web
- [ ] Stream movie to MacBook

### MacBook Air Access:
```
http://YOUR-M4-IP:32400/web
```
Or use Plex app from App Store (better experience)

---

## 📺 Jellyfin - Open Source Media Server

**What it does:** Alternative to Plex, completely free and open source.

**Port:** 8096
**Access:** http://M4-IP:8096

### Configuration Steps:

1. **First Access:** http://localhost:8096
2. **Setup Wizard:**
   - Language: English
   - Create admin user
   - Add libraries (same as Plex):
     - Movies: `/movies`
     - TV Shows: `/tv`
     - Music: `/music`

3. **Settings → Dashboard → Playback:**
   - Enable hardware acceleration (Apple Silicon)
   - Max streaming bitrate: Automatic

### Test:
- [ ] Login with admin credentials
- [ ] Add test movie
- [ ] Play in browser
- [ ] **From MacBook:** http://M4-IP:8096
- [ ] Install Jellyfin app on MacBook for better experience

### MacBook Air Access:
```
http://YOUR-M4-IP:8096
```

---

## 🎥 Radarr - Automated Movie Downloads

**What it does:** Automatically searches for, downloads, and organizes movies.

**Port:** 7878
**Access:** http://M4-IP:7878

### Configuration Steps:

1. **Open:** http://localhost:7878
2. **Settings → Media Management:**
   - Root Folder: `/movies`
   - ✅ Rename Movies
   - ✅ Create empty folders for new movies

3. **Settings → Indexers:**
   - Should see Prowlarr indexers automatically
   - If not, see Prowlarr setup

4. **Settings → Download Clients:**
   - Add → Transmission
   - Host: `transmission`
   - Port: `9091`
   - Username: `admin`
   - Password: `transmission`
   - Category: `radarr`

5. **Settings → Connect:**
   - Add → Plex Media Server
   - Host: `plex`
   - Port: `32400`
   - Authenticate with Plex.tv

### Test:
- [ ] Add movie (e.g., "Big Buck Bunny")
- [ ] Click search (magnifying glass)
- [ ] Verify appears in queue
- [ ] Check Transmission for download
- [ ] Wait for completion
- [ ] Verify in Plex

### MacBook Air Access:
```
http://YOUR-M4-IP:7878
```

---

## 📺 Sonarr - Automated TV Show Downloads

**What it does:** Like Radarr but for TV shows. Automatically downloads new episodes.

**Port:** 8989
**Access:** http://M4-IP:8989

### Configuration Steps:

**Same as Radarr but:**
- Root Folder: `/tv`
- Download Client category: `sonarr`

### Test:
- [ ] Add TV show (e.g., "Breaking Bad")
- [ ] Monitor specific seasons
- [ ] Search for episodes
- [ ] Verify downloads
- [ ] Check appears in Plex/Jellyfin

### MacBook Air Access:
```
http://YOUR-M4-IP:8989
```

---

## 🔍 Prowlarr - Indexer Manager

**What it does:** Central hub for torrent/usenet indexers. Syncs to Radarr/Sonarr.

**Port:** 9696
**Access:** http://M4-IP:9696

### Configuration Already Complete!

**Configured indexers:**
- 1337x (with FlareSolverr)
- TorrentGalaxy
- EZTV
- YTS
- Nyaa

**Connected to:**
- Radarr
- Sonarr

### Test:
- [ ] Search for "Inception" in Prowlarr
- [ ] See results from all indexers
- [ ] Verify indexers show in Radarr/Sonarr

### MacBook Air Access:
```
http://YOUR-M4-IP:9696
```

---

## 🎭 Overseerr - Media Request System

**What it does:** Beautiful interface for family to request movies/TV shows.

**Port:** 5055
**Access:** http://M4-IP:5055

### Configuration Steps:

1. **Setup wizard complete** (Plex connected, Radarr/Sonarr linked)
2. **Settings → Users:**
   - Import Plex users
   - Set request limits per user

3. **Share with family:** Give them the URL

### Test:
- [ ] Request a movie
- [ ] Verify appears in Radarr
- [ ] Track status in Overseerr
- [ ] Get notification when ready

### MacBook Air Access:
```
http://YOUR-M4-IP:5055
```
**Family members can use this from their devices too!**

---

## 📥 Transmission - Download Client

**What it does:** Downloads torrents for Radarr/Sonarr.

**Port:** 9091
**Username:** admin
**Password:** transmission

**Access:** http://M4-IP:9091

### Test:
- [ ] Login with credentials
- [ ] See active downloads
- [ ] Check download/upload speeds

### MacBook Air Access:
```
http://YOUR-M4-IP:9091
Username: admin
Password: transmission
```

---

## 📊 Tautulli - Plex Statistics

**What it does:** Detailed Plex watching statistics and monitoring.

**Port:** 8181
**Access:** http://M4-IP:8181

### Configuration Steps:

1. **First run:** Setup wizard
2. **Connect to Plex:**
   - Plex IP: `plex` or `localhost`
   - Port: `32400`
   - Authenticate

3. **View stats:**
   - What's being watched
   - User activity
   - Popular content
   - Bandwidth usage

### Test:
- [ ] Play something in Plex
- [ ] See live stream in Tautulli
- [ ] View watch history

### MacBook Air Access:
```
http://YOUR-M4-IP:8181
```

---

# Smart Home

## 🏠 Home Assistant - Smart Home Hub

**What it does:** Central control for ALL smart home devices.

**Port:** 8123
**Access:** http://M4-IP:8123

### Configuration Steps:

1. **First run:** Create admin account
2. **Setup location:** Your address
3. **Add integrations:**
   - Nest (for cameras)
   - Tesla
   - Sonos
   - Zigbee2MQTT (for Zigbee devices)
   - MQTT (Mosquitto)

4. **Configure dashboards:**
   - Overview
   - Energy monitoring
   - Security cameras
   - Climate control

### Devices to Add:
- ✅ 10 Sonos speakers
- ✅ 5 Nest cameras  
- ✅ Tesla Model Y
- ✅ Cupra Born EV
- ✅ Easee charger
- ✅ Zigbee devices (via Zigbee2MQTT)

### Test:
- [ ] Add Sonos integration
- [ ] Control speaker volume
- [ ] View Nest camera feeds
- [ ] Check Tesla status
- [ ] Create automation (lights on at sunset)

### MacBook Air Access:
```
http://YOUR-M4-IP:8123
```
Or use Home Assistant app for better mobile experience

---

## 🐝 Zigbee2MQTT - Zigbee Device Bridge

**What it does:** Connects Zigbee devices to Home Assistant via MQTT.

**Port:** 8080 (web UI)
**Access:** http://M4-IP:8080

### Configuration:
- Already configured to connect to Mosquitto
- Devices appear in Home Assistant automatically

### Test:
- [ ] Open web UI
- [ ] See paired devices
- [ ] Pair new Zigbee device
- [ ] Verify in Home Assistant

### MacBook Air Access:
```
http://YOUR-M4-IP:8080
```

---

## 🦟 Mosquitto - MQTT Broker

**What it does:** Message broker for IoT devices (invisible backend).

**Port:** 1883 (MQTT), 9001 (WebSocket)
**No web UI** - it's a service

### Test:
- [ ] Home Assistant connected
- [ ] Zigbee2MQTT connected
- [ ] Messages flowing (check HA logs)

---

## 🎛️ Node-RED - Visual Automation

**What it does:** Create complex automations with drag-and-drop interface.

**Port:** 1880
**Access:** http://M4-IP:1880

### Configuration:
1. Create flows by dragging nodes
2. Connect to Home Assistant
3. Create advanced automations

### Examples:
- If Nest detects motion → Turn on lights
- If Tesla arrives home → Open garage
- If no one home → Set to away mode

### Test:
- [ ] Create simple flow (inject → debug)
- [ ] Deploy flow
- [ ] See output in debug panel

### MacBook Air Access:
```
http://YOUR-M4-IP:1880
```

---

## 🎮 ESPHome - DIY Smart Devices

**What it does:** Create custom ESP32/ESP8266 smart devices.

**Port:** 6052
**Access:** http://M4-IP:6052

### Use Cases:
- Custom temperature sensors
- DIY smart plugs
- LED strip controllers
- Garage door openers

### MacBook Air Access:
```
http://YOUR-M4-IP:6052
```

---

# Monitoring & Dashboards

## 📊 Grafana - Beautiful Dashboards

**What it does:** Visualize all your metrics in beautiful dashboards.

**Port:** 3000
**Default credentials:** admin / admin (change on first login)

**Access:** http://M4-IP:3000

### Configuration Steps:

1. **First login:** Change default password
2. **Add Data Sources:**
   - Prometheus (http://prometheus:9090)
   - InfluxDB (http://influxdb:8086)
   - Loki (http://loki:3100)

3. **Import Dashboards:**
   - Node Exporter Full (ID: 1860)
   - Docker monitoring (ID: 893)
   - Home Assistant (ID: 13177)

4. **Create custom dashboards:**
   - System resources
   - Container stats
   - Network usage
   - Smart home data

### Test:
- [ ] Login successful
- [ ] Add Prometheus data source
- [ ] Import dashboard
- [ ] See live metrics

### MacBook Air Access:
```
http://YOUR-M4-IP:3000
```

---

## 📈 Prometheus - Metrics Database

**What it does:** Collects and stores metrics from all services.

**Port:** 9090
**Access:** http://M4-IP:9090

### Configuration:
- Auto-discovers Docker containers
- Scrapes metrics every 15 seconds
- Stores time-series data

### Test:
- [ ] Open Prometheus UI
- [ ] Run query: `up`
- [ ] See all targets
- [ ] Graph CPU usage

### MacBook Air Access:
```
http://YOUR-M4-IP:9090
```

---

## 🌊 Netdata - Real-Time Monitoring

**What it does:** Beautiful real-time system monitoring.

**Port:** 19999
**Access:** http://M4-IP:19999

### Features:
- CPU usage per core
- Memory usage
- Disk I/O
- Network traffic
- Container stats
- **All in REAL-TIME!**

### Test:
- [ ] Open dashboard
- [ ] See live CPU graph
- [ ] Check disk usage
- [ ] View network traffic

### MacBook Air Access:
```
http://YOUR-M4-IP:19999
```
**No login required! Bookmark this for quick system checks**

---

## ⏱️ Uptime Kuma - Service Monitoring

**What it does:** Monitors if your services are up/down with alerts.

**Port:** 3001
**Access:** http://M4-IP:3001

### Configuration Steps:

1. **First run:** Create admin account
2. **Add monitors:**
   - Plex (http://plex:32400)
   - Home Assistant (http://homeassistant:8123)
   - Grafana (http://grafana:3000)
   - All important services

3. **Setup notifications:**
   - Email (Gmail)
   - Discord
   - Telegram
   - Get alerted if service goes down!

### Test:
- [ ] Add Plex monitor
- [ ] See "Up" status
- [ ] Stop Plex temporarily
- [ ] Get alert (if configured)
- [ ] Start Plex, see recovery

### MacBook Air Access:
```
http://YOUR-M4-IP:3001
```

---

## 🔍 cAdvisor - Container Stats

**What it does:** Detailed Docker container resource usage.

**Port:** 8080
**Access:** http://M4-IP:8080

### Shows:
- CPU usage per container
- Memory usage per container
- Network I/O
- Disk I/O

### MacBook Air Access:
```
http://YOUR-M4-IP:8080
```

---

## 📝 Loki - Log Aggregation

**What it does:** Collects logs from all containers (backend for Grafana).

**Port:** 3100
**No web UI** - use via Grafana

### Test in Grafana:
- [ ] Add Loki data source
- [ ] Explore → Select Loki
- [ ] Query: `{container_name="plex"}`
- [ ] See Plex logs

---

## 🏠 Homer - Dashboard 1

**What it does:** Simple, fast dashboard with links to all services.

**Port:** 8081
**Access:** http://M4-IP:8081

### Configuration:
Edit config to add your services with icons

### MacBook Air Access:
```
http://YOUR-M4-IP:8081
```

---

## 🎨 Dashy - Dashboard 2

**What it does:** Modern, feature-rich dashboard.

**Port:** 4000
**Access:** http://M4-IP:4000

### Features:
- Widgets
- Status indicators
- Search
- Themes

### MacBook Air Access:
```
http://YOUR-M4-IP:4000
```

---

## 📑 Organizr - Dashboard 3

**What it does:** Tabbed dashboard - all services in one interface.

**Port:** 80
**Access:** http://M4-IP

### Setup:
1. Create admin account
2. Add tabs for each service
3. Enable SSO (single sign-on)

### MacBook Air Access:
```
http://YOUR-M4-IP
```

---

# Security & Privacy

## 🔐 Vaultwarden - Password Manager

**What it does:** Self-hosted Bitwarden - store all your passwords securely.

**Port:** 8000
**Access:** http://M4-IP:8000

### Configuration Steps:

1. **Create account** (first user is admin)
2. **Install browser extension:**
   - Bitwarden extension for Chrome/Firefox/Safari
   - Set server to: `http://M4-IP:8000`

3. **Import existing passwords:**
   - From 1Password
   - From Chrome
   - From other managers

4. **Enable 2FA:**
   - Settings → Security
   - Enable TOTP

### Test:
- [ ] Create account
- [ ] Add test password
- [ ] Install browser extension
- [ ] Login via extension
- [ ] Auto-fill test password

### MacBook Air Access:
```
http://YOUR-M4-IP:8000
```
Install Bitwarden extension, point to your M4 server

**IMPORTANT:** Backup Vaultwarden database regularly!

---

## 🛡️ AdGuard Home - DNS Ad Blocker

**What it does:** Blocks ads network-wide at DNS level.

**Port:** 3000 (web UI)
**DNS Port:** 53

**Access:** http://M4-IP:3000

### Configuration Steps:

1. **Setup wizard:** Create admin credentials
2. **Configure DNS:**
   - Upstream DNS: Cloudflare (1.1.1.1)
   - Enable DNS-over-HTTPS

3. **Add blocklists:**
   - Default lists already good
   - Add: Steven Black hosts
   - Add: Hagezi Pro

4. **Configure devices:**
   - On MacBook Air:
     - System Settings → Network
     - Advanced → DNS
     - Add: M4-IP

5. **Configure router** (better - blocks for whole home):
   - Router settings → DNS
   - Primary DNS: M4-IP
   - Secondary: 1.1.1.1

### Allowlist for Prowlarr:
If indexers blocked:
- Filters → Custom filtering rules
- Add: `@@||1337x.to^`
- Add: `@@||torrentgalaxy.to^`

### Test:
- [ ] Set MacBook DNS to M4-IP
- [ ] Visit website with ads
- [ ] Ads should be blocked!
- [ ] Check AdGuard dashboard for stats

### MacBook Air Access:
```
http://YOUR-M4-IP:3000
```

**To use ad blocking on MacBook:**
System Settings → Network → Wi-Fi → Details → DNS → Add M4-IP

---

## 🔒 CrowdSec - Security IPS

**What it does:** Detects and blocks malicious IP addresses.

**Port:** 8080 (API), No main web UI
**Dashboard:** Part of Grafana

### Features:
- Blocks brute force attempts
- Shares threat intelligence
- Protects all services

### Test:
- [ ] Check running: `docker logs crowdsec`
- [ ] View in Grafana dashboard
- [ ] See blocked IPs

---

# Storage & Backup

## ☁️ Nextcloud - Personal Cloud

**What it does:** Your own Dropbox/Google Drive.

**Port:** 8081 or 443
**Access:** http://M4-IP:8081

### Configuration Steps:

1. **First run:** Create admin account
2. **Install apps:**
   - Calendar
   - Contacts
   - Notes
   - Photos
   - Office (Collabora/OnlyOffice)

3. **Setup external storage:**
   - Mount HomeLab-4TB folders

4. **Install desktop client** on MacBook:
   - Download Nextcloud client
   - Connect to your server
   - Sync folders

### Test:
- [ ] Create folder
- [ ] Upload file
- [ ] Install MacBook client
- [ ] Sync file to MacBook
- [ ] Edit file, verify syncs

### MacBook Air Access:
```
http://YOUR-M4-IP:8081
```
Plus desktop/mobile apps for syncing

---

## 🔄 Syncthing - File Sync

**What it does:** Sync files between devices without cloud.

**Port:** 8384
**Access:** http://M4-IP:8384

### Configuration Steps:

1. **Install on MacBook:**
   ```bash
   brew install syncthing
   syncthing
   ```
   Opens: http://localhost:8384

2. **Add M4 as remote device:**
   - Actions → Show ID (on M4)
   - Add Remote Device (on MacBook)
   - Paste M4's ID

3. **Create shared folder:**
   - Documents folder
   - Photos folder
   - Syncs both ways automatically

### Test:
- [ ] Add M4 to MacBook Syncthing
- [ ] Create shared folder
- [ ] Add file on M4
- [ ] Verify appears on MacBook
- [ ] Edit on MacBook
- [ ] Verify syncs to M4

### MacBook Air Access:
```
http://YOUR-M4-IP:8384 (M4 Syncthing)
http://localhost:8384 (MacBook Syncthing)
```

---

## 💾 Duplicati - Backup Solution

**What it does:** Encrypted backups to cloud storage (B2, Google Drive, etc.)

**Port:** 8200
**Access:** http://M4-IP:8200

### Configuration Steps:

1. **Create backup job:**
   - Source: `/Users/homelab/HomeLab/Docker/Data`
   - Destination: Backblaze B2 / Google Drive
   - Schedule: Daily at 3 AM
   - Retention: 30 days

2. **Encryption:** Set strong passphrase

3. **Test restore** to verify backups work

### Test:
- [ ] Create backup job
- [ ] Run backup manually
- [ ] Verify files in destination
- [ ] Restore single file
- [ ] Verify file intact

### MacBook Air Access:
```
http://YOUR-M4-IP:8200
```

---

## 📁 File Browser - Web File Manager

**Port:** 8087
**Username:** admin
**Password:** W9pJ1w8LSmEe96v3 (change after first login!)

**Access:** http://M4-IP:8087

### What you can do:
- Browse files on M4
- Upload/download files
- Create folders
- Edit text files
- Share files via link

### Test:
- [ ] Login
- [ ] Browse to HomeLab-4TB
- [ ] Create test folder
- [ ] Upload file from MacBook
- [ ] Download file to MacBook

### MacBook Air Access:
```
http://YOUR-M4-IP:8087
Username: admin
Password: W9pJ1w8LSmEe96v3
```

**CHANGE PASSWORD AFTER FIRST LOGIN!**

---

# AI & Development

## 🤖 OpenWebUI - Local AI Chat

**What it does:** Chat interface for Ollama (like ChatGPT but local).

**Port:** 3000 or 8080
**Access:** http://M4-IP:PORT

### Configuration:
1. Create account
2. Connect to Ollama (http://ollama:11434)
3. Download models (llama2, mistral, etc.)

### Test:
- [ ] Login
- [ ] Select model
- [ ] Ask question: "What's the weather like?"
- [ ] Get response

### MacBook Air Access:
```
http://YOUR-M4-IP:PORT
```

---

## 🦙 Ollama - Local AI Models

**What it does:** Runs large language models locally.

**Port:** 11434 (API)
**Access:** http://M4-IP:11434

### Pull models:
```bash
docker exec ollama ollama pull llama2
docker exec ollama ollama pull mistral
```

### Test:
```bash
docker exec ollama ollama run llama2 "Hello!"
```

---

## 💻 Code Server - VS Code in Browser

**What it does:** Full VS Code running in your browser.

**Port:** 8443
**Access:** http://M4-IP:8443

### Configuration:
- Password in logs or environment variable
- Install extensions
- Open terminal

### Use cases:
- Edit config files remotely
- Code from any device
- No local IDE needed

### MacBook Air Access:
```
http://YOUR-M4-IP:8443
```

---

## 📓 Jupyter - Python Notebooks

**What it does:** Interactive Python notebooks for data science.

**Port:** 8888
**Access:** http://M4-IP:8888

### Features:
- Run Python code
- Data visualization
- Machine learning
- Documentation

### Test:
- [ ] Create new notebook
- [ ] Run: `print("Hello")`
- [ ] Install library: `!pip install pandas`
- [ ] Create plot

### MacBook Air Access:
```
http://YOUR-M4-IP:8888
```

---

## 🦊 Gitea - Git Server

**What it does:** Self-hosted GitHub alternative.

**Port:** 3000
**Access:** http://M4-IP:3000

### Configuration:
1. Setup wizard on first access
2. Create admin account
3. Create repositories
4. Clone to MacBook

### MacBook Git setup:
```bash
git clone http://M4-IP:3000/username/repo.git
```

### Test:
- [ ] Create repo
- [ ] Clone to MacBook
- [ ] Make commit
- [ ] Push to Gitea
- [ ] View in web UI

### MacBook Air Access:
```
http://YOUR-M4-IP:3000
```

---

# Utilities

## 📸 PhotoPrism - Photo Management

**What it does:** AI-powered photo organization (like Google Photos).

**Port:** 2342
**Access:** http://M4-IP:2342

### Features:
- Face recognition
- Object detection
- Map view
- Albums
- Sharing

### Configuration:
1. Import photos from folder
2. Let it index (takes time!)
3. Browse by face, location, object

### Test:
- [ ] Upload photos
- [ ] Wait for indexing
- [ ] Search for "sunset"
- [ ] Create album
- [ ] Share album

### MacBook Air Access:
```
http://YOUR-M4-IP:2342
```

---

## 📄 Paperless-ngx - Document Management

**What it does:** Scan, OCR, and organize all your documents.

**Port:** 8000
**Access:** http://M4-IP:8000

### Configuration:
1. Create superuser account
2. Setup email consumption (optional)
3. Define document types
4. Create tags

### Use cases:
- Scan receipts
- Store bills
- Organize contracts
- Search all documents

### Test:
- [ ] Upload PDF
- [ ] Wait for OCR
- [ ] Search content
- [ ] Tag document
- [ ] Download

### MacBook Air Access:
```
http://YOUR-M4-IP:8000
```

---

## 📚 Calibre - eBook Library

**What it does:** Manage your eBook collection.

**Port:** 8083
**Access:** http://M4-IP:8083

### Features:
- Import ebooks
- Convert formats
- Sync to eReader
- Read in browser

### MacBook Air Access:
```
http://YOUR-M4-IP:8083
```

---

## 📰 FreshRSS - RSS Reader

**What it does:** Aggregate and read RSS feeds.

**Port:** 8085
**Access:** http://M4-IP:8085

### Configuration:
1. Create account
2. Add feeds (news, blogs, YouTube channels)
3. Organize with categories

### MacBook Air Access:
```
http://YOUR-M4-IP:8085
```

---

# System Services

## 🐳 Portainer - Docker Management

**What it does:** Web UI for managing all Docker containers.

**Port:** 9000
**Access:** http://M4-IP:9000

### What you can do:
- Start/stop containers
- View logs
- See resource usage
- Update containers
- Manage networks

### Test:
- [ ] View container list
- [ ] Restart Plex
- [ ] Check logs
- [ ] View stats

### MacBook Air Access:
```
http://YOUR-M4-IP:9000
```

**Bookmark this - your main management interface!**

---

## 🔄 Nginx Proxy Manager - Reverse Proxy

**What it does:** Manage reverse proxies with SSL certificates.

**Port:** 81 (admin UI)
**Default:** admin@example.com / changeme

**Access:** http://M4-IP:81

### Use cases:
- Add custom domains
- Get Let's Encrypt SSL certs
- Access services via subdomain

### Example:
Instead of `http://M4-IP:32400`
Use: `https://plex.yourdomain.com`

### MacBook Air Access:
```
http://YOUR-M4-IP:81
```

---

## 💾 InfluxDB - Time Series Database

**What it does:** Stores time-series data (metrics, IoT data).

**Port:** 8086 (web UI), 8087 (RPC)
**Access:** http://M4-IP:8086

### Used by:
- Home Assistant (historical data)
- Grafana (metrics visualization)
- IoT sensors

### Test:
- [ ] Open web UI
- [ ] Create bucket
- [ ] Query data
- [ ] View in Grafana

### MacBook Air Access:
```
http://YOUR-M4-IP:8086
```

---

# Access from MacBook Air

## 🌐 Network Setup

### Find Your M4's IP Address

**On M4:**
```bash
ifconfig en0 | grep "inet " | awk '{print $2}'
```

Or check System Settings → Network

**Example:** `192.168.68.100`

### Create Shortcuts on MacBook

1. **Create bookmarks folder** in Safari/Chrome: "HomeLab"

2. **Add all services:**
```
Plex:              http://192.168.68.100:32400/web
Home Assistant:    http://192.168.68.100:8123
Grafana:           http://192.168.68.100:3000
Portainer:         http://192.168.68.100:9000
File Browser:      http://192.168.68.100:8087
Netdata:           http://192.168.68.100:19999
Overseerr:         http://192.168.68.100:5055
```

### Better Option: Use Tailscale

**Setup Tailscale for remote access:**

1. **Install on M4:**
   ```bash
   brew install tailscale
   sudo tailscale up
   ```

2. **Install on MacBook:**
   ```bash
   brew install tailscale
   sudo tailscale up
   ```

3. **Access from anywhere:**
   ```
   http://100.X.X.X:32400 (Tailscale IP)
   ```

Works even when away from home!

---

## 📱 Mobile Apps for Better Experience

### Install These on MacBook/iPhone/iPad:

**Media:**
- Plex (App Store) - Better than web
- Infuse (excellent video player)

**Smart Home:**
- Home Assistant (App Store)

**Monitoring:**
- Grafana mobile app

**Password Manager:**
- Bitwarden (points to your Vaultwarden)

**File Sync:**
- Nextcloud desktop client
- Syncthing

---

# Power Management & Auto-Start

## ⚡ M4 Mac Mini Power Configuration

### Essential Settings (Already Applied)

```bash
# Never sleep (server must stay on!)
sudo pmset -a sleep 0
sudo pmset -a disksleep 0
sudo pmset -a displaysleep 10

# Auto-restart after power failure
sudo pmset -a autorestart 1
sudo systemsetup -setrestartfreeze on

# Wake for network access
sudo pmset -a womp 1
```

### Verify Settings

```bash
pmset -g
```

Should show:
- sleep: 0
- disksleep: 0  
- autorestart: 1
- womp: 1

---

## 🔄 Auto-Start on Reboot

### Docker Services Auto-Start

All your containers have: `restart: unless-stopped`

**This means:**
- ✅ Auto-start on Mac reboot
- ✅ Auto-restart if crash
- ✅ Manual stop stays stopped

### HomeLab-4TB Auto-Mount

**Option 1: System Settings**
1. System Settings → Users & Groups
2. Login Items
3. Add HomeLab-4TB drive
4. Check "Hide" (don't open Finder)

**Option 2: fstab (Advanced)**
Auto-mount via UUID - more reliable

### Docker Start on Boot

**OrbStack automatically starts on login**

Verify:
```bash
# Check OrbStack is running
orbctl status

# Check containers
docker ps
```

---

## 🔋 Power Management Best Practices

### What to Enable:

✅ **Never sleep** (M4 is your server)
✅ **Display can sleep** (no monitor needed)
✅ **Auto-restart after power outage**
✅ **Wake for network access**
✅ **All containers auto-restart**

### What to Disable:

❌ **Power Nap** (causes wake issues)
❌ **Put hard disks to sleep** (external drive issues)
❌ **Automatic updates during sleep** (not sleeping anyway)

### UPS Recommended

**Get a UPS (Uninterruptible Power Supply):**
- Protects from power outages
- Clean shutdown if power lost
- Prevents data corruption

**Recommended:**
- APC Back-UPS 1500VA
- CyberPower CP1500PFCLCD

---

## 🔧 Maintenance Automation

### Daily Tasks (Automated)

**Watchtower (4 AM daily):**
- Updates all containers
- Pulls new images
- Restarts with updates
- Cleans old images

**Duplicati (3 AM daily):**
- Backs up Docker configs
- Encrypted backup to cloud
- 30-day retention

**Cleanup script:**
```bash
# Create maintenance script
cat > ~/daily-cleanup.sh << 'EOFCLEAN'
#!/bin/bash
# Clean Docker
docker system prune -f
# Clean logs
find ~/HomeLab/logs -type f -mtime +30 -delete
EOFCLEAN

chmod +x ~/daily-cleanup.sh

# Add to crontab
crontab -e
# Add: 0 2 * * * ~/daily-cleanup.sh
```

---

## 🆘 Recovery After Power Loss

### What Happens:

1. **Power restored** → Mac auto-boots
2. **macOS starts** → OrbStack starts
3. **Docker starts** → All containers start
4. **HomeLab-4TB** → Auto-mounts (if configured)
5. **All services** → Available in 2-3 minutes

### Manual Recovery (if needed):

```bash
# 1. Check drive mounted
ls /Volumes/HomeLab-4TB

# 2. Check Docker running
docker ps

# 3. Start all services if needed
cd ~/HomeLab/Docker/Compose
docker compose -f core.yml up -d
docker compose -f media.yml up -d
docker compose -f smart-home.yml up -d
# etc.

# 4. Check status
docker ps | grep -E "STATUS|Up"
```

---

# Complete Testing Checklist

## 🧪 Full System Test (Run This!)

### Phase 1: Media Services
- [ ] Plex accessible from MacBook
- [ ] Play movie in Plex
- [ ] Jellyfin accessible
- [ ] Radarr adds movie successfully
- [ ] Sonarr adds TV show
- [ ] Prowlarr search returns results
- [ ] Overseerr request works
- [ ] Transmission shows active downloads
- [ ] Movie appears in Plex after download

### Phase 2: Smart Home
- [ ] Home Assistant accessible from MacBook
- [ ] Sonos speaker control works
- [ ] Nest camera feed visible
- [ ] Tesla shows status
- [ ] Create simple automation
- [ ] Zigbee2MQTT shows devices
- [ ] Node-RED flow executes

### Phase 3: Monitoring
- [ ] Grafana accessible from MacBook
- [ ] Dashboard shows metrics
- [ ] Prometheus has data
- [ ] Netdata shows real-time stats
- [ ] Uptime Kuma monitors services
- [ ] Alert when service stopped (test)

### Phase 4: Security & Storage
- [ ] Vaultwarden saves password
- [ ] Browser extension works
- [ ] AdGuard blocks ads on MacBook
- [ ] Nextcloud syncs file
- [ ] Syncthing syncs to MacBook
- [ ] Duplicati backup completes
- [ ] File Browser upload works

### Phase 5: AI & Development
- [ ] OpenWebUI responds to prompt
- [ ] Ollama model loads
- [ ] Jupyter notebook runs code
- [ ] Code Server opens files
- [ ] Gitea clone to MacBook

### Phase 6: Utilities
- [ ] PhotoPrism indexes photos
- [ ] Paperless-ngx scans document
- [ ] Calibre opens ebook
- [ ] FreshRSS shows feeds

### Phase 7: System
- [ ] Portainer shows all containers
- [ ] All containers "Up" status
- [ ] Logs accessible
- [ ] Restart container works

### Phase 8: Power & Recovery
- [ ] Restart M4 Mac
- [ ] Wait 3 minutes
- [ ] All containers auto-start
- [ ] HomeLab-4TB mounted
- [ ] Services accessible from MacBook
- [ ] No manual intervention needed

---

# Quick Reference - All Ports

```
Port    Service              Access From MacBook
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
80      Organizr             http://M4-IP
81      Nginx Proxy Mgr      http://M4-IP:81
1880    Node-RED             http://M4-IP:1880
2342    PhotoPrism           http://M4-IP:2342
3000    Grafana              http://M4-IP:3000
3001    Uptime Kuma          http://M4-IP:3001
4000    Dashy                http://M4-IP:4000
5055    Overseerr            http://M4-IP:5055
6052    ESPHome              http://M4-IP:6052
7878    Radarr               http://M4-IP:7878
8000    Vaultwarden          http://M4-IP:8000
8080    Zigbee2MQTT          http://M4-IP:8080
8081    Homer                http://M4-IP:8081
8083    Calibre              http://M4-IP:8083
8085    FreshRSS             http://M4-IP:8085
8086    InfluxDB             http://M4-IP:8086
8087    File Browser         http://M4-IP:8087
8096    Jellyfin             http://M4-IP:8096
8123    Home Assistant       http://M4-IP:8123
8181    Tautulli             http://M4-IP:8181
8200    Duplicati            http://M4-IP:8200
8384    Syncthing            http://M4-IP:8384
8443    Code Server          http://M4-IP:8443
8888    Jupyter              http://M4-IP:8888
8989    Sonarr               http://M4-IP:8989
9000    Portainer            http://M4-IP:9000
9090    Prometheus           http://M4-IP:9090
9091    Transmission         http://M4-IP:9091
9696    Prowlarr             http://M4-IP:9696
11434   Ollama API           http://M4-IP:11434
19999   Netdata              http://M4-IP:19999
32400   Plex                 http://M4-IP:32400/web
```

---

# 🎉 Congratulations!

**You have built an ENTERPRISE-GRADE homelab!**

**Your capabilities:**
- 📺 Personal streaming service (Plex/Jellyfin)
- 🎬 Automated media acquisition
- 🏠 Complete smart home control
- 📊 Professional-grade monitoring
- 🔐 Self-hosted password manager
- ☁️ Personal cloud storage
- 🤖 Local AI capabilities
- 🛡️ Network-wide ad blocking
- 📸 AI photo management
- 📄 Document organization
- 💾 Encrypted backups
- 🔄 Automatic updates
- ⚡ Zero-downtime operation

**All running on a tiny M4 Mac Mini!**

**Access from anywhere:**
- MacBook Air at home
- MacBook Air away (via Tailscale)
- iPhone/iPad (via apps)
- Any browser

**Zero maintenance:**
- Auto-updates (Watchtower)
- Auto-backups (Duplicati)
- Auto-restart (power loss recovery)
- Auto-monitoring (Uptime Kuma alerts)

**You're basically running a small data center! 🚀**

EOF

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Complete Services Guide Created!"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "View the guide:"
echo "  open ~/HomeLab/docs/COMPLETE_SERVICES_GUIDE.md"
echo ""
echo "This guide includes:"
echo "  - Configuration for all 40+ services"
echo "  - How to access from MacBook Air"
echo "  - Complete testing checklist"
echo "  - Power management setup"
echo "  - Auto-start configuration"
echo "  - Recovery procedures"
echo ""
echo "Your enterprise homelab documentation is ready!"
echo ""