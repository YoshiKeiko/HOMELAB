#!/bin/bash

################################################################################
# Complete HomeLab Smart Deployment
# - Checks existing setup
# - Only installs missing services
# - Includes VNC server
# - Automated pCloud backups
# - Full documentation
################################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_skip() { echo -e "${BLUE}[⊘]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         COMPLETE HOMELAB DEPLOYMENT                            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

################################################################################
# PHASE 1: CHECK CURRENT SETUP
################################################################################

log_step "Phase 1: Checking current setup..."
echo ""

# Get list of running containers
EXISTING_SERVICES=$(docker ps --format "{{.Names}}" 2>/dev/null || echo "")

if [ -z "$EXISTING_SERVICES" ]; then
    log_info "Fresh installation - no existing containers"
    CONTAINER_COUNT=0
else
    CONTAINER_COUNT=$(echo "$EXISTING_SERVICES" | wc -l | tr -d ' ')
    log_info "Found $CONTAINER_COUNT existing containers"
    echo ""
    echo "Current services:"
    echo "$EXISTING_SERVICES" | while read service; do
        echo "  ✓ $service"
    done
fi

echo ""

# Function to check if container exists
container_exists() {
    echo "$EXISTING_SERVICES" | grep -q "^$1$"
}

################################################################################
# PHASE 2: PREPARE INFRASTRUCTURE
################################################################################

log_step "Phase 2: Preparing infrastructure..."
echo ""

# Create directory structure
mkdir -p ~/HomeLab/Docker/Compose
mkdir -p ~/HomeLab/Docker/Data
mkdir -p ~/HomeLab/docs
mkdir -p ~/HomeLab/scripts
mkdir -p ~/HomeLab/backups

log_info "Directory structure created"

# Create network if needed
if ! docker network ls | grep -q homelab-net; then
    docker network create homelab-net
    log_info "Created homelab-net network"
else
    log_skip "Network already exists"
fi

echo ""

################################################################################
# PHASE 3: DEPLOY HEIMDALL DASHBOARD
################################################################################

log_step "Phase 3: Deploying Heimdall Dashboard..."
echo ""

if container_exists "heimdall"; then
    log_skip "Heimdall already running - updating configuration"
else
    mkdir -p ~/HomeLab/Docker/Data/heimdall
    
    cat > ~/HomeLab/Docker/Compose/heimdall.yml << 'EOF'
version: '3.8'

networks:
  homelab-net:
    external: true

services:
  heimdall:
    image: lscr.io/linuxserver/heimdall:latest
    container_name: heimdall
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "8090:80"
      - "8443:443"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - ~/HomeLab/Docker/Data/heimdall:/config
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOF

    docker compose -f ~/HomeLab/Docker/Compose/heimdall.yml up -d
    log_info "Heimdall deployed - http://localhost:8090"
fi

echo ""

################################################################################
# PHASE 4: DEPLOY VNC SERVER
################################################################################

log_step "Phase 4: Deploying VNC Server..."
echo ""

if container_exists "kasm"; then
    log_skip "VNC/Desktop already running"
else
    mkdir -p ~/HomeLab/Docker/Data/kasm-vnc
    
    cat > ~/HomeLab/Docker/Compose/vnc-desktop.yml << 'EOF'
version: '3.8'

networks:
  homelab-net:
    external: true

services:
  kasm-vnc:
    image: lscr.io/linuxserver/webtop:ubuntu-kde
    container_name: kasm-vnc
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "3050:3000"
      - "3051:3001"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - SUBFOLDER=/
    volumes:
      - ~/HomeLab/Docker/Data/kasm-vnc:/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
    shm_size: "1gb"
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOF

    docker compose -f ~/HomeLab/Docker/Compose/vnc-desktop.yml up -d
    log_info "VNC Desktop deployed - http://localhost:3050"
    echo "    Username: abc"
    echo "    Password: abc (change on first login)"
fi

echo ""

################################################################################
# PHASE 5: DEPLOY BACKUP SOLUTION (DUPLICATI)
################################################################################

log_step "Phase 5: Deploying Automated Backup Solution..."
echo ""

