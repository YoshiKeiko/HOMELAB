#!/bin/bash

################################################################################
# HomeLab COMPLETE Enterprise Installation Script
# M4 Mac Mini - Full 60+ Service Deployment
# Fixed version with proper prerequisites and error handling
################################################################################

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo ""
    echo -e "${BLUE}################################################################################${NC}"
    echo -e "${BLUE}# $1${NC}"
    echo -e "${BLUE}################################################################################${NC}"
    echo ""
}

log_service() {
    echo -e "${CYAN}  → Deploying $1...${NC}"
}

# Error handler
error_exit() {
    log_error "$1"
    exit 1
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error_exit "This script is designed for macOS only"
fi

################################################################################
# Configuration Variables
################################################################################

HOMELAB_DIR="$HOME/HomeLab"
DOCKER_DATA_DIR="$HOMELAB_DIR/Docker/Data"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"
ISO_DIR="$HOMELAB_DIR/isos"

# Generate secure random passwords
POSTGRES_PASSWORD="$(openssl rand -base64 32 | tr -d '/+=')"
MYSQL_ROOT_PASSWORD="$(openssl rand -base64 32 | tr -d '/+=')"
REDIS_PASSWORD="$(openssl rand -base64 32 | tr -d '/+=')"
MONGO_ROOT_PASSWORD="$(openssl rand -base64 32 | tr -d '/+=')"
NEXTCLOUD_ADMIN_PASSWORD="$(openssl rand -base64 32 | tr -d '/+=')"
GRAFANA_ADMIN_PASSWORD="$(openssl rand -base64 32 | tr -d '/+=')"
AUTHELIA_JWT_SECRET="$(openssl rand -base64 64 | tr -d '/+=')"
AUTHELIA_SESSION_SECRET="$(openssl rand -base64 64 | tr -d '/+=')"
AUTHELIA_STORAGE_ENCRYPTION_KEY="$(openssl rand -base64 64 | tr -d '/+=')"

# Optional tokens
PLEX_CLAIM_TOKEN=""  # Get from https://www.plex.tv/claim/

# Network Configuration
MAC_HOSTNAME="homelab.local"
TIMEZONE="Europe/London"
PUID="501"
PGID="20"

# RustDesk key placeholder
RUSTDESK_KEY=""

################################################################################
# Phase 0: Prerequisites Check
################################################################################

check_prerequisites() {
    log_section "Phase 0: Checking Prerequisites"
    
    # Check for required commands
    log_info "Checking for required commands..."
    
    if ! command -v openssl &> /dev/null; then
        error_exit "openssl not found. Please install: brew install openssl"
    fi
    
    log_info "✓ All prerequisites met"
}

################################################################################
# Phase 1: Cleanup Existing Installation
################################################################################

cleanup_existing() {
    log_section "Phase 1: Cleaning Up Existing Installation"
    
    log_warn "This will remove ALL existing Docker containers, images, and data!"
    log_warn "Press Ctrl+C to cancel, or Enter to continue..."
    read -r
    
    log_info "Stopping all Docker containers..."
    if [ "$(docker ps -q)" ]; then
        docker stop $(docker ps -aq) 2>/dev/null || true
    fi
    
    log_info "Removing all Docker containers..."
    if [ "$(docker ps -aq)" ]; then
        docker rm $(docker ps -aq) 2>/dev/null || true
    fi
    
    log_info "Removing Docker images (this may take a while)..."
    if [ "$(docker images -q)" ]; then
        docker rmi -f $(docker images -q) 2>/dev/null || true
    fi
    
    log_info "Removing Docker networks..."
    docker network prune -f 2>/dev/null || true
    
    log_info "Removing Docker volumes..."
    docker volume prune -f 2>/dev/null || true
    
    log_info "Cleaning up data directories..."
    if [ -d "$DOCKER_DATA_DIR" ]; then
        sudo rm -rf "$DOCKER_DATA_DIR"
    fi
    
    if [ -d "$COMPOSE_DIR" ]; then
        rm -rf "$COMPOSE_DIR"
    fi
    
    log_info "✓ Cleanup complete"
}

################################################################################
# Phase 2: Directory Structure
################################################################################

create_directory_structure() {
    log_section "Phase 2: Creating Complete Directory Structure"
    
    log_info "Creating base directories..."
    mkdir -p "$HOMELAB_DIR"
    mkdir -p "$HOMELAB_DIR/Docker"
    mkdir -p "$HOMELAB_DIR/Docker/Data"
    mkdir -p "$HOMELAB_DIR/Docker/Compose"
    mkdir -p "$HOMELAB_DIR/isos"
    mkdir -p "$HOMELAB_DIR/backups"
    mkdir -p "$HOMELAB_DIR/docs"
    mkdir -p "$HOMELAB_DIR/scripts"
    
    log_info "Creating core infrastructure directories..."
    mkdir -p "$DOCKER_DATA_DIR/traefik/config"
    mkdir -p "$DOCKER_DATA_DIR/traefik/acme"
    mkdir -p "$DOCKER_DATA_DIR/traefik/logs"
    mkdir -p "$DOCKER_DATA_DIR/authelia/config"
    mkdir -p "$DOCKER_DATA_DIR/authelia/secrets"
    mkdir -p "$DOCKER_DATA_DIR/portainer/data"
    mkdir -p "$DOCKER_DATA_DIR/watchtower/config"
    
    log_info "Creating database directories..."
    mkdir -p "$DOCKER_DATA_DIR/postgres/data"
    mkdir -p "$DOCKER_DATA_DIR/mariadb/data"
    mkdir -p "$DOCKER_DATA_DIR/mongodb/data"
    mkdir -p "$DOCKER_DATA_DIR/redis/data"
    mkdir -p "$DOCKER_DATA_DIR/influxdb/data"
    
    log_info "Creating media service directories..."
    mkdir -p "$DOCKER_DATA_DIR/plex/config"
    mkdir -p "$DOCKER_DATA_DIR/plex/transcode"
    mkdir -p "$DOCKER_DATA_DIR/plex/media/movies"
    mkdir -p "$DOCKER_DATA_DIR/plex/media/tv"
    mkdir -p "$DOCKER_DATA_DIR/plex/media/music"
    mkdir -p "$DOCKER_DATA_DIR/plex/media/photos"
    mkdir -p "$DOCKER_DATA_DIR/jellyfin/config"
    mkdir -p "$DOCKER_DATA_DIR/jellyfin/cache"
    mkdir -p "$DOCKER_DATA_DIR/jellyfin/media"
    mkdir -p "$DOCKER_DATA_DIR/radarr/config"
    mkdir -p "$DOCKER_DATA_DIR/sonarr/config"
    mkdir -p "$DOCKER_DATA_DIR/lidarr/config"
    mkdir -p "$DOCKER_DATA_DIR/readarr/config"
    mkdir -p "$DOCKER_DATA_DIR/bazarr/config"
    mkdir -p "$DOCKER_DATA_DIR/prowlarr/config"
    mkdir -p "$DOCKER_DATA_DIR/overseerr/config"
    mkdir -p "$DOCKER_DATA_DIR/tautulli/config"
    mkdir -p "$DOCKER_DATA_DIR/transmission/config"
    mkdir -p "$DOCKER_DATA_DIR/transmission/downloads"
    mkdir -p "$DOCKER_DATA_DIR/transmission/watch"
    mkdir -p "$DOCKER_DATA_DIR/qbittorrent/config"
    mkdir -p "$DOCKER_DATA_DIR/qbittorrent/downloads"
    mkdir -p "$DOCKER_DATA_DIR/sabnzbd/config"
    
    log_info "Creating smart home directories..."
    mkdir -p "$DOCKER_DATA_DIR/homeassistant/config"
    mkdir -p "$DOCKER_DATA_DIR/nodered/data"
    mkdir -p "$DOCKER_DATA_DIR/mosquitto/config"
    mkdir -p "$DOCKER_DATA_DIR/mosquitto/data"
    mkdir -p "$DOCKER_DATA_DIR/mosquitto/log"
    mkdir -p "$DOCKER_DATA_DIR/zigbee2mqtt/data"
    mkdir -p "$DOCKER_DATA_DIR/esphome/config"
    
    log_info "Creating AI & development directories..."
    mkdir -p "$DOCKER_DATA_DIR/ollama/models"
    mkdir -p "$DOCKER_DATA_DIR/openwebui/data"
    mkdir -p "$DOCKER_DATA_DIR/codeserver/config"
    mkdir -p "$DOCKER_DATA_DIR/jupyter/notebooks"
    mkdir -p "$DOCKER_DATA_DIR/gitea/data"
    
    log_info "Creating network service directories..."
    mkdir -p "$DOCKER_DATA_DIR/adguard/work"
    mkdir -p "$DOCKER_DATA_DIR/adguard/conf"
    mkdir -p "$DOCKER_DATA_DIR/nginx-proxy-manager/data"
    mkdir -p "$DOCKER_DATA_DIR/nginx-proxy-manager/letsencrypt"
    mkdir -p "$DOCKER_DATA_DIR/wireguard/config"
    mkdir -p "$DOCKER_DATA_DIR/rustdesk/data"
    
    log_info "Creating monitoring directories..."
    mkdir -p "$DOCKER_DATA_DIR/prometheus/data"
    mkdir -p "$DOCKER_DATA_DIR/prometheus/config"
    mkdir -p "$DOCKER_DATA_DIR/grafana/data"
    mkdir -p "$DOCKER_DATA_DIR/loki/data"
    mkdir -p "$DOCKER_DATA_DIR/loki/config"
    mkdir -p "$DOCKER_DATA_DIR/promtail/config"
    mkdir -p "$DOCKER_DATA_DIR/uptime-kuma/data"
    mkdir -p "$DOCKER_DATA_DIR/netdata/config"
    
    log_info "Creating storage & backup directories..."
    mkdir -p "$DOCKER_DATA_DIR/nextcloud/data"
    mkdir -p "$DOCKER_DATA_DIR/nextcloud/config"
    mkdir -p "$DOCKER_DATA_DIR/syncthing/config"
    mkdir -p "$DOCKER_DATA_DIR/syncthing/data"
    mkdir -p "$DOCKER_DATA_DIR/duplicati/config"
    mkdir -p "$DOCKER_DATA_DIR/duplicati/backups"
    mkdir -p "$DOCKER_DATA_DIR/filebrowser/config"
    
    log_info "Creating security directories..."
    mkdir -p "$DOCKER_DATA_DIR/vaultwarden/data"
    mkdir -p "$DOCKER_DATA_DIR/fail2ban/config"
    mkdir -p "$DOCKER_DATA_DIR/fail2ban/db"
    mkdir -p "$DOCKER_DATA_DIR/crowdsec/config"
    mkdir -p "$DOCKER_DATA_DIR/crowdsec/data"
    
    log_info "Creating dashboard directories..."
    mkdir -p "$DOCKER_DATA_DIR/heimdall/config"
    mkdir -p "$DOCKER_DATA_DIR/homer/assets"
    mkdir -p "$DOCKER_DATA_DIR/dashy/config"
    mkdir -p "$DOCKER_DATA_DIR/organizr/config"
    
    log_info "Creating utility directories..."
    mkdir -p "$DOCKER_DATA_DIR/paperless/data"
    mkdir -p "$DOCKER_DATA_DIR/paperless/media"
    mkdir -p "$DOCKER_DATA_DIR/paperless/consume"
    mkdir -p "$DOCKER_DATA_DIR/photoprism/storage"
    mkdir -p "$DOCKER_DATA_DIR/photoprism/originals"
    mkdir -p "$DOCKER_DATA_DIR/photoprism/import"
    mkdir -p "$DOCKER_DATA_DIR/calibre/config"
    mkdir -p "$DOCKER_DATA_DIR/calibre/books"
    mkdir -p "$DOCKER_DATA_DIR/freshrss/data"
    mkdir -p "$DOCKER_DATA_DIR/freshrss/extensions"
    
    log_info "✓ Complete directory structure created"
}

################################################################################
# Phase 3: Install Dependencies
################################################################################

install_dependencies() {
    log_section "Phase 3: Installing System Dependencies"
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    
    log_info "Installing system packages..."
    brew install --cask orbstack 2>/dev/null || log_info "OrbStack already installed"
    brew install wget curl git htop jq openssl 2>/dev/null || true
    
    log_info "Waiting for OrbStack to be ready..."
    # Give OrbStack time to start if just installed
    sleep 5
    
    # Verify OrbStack/Docker is running
    local max_attempts=10
    local attempt=1
    while ! docker ps &> /dev/null; do
        if [ $attempt -eq $max_attempts ]; then
            error_exit "Docker is not running. Please start OrbStack manually and run this script again."
        fi
        log_warn "Waiting for Docker to be ready... (attempt $attempt/$max_attempts)"
        sleep 3
        ((attempt++))
    done
    
    log_info "✓ Dependencies installed and Docker is ready"
}

################################################################################
# Phase 4: Docker Networks
################################################################################

create_docker_networks() {
    log_section "Phase 4: Creating Docker Networks"
    
    log_info "Creating networks..."
    docker network create homelab-net 2>/dev/null || log_info "homelab-net exists"
    docker network create proxy-net 2>/dev/null || log_info "proxy-net exists"
    docker network create media-net 2>/dev/null || log_info "media-net exists"
    docker network create monitoring-net 2>/dev/null || log_info "monitoring-net exists"
    docker network create database-net 2>/dev/null || log_info "database-net exists"
    
    log_info "✓ Docker networks created"
}

################################################################################
# Phase 5: Database Stack
################################################################################

deploy_databases() {
    log_section "Phase 5: Deploying Database Stack"
    
    cat > "$COMPOSE_DIR/databases.yml" << EOF
services:
  postgres:
    image: postgres:15-alpine
    container_name: postgres
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: homelab
    volumes:
      - ${DOCKER_DATA_DIR}/postgres/data:/var/lib/postgresql/data
    networks:
      - database-net
    ports:
      - "5432:5432"

  mariadb:
    image: mariadb:latest
    container_name: mariadb
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: homelab
    volumes:
      - ${DOCKER_DATA_DIR}/mariadb/data:/var/lib/mysql
    networks:
      - database-net
    ports:
      - "3306:3306"

  mongodb:
    image: mongo:latest
    container_name: mongodb
    restart: unless-stopped
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_ROOT_PASSWORD}
    volumes:
      - ${DOCKER_DATA_DIR}/mongodb/data:/data/db
    networks:
      - database-net
    ports:
      - "27017:27017"

  redis:
    image: redis:alpine
    container_name: redis
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - ${DOCKER_DATA_DIR}/redis/data:/data
    networks:
      - database-net
    ports:
      - "6379:6379"

  influxdb:
    image: influxdb:2.7-alpine
    container_name: influxdb
    restart: unless-stopped
    environment:
      DOCKER_INFLUXDB_INIT_MODE: setup
      DOCKER_INFLUXDB_INIT_USERNAME: admin
      DOCKER_INFLUXDB_INIT_PASSWORD: ${POSTGRES_PASSWORD}
      DOCKER_INFLUXDB_INIT_ORG: homelab
      DOCKER_INFLUXDB_INIT_BUCKET: metrics
    volumes:
      - ${DOCKER_DATA_DIR}/influxdb/data:/var/lib/influxdb2
    networks:
      - database-net
    ports:
      - "8086:8086"

networks:
  database-net:
    external: true
EOF
    
    log_info "Starting database stack..."
    docker compose -f "$COMPOSE_DIR/databases.yml" up -d
    
    log_info "Waiting for databases to initialize..."
    sleep 10
    
    log_info "✓ Database stack deployed"
}

