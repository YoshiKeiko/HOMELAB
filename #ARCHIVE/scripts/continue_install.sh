#!/bin/bash

################################################################################
# Continue Installation - Fix Nextcloud + Install Remaining Services
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_section() {
    echo ""
    echo -e "${BLUE}################################################################################${NC}"
    echo -e "${BLUE}# $1${NC}"
    echo -e "${BLUE}################################################################################${NC}"
    echo ""
}

HOMELAB_DIR="$HOME/HomeLab"
DOCKER_DATA_DIR="$HOMELAB_DIR/Docker/Data"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"
TIMEZONE="Europe/London"
PUID="501"
PGID="20"

# Get passwords from existing containers
POSTGRES_PASSWORD=$(docker exec postgres printenv POSTGRES_PASSWORD 2>/dev/null || echo "SecurePostgres2024!")
MYSQL_ROOT_PASSWORD=$(docker exec mariadb printenv MYSQL_ROOT_PASSWORD 2>/dev/null || echo "SecureMySQL2024!")

NEXTCLOUD_ADMIN_PASSWORD="$(openssl rand -base64 24 | tr -d '/+=')"
GRAFANA_ADMIN_PASSWORD="$(docker exec grafana printenv GF_SECURITY_ADMIN_PASSWORD 2>/dev/null || openssl rand -base64 24 | tr -d '/+=')"

################################################################################
# Fix Storage Stack - Change Nextcloud Port
################################################################################

log_section "Fixing Storage Stack (Nextcloud Port Conflict)"

cat > "$COMPOSE_DIR/storage.yml" << EOF
services:
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    restart: unless-stopped
    ports:
      - "8097:80"
    environment:
      - POSTGRES_HOST=postgres
      - POSTGRES_DB=nextcloud
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - NEXTCLOUD_ADMIN_USER=admin
      - NEXTCLOUD_ADMIN_PASSWORD=${NEXTCLOUD_ADMIN_PASSWORD}
      - NEXTCLOUD_TRUSTED_DOMAINS=localhost homelab.local
    volumes:
      - ${DOCKER_DATA_DIR}/nextcloud/data:/var/www/html
    networks:
      - homelab-net
      - database-net

  syncthing:
    image: lscr.io/linuxserver/syncthing:latest
    container_name: syncthing
    restart: unless-stopped
    ports:
      - "8384:8384"
      - "22000:22000/tcp"
      - "22000:22000/udp"
      - "21027:21027/udp"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/syncthing/config:/config
      - ${DOCKER_DATA_DIR}/syncthing/data:/data
    networks:
      - homelab-net

  duplicati:
    image: lscr.io/linuxserver/duplicati:latest
    container_name: duplicati
    restart: unless-stopped
    ports:
      - "8200:8200"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/duplicati/config:/config
      - ${DOCKER_DATA_DIR}/duplicati/backups:/backups
      - ${DOCKER_DATA_DIR}:/source
    networks:
      - homelab-net

  filebrowser:
    image: filebrowser/filebrowser:latest
    container_name: filebrowser
    restart: unless-stopped
    ports:
      - "8087:80"
    volumes:
      - ${DOCKER_DATA_DIR}/filebrowser/config:/config
      - ${HOMELAB_DIR}:/srv
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
  database-net:
    external: true
EOF

docker compose -f "$COMPOSE_DIR/storage.yml" up -d
log_info "✓ Storage stack deployed (Nextcloud now on port 8097)"

################################################################################
# Deploy Security Stack
################################################################################

log_section "Phase 5: Deploying Security Stack (3 services)"

cat > "$COMPOSE_DIR/security.yml" << EOF
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    ports:
      - "8088:80"
    environment:
      - SIGNUPS_ALLOWED=true
      - INVITATIONS_ALLOWED=true
      - WEBSOCKET_ENABLED=true
    volumes:
      - ${DOCKER_DATA_DIR}/vaultwarden/data:/data
    networks:
      - homelab-net

  fail2ban:
    image: crazymax/fail2ban:latest
    container_name: fail2ban
    restart: unless-stopped
    network_mode: host
    cap_add:
      - NET_ADMIN
      - NET_RAW
    volumes:
      - ${DOCKER_DATA_DIR}/fail2ban/config:/data
      - /var/log:/var/log:ro
    environment:
      - TZ=${TIMEZONE}

  crowdsec:
    image: crowdsecurity/crowdsec:latest
    container_name: crowdsec
    restart: unless-stopped
    ports:
      - "8089:8080"
    environment:
      - COLLECTIONS=crowdsecurity/linux crowdsecurity/nginx
    volumes:
      - ${DOCKER_DATA_DIR}/crowdsec/config:/etc/crowdsec
      - ${DOCKER_DATA_DIR}/crowdsec/data:/var/lib/crowdsec/data
      - /var/log:/var/log:ro
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
EOF

docker compose -f "$COMPOSE_DIR/security.yml" up -d
log_info "✓ Security stack deployed"

################################################################################
# Deploy Dashboards
################################################################################

log_section "Phase 6: Deploying Dashboards (4 services)"

