#!/bin/bash

################################################################################
# HomeLab Service URL Checker
# Tests all services and reports what's actually running
################################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m'

log_online() { echo -e "${GREEN}[✓ ONLINE]${NC} $1"; }
log_offline() { echo -e "${RED}[✗ OFFLINE]${NC} $1"; }
log_info() { echo -e "${CYAN}[INFO]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         HOMELAB SERVICE CHECKER                                ║"
echo "║         Testing all URLs to see what's actually running        ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Create results file
RESULTS_FILE=~/HomeLab/SERVICE_CHECK_RESULTS_$(date +%Y%m%d_%H%M%S).txt
ONLINE_FILE=~/HomeLab/SERVICES_ONLINE.txt
OFFLINE_FILE=~/HomeLab/SERVICES_OFFLINE.txt

cat > "$RESULTS_FILE" << 'EOFHEADER'
╔═══════════════════════════════════════════════════════════════╗
║              HOMELAB SERVICE CHECK RESULTS                     ║
╚═══════════════════════════════════════════════════════════════╝

Scan Date: $(date)

EOFHEADER

# Initialize counters
ONLINE_COUNT=0
OFFLINE_COUNT=0
TOTAL_COUNT=0

# Initialize result files
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" > "$ONLINE_FILE"
echo "  SERVICES ONLINE" >> "$ONLINE_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$ONLINE_FILE"
echo "" >> "$ONLINE_FILE"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" > "$OFFLINE_FILE"
echo "  SERVICES OFFLINE OR NOT INSTALLED" >> "$OFFLINE_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$OFFLINE_FILE"
echo "" >> "$OFFLINE_FILE"

# Function to test URL
test_url() {
    local name="$1"
    local url="$2"
    local port="$3"
    
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    
    # Skip if no URL
    if [ -z "$url" ] || [ "$url" = "null" ]; then
        log_offline "$name (No web interface)"
        echo "$name - No web interface" >> "$OFFLINE_FILE"
        OFFLINE_COUNT=$((OFFLINE_COUNT + 1))
        return
    fi
    
    # Test connection with timeout
    if curl -s -f -m 3 "$url" > /dev/null 2>&1; then
        log_online "$name - $url"
        echo "✓ $name - $url" >> "$ONLINE_FILE"
        echo "✓ ONLINE: $name - $url" >> "$RESULTS_FILE"
        ONLINE_COUNT=$((ONLINE_COUNT + 1))
    else
        # Try just the port
        if nc -z localhost "$port" 2>/dev/null; then
            log_online "$name - Port $port open (may need login/setup)"
            echo "✓ $name - Port $port (needs config)" >> "$ONLINE_FILE"
            echo "✓ PORT OPEN: $name - Port $port (needs login or initial setup)" >> "$RESULTS_FILE"
            ONLINE_COUNT=$((ONLINE_COUNT + 1))
        else
            log_offline "$name - $url (Port $port not responding)"
            echo "✗ $name - $url (Port $port)" >> "$OFFLINE_FILE"
            echo "✗ OFFLINE: $name - $url (Port $port)" >> "$RESULTS_FILE"
            OFFLINE_COUNT=$((OFFLINE_COUNT + 1))
        fi
    fi
}

echo "Testing services... (this may take 1-2 minutes)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Media Services"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_url "Plex" "http://localhost:32400/web" "32400"
test_url "Jellyfin" "http://localhost:8096" "8096"
test_url "Radarr" "http://localhost:7878" "7878"
test_url "Sonarr" "http://localhost:8989" "8989"
test_url "Prowlarr" "http://localhost:9696" "9696"
test_url "Overseerr" "http://localhost:5055" "5055"
test_url "Transmission" "http://localhost:9091" "9091"
test_url "Tautulli" "http://localhost:8181" "8181"
test_url "Bazarr" "http://localhost:6767" "6767"
test_url "Lidarr" "http://localhost:8686" "8686"
test_url "Readarr" "http://localhost:8787" "8787"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Smart Home"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_url "Home Assistant" "http://localhost:8123" "8123"
test_url "Node-RED" "http://localhost:1880" "1880"
test_url "ESPHome" "http://localhost:6052" "6052"
test_url "Zigbee2MQTT" "http://localhost:8080" "8080"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Monitoring"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_url "Grafana" "http://localhost:3000" "3000"
test_url "Prometheus" "http://localhost:9090" "9090"
test_url "Netdata" "http://localhost:19999" "19999"
test_url "Uptime Kuma" "http://localhost:3001" "3001"
test_url "cAdvisor" "http://localhost:8085" "8085"
test_url "Loki" "http://localhost:3100" "3100"
test_url "InfluxDB" "http://localhost:8086" "8086"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Dashboards"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_url "Heimdall" "http://localhost:8090" "8090"
test_url "Homer" "http://localhost:8091" "8091"
test_url "Dashy" "http://localhost:4000" "4000"
test_url "Organizr" "http://localhost:8092" "8092"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Storage & Backup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_url "Nextcloud" "http://localhost:8080" "8080"
test_url "Kopia" "http://localhost:8202" "8202"
test_url "Duplicati" "http://localhost:8200" "8200"
test_url "Syncthing" "http://localhost:8384" "8384"
test_url "File Browser" "http://localhost:8087" "8087"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Productivity"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_url "Paperless-ngx" "http://localhost:8000" "8000"
test_url "PhotoPrism" "http://localhost:2342" "2342"
test_url "Calibre" "http://localhost:8081" "8081"
test_url "FreshRSS" "http://localhost:8082" "8082"
test_url "Gitea" "http://localhost:3002" "3002"
test_url "Code Server" "http://localhost:8443" "8443"
test_url "Jupyter" "http://localhost:8888" "8888"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Security & Network"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_url "AdGuard Home" "http://localhost:3080" "3080"
test_url "Vaultwarden" "http://localhost:8280" "8280"
test_url "CrowdSec" "http://localhost:8089" "8089"
test_url "Nginx Proxy Manager" "http://localhost:81" "81"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Management"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

test_url "Portainer" "http://localhost:9000" "9000"
test_url "VNC Desktop" "http://localhost:3050" "3050"
test_url "OpenWebUI" "http://localhost:3003" "3003"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Backend Services (No Web UI)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check backend services via nc (netcat)
if nc -z localhost 1883 2>/dev/null; then
    log_online "Mosquitto MQTT - Port 1883"
    echo "✓ Mosquitto MQTT - Port 1883" >> "$ONLINE_FILE"
    ONLINE_COUNT=$((ONLINE_COUNT + 1))
else
    log_offline "Mosquitto MQTT - Port 1883"
    echo "✗ Mosquitto MQTT - Port 1883" >> "$OFFLINE_FILE"
    OFFLINE_COUNT=$((OFFLINE_COUNT + 1))
fi

TOTAL_COUNT=$((TOTAL_COUNT + 1))

# Check Docker containers
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Docker Container Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "" >> "$RESULTS_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$RESULTS_FILE"
echo "  DOCKER CONTAINERS RUNNING" >> "$RESULTS_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

CONTAINER_COUNT=$(docker ps -q | wc -l | tr -d ' ')
log_info "Total Docker containers running: $CONTAINER_COUNT"
echo ""

docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | head -20

docker ps --format "{{.Names}}" >> "$RESULTS_FILE"

# Generate summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PERCENTAGE=$((ONLINE_COUNT * 100 / TOTAL_COUNT))

echo "Total Services Tested:  $TOTAL_COUNT"
echo "${GREEN}Services Online:        $ONLINE_COUNT ($PERCENTAGE%)${NC}"
echo "${RED}Services Offline:       $OFFLINE_COUNT${NC}"
echo ""

# Add summary to results file
cat >> "$RESULTS_FILE" << EOFSUMMARY

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Total Services Tested:  $TOTAL_COUNT
Services Online:        $ONLINE_COUNT ($PERCENTAGE%)
Services Offline:       $OFFLINE_COUNT
Docker Containers:      $CONTAINER_COUNT running

Results saved to:
- Full results:   $RESULTS_FILE
- Online only:    $ONLINE_FILE
- Offline only:   $OFFLINE_FILE

EOFSUMMARY

# Add footer to online/offline files
echo "" >> "$ONLINE_FILE"
echo "Total Online: $ONLINE_COUNT services" >> "$ONLINE_FILE"

echo "" >> "$OFFLINE_FILE"
echo "Total Offline: $OFFLINE_COUNT services" >> "$OFFLINE_FILE"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Results Saved"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Full results:   $RESULTS_FILE"
echo "Online only:    $ONLINE_FILE"
echo "Offline only:   $OFFLINE_FILE"
echo ""
echo "View results:"
echo "  cat $RESULTS_FILE"
echo ""
echo "View online services only:"
echo "  cat $ONLINE_FILE"
echo ""
echo "View offline services:"
echo "  cat $OFFLINE_FILE"
echo ""

# Generate clean list for Heimdall import
CLEAN_JSON=~/HomeLab/HEIMDALL_CLEAN_$(date +%Y%m%d_%H%M%S).json

echo "[" > "$CLEAN_JSON"

cat > /tmp/heimdall_template.txt << 'EOFTEMPLATE'
{
  "title": "SERVICE_NAME",
  "colour": "SERVICE_COLOR",
  "url": "SERVICE_URL",
  "description": null,
  "appid": null,
  "appdescription": "SERVICE_DESC"
}
EOFTEMPLATE

# Only add online services to JSON
first=true
while IFS= read -r line; do
    if [[ $line == ✓* ]]; then
        # Extract service name and URL
        service=$(echo "$line" | sed 's/✓ //' | cut -d' ' -f1)
        url=$(echo "$line" | sed 's/.*- //')
        
        # Add comma if not first
        if [ "$first" = false ]; then
            echo "," >> "$CLEAN_JSON"
        fi
        first=false
        
        # Add service entry (simplified)
        cat >> "$CLEAN_JSON" << EOFJSON
  {
    "title": "$service",
    "colour": "#4a90e2",
    "url": "$url",
    "description": null,
    "appid": null,
    "appdescription": "Working service - tested $(date +%Y-%m-%d)"
  }
EOFJSON
    fi
done < "$ONLINE_FILE"

echo "" >> "$CLEAN_JSON"
echo "]" >> "$CLEAN_JSON"

echo "Clean Heimdall config (ONLY working services):"
echo "  $CLEAN_JSON"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "${GREEN}✓ Service check complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Review the results files above"
echo "2. Paste contents of $RESULTS_FILE here"
echo "3. I'll help you fix any missing services"
echo ""