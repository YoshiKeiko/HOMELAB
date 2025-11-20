#!/bin/bash

################################################################################
# QUICK HOMELAB TEST - Uses network IP instead of localhost
################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MAC_IP="192.168.50.50"

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  QUICK HOMELAB TEST - Testing via $MAC_IP${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Key services to test
SERVICES="
portainer:9000
heimdall:8090
plex:32400
homeassistant:8123
grafana:3003
sonarr:8989
radarr:7878
overseerr:5055
adguard-home:8084
"

WORKING=0
BROKEN=0

for service in $SERVICES; do
    name=$(echo $service | cut -d: -f1)
    port=$(echo $service | cut -d: -f2)
    
    if timeout 2 curl -f -s -o /dev/null "http://$MAC_IP:$port" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $name → http://$MAC_IP:$port"
        WORKING=$((WORKING + 1))
    else
        echo -e "${RED}✗${NC} $name → http://$MAC_IP:$port"
        BROKEN=$((BROKEN + 1))
    fi
done

echo ""
echo -e "${GREEN}Working: $WORKING${NC} | ${RED}Not Responding: $BROKEN${NC}"
echo ""

if [ $WORKING -gt 0 ]; then
    echo -e "${GREEN}✓ Services are accessible!${NC}"
    echo ""
    echo "Quick Access URLs:"
    echo "  Heimdall:  http://$MAC_IP:8090"
    echo "  Portainer: http://$MAC_IP:9000"
    echo "  Plex:      http://$MAC_IP:32400/web"
else
    echo -e "${RED}⚠️  No services responding on $MAC_IP${NC}"
    echo ""
    echo "Possible issues:"
    echo "  1. Check Mac IP: ifconfig | grep 192.168.50"
    echo "  2. Check containers: docker ps"
    echo "  3. Check firewall: System Settings → Network → Firewall"
fi