################################################################################
# Phase 6: Core Infrastructure
################################################################################

deploy_core_infrastructure() {
    log_section "Phase 6: Deploying Core Infrastructure"
    
    # Portainer
    log_service "Portainer"
    cat > "$COMPOSE_DIR/portainer.yml" << EOF
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ${DOCKER_DATA_DIR}/portainer:/data
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
EOF
    docker compose -f "$COMPOSE_DIR/portainer.yml" up -d
    
    # Watchtower
    log_service "Watchtower"
    cat > "$COMPOSE_DIR/watchtower.yml" << EOF
services:
  watchtower:
    image: containrrr/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_SCHEDULE=0 0 4 * * *
      - TZ=${TIMEZONE}
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
EOF
    docker compose -f "$COMPOSE_DIR/watchtower.yml" up -d
    
    log_info "✓ Core infrastructure deployed"
}

################################################################################
# Phase 7: Complete Media Stack
################################################################################

deploy_complete_media_stack() {
    log_section "Phase 7: Deploying Complete Media Stack (13 services)"
    
    cat > "$COMPOSE_DIR/media-complete.yml" << EOF
services:
  plex:
    image: plexinc/pms-docker:latest
    container_name: plex
    restart: unless-stopped
    network_mode: host
    environment:
      - TZ=${TIMEZONE}
      - PLEX_CLAIM=${PLEX_CLAIM_TOKEN}
    volumes:
      - ${DOCKER_DATA_DIR}/plex/config:/config
      - ${DOCKER_DATA_DIR}/plex/transcode:/transcode
      - ${DOCKER_DATA_DIR}/plex/media:/data

  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    ports:
      - "8096:8096"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/jellyfin/config:/config
      - ${DOCKER_DATA_DIR}/jellyfin/cache:/cache
      - ${DOCKER_DATA_DIR}/plex/media:/media
    networks:
      - media-net

  radarr:
    image: linuxserver/radarr:latest
    container_name: radarr
    restart: unless-stopped
    ports:
      - "7878:7878"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/radarr/config:/config
      - ${DOCKER_DATA_DIR}/plex/media/movies:/movies
      - ${DOCKER_DATA_DIR}/transmission/downloads:/downloads
    networks:
      - media-net

  sonarr:
    image: linuxserver/sonarr:latest
    container_name: sonarr
    restart: unless-stopped
    ports:
      - "8989:8989"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/sonarr/config:/config
      - ${DOCKER_DATA_DIR}/plex/media/tv:/tv
      - ${DOCKER_DATA_DIR}/transmission/downloads:/downloads
    networks:
      - media-net

  lidarr:
    image: linuxserver/lidarr:latest
    container_name: lidarr
    restart: unless-stopped
    ports:
      - "8686:8686"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/lidarr/config:/config
      - ${DOCKER_DATA_DIR}/plex/media/music:/music
      - ${DOCKER_DATA_DIR}/transmission/downloads:/downloads
    networks:
      - media-net

  readarr:
    image: linuxserver/readarr:develop
    container_name: readarr
    restart: unless-stopped
    ports:
      - "8787:8787"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/readarr/config:/config
      - ${DOCKER_DATA_DIR}/transmission/downloads:/downloads
    networks:
      - media-net

  bazarr:
    image: linuxserver/bazarr:latest
    container_name: bazarr
    restart: unless-stopped
    ports:
      - "6767:6767"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/bazarr/config:/config
      - ${DOCKER_DATA_DIR}/plex/media/movies:/movies
      - ${DOCKER_DATA_DIR}/plex/media/tv:/tv
    networks:
      - media-net

  prowlarr:
    image: linuxserver/prowlarr:latest
    container_name: prowlarr
    restart: unless-stopped
    ports:
      - "9696:9696"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/prowlarr/config:/config
    networks:
      - media-net

  overseerr:
    image: linuxserver/overseerr:latest
    container_name: overseerr
    restart: unless-stopped
    ports:
      - "5055:5055"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/overseerr/config:/config
    networks:
      - media-net

  tautulli:
    image: linuxserver/tautulli:latest
    container_name: tautulli
    restart: unless-stopped
    ports:
      - "8181:8181"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/tautulli/config:/config
    networks:
      - media-net

  transmission:
    image: linuxserver/transmission:latest
    container_name: transmission
    restart: unless-stopped
    ports:
      - "9091:9091"
      - "51413:51413"
      - "51413:51413/udp"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/transmission/config:/config
      - ${DOCKER_DATA_DIR}/transmission/downloads:/downloads
      - ${DOCKER_DATA_DIR}/transmission/watch:/watch
    networks:
      - media-net

  qbittorrent:
    image: linuxserver/qbittorrent:latest
    container_name: qbittorrent
    restart: unless-stopped
    ports:
      - "8082:8080"
      - "6881:6881"
      - "6881:6881/udp"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
      - WEBUI_PORT=8080
    volumes:
      - ${DOCKER_DATA_DIR}/qbittorrent/config:/config
      - ${DOCKER_DATA_DIR}/qbittorrent/downloads:/downloads
    networks:
      - media-net

  sabnzbd:
    image: linuxserver/sabnzbd:latest
    container_name: sabnzbd
    restart: unless-stopped
    ports:
      - "8083:8080"
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
    volumes:
      - ${DOCKER_DATA_DIR}/sabnzbd/config:/config
      - ${DOCKER_DATA_DIR}/transmission/downloads:/downloads
    networks:
      - media-net

networks:
  media-net:
    external: true
EOF
    
    log_info "Starting media stack (this may take a few minutes)..."
    docker compose -f "$COMPOSE_DIR/media-complete.yml" up -d
    
    log_info "✓ Complete media stack deployed"
}

