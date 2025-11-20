#!/bin/bash

################################################################################
# Complete Plex 4TB Setup Script
# Creates folders, updates configs, restarts everything
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

DRIVE="/Volumes/HomeLab-4TB"
HOMELAB_DIR="$HOME/HomeLab"
DATA_DIR="$HOMELAB_DIR/Docker/Data"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        PLEX 4TB STORAGE - COMPLETE SETUP SCRIPT               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

################################################################################
# STEP 1: Verify Drive
################################################################################

log_step "Step 1: Verifying HomeLab-4TB drive..."
echo ""

if [ ! -d "$DRIVE" ]; then
    log_error "Drive not found at: $DRIVE"
    echo ""
    echo "Available drives:"
    ls -la /Volumes/
    echo ""
    echo "Please ensure HomeLab-4TB is mounted and try again."
    exit 1
fi

log_info "Drive found: $DRIVE"
echo ""
echo "Current space:"
df -h "$DRIVE" | tail -1
echo ""

################################################################################
# STEP 2: Create Folder Structure
################################################################################

log_step "Step 2: Creating folder structure on 4TB..."
echo ""

mkdir -p "$DRIVE/Media/Movies"
mkdir -p "$DRIVE/Media/TV Shows"
mkdir -p "$DRIVE/Media/Music"
mkdir -p "$DRIVE/Media/Photos"
mkdir -p "$DRIVE/Downloads/incomplete"
mkdir -p "$DRIVE/Downloads/complete/movies"
mkdir -p "$DRIVE/Downloads/complete/tv"

log_info "Created: $DRIVE/Media/Movies"
log_info "Created: $DRIVE/Media/TV Shows"
log_info "Created: $DRIVE/Media/Music"
log_info "Created: $DRIVE/Media/Photos"
log_info "Created: $DRIVE/Downloads/incomplete"
log_info "Created: $DRIVE/Downloads/complete/movies"
log_info "Created: $DRIVE/Downloads/complete/tv"
echo ""

# Set permissions
chmod -R 755 "$DRIVE/Media"
chmod -R 755 "$DRIVE/Downloads"
log_info "Permissions set"
echo ""

################################################################################
# STEP 3: Backup Existing Compose File
################################################################################

log_step "Step 3: Backing up existing configuration..."
echo ""

COMPOSE_FILE="$COMPOSE_DIR/media.yml"

if [ -f "$COMPOSE_FILE" ]; then
    cp "$COMPOSE_FILE" "$COMPOSE_FILE.backup-$(date +%Y%m%d-%H%M%S)"
    log_info "Backed up: $COMPOSE_FILE"
else
    mkdir -p "$COMPOSE_DIR"
    log_info "Creating new compose file"
fi
echo ""

################################################################################
# STEP 4: Create New Compose File with 4TB Paths
################################################################################

log_step "Step 4: Creating new docker-compose configuration..."
echo ""