cat > "$COMPOSE_DIR/dashboards.yml" << EOF
services:
  heimdall:
    image: lscr.io/linuxserver/heimdall:latest
    container_name: heimdall
    restart: unless-stopped
    ports:
      - "8090:80"
      - "4443:443"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/heimdall/config:/config
    networks:
      - homelab-net

  homer:
    image: b4bz/homer:latest
    container_name: homer
    restart: unless-stopped
    ports:
      - "8091:8080"
    volumes:
      - ${DOCKER_DATA_DIR}/homer/assets:/www/assets
    environment:
      - INIT_ASSETS=0
    networks:
      - homelab-net

  dashy:
    image: lissy93/dashy:latest
    container_name: dashy
    restart: unless-stopped
    ports:
      - "4000:80"
    volumes:
      - ${DOCKER_DATA_DIR}/dashy/config:/app/public
    environment:
      - NODE_ENV=production
    networks:
      - homelab-net

  organizr:
    image: organizr/organizr:latest
    container_name: organizr
    restart: unless-stopped
    ports:
      - "8092:80"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/organizr/config:/config
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
EOF

docker compose -f "$COMPOSE_DIR/dashboards.yml" up -d
log_info "✓ Dashboards deployed"

################################################################################
# Deploy Utilities
################################################################################

log_section "Phase 7: Deploying Utilities (4 services)"

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
      - "8096:80"
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

docker compose -f "$COMPOSE_DIR/utilities.yml" up -d
log_info "✓ Utilities deployed"

################################################################################
# Final Summary
################################################################################

log_section "Installation Complete!"

# Get RustDesk key if it exists
RUSTDESK_KEY=$(docker logs hbbs 2>&1 | grep "Key:" | awk '{print $NF}' | tail -1 2>/dev/null || echo "N/A")

# Count containers
TOTAL_CONTAINERS=$(docker ps --format '{{.Names}}' | wc -l | tr -d ' ')

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  🎉 SUCCESS! ${TOTAL_CONTAINERS} SERVICES NOW RUNNING!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}KEY SERVICES - QUICK ACCESS:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🎛️  MAIN DASHBOARD:"
echo "  Heimdall:        http://localhost:8090"
echo ""
echo "🤖 AI SERVICES:"
echo "  OpenWebUI:       http://localhost:3000"
echo "  Ollama API:      http://localhost:11434"
echo ""
echo "🏠 SMART HOME:"
echo "  Home Assistant:  http://localhost:8123"
echo "  Node-RED:        http://localhost:1880"
echo ""
echo "📊 MONITORING:"
echo -e "  Grafana:         http://localhost:3003 ${CYAN}(admin/${GRAFANA_ADMIN_PASSWORD})${NC}"
echo "  Prometheus:      http://localhost:9090"
echo "  Uptime Kuma:     http://localhost:3004"
echo "  Netdata:         http://localhost:19999"
echo ""
echo "📦 STORAGE:"
echo -e "  Nextcloud:       http://localhost:8097 ${YELLOW}(FIXED PORT!)${NC}"
echo "  Syncthing:       http://localhost:8384"
echo "  File Browser:    http://localhost:8087"
echo ""
echo "🎬 MEDIA:"
echo "  Plex:            http://localhost:32400/web"
echo "  Jellyfin:        http://localhost:8096"
echo "  Overseerr:       http://localhost:5055"
echo ""
echo "🔒 SECURITY:"
echo "  Vaultwarden:     http://localhost:8088"
echo ""
echo "🛠️  DEVELOPMENT:"
echo "  Code Server:     http://localhost:8443 (password: changeme)"
echo "  Jupyter:         http://localhost:8888"
echo "  Gitea:           http://localhost:3001"
echo "  Portainer:       http://localhost:9000"
echo ""

# Save credentials
cat > "$HOMELAB_DIR/docs/FINAL_CREDENTIALS.txt" << EOF
╔═══════════════════════════════════════════════════════════════╗
║              HOMELAB COMPLETE - ALL CREDENTIALS               ║
╚═══════════════════════════════════════════════════════════════╝

Generated: $(date)

IMPORTANT SERVICE PASSWORDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Nextcloud:        admin / ${NEXTCLOUD_ADMIN_PASSWORD}
Grafana:          admin / ${GRAFANA_ADMIN_PASSWORD}
PhotoPrism:       admin / ${NEXTCLOUD_ADMIN_PASSWORD}
Code Server:      changeme (CHANGE THIS!)

TAILSCALE INFO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Mac IP:           $(tailscale ip -4 2>/dev/null || echo "Run: tailscale ip -4")

⚠️ ADD ALL TO 1PASSWORD AND DELETE THIS FILE!
EOF

chmod 600 "$HOMELAB_DIR/docs/FINAL_CREDENTIALS.txt"

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}  ⚠️  CREDENTIALS SAVED TO:${NC}"
echo "  $HOMELAB_DIR/docs/FINAL_CREDENTIALS.txt"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Next Steps:"
echo "1. Save all credentials to 1Password"
echo "2. Open Heimdall: http://localhost:8090"
echo "3. Configure your services"
echo "4. Run status check: ~/Downloads/check-homelab-status.sh"
echo ""