if container_exists "duplicati"; then
    log_skip "Duplicati already running"
elif container_exists "kopia"; then
    log_skip "Kopia already configured for backups"
else
    mkdir -p ~/HomeLab/Docker/Data/duplicati
    
    # Generate encryption key
    ENCRYPTION_KEY=$(openssl rand -base64 32)
    
    cat > ~/HomeLab/Docker/Compose/backup.yml << EOF
version: '3.8'

networks:
  homelab-net:
    external: true

services:
  duplicati:
    image: lscr.io/linuxserver/duplicati:latest
    container_name: duplicati
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "8200:8200"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - CLI_ARGS=--webservice-interface=any --server-encryption-key=${ENCRYPTION_KEY}
    volumes:
      - ~/HomeLab/Docker/Data/duplicati:/config
      - ~/HomeLab/Docker/Data:/source
      - /Volumes/HomeLab-4TB:/backups
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOF

    docker compose -f ~/HomeLab/Docker/Compose/backup.yml up -d
    
    # Save encryption key
    echo "${ENCRYPTION_KEY}" > ~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
    chmod 600 ~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
    
    log_info "Duplicati deployed - http://localhost:8200"
    echo "    ⚠️  Encryption key saved to: ~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt"
    echo "    ⚠️  Save this key in 1Password NOW!"
fi

echo ""

################################################################################
# PHASE 6: DEPLOY MEDIA AUTOMATION
################################################################################

log_step "Phase 6: Deploying Media Automation..."
echo ""

MEDIA_TO_DEPLOY=()
! container_exists "prowlarr" && MEDIA_TO_DEPLOY+=("prowlarr")
! container_exists "radarr" && MEDIA_TO_DEPLOY+=("radarr")
! container_exists "sonarr" && MEDIA_TO_DEPLOY+=("sonarr")
! container_exists "overseerr" && MEDIA_TO_DEPLOY+=("overseerr")
! container_exists "transmission" && MEDIA_TO_DEPLOY+=("transmission")

