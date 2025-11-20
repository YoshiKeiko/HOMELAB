#!/bin/bash

################################################################################
# HomeLab - Install Remaining 33 Services (ARM64 Compatible)
# For M4 Mac Mini
################################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_section() {
    echo ""
    echo -e "${BLUE}################################################################################${NC}"
    echo -e "${BLUE}# $1${NC}"
    echo -e "${BLUE}################################################################################${NC}"
    echo ""
}

# Configuration
HOMELAB_DIR="$HOME/HomeLab"
DOCKER_DATA_DIR="$HOMELAB_DIR/Docker/Data"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"
TIMEZONE="Europe/London"
PUID="501"
PGID="20"

# Get existing passwords from running containers
POSTGRES_PASSWORD=$(docker exec postgres printenv POSTGRES_PASSWORD 2>/dev/null || echo "SecurePostgres2024!")
MYSQL_ROOT_PASSWORD=$(docker exec mariadb printenv MYSQL_ROOT_PASSWORD 2>/dev/null || echo "SecureMySQL2024!")
REDIS_PASSWORD=$(docker exec redis cat /data/redis.conf 2>/dev/null | grep requirepass | awk '{print $2}' || echo "SecureRedis2024!")

# Generate new passwords for new services
NEXTCLOUD_ADMIN_PASSWORD="$(openssl rand -base64 24 | tr -d '/+=')"
GRAFANA_ADMIN_PASSWORD="$(openssl rand -base64 24 | tr -d '/+=')"

RUSTDESK_KEY=""

################################################################################
# Phase 1: AI & Development Stack
################################################################################

deploy_ai_stack() {
    log_section "Phase 1: Deploying AI & Development Stack (5 services)"
    
    cat > "$COMPOSE_DIR/ai-dev.yml" << EOF
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ${DOCKER_DATA_DIR}/ollama/models:/root/.ollama
    networks:
      - homelab-net

  openwebui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: openwebui
    restart: unless-stopped
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    volumes:
      - ${DOCKER_DATA_DIR}/openwebui/data:/app/backend/data
    networks:
      - homelab-net
    depends_on:
      - ollama

  codeserver:
    image: lscr.io/linuxserver/code-server:latest
    container_name: codeserver
    restart: unless-stopped
    ports:
      - "8443:8443"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
      - PASSWORD=changeme
    volumes:
      - ${DOCKER_DATA_DIR}/codeserver/config:/config
    networks:
      - homelab-net

  jupyter:
    image: jupyter/datascience-notebook:latest
    container_name: jupyter
    restart: unless-stopped
    ports:
      - "8888:8888"
    environment:
      - JUPYTER_ENABLE_LAB=yes
    volumes:
      - ${DOCKER_DATA_DIR}/jupyter/notebooks:/home/jovyan/work
    networks:
      - homelab-net

  gitea:
    image: gitea/gitea:latest
    container_name: gitea
    restart: unless-stopped
    ports:
      - "3001:3000"
      - "2222:22"
    environment:
      - USER_UID=${PUID}
      - USER_GID=${PGID}
    volumes:
      - ${DOCKER_DATA_DIR}/gitea/data:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
EOF
    
    docker compose -f "$COMPOSE_DIR/ai-dev.yml" up -d
    log_info "✓ AI & Development stack deployed"
}

################################################################################
# Phase 2: Smart Home Stack
################################################################################

