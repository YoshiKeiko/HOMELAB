#!/bin/bash

################################################################################
# HOMELAB SERVICE TEST - macOS Compatible
################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MAC_IP="192.168.50.50"

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  HOMELAB SERVICE TEST${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Test function (no timeout command needed)
test_service() {
    local name=$1
    local port=$2
    
    if curl -f -s -m 2 -o /dev/null "http://$MAC_IP:$port" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $name (http://$MAC_IP:$port)"
        return 0
    else
        echo -e "${RED}✗${NC} $name (http://$MAC_IP:$port)"
        return 1
    fi
}

echo -e "${YELLOW}Infrastructure:${NC}"
test_service "Portainer      " 9000
test_service "Nginx Proxy Mgr" 81
test_service "AdGuard Home   " 8084

echo ""
echo -e "${YELLOW}Media Services:${NC}"
test_service "Plex           " 32400
test_service "Jellyfin       " 8096
test_service "Sonarr         " 8989
test_service "Radarr         " 7878
test_service "Prowlarr       " 9696
test_service "Overseerr      " 5055
test_service "Transmission   " 9091
test_service "Tautulli       " 8181

echo ""
echo -e "${YELLOW}Smart Home:${NC}"
test_service "Home Assistant " 8123
test_service "Node-RED       " 1880
test_service "Zigbee2MQTT    " 8080

echo ""
echo -e "${YELLOW}AI Services:${NC}"
test_service "Open WebUI     " 3000
test_service "Jupyter        " 8888
test_service "Ollama         " 11434

echo ""
echo -e "${YELLOW}Monitoring:${NC}"
test_service "Grafana        " 3003
test_service "Prometheus     " 9090
test_service "Uptime Kuma    " 3004
test_service "Netdata        " 19999

echo ""
echo -e "${YELLOW}Security:${NC}"
test_service "Vaultwarden    " 8088
test_service "CrowdSec       " 8089

echo ""
echo -e "${YELLOW}Storage:${NC}"
test_service "Nextcloud      " 8097
test_service "PhotoPrism     " 2342
test_service "File Browser   " 8087
test_service "Syncthing      " 8384
test_service "Kopia          " 8202

echo ""
echo -e "${YELLOW}Productivity:${NC}"
test_service "Paperless-ngx  " 8093
test_service "FreshRSS       " 8098
test_service "Calibre        " 8094
test_service "Code Server    " 8443
test_service "Gitea          " 3001

echo ""
echo -e "${YELLOW}Dashboards:${NC}"
test_service "Heimdall       " 8090
test_service "Homer          " 8091
test_service "Dashy          " 4000
test_service "Organizr       " 8092

echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Testing complete!${NC}"
echo ""
echo -e "Main Dashboard: ${BLUE}http://$MAC_IP:8090${NC}"
echo ""

