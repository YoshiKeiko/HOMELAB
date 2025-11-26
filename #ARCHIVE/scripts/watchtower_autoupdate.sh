#!/bin/bash

################################################################################
# Setup Automatic Docker Container Updates with Watchtower
################################################################################

set -euo pipefail

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

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║       SETUP AUTOMATIC DOCKER CONTAINER UPDATES                 ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

################################################################################
# Check if Watchtower already exists
################################################################################

log_step "Checking for existing Watchtower..."
echo ""

if docker ps -a | grep -q watchtower; then
    log_info "Watchtower already exists"
    WATCHTOWER_EXISTS=true
else
    log_info "Watchtower not found - will create"
    WATCHTOWER_EXISTS=false
fi

echo ""

################################################################################
# Create Watchtower Configuration
################################################################################

log_step "Creating Watchtower configuration..."
echo ""

COMPOSE_FILE="$HOME/HomeLab/Docker/Compose/core.yml"

# Check if core.yml exists, if not create it
if [ ! -f "$COMPOSE_FILE" ]; then
    log_info "Creating core.yml for system services..."
    mkdir -p "$(dirname "$COMPOSE_FILE")"
    
    cat > "$COMPOSE_FILE" << 'EOFCORE'
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /Users/homelab/HomeLab/Docker/Data/portainer:/data
    networks:
      - homelab-net

  watchtower:
    image: containrrr/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_INCLUDE_RESTARTING=true
      - WATCHTOWER_INCLUDE_STOPPED=false
      - WATCHTOWER_SCHEDULE=0 0 4 * * *
      - WATCHTOWER_NOTIFICATIONS=shoutrrr
      - WATCHTOWER_NOTIFICATION_URL=
      - TZ=Europe/London
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
EOFCORE

    log_info "Created core.yml with Portainer and Watchtower"
else
    # Add Watchtower to existing core.yml if not present
    if ! grep -q "watchtower:" "$COMPOSE_FILE"; then
        log_info "Adding Watchtower to existing core.yml..."
        
        # Backup
        cp "$COMPOSE_FILE" "$COMPOSE_FILE.backup-$(date +%Y%m%d-%H%M%S)"
        
        # Add Watchtower before networks section
        cat > /tmp/watchtower_service.yml << 'EOFWATCH'

  watchtower:
    image: containrrr/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_INCLUDE_RESTARTING=true
      - WATCHTOWER_INCLUDE_STOPPED=false
      - WATCHTOWER_SCHEDULE=0 0 4 * * *
      - WATCHTOWER_NOTIFICATIONS=shoutrrr
      - WATCHTOWER_NOTIFICATION_URL=
      - TZ=Europe/London
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - homelab-net
EOFWATCH

        # Insert before networks
        awk '
        /^networks:/ && !inserted { 
            system("cat /tmp/watchtower_service.yml")
            inserted=1
        }
        { print }
        ' "$COMPOSE_FILE" > "$COMPOSE_FILE.tmp" && mv "$COMPOSE_FILE.tmp" "$COMPOSE_FILE"
        
        log_info "Watchtower added to core.yml"
    else
        log_info "Watchtower already in core.yml"
    fi
fi

echo ""

################################################################################
# Start Watchtower
################################################################################

log_step "Starting Watchtower..."
echo ""

cd ~/HomeLab/Docker/Compose
docker compose -f core.yml up -d watchtower

sleep 3

if docker ps | grep -q watchtower; then
    log_info "Watchtower is running"
else
    log_error "Watchtower failed to start"
    docker logs watchtower --tail 30
    exit 1
fi

echo ""

################################################################################
# Create Documentation
################################################################################

log_step "Creating documentation..."
echo ""

cat > "$HOME/HomeLab/docs/WATCHTOWER_AUTO_UPDATES.md" << 'EOFDOC'
# 🔄 Automatic Docker Container Updates with Watchtower

## What is Watchtower?

Watchtower automatically updates your Docker containers when new images are available.

**What it does:**
1. Checks for updated images daily (4 AM)
2. Pulls new images if available
3. Stops old container
4. Starts new container with same config
5. Removes old image (cleanup)
6. All automatic, no manual intervention!