deploy_smart_home() {
    log_section "Phase 2: Deploying Smart Home Stack (5 services)"
    
    # Create Mosquitto config
    mkdir -p "$DOCKER_DATA_DIR/mosquitto/config"
    cat > "$DOCKER_DATA_DIR/mosquitto/config/mosquitto.conf" << 'EOF'
listener 1883
allow_anonymous true
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
EOF
    
    cat > "$COMPOSE_DIR/smarthome.yml" << EOF
services:
  homeassistant:
    image: homeassistant/home-assistant:latest
    container_name: homeassistant
    restart: unless-stopped
    network_mode: host
    volumes:
      - ${DOCKER_DATA_DIR}/homeassistant/config:/config
      - /etc/localtime:/etc/localtime:ro
    environment:
      - TZ=${TIMEZONE}

  nodered:
    image: nodered/node-red:latest
    container_name: nodered
    restart: unless-stopped
    ports:
      - "1880:1880"
    environment:
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/nodered/data:/data
    networks:
      - homelab-net

  mosquitto:
    image: eclipse-mosquitto:latest
    container_name: mosquitto
    restart: unless-stopped
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ${DOCKER_DATA_DIR}/mosquitto/config:/mosquitto/config
      - ${DOCKER_DATA_DIR}/mosquitto/data:/mosquitto/data
      - ${DOCKER_DATA_DIR}/mosquitto/log:/mosquitto/log
    networks:
      - homelab-net

  zigbee2mqtt:
    image: koenkk/zigbee2mqtt:latest
    container_name: zigbee2mqtt
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - ${DOCKER_DATA_DIR}/zigbee2mqtt/data:/app/data
      - /run/udev:/run/udev:ro
    environment:
      - TZ=${TIMEZONE}
    networks:
      - homelab-net

  esphome:
    image: esphome/esphome:latest
    container_name: esphome
    restart: unless-stopped
    ports:
      - "6052:6052"
    volumes:
      - ${DOCKER_DATA_DIR}/esphome/config:/config
      - /etc/localtime:/etc/localtime:ro
    network_mode: host

networks:
  homelab-net:
    external: true
EOF
    
    docker compose -f "$COMPOSE_DIR/smarthome.yml" up -d
    log_info "✓ Smart home stack deployed"
}

################################################################################
# Phase 3: Monitoring Stack
################################################################################

deploy_monitoring() {
    log_section "Phase 3: Deploying Monitoring Stack (8 services)"
    
    # Prometheus config
    cat > "$DOCKER_DATA_DIR/prometheus/prometheus.yml" << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
  
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
EOF
    
    cat > "$COMPOSE_DIR/monitoring.yml" << EOF
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ${DOCKER_DATA_DIR}/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - ${DOCKER_DATA_DIR}/prometheus/data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    networks:
      - monitoring-net
    user: "0:0"

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    restart: unless-stopped
    ports:
      - "3003:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD}
      - GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource
    volumes:
      - ${DOCKER_DATA_DIR}/grafana/data:/var/lib/grafana
    networks:
      - monitoring-net
    user: "0:0"
    depends_on:
      - prometheus

  loki:
    image: grafana/loki:latest
    container_name: loki
    restart: unless-stopped
    ports:
      - "3100:3100"
    volumes:
      - ${DOCKER_DATA_DIR}/loki/data:/loki
    networks:
      - monitoring-net
    user: "0:0"

  promtail:
    image: grafana/promtail:latest
    container_name: promtail
    restart: unless-stopped
    volumes:
      - /var/log:/var/log:ro
      - ${DOCKER_DATA_DIR}/promtail/config:/etc/promtail
    networks:
      - monitoring-net

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    ports:
      - "9100:9100"
    command:
      - '--path.rootfs=/host'
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)(\$\$|/)'
    volumes:
      - /:/host:ro,rslave
    networks:
      - monitoring-net

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    restart: unless-stopped
    ports:
      - "8085:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker:/var/lib/docker:ro
    networks:
      - monitoring-net
    privileged: true

  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    restart: unless-stopped
    ports:
      - "3004:3001"
    volumes:
      - ${DOCKER_DATA_DIR}/uptime-kuma/data:/app/data
    networks:
      - monitoring-net

  netdata:
    image: netdata/netdata:latest
    container_name: netdata
    restart: unless-stopped
    ports:
      - "19999:19999"
    cap_add:
      - SYS_PTRACE
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - monitoring-net

networks:
  monitoring-net:
    external: true
EOF
    
    docker compose -f "$COMPOSE_DIR/monitoring.yml" up -d
    log_info "✓ Monitoring stack deployed"
}

################################################################################
# Phase 4: Storage & Backup
################################################################################

deploy_storage() {
    log_section "Phase 4: Deploying Storage & Backup (4 services)"
    
    cat > "$COMPOSE_DIR/storage.yml" << EOF
services:
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    restart: unless-stopped
    ports:
      - "8086:80"
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
    log_info "✓ Storage & backup deployed"
}

################################################################################
# Phase 5: Security Stack
################################################################################

deploy_security() {
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
}

################################################################################
# Phase 6: Dashboards
################################################################################

deploy_dashboards() {
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
}

################################################################################
# Phase 7: Utilities
################################################################################

deploy_utilities() {
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
      - PAPERLESS_SECRET_KEY=$(openssl rand -base64 32)
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
}

################################################################################
# Final Summary
################################################################################

