# Create the Scripts directory if needed
mkdir -p ~/homelab/Scripts

# Create and execute the script directly
bash << 'SCRIPTEOF'
#!/bin/bash

# Fix AdGuard Home Networking - Switch from host to bridge mode
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}AdGuard Home Network Mode Fix${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# Step 1: Create docker-compose.yml
echo -e "${YELLOW}Step 1: Creating docker-compose.yml...${NC}"
mkdir -p ~/homelab/Docker
cat > ~/homelab/Docker/adguard-compose.yml << 'COMPOSE_EOF'
services:
  adguard-home:
    image: adguard/adguardhome:latest
    container_name: adguard-home
    restart: unless-stopped
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "3000:3000/tcp"
      - "3001:3001/tcp"
      - "853:853/tcp"
      - "784:784/udp"
      - "8853:8853/udp"
      - "5443:5443/tcp"
      - "5443:5443/udp"
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

# Step 2: Stop container
echo -e "${YELLOW}Step 2: Stopping container...${NC}"
docker stop adguard-home || echo "Container not running"
echo -e "${GREEN}✓ Stopped${NC}"

# Step 3: Remove container
echo -e "${YELLOW}Step 3: Removing container...${NC}"
docker rm adguard-home || echo "Container already removed"
echo -e "${GREEN}✓ Removed${NC}"

# Step 4: Start with new config
echo -e "${YELLOW}Step 4: Starting with bridge networking...${NC}"
cd ~/homelab/Docker
docker compose -f adguard-compose.yml up -d
echo -e "${GREEN}✓ Started${NC}"

# Step 5: Verify
echo ""
echo -e "${YELLOW}Verifying...${NC}"
sleep 3
docker ps | grep adguard

echo ""
echo -e "${GREEN}Complete! Check Query Log for device IPs.${NC}"
SCRIPTEOF