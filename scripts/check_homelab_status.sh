#!/bin/bash

################################################################################
# HomeLab Inventory & Status Checker
# Shows what's running, what's installed, and what's missing
################################################################################

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  HomeLab Service Inventory - M4 Mac Mini"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Get all running containers
RUNNING_CONTAINERS=$(docker ps --format "{{.Names}}")

# Function to check if container is running
check_service() {
    local service_name=$1
    local display_name=$2
    local port=$3
    
    if echo "$RUNNING_CONTAINERS" | grep -q "^${service_name}$"; then
        echo -e "${GREEN}✓${NC} ${display_name}" | awk '{printf "%-40s", $0}'
        if [ ! -z "$port" ]; then
            echo -e "${CYAN}http://localhost:${port}${NC}"
        else
            echo ""
        fi
        return 0
    else
        echo -e "${RED}✗${NC} ${display_name}" | awk '{printf "%-40s", $0}'
        echo -e "${GRAY}Not running${NC}"
        return 1
    fi
}

# Counters
TOTAL=0
RUNNING=0

################################################################################
# CORE INFRASTRUCTURE (2 services)
################################################################################

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}CORE INFRASTRUCTURE${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "portainer" "Portainer" "9000" && ((RUNNING++)); ((TOTAL++))
check_service "watchtower" "Watchtower" "" && ((RUNNING++)); ((TOTAL++))

################################################################################
# DATABASES (5 services)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}DATABASES${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "postgres" "PostgreSQL" "5432" && ((RUNNING++)); ((TOTAL++))
check_service "mariadb" "MariaDB" "3306" && ((RUNNING++)); ((TOTAL++))
check_service "mongodb" "MongoDB" "27017" && ((RUNNING++)); ((TOTAL++))
check_service "redis" "Redis" "6379" && ((RUNNING++)); ((TOTAL++))
check_service "influxdb" "InfluxDB" "8086" && ((RUNNING++)); ((TOTAL++))

################################################################################
# MEDIA SERVICES (13 services - but only 7 ARM64 compatible)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}MEDIA SERVICES${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "plex" "Plex Media Server" "32400/web" && ((RUNNING++)); ((TOTAL++))
check_service "jellyfin" "Jellyfin" "8096" && ((RUNNING++)); ((TOTAL++))
check_service "radarr" "Radarr (Movies)" "7878" && ((RUNNING++)); ((TOTAL++))
check_service "sonarr" "Sonarr (TV)" "8989" && ((RUNNING++)); ((TOTAL++))
check_service "prowlarr" "Prowlarr (Indexer)" "9696" && ((RUNNING++)); ((TOTAL++))
check_service "overseerr" "Overseerr (Requests)" "5055" && ((RUNNING++)); ((TOTAL++))
check_service "transmission" "Transmission" "9091" && ((RUNNING++)); ((TOTAL++))

# ARM64 incompatible (skipped)
echo -e "${GRAY}○ Lidarr (Music)                        Skipped - No ARM64${NC}"
echo -e "${GRAY}○ Readarr (Books)                       Skipped - No ARM64${NC}"
echo -e "${GRAY}○ Bazarr (Subtitles)                    Skipped - No ARM64${NC}"
echo -e "${GRAY}○ Tautulli (Plex Stats)                 Skipped - No ARM64${NC}"
echo -e "${GRAY}○ qBittorrent                           Skipped - No ARM64${NC}"
echo -e "${GRAY}○ SABnzbd                               Skipped - No ARM64${NC}"

################################################################################
# AI & DEVELOPMENT (5 services)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}AI & DEVELOPMENT${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "ollama" "Ollama (LLM)" "11434" && ((RUNNING++)); ((TOTAL++))
check_service "openwebui" "Open WebUI" "3000" && ((RUNNING++)); ((TOTAL++))
check_service "codeserver" "Code Server (VS Code)" "8443" && ((RUNNING++)); ((TOTAL++))
check_service "jupyter" "Jupyter Notebook" "8888" && ((RUNNING++)); ((TOTAL++))
check_service "gitea" "Gitea (Git Server)" "3001" && ((RUNNING++)); ((TOTAL++))

################################################################################
# SMART HOME (5 services)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}SMART HOME${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "homeassistant" "Home Assistant" "8123" && ((RUNNING++)); ((TOTAL++))
check_service "nodered" "Node-RED" "1880" && ((RUNNING++)); ((TOTAL++))
check_service "mosquitto" "Mosquitto MQTT" "1883" && ((RUNNING++)); ((TOTAL++))
check_service "zigbee2mqtt" "Zigbee2MQTT" "8080" && ((RUNNING++)); ((TOTAL++))
check_service "esphome" "ESPHome" "6052" && ((RUNNING++)); ((TOTAL++))

################################################################################
# NETWORK SERVICES (4 services - RustDesk removed)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}NETWORK SERVICES${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "adguard" "AdGuard Home" "3002" && ((RUNNING++)); ((TOTAL++))
check_service "nginx-proxy-manager" "Nginx Proxy Manager" "81" && ((RUNNING++)); ((TOTAL++))
check_service "wireguard" "WireGuard VPN" "51820" && ((RUNNING++)); ((TOTAL++))

# Check Tailscale (not a Docker container)
if command -v tailscale &> /dev/null && tailscale status &> /dev/null; then
    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null)
    echo -e "${GREEN}✓${NC} Tailscale VPN" | awk '{printf "%-40s", $0}'
    echo -e "${CYAN}${TAILSCALE_IP}${NC}"
    ((RUNNING++))
else
    echo -e "${RED}✗${NC} Tailscale VPN" | awk '{printf "%-40s", $0}'
    echo -e "${GRAY}Not running${NC}"
fi
((TOTAL++))

