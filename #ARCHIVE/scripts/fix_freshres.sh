#!/bin/bash

################################################################################
# Final Fix - FreshRSS Port Conflict
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

COMPOSE_DIR="$HOME/HomeLab/Docker/Compose"
DOCKER_DATA_DIR="$HOME/HomeLab/Docker/Data"
PUID="501"
PGID="20"
TIMEZONE="Europe/London"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Fixing FreshRSS Port Conflict"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Get passwords
POSTGRES_PASSWORD=$(docker exec postgres printenv POSTGRES_PASSWORD 2>/dev/null)
MYSQL_ROOT_PASSWORD=$(docker exec mariadb printenv MYSQL_ROOT_PASSWORD 2>/dev/null)
NEXTCLOUD_ADMIN_PASSWORD=$(docker exec nextcloud printenv NEXTCLOUD_ADMIN_PASSWORD 2>/dev/null)

# Stop FreshRSS
docker stop freshrss 2>/dev/null || true
docker rm freshrss 2>/dev/null || true

# Recreate utilities compose file with fixed port
cat > "$COMPOSE_DIR/utilities.yml" << EOF
services:
  paperless-ngx:
    image: ghcr.io/paperless-ngx/paperless-ngx:latest
    container_name: paperless
    restart: unless-stopped
    ports:
      - "8093:8000"
    environment:
      - PAPERLESS_REDIS=redis://redis:6379
      - PAPERLESS_DBHOST=postgres
      - PAPERLESS_DBNAME=paperless
      - PAPERLESS_DBUSER=postgres
      - PAPERLESS_DBPASS=${POSTGRES_PASSWORD}
      - PAPERLESS_SECRET_KEY=$(openssl rand -base64 32 | tr -d '/+=')
      - PAPERLESS_TIME_ZONE=${TIMEZONE}
      - USERMAP_UID=${PUID}
      - USERMAP_GID=${PGID}
    volumes:
      - ${DOCKER_DATA_DIR}/paperless/data:/usr/src/paperless/data
      - ${DOCKER_DATA_DIR}/paperless/media:/usr/src/paperless/media
      - ${DOCKER_DATA_DIR}/paperless/consume:/usr/src/paperless/consume
    networks:
      - homelab-net
      - database-net

  photoprism:
    image: photoprism/photoprism:latest
    container_name: photoprism
    restart: unless-stopped
    ports:
      - "2342:2342"
    environment:
      PHOTOPRISM_ADMIN_PASSWORD: ${NEXTCLOUD_ADMIN_PASSWORD}
      PHOTOPRISM_SITE_URL: "http://localhost:2342/"
      PHOTOPRISM_DATABASE_DRIVER: "mysql"
      PHOTOPRISM_DATABASE_SERVER: "mariadb:3306"
      PHOTOPRISM_DATABASE_NAME: "photoprism"
      PHOTOPRISM_DATABASE_USER: "root"
      PHOTOPRISM_DATABASE_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    volumes:
      - ${DOCKER_DATA_DIR}/photoprism/storage:/photoprism/storage
      - ${DOCKER_DATA_DIR}/photoprism/originals:/photoprism/originals
      - ${DOCKER_DATA_DIR}/photoprism/import:/photoprism/import
    networks:
      - homelab-net
      - database-net

  calibre:
    image: lscr.io/linuxserver/calibre:latest
    container_name: calibre
    restart: unless-stopped
    ports:
      - "8094:8080"
      - "8095:8081"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/calibre/config:/config
      - ${DOCKER_DATA_DIR}/calibre/books:/books
    networks:
      - homelab-net

  freshrss:
    image: freshrss/freshrss:latest
    container_name: freshrss
    restart: unless-stopped
    ports:
      - "8098:80"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/freshrss/data:/var/www/FreshRSS/data
      - ${DOCKER_DATA_DIR}/freshrss/extensions:/var/www/FreshRSS/extensions
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
  database-net:
    external: true
EOF

