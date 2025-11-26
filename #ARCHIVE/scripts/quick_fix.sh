#!/bin/bash

################################################################################
# Fix Common Issues - Safe Version (Only fixes existing services)
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

HOMELAB_DIR="$HOME/HomeLab"

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_fix() { echo -e "${YELLOW}[FIX]${NC} $1"; }
log_skip() { echo -e "${BLUE}[SKIP]${NC} $1"; }

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Fixing Issues"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Check if container exists and is running
container_exists() {
    docker ps -a --format '{{.Names}}' | grep -q "^${1}$"
}

container_running() {
    docker ps --format '{{.Names}}' | grep -q "^${1}$"
}

fix_container() {
    local name=$1
    if container_exists "$name"; then
        if container_running "$name"; then
            log_fix "Restarting $name..."
            docker restart "$name"
            sleep 3
        else
            log_fix "Starting $name..."
            docker start "$name"
            sleep 2
        fi
    else
        log_skip "$name not installed"
    fi
}

################################################################################
# Fix Portainer (timeout issue)
################################################################################

log_fix "Fixing Portainer timeout..."
docker restart portainer
sleep 5
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT: Open Portainer NOW (within 5 minutes)${NC}"
echo "   http://localhost:9000"
echo ""

################################################################################
# Fix other services
################################################################################

fix_container "duplicati"
fix_container "adguard"
fix_container "openwebui"

################################################################################
# Create Quick Reference Guide
################################################################################

log_info "Creating quick reference guide..."

cat > "$HOMELAB_DIR/docs/QUICK_START.md" << 'EOF'
# 🚀 Quick Start - Your Services

## ⚡ Do These NOW (Essential)

### 1. Portainer - Docker Management
**URL:** http://localhost:9000  
**Action:** Create admin account (do within 5 minutes of restart!)  
**Why:** Manage all containers - essential for troubleshooting

### 2. Vaultwarden - Password Manager
**URL:** http://localhost:8088  
**Action:** Create account - MASTER PASSWORD IS CRITICAL!  
**Why:** Store all your other passwords here safely

### 3. Heimdall - Dashboard
**URL:** http://localhost:8090  
**Action:** Click settings gear → Add all your services  
**Why:** Your homepage - links to everything

---

## 📋 Services That Need First-Time Setup

### Account Creation Required

| Service | URL | What to Do |
|---------|-----|------------|
| **OpenWebUI** | http://localhost:3000 | Sign up (local account) |
| **Home Assistant** | http://localhost:8123 | Create account, add devices |
| **Uptime Kuma** | http://localhost:3004 | Create admin, add monitors |
| **Plex** | http://localhost:32400/web | Sign in with Plex account |
| **Jellyfin** | http://localhost:8096 | Create admin account |
| **Gitea** | http://localhost:3001 | Initial setup wizard |

### Has Default Password (Check credentials file)

| Service | URL | Default Login |
|---------|-----|---------------|
| **Grafana** | http://localhost:3003 | admin / (see credentials) |
| **Nextcloud** | http://localhost:8097 | admin / (see credentials) |
| **PhotoPrism** | http://localhost:2342 | admin / (see credentials) |
| **Code Server** | http://localhost:8443 | Password: changeme |
| **File Browser** | http://localhost:8087 | admin / admin |

### Works Immediately (No Setup)

| Service | URL | What It Does |
|---------|-----|--------------|
| **Netdata** | http://localhost:19999 | Real-time system monitoring |
| **Prometheus** | http://localhost:9090 | Metrics database |
| **Transmission** | http://localhost:9091 | Download client |
| **Syncthing** | http://localhost:8384 | File sync |
| **Duplicati** | http://localhost:8200 | Backup tool |
| **Node-RED** | http://localhost:1880 | Automation flows |

---

## 🎯 Configuration Order

### Phase 1: Essential (30 minutes)
1. ✅ Portainer → Create account
2. ✅ Vaultwarden → Create account, save master password
3. ✅ Get passwords: `cat ~/HomeLab/docs/FINAL_CREDENTIALS.txt`
4. ✅ Add passwords to Vaultwarden
5. ✅ Heimdall → Add all services as tiles

### Phase 2: Choose Your Path

