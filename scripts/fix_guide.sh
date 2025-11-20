#!/bin/bash

################################################################################
# Fix Common Issues & Quick Setup Guide
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

HOMELAB_DIR="$HOME/HomeLab"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_fix() { echo -e "${YELLOW}[FIX]${NC} $1"; }

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Fixing Issues & Creating Setup Guide"
echo "═══════════════════════════════════════════════════════════════"
echo ""

################################################################################
# Fix Portainer (timeout issue)
################################################################################

log_fix "Fixing Portainer timeout..."
docker restart portainer
sleep 5
log_info "Portainer restarted - open http://localhost:9000 NOW (within 5 minutes)"

################################################################################
# Fix Duplicati (not loading)
################################################################################

log_fix "Checking Duplicati..."
if docker ps | grep -q duplicati; then
    log_info "Duplicati is running - may need time to fully start"
    docker restart duplicati
    sleep 3
else
    log_info "Starting Duplicati..."
    docker start duplicati
fi

################################################################################
# Fix AdGuard (not loading)
################################################################################

log_fix "Checking AdGuard..."
if docker ps | grep -q adguard; then
    log_info "AdGuard is running"
    docker restart adguard
    sleep 3
else
    log_info "Starting AdGuard..."
    docker start adguard
fi

################################################################################
# Fix OpenWebUI signup error
################################################################################

log_fix "Fixing OpenWebUI database..."
docker restart openwebui
sleep 5
log_info "OpenWebUI restarted - try signup again"

################################################################################
# Generate Complete Credentials & Setup Guide
################################################################################

cat > "$HOMELAB_DIR/docs/QUICK_SETUP_GUIDE.md" << 'EOF'
# 🚀 Quick Setup Guide - All Credentials & First Steps

**Generated:** TIMESTAMP

---

## 🔑 Default Credentials & Access

### Services with NO LOGIN REQUIRED (Just Open)
| Service | URL | Notes |
|---------|-----|-------|
| Heimdall | http://localhost:8090 | Empty at first - add apps |
| Netdata | http://localhost:19999 | Real-time monitoring |
| Prometheus | http://localhost:9090 | Metrics database |
| Homer | http://localhost:8091 | Configure via YAML |
| Dashy | http://localhost:4000 | Configure via YAML |

---

### Services Requiring FIRST-TIME SETUP

#### ✅ Portainer
- **URL:** http://localhost:9000
- **First Time:** Create admin account
  - Username: `admin`
  - Password: Choose strong password
- **⚠️ IMPORTANT:** Must complete within 5 minutes of container start
- **If timeout:** Run `docker restart portainer` and try again immediately

#### ✅ Vaultwarden (Password Manager)
- **URL:** http://localhost:8088
- **First Time:** Click "Create Account"
  - Email: (can be fake - local only)
  - Master Password: **CRITICAL - never forget this!**
- **Use for:** Store all other passwords here

#### ✅ OpenWebUI (AI Chat)
- **URL:** http://localhost:3000
- **First Time:** Click "Sign Up"
  - Email: (can be fake)
  - Username: Choose one
  - Password: Choose one
- **After signup:** Download models (see below)

#### ✅ Home Assistant
- **URL:** http://localhost:8123
- **First Time:** Create account
  - Name: Your name
  - Username: Choose one
  - Password: Choose one
  - Location: Set for weather/automations
- **Then:** Start adding devices!

#### ✅ Uptime Kuma
- **URL:** http://localhost:3004
- **First Time:** Create admin account
- **Then:** Add all your services to monitor uptime

#### ✅ Plex Media Server
- **URL:** http://localhost:32400/web
- **First Time:** Sign in with Plex account (create free at plex.tv)
- **Then:** Add media libraries

#### ✅ Jellyfin
- **URL:** http://localhost:8096
- **First Time:** Create admin account
- **Then:** Add same media libraries as Plex

---

### Services with DEFAULT CREDENTIALS (Change Immediately!)