################################################################################
# MONITORING (8 services)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}MONITORING${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "prometheus" "Prometheus" "9090" && ((RUNNING++)); ((TOTAL++))
check_service "grafana" "Grafana" "3003" && ((RUNNING++)); ((TOTAL++))
check_service "loki" "Loki (Logs)" "3100" && ((RUNNING++)); ((TOTAL++))
check_service "promtail" "Promtail (Log Shipper)" "" && ((RUNNING++)); ((TOTAL++))
check_service "node-exporter" "Node Exporter" "9100" && ((RUNNING++)); ((TOTAL++))
check_service "cadvisor" "cAdvisor" "8085" && ((RUNNING++)); ((TOTAL++))
check_service "uptime-kuma" "Uptime Kuma" "3004" && ((RUNNING++)); ((TOTAL++))
check_service "netdata" "Netdata" "19999" && ((RUNNING++)); ((TOTAL++))

################################################################################
# STORAGE & BACKUP (4 services)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}STORAGE & BACKUP${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "nextcloud" "Nextcloud" "8086" && ((RUNNING++)); ((TOTAL++))
check_service "syncthing" "Syncthing" "8384" && ((RUNNING++)); ((TOTAL++))
check_service "duplicati" "Duplicati" "8200" && ((RUNNING++)); ((TOTAL++))
check_service "filebrowser" "File Browser" "8087" && ((RUNNING++)); ((TOTAL++))

################################################################################
# SECURITY (3 services)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}SECURITY${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "vaultwarden" "Vaultwarden (Password Mgr)" "8088" && ((RUNNING++)); ((TOTAL++))
check_service "fail2ban" "Fail2ban" "" && ((RUNNING++)); ((TOTAL++))
check_service "crowdsec" "CrowdSec" "8089" && ((RUNNING++)); ((TOTAL++))

################################################################################
# DASHBOARDS (4 services)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}DASHBOARDS${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "heimdall" "Heimdall" "8090" && ((RUNNING++)); ((TOTAL++))
check_service "homer" "Homer" "8091" && ((RUNNING++)); ((TOTAL++))
check_service "dashy" "Dashy" "4000" && ((RUNNING++)); ((TOTAL++))
check_service "organizr" "Organizr" "8092" && ((RUNNING++)); ((TOTAL++))

################################################################################
# UTILITIES (4 services)
################################################################################

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}UTILITIES${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

check_service "paperless" "Paperless-ngx" "8093" && ((RUNNING++)); ((TOTAL++))
check_service "photoprism" "PhotoPrism" "2342" && ((RUNNING++)); ((TOTAL++))
check_service "calibre" "Calibre" "8094" && ((RUNNING++)); ((TOTAL++))
check_service "freshrss" "FreshRSS" "8096" && ((RUNNING++)); ((TOTAL++))

################################################################################
# SUMMARY
################################################################################

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}SUMMARY${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""

PERCENTAGE=$((RUNNING * 100 / TOTAL))

echo -e "Total Services Planned:  ${BLUE}${TOTAL}${NC}"
echo -e "Currently Running:       ${GREEN}${RUNNING}${NC}"
echo -e "Not Yet Installed:       ${RED}$((TOTAL - RUNNING))${NC}"
echo -e "Completion:              ${CYAN}${PERCENTAGE}%${NC}"
echo ""

if [ $RUNNING -lt $TOTAL ]; then
    MISSING=$((TOTAL - RUNNING))
    echo -e "${YELLOW}To install the remaining ${MISSING} services, run:${NC}"
    echo "  ~/Downloads/install-remaining-services.sh"
    echo ""
fi

################################################################################
# DOCKER STATS
################################################################################

echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}DOCKER RESOURCE USAGE${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Get container count
CONTAINER_COUNT=$(docker ps -q | wc -l | tr -d ' ')
echo "Running Containers: ${CONTAINER_COUNT}"

# Get image count
IMAGE_COUNT=$(docker images -q | wc -l | tr -d ' ')
echo "Docker Images:      ${IMAGE_COUNT}"

# Get volume count
VOLUME_COUNT=$(docker volume ls -q | wc -l | tr -d ' ')
echo "Docker Volumes:     ${VOLUME_COUNT}"

# Get network count
NETWORK_COUNT=$(docker network ls | grep -v "bridge\|host\|none" | wc -l | tr -d ' ')
echo "Docker Networks:    ${NETWORK_COUNT}"

echo ""

# System resource usage
echo "System Resources:"
df -h "$HOME/HomeLab" | tail -1 | awk '{print "  Disk Usage:     " $3 " / " $2 " (" $5 ")"}'

echo ""

################################################################################
# QUICK ACCESS
################################################################################

echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}QUICK ACCESS${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "View all running containers:"
echo "  docker ps --format 'table {{.Names}}\t{{.Status}}'"
echo ""
echo "View logs for a service:"
echo "  docker logs <container-name>"
echo ""
echo "Restart a service:"
echo "  docker restart <container-name>"
echo ""
echo "Stop all services:"
echo "  docker stop \$(docker ps -q)"
echo ""

# Save report
REPORT_FILE="$HOME/HomeLab/docs/service-inventory-$(date +%Y%m%d-%H%M%S).txt"
{
    echo "HomeLab Service Inventory Report"
    echo "Generated: $(date)"
    echo ""
    echo "Total Services: $TOTAL"
    echo "Running: $RUNNING"
    echo "Not Installed: $((TOTAL - RUNNING))"
    echo "Completion: ${PERCENTAGE}%"
    echo ""
    echo "Running Containers:"
    docker ps --format "  - {{.Names}}: {{.Status}}"
} > "$REPORT_FILE"

echo "Report saved: $REPORT_FILE"
echo ""