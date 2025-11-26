#!/bin/bash

################################################################################
# Install AdGuard Home - DNS Ad Blocking
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

HOMELAB_DIR="$HOME/HomeLab"
DOCKER_DATA_DIR="$HOMELAB_DIR/Docker/Data"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Installing AdGuard Home"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Create data directories
log_info "Creating AdGuard directories..."
mkdir -p "$DOCKER_DATA_DIR/adguard/work"
mkdir -p "$DOCKER_DATA_DIR/adguard/conf"

# Create compose file
log_info "Creating docker-compose configuration..."
cat > "$COMPOSE_DIR/adguard.yml" << EOF
services:
  adguard:
    image: adguard/adguardhome:latest
    container_name: adguard
    restart: unless-stopped
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "3002:3000/tcp"
      - "8084:80/tcp"
    volumes:
      - ${DOCKER_DATA_DIR}/adguard/work:/opt/adguardhome/work
      - ${DOCKER_DATA_DIR}/adguard/conf:/opt/adguardhome/conf
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
EOF

# Start AdGuard
log_info "Starting AdGuard Home..."
docker compose -f "$COMPOSE_DIR/adguard.yml" up -d

log_info "Waiting for AdGuard to initialize (15 seconds)..."
sleep 15

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}✓ AdGuard Home Installed!${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${BLUE}Initial Setup:${NC}"
echo "  1. Open: http://localhost:3002"
echo "  2. Click 'Get Started'"
echo "  3. Configure admin interface:"
echo "     - Leave port as 3000 (shows as 3002 externally)"
echo "     - Click 'Next'"
echo "  4. Configure DNS settings:"
echo "     - Leave port as 53"
echo "     - Click 'Next'"
echo "  5. Create admin account:"
echo "     - Username: admin (or your choice)"
echo "     - Password: (choose strong password)"
echo "     - Save to Vaultwarden!"
echo "  6. Click 'Next' → 'Next' → 'Open Dashboard'"
echo ""
echo -e "${BLUE}After Setup:${NC}"
echo "  Admin Interface: http://localhost:8084"
echo "  Setup Interface: http://localhost:3002 (only for first time)"
echo ""
echo -e "${YELLOW}What AdGuard Does:${NC}"
echo "  • Blocks ads network-wide (all devices)"
echo "  • Blocks tracking and malware domains"
echo "  • DNS-level filtering (faster than browser extensions)"
echo "  • Query logs and statistics"
echo "  • Parental controls"
echo "  • Safe search enforcement"
echo ""
echo -e "${YELLOW}To Use AdGuard:${NC}"
echo "  1. Configure your router to use AdGuard as DNS server"
echo "     DNS Server: $(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -1)"
echo "  2. Or configure individual devices to use this IP as DNS"
echo "  3. All traffic will be filtered automatically"
echo ""
echo -e "${YELLOW}Test It's Working:${NC}"
echo "  1. After setup, visit: http://ads-blocker.com/testing/"
echo "  2. You should see 'All tests passed!'"
echo ""
echo -e "${GREEN}Add to Heimdall:${NC}"
echo "  Title: AdGuard Home"
echo "  URL: http://localhost:8084"
echo ""