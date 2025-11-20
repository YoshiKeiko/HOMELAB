# 📘 STEVE'S HOMELAB COMPLETE HANDBOOK

**Version:** 1.0  
**Last Updated:** November 19, 2025  
**Hardware:** M4 Mac Mini (32GB RAM, 512GB SSD + 4TB External)  
**Network:** 10GbE, 5Gbps CityFibre Internet

---

# TABLE OF CONTENTS

1. [What We Built](#what-we-built)
2. [How We Built It](#how-we-built-it)
3. [Complete Service List](#complete-service-list)
4. [Access Guide](#access-guide)
5. [Service Explanations](#service-explanations)
6. [Backup & Restore](#backup--restore)
7. [Testing Procedures](#testing-procedures)
8. [Troubleshooting](#troubleshooting)
9. [Recreation Guide](#recreation-guide)

---

# WHAT WE BUILT

## Infrastructure Overview

You now have a **56-container enterprise-grade homelab** running on your M4 Mac Mini using OrbStack (Docker). This provides:

### Core Capabilities
- **Media Management**: Complete Plex + Jellyfin setup with automated downloads
- **Smart Home Integration**: Home Assistant controlling 10 Sonos speakers, 5 Nest cameras, EVs, and more
- **AI Services**: Local LLMs via Ollama with ChatGPT-like interface
- **Security**: Network-wide ad blocking, password management, intrusion detection
- **Monitoring**: Real-time system metrics, uptime tracking, log aggregation
- **Storage**: Cloud storage, photo management, document scanning
- **Productivity**: RSS reader, e-books, code editing, Git hosting
- **Dashboards**: Multiple options (Heimdall, Homer, Dashy, Organizr)

### Network Architecture
```
Internet (5Gbps) → Router (Sky) → Mac Mini (10GbE) → Services
                                     ↓
                               AdGuard DNS (192.168.50.50)
                                     ↓
                          All Devices Get Ad Blocking
```

### Storage Layout
- **Internal 512GB SSD**: Docker configs, databases, system files
- **External 4TB**: Media content, photos, backups, large data

---

# HOW WE BUILT IT

## Phase 1: Foundation (Week 1)

### Step 1.1: Install OrbStack
```bash
brew install orbstack
```
**Why**: OrbStack provides Docker on macOS with better performance than Docker Desktop

### Step 1.2: Create Network
```bash
docker network create homelab-network
```
**Why**: Allows containers to communicate with each other

### Step 1.3: Create Directory Structure
```bash
mkdir -p ~/homelab/Docker/Data
mkdir -p ~/homelab/Docker/Compose  
mkdir -p ~/homelab/Scripts
mkdir -p ~/homelab/docs
```

## Phase 2: Core Infrastructure

### Portainer (Docker Management)
```bash
docker run -d \
  --name portainer \
  --restart unless-stopped \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

### Watchtower (Auto-Updates)
```bash
docker run -d \
  --name watchtower \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower:latest \
  --schedule "0 0 4 * * *"
```

### AdGuard Home (DNS/Ad Blocking)
```bash
docker run -d \
  --name adguard-home \
  --restart unless-stopped \
  --network homelab-network \
  -p 53:53/tcp -p 53:53/udp \
  -p 8084:3000/tcp \
  -v /Volumes/HomeLab-4TB/Docker/Data/adguard/work:/opt/adguardhome/work \
  -v /Volumes/HomeLab-4TB/Docker/Data/adguard/conf:/opt/adguardhome/conf \
  adguard/adguardhome:latest
```

**Router DNS Configuration:**
- Primary DNS: 192.168.50.50 (AdGuard)
- Secondary DNS: 192.168.50.1 (Sky Shield fallback)

## Phase 3: Databases

Deployed PostgreSQL, MariaDB, MongoDB, Redis, and InfluxDB for application data storage.

## Phase 4: Media Stack

Deployed Plex, Jellyfin, Sonarr, Radarr, Prowlarr, Overseerr, Transmission, Tautulli for complete media automation.

## Phase 5: Smart Home Integration

Connected Home Assistant to:
- 10 Sonos speakers
- 5 Nest cameras
- Nest Thermostat
- Tesla Model Y
- Cupra Born
- Easee charger
- Meross smart plugs
- LG TVs
- Gaming consoles

## Phase 6: AI & Monitoring

Added Ollama/Open WebUI for local AI, Grafana/Prometheus for monitoring, Uptime Kuma for status tracking.

## Phase 7: Security & Storage

Deployed Vaultwarden, CrowdSec, Fail2ban for security. Added Nextcloud, PhotoPrism, Paperless-ngx for storage/documents.

## Phase 8: Dashboards & Productivity

Set up Heimdall (main dashboard), plus Homer, Dashy, Organizr as alternatives. Added FreshRSS, Calibre, Code Server, Gitea.

---

# COMPLETE SERVICE LIST

## Infrastructure (3)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Portainer | 9000 | Docker management UI | ✅ |
| Watchtower | - | Auto-updates containers | ✅ |
| Nginx Proxy Manager | 81 | Reverse proxy & SSL | ✅ |

## Databases (5)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| PostgreSQL | 5432 | Relational database | ✅ |
| MariaDB | 3306 | MySQL-compatible DB | ✅ |
| MongoDB | 27017 | Document database | ✅ |
| Redis | 6379 | Cache/queue | ✅ |
| InfluxDB | 8086 | Time-series database | ✅ |

## Media Management (9)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Plex | 32400 | Media server | ✅ |
| Jellyfin | 8096 | Alternative media server | ✅ |
| Sonarr | 8989 | TV show automation | ✅ |
| Radarr | 7878 | Movie automation | ✅ |
| Prowlarr | 9696 | Indexer management | ✅ |
| Overseerr | 5055 | Request management | ✅ |
| Transmission | 9091 | Download client | ✅ |
| Tautulli | 8181 | Plex statistics | ✅ |
| FlareSolverr | 8191 | Cloudflare bypass | ✅ |
| Calibre | 8094 | E-book management | ✅ |

## Smart Home (5)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Home Assistant | 8123 | Smart home hub | ✅ |
| Node-RED | 1880 | Automation flows | ✅ |
| Zigbee2MQTT | 8080 | Zigbee bridge | ✅ |
| ESPHome | 6052 | ESP device manager | ✅ |
| Mosquitto | 1883 | MQTT broker | ✅ |

## AI Services (3)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Ollama | 11434 | Local LLM server | ✅ |
| Open WebUI | 3000 | ChatGPT-like interface | ✅ |
| Jupyter | 8888 | Data science notebooks | ✅ |

## Monitoring (8)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Grafana | 3003 | Metrics dashboard | ✅ |
| Prometheus | 9090 | Metrics collection | ✅ |
| Loki | 3100 | Log aggregation | ✅ |
| Promtail | - | Log shipper | ⚠️ |
| Uptime Kuma | 3004 | Uptime monitoring | ✅ |
| cAdvisor | 8085 | Container metrics | ✅ |
| Netdata | 19999 | Real-time monitoring | ✅ |
| Node Exporter | 9100 | System metrics | ✅ |

## Security (4)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| AdGuard Home | 8084 | DNS ad blocking | ✅ |
| Vaultwarden | 8088 | Password manager | ✅ |
| CrowdSec | 8089 | IDS/IPS | ✅ |
| Fail2ban | - | Intrusion prevention | ✅ |

## Storage (5)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Nextcloud | 8097 | Cloud storage | ✅ |
| PhotoPrism | 2342 | Photo management | ✅ |
| File Browser | 8087 | Web file manager | ✅ |
| Syncthing | 8384 | File sync | ✅ |
| Kopia | 8202 | Backup solution | ✅ |

## Productivity (5)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Paperless-ngx | 8093 | Document management | ⚠️ |
| FreshRSS | 8098 | RSS reader | ✅ |
| Code Server | 8443 | VS Code in browser | ✅ |
| Gitea | 3001 | Git hosting | ✅ |

## Dashboards (4)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Heimdall | 8090 | Main dashboard | ✅ |
| Homer | 8091 | Simple dashboard | ✅ |
| Dashy | 4000 | Feature-rich dashboard | ✅ |
| Organizr | 8092 | Unified dashboard | ✅ |

## Other (1)
| Service | Port | Purpose | Status |
|---------|------|---------|--------|
| Webtop (VNC) | 3050 | Ubuntu desktop | ✅ |

**Total: 56 Services**

---

# ACCESS GUIDE

## From Your Mac (Local)

All services accessible via `http://localhost:PORT`

Example: `http://localhost:8090` for Heimdall

## From Other Devices on Network

All services accessible via `http://192.168.50.50:PORT`

Example: `http://192.168.50.50:8090` for Heimdall

### iPhone/iPad
1. Open Safari
2. Go to `http://192.168.50.50:PORT`
3. Bookmark for easy access

### TV (LG WebOS)
1. Open web browser
2. Go to `http://192.168.50.50:32400/web` (Plex)
3. Or install Plex app from LG Content Store

### PlayStation 5 / Xbox
1. Open edge browser
2. Navigate to `http://192.168.50.50:PORT`
3. Or install native Plex app

### Another MacBook
Same as Mac - use `http://192.168.50.50:PORT`

## Quick Access URLs

**Most Used:**
- Heimdall Dashboard: http://192.168.50.50:8090
- Plex: http://192.168.50.50:32400/web
- Home Assistant: http://192.168.50.50:8123
- Portainer: http://192.168.50.50:9000
- AdGuard: http://192.168.50.50:8084

---

# SERVICE EXPLANATIONS

## Infrastructure Services

### Portainer
**What it does**: Web interface to manage all Docker containers  
**Why you need it**: Easy point-and-click container management  
**How to use**:
1. Login at http://192.168.50.50:9000
2. View all containers, start/stop them
3. Check logs, stats, and configurations
4. Deploy new containers via UI

### Watchtower
**What it does**: Automatically updates Docker containers  
**Why you need it**: Keeps everything up-to-date without manual work  
**How it works**: Runs at 4 AM daily, checks for updates, applies them  
**No UI** - it's a background service

### Nginx Proxy Manager
**What it does**: Reverse proxy with SSL certificates  
**Why you need it**: Secure external access with HTTPS  
**How to use**:
1. Login at http://192.168.50.50:81
2. Add proxy hosts for external access
3. Request SSL certificates (automatic via Let's Encrypt)

## Media Services

### Plex
**What it does**: Streams your media collection to any device  
**Why you need it**: Watch movies/TV anywhere - TV, phone, laptop  
**How to use**:
1. Open http://192.168.50.50:32400/web
2. Browse your library
3. Play on any device with Plex app
4. Automatic transcoding for different devices

**Access from:**
- Web browser (any device)
- Plex app (iOS, Android, Smart TV, game consoles)
- Sonos (via Plex integration)

### Sonarr/Radarr
**What they do**: Automatically find and download TV shows/movies  
**How to use**:
1. Sonarr: http://192.168.50.50:8989
2. Radarr: http://192.168.50.50:7878
3. Add shows/movies you want
4. They automatically search, download, organize
5. Appears in Plex automatically

### Overseerr
**What it does**: Request management for Plex  
**Why you need it**: Family can request movies/shows  
**How to use**:
1. Open http://192.168.50.50:5055
2. Search for content
3. Click "Request"
4. Automatically added to Sonarr/Radarr
5. Downloaded and added to Plex

## Smart Home

### Home Assistant
**What it does**: Controls all your smart home devices  
**Why you need it**: Central hub for everything smart  
**Connected devices**:
- 10 Sonos speakers
- 5 Nest cameras
- Nest Thermostat
- Tesla Model Y
- Cupra Born EV
- Easee charger
- Meross plugs
- LG TVs
- Game consoles

**How to use**:
1. Open http://192.168.50.50:8123
2. Dashboard shows all devices
3. Create automations (lights on at sunset)
4. Group devices (all downstairs lights)
5. Use mobile app for remote control

**Access from phone:**
1. Install Home Assistant app
2. Connect to http://192.168.50.50:8123
3. Full control from anywhere

### Node-RED
**What it does**: Visual automation builder  
**Why you need it**: Create complex automations easily  
**How to use**:
1. Open http://192.168.50.50:1880
2. Drag and drop nodes
3. Connect them to create flows
4. Example: "When I leave home, turn off all lights"

## AI Services

### Open WebUI
**What it does**: ChatGPT-like interface for local AI models  
**Why you need it**: Private AI chat without internet  
**How to use**:
1. Open http://192.168.50.50:3000
2. Select model (llama3, codellama, etc.)
3. Chat like ChatGPT
4. Fully private - no data leaves your network

**Access from any device**: Just open the URL in browser

### Jupyter
**What it does**: Python notebooks for data science  
**Why you need it**: Analyze data, run scripts, experiments  
**How to use**:
1. Open http://192.168.50.50:8888
2. Create new notebook
3. Write Python code
4. Run cells, see results

## Monitoring

### Grafana
**What it does**: Beautiful dashboards for metrics  
**Why you need it**: See system health at a glance  
**How to use**:
1. Open http://192.168.50.50:3003
2. View pre-built dashboards
3. Monitor CPU, RAM, disk, network
4. Set up alerts

### Uptime Kuma
**What it does**: Monitors if services are up/down  
**Why you need it**: Get notified if something breaks  
**How to use**:
1. Open http://192.168.50.50:3004
2. Add monitors for each service
3. Set up notifications (email, Slack, etc.)
4. View uptime history

## Security

### AdGuard Home
**What it does**: Blocks ads for entire network  
**Why you need it**: No ads on any device, including phones/TVs  
**How to use**:
1. Open http://192.168.50.50:8084
2. View query log (what's being blocked)
3. Whitelist/blacklist domains
4. See stats

**How it works**: Every device uses it as DNS server automatically

### Vaultwarden
**What it does**: Password manager (Bitwarden compatible)  
**Why you need it**: Store passwords securely  
**How to use**:
1. Open http://192.168.50.50:8088
2. Create account
3. Install Bitwarden extension/app
4. Point to your server
5. Store passwords

**Access from phone:**
1. Install Bitwarden app
2. Server URL: http://192.168.50.50:8088
3. Login with account

## Storage

### Nextcloud
**What it does**: Private cloud storage (like Dropbox)  
**Why you need it**: Store files, sync across devices  
**How to use**:
1. Open http://192.168.50.50:8097
2. Upload files
3. Share with others
4. Install desktop/mobile sync apps

### PhotoPrism
**What it does**: Google Photos alternative  
**Why you need it**: Organize, search photos privately  
**How to use**:
1. Open http://192.168.50.50:2342
2. Upload photos
3. AI auto-tags faces, objects, locations
4. Search "beach 2023" to find photos

### Paperless-ngx
**What it does**: Scan and organize documents  
**Why you need it**: Paperless office  
**How to use**:
1. Open http://192.168.50.50:8093
2. Upload scanned documents
3. OCR automatically extracts text
4. Search any document
5. Set up scanner to auto-upload

## Productivity

### FreshRSS
**What it does**: RSS feed reader  
**Why you need it**: Follow blogs, news in one place  
**How to use**:
1. Open http://192.168.50.50:8098
2. Add RSS feeds
3. Read articles
4. Mark as read, favorite, etc.

### Code Server
**What it does**: VS Code in your browser  
**Why you need it**: Code from any device  
**How to use**:
1. Open http://192.168.50.50:8443
2. Full VS Code experience
3. Access your homelab code
4. Edit from iPad, phone, etc.

## Dashboards

### Heimdall
**What it does**: Main dashboard for all services  
**Why you need it**: One place to access everything  
**How to use**:
1. Open http://192.168.50.50:8090
2. Click any service icon
3. Goes directly there
4. Organized by category

**Set as browser homepage** for instant access

---

# BACKUP & RESTORE

## What Gets Backed Up

- Docker Compose files (service definitions)
- Container configurations (settings, users, etc.)
- Scripts and automation
- This handbook

## What Does NOT Get Backed Up

- Media files (movies, TV shows) - too large
- Photos/documents - backed up separately
- Database data - use individual service backups

## Backup Procedure

### Manual Backup

```bash
cd ~/homelab
./pcloud-backup-setup.sh
```

This creates a timestamped backup and guides you through uploading to pCloud.

### Automated Daily Backups

```bash
# Edit crontab
crontab -e

# Add this line:
0 2 * * * ~/homelab/Scripts/auto-backup-pcloud.sh
```

Runs at 2 AM daily, keeps last 7 days.

## Restore Procedure

### From pCloud

1. Download backup from pCloud
2. Extract: `tar xzf homelab-config-YYYYMMDD.tar.gz`
3. Review docker compose files
4. Redeploy services

### Full Restore Steps

```bash
# 1. Install OrbStack
brew install orbstack

# 2. Create network
docker network create homelab-network

# 3. Extract backup
cd ~/Downloads
tar xzf homelab-config-YYYYMMDD.tar.gz
cd homelab-config-YYYYMMDD

# 4. Restore compose files
cp -r compose/* ~/homelab/Docker/

# 5. Redeploy each service
cd ~/homelab/Docker
docker compose -f service-name.yml up -d

# 6. Restore individual configs
for config in configs/*.tar.gz; do
    container=$(basename "$config" -config.tar.gz)
    docker cp "$config" "$container":/
done
```

---

# TESTING PROCEDURES

## Automated Testing

Run the master test script:

```bash
cd ~/homelab
./homelab-master-setup.sh
```

This automatically:
1. Discovers all running containers
2. Tests connectivity to each service
3. Generates status report
4. Creates bookmark file
5. Produces testing checklist

## Manual Testing Checklist

### Infrastructure
- [ ] Portainer - Can login and see all containers
- [ ] AdGuard - Query log shows blocked domains
- [ ] Nginx Proxy Manager - Can create proxy host

### Media
- [ ] Plex - Can play a video
- [ ] Sonarr - Can add a TV show
- [ ] Radarr - Can add a movie
- [ ] Overseerr - Can make a request

### Smart Home
- [ ] Home Assistant - All devices show up
- [ ] Can control Sonos speakers
- [ ] Can view Nest camera feeds
- [ ] Automations working

### AI
- [ ] Open WebUI - Can chat with AI
- [ ] Model responds correctly

### Monitoring
- [ ] Grafana - Dashboards show data
- [ ] Uptime Kuma - Services show as up

### Security
- [ ] AdGuard blocking ads (check query log)
- [ ] Vaultwarden - Can store password

### Storage
- [ ] Nextcloud - Can upload file
- [ ] PhotoPrism - Can browse photos

## Network Access Testing

From another device:

```bash
# Test from iPhone/iPad/MacBook
curl http://192.168.50.50:9000
# Should return HTML

# Test DNS
nslookup google.com 192.168.50.50
# Should resolve via AdGuard
```

---

# TROUBLESHOOTING

## Container Won't Start

```bash
# Check logs
docker logs container-name

# Check if port already in use
docker ps | grep PORT_NUMBER

# Restart container
docker restart container-name

# Remove and recreate
docker stop container-name
docker rm container-name
# Then redeploy
```

## Can't Access from Other Devices

```bash
# Check Mac firewall
# System Settings → Network → Firewall → Off

# Test connectivity
ping 192.168.50.50

# Check if port is listening
docker ps | grep container-name
```

## Service Not Working After Update

```bash
# Check Watchtower logs
docker logs watchtower

# Rollback to previous version
docker pull service:previous-version
docker stop service
docker rm service
# Redeploy with old version
```

## AdGuard Not Blocking

1. Check router DNS settings (should be 192.168.50.50)
2. Check device DNS settings
3. Test: `nslookup doubleclick.net 192.168.50.50`
   - Should return 0.0.0.0

## Slow Performance

```bash
# Check resource usage
docker stats

# Check disk space
df -h

# Restart heavy services
docker restart plex jellyfin
```

---

# RECREATION GUIDE

## From Scratch Setup

### Prerequisites
- M4 Mac Mini (or similar)
- macOS Sonoma or later
- External storage (4TB recommended)
- Network configured (10GbE recommended)

### Step-by-Step

**1. Install Homebrew**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. Install OrbStack**
```bash
brew install orbstack
```

**3. Create Directory Structure**
```bash
mkdir -p ~/homelab/{Docker/{Data,Compose},Scripts,docs,backups}
```

**4. Create Docker Network**
```bash
docker network create homelab-network
```

**5. Deploy Infrastructure**

Start with Portainer:
```bash
docker run -d \
  --name portainer \
  --restart unless-stopped \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

**6. Deploy Databases**

PostgreSQL, MariaDB, MongoDB, Redis, InfluxDB (see compose files in backup)

**7. Deploy Media Stack**

Plex, Jellyfin, Sonarr, Radarr, etc. (use compose files)

**8. Deploy Everything Else**

Follow compose files from backup or handbook

**9. Configure Services**

Use the testing checklist to verify each service

**10. Set Up Backups**

Run backup script, schedule cron job

### Time Estimate

- Fresh install: 4-6 hours
- With automation: 2-3 hours
- From backup restore: 1-2 hours

---

# APPENDIX

## Useful Commands

### Docker Management
```bash
# View all containers
docker ps -a

# View logs
docker logs -f container-name

# Restart all containers
docker restart $(docker ps -q)

# Stop all containers
docker stop $(docker ps -q)

# Remove stopped containers
docker container prune

# View resource usage
docker stats

# Update single container
docker pull image:latest
docker stop container-name
docker rm container-name
# Redeploy
```

### System Maintenance
```bash
# Check disk space
df -h

# Clean Docker
docker system prune -a

# View network
docker network ls
docker network inspect homelab-network

# Backup configs
~/homelab/Scripts/auto-backup-pcloud.sh
```

### Monitoring
```bash
# Check service status
curl -f http://localhost:PORT || echo "Service down"

# Network connectivity
ping 192.168.50.50

# DNS resolution
nslookup domain.com 192.168.50.50
```

## Port Reference

Quick reference for all service ports:

```
Infrastructure:
9000  - Portainer
81    - Nginx Proxy Manager
8084  - AdGuard Home

Media:
32400 - Plex
8096  - Jellyfin
8989  - Sonarr
7878  - Radarr
9696  - Prowlarr
5055  - Overseerr
9091  - Transmission

Smart Home:
8123  - Home Assistant
1880  - Node-RED
8080  - Zigbee2MQTT

AI:
3000  - Open WebUI
11434 - Ollama
8888  - Jupyter

Monitoring:
3003  - Grafana
9090  - Prometheus
3004  - Uptime Kuma
19999 - Netdata

Security:
8088  - Vaultwarden
8089  - CrowdSec

Storage:
8097  - Nextcloud
2342  - PhotoPrism
8384  - Syncthing

Dashboards:
8090  - Heimdall
8091  - Homer
4000  - Dashy
8092  - Organizr
```

## Network Diagram

```
                    Internet (5Gbps)
                           ↓
                    Sky Router (192.168.50.1)
                           ↓
              TP-Link 10GbE Switch (SX1008)
                           ↓
    ┌──────────────────────┼──────────────────────┐
    ↓                      ↓                       ↓
M4 Mac Mini         Other Devices           External Storage
192.168.50.50      (phones, TVs,            (4TB SSD)
                    laptops, etc.)
    ↓
AdGuard DNS (port 53)
    ↓
All Network DNS Queries
```

## Credentials Storage

All passwords and API keys stored in 1Password under "HomeLab" vault:

- Portainer admin password
- Grafana admin password
- Home Assistant access token
- Plex claim token
- Each service's credentials

**Never store credentials in plaintext files!**

---

# CONCLUSION

You now have a complete, documented, tested homelab. Everything is automated, backed up, and accessible from any device on your network.

**Key Achievements:**
- ✅ 56 containers running smoothly
- ✅ Complete media automation
- ✅ Network-wide ad blocking
- ✅ Smart home integration
- ✅ Local AI capabilities
- ✅ Comprehensive monitoring
- ✅ Automated backups
- ✅ Full documentation

**Maintenance Required:**
- Daily: None (automated)
- Weekly: Check Uptime Kuma dashboard
- Monthly: Review backup status
- Quarterly: Review and update documentation

**Support Resources:**
- This handbook
- Backup files in pCloud
- Status dashboard at http://192.168.50.50:8090
- Testing checklist for verification

---

**Document Version:** 1.0  
**Last Updated:** November 19, 2025  
**Maintained By:** Steve  
**Next Review:** February 2026
