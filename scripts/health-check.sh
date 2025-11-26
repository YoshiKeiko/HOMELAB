#!/bin/bash

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║          HOMELAB CONTAINER HEALTH CHECK                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Timestamp: $(date)"
echo "Host: $(hostname)"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get all running containers
echo "=== RUNNING CONTAINERS ==="
docker ps --format "{{.Names}}" | sort > /tmp/containers.txt
TOTAL=$(wc -l < /tmp/containers.txt | tr -d ' ')
echo "Total running: $TOTAL"
echo ""

# Health check function
check_url() {
  local name=$1
  local url=$2
  
  response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 -k "$url" 2>/dev/null)
  
  if [ "$response" == "200" ] || [ "$response" == "302" ] || [ "$response" == "301" ] || [ "$response" == "401" ] || [ "$response" == "303" ] || [ "$response" == "307" ]; then
    echo -e "${GREEN}✅ $name${NC} - $url (HTTP $response)"
    return 0
  else
    echo -e "${RED}❌ $name${NC} - $url (HTTP $response)"
    return 1
  fi
}

echo "=== WEB UI HEALTH CHECKS ==="
echo ""

# Core Infrastructure
echo "--- Core Infrastructure ---"
check_url "Portainer" "http://192.168.50.50:9000"
check_url "Heimdall" "http://192.168.50.50:8090"
check_url "Grafana" "http://192.168.50.50:3003"
check_url "Prometheus" "http://192.168.50.50:9090"
check_url "Uptime Kuma" "http://192.168.50.50:3004"
check_url "AdGuard Home" "http://192.168.50.50:8084"
echo ""

# Media Stack
echo "--- Media Stack ---"
check_url "Plex" "http://192.168.50.50:32400/web"
check_url "Jellyfin" "http://192.168.50.50:8096"
check_url "Sonarr" "http://192.168.50.50:8989"
check_url "Radarr" "http://192.168.50.50:7878"
check_url "Prowlarr" "http://192.168.50.50:9696"
check_url "Overseerr" "http://192.168.50.50:5055"
check_url "Tautulli" "http://192.168.50.50:8181"
check_url "Transmission" "http://192.168.50.50:9091"
echo ""

# Smart Home & IoT
echo "--- Smart Home & IoT ---"
check_url "Home Assistant" "http://192.168.50.50:8123"
check_url "Node-RED" "http://192.168.50.50:1880"
check_url "Zigbee2MQTT" "http://192.168.50.50:8080"
check_url "ESPHome" "http://192.168.50.50:6052"
echo ""

# AI & Development
echo "--- AI & Development ---"
check_url "Ollama API" "http://192.168.50.50:11434"
check_url "Open WebUI" "http://192.168.50.50:3000"
check_url "Jupyter" "http://192.168.50.50:8888"
check_url "Code Server" "http://192.168.50.50:8443"
check_url "Gitea" "http://192.168.50.50:3001"
echo ""

# Productivity & Documents
echo "--- Productivity & Documents ---"
check_url "Nextcloud" "http://192.168.50.50:8097"
check_url "Paperless" "http://192.168.50.50:8093"
check_url "Calibre" "http://192.168.50.50:8094"
check_url "FreshRSS" "http://192.168.50.50:8098"
check_url "PhotoPrism" "http://192.168.50.50:2342"
check_url "Vaultwarden" "http://192.168.50.50:8088"
echo ""

# Monitoring & Databases
echo "--- Monitoring & Databases ---"
check_url "Netdata" "http://192.168.50.50:19999"
check_url "cAdvisor" "http://192.168.50.50:8085"
check_url "Loki" "http://192.168.50.50:3100/ready"
check_url "InfluxDB" "http://192.168.50.50:8086"
echo ""

# Surveillance
echo "--- Surveillance ---"
check_url "Agent DVR" "http://192.168.50.50:8099"
echo ""

# Dashboards
echo "--- Dashboards ---"
check_url "Homer" "http://192.168.50.50:8091"
check_url "Dashy" "http://192.168.50.50:4000"
check_url "Organizr" "http://192.168.50.50:8092"
echo ""

# Security & Infrastructure
echo "--- Security & Infrastructure ---"
check_url "Nginx Proxy Manager" "http://192.168.50.50:81"
check_url "Filebrowser" "http://192.168.50.50:8087"
echo ""

# Backup
echo "--- Backup ---"
check_url "Kopia" "http://192.168.50.50:8202"
check_url "Syncthing" "http://192.168.50.50:8384"
echo ""

# Other
echo "--- Other ---"
check_url "KASM VNC" "http://192.168.50.50:3050"
check_url "Flaresolverr" "http://192.168.50.50:8191"
echo ""

echo "=== CONTAINER STATUS CHECK ==="
echo ""
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.State}}" | sort

echo ""
echo "=== STOPPED/FAILED CONTAINERS ==="
docker ps -a --filter "status=exited" --format "table {{.Names}}\t{{.Status}}"

echo ""
echo "=== DISK SPACE ==="
df -h / /Volumes/HomeLab-4TB 2>/dev/null

echo ""
echo "=== DOCKER DISK USAGE ==="
docker system df

echo ""
echo "=== TOP 20 MEMORY USAGE ==="
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | sort -k3 -h | tail -20

echo ""
echo "Health check complete!"