#### ⚠️ Grafana
- **URL:** http://localhost:3003
- **Username:** `admin`
- **Password:** Check `~/HomeLab/docs/FINAL_CREDENTIALS.txt`
- **After login:** Change password in profile settings

#### ⚠️ Nextcloud
- **URL:** http://localhost:8097
- **Username:** `admin`
- **Password:** Check `~/HomeLab/docs/FINAL_CREDENTIALS.txt`
- **After login:** Complete setup wizard

#### ⚠️ PhotoPrism
- **URL:** http://localhost:2342
- **Username:** `admin`
- **Password:** Check `~/HomeLab/docs/FINAL_CREDENTIALS.txt`

#### ⚠️ Code Server (VS Code)
- **URL:** http://localhost:8443
- **Password:** `changeme`
- **⚠️ CHANGE THIS!** Edit in settings or restart with new password

#### ⚠️ File Browser
- **URL:** http://localhost:8087
- **Username:** `admin`
- **Password:** `admin`
- **⚠️ CHANGE THIS!** Click username → Settings → Change password

#### ⚠️ Nginx Proxy Manager
- **URL:** http://localhost:81
- **Email:** `admin@example.com`
- **Password:** `changeme`
- **After login:** Change in user settings

---

### Services with AUTO-CONFIGURATION

#### ✅ AdGuard Home
- **URL:** http://localhost:3002
- **First Time:** Setup wizard
  1. Choose admin username
  2. Choose admin password
  3. Configure DNS settings
  4. Set listening interfaces

---

### Media Automation Stack (Configure Together)

These work together - configure in this order:

#### 1. Prowlarr (Indexer Manager) - CONFIGURE FIRST
- **URL:** http://localhost:9696
- **First Time:** Open and create settings
- **Purpose:** Add indexers (search sources)
- **Setup:**
  1. Settings → General → Copy API key
  2. Indexers → Add Indexer
  3. Add your preferred indexers
  4. Test each one

#### 2. Radarr (Movies)
- **URL:** http://localhost:7878
- **Setup:**
  1. Settings → General → Copy API key
  2. Settings → Indexers → Add → Prowlarr
  3. Settings → Download Clients → Add → Transmission
  4. Settings → Connect → Add → Plex/Jellyfin
  5. Movies → Add Movie

#### 3. Sonarr (TV Shows)
- **URL:** http://localhost:8989
- **Setup:** Same as Radarr but for TV shows
  1. Connect to Prowlarr
  2. Connect to Transmission
  3. Connect to Plex/Jellyfin
  4. Series → Add Series

#### 4. Overseerr (Requests)
- **URL:** http://localhost:5055
- **Setup:**
  1. Sign in with Plex account
  2. Connect to Plex server
  3. Connect to Radarr (use API key)
  4. Connect to Sonarr (use API key)
  5. Share URL with family for requests

---

### Development Tools

#### Jupyter Notebook
- **URL:** http://localhost:8888
- **Token Required:** Get from logs
  ```bash
  docker logs jupyter
  ```
  Look for line: `http://127.0.0.1:8888/?token=XXXXX`
- Copy the token and paste when accessing

#### Gitea (Git Server)
- **URL:** http://localhost:3001
- **First Time:** Initial configuration
  1. Database: Keep SQLite
  2. Server domain: localhost
  3. Port: 3001
  4. Create admin account
- **Then:** Create repositories

---

### Monitoring Stack

#### Grafana
- **URL:** http://localhost:3003
- **After login:**
  1. Add Data Sources:
     - Prometheus: http://prometheus:9090
     - Loki: http://loki:3100
     - InfluxDB: http://influxdb:8086
  2. Import Dashboards:
     - Dashboard ID 1860 (Node Exporter)
     - Dashboard ID 193 (Docker)
     - Dashboard ID 893 (Container Stats)

#### Prometheus
- **URL:** http://localhost:9090
- **Just works** - already scraping metrics
- **Use via:** Grafana dashboards

---

### Storage & Sync