---

## ✅ Current Configuration

### Update Schedule

**When:** Every day at 4:00 AM

**What gets updated:**
- ✅ All running containers
- ✅ Containers that restart automatically
- ❌ Stopped containers (skipped)

### Settings

```yaml
WATCHTOWER_CLEANUP: true                    # Remove old images
WATCHTOWER_INCLUDE_RESTARTING: true        # Update restarting containers
WATCHTOWER_INCLUDE_STOPPED: false          # Skip stopped containers
WATCHTOWER_SCHEDULE: 0 0 4 * * *           # 4 AM daily (cron format)
```

---

## 🎯 What Gets Updated Automatically

### Your Containers (Currently 47+):

**Media Stack:**
- Plex
- Jellyfin
- Radarr
- Sonarr
- Prowlarr
- Overseerr
- Transmission
- Tautulli

**Smart Home:**
- Home Assistant
- Node-RED
- Mosquitto (MQTT)
- Zigbee2MQTT

**AI Services:**
- Ollama
- Open WebUI

**Monitoring:**
- Prometheus
- Grafana
- Netdata
- Uptime Kuma

**Security:**
- Vaultwarden
- AdGuard Home

**System:**
- Portainer
- Watchtower (updates itself!)
- FlareSolverr

**And all others!**

---

## 🔧 Manual Update (Before 4 AM)

### Update Prowlarr Now:

```bash
# Update just Prowlarr
docker compose -f ~/HomeLab/Docker/Compose/media.yml pull prowlarr
docker compose -f ~/HomeLab/Docker/Compose/media.yml up -d prowlarr

# Watchtower will handle it automatically at 4 AM anyway!
```

### Update All Media Containers:

```bash
cd ~/HomeLab/Docker/Compose
docker compose -f media.yml pull
docker compose -f media.yml up -d
```

### Update Everything:

```bash
# Let Watchtower do it (one-time immediate run)
docker exec watchtower /watchtower --run-once
```

---

## 📊 Check What Watchtower is Doing

### View Logs

```bash
# See recent activity
docker logs watchtower --tail 50

# Follow live updates
docker logs watchtower -f
```

**You'll see:**
```
time="2025-01-01T04:00:00Z" level=info msg="Checking for updates"
time="2025-01-01T04:00:05Z" level=info msg="Found new prowlarr:latest"
time="2025-01-01T04:00:10Z" level=info msg="Stopping prowlarr"
time="2025-01-01T04:00:15Z" level=info msg="Starting prowlarr"
time="2025-01-01T04:00:20Z" level=info msg="Session done"
```

### Check Last Run

```bash
docker logs watchtower --since 24h | grep -i "session done"
```

---

## ⚙️ Advanced Configuration

### Change Update Schedule

**Edit core.yml:**

```bash
nano ~/HomeLab/Docker/Compose/core.yml
```

**Find Watchtower section and change schedule:**

```yaml
- WATCHTOWER_SCHEDULE=0 0 4 * * *    # Current: 4 AM daily
```

**Common schedules (cron format):**

```
0 0 4 * * *     # 4 AM every day (current)
0 0 2 * * *     # 2 AM every day
0 0 4 * * 0     # 4 AM every Sunday
0 0 4 */2 * *   # 4 AM every 2 days
0 0 */6 * * *   # Every 6 hours
```

**After changing:**
```bash
docker compose -f ~/HomeLab/Docker/Compose/core.yml up -d watchtower
```

---

### Exclude Specific Containers

**Don't want something auto-updated?**

Add label to container in compose file:

```yaml
  homeassistant:
    image: ghcr.io/home-assistant/home-assistant:stable
    # ... other config ...
    labels:
      - "com.centurylinklabs.watchtower.enable=false"
```

**Then restart container:**
```bash
docker compose -f ~/HomeLab/Docker/Compose/smart-home.yml up -d homeassistant
```

---

### Enable Update Notifications

**Get notified when containers update!**

#### Email Notifications (Gmail):

**Edit core.yml:**