cat > "$COMPOSE_FILE" << 'EOFCOMPOSE'
services:
  plex:
    image: lscr.io/linuxserver/plex:latest
    container_name: plex
    restart: unless-stopped
    ports:
      - "32400:32400"
    environment:
      - PUID=1000
      - PGID=1000
      - VERSION=docker
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/plex/config:/config
      - /Volumes/HomeLab-4TB/Media/Movies:/movies
      - /Volumes/HomeLab-4TB/Media/TV Shows:/tv
      - /Volumes/HomeLab-4TB/Media/Music:/music
      - /Volumes/HomeLab-4TB/Media/Photos:/photos
      - /Users/homelab/HomeLab/Docker/Data/plex/transcode:/transcode
    networks:
      - homelab-net

  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    ports:
      - "8096:8096"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/jellyfin:/config
      - /Volumes/HomeLab-4TB/Media/Movies:/movies
      - /Volumes/HomeLab-4TB/Media/TV Shows:/tv
      - /Volumes/HomeLab-4TB/Media/Music:/music
    networks:
      - homelab-net

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    restart: unless-stopped
    ports:
      - "7878:7878"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/radarr:/config
      - /Volumes/HomeLab-4TB/Media/Movies:/movies
      - /Volumes/HomeLab-4TB/Downloads:/downloads
    networks:
      - homelab-net

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    restart: unless-stopped
    ports:
      - "8989:8989"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/sonarr:/config
      - /Volumes/HomeLab-4TB/Media/TV Shows:/tv
      - /Volumes/HomeLab-4TB/Downloads:/downloads
    networks:
      - homelab-net

  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    restart: unless-stopped
    ports:
      - "9696:9696"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/prowlarr:/config
    networks:
      - homelab-net

  overseerr:
    image: lscr.io/linuxserver/overseerr:latest
    container_name: overseerr
    restart: unless-stopped
    ports:
      - "5055:5055"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/overseerr:/config
    networks:
      - homelab-net

  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    restart: unless-stopped
    ports:
      - "9091:9091"
      - "51413:51413"
      - "51413:51413/udp"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - USER=admin
      - PASS=transmission
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/transmission:/config
      - /Volumes/HomeLab-4TB/Downloads:/downloads
      - /Volumes/HomeLab-4TB/Downloads/complete:/watch
    networks:
      - homelab-net

  tautulli:
    image: lscr.io/linuxserver/tautulli:latest
    container_name: tautulli
    restart: unless-stopped
    ports:
      - "8181:8181"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/tautulli:/config
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
EOFCOMPOSE

log_info "New compose file created with 4TB paths"
echo ""

################################################################################
# STEP 5: Stop and Remove Old Containers
################################################################################

log_step "Step 5: Stopping existing media containers..."
echo ""

docker stop plex jellyfin radarr sonarr transmission 2>/dev/null || true
log_info "Stopped all media containers"
echo ""

################################################################################
# STEP 6: Start Services with New Configuration
################################################################################

log_step "Step 6: Starting services with new 4TB configuration..."
echo ""

cd "$COMPOSE_DIR"
docker compose -f media.yml up -d

log_info "Services starting..."
echo ""

# Wait for services to initialize
echo "Waiting 15 seconds for services to fully start..."
for i in {15..1}; do
    echo -ne "\r${YELLOW}$i seconds remaining...${NC}"
    sleep 1
done
echo -e "\r${GREEN}Services started!        ${NC}"
echo ""

################################################################################
# STEP 7: Verify Mounts
################################################################################

log_step "Step 7: Verifying container mounts..."
echo ""

# Test Plex
if docker exec plex ls /movies >/dev/null 2>&1; then
    log_info "Plex can see /movies"
else
    log_error "Plex CANNOT see /movies"
fi

if docker exec plex ls /tv >/dev/null 2>&1; then
    log_info "Plex can see /tv"
else
    log_error "Plex CANNOT see /tv"
fi

echo ""

# Test Radarr
if docker exec radarr ls /movies >/dev/null 2>&1; then
    log_info "Radarr can see /movies"
else
    log_error "Radarr CANNOT see /movies"
fi

if docker exec radarr ls /downloads >/dev/null 2>&1; then
    log_info "Radarr can see /downloads"
else
    log_error "Radarr CANNOT see /downloads"
fi

echo ""

# Test Sonarr
if docker exec sonarr ls /tv >/dev/null 2>&1; then
    log_info "Sonarr can see /tv"
else
    log_error "Sonarr CANNOT see /tv"
fi

if docker exec sonarr ls /downloads >/dev/null 2>&1; then
    log_info "Sonarr can see /downloads"
else
    log_error "Sonarr CANNOT see /downloads"
fi

echo ""

# Test Transmission
if docker exec transmission ls /downloads >/dev/null 2>&1; then
    log_info "Transmission can see /downloads"
else
    log_error "Transmission CANNOT see /downloads"