#### 🎬 Media Setup (2 hours)
1. **Prowlarr** (http://localhost:9696)
   - Add indexers first
   - Copy API key

2. **Radarr** (http://localhost:7878)
   - Connect to Prowlarr
   - Connect to Transmission
   - Connect to Plex

3. **Sonarr** (http://localhost:8989)
   - Same setup as Radarr

4. **Plex** (http://localhost:32400/web)
   - Add movie/TV libraries
   - Point to media folders

5. **Overseerr** (http://localhost:5055)
   - Connect to Plex
   - Connect to Radarr/Sonarr
   - Family can request content

#### 🏠 Smart Home Setup (2-3 hours)
1. **Home Assistant** (http://localhost:8123)
   - Add your 10 Sonos speakers
   - Add your 5 Nest cameras
   - Add Tesla Model Y
   - Add Cupra Born
   - Add Easee charger
   - Create automations

2. **Node-RED** (http://localhost:1880)
   - For complex automations
   - Connect to Home Assistant

#### 🤖 AI Setup (30 minutes)
1. **OpenWebUI** (http://localhost:3000)
   - Create account
   - Download models:
     ```
     Settings → Models → Pull:
     - llama3.2 (fast)
     - mistral (smart)
     - codellama (coding)
     ```
   - Start chatting!

#### 📊 Monitoring Setup (1 hour)
1. **Grafana** (http://localhost:3003)
   - Add Prometheus data source
   - Import dashboard 1860 (Node Exporter)
   - Import dashboard 193 (Docker)

2. **Uptime Kuma** (http://localhost:3004)
   - Add all your services
   - Get alerts when things go down

---

## 🔧 Common Tasks

**Get all passwords:**
```bash
cat ~/HomeLab/docs/FINAL_CREDENTIALS.txt
```

**Restart a service:**
```bash
docker restart <service-name>
```

**View logs:**
```bash
docker logs <service-name>
```

**See what's running:**
```bash
docker ps
```

---

## 🆘 Troubleshooting

**Portainer timeout:**
```bash
docker restart portainer
# Then IMMEDIATELY open http://localhost:9000
```

**Service won't load:**
1. Check if running: `docker ps | grep <service>`
2. Check logs: `docker logs <service>`
3. Restart: `docker restart <service>`

**OpenWebUI signup error:**
```bash
docker restart openwebui
# Wait 10 seconds, try signup again
```

**Duplicati won't load:**
```bash
docker restart duplicati
# Wait 30 seconds (slow to start)
```

---

## 📱 Access from Phone (Tailscale)

Your Mac IP: `tailscale ip -4`

Access format: `http://YOUR_IP:PORT`

Examples:
- Heimdall: http://100.96.129.29:8090
- Home Assistant: http://100.96.129.29:8123
- OpenWebUI: http://100.96.129.29:3000

---

## ✅ First Day Checklist

- [ ] Portainer: Create admin account
- [ ] Vaultwarden: Create account (SAVE MASTER PASSWORD!)
- [ ] Get passwords from credentials file
- [ ] Add all passwords to Vaultwarden
- [ ] Heimdall: Add all service tiles
- [ ] Set Heimdall as browser homepage
- [ ] Choose one category to configure (Media/Smart Home/AI)
- [ ] Test accessing services via Tailscale on phone

---

**Need detailed walkthroughs?**
Check: `~/HomeLab/docs/walkthroughs/`

**Your homelab is ready to configure! 🎉**

EOF

cat > "$HOMELAB_DIR/docs/ALL_SERVICE_URLS.txt" << 'EOF'
═══════════════════════════════════════════════════════════════
  ALL SERVICE URLs - Quick Reference
═══════════════════════════════════════════════════════════════

CORE
----
Portainer:              http://localhost:9000

DASHBOARDS
----------
Heimdall:               http://localhost:8090
Homer:                  http://localhost:8091
Dashy:                  http://localhost:4000
Organizr:               http://localhost:8092

MEDIA
-----
Plex:                   http://localhost:32400/web
Jellyfin:               http://localhost:8096
Radarr:                 http://localhost:7878
Sonarr:                 http://localhost:8989
Prowlarr:               http://localhost:9696
Overseerr:              http://localhost:5055
Transmission:           http://localhost:9091

AI & DEVELOPMENT
----------------
OpenWebUI:              http://localhost:3000
Ollama API:             http://localhost:11434
Code Server:            http://localhost:8443
Jupyter:                http://localhost:8888
Gitea:                  http://localhost:3001

SMART HOME
----------
Home Assistant:         http://localhost:8123
Node-RED:               http://localhost:1880
Zigbee2MQTT:            http://localhost:8080
ESPHome:                http://localhost:6052

MONITORING
----------
Grafana:                http://localhost:3003
Prometheus:             http://localhost:9090
Uptime Kuma:            http://localhost:3004
Netdata:                http://localhost:19999
cAdvisor:               http://localhost:8085

STORAGE & BACKUP
----------------
Nextcloud:              http://localhost:8097
Syncthing:              http://localhost:8384
Duplicati:              http://localhost:8200
File Browser:           http://localhost:8087

SECURITY
--------
Vaultwarden:            http://localhost:8088
CrowdSec:               http://localhost:8089

UTILITIES
---------
Paperless-ngx:          http://localhost:8093
PhotoPrism:             http://localhost:2342
Calibre:                http://localhost:8094
FreshRSS:               http://localhost:8098

═══════════════════════════════════════════════════════════════
EOF

log_info "✓ Quick start guide created: ~/HomeLab/docs/QUICK_START.md"
log_info "✓ URL reference created: ~/HomeLab/docs/ALL_SERVICE_URLS.txt"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}✓ Fixes Complete${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "View your guides:"
echo "  open ~/HomeLab/docs/QUICK_START.md"
echo "  cat ~/HomeLab/docs/ALL_SERVICE_URLS.txt"
echo ""
echo -e "${YELLOW}⚡ DO NOW:${NC}"
echo "  1. Portainer: http://localhost:9000 (create account)"
echo "  2. Vaultwarden: http://localhost:8088 (create account)"
echo "  3. Heimdall: http://localhost:8090 (add services)"
echo ""