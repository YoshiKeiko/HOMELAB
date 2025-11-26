#!/bin/bash
#===============================================================================
# Agent DVR Deployment Script for M4 Mac Mini
# Deploys Agent DVR NVR for Tapo C310 camera
#===============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOCKER_BASE="$HOME/docker"
SURVEILLANCE_DIR="$DOCKER_BASE/surveillance"
COMPOSE_FILE="$SURVEILLANCE_DIR/docker-compose.yml"

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}       Agent DVR Deployment for Tapo C310                       ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

#-------------------------------------------------------------------------------
# Step 1: Create directory structure
#-------------------------------------------------------------------------------
echo -e "${YELLOW}[1/5] Creating directory structure...${NC}"

mkdir -p "$SURVEILLANCE_DIR"
mkdir -p "$SURVEILLANCE_DIR/agent-dvr/config"
mkdir -p "$SURVEILLANCE_DIR/agent-dvr/media"
mkdir -p "$SURVEILLANCE_DIR/agent-dvr/commands"

echo -e "${GREEN}✓ Directories created${NC}"

#-------------------------------------------------------------------------------
# Step 2: Create Docker Compose file
#-------------------------------------------------------------------------------
echo -e "${YELLOW}[2/5] Creating Docker Compose configuration...${NC}"

cat > "$COMPOSE_FILE" << 'EOF'
#===============================================================================
# Agent DVR - Surveillance/NVR Stack
# For Tapo C310 and other IP cameras
#===============================================================================

services:
  agent-dvr:
    image: mekayelanik/ispyagentdvr:latest
    container_name: agent-dvr
    restart: unless-stopped
    ports:
      - "8090:8090"      # Web UI
      - "3478:3478/udp"  # TURN server for WebRTC
      - "50000-50010:50000-50010/udp"  # WebRTC ports
    volumes:
      - ./agent-dvr/config:/AgentDVR/Media/XML
      - ./agent-dvr/media:/AgentDVR/Media/WebServerRoot/Media
      - ./agent-dvr/commands:/AgentDVR/Commands
    environment:
      - TZ=Europe/London
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8090"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

networks:
  default:
    name: surveillance
    driver: bridge
EOF

echo -e "${GREEN}✓ Docker Compose file created${NC}"

#-------------------------------------------------------------------------------
# Step 3: Pull the Docker image
#-------------------------------------------------------------------------------
echo -e "${YELLOW}[3/5] Pulling Agent DVR Docker image (ARM64)...${NC}"

cd "$SURVEILLANCE_DIR"
docker compose pull

echo -e "${GREEN}✓ Docker image pulled${NC}"

#-------------------------------------------------------------------------------
# Step 4: Start the container
#-------------------------------------------------------------------------------
echo -e "${YELLOW}[4/5] Starting Agent DVR container...${NC}"

docker compose up -d

# Wait for container to be healthy
echo -e "${YELLOW}    Waiting for Agent DVR to start...${NC}"
sleep 10

# Check if container is running
if docker ps | grep -q agent-dvr; then
    echo -e "${GREEN}✓ Agent DVR container is running${NC}"
else
    echo -e "${RED}✗ Failed to start Agent DVR container${NC}"
    echo -e "${YELLOW}  Checking logs...${NC}"
    docker logs agent-dvr --tail 50
    exit 1
fi

#-------------------------------------------------------------------------------
# Step 5: Display configuration info
#-------------------------------------------------------------------------------
echo -e "${YELLOW}[5/5] Deployment complete!${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}           Agent DVR Successfully Deployed!                    ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Access Information:${NC}"
echo -e "  Web UI:        ${GREEN}http://localhost:8090${NC}"
echo -e "  Network UI:    ${GREEN}http://192.168.68.50:8090${NC}"
echo ""
echo -e "${YELLOW}Container Status:${NC}"
docker ps --filter "name=agent-dvr" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}NEXT STEPS - Add Your Tapo C310 Camera:${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}1. Enable RTSP on your Tapo C310:${NC}"
echo -e "   a) Open Tapo app on your phone"
echo -e "   b) Select your C310 camera"
echo -e "   c) Go to Settings → Advanced Settings → Camera Account"
echo -e "   d) Create a username and password for RTSP access"
echo ""
echo -e "${YELLOW}2. Find your camera's IP address:${NC}"
echo -e "   Check Tapo app → Camera → Settings → Device Info"
echo -e "   Or check your router's DHCP client list"
echo ""
echo -e "${YELLOW}3. Test RTSP stream (optional):${NC}"
echo -e "   ffmpeg -i \"rtsp://USERNAME:PASSWORD@CAMERA_IP:554/stream1\" -frames:v 1 test.jpg"
echo ""
echo -e "${YELLOW}4. Add camera in Agent DVR:${NC}"
echo -e "   a) Open http://192.168.68.50:8090"
echo -e "   b) Click '+ Add Device' → 'Video Source'"
echo -e "   c) Set Source Type: RTSP (FFmpeg)"
echo -e "   d) Enter URL: rtsp://USERNAME:PASSWORD@CAMERA_IP:554/stream1"
echo -e "   e) Click OK"
echo ""
echo -e "${YELLOW}RTSP URL Format:${NC}"
echo -e "   Main stream (1080p): rtsp://user:pass@ip:554/stream1"
echo -e "   Sub stream (SD):     rtsp://user:pass@ip:554/stream2"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}Storage Paths:${NC}"
echo -e "  Config:   $SURVEILLANCE_DIR/agent-dvr/config"
echo -e "  Media:    $SURVEILLANCE_DIR/agent-dvr/media"
echo -e "  Commands: $SURVEILLANCE_DIR/agent-dvr/commands"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Opening Agent DVR in browser...${NC}"

# Open in default browser (macOS)
sleep 2
open "http://localhost:8090"

echo -e "${GREEN}Done! Agent DVR is ready to use.${NC}"
