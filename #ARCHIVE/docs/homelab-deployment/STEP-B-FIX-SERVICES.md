# STEP B: FIX BROKEN SERVICES

**Time Required:** 20-30 minutes  
**Goal:** Get all 11 broken services working

**Broken Services:**
1. AdGuard Home (port 8084)
2. Plex (port 32400)
3. Sonarr (port 8989)
4. Transmission (port 9091)
5. Zigbee2MQTT (port 8080)
6. CrowdSec (port 8089)
7. PhotoPrism (port 2342)
8. Kopia (port 8202)
9. Paperless-ngx (port 8093)
10. Dashy (port 4000)

---

## General Troubleshooting Steps

For each broken service, follow this process:

### 1. Check if Container is Running

```bash
docker ps | grep service-name
```

**If not listed:**
```bash
# Check all containers (including stopped)
docker ps -a | grep service-name

# Start the container
docker start service-name
```

### 2. Check Logs

```bash
docker logs service-name --tail 50
```

Look for:
- ❌ Error messages
- ❌ "Permission denied"
- ❌ "Port already in use"
- ❌ "Connection refused"
- ❌ "File not found"

### 3. Check Port Conflicts

```bash
netstat -an | grep PORT_NUMBER
```

**If port shows multiple bindings:**
```bash
# Find which container is using it
docker ps --format '{{.Names}} {{.Ports}}' | grep PORT_NUMBER

# Stop conflicting container
docker stop conflicting-container
```

### 4. Restart Container

```bash
docker restart service-name
```

### 5. Test Again

```bash
curl -I http://192.168.50.50:PORT
```

---

## Service-Specific Fixes

### 1. AdGuard Home (Port 8084)

**Check Status:**
```bash
docker ps | grep adguard
docker logs adguard-home --tail 30
```

**Common Issues:**
- Port 53 (DNS) conflict with system DNS
- Port 8084 mapped incorrectly

**Fix:**
```bash
# Check port mapping
docker inspect adguard-home | grep -A 10 PortBindings

# Should show:
# "3000/tcp": [{"HostPort": "8084"}]

# If wrong, recreate container:
docker stop adguard-home
docker rm adguard-home

# Use the fixed docker run command from earlier
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

**Test:**
```bash
curl -I http://192.168.50.50:8084
```

---

### 2. Plex (Port 32400)

**Check Status:**
```bash
docker ps | grep plex
docker logs plex --tail 30
```

**Common Issues:**
- Not claimed to Plex account
- Network mode issues
- Permission problems

**Fix:**
```bash
# Check if running
docker restart plex

# Wait 30 seconds
sleep 30

# Test
curl -I http://192.168.50.50:32400/web
```

**If still not working:**
```bash
# Get claim token from: https://www.plex.tv/claim/
# Recreate with claim token

docker stop plex
docker rm plex

# Replace YOUR_CLAIM_TOKEN
docker run -d \
  --name plex \
  --restart unless-stopped \
  --network homelab-network \
  -e PLEX_CLAIM=YOUR_CLAIM_TOKEN \
  -e TZ=Europe/London \
  -p 32400:32400 \
  -v ~/homelab/Docker/Data/plex:/config \
  -v /Volumes/HomeLab-4TB/Media:/media \
  lscr.io/linuxserver/plex:latest
```

---

### 3. Sonarr (Port 8989)

**Check Status:**
```bash
docker ps | grep sonarr
docker logs sonarr --tail 30
```

**Fix:**
```bash
# Simple restart usually fixes it
docker restart sonarr

# Wait 10 seconds
sleep 10

# Test
curl -I http://192.168.50.50:8989
```

---

### 4. Transmission (Port 9091)

**Check Status:**
```bash
docker ps | grep transmission
docker logs transmission --tail 30
```

**Common Issues:**
- Port 9091 conflict (sometimes used by Plex)
- Authentication issues

**Fix:**
```bash
# Restart
docker restart transmission

# If that doesn't work, check logs:
docker logs transmission | grep -i error
```

---

### 5. Zigbee2MQTT (Port 8080)

**Check Status:**
```bash
docker ps | grep zigbee
docker logs zigbee2mqtt --tail 50
```

**Common Issues:**
- Port 8080 conflict (many services use this)
- No Zigbee adapter connected
- Permission to access USB device

**Port Conflict Fix:**
```bash
# Check what's using 8080
netstat -an | grep 8080

# If conflict, change Zigbee2MQTT to different port:
docker stop zigbee2mqtt
docker rm zigbee2mqtt

# Recreate on port 8082 instead
docker run -d \
  --name zigbee2mqtt \
  --restart unless-stopped \
  --network homelab-network \
  -p 8082:8080 \
  -v ~/homelab/Docker/Data/zigbee2mqtt:/app/data \
  koenkk/zigbee2mqtt:latest

# Test new port
curl -I http://192.168.50.50:8082
```

---

### 6. CrowdSec (Port 8089)

**Check Status:**
```bash
docker ps | grep crowdsec
docker logs crowdsec --tail 30
```

**Fix:**
```bash
# Restart
docker restart crowdsec

# Wait for startup (takes 20-30 seconds)
sleep 30

# Test
curl -I http://192.168.50.50:8089
```

---

### 7. PhotoPrism (Port 2342)

**Check Status:**
```bash
docker ps | grep photoprism
docker logs photoprism --tail 50
```

**Common Issues:**
- Database not ready
- Permission issues on photo directory
- Resource intensive startup

**Fix:**
```bash
# Restart
docker restart photoprism

# PhotoPrism takes 30-60 seconds to start
sleep 45

# Test
curl -I http://192.168.50.50:2342
```

---

### 8. Kopia (Port 8202)

**Check Status:**
```bash
docker ps | grep kopia
docker logs kopia --tail 30
```

**Fix:**
```bash
# Restart
docker restart kopia

# Test
curl -I http://192.168.50.50:8202
```

---

### 9. Paperless-ngx (Port 8093)

**Check Status:**
```bash
docker ps | grep paperless
docker logs paperless --tail 50
```

**Common Issues:**
- Database startup delay
- Redis not ready
- Long initialization time

**Fix:**
```bash
# Check dependencies first
docker ps | grep paperless

# Should see:
# - paperless
# - paperless-redis
# - paperless-db

# Restart all of them in order
docker restart paperless-redis
docker restart paperless-db
sleep 10
docker restart paperless

# Wait for full startup (60-90 seconds)
sleep 90

# Test
curl -I http://192.168.50.50:8093
```

---

### 10. Dashy (Port 4000)

**Check Status:**
```bash
docker ps | grep dashy
docker logs dashy --tail 30
```

**Common Issues:**
- Config file missing/invalid
- Port conflict

**Fix:**
```bash
# Restart
docker restart dashy

# Test
curl -I http://192.168.50.50:4000
```

---

## Quick Fix Script

Run this to attempt automatic fixes:

```bash
#!/bin/bash

echo "Attempting to fix broken services..."

# List of broken services
SERVICES=(
    "adguard-home"
    "plex"
    "sonarr"
    "transmission"
    "zigbee2mqtt"
    "crowdsec"
    "photoprism"
    "kopia"
    "paperless"
    "dashy"
)

for service in "${SERVICES[@]}"; do
    echo ""
    echo "Fixing: $service"
    
    # Check if running
    if docker ps | grep -q "$service"; then
        echo "  - Restarting..."
        docker restart "$service"
    else
        echo "  - Starting..."
        docker start "$service"
    fi
    
    sleep 5
done

echo ""
echo "Waiting for services to stabilize (60 seconds)..."
sleep 60

echo ""
echo "Testing services..."
./homelab-working-test.sh
```

---

## After Fixing Each Service

### 1. Update Your Custom Homepage

Edit: `~/homelab-deployment/homepage-bookmarks.html`

**Change the service from:**
```html
<a href="http://192.168.50.50:PORT" class="service broken">
```

**To:**
```html
<a href="http://192.168.50.50:PORT" class="service">
```

**And change:**
```html
<div class="status">⚠️ Issue</div>
```

**To:**
```html
<div class="status">✓ Working</div>
```

### 2. Run Test Again

```bash
cd ~/homelab-deployment
./homelab-working-test.sh
```

### 3. Create New Backup

```bash
cd ~/homelab-deployment
./pcloud-backup-setup.sh
```

---

## ✅ COMPLETION CHECKLIST

After fixing each service, mark it off:

- [ ] AdGuard Home - http://192.168.50.50:8084
- [ ] Plex - http://192.168.50.50:32400/web
- [ ] Sonarr - http://192.168.50.50:8989
- [ ] Transmission - http://192.168.50.50:9091
- [ ] Zigbee2MQTT - http://192.168.50.50:8080
- [ ] CrowdSec - http://192.168.50.50:8089
- [ ] PhotoPrism - http://192.168.50.50:2342
- [ ] Kopia - http://192.168.50.50:8202
- [ ] Paperless-ngx - http://192.168.50.50:8093
- [ ] Dashy - http://192.168.50.50:4000

---

## Common Issues Across Services

### Port Conflicts

**Symptom:** "Address already in use"

**Fix:**
```bash
# Find what's using the port
lsof -i :PORT_NUMBER

# Stop the conflicting service
docker stop conflicting-service
```

### Permission Issues

**Symptom:** "Permission denied" in logs

**Fix:**
```bash
# Fix ownership of data directory
sudo chown -R $(whoami) ~/homelab/Docker/Data/service-name

# Or for external drive
sudo chown -R $(whoami) /Volumes/HomeLab-4TB/Docker/Data/service-name
```

### Database Connection Issues

**Symptom:** "Connection refused" to postgres/mariadb/mongodb

**Fix:**
```bash
# Restart database first
docker restart postgres  # or mariadb/mongodb

# Wait 10 seconds
sleep 10

# Then restart the service
docker restart service-name
```

### Network Issues

**Symptom:** "Network not found"

**Fix:**
```bash
# Recreate network
docker network create homelab-network

# Restart service
docker restart service-name
```

---

## When Nothing Works

### Nuclear Option: Recreate Container

```bash
# 1. Stop container
docker stop service-name

# 2. Remove container (keeps data)
docker rm service-name

# 3. Pull fresh image
docker pull service-image:latest

# 4. Recreate using original docker run command
# (Check handbook or compose file for exact command)

# 5. Start it
docker start service-name
```

---

## Next Step

When all services are fixed, move to **STEP D: HANDBOOK REVIEW**