################################################################################
# Phase 8: AI & Development Stack
################################################################################

deploy_ai_development() {
    log_section "Phase 8: Deploying AI & Development Stack"
    
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
    image: linuxserver/code-server:latest
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
# Phase 9: Smart Home Stack
################################################################################

deploy_smart_home() {
    log_section "Phase 9: Deploying Smart Home Stack"
    
    # Create Mosquitto config
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
# Phase 10: Network Services
################################################################################

deploy_network_services() {
    log_section "Phase 10: Deploying Network Services"
    
    cat > "$COMPOSE_DIR/network.yml" << EOF
services:
  adguard:
    image: adguard/adguardhome:latest
    container_name: adguard
    restart: unless-stopped
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "3002:3000/tcp"
      - "8084:80/tcp"
    volumes:
      - ${DOCKER_DATA_DIR}/adguard/work:/opt/adguardhome/work
      - ${DOCKER_DATA_DIR}/adguard/conf:/opt/adguardhome/conf
    networks:
      - homelab-net

  nginx-proxy-manager:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "81:81"
    environment:
      DB_SQLITE_FILE: "/data/database.sqlite"
    volumes:
      - ${DOCKER_DATA_DIR}/nginx-proxy-manager/data:/data
      - ${DOCKER_DATA_DIR}/nginx-proxy-manager/letsencrypt:/etc/letsencrypt
    networks:
      - homelab-net
      - proxy-net

  wireguard:
    image: linuxserver/wireguard:latest
    container_name: wireguard
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TIMEZONE}
      - SERVERURL=auto
      - SERVERPORT=51820
      - PEERS=5
      - PEERDNS=auto
    volumes:
      - ${DOCKER_DATA_DIR}/wireguard/config:/config
      - /lib/modules:/lib/modules:ro
    ports:
      - "51820:51820/udp"
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    networks:
      - homelab-net

  hbbs:
    container_name: hbbs
    image: rustdesk/rustdesk-server:latest
    command: hbbs -r rustdesk.local:21117
    volumes:
      - ${DOCKER_DATA_DIR}/rustdesk/data:/root
    networks:
      - homelab-net
    ports:
      - 21115:21115
      - 21116:21116
      - 21116:21116/udp
      - 21118:21118
    restart: unless-stopped

  hbbr:
    container_name: hbbr
    image: rustdesk/rustdesk-server:latest
    command: hbbr
    volumes:
      - ${DOCKER_DATA_DIR}/rustdesk/data:/root
    networks:
      - homelab-net
    ports:
      - 21117:21117
      - 21119:21119
    restart: unless-stopped

networks:
  homelab-net:
    external: true
  proxy-net:
    external: true
EOF
    
    docker compose -f "$COMPOSE_DIR/network.yml" up -d
    
    log_info "Waiting for RustDesk to initialize..."
    sleep 5
    
    RUSTDESK_KEY=$(docker logs hbbs 2>&1 | grep "Key:" | awk '{print $NF}' | tail -1)
    
    log_info "✓ Network services deployed"
}

################################################################################
# Phase 11: Complete Monitoring Stack
################################################################################

deploy_complete_monitoring() {
    log_section "Phase 11: Deploying Complete Monitoring Stack"
    
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
    log_info "✓ Complete monitoring stack deployed"
}

################################################################################
# Phase 12: Storage & Backup
################################################################################

deploy_storage_backup() {
    log_section "Phase 12: Deploying Storage & Backup Services"
    
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
    image: linuxserver/syncthing:latest
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
    image: linuxserver/duplicati:latest
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
    log_info "✓ Storage & backup services deployed"
}

################################################################################
# Phase 13: Security Stack
################################################################################

deploy_security() {
    log_section "Phase 13: Deploying Security Services"
    
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
    log_info "✓ Security services deployed"
}

################################################################################
# Phase 14: Dashboard Services
################################################################################

deploy_dashboards() {
    log_section "Phase 14: Deploying Dashboard Services"
    
    cat > "$COMPOSE_DIR/dashboards.yml" << EOF
services:
  heimdall:
    image: linuxserver/heimdall:latest
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
    log_info "✓ Dashboard services deployed"
}

################################################################################
# Phase 15: Utilities
################################################################################

deploy_utilities() {
    log_section "Phase 15: Deploying Utility Services"
    
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
      - PAPERLESS_SECRET_KEY=${AUTHELIA_JWT_SECRET}
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
    image: linuxserver/calibre:latest
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
    log_info "✓ Utility services deployed"
}

################################################################################
# Phase 16: Summary & Credentials
################################################################################

print_complete_summary() {
    log_section "Installation Complete!"
    
    # Count running containers
    local container_count=$(docker ps --format '{{.Names}}' | wc -l | tr -d ' ')
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  🎉 SUCCESS! ${container_count} SERVICES DEPLOYED!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${BLUE}CORE INFRASTRUCTURE${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Portainer:           http://localhost:9000"
    echo ""
    
    echo -e "${BLUE}MEDIA SERVICES (13)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Plex:                http://localhost:32400/web"
    echo "Jellyfin:            http://localhost:8096"
    echo "Radarr:              http://localhost:7878"
    echo "Sonarr:              http://localhost:8989"
    echo "Lidarr:              http://localhost:8686"
    echo "Readarr:             http://localhost:8787"
    echo "Bazarr:              http://localhost:6767"
    echo "Prowlarr:            http://localhost:9696"
    echo "Overseerr:           http://localhost:5055"
    echo "Tautulli:            http://localhost:8181"
    echo "Transmission:        http://localhost:9091"
    echo "qBittorrent:         http://localhost:8082"
    echo "SABnzbd:             http://localhost:8083"
    echo ""
    
    echo -e "${BLUE}AI & DEVELOPMENT (5)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Ollama:              http://localhost:11434"
    echo "OpenWebUI:           http://localhost:3000"
    echo "Code Server:         http://localhost:8443"
    echo "Jupyter:             http://localhost:8888"
    echo "Gitea:               http://localhost:3001"
    echo ""
    
    echo -e "${BLUE}SMART HOME (5)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Home Assistant:      http://localhost:8123"
    echo "Node-RED:            http://localhost:1880"
    echo "Zigbee2MQTT:         http://localhost:8080"
    echo "ESPHome:             http://localhost:6052"
    echo "Mosquitto MQTT:      mqtt://localhost:1883"
    echo ""
    
    echo -e "${BLUE}NETWORK SERVICES (6)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "AdGuard Home:        http://localhost:3002"
    echo "Nginx Proxy Manager: http://localhost:81"
    echo "WireGuard VPN:       Port 51820/udp"
    if [ -n "$RUSTDESK_KEY" ]; then
        echo -e "RustDesk Key:        ${YELLOW}${RUSTDESK_KEY}${NC}"
    fi
    echo ""
    
    echo -e "${BLUE}MONITORING (8)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Prometheus:          http://localhost:9090"
    echo "Grafana:             http://localhost:3003"
    echo "Loki:                http://localhost:3100"
    echo "Uptime Kuma:         http://localhost:3004"
    echo "Netdata:             http://localhost:19999"
    echo "cAdvisor:            http://localhost:8085"
    echo "Node Exporter:       http://localhost:9100"
    echo ""
    
    echo -e "${BLUE}STORAGE & BACKUP (4)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Nextcloud:           http://localhost:8086"
    echo "Syncthing:           http://localhost:8384"
    echo "Duplicati:           http://localhost:8200"
    echo "File Browser:        http://localhost:8087"
    echo ""
    
    echo -e "${BLUE}SECURITY (3)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Vaultwarden:         http://localhost:8088"
    echo "CrowdSec:            http://localhost:8089"
    echo "Fail2ban:            Active (host network)"
    echo ""
    
    echo -e "${BLUE}DASHBOARDS (4)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Heimdall:            http://localhost:8090"
    echo "Homer:               http://localhost:8091"
    echo "Dashy:               http://localhost:4000"
    echo "Organizr:            http://localhost:8092"
    echo ""
    
    echo -e "${BLUE}UTILITIES (4)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Paperless-ngx:       http://localhost:8093"
    echo "PhotoPrism:          http://localhost:2342"
    echo "Calibre:             http://localhost:8094"
    echo "FreshRSS:            http://localhost:8096"
    echo ""
    
    echo -e "${BLUE}DATABASES (5)${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "PostgreSQL:          localhost:5432"
    echo "MariaDB:             localhost:3306"
    echo "MongoDB:             localhost:27017"
    echo "Redis:               localhost:6379"
    echo "InfluxDB:            localhost:8086"
    echo ""
    
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  ⚠️  CRITICAL: SAVE ALL CREDENTIALS TO 1PASSWORD NOW!${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Save all credentials
    cat > "$HOMELAB_DIR/docs/CREDENTIALS.txt" << EOF
╔═══════════════════════════════════════════════════════════════╗
║         HOMELAB MASTER CREDENTIALS - SAVE TO 1PASSWORD        ║
╚═══════════════════════════════════════════════════════════════╝

Generated: $(date)
Hostname: $MAC_HOSTNAME

DATABASE PASSWORDS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PostgreSQL:       $POSTGRES_PASSWORD
MySQL/MariaDB:    $MYSQL_ROOT_PASSWORD
MongoDB:          $MONGO_ROOT_PASSWORD
Redis:            $REDIS_PASSWORD

SERVICE CREDENTIALS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Nextcloud Admin:  admin / $NEXTCLOUD_ADMIN_PASSWORD
Grafana Admin:    admin / $GRAFANA_ADMIN_PASSWORD
PhotoPrism:       admin / $NEXTCLOUD_ADMIN_PASSWORD
Code Server:      changeme (CHANGE THIS!)

SECURITY SECRETS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Authelia JWT:     $AUTHELIA_JWT_SECRET
Authelia Session: $AUTHELIA_SESSION_SECRET
Authelia Storage: $AUTHELIA_STORAGE_ENCRYPTION_KEY

REMOTE ACCESS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RustDesk Key:     $RUSTDESK_KEY

╔═══════════════════════════════════════════════════════════════╗
║  ⚠️  CRITICAL: Add these to 1Password immediately and delete  ║
║      this file after securing the credentials!                ║
╚═══════════════════════════════════════════════════════════════╝

To delete this file after securing:
rm "$HOMELAB_DIR/docs/CREDENTIALS.txt"
EOF
    
    chmod 600 "$HOMELAB_DIR/docs/CREDENTIALS.txt"
    
    echo "All credentials saved to: $HOMELAB_DIR/docs/CREDENTIALS.txt"
    echo ""
    echo -e "${GREEN}Next Steps:${NC}"
    echo "1. Add all credentials from CREDENTIALS.txt to 1Password"
    echo "2. Delete the CREDENTIALS.txt file after saving"
    echo "3. Configure each service through their web interfaces"
    echo "4. Set up media library paths in Plex/Jellyfin"
    echo "5. Configure monitoring dashboards in Grafana"
    echo "6. Set up Home Assistant devices"
    echo "7. Configure backup schedules in Duplicati"
    echo "8. Configure RustDesk clients with the public key"
    echo ""
    
    echo "Installation log saved to: $HOMELAB_DIR/docs/install-$(date +%Y%m%d-%H%M%S).log"
}

################################################################################
# Main Execution
################################################################################

main() {
    # Create docs directory first for logging
    mkdir -p "$HOMELAB_DIR/docs"
    
    # Redirect all output to log file
    exec 1> >(tee "$HOMELAB_DIR/docs/install-$(date +%Y%m%d-%H%M%S).log")
    exec 2>&1
    
    log_section "HomeLab Complete Installation - 60+ Services"
    log_info "Starting comprehensive deployment..."
    log_info "Estimated time: 20-30 minutes depending on internet speed"
    echo ""
    
    check_prerequisites
    cleanup_existing
    create_directory_structure
    install_dependencies
    create_docker_networks
    deploy_databases
    deploy_core_infrastructure
    deploy_complete_media_stack
    deploy_ai_development
    deploy_smart_home
    deploy_network_services
    deploy_complete_monitoring
    deploy_storage_backup
    deploy_security
    deploy_dashboards
    deploy_utilities
    print_complete_summary
}

# Run the installation
main "$@"