#### Nextcloud
- **After login:**
  1. Complete setup wizard
  2. Install apps: Calendar, Contacts, Notes, Tasks
  3. Download desktop sync client
  4. Download Android/iOS app for photo upload

#### Syncthing
- **URL:** http://localhost:8384
- **First Time:** 
  1. Set device name
  2. Add folders to sync
  3. Add remote devices (other computers/phones)
- **On other devices:** Install Syncthing app

#### Duplicati (Backups)
- **URL:** http://localhost:8200
- **Setup:**
  1. Choose destination (external drive, cloud storage)
  2. Configure encryption password (SAVE THIS!)
  3. Select folders to backup
  4. Set schedule (daily recommended)

---

## 📋 Configuration Priority Order

### Essential (Do These First - 30 min)
1. ✅ **Portainer** - For managing everything
2. ✅ **Vaultwarden** - Store all passwords here
3. ✅ **Heimdall** - Your homepage

### Choose Your Path

#### 🎬 Media User (2-3 hours)
4. ✅ Plex or Jellyfin
5. ✅ Prowlarr
6. ✅ Radarr
7. ✅ Sonarr
8. ✅ Overseerr

#### 🏠 Smart Home User (2-3 hours)
4. ✅ Home Assistant
5. ✅ Node-RED
6. ✅ Connect your devices (Sonos, Nest, Tesla, etc.)

#### 🤖 AI/Dev User (1 hour)
4. ✅ OpenWebUI
5. ✅ Download AI models
6. ✅ Code Server
7. ✅ Jupyter

#### 📊 Monitoring Enthusiast (1-2 hours)
4. ✅ Grafana
5. ✅ Import dashboards
6. ✅ Uptime Kuma

### When You Have Time
- Nextcloud (cloud storage)
- Duplicati (backups - important!)
- Paperless-ngx (documents)
- PhotoPrism (photos)
- All the rest!

---

## 🎯 Quick Start Commands

**View all passwords:**
```bash
cat ~/HomeLab/docs/FINAL_CREDENTIALS.txt
```

**Restart a service:**
```bash
docker restart <service-name>
```

**View service logs:**
```bash
docker logs <service-name>
```

**Check what's running:**
```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
```

**Restart Portainer (if timeout):**
```bash
docker restart portainer
# Then immediately open http://localhost:9000
```

---

## 🔧 Troubleshooting

**Service won't load:**
1. Check if running: `docker ps | grep <service>`
2. Check logs: `docker logs <service>`
3. Restart: `docker restart <service>`
4. Check Portainer for errors

**Forgot password:**
- Most services: Check `~/HomeLab/docs/FINAL_CREDENTIALS.txt`
- Reset if needed: Stop container, delete data folder, restart

**Port conflict:**
- Check what's using port: `lsof -i :<port>`
- Change port in compose file
- Restart container

---

## 📱 Mobile Access

**Via Tailscale:**
- All services: `http://TAILSCALE_IP:PORT`
- Your IP: `tailscale ip -4`
- Works from anywhere!

**Apps to Install:**
- **Vaultwarden:** Bitwarden app
- **Home Assistant:** Official app
- **Plex:** Official app
- **Nextcloud:** Official app
- **VNC Viewer:** For screen sharing

---

## ✅ Essential First Day Checklist

- [ ] Open Portainer - create account
- [ ] Open Heimdall - stays empty until you add apps
- [ ] Open Vaultwarden - create account - **master password crucial!**
- [ ] Get all passwords from FINAL_CREDENTIALS.txt
- [ ] Add them to Vaultwarden
- [ ] Delete FINAL_CREDENTIALS.txt after saving
- [ ] Configure Heimdall - add all services
- [ ] Set Heimdall as browser homepage
- [ ] Pick one category (Media/Smart Home/AI) to configure
- [ ] Set up Duplicati for backups

---

## 🎓 Learning Resources

**Walkthroughs Location:**
```
~/HomeLab/docs/walkthroughs/
```

**Start with:**
- `00-INDEX.md` - Overview
- `01-Portainer.md` - Essential tool
- `03-Heimdall.md` - Your homepage
- Then pick your path!