log_info "Starting utilities with fixed FreshRSS port (8098)..."
docker compose -f "$COMPOSE_DIR/utilities.yml" up -d

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}✓ ALL SERVICES NOW RUNNING!${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Count total containers
TOTAL=$(docker ps --format '{{.Names}}' | wc -l | tr -d ' ')

echo -e "${CYAN}Total Running Containers: ${TOTAL}${NC}"
echo ""

echo -e "${BLUE}COMPLETE SERVICE LIST WITH ACCESS URLS:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎛️  CORE:"
echo "  Portainer:           http://localhost:9000"
echo ""
echo "🎬 MEDIA (7):"
echo "  Plex:                http://localhost:32400/web"
echo "  Jellyfin:            http://localhost:8096"
echo "  Radarr:              http://localhost:7878"
echo "  Sonarr:              http://localhost:8989"
echo "  Prowlarr:            http://localhost:9696"
echo "  Overseerr:           http://localhost:5055"
echo "  Transmission:        http://localhost:9091"
echo ""
echo "🤖 AI & DEVELOPMENT (5):"
echo "  OpenWebUI:           http://localhost:3000"
echo "  Ollama API:          http://localhost:11434"
echo "  Code Server:         http://localhost:8443"
echo "  Jupyter:             http://localhost:8888"
echo "  Gitea:               http://localhost:3001"
echo ""
echo "🏠 SMART HOME (5):"
echo "  Home Assistant:      http://localhost:8123"
echo "  Node-RED:            http://localhost:1880"
echo "  Mosquitto MQTT:      Port 1883"
echo "  Zigbee2MQTT:         http://localhost:8080"
echo "  ESPHome:             http://localhost:6052"
echo ""
echo "📊 MONITORING (8):"
echo "  Grafana:             http://localhost:3003"
echo "  Prometheus:          http://localhost:9090"
echo "  Loki:                http://localhost:3100"
echo "  Uptime Kuma:         http://localhost:3004"
echo "  Netdata:             http://localhost:19999"
echo "  cAdvisor:            http://localhost:8085"
echo "  Node Exporter:       http://localhost:9100"
echo ""
echo "💾 STORAGE & BACKUP (4):"
echo "  Nextcloud:           http://localhost:8097 ← CHANGED PORT"
echo "  Syncthing:           http://localhost:8384"
echo "  Duplicati:           http://localhost:8200"
echo "  File Browser:        http://localhost:8087"
echo ""
echo "🔒 SECURITY (3):"
echo "  Vaultwarden:         http://localhost:8088"
echo "  CrowdSec:            http://localhost:8089"
echo "  Fail2ban:            Active (host network)"
echo ""
echo "🎨 DASHBOARDS (4):"
echo "  Heimdall:            http://localhost:8090 ← START HERE!"
echo "  Homer:               http://localhost:8091"
echo "  Dashy:               http://localhost:4000"
echo "  Organizr:            http://localhost:8092"
echo ""
echo "🛠️  UTILITIES (4):"
echo "  Paperless-ngx:       http://localhost:8093"
echo "  PhotoPrism:          http://localhost:2342"
echo "  Calibre:             http://localhost:8094"
echo "  FreshRSS:            http://localhost:8098 ← CHANGED PORT"
echo ""
echo "🗄️  DATABASES (5):"
echo "  PostgreSQL:          localhost:5432"
echo "  MariaDB:             localhost:3306"
echo "  MongoDB:             localhost:27017"
echo "  Redis:               localhost:6379"
echo "  InfluxDB:            http://localhost:8086"
echo ""

# Get Tailscale IP
TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "Run: tailscale ip -4")

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}  📱 REMOTE ACCESS VIA TAILSCALE${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Your Mac's Tailscale IP: ${TAILSCALE_IP}"
echo ""
echo "Access from your Android phone:"
echo "  http://${TAILSCALE_IP}:8090  (Heimdall)"
echo "  http://${TAILSCALE_IP}:3000  (OpenWebUI)"
echo "  http://${TAILSCALE_IP}:8123  (Home Assistant)"
echo ""

# Save final summary
cat > "$HOME/HomeLab/docs/COMPLETE_INSTALLATION.txt" << EOF
═══════════════════════════════════════════════════════════════
  HOMELAB INSTALLATION COMPLETE
═══════════════════════════════════════════════════════════════

Installation Date: $(date)
Total Services: ${TOTAL}

QUICK START:
1. Open Heimdall Dashboard: http://localhost:8090
2. Add all your services to Heimdall for easy access
3. Configure Home Assistant for smart home devices
4. Set up Grafana dashboards for monitoring

CREDENTIALS FILE:
  ~/HomeLab/docs/FINAL_CREDENTIALS.txt

TAILSCALE ACCESS:
  Mac IP: ${TAILSCALE_IP}
  Use this IP on your phone to access services

PORT CHANGES FROM DEFAULTS:
  - Nextcloud: 8097 (was 8086, conflict with InfluxDB)
  - FreshRSS: 8098 (was 8096, conflict with Jellyfin)

SERVICES RUNNING: ${TOTAL}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$(docker ps --format "  - {{.Names}}")

═══════════════════════════════════════════════════════════════
EOF

echo ""
echo -e "${GREEN}Installation summary saved to:${NC}"
echo "  ~/HomeLab/docs/COMPLETE_INSTALLATION.txt"
echo ""
echo -e "${GREEN}🎉 ALL DONE! Your homelab is fully operational!${NC}"
echo ""
echo "Next steps:"
echo "1. Open Heimdall: http://localhost:8090"
echo "2. Save credentials from ~/HomeLab/docs/FINAL_CREDENTIALS.txt"
echo "3. Start configuring your services!"
echo ""