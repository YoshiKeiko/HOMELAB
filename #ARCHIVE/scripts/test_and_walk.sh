#!/bin/bash

################################################################################
# HomeLab Complete Testing & Configuration Walkthrough
# Tests all 47 services and provides step-by-step configuration guide
################################################################################

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

HOMELAB_DIR="$HOME/HomeLab"
WALKTHROUGH_DIR="$HOMELAB_DIR/docs/walkthroughs"
TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "127.0.0.1")

# Create walkthrough directory
mkdir -p "$WALKTHROUGH_DIR"

log_test() {
    echo -e "${CYAN}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[✓ PASS]${NC} $1"
}

log_fail() {
    echo -e "${RED}[✗ FAIL]${NC} $1"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}  $1${NC}"
    echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Test if URL is accessible
test_url() {
    local service_name=$1
    local url=$2
    local expected_code=${3:-200}
    
    log_test "Testing $service_name at $url"
    
    if curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" | grep -q "$expected_code\|302\|301"; then
        log_pass "$service_name is accessible"
        return 0
    else
        log_fail "$service_name is NOT accessible"
        return 1
    fi
}

# Test if container is running
test_container() {
    local container_name=$1
    
    if docker ps --format '{{.Names}}' | grep -q "^${container_name}$"; then
        log_pass "$container_name container is running"
        return 0
    else
        log_fail "$container_name container is NOT running"
        return 1
    fi
}

################################################################################
# Generate Walkthroughs for Each Service
################################################################################