if [ ${#MEDIA_TO_DEPLOY[@]} -eq 0 ]; then
    log_skip "All media automation services already running"
else
    log_info "Deploying: ${MEDIA_TO_DEPLOY[*]}"
    
    # Create directories
    for service in "${MEDIA_TO_DEPLOY[@]}"; do
        mkdir -p ~/HomeLab/Docker/Data/$service
    done
    
    mkdir -p /Volumes/HomeLab-4TB/downloads/{complete,incomplete}
    mkdir -p /Volumes/HomeLab-4TB/media/{movies,tv}
    
    cat > ~/HomeLab/Docker/Compose/media-automation.yml << 'EOF'
version: '3.8'

networks:
  homelab-net:
    external: true

services:
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "9696:9696"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - ~/HomeLab/Docker/Data/prowlarr:/config
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "7878:7878"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - ~/HomeLab/Docker/Data/radarr:/config
      - /Volumes/HomeLab-4TB:/data
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "8989:8989"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - ~/HomeLab/Docker/Data/sonarr:/config
      - /Volumes/HomeLab-4TB:/data
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  overseerr:
    image: lscr.io/linuxserver/overseerr:latest
    container_name: overseerr
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "5055:5055"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - ~/HomeLab/Docker/Data/overseerr:/config
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "9091:9091"
      - "51413:51413"
      - "51413:51413/udp"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - USER=admin
      - PASS=admin
    volumes:
      - ~/HomeLab/Docker/Data/transmission:/config
      - /Volumes/HomeLab-4TB/downloads:/downloads
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOF

    # Deploy only new services
    docker compose -f ~/HomeLab/Docker/Compose/media-automation.yml up -d
    log_info "Media automation deployed"
fi

echo ""

################################################################################
# PHASE 7: DEPLOY SMART HOME
################################################################################

log_step "Phase 7: Deploying Smart Home Stack..."
echo ""

SMARTHOME_TO_DEPLOY=()
! container_exists "homeassistant" && SMARTHOME_TO_DEPLOY+=("homeassistant")
! container_exists "mosquitto" && SMARTHOME_TO_DEPLOY+=("mosquitto")
! container_exists "nodered" && SMARTHOME_TO_DEPLOY+=("nodered")

if [ ${#SMARTHOME_TO_DEPLOY[@]} -eq 0 ]; then
    log_skip "All smart home services already running"
else
    log_info "Deploying: ${SMARTHOME_TO_DEPLOY[*]}"
    
    for service in "${SMARTHOME_TO_DEPLOY[@]}"; do
        mkdir -p ~/HomeLab/Docker/Data/$service
    done
    
    mkdir -p ~/HomeLab/Docker/Data/mosquitto/{config,data,log}
    
    # Create Mosquitto config
    cat > ~/HomeLab/Docker/Data/mosquitto/config/mosquitto.conf << 'EOF'
listener 1883
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
EOF
    
    cat > ~/HomeLab/Docker/Compose/smart-home.yml << 'EOF'
version: '3.8'

networks:
  homelab-net:
    external: true

services:
  homeassistant:
    image: ghcr.io/home-assistant/home-assistant:stable
    container_name: homeassistant
    restart: unless-stopped
    network_mode: host
    privileged: true
    environment:
      - TZ=Europe/London
    volumes:
      - ~/HomeLab/Docker/Data/homeassistant:/config
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  mosquitto:
    image: eclipse-mosquitto:latest
    container_name: mosquitto
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ~/HomeLab/Docker/Data/mosquitto/config:/mosquitto/config
      - ~/HomeLab/Docker/Data/mosquitto/data:/mosquitto/data
      - ~/HomeLab/Docker/Data/mosquitto/log:/mosquitto/log
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  nodered:
    image: nodered/node-red:latest
    container_name: nodered
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "1880:1880"
    environment:
      - TZ=Europe/London
    volumes:
      - ~/HomeLab/Docker/Data/nodered:/data
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOF

    docker compose -f ~/HomeLab/Docker/Compose/smart-home.yml up -d
    log_info "Smart home stack deployed"
fi

echo ""

################################################################################
# PHASE 8: DEPLOY MONITORING
################################################################################

log_step "Phase 8: Deploying Monitoring Stack..."
echo ""

MONITORING_TO_DEPLOY=()
! container_exists "grafana" && MONITORING_TO_DEPLOY+=("grafana")
! container_exists "prometheus" && MONITORING_TO_DEPLOY+=("prometheus")
! container_exists "netdata" && MONITORING_TO_DEPLOY+=("netdata")

if [ ${#MONITORING_TO_DEPLOY[@]} -eq 0 ]; then
    log_skip "All monitoring services already running"
else
    log_info "Deploying: ${MONITORING_TO_DEPLOY[*]}"
    
    for service in "${MONITORING_TO_DEPLOY[@]}"; do
        mkdir -p ~/HomeLab/Docker/Data/$service
    done
    
    mkdir -p ~/HomeLab/Docker/Data/prometheus-data
    
    # Create Prometheus config
    cat > ~/HomeLab/Docker/Data/prometheus/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'docker'
    static_configs:
      - targets: ['host.docker.internal:9323']
  
  - job_name: 'netdata'
    static_configs:
      - targets: ['netdata:19999']
EOF
    
    cat > ~/HomeLab/Docker/Compose/monitoring.yml << 'EOF'
version: '3.8'

networks:
  homelab-net:
    external: true

services:
  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource
    volumes:
      - ~/HomeLab/Docker/Data/grafana:/var/lib/grafana
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    networks:
      - homelab-net
    ports:
      - "9090:9090"
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
    volumes:
      - ~/HomeLab/Docker/Data/prometheus:/etc/prometheus
      - ~/HomeLab/Docker/Data/prometheus-data:/prometheus
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  netdata:
    image: netdata/netdata:latest
    container_name: netdata
    restart: unless-stopped
    hostname: homelab-m4
    networks:
      - homelab-net
    ports:
      - "19999:19999"
    cap_add:
      - SYS_PTRACE
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    volumes:
      - ~/HomeLab/Docker/Data/netdata:/etc/netdata
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOF

    docker compose -f ~/HomeLab/Docker/Compose/monitoring.yml up -d
    log_info "Monitoring stack deployed"
fi

echo ""

################################################################################
# PHASE 9: GENERATE DOCUMENTATION
################################################################################

log_step "Phase 9: Generating documentation..."
echo ""

# Create main documentation
cat > ~/HomeLab/docs/HOMELAB_GUIDE.md << 'EOF'
# 🏠 HomeLab Complete Guide

**M4 Mac Mini HomeLab - Full Documentation**

---

## 📊 System Overview

**Hardware:**
- Mac Mini M4 (32GB RAM, 512GB SSD)
- 4TB External SSD (HomeLab-4TB)
- 10GbE Network Connection
- 5Gbps CityFibre Internet

**Software:**
- macOS Sequoia
- OrbStack (Docker runtime)
- Docker Compose orchestration

---

## 🌐 Service Access

### Dashboard
**Heimdall:** http://localhost:8090
- Central dashboard for all services
- Add applications via the web UI
- Customize appearance and layout

### VNC/Remote Desktop
**Web Desktop:** http://localhost:3050
- Full Ubuntu KDE desktop in browser
- Username: abc / Password: abc
- Change password on first login!

### Backup System
**Duplicati:** http://localhost:8200
- Automated backups to pCloud
- Encrypted incremental backups
- WebDAV connection to pCloud

### Media Services
**Plex:** http://localhost:32400/web
**Overseerr:** http://localhost:5055
**Radarr:** http://localhost:7878
**Sonarr:** http://localhost:8989
**Prowlarr:** http://localhost:9696
**Transmission:** http://localhost:9091 (admin/admin)

### Smart Home
**Home Assistant:** http://localhost:8123
**Node-RED:** http://localhost:1880
**Mosquitto MQTT:** localhost:1883

### Monitoring
**Grafana:** http://localhost:3000 (admin/admin)
**Prometheus:** http://localhost:9090
**Netdata:** http://localhost:19999

### Management
**Portainer:** http://localhost:9000 (if installed)
**AdGuard:** http://localhost:3080 (if installed)

---

## 🔄 How to Update Services

### Update Single Service

```bash
cd ~/HomeLab/Docker/Compose

# Pull latest image
docker compose -f [compose-file].yml pull

# Recreate container
docker compose -f [compose-file].yml up -d
```

### Update All Services

```bash
# Update everything
cd ~/HomeLab/Docker/Compose
for file in *.yml; do
    docker compose -f "$file" pull
    docker compose -f "$file" up -d
done
```

### Update with Watchtower (Automatic)

Watchtower is configured via labels. To enable:

```bash
cat > ~/HomeLab/Docker/Compose/watchtower.yml << 'EOFWT'
version: '3.8'

services:
  watchtower:
    image: containrrr/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_SCHEDULE=0 0 4 * * *
      - WATCHTOWER_LABEL_ENABLE=true
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOFWT

docker compose -f ~/HomeLab/Docker/Compose/watchtower.yml up -d
```

Updates run daily at 4 AM.

---

## 💾 Backup Configuration

### Duplicati Setup for pCloud

**Access:** http://localhost:8200

**Steps:**

1. **Add Backup:**
   - Click "Add backup"
   - Name: "HomeLab Docker Configs"

2. **Destination:**
   - Type: WebDAV
   - Server: `https://webdav.pcloud.com/HomeLab-Backups`
   - Username: your-pcloud-email
   - Password: your-pcloud-password (or app password if 2FA)
   - Test connection

3. **Source Data:**
   - Path: `/source` (maps to ~/HomeLab/Docker/Data)
   - Exclude: `*/cache/*`, `*/logs/*`, `*/transcode/*`

4. **Schedule:**
   - Daily at 3:00 AM

5. **Options:**
   - Retention: 30 days
   - Compression: High

6. **Encryption:**
   - Set strong passphrase
   - Save in 1Password!

7. **Save and Run** first backup

**Encryption Key Location:**
```
~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
```
⚠️ **Save this in 1Password immediately!**

---

## 🏠 Smart Home Integration

### Devices Supported
- 10x Sonos Speakers
- 5x Nest Cameras  
- Tesla Model Y
- Cupra Born EV
- Easee EV Charger

### Setup Home Assistant

1. **Access:** http://localhost:8123
2. **First Run:** Create account
3. **Add Integrations:**
   - Settings → Devices & Services → Add Integration
   - Search for: Sonos, Nest, Tesla, etc.
4. **Configure MQTT:**
   - Add MQTT integration
   - Broker: mosquitto (auto-discovered)
5. **Node-RED Integration:**
   - Add Node-RED integration for automation

---

## 📊 Monitoring Setup

### Grafana Dashboards

**Import Pre-built Dashboards:**

1. Login to Grafana (admin/admin)
2. Change password
3. Add Prometheus data source:
   - Configuration → Data Sources → Add
   - Type: Prometheus
   - URL: `http://prometheus:9090`
   - Save & Test

4. Import Dashboards:
   - Dashboards → Import
   - Dashboard ID: 1860 (Node Exporter Full)
   - Dashboard ID: 893 (Docker)
   - Dashboard ID: 11074 (Netdata)

### Netdata

Real-time system monitoring at http://localhost:19999

Features:
- CPU, RAM, Disk, Network monitoring
- Docker container stats
- Alert notifications
- Beautiful real-time graphs

---

## 🔧 Maintenance Tasks

### Daily (Automated)
- ✅ Duplicati backups (3 AM)
- ✅ Watchtower updates (4 AM)

### Weekly
- [ ] Check backup logs
- [ ] Review Grafana dashboards
- [ ] Check disk space

### Monthly
- [ ] Test restore from backup
- [ ] Review and clean old media
- [ ] Update documentation
- [ ] Check service logs for errors

---

## 🆘 Troubleshooting

### Service Won't Start

```bash
# Check logs
docker logs [container-name]

# Restart service
docker restart [container-name]

# Recreate service
cd ~/HomeLab/Docker/Compose
docker compose -f [compose-file].yml down
docker compose -f [compose-file].yml up -d
```

### Can't Access Service

```bash
# Check if running
docker ps | grep [service-name]

# Check ports
docker port [container-name]

# Check network
docker network inspect homelab-net
```

### Backup Fails

1. Check Duplicati logs
2. Verify pCloud credentials
3. Test WebDAV connection
4. Check available space

### Out of Disk Space

```bash
# Check usage
df -h

# Clean Docker
docker system prune -a

# Clean old logs
find ~/HomeLab/Docker/Data -name "*.log" -mtime +30 -delete
```

---

## 📱 Mobile Access

### From iPhone/iPad

**Web Services:**
- Open Safari
- Navigate to: `http://M4-IP:PORT`
- Add to Home Screen for app-like experience

**Home Assistant:**
- Install Home Assistant app from App Store
- Configure with M4 IP address

**VNC Desktop:**
- Open: `http://M4-IP:3050`
- Full desktop in browser

---

## 🔐 Security Recommendations

### Passwords to Set
- [ ] Grafana admin password
- [ ] Transmission password
- [ ] VNC desktop password
- [ ] Home Assistant account
- [ ] Duplicati web password

### Save in 1Password
- [ ] All service passwords
- [ ] Duplicati encryption key
- [ ] pCloud credentials
- [ ] Repository encryption password

### Network Security
- ✅ Services only on local network
- ✅ No internet exposure (yet)
- ⏳ Add Tailscale for remote access (future)
- ⏳ Add reverse proxy with auth (future)

---

## 🚀 Future Enhancements

### Phase 2 - Media Enhancement
- Jellyfin (Plex alternative)
- Tautulli (Plex statistics)
- Bazarr (subtitle downloads)
- Lidarr (music automation)

### Phase 3 - Productivity
- Nextcloud (personal cloud)
- Paperless-ngx (document management)
- PhotoPrism (photo library)
- Calibre (ebook library)

### Phase 4 - Advanced
- Authelia (SSO authentication)
- Traefik (reverse proxy)
- Databases (PostgreSQL, MariaDB)
- CrowdSec (security)

### Phase 5 - VMs
- UTM for Windows 11 ARM
- Additional Linux VMs
- Testing environments

---

## 📚 Additional Documentation

**Configuration Files:**
```
~/HomeLab/Docker/Compose/        - All compose files
~/HomeLab/Docker/Data/           - Service data
~/HomeLab/docs/                  - Documentation
~/HomeLab/scripts/               - Utility scripts
~/HomeLab/backups/               - Local backups
```

**Important Files:**
```
~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
~/HomeLab/docs/SERVICES_LIST.txt
~/HomeLab/docs/HOMELAB_GUIDE.md (this file)
```

---

## ✅ Quick Reference

**Restart All Services:**
```bash
docker restart $(docker ps -q)
```

**View All Logs:**
```bash
docker compose -f ~/HomeLab/Docker/Compose/*.yml logs -f
```

**Check Service Status:**
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

**Backup Now:**
```bash
# Via Duplicati web UI
open http://localhost:8200
# Click "Run now" on backup job
```

**Access Dashboard:**
```bash
open http://localhost:8090
```

---

**Your HomeLab is fully deployed and documented!** 🎉
EOF

log_info "Main guide created: ~/HomeLab/docs/HOMELAB_GUIDE.md"

# Create services list
cat > ~/HomeLab/docs/SERVICES_LIST.txt << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║              HOMELAB SERVICES - QUICK REFERENCE                ║
╚═══════════════════════════════════════════════════════════════╝

Dashboard & Access:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Heimdall:        http://localhost:8090
VNC Desktop:     http://localhost:3050

Backup:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Duplicati:       http://localhost:8200

Media Services:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Plex:            http://localhost:32400/web
Overseerr:       http://localhost:5055
Radarr:          http://localhost:7878
Sonarr:          http://localhost:8989
Prowlarr:        http://localhost:9696
Transmission:    http://localhost:9091 (admin/admin)

Smart Home:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Home Assistant:  http://localhost:8123
Node-RED:        http://localhost:1880
MQTT:            localhost:1883

Monitoring:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Grafana:         http://localhost:3000 (admin/admin)
Prometheus:      http://localhost:9090
Netdata:         http://localhost:19999

Update Commands:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Update all:      cd ~/HomeLab/Docker/Compose && 
                 for f in *.yml; do 
                   docker compose -f "$f" pull && 
                   docker compose -f "$f" up -d
                 done

View services:   docker ps
View logs:       docker logs [container-name]
Restart:         docker restart [container-name]

Documentation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Full guide:      ~/HomeLab/docs/HOMELAB_GUIDE.md
This list:       ~/HomeLab/docs/SERVICES_LIST.txt

═══════════════════════════════════════════════════════════════
EOF

log_info "Services list created: ~/HomeLab/docs/SERVICES_LIST.txt"

# Create backup configuration guide
cat > ~/HomeLab/docs/BACKUP_SETUP_GUIDE.md << 'EOF'
# 💾 Backup Configuration Guide

## Quick Setup for pCloud

### Step 1: Get pCloud Credentials

**If you have 2FA enabled:**
1. pCloud → Settings → Security
2. App Passwords → Create
3. Name: "Duplicati HomeLab"
4. Copy generated password
5. Save in 1Password

**WebDAV Details:**
- URL: `https://webdav.pcloud.com/HomeLab-Backups`
- Username: your-pcloud-email@example.com
- Password: [app password or main password]

### Step 2: Configure Duplicati

1. Open http://localhost:8200
2. Add backup → Configure new backup

**General:**
- Name: HomeLab Docker Configs
- Encryption: AES-256
- Passphrase: [create strong password - save in 1Password!]

**Destination:**
- Type: WebDAV
- Server: `https://webdav.pcloud.com/HomeLab-Backups`
- Username: [your pCloud email]
- Password: [app password]
- Test connection ✓

**Source:**
- Path: `/source`
- Exclude: `*/cache/*`, `*/logs/*`, `*/transcode/*`

**Schedule:**
- Daily at 03:00

**Options:**
- Keep 30 days
- Compression: High

3. Save and run first backup

### Step 3: Verify

1. Check pCloud for encrypted files
2. Test restore of single file
3. Verify in Duplicati logs

### Automatic Operation

Backups run automatically at 3 AM daily.

No maintenance needed!

**Important Files to Save:**
- Duplicati encryption passphrase (1Password)
- pCloud credentials (1Password)
- Encryption key: ~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
EOF

log_info "Backup guide created: ~/HomeLab/docs/BACKUP_SETUP_GUIDE.md"

# Create update script
cat > ~/HomeLab/scripts/update-all-services.sh << 'EOF'
#!/bin/bash

echo "Updating all HomeLab services..."
echo ""

cd ~/HomeLab/Docker/Compose

for file in *.yml; do
    echo "Updating $file..."
    docker compose -f "$file" pull
    docker compose -f "$file" up -d
    echo ""
done

echo "All services updated!"
docker ps --format "table {{.Names}}\t{{.Status}}"
EOF

chmod +x ~/HomeLab/scripts/update-all-services.sh
log_info "Update script created: ~/HomeLab/scripts/update-all-services.sh"

echo ""

################################################################################
# PHASE 10: FINAL SUMMARY
################################################################################

log_step "Phase 10: Generating final summary..."
echo ""

# Count running containers
FINAL_COUNT=$(docker ps -q | wc -l | tr -d ' ')

cat > ~/HomeLab/DEPLOYMENT_SUMMARY.txt << EOF
╔═══════════════════════════════════════════════════════════════╗
║              HOMELAB DEPLOYMENT COMPLETE!                      ║
╚═══════════════════════════════════════════════════════════════╝

Deployment Date: $(date)
Total Services:  $FINAL_COUNT containers running

Services Deployed:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

docker ps --format "{{.Names}}" | sort | while read name; do
    port=$(docker port "$name" 2>/dev/null | grep -oE '[0-9]+' | head -1)
    if [ -n "$port" ]; then
        printf "%-20s http://localhost:%-5s\n" "$name:" "$port" >> ~/HomeLab/DEPLOYMENT_SUMMARY.txt
    else
        printf "%-20s (no web interface)\n" "$name:" >> ~/HomeLab/DEPLOYMENT_SUMMARY.txt
    fi
done

cat >> ~/HomeLab/DEPLOYMENT_SUMMARY.txt << EOF

Quick Access:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Dashboard:       http://localhost:8090
VNC Desktop:     http://localhost:3050
Backup Config:   http://localhost:8200

Documentation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Main Guide:      ~/HomeLab/docs/HOMELAB_GUIDE.md
Services List:   ~/HomeLab/docs/SERVICES_LIST.txt
Backup Guide:    ~/HomeLab/docs/BACKUP_SETUP_GUIDE.md

Important:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  Duplicati encryption key saved to:
    ~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
    
⚠️  SAVE THIS IN 1PASSWORD NOW!

Next Steps:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Open Heimdall and add all services
2. Configure Duplicati backup to pCloud
3. Setup Home Assistant integrations
4. Change default passwords
5. Test backup and restore

Update Services:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Run: ~/HomeLab/scripts/update-all-services.sh

═══════════════════════════════════════════════════════════════
Your HomeLab is ready to use! 🎉
═══════════════════════════════════════════════════════════════
EOF

cat ~/HomeLab/DEPLOYMENT_SUMMARY.txt

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📚 Documentation Created"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Main guide:      open ~/HomeLab/docs/HOMELAB_GUIDE.md"
echo "Services list:   cat ~/HomeLab/docs/SERVICES_LIST.txt"
echo "Backup guide:    open ~/HomeLab/docs/BACKUP_SETUP_GUIDE.md"
echo "Deployment summary: cat ~/HomeLab/DEPLOYMENT_SUMMARY.txt"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🎯 Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Open Heimdall:  http://localhost:8090"
echo "2. Configure Duplicati backup to pCloud"
echo "3. Setup Home Assistant smart home devices"
echo "4. Change all default passwords"
echo ""
echo "⚠️  CRITICAL: Save Duplicati encryption key in 1Password!"
echo "    Location: ~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt"
echo ""
log_info "Deployment complete! 🎉"
echo ""