fi

echo ""

################################################################################
# STEP 8: Create Test Movie
################################################################################

log_step "Step 8: Creating test movie file..."
echo ""

mkdir -p "$DRIVE/Media/Movies/Big Buck Bunny (2008)"
cat > "$DRIVE/Media/Movies/Big Buck Bunny (2008)/Big Buck Bunny (2008).nfo" << 'EOFNFO'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<movie>
    <title>Big Buck Bunny</title>
    <year>2008</year>
    <plot>A test movie for your Plex setup</plot>
</movie>
EOFNFO

# Create small dummy file
dd if=/dev/zero of="$DRIVE/Media/Movies/Big Buck Bunny (2008)/Big Buck Bunny (2008).mkv" bs=1m count=1 2>/dev/null

log_info "Test movie created: Big Buck Bunny (2008)"
echo ""

################################################################################
# STEP 9: Create Configuration Guide
################################################################################

log_step "Step 9: Creating configuration guide..."
echo ""

cat > "$HOMELAB_DIR/docs/PLEX_CONFIGURATION_STEPS.md" << 'EOFGUIDE'
# 📺 Plex Configuration Steps

## ✅ Folders Created on HomeLab-4TB

```
/Volumes/HomeLab-4TB/
├── Media/
│   ├── Movies/         ✓ Ready for Plex
│   ├── TV Shows/       ✓ Ready for Plex
│   ├── Music/          ✓ Ready for Plex
│   └── Photos/         ✓ Ready for Plex
└── Downloads/
    ├── incomplete/     ✓ Transmission downloading here
    └── complete/
        ├── movies/     ✓ Radarr picks up from here
        └── tv/         ✓ Sonarr picks up from here
```

## 🎬 Configure Plex Libraries (DO THIS NOW!)

### 1. Open Plex Web Interface

```
http://localhost:32400/web
```

### 2. Add Movie Library

1. Click **"More"** or **"+"** in the sidebar
2. Click **"Add Library"**
3. Select **"Movies"**
4. Click **"Next"**
5. Click **"Browse for Media Folder"**
6. Navigate to **`/movies`** (this is inside the container)
7. Click **"Add"**
8. Under **"Advanced"**:
   - ✅ Check "Scan my library automatically"
   - ✅ Check "Run a partial scan when changes are detected"
9. Click **"Add Library"**

### 3. Add TV Shows Library

1. Click **"+"** → **"Add Library"**
2. Select **"TV Shows"**
3. Browse to **`/tv`**
4. Click **"Add"**
5. Enable automatic scanning
6. Click **"Add Library"**

### 4. Add Music Library (Optional)

1. Add Library → **"Music"**
2. Browse to **`/music`**
3. Click **"Add Library"**

### 5. Add Photos Library (Optional)

1. Add Library → **"Photos"**
2. Browse to **`/photos`**
3. Click **"Add Library"**

### 6. Verify Test Movie

1. Go to Movies library
2. You should see **"Big Buck Bunny (2008)"**
3. If not, click **"..."** → **"Scan Library Files"**
4. Wait 30 seconds
5. Refresh page

---

## 🎯 Configure Radarr (Movie Automation)

### 1. Open Radarr

```
http://localhost:7878
```

### 2. Add Root Folder

1. **Settings** → **Media Management**
2. Click **"Add Root Folder"**
3. Enter: **`/movies`**
4. Click **"OK"**

### 3. Connect to Transmission

1. **Settings** → **Download Clients**
2. Click **"+"** → **"Transmission"**
3. Configure:
   - **Name:** Transmission
   - **Host:** transmission
   - **Port:** 9091
   - **Username:** admin
   - **Password:** transmission
   - **Category:** movies
   - **Directory:** (leave empty)
4. Click **"Test"** → Should show green checkmark
5. Click **"Save"**

### 4. Connect to Plex