```yaml
- WATCHTOWER_NOTIFICATIONS=shoutrrr
- WATCHTOWER_NOTIFICATION_URL=smtp://your-email@gmail.com:app-password@smtp.gmail.com:587/?from=your-email@gmail.com&to=your-email@gmail.com
```

**Gmail App Password:**
1. https://myaccount.google.com/apppasswords
2. Generate password
3. Use in URL above

#### Discord Notifications:

```yaml
- WATCHTOWER_NOTIFICATION_URL=discord://webhook-id/webhook-token
```

#### Slack Notifications:

```yaml
- WATCHTOWER_NOTIFICATION_URL=slack://webhook-url
```

**Restart Watchtower after changes:**
```bash
docker compose -f ~/HomeLab/Docker/Compose/core.yml restart watchtower
```

---

## 🛡️ Safety Features

### What Watchtower Does:

✅ **Uses same configuration** - Your volumes, ports, env vars stay the same
✅ **Cleanup** - Removes old images automatically
✅ **Maintains restart policy** - Containers restart as configured
✅ **No data loss** - Only updates image, keeps all data in volumes

### What Watchtower Doesn't Do:

❌ **Doesn't update compose files** - Manual changes stay
❌ **Doesn't change volumes** - Your data is safe
❌ **Doesn't modify networks** - Network config unchanged
❌ **Doesn't break things** - If update fails, old container keeps running

### Rollback if Needed:

```bash
# If new version has issues, rollback:
docker stop prowlarr
docker rm prowlarr

# Edit compose to use specific version
nano ~/HomeLab/Docker/Compose/media.yml

# Change:
# image: lscr.io/linuxserver/prowlarr:latest
# To:
# image: lscr.io/linuxserver/prowlarr:1.10.5.4088

# Restart
docker compose -f ~/HomeLab/Docker/Compose/media.yml up -d prowlarr
```

---

## 📋 Update Strategy by Service

### Always Update (Safe):

These are stable and safe to auto-update:
- ✅ Plex (stable releases)
- ✅ Transmission (very stable)
- ✅ AdGuard Home (careful with config)
- ✅ Netdata (monitoring)
- ✅ Uptime Kuma (monitoring)
- ✅ FlareSolverr (proxy)

### Auto-Update with Caution:

These sometimes have breaking changes:
- ⚠️ **Home Assistant** - Check release notes first!
- ⚠️ **Radarr/Sonarr/Prowlarr** - Usually fine, but test
- ⚠️ **Grafana** - Dashboard configs might need adjustment
- ⚠️ **Vaultwarden** - Backup before major updates

**Recommendation:** Use stable/specific tags for critical services:

```yaml
homeassistant:
  image: ghcr.io/home-assistant/home-assistant:2024.1.0  # Specific version
  # Not: ghcr.io/home-assistant/home-assistant:latest
```

### Manual Updates Only:

Consider excluding from Watchtower:
- 🔒 **Databases** (PostgreSQL, MongoDB) - Backup first!
- 🔒 **Vaultwarden** - Passwords are critical
- 🔒 **Home Assistant** - Smart home is critical

---

## 🧪 Test Updates Before Production

### Create Test Instance:

```bash
# Test Prowlarr update before applying to main
docker run -d \
  --name prowlarr-test \
  -p 9697:9696 \
  lscr.io/linuxserver/prowlarr:latest

# Test it works
# Then update main instance
```

---

## 📊 Monitoring Updates

### Create Update Log Script:

```bash
cat > ~/check-updates.sh << 'EOFSCRIPT'
#!/bin/bash

echo "Watchtower Update Log (Last 7 Days)"
echo "===================================="
echo ""

docker logs watchtower --since 168h | grep -E "(Checking|Found new|Stopping|Starting|Session done)"

echo ""
echo "Containers currently running:"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
EOFSCRIPT

chmod +x ~/check-updates.sh
```

**Run it:**
```bash
~/check-updates.sh
```

---

## ✅ Best Practices

### 1. Regular Backups

Before relying on auto-updates:

```bash
# Backup all configs daily (Duplicati does this)
# Backup databases before major updates
# Test rollback procedure
```

### 2. Monitor After Updates

```bash
# Check logs after 4 AM updates
docker compose -f ~/HomeLab/Docker/Compose/media.yml logs --since 1h

# Check if all containers running
docker ps -a | grep -v "Up"
```

### 3. Pin Critical Versions

**For critical services, use specific versions:**

```yaml
vaultwarden:
  image: vaultwarden/server:1.30.1  # Pin version
  # Not: vaultwarden/server:latest
```

### 4. Staged Rollout

**Update test environment first:**
1. Update test container (9697 port)
2. Verify works for 24 hours
3. Let Watchtower update production

---

## 🆘 Troubleshooting

### Watchtower Not Updating Containers

**Check schedule:**
```bash
docker logs watchtower | grep -i schedule
```

**Force immediate update:**
```bash
docker exec watchtower /watchtower --run-once
```

**Check for errors:**
```bash
docker logs watchtower --tail 100 | grep -i error
```

### Container Won't Start After Update

**Check logs:**
```bash
docker logs prowlarr --tail 50
```

**Rollback to previous version:**
```bash
# Stop container
docker stop prowlarr

# Check available versions
# https://github.com/linuxserver/docker-prowlarr/releases

# Update compose with specific version
# Restart
```

### Watchtower Stopped Running

**Restart Watchtower:**
```bash
docker restart watchtower
```

**Check if it's stuck:**
```bash
docker ps -a | grep watchtower
```

---

## 📝 Quick Reference

**Status Check:**
```bash
docker ps | grep watchtower
docker logs watchtower --tail 20
```

**Force Update Now:**
```bash
docker exec watchtower /watchtower --run-once
```

**Update Specific Service:**
```bash
docker compose -f ~/HomeLab/Docker/Compose/media.yml pull prowlarr
docker compose -f ~/HomeLab/Docker/Compose/media.yml up -d prowlarr
```

**Disable Auto-Update for Container:**
```yaml
labels:
  - "com.centurylinklabs.watchtower.enable=false"
```

**View Update Schedule:**
```bash
docker inspect watchtower | grep SCHEDULE
```

---

## 🎉 Summary

**You now have:**
- ✅ Automatic updates at 4 AM daily
- ✅ Old images cleaned up automatically  
- ✅ All 47+ containers stay up-to-date
- ✅ Safe rollback if needed
- ✅ Zero manual intervention required

**Watchtower keeps your homelab fresh! 🔄**

**Want to update Prowlarr right now?**
```bash
docker exec watchtower /watchtower --run-once
```

**Or just wait until 4 AM - Watchtower's got you covered!** ⏰

EOFDOC

log_info "Documentation created: ~/HomeLab/docs/WATCHTOWER_AUTO_UPDATES.md"

echo ""

################################################################################
# Summary
################################################################################

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║              ✓ WATCHTOWER SETUP COMPLETE!                     ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "What Watchtower Does:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ Checks for updates daily at 4:00 AM"
echo "  ✅ Automatically pulls new images"
echo "  ✅ Restarts containers with updates"
echo "  ✅ Cleans up old images"
echo "  ✅ All 47+ containers stay current"
echo ""

echo "Update Prowlarr Right Now:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${CYAN}docker exec watchtower /watchtower --run-once${NC}"
echo ""
echo "Or just wait - Watchtower will update it at 4 AM!"
echo ""

echo "Check Watchtower Status:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${CYAN}docker logs watchtower --tail 50${NC}"
echo ""

echo "Update Specific Container Manually:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${CYAN}docker compose -f ~/HomeLab/Docker/Compose/media.yml pull prowlarr${NC}"
echo "  ${CYAN}docker compose -f ~/HomeLab/Docker/Compose/media.yml up -d prowlarr${NC}"
echo ""

echo "View Complete Documentation:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${CYAN}open ~/HomeLab/docs/WATCHTOWER_AUTO_UPDATES.md${NC}"
echo ""

echo "${GREEN}Your containers will now stay automatically updated! 🔄${NC}"
echo ""