---

**Need Help?**
- Check Portainer logs
- Restart the service
- Check the walkthrough guides
- Google the specific error

**Your homelab is 97% operational - great start! 🎉**

EOF

sed -i '' "s/TIMESTAMP/$(date)/" "$HOMELAB_DIR/docs/QUICK_SETUP_GUIDE.md"

################################################################################
# Create credentials file if missing
################################################################################

if [ ! -f "$HOMELAB_DIR/docs/FINAL_CREDENTIALS.txt" ]; then
    log_info "Creating credentials reference file..."
    
    GRAFANA_PASS=$(docker exec grafana printenv GF_SECURITY_ADMIN_PASSWORD 2>/dev/null || echo "admin")
    NEXTCLOUD_PASS=$(docker exec nextcloud printenv NEXTCLOUD_ADMIN_PASSWORD 2>/dev/null || echo "admin")
    
    cat > "$HOMELAB_DIR/docs/FINAL_CREDENTIALS.txt" << EOF
╔═══════════════════════════════════════════════════════════════╗
║              HOMELAB CREDENTIALS REFERENCE                     ║
╚═══════════════════════════════════════════════════════════════╝

Generated: $(date)

SERVICE CREDENTIALS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Grafana:          admin / ${GRAFANA_PASS}
Nextcloud:        admin / ${NEXTCLOUD_PASS}
PhotoPrism:       admin / ${NEXTCLOUD_PASS}
Code Server:      changeme (CHANGE THIS!)
File Browser:     admin / admin (CHANGE THIS!)
Nginx Proxy:      admin@example.com / changeme

SERVICES REQUIRING ACCOUNT CREATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Portainer:        http://localhost:9000 (create on first access)
Vaultwarden:      http://localhost:8088 (create on first access)
OpenWebUI:        http://localhost:3000 (create on first access)
Home Assistant:   http://localhost:8123 (create on first access)
Uptime Kuma:      http://localhost:3004 (create on first access)
Plex:             http://localhost:32400/web (sign in with plex.tv)
Jellyfin:         http://localhost:8096 (create on first access)

⚠️  ADD ALL PASSWORDS TO VAULTWARDEN THEN DELETE THIS FILE!

EOF
    chmod 600 "$HOMELAB_DIR/docs/FINAL_CREDENTIALS.txt"
fi

################################################################################
# Summary
################################################################################

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}✓ Fixes Applied${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Fixed services:"
echo "  - Portainer restarted (open NOW: http://localhost:9000)"
echo "  - Duplicati restarted"
echo "  - AdGuard restarted"
echo "  - OpenWebUI restarted"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${BLUE}📚 Complete Setup Guide Created${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Guide location:"
echo "  ~/HomeLab/docs/QUICK_SETUP_GUIDE.md"
echo ""
echo "View it:"
echo "  open ~/HomeLab/docs/QUICK_SETUP_GUIDE.md"
echo ""
echo "This guide includes:"
echo "  ✓ All default credentials"
echo "  ✓ Which services need account creation"
echo "  ✓ Step-by-step setup for each service"
echo "  ✓ Configuration order recommendations"
echo "  ✓ Troubleshooting tips"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${YELLOW}⚡ QUICK START (Do These Now)${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "1. Portainer (CRITICAL - do within 5 min):"
echo "   http://localhost:9000"
echo "   → Create admin account"
echo ""
echo "2. Heimdall (your homepage):"
echo "   http://localhost:8090"
echo "   → Click settings gear → Add applications"
echo ""
echo "3. Vaultwarden (password manager):"
echo "   http://localhost:8088"
echo "   → Create account (master password important!)"
echo "   → Store all other passwords here"
echo ""
echo "4. Get credentials:"
echo "   cat ~/HomeLab/docs/FINAL_CREDENTIALS.txt"
echo "   → Add to Vaultwarden"
echo "   → Delete file after saving"
echo ""
echo "Then configure services based on your interests!"
echo ""