1. **Settings** → **Connect**
2. Click **"+"** → **"Plex Media Server"**
3. Configure:
   - **Name:** Plex
   - **Host:** plex
   - **Port:** 32400
4. Click **"Authenticate with Plex.tv"**
5. Sign in
6. Click **"Test"** → Should work
7. Click **"Save"**

### 5. Connect to Prowlarr

1. Open Prowlarr: http://localhost:9696
2. **Settings** → **Apps**
3. Click **"+"** → **"Radarr"**
4. Get Radarr API key:
   - Open Radarr → Settings → General
   - Copy **API Key**
5. In Prowlarr:
   - **Prowlarr Server:** http://prowlarr:9696
   - **Radarr Server:** http://radarr:7878
   - **API Key:** (paste from Radarr)
6. Click **"Test"** → **"Save"**

---

## 📺 Configure Sonarr (TV Automation)

### 1. Open Sonarr

```
http://localhost:8989
```

### 2. Add Root Folder

1. **Settings** → **Media Management**
2. Click **"Add Root Folder"**
3. Enter: **`/tv`**
4. Click **"OK"**

### 3. Connect to Transmission

Same as Radarr:
- **Host:** transmission
- **Port:** 9091
- **Username:** admin
- **Password:** transmission
- **Category:** tv

### 4. Connect to Plex

Same as Radarr:
- **Host:** plex
- **Port:** 32400
- Authenticate with Plex.tv

### 5. Connect to Prowlarr

1. Get Sonarr API key
2. In Prowlarr → Settings → Apps
3. Add Sonarr
4. Configure and test

---

## 🎭 Configure Overseerr (Request Management)

### 1. Open Overseerr

```
http://localhost:5055
```

### 2. Sign In with Plex

1. Click **"Use your Plex account"**
2. Sign in with Plex
3. Grant permissions

### 3. Connect Plex Server

1. Select your Plex server
2. Click **"Sync Libraries"**
3. Select Movies and TV Shows libraries
4. Click **"Continue"**

### 4. Connect Radarr

1. Click **"Add Radarr Server"**
2. Configure:
   - **Server Name:** Radarr
   - **Hostname/IP:** radarr
   - **Port:** 7878
   - **API Key:** (from Radarr Settings → General)
   - **Quality Profile:** HD-1080p (or your preference)
   - **Root Folder:** /movies
3. Click **"Test"** → **"Save"**

### 5. Connect Sonarr

Same process as Radarr:
- **Hostname:** sonarr
- **Port:** 8989
- **Root Folder:** /tv

### 6. Start Using!

Now family can request content through Overseerr's beautiful interface!

---

## 🧪 Test Your Complete Setup

### Test 1: Manual File Addition

1. Download a sample movie file
2. Place in: `/Volumes/HomeLab-4TB/Media/Movies/Movie Name (Year)/`
3. Name it: `Movie Name (Year).mkv`
4. Wait 1-2 minutes
5. Check Plex - should appear!

### Test 2: Automated Download

1. Open Overseerr: http://localhost:5055
2. Search for a movie
3. Click **"Request"**
4. Watch the magic:
   - Check Radarr - appears in queue
   - Check Transmission - starts downloading
   - Wait for download to complete
   - Radarr moves to Movies folder
   - Plex scans and adds to library
5. Movie appears in Plex! 🎉

---

## 📊 Monitor Your Setup

### Plex Dashboard

- **Tautulli:** http://localhost:8181
  - Connect to Plex
  - See what's being watched
  - Usage statistics
  - User activity

### Download Progress

- **Transmission:** http://localhost:9091
  - See active downloads
  - Manage queue
  - Set bandwidth limits

### System Health

- **Portainer:** http://localhost:9000
  - Check container status
  - View logs
  - Resource usage

---

## 🔧 Transmission Settings

### Configure Download Behavior

1. Open Transmission: http://localhost:9091
2. Click **wrench icon** (Settings)