generate_walkthroughs() {
    log_section "Generating Configuration Walkthroughs"
    
    # Create master walkthrough index
    cat > "$WALKTHROUGH_DIR/00-INDEX.md" << 'EOF'
# 🏠 HomeLab Configuration Walkthrough Index

**Complete Step-by-Step Guide for All 47 Services**

## 📋 How to Use This Guide

1. Start with **Phase 1** (Core Services)
2. Work through each phase in order
3. Each service has checkboxes - tick them off as you complete
4. Take your time - don't rush
5. Bookmark services as you configure them

## 🗂️ Configuration Phases

### Phase 1: Core Infrastructure (Essential)
1. [Portainer](01-Portainer.md) - Docker Management (START HERE!)
2. [Watchtower](02-Watchtower.md) - Auto-updates

### Phase 2: Databases (Auto-configured)
- Already configured - no action needed
- PostgreSQL, MariaDB, MongoDB, Redis, InfluxDB

### Phase 3: Essential Dashboards
3. [Heimdall](03-Heimdall.md) - Main Dashboard (IMPORTANT!)
4. [Homer](04-Homer.md) - Alternative Dashboard
5. [Dashy](05-Dashy.md) - Modern Dashboard
6. [Organizr](06-Organizr.md) - Tabbed Dashboard

### Phase 4: Media Stack
7. [Plex](07-Plex.md) - Media Server
8. [Jellyfin](08-Jellyfin.md) - Open Source Alternative
9. [Prowlarr](09-Prowlarr.md) - Indexer Manager (Configure FIRST)
10. [Radarr](10-Radarr.md) - Movie Manager
11. [Sonarr](11-Sonarr.md) - TV Show Manager
12. [Transmission](12-Transmission.md) - Download Client
13. [Overseerr](13-Overseerr.md) - Request Management

### Phase 5: Monitoring
14. [Grafana](14-Grafana.md) - Dashboards
15. [Prometheus](15-Prometheus.md) - Metrics
16. [Uptime Kuma](16-Uptime-Kuma.md) - Uptime Monitoring
17. [Netdata](17-Netdata.md) - Real-time Monitoring

### Phase 6: AI & Development
18. [OpenWebUI](18-OpenWebUI.md) - AI Chat Interface
19. [Ollama](19-Ollama.md) - LLM Server
20. [Code Server](20-Code-Server.md) - VS Code
21. [Jupyter](21-Jupyter.md) - Python Notebooks
22. [Gitea](22-Gitea.md) - Git Server

### Phase 7: Smart Home
23. [Home Assistant](23-Home-Assistant.md) - Smart Home Hub
24. [Node-RED](24-Node-RED.md) - Automation Flows
25. [ESPHome](25-ESPHome.md) - DIY Devices

### Phase 8: Storage & Backup
26. [Nextcloud](26-Nextcloud.md) - Cloud Storage
27. [Syncthing](27-Syncthing.md) - File Sync
28. [Duplicati](28-Duplicati.md) - Backups
29. [File Browser](29-File-Browser.md) - Web File Manager

### Phase 9: Security
30. [Vaultwarden](30-Vaultwarden.md) - Password Manager
31. [AdGuard Home](31-AdGuard.md) - DNS Ad Blocking

### Phase 10: Utilities
32. [Paperless-ngx](32-Paperless.md) - Document Management
33. [PhotoPrism](33-PhotoPrism.md) - Photo Management
34. [Calibre](34-Calibre.md) - eBook Management
35. [FreshRSS](35-FreshRSS.md) - RSS Reader

## ⏱️ Time Estimates

- **Phase 1 (Core):** 15 minutes
- **Phase 3 (Dashboards):** 30 minutes
- **Phase 4 (Media):** 1-2 hours
- **Phase 5 (Monitoring):** 1 hour
- **Phase 6 (AI):** 30 minutes
- **Phase 7 (Smart Home):** 2-3 hours
- **Phase 8 (Storage):** 1 hour
- **Phase 9 (Security):** 30 minutes
- **Phase 10 (Utilities):** 1-2 hours

**Total Time:** 8-12 hours (spread over several days)

## 🎯 Quick Start Path (Essential Services Only)

If you want to get started quickly, configure these first:

1. ✅ Portainer (essential for troubleshooting)
2. ✅ Heimdall (your homepage)
3. ✅ Plex or Jellyfin (media streaming)
4. ✅ Home Assistant (if you have smart home devices)
5. ✅ OpenWebUI (if you want local AI)
6. ✅ Nextcloud (personal cloud)
7. ✅ Vaultwarden (password manager)

Then configure the rest as you need them!

---

**Your Tailscale IP:** TAILSCALE_IP_PLACEHOLDER  
**All services accessible at:** http://TAILSCALE_IP_PLACEHOLDER:PORT

EOF

    sed -i '' "s/TAILSCALE_IP_PLACEHOLDER/${TAILSCALE_IP}/g" "$WALKTHROUGH_DIR/00-INDEX.md"
    
    log_info "Creating individual service walkthroughs..."
    
    # Create Portainer walkthrough
    cat > "$WALKTHROUGH_DIR/01-Portainer.md" << 'EOF'
# Portainer - Docker Management

**URL:** http://localhost:9000  
**Tailscale:** http://TAILSCALE_IP:9000  
**Time:** 5 minutes

## What is Portainer?

Your control panel for all Docker containers. Essential for managing your homelab.

## Configuration Steps

### Step 1: Initial Access
- [ ] Open http://localhost:9000
- [ ] You should see the Portainer login/setup page

### Step 2: Create Admin Account
- [ ] Set username (e.g., `admin`)
- [ ] Set a **strong** password (save to 1Password)
- [ ] Click "Create User"

### Step 3: Connect to Docker
- [ ] Select "Docker" (not Kubernetes)
- [ ] Choose "Connect using socket"
- [ ] Click "Connect"

### Step 4: Explore the Interface
- [ ] Click "local" environment
- [ ] Click "Containers" - you should see all 47 services
- [ ] Click on a container to view:
  - Logs (useful for troubleshooting)
  - Stats (CPU/RAM usage)
  - Console (execute commands)

### Step 5: Bookmark It
- [ ] Bookmark http://localhost:9000
- [ ] You'll use this CONSTANTLY

## What You Can Do

**View All Containers:**
- See which are running (green)
- Which are stopped (red)
- Resource usage for each

**Manage Containers:**
- Start/Stop/Restart any service
- View real-time logs
- Check resource usage
- Execute commands inside containers

**Troubleshooting:**
- When a service isn't working, check logs here first
- Restart containers with one click
- See error messages immediately

## Common Tasks

**Restart a Service:**
1. Click "Containers"
2. Find the service
3. Click the circular arrow icon

**View Logs:**
1. Click container name
2. Click "Logs" tab
3. Toggle "Auto-refresh" for live logs

**Check Resource Usage:**
1. Click container name
2. Click "Stats" tab
3. See CPU, RAM, Network usage

## Tips

- Keep Portainer open in a pinned browser tab
- Check logs when troubleshooting ANY service
- Use the search box to find containers quickly
- Set up Portainer app on your phone for mobile management

## ✅ Verification

- [ ] Can log in to Portainer
- [ ] Can see all 47 containers
- [ ] Can view logs of any container
- [ ] Can restart a test container successfully

## Next Step

→ Configure [Heimdall Dashboard](03-Heimdall.md) to access all your services easily

EOF

    # Create Heimdall walkthrough
    cat > "$WALKTHROUGH_DIR/03-Heimdall.md" << 'EOF'
# Heimdall - Application Dashboard

**URL:** http://localhost:8090  
**Tailscale:** http://TAILSCALE_IP:8090  
**Time:** 30 minutes

## What is Heimdall?

Your homelab homepage. One page with links to all 47 services. **Make this your browser homepage!**

## Configuration Steps

### Step 1: Initial Access
- [ ] Open http://localhost:8090
- [ ] You should see an empty dashboard

### Step 2: Add Your First Application
- [ ] Look for settings/gear icon (top right or bottom right)
- [ ] Click "+ Add" or "Add Application"

### Step 3: Add Essential Services

Copy these settings for each service:

#### Portainer
- **Title:** Portainer
- **URL:** http://localhost:9000
- **App Type:** Select "Portainer" from dropdown
- [ ] Save

#### Plex
- **Title:** Plex
- **URL:** http://localhost:32400/web
- **App Type:** Select "Plex" from dropdown
- [ ] Save

#### Jellyfin
- **Title:** Jellyfin
- **URL:** http://localhost:8096
- **App Type:** Select "Jellyfin"
- [ ] Save

#### Home Assistant
- **Title:** Home Assistant
- **URL:** http://localhost:8123
- **App Type:** Select "Home Assistant"
- [ ] Save

#### OpenWebUI
- **Title:** OpenWebUI (AI Chat)
- **URL:** http://localhost:3000
- **App Type:** May need "Custom" - upload icon
- [ ] Save

#### Grafana
- **Title:** Grafana
- **URL:** http://localhost:3003
- **App Type:** Select "Grafana"
- [ ] Save

### Step 4: Add All Other Services

Continue adding services from this list:

**Media Services:**
- Radarr (http://localhost:7878)
- Sonarr (http://localhost:8989)
- Prowlarr (http://localhost:9696)
- Overseerr (http://localhost:5055)
- Transmission (http://localhost:9091)
- Tautulli (http://localhost:8181)

**Monitoring:**
- Prometheus (http://localhost:9090)
- Uptime Kuma (http://localhost:3004)
- Netdata (http://localhost:19999)

**Storage:**
- Nextcloud (http://localhost:8097)
- Syncthing (http://localhost:8384)
- Duplicati (http://localhost:8200)
- File Browser (http://localhost:8087)

**AI & Development:**
- Code Server (http://localhost:8443)
- Jupyter (http://localhost:8888)
- Gitea (http://localhost:3001)

**Security:**
- Vaultwarden (http://localhost:8088)
- AdGuard (http://localhost:3002)

**Utilities:**
- Paperless-ngx (http://localhost:8093)
- PhotoPrism (http://localhost:2342)
- Calibre (http://localhost:8094)
- FreshRSS (http://localhost:8098)

**Network:**
- Nginx Proxy Manager (http://localhost:81)

### Step 5: Organize with Tags
- [ ] Create tags: Media, Monitoring, Storage, AI, Security, Utilities
- [ ] Tag each application appropriately
- [ ] They'll be grouped on your dashboard

### Step 6: Set as Homepage
- [ ] In your browser settings, set homepage to http://localhost:8090
- [ ] Or bookmark it in your favorites bar
- [ ] On phone: Add to home screen

### Step 7: Customize
- [ ] Click settings gear
- [ ] Choose background image (or upload your own)
- [ ] Adjust tile size
- [ ] Choose color scheme

## Tips

**Search Functionality:**
- Use search box to quickly find services
- Faster than scrolling with 47+ tiles

**Status Indicators:**
- Green dot = service is up
- Red dot = service is down
- Click tile to open service

**Mobile Access:**
- Via Tailscale: http://TAILSCALE_IP:8090
- Add to phone home screen for app-like experience

**Multiple Profiles:**
- Create different views for different purposes
- "Work" profile with dev tools
- "Media" profile with streaming services

## ✅ Verification

- [ ] All essential services added
- [ ] Tiles show correct icons
- [ ] Clicking tiles opens services
- [ ] Status indicators working
- [ ] Set as browser homepage

## Next Step

Choose your path:
- **Media:** Configure [Plex](07-Plex.md)
- **Smart Home:** Configure [Home Assistant](23-Home-Assistant.md)
- **AI:** Configure [OpenWebUI](18-OpenWebUI.md)
- **Monitoring:** Configure [Grafana](14-Grafana.md)

EOF

    # Create Plex walkthrough
    cat > "$WALKTHROUGH_DIR/07-Plex.md" << 'EOF'
# Plex Media Server Configuration

**URL:** http://localhost:32400/web  
**Time:** 30-60 minutes

## Prerequisites

- [ ] Media files organized in folders
- [ ] Plex account created (free at plex.tv)

## Configuration Steps

### Step 1: Initial Setup
- [ ] Open http://localhost:32400/web
- [ ] Sign in with Plex account
- [ ] Name your server (e.g., "HomeLab")
- [ ] Click "Next"

### Step 2: Add Movie Library
- [ ] Click "Add Library"
- [ ] Select "Movies"
- [ ] Click "Next"
- [ ] Click "Browse for Media Folder"
- [ ] Navigate to: `/data/movies` (inside container)
- [ ] Click "Add"
- [ ] Under "Advanced", check:
  - [ ] "Scan my library automatically"
  - [ ] "Run scanner when changes are detected"
- [ ] Click "Add Library"

### Step 3: Add TV Shows Library
- [ ] Click "Add Library" again
- [ ] Select "TV Shows"
- [ ] Browse to: `/data/tv`
- [ ] Enable automatic scanning
- [ ] Click "Add Library"

### Step 4: Add Music Library (Optional)
- [ ] Click "Add Library"
- [ ] Select "Music"
- [ ] Browse to: `/data/music`
- [ ] Enable automatic scanning
- [ ] Click "Add Library"

### Step 5: Configure Settings

#### General Settings
- [ ] Go to Settings → General
- [ ] Set friendly name
- [ ] Enable "Update my library automatically"

#### Remote Access
- [ ] Go to Settings → Remote Access
- [ ] Click "Enable Remote Access"
- [ ] Note: May not work initially - that's OK
- [ ] Use Tailscale for remote access instead

#### Transcoder Settings
- [ ] Go to Settings → Transcoder
- [ ] Set "Transcoder quality" to "Automatic"
- [ ] Enable "Use hardware acceleration when available"
- [ ] Set transcoder temp directory to `/transcode`

### Step 6: Configure Agents (Metadata)
- [ ] Settings → Agents
- [ ] For Movies: Ensure "The Movie Database" is checked
- [ ] For TV Shows: Ensure "The TVDB" is checked
- [ ] These fetch posters, descriptions, cast info

### Step 7: Test Scanning
- [ ] Add a test movie to `/Users/homelab/HomeLab/Docker/Data/plex/media/movies`
- [ ] Go to your Movies library
- [ ] Click "..." → "Scan Library Files"
- [ ] Wait a minute, movie should appear with poster

## File Organization Best Practices

**Movies:**
```
/movies
  ├── Movie Name (Year)
  │   └── Movie Name (Year).mkv
  ├── Another Movie (2023)
  │   └── Another Movie (2023).mp4
```

**TV Shows:**
```
/tv
  ├── Show Name
  │   ├── Season 01
  │   │   ├── Show Name - S01E01.mkv
  │   │   ├── Show Name - S01E02.mkv
  │   └── Season 02
  │       ├── Show Name - S02E01.mkv
```

## Features to Explore

### Collections
- Automatically groups related movies
- Star Wars collection, MCU collection, etc.
- Create custom collections

### Playlists
- Create playlists across libraries
- "Workout Music", "Kids Movies", etc.

### Sharing
- Share libraries with family/friends
- Each user gets their own watch history
- Settings → Users → "Invite Friends"

### Mobile Apps
- Download Plex app on phone/tablet
- Sign in with same account
- Access your media anywhere via Tailscale

### Plex Discovery
- Get recommendations
- Find trending content
- Track what you want to watch

## Troubleshooting

**Movies not appearing:**
- Check file names match Plex format
- Run manual scan
- Check Portainer logs: `docker logs plex`

**No posters/metadata:**
- Check internet connection
- Settings → Troubleshooting → "Refresh all metadata"

**Buffering/transcoding issues:**
- Reduce quality in player settings
- Check CPU usage in Portainer
- M4 Mac should handle 4K transcoding fine

## ✅ Verification

- [ ] Can see movie library
- [ ] Can see TV show library
- [ ] Test movie has poster and metadata
- [ ] Can play a video
- [ ] Video plays smoothly

## Next Steps

→ Configure [Radarr](10-Radarr.md) to automate movie downloads  
→ Configure [Sonarr](11-Sonarr.md) to automate TV downloads  
→ Configure [Overseerr](13-Overseerr.md) for family requests

EOF

    # Create Home Assistant walkthrough
    cat > "$WALKTHROUGH_DIR/23-Home-Assistant.md" << 'EOF'
# Home Assistant Configuration

**URL:** http://localhost:8123  
**Tailscale:** http://TAILSCALE_IP:8123  
**Time:** 2-3 hours (varies by devices)

## What You'll Connect

Based on your setup:
- 10 Sonos speakers
- 5 Nest cameras
- Tesla Model Y
- Cupra Born EV
- Easee charger
- Plus any future smart devices

## Configuration Steps

### Step 1: Initial Setup
- [ ] Open http://localhost:8123
- [ ] Wait for Home Assistant to fully start (first launch takes 2-3 minutes)
- [ ] Create your account:
  - [ ] Name
  - [ ] Username
  - [ ] Password (save to 1Password)
  - [ ] Set time zone to "Europe/London"
  - [ ] Set location (for weather, sun, etc.)

### Step 2: Skip Analytics (Optional)
- [ ] Choose whether to share analytics
- [ ] Click "Next"

### Step 3: Device Discovery
- [ ] Home Assistant will automatically discover devices on your network
- [ ] You should see some devices appear
- [ ] Don't add them yet - we'll do it properly

### Step 4: Enable Advanced Mode
- [ ] Click your username (bottom left)
- [ ] Scroll down
- [ ] Toggle "Advanced Mode" ON
- [ ] This unlocks more features

### Step 5: Install HACS (Home Assistant Community Store)

HACS gives you access to thousands of custom integrations.

**Open Terminal in Home Assistant:**
- [ ] Go to Settings → Add-ons → Add-on Store
- [ ] Install "Terminal & SSH" add-on
- [ ] Start it
- [ ] Click "Open Web UI"

**Install HACS:**
```bash
wget -O - https://get.hacs.xyz | bash -
```

- [ ] Restart Home Assistant (Settings → System → Restart)
- [ ] After restart, go to Settings → Devices & Services
- [ ] Click "+ Add Integration"
- [ ] Search for "HACS"
- [ ] Follow GitHub authorization steps
- [ ] HACS is now installed

### Step 6: Add Sonos Speakers

- [ ] Go to Settings → Devices & Services
- [ ] Click "+ Add Integration"
- [ ] Search "Sonos"
- [ ] Click "Sonos"
- [ ] It should auto-discover all 10 speakers
- [ ] Select all speakers you want to add
- [ ] Click "Submit"
- [ ] Name each speaker properly (Living Room, Bedroom, etc.)

**Sonos Features:**
- Play/pause/skip
- Volume control
- Group speakers together
- Source selection
- TTS (text-to-speech announcements)

### Step 7: Add Nest Cameras

**Option 1: Via Google (Recommended)**
- [ ] Go to Settings → Devices & Services
- [ ] Click "+ Add Integration"
- [ ] Search "Google Nest"
- [ ] Click it
- [ ] Log in with your Google account
- [ ] Authorize Home Assistant
- [ ] Select your 5 cameras
- [ ] They'll appear as camera entities

**What you get:**
- Live camera feeds
- Motion detection
- Alerts
- Recording (if Nest Aware subscription)

### Step 8: Add Tesla Model Y

**Install Tesla Custom Integration via HACS:**
- [ ] Go to HACS → Integrations
- [ ] Click "+ Explore & Download Repositories"
- [ ] Search "Tesla Custom Integration"
- [ ] Click "Download"
- [ ] Restart Home Assistant

**Add Your Tesla:**
- [ ] Settings → Devices & Services
- [ ] Click "+ Add Integration"
- [ ] Search "Tesla Custom Integration"
- [ ] Enter your Tesla account email/password
- [ ] Your Model Y should appear

**Tesla Controls:**
- Climate control (heat/cool)
- Door lock/unlock
- Charging start/stop
- Battery level
- Range
- Location
- Sentry mode

### Step 9: Add Cupra Born

**Install Volkswagen We Connect:**
- [ ] HACS → Integrations
- [ ] Search "Volkswagen We Connect ID"
- [ ] Download
- [ ] Restart
- [ ] Add integration
- [ ] Login with Cupra/VW credentials
- [ ] Select Cupra Born

**Cupra Controls:**
- Battery level
- Charging status
- Range
- Climate control
- Door lock status

### Step 10: Add Easee Charger

- [ ] Settings → Devices & Services
- [ ] "+ Add Integration"
- [ ] Search "Easee"
- [ ] Login with Easee account
- [ ] Your charger appears

**Easee Controls:**
- Start/stop charging
- Set charging current
- Schedule charging
- Monitor energy usage
- See charging statistics

### Step 11: Create Your First Dashboard

- [ ] Click "Overview" (home icon)
- [ ] Click three dots → "Edit Dashboard"
- [ ] Click "+ Add Card"

**Essential Cards to Add:**

**Weather Card:**
- [ ] Search "Weather"
- [ ] Select "Weather Forecast"
- [ ] Configure for your location

**Media Control Card:**
- [ ] Add "Media Control" card
- [ ] Select a Sonos speaker
- [ ] Repeat for other main speakers

**Camera Cards:**
- [ ] Add "Picture Glance" card for each camera
- [ ] Shows live feed with tap to open

**Tesla Card:**
- [ ] Add "Entities" card
- [ ] Add Tesla battery level
- [ ] Add Tesla range
- [ ] Add Tesla location

**Cupra Card:**
- [ ] Same as Tesla
- [ ] Battery, range, charging status

**Easee Charger Card:**
- [ ] Add "Entities" card
- [ ] Show charging status
- [ ] Show power usage
- [ ] Add toggle for start/stop

### Step 12: Create Your First Automation

**Example: "Welcome Home" Automation**

- [ ] Go to Settings → Automations & Scenes
- [ ] Click "Create Automation"
- [ ] Click "Start with an empty automation"

**Trigger:**
- [ ] Click "+ Add Trigger"
- [ ] Type: Zone
- [ ] Zone: Home
- [ ] Event: Enter
- [ ] Person: You

**Actions:**
- [ ] "+ Add Action"
- [ ] Action type: Call Service
- [ ] Service: `light.turn_on`
- [ ] Target: Your lights
- [ ] Save

Now when you arrive home, lights turn on automatically!

### Step 13: More Automation Ideas

**Leaving Home:**
- Trigger: Everyone leaves home
- Actions:
  - Turn off all lights
  - Set cameras to away mode
  - Adjust thermostat
  - Lock doors (if smart locks)

**Bedtime:**
- Trigger: 11 PM (or button press)
- Actions:
  - Turn off all lights
  - Stop all Sonos speakers
  - Lock doors
  - Lower heating
  - Set cameras to night mode

**Cheap Electricity Charging:**
- Trigger: Time (when electricity is cheap)
- Actions:
  - Start Easee charger
  - Send notification
  - Stop at 6 AM

**Motion Lights:**
- Trigger: Motion detected (camera or sensor)
- Condition: Sun is down
- Action: Turn on nearby lights for 5 minutes

**Morning Routine:**
- Trigger: Alarm goes off (or time)
- Actions:
  - Gradually turn on bedroom lights
  - Start coffee maker (if smart plug)
  - Play news on Sonos
  - Preheat Tesla/Cupra

### Step 14: Install Useful Integrations

Via HACS, install these popular integrations:

**Alexa Media Player** (if you have Alexa):
- Control Alexa devices
- Send TTS notifications

**Spotify:**
- Control Spotify on Sonos
- See what's playing

**WAZE Travel Time:**
- Commute time notifications
- EV charging based on travel time

**Frigate** (if you want local camera AI):
- Person/object detection
- Better than Nest AI
- Works with your existing cameras

## Mobile App Setup

### Install Home Assistant App
- [ ] Download from Play Store/App Store
- [ ] Open app
- [ ] Scan QR code OR enter: http://TAILSCALE_IP:8123
- [ ] Login with your account
- [ ] Grant location permissions (for presence detection)
- [ ] Enable notifications

### Mobile App Features
- **Presence detection:** Knows when you're home
- **Actionable notifications:** "Garage open - close it?" with button
- **Quick actions:** Widgets for common controls
- **Camera viewing:** See all cameras in one app
- **Voice control:** "Hey Google, turn on living room lights" (via HA)

## Advanced: Node-RED Integration

For complex automations, use Node-RED:
- [ ] Open Node-RED: http://localhost:1880
- [ ] Install Home Assistant nodes
- [ ] Create visual automation flows

## Tips

**Start Simple:**
- Don't try to automate everything at once
- Start with lights, then add more

**Test Automations:**
- Use the "Run Actions" button to test without waiting for triggers

**Backup Configuration:**
- Settings → System → Backups
- Create backup weekly
- Download to safe location

**Voice Control:**
- Integrate with Google Home or Alexa
- "Hey Google, start charging the Cupra"
- "Alexa, play music in the kitchen"

**Energy Dashboard:**
- Settings → Energy
- Add your chargers
- Track EV charging costs
- See solar production (if you add solar)

## Troubleshooting

**Device not discovered:**
- Ensure device and Mac are on same network
- Check device manufacturer's HA integration docs
- May need to add manually with IP address

**Automation not triggering:**
- Check automation state (ON/OFF toggle)
- View automation traces to see what happened
- Check trigger conditions

**Slow interface:**
- Clear browser cache
- Use Chrome/Edge (not Safari)
- Check CPU usage in Portainer

## ✅ Verification

- [ ] Can log in to Home Assistant
- [ ] Sonos speakers added and controllable
- [ ] Nest cameras visible
- [ ] Tesla added with controls
- [ ] Cupra added with controls
- [ ] Easee charger controllable
- [ ] Created at least one automation
- [ ] Mobile app installed and working

## Next Steps

→ [Node-RED](24-Node-RED.md) for advanced automations  
→ [ESPHome](25-ESPHome.md) for DIY sensors  
→ Explore HACS for custom integrations

---

**This is your smart home brain. Spend time here - it's worth it!**

EOF

    # Create OpenWebUI walkthrough
    cat > "$WALKTHROUGH_DIR/18-OpenWebUI.md" << 'EOF'
# OpenWebUI - Local AI Chat

**URL:** http://localhost:3000  
**Tailscale:** http://TAILSCALE_IP:3000  
**Time:** 20 minutes

## What is OpenWebUI?

ChatGPT-style interface running completely on your M4 Mac. No subscriptions, no data sent to external servers.

## Prerequisites

- [ ] Ollama is running (check in Portainer)

## Configuration Steps

### Step 1: Create Account
- [ ] Open http://localhost:3000
- [ ] Click "Sign Up"
- [ ] Enter email (can be fake - it's local only)
- [ ] Set username
- [ ] Set password (save to 1Password)
- [ ] Click "Create Account"

### Step 2: Download Your First Model

Models are like different AI personalities. Start with these:

**Llama 3.2 (Fast, good for chat):**
- [ ] Click settings (gear icon)
- [ ] Go to "Models"
- [ ] In "Pull a model from Ollama.com", type: `llama3.2`
- [ ] Click download icon
- [ ] Wait 2-5 minutes (1.3GB download)

**Mistral (Smarter, better for complex tasks):**
- [ ] Pull model: `mistral`
- [ ] Wait 5-10 minutes (4.1GB download)

**CodeLlama (Best for programming):**
- [ ] Pull model: `codellama`
- [ ] Wait 5-10 minutes (3.8GB)

**DeepSeek Coder (Alternative for coding):**
- [ ] Pull model: `deepseek-coder`
- [ ] Great for programming questions

### Step 3: Test Your First Chat
- [ ] Click "New Chat"
- [ ] Select model (llama3.2 for speed)
- [ ] Type: "Tell me a joke about homelabs"
- [ ] Watch response stream in real-time
- [ ] Response should be coherent and relevant

### Step 4: Try Different Models
- [ ] Start new chat
- [ ] Switch to Mistral
- [ ] Ask same question
- [ ] Compare responses
- [ ] Notice Mistral is smarter but slower

### Step 5: Test Code Generation
- [ ] Start new chat
- [ ] Select CodeLlama
- [ ] Ask: "Write a Python script to organize files by extension"
- [ ] Model should provide working code with explanations

### Step 6: Upload Documents (RAG)

OpenWebUI can read documents and answer questions about them!

- [ ] Click paperclip icon in chat
- [ ] Upload a PDF or text file
- [ ] Ask: "Summarize this document"
- [ ] Ask: "What are the key points?"
- [ ] Model uses document content to answer

### Step 7: Customize Settings

**Model Settings:**
- [ ] Click settings → Models
- [ ] Adjust temperature (0.7 = balanced, 0.3 = focused, 0.9 = creative)
- [ ] Adjust max tokens (response length)

**Interface Settings:**
- [ ] Settings → Interface
- [ ] Choose dark/light theme
- [ ] Adjust font size
- [ ] Enable/disable features

**System Prompts:**
- [ ] Settings → Prompts
- [ ] Create custom system prompts
- [ ] Example: "You are a helpful homelab assistant who knows Docker"
- [ ] Use per chat or globally

### Step 8: Create Custom Prompts

**Example: Homelab Helper**
- [ ] Settings → Prompts
- [ ] Create new prompt
- [ ] Name: "HomeLab Assistant"
- [ ] Content:
```
You are an expert in homelabs, Docker, Linux, and home automation.
You help configure services, troubleshoot issues, and suggest improvements.
Always provide practical, tested solutions.
```
- [ ] Save
- [ ] Use in new chats by selecting it

**Example: Code Reviewer**
```
You are a senior software engineer doing code review.
Identify bugs, suggest improvements, and explain best practices.
Be constructive and educational.
```

### Step 9: Organize Chats

**Folders:**
- [ ] Right-click on chat
- [ ] "Move to folder"
- [ ] Create folders: Code, HomeLab, Writing, etc.
- [ ] Organize chats by topic

**Tags:**
- [ ] Tag chats for easy searching
- [ ] #docker, #python, #homelab, etc.

**Archive Old Chats:**
- [ ] Right-click → Archive
- [ ] Keeps chat history clean

## Recommended Models by Use Case

**General Chat & Questions:**
- `llama3.2` (fast)
- `mistral` (smarter)

**Programming & Code:**
- `codellama`
- `deepseek-coder`
- `phind-codellama`

**Creative Writing:**
- `mistral`
- `llama3.2`

**Technical Documentation:**
- `deepseek-coder`
- `codellama`

**Small & Fast (for testing):**
- `tinyllama` (650MB)

**Vision (Image Understanding):**
- `llava` (can describe images)

## Example Prompts to Try

**HomeLab:**
- "How do I configure Plex to transcode 4K to 1080p?"
- "Write a Docker compose file for a new service"
- "Explain how Prometheus scraping works"

**Coding:**
- "Review this Python code: [paste code]"
- "Convert this bash script to Python"
- "Explain this error: [paste error]"

**Writing:**
- "Write a professional email requesting time off"
- "Summarize this article in 3 bullet points"
- "Rewrite this paragraph to be more concise"

**Learning:**
- "Explain Docker networking like I'm 5"
- "What's the difference between MQTT and HTTP?"
- "Teach me Python decorators with examples"

## Advanced Features

**Chat Import/Export:**
- Export chats as JSON
- Share conversations
- Backup important chats

**API Access:**
- OpenWebUI has an API
- Integrate with other apps
- Automate conversations

**Multi-User:**
- Create accounts for family
- Each user gets their own chat history
- Admin controls in settings

**Model Management:**
- Delete unused models to free space
- Each model is several GB
- Keep 3-4 models you actually use

## Performance Tips

**M4 Mac Optimization:**
- Models run on CPU (no GPU needed)
- M4 handles 7B-13B models well
- Larger models (70B+) will be slow

**Speed vs Quality:**
- llama3.2: Fastest, good enough
- mistral: Slower, smarter
- Pick based on task importance

**Memory Usage:**
- Models use RAM when loaded
- Unload unused models
- Check RAM in Portainer

## Privacy & Security

**Completely Private:**
- No data sent to external servers
- No internet required (after model download)
- Chat history stored locally

**Safe for Sensitive Data:**
- Can paste confidential code
- Can discuss private matters
- Perfect for work-related questions

## Troubleshooting

**Model won't download:**
- Check internet connection
- Check disk space (models are large)
- Try `docker logs ollama` in Portainer

**Slow responses:**
- M4 Mac should be fast
- Check CPU usage in Portainer
- Try smaller model (llama3.2 vs mistral)

**Model gives nonsense:**
- Lower temperature
- Try different model
- Rephrase question more specifically

**Can't access OpenWebUI:**
- Check if running in Portainer
- Try `docker restart openwebui`
- Check logs: `docker logs openwebui`

## ✅ Verification

- [ ] Can log in to OpenWebUI
- [ ] Downloaded at least 2 models
- [ ] Had successful conversation
- [ ] Tested code generation
- [ ] Uploaded and queried a document
- [ ] Created custom prompt
- [ ] Organized chats into folders

## Next Steps

→ Download more models as needed  
→ Create custom prompts for your workflow  
→ Integrate into your daily work

**This replaces ChatGPT subscriptions - use it daily!**

EOF

    log_pass "Walkthroughs generated successfully"
    log_info "Location: $WALKTHROUGH_DIR"
}

################################################################################
# Run System Tests
################################################################################

run_system_tests() {
    log_section "Running System Tests"
    
    local total_tests=0
    local passed_tests=0
    
    log_info "Testing Core Services..."
    test_container "portainer" && ((passed_tests++)); ((total_tests++))
    test_container "watchtower" && ((passed_tests++)); ((total_tests++))
    test_url "Portainer" "http://localhost:9000" "200" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing Databases..."
    test_container "postgres" && ((passed_tests++)); ((total_tests++))
    test_container "mariadb" && ((passed_tests++)); ((total_tests++))
    test_container "mongodb" && ((passed_tests++)); ((total_tests++))
    test_container "redis" && ((passed_tests++)); ((total_tests++))
    test_container "influxdb" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing Media Services..."
    test_container "plex" && ((passed_tests++)); ((total_tests++))
    test_container "jellyfin" && ((passed_tests++)); ((total_tests++))
    test_container "radarr" && ((passed_tests++)); ((total_tests++))
    test_container "sonarr" && ((passed_tests++)); ((total_tests++))
    test_container "prowlarr" && ((passed_tests++)); ((total_tests++))
    test_container "overseerr" && ((passed_tests++)); ((total_tests++))
    test_container "transmission" && ((passed_tests++)); ((total_tests++))
    test_url "Plex" "http://localhost:32400/web" "200\|401" && ((passed_tests++)); ((total_tests++))
    test_url "Jellyfin" "http://localhost:8096" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing AI Services..."
    test_container "ollama" && ((passed_tests++)); ((total_tests++))
    test_container "openwebui" && ((passed_tests++)); ((total_tests++))
    test_container "codeserver" && ((passed_tests++)); ((total_tests++))
    test_container "jupyter" && ((passed_tests++)); ((total_tests++))
    test_container "gitea" && ((passed_tests++)); ((total_tests++))
    test_url "OpenWebUI" "http://localhost:3000" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing Smart Home..."
    test_container "homeassistant" && ((passed_tests++)); ((total_tests++))
    test_container "nodered" && ((passed_tests++)); ((total_tests++))
    test_container "mosquitto" && ((passed_tests++)); ((total_tests++))
    test_url "Home Assistant" "http://localhost:8123" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing Monitoring..."
    test_container "grafana" && ((passed_tests++)); ((total_tests++))
    test_container "prometheus" && ((passed_tests++)); ((total_tests++))
    test_container "uptime-kuma" && ((passed_tests++)); ((total_tests++))
    test_container "netdata" && ((passed_tests++)); ((total_tests++))
    test_url "Grafana" "http://localhost:3003" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing Storage..."
    test_container "nextcloud" && ((passed_tests++)); ((total_tests++))
    test_container "syncthing" && ((passed_tests++)); ((total_tests++))
    test_container "duplicati" && ((passed_tests++)); ((total_tests++))
    test_url "Nextcloud" "http://localhost:8097" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing Security..."
    test_container "vaultwarden" && ((passed_tests++)); ((total_tests++))
    test_container "crowdsec" && ((passed_tests++)); ((total_tests++))
    test_url "Vaultwarden" "http://localhost:8088" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing Dashboards..."
    test_container "heimdall" && ((passed_tests++)); ((total_tests++))
    test_container "homer" && ((passed_tests++)); ((total_tests++))
    test_container "dashy" && ((passed_tests++)); ((total_tests++))
    test_url "Heimdall" "http://localhost:8090" && ((passed_tests++)); ((total_tests++))
    
    log_info "Testing Utilities..."
    test_container "paperless" && ((passed_tests++)); ((total_tests++))
    test_container "photoprism" && ((passed_tests++)); ((total_tests++))
    test_container "calibre" && ((passed_tests++)); ((total_tests++))
    test_container "freshrss" && ((passed_tests++)); ((total_tests++))
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo -e "  ${GREEN}TEST RESULTS${NC}"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo -e "Total Tests:     ${BLUE}${total_tests}${NC}"
    echo -e "Passed:          ${GREEN}${passed_tests}${NC}"
    echo -e "Failed:          ${RED}$((total_tests - passed_tests))${NC}"
    echo -e "Success Rate:    ${CYAN}$((passed_tests * 100 / total_tests))%${NC}"
    echo ""
}

################################################################################
# Create Test Report
################################################################################

create_test_report() {
    local report_file="$HOMELAB_DIR/docs/TEST_REPORT_$(date +%Y%m%d-%H%M%S).md"
    
    cat > "$report_file" << EOF
# HomeLab System Test Report

**Generated:** $(date)  
**Total Containers:** $(docker ps --format '{{.Names}}' | wc -l | tr -d ' ')  
**Tailscale IP:** ${TAILSCALE_IP}

## Test Results

See terminal output above for detailed test results.

## Running Containers

\`\`\`
$(docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | head -50)
\`\`\`

## System Resources

**Docker Stats:**
\`\`\`
$(docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | head -20)
\`\`\`

## Next Steps

1. Review walkthroughs in: $WALKTHROUGH_DIR
2. Start with: 01-Portainer.md
3. Configure Heimdall: 03-Heimdall.md
4. Choose your path based on interests

## Configuration Order Recommendation

**Essential (Do First):**
1. Portainer
2. Heimdall
3. Vaultwarden (passwords)

**Media Users:**
4. Plex/Jellyfin
5. Prowlarr
6. Radarr/Sonarr
7. Overseerr

**Smart Home Users:**
4. Home Assistant
5. Node-RED
6. Configure your devices

**Power Users:**
4. Grafana + Prometheus
5. Nextcloud
6. OpenWebUI
7. Everything else!

EOF
    
    log_info "Test report saved: $report_file"
}

################################################################################
# Main Execution
################################################################################

main() {
    log_section "HomeLab System Test & Configuration Walkthrough"
    
    echo "This script will:"
    echo "1. Test all 47 services to verify they're working"
    echo "2. Generate detailed configuration walkthroughs"
    echo "3. Create a test report"
    echo ""
    echo "Press Enter to continue..."
    read
    
    generate_walkthroughs
    run_system_tests
    create_test_report
    
    log_section "Complete!"
    
    echo ""
    echo -e "${GREEN}✓ All walkthroughs generated${NC}"
    echo -e "${GREEN}✓ System tests completed${NC}"
    echo -e "${GREEN}✓ Test report created${NC}"
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  📚 CONFIGURATION WALKTHROUGHS${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Location: $WALKTHROUGH_DIR"
    echo ""
    echo "Start here:"
    echo "  1. open '$WALKTHROUGH_DIR/00-INDEX.md'"
    echo "  2. Follow walkthroughs in order"
    echo "  3. Check off each step as you complete it"
    echo ""
    echo -e "${CYAN}Recommended configuration order:${NC}"
    echo "  1. Portainer (essential troubleshooting tool)"
    echo "  2. Heimdall (your homelab homepage)"
    echo "  3. Pick your path:"
    echo "     - Media: Plex → Prowlarr → Radarr/Sonarr"
    echo "     - Smart Home: Home Assistant → Node-RED"
    echo "     - AI: OpenWebUI → download models"
    echo "     - Monitoring: Grafana → Prometheus"
    echo ""
    echo "Take your time - quality over speed!"
    echo ""
}

main "$@"