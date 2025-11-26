#!/bin/bash

################################################################################
# Fix Duplicati Port Conflict (Port 8200 in use by OrbStack)
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         FIX DUPLICATI PORT CONFLICT                            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

log_error "Port 8200 is in use by OrbStack"
echo ""
echo "Duplicati can't use port 8200 because OrbStack is already using it."
echo "We'll change Duplicati to port 8201 instead."
echo ""

log_step "Step 1: Stopping and removing old Duplicati..."
echo ""

docker stop duplicati 2>/dev/null || true
docker rm duplicati 2>/dev/null || true

log_info "Old container removed"
echo ""

log_step "Step 2: Creating Duplicati on port 8201..."
echo ""

# Ensure directory exists
mkdir -p ~/HomeLab/Docker/Data/duplicati

# Create new container on port 8201
docker run -d \
  --name duplicati \
  --restart unless-stopped \
  --network homelab-net \
  -p 8201:8200 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -v ~/HomeLab/Docker/Data/duplicati:/config \
  -v ~/HomeLab/Docker/Data:/source \
  -v /Volumes/HomeLab-4TB:/backups \
  lscr.io/linuxserver/duplicati:latest

if [ $? -eq 0 ]; then
    log_info "Duplicati created on port 8201"
    echo ""
    
    log_step "Waiting 15 seconds for startup..."
    for i in {15..1}; do
        echo -ne "\rStarting in $i seconds...  "
        sleep 1
    done
    echo -e "\r${GREEN}Duplicati is ready!                ${NC}"
    
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║                  ✓ DUPLICATI IS READY                         ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
    
    echo "Access Duplicati at:"
    echo "  ${CYAN}http://localhost:8201${NC}"
    echo ""
    echo "  ${YELLOW}Note: Port changed from 8200 to 8201 (OrbStack conflict)${NC}"
    echo ""
    
    # Check if it's responding
    log_step "Testing connection..."
    sleep 5
    
    if curl -s http://localhost:8201 >/dev/null 2>&1; then
        log_info "Duplicati is responding!"
        echo ""
        echo "Opening in browser..."
        open http://localhost:8201 2>/dev/null || echo "Open manually: http://localhost:8201"
    else
        echo ""
        echo "Still starting up, give it another 10 seconds..."
        echo "Then open: ${CYAN}http://localhost:8201${NC}"
    fi
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Next Steps"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "1. Open Duplicati: ${CYAN}http://localhost:8201${NC}"
    echo ""
    echo "2. Configure pCloud backup:"
    echo "   - Add backup job"
    echo "   - Storage: WebDAV"
    echo "   - Server: https://webdav.pcloud.com"
    echo "   - Path: /HomeLab-Backups"
    echo "   - Source: /source (maps to Docker/Data)"
    echo ""
    echo "3. Schedule: Daily at 3 AM"
    echo ""
    echo "Complete guide: ~/HomeLab/docs/PCLOUD_BACKUP_COMPLETE_GUIDE.md"
    echo ""
    
else
    log_error "Failed to create Duplicati"
    echo ""
    echo "Check Docker is running:"
    echo "  docker ps"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Verify"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Show container status
if docker ps | grep -q duplicati; then
    log_info "Duplicati is running"
    echo ""
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "NAMES|duplicati"
    echo ""
    echo "Access: ${CYAN}http://localhost:8201${NC}"
else
    log_error "Duplicati failed to start"
    echo ""
    echo "Check logs:"
    echo "  docker logs duplicati"
fi

# Update documentation
cat > ~/HomeLab/docs/DUPLICATI_PORT.txt << 'EOFDOC'
╔═══════════════════════════════════════════════════════════════╗
║              DUPLICATI PORT INFORMATION                        ║
╚═══════════════════════════════════════════════════════════════╝

⚠️  PORT CHANGED DUE TO ORBSTACK CONFLICT

Original Port:  8200 (blocked by OrbStack)
New Port:       8201

Access Duplicati:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

From M4 Mac:
  http://localhost:8201

From MacBook Air:
  http://M4-IP:8201

Port Mapping:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Container Port: 8200 (internal)
Host Port:      8201 (external)

Docker Command:
  -p 8201:8200

Why Change?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

OrbStack uses port 8200 for its own services.
Duplicati moved to 8201 to avoid conflict.

Both services can now run simultaneously.

Quick Commands:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Open Duplicati:
  open http://localhost:8201

Check status:
  docker ps | grep duplicati

Restart:
  docker restart duplicati

View logs:
  docker logs duplicati

═══════════════════════════════════════════════════════════════
Created: $(date)
═══════════════════════════════════════════════════════════════
EOFDOC

echo ""
echo "Port info saved to: ~/HomeLab/docs/DUPLICATI_PORT.txt"
echo ""