**Downloading Tab:**
- Download to: `/downloads/incomplete`
- Move completed to: `/downloads/complete`
- ✅ Check "Keep incomplete downloads in..."

**Speed Tab:**
- Upload limit: 1000 KB/s (adjust for your upload speed)
- Download limit: Unlimited (or set if needed)

**Peers Tab:**
- Max peers: 50
- Max peers per torrent: 40

**Network Tab:**
- Peer port: 51413
- ✅ "Use port forwarding"
- ✅ "Enable µTP"

Click **Save** after changes.

---

## ✅ Configuration Complete Checklist

### Plex
- [ ] Movies library added (/movies)
- [ ] TV Shows library added (/tv)
- [ ] Automatic scanning enabled
- [ ] Test movie visible

### Radarr
- [ ] Root folder set (/movies)
- [ ] Transmission connected
- [ ] Plex connected
- [ ] Prowlarr connected

### Sonarr
- [ ] Root folder set (/tv)
- [ ] Transmission connected
- [ ] Plex connected
- [ ] Prowlarr connected

### Overseerr
- [ ] Plex authenticated
- [ ] Libraries synced
- [ ] Radarr connected
- [ ] Sonarr connected

### Testing
- [ ] Test movie shows in Plex
- [ ] Requested movie downloaded successfully
- [ ] Movie appeared in Plex automatically

---

## 🎉 You're Done!

Your complete media automation system is ready:

1. **Request content** in Overseerr
2. **Automatic download** via Radarr/Sonarr + Transmission
3. **Automatic organization** with proper naming
4. **Automatic scanning** in Plex
5. **Stream anywhere** via Plex apps

**Enjoy your personal Netflix! 🍿**

EOFGUIDE

log_info "Configuration guide created"
echo ""

################################################################################
# FINAL SUMMARY
################################################################################

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                  ✓ SETUP COMPLETE!                            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo -e "${GREEN}✓ Created folders on HomeLab-4TB${NC}"
echo -e "${GREEN}✓ Updated Docker configuration${NC}"
echo -e "${GREEN}✓ Restarted all media services${NC}"
echo -e "${GREEN}✓ Verified container mounts${NC}"
echo -e "${GREEN}✓ Created test movie${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${CYAN}NEXT STEPS - Configure Services${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}1. Configure Plex Libraries (IMPORTANT!)${NC}"
echo "   Open: ${CYAN}http://localhost:32400/web${NC}"
echo "   → Add Library → Movies → Browse to /movies"
echo "   → Add Library → TV Shows → Browse to /tv"
echo ""
echo -e "${YELLOW}2. Configure Radarr${NC}"
echo "   Open: ${CYAN}http://localhost:7878${NC}"
echo "   → Settings → Media Management → Root Folder: /movies"
echo "   → Settings → Download Clients → Add Transmission"
echo ""
echo -e "${YELLOW}3. Configure Sonarr${NC}"
echo "   Open: ${CYAN}http://localhost:8989${NC}"
echo "   → Settings → Media Management → Root Folder: /tv"
echo "   → Settings → Download Clients → Add Transmission"
echo ""
echo -e "${YELLOW}4. Configure Overseerr${NC}"
echo "   Open: ${CYAN}http://localhost:5055${NC}"
echo "   → Sign in with Plex → Connect Radarr & Sonarr"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${MAGENTA}Complete Configuration Guide${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Detailed step-by-step instructions:"
echo "  ${CYAN}open $HOMELAB_DIR/docs/PLEX_CONFIGURATION_STEPS.md${NC}"
echo ""
echo "Or:"
echo "  ${CYAN}cat $HOMELAB_DIR/docs/PLEX_CONFIGURATION_STEPS.md${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${GREEN}Storage Info${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
df -h "$DRIVE" | tail -1
echo ""
echo -e "${GREEN}Your media empire is ready! Configure Plex and start enjoying! 🎬${NC}"
echo ""