print_summary() {
    log_section "Installation Complete!"
    
    # Get RustDesk key
    RUSTDESK_KEY=$(docker logs hbbs 2>&1 | grep "Key:" | awk '{print $NF}' | tail -1)
    
    # Count containers
    local total_containers=$(docker ps --format '{{.Names}}' | wc -l | tr -d ' ')
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  🎉 SUCCESS! ${total_containers} SERVICES NOW RUNNING!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${BLUE}AI & DEVELOPMENT${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Ollama:          http://localhost:11434"
    echo "OpenWebUI:       http://localhost:3000"
    echo "Code Server:     http://localhost:8443 (password: changeme)"
    echo "Jupyter:         http://localhost:8888"
    echo "Gitea:           http://localhost:3001"
    echo ""
    
    echo -e "${BLUE}SMART HOME${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Home Assistant:  http://localhost:8123"
    echo "Node-RED:        http://localhost:1880"
    echo "Zigbee2MQTT:     http://localhost:8080"
    echo "ESPHome:         http://localhost:6052"
    echo ""
    
    echo -e "${BLUE}MONITORING${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Prometheus:      http://localhost:9090"
    echo -e "Grafana:         http://localhost:3003 ${YELLOW}(admin/${GRAFANA_ADMIN_PASSWORD})${NC}"
    echo "Loki:            http://localhost:3100"
    echo "Uptime Kuma:     http://localhost:3004"
    echo "Netdata:         http://localhost:19999"
    echo "cAdvisor:        http://localhost:8085"
    echo ""
    
    echo -e "${BLUE}STORAGE & BACKUP${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "Nextcloud:       http://localhost:8086 ${YELLOW}(admin/${NEXTCLOUD_ADMIN_PASSWORD})${NC}"
    echo "Syncthing:       http://localhost:8384"
    echo "Duplicati:       http://localhost:8200"
    echo "File Browser:    http://localhost:8087"
    echo ""
    
    echo -e "${BLUE}SECURITY${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Vaultwarden:     http://localhost:8088"
    echo "CrowdSec:        http://localhost:8089"
    echo "Fail2ban:        Active"
    echo ""
    
    echo -e "${BLUE}DASHBOARDS${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Heimdall:        http://localhost:8090"
    echo "Homer:           http://localhost:8091"
    echo "Dashy:           http://localhost:4000"
    echo "Organizr:        http://localhost:8092"
    echo ""
    
    echo -e "${BLUE}UTILITIES${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Paperless-ngx:   http://localhost:8093"
    echo -e "PhotoPrism:      http://localhost:2342 ${YELLOW}(admin/${NEXTCLOUD_ADMIN_PASSWORD})${NC}"
    echo "Calibre:         http://localhost:8094"
    echo "FreshRSS:        http://localhost:8096"
    echo ""
    
    # Save credentials
    cat > "$HOMELAB_DIR/docs/NEW_CREDENTIALS.txt" << EOF
╔═══════════════════════════════════════════════════════════════╗
║              NEW SERVICE CREDENTIALS - SAVE NOW!              ║
╚═══════════════════════════════════════════════════════════════╝

Generated: $(date)

NEW SERVICE PASSWORDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Nextcloud Admin:  admin / ${NEXTCLOUD_ADMIN_PASSWORD}
Grafana Admin:    admin / ${GRAFANA_ADMIN_PASSWORD}
PhotoPrism:       admin / ${NEXTCLOUD_ADMIN_PASSWORD}
Code Server:      changeme (CHANGE THIS!)

EXISTING (from previous installation)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RustDesk Key:     ${RUSTDESK_KEY}

⚠️ Add these to 1Password and delete this file!
EOF
    
    chmod 600 "$HOMELAB_DIR/docs/NEW_CREDENTIALS.txt"
    
    echo -e "${YELLOW}⚠️  CREDENTIALS SAVED: $HOMELAB_DIR/docs/NEW_CREDENTIALS.txt${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Save all credentials to 1Password"
    echo "2. Configure Grafana dashboards"
    echo "3. Set up Home Assistant devices"
    echo "4. Configure backup schedules in Duplicati"
    echo ""
}

################################################################################
# Main Execution
################################################################################

main() {
    log_section "Installing Remaining 33 HomeLab Services"
    log_info "Estimated time: 10-15 minutes"
    echo ""
    
    deploy_ai_stack
    deploy_smart_home
    deploy_monitoring
    deploy_storage
    deploy_security
    deploy_dashboards
    deploy_utilities
    print_summary
}

main "$@"