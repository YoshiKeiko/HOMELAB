#!/bin/bash

################################################################################
# Automated Prowlarr DNS/SSL Fix Script
# Accounts for AdGuard DNS setup
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

COMPOSE_FILE="$HOME/HomeLab/Docker/Compose/media.yml"

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         FIX PROWLARR DNS/SSL ISSUES                           ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Check AdGuard
if docker ps | grep -q adguard; then
    ADGUARD_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' adguard)
    log_info "AdGuard detected at: $ADGUARD_IP"
    USE_ADGUARD=true
else
    log_info "AdGuard not detected, using public DNS"
    USE_ADGUARD=false
fi

# Backup
log_step "Backing up configuration..."
cp "$COMPOSE_FILE" "$COMPOSE_FILE.backup-$(date +%Y%m%d-%H%M%S)"
log_info "Backup created"

# Stop Prowlarr
log_step "Stopping Prowlarr..."
docker stop prowlarr 2>/dev/null || true

# Update compose file
log_step "Updating compose file..."

# Create new compose with DNS settings
if [ "$USE_ADGUARD" = true ]; then
    DNS_SERVERS="      - $ADGUARD_IP
      - 1.1.1.1
      - 8.8.8.8"
else
    DNS_SERVERS="      - 1.1.1.1
      - 8.8.8.8"
fi

# Read and update file
awk -v dns="$DNS_SERVERS" '
/^  prowlarr:/ { in_prowlarr=1 }
in_prowlarr && /^  [a-z]/ && !/^  prowlarr:/ { 
    if (!dns_added) {
        print "    dns:"
        print dns
        print "    extra_hosts:"
        print "      - \"host.docker.internal:host-gateway\""
        dns_added=1
    }
    in_prowlarr=0 
}
{ print }
' "$COMPOSE_FILE" > "$COMPOSE_FILE.tmp" && mv "$COMPOSE_FILE.tmp" "$COMPOSE_FILE"

log_info "DNS configuration added"

# Add FlareSolverr if not present
if ! grep -q "flaresolverr:" "$COMPOSE_FILE"; then
    log_step "Adding FlareSolverr..."
    
    cat >> "$COMPOSE_FILE.tmp" << EOFFLARE

  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    restart: unless-stopped
    ports:
      - "8191:8191"
    environment:
      - LOG_LEVEL=info
      - TZ=Europe/London
    networks:
      - homelab-net
    dns:
$DNS_SERVERS
EOFFLARE

    # Insert before networks
    sed '/^networks:/,$d' "$COMPOSE_FILE" > "$COMPOSE_FILE.new"
    cat "$COMPOSE_FILE.tmp" >> "$COMPOSE_FILE.new"
    echo "" >> "$COMPOSE_FILE.new"
    sed -n '/^networks:/,$p' "$COMPOSE_FILE" >> "$COMPOSE_FILE.new"
    mv "$COMPOSE_FILE.new" "$COMPOSE_FILE"
    rm "$COMPOSE_FILE.tmp"
    
    log_info "FlareSolverr added"
fi

# Restart services
log_step "Starting services..."
cd ~/HomeLab/Docker/Compose
docker compose -f media.yml up -d flaresolverr 2>/dev/null || true
sleep 3
docker compose -f media.yml up -d prowlarr

echo ""
log_info "Waiting for services to start..."
sleep 10

# Verify
log_step "Verifying..."
if docker ps | grep -q prowlarr; then
    log_info "Prowlarr is running"
else
    log_error "Prowlarr failed to start"
    exit 1
fi

# Test DNS
if docker exec prowlarr nslookup cloudflare.com >/dev/null 2>&1; then
    log_info "DNS resolution working"
else
    log_error "DNS resolution failed"
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    ✓ FIX COMPLETE!                            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo ""
echo "1. Open Prowlarr: ${CYAN}http://localhost:9696${NC}"
echo ""
echo "2. Test adding indexer:"
echo "   Indexers → Add Indexer → Search: 1337x"
echo "   Should work now!"
echo ""
echo "3. If still getting Cloudflare errors:"
echo "   Settings → Indexers → Proxies → Add → FlareSolverr"
echo "   Host: http://flaresolverr:8191"
echo ""

if [ "$USE_ADGUARD" = true ]; then
    echo "4. ${MAGENTA}AdGuard Note:${NC} If indexers still fail, add to AdGuard allowlist:"
    echo "   Open AdGuard: ${CYAN}http://localhost:3000${NC}"
    echo "   Filters → Custom filtering rules → Add:"
    echo "   ${CYAN}@@||1337x.to^${NC}"
    echo "   ${CYAN}@@||torrentgalaxy.to^${NC}"
    echo ""
fi

echo "Logs: ${CYAN}docker logs prowlarr${NC}"
echo ""