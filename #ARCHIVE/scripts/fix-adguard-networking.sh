#!/bin/bash

# Fix AdGuard Home Networking - Switch from host to bridge mode
# This will allow AdGuard Home to show actual device IPs instead of ::1 localhost

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}AdGuard Home Network Mode Fix${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Step 1: Create docker-compose.yml
echo -e "${YELLOW}Step 1: Creating docker-compose.yml for AdGuard Home...${NC}"
mkdir -p ~/homelab/Docker
cat > ~/homelab/Docker/adguard-compose.yml << 'COMPOSE_EOF'
services:
  adguard-home:
    image: adguard/adguardhome:latest
    container_name: adguard-home
    restart: unless-stopped
    ports:
      - "53:53/tcp"      # DNS
      - "53:53/udp"      # DNS
      - "3000:3000/tcp"  # Web interface (initial setup)
      - "3001:3001/tcp"  # Web interface (after setup)
      - "853:853/tcp"    # DNS-over-TLS
      - "784:784/udp"    # DNS-over-QUIC
      - "8853:8853/udp"  # DNS-over-QUIC
      - "5443:5443/tcp"  # DNSCrypt
      - "5443:5443/udp"  # DNSCrypt
    volumes:
      - /Volumes/HomeLab-4TB/Docker/Data/adguard/work:/opt/adguardhome/work
      - /Volumes/HomeLab-4TB/Docker/Data/adguard/conf:/opt/adguardhome/conf
    networks:
      - homelab-network

networks:
  homelab-network:
    external: true
COMPOSE_EOF
echo -e "${GREEN}✓ docker-compose.yml created${NC}"
echo ""

# Step 2: Stop the old container
echo -e "${YELLOW}Step 2: Stopping current AdGuard Home container...${NC}"
if docker ps -q -f name=adguard-home > /dev/null 2>&1; then
    docker stop adguard-home
    echo -e "${GREEN}✓ Container stopped${NC}"
else
    echo -e "${YELLOW}! Container not running${NC}"
fi
echo ""

# Step 3: Remove the old container
echo -e "${YELLOW}Step 3: Removing old container...${NC}"
if docker ps -aq -f name=adguard-home > /dev/null 2>&1; then
    docker rm adguard-home
    echo -e "${GREEN}✓ Container removed${NC}"
else
    echo -e "${YELLOW}! Container already removed${NC}"
fi
echo ""

# Step 4: Start with new configuration
echo -e "${YELLOW}Step 4: Starting AdGuard Home with bridge networking...${NC}"
cd ~/homelab/Docker
docker compose -f adguard-compose.yml up -d
echo -e "${GREEN}✓ AdGuard Home started${NC}"
echo ""

# Step 5: Verify
echo -e "${YELLOW}Step 5: Verifying container status...${NC}"
sleep 3
if docker ps | grep -q adguard-home; then
    echo -e "${GREEN}✓ AdGuard Home is running${NC}"
    docker ps | grep adguard-home
else
    echo -e "${RED}✗ AdGuard Home failed to start${NC}"
    exit 1
fi
echo ""

echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}AdGuard Home Network Fix Complete!${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Wait 30 seconds for AdGuard Home to fully start"
echo "2. Open AdGuard Home web interface: http://192.168.68.50:3000"
echo "3. Check Query Log - you should now see device IPs instead of ::1"
echo "4. Test from another device to verify"
echo ""
echo -e "${YELLOW}Note:${NC} All your AdGuard Home settings and blocklists are preserved."

