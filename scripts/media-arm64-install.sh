#!/bin/bash

# ARM64-Compatible Media Stack for M4 Mac Mini
# MINIMAL VERSION - Only 7 confirmed ARM64 services

set -euo pipefail

echo "==================================================================="
echo "  Deploying MINIMAL ARM64 Media Stack (7 services)"
echo "==================================================================="
echo ""

COMPOSE_DIR="$HOME/HomeLab/Docker/Compose"

# Remove any existing failed stack
docker compose -f "$COMPOSE_DIR/media-complete.yml" down 2>/dev/null || true
rm -f "$COMPOSE_DIR/media-complete.yml"

# Create MINIMAL ARM64 stack
cat > "$COMPOSE_DIR/media-arm64.yml" << 'EOF'
services:
  plex:
    image: plexinc/pms-docker:latest
    container_name: plex
    restart: unless-stopped
    network_mode: host
    environment:
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/plex/config:/config
      - /Users/homelab/HomeLab/Docker/Data/plex/transcode:/transcode
      - /Users/homelab/HomeLab/Docker/Data/plex/media:/data

  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    ports:
      - "8096:8096"
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/jellyfin/config:/config
      - /Users/homelab/HomeLab/Docker/Data/jellyfin/cache:/cache
      - /Users/homelab/HomeLab/Docker/Data/plex/media:/media
    networks:
      - media-net

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    restart: unless-stopped
    ports:
      - "7878:7878"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/radarr/config:/config
      - /Users/homelab/HomeLab/Docker/Data/plex/media/movies:/movies
      - /Users/homelab/HomeLab/Docker/Data/transmission/downloads:/downloads
    networks:
      - media-net

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    restart: unless-stopped
    ports:
      - "8989:8989"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/sonarr/config:/config
      - /Users/homelab/HomeLab/Docker/Data/plex/media/tv:/tv
      - /Users/homelab/HomeLab/Docker/Data/transmission/downloads:/downloads
    networks:
      - media-net

  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    restart: unless-stopped
    ports:
      - "9696:9696"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/prowlarr/config:/config
    networks:
      - media-net

  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    restart: unless-stopped
    ports:
      - "9091:9091"
      - "51413:51413"
      - "51413:51413/udp"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/transmission/config:/config
      - /Users/homelab/HomeLab/Docker/Data/transmission/downloads:/downloads
      - /Users/homelab/HomeLab/Docker/Data/transmission/watch:/watch
    networks:
      - media-net

  overseerr:
    image: sctx/overseerr:latest
    container_name: overseerr
    restart: unless-stopped
    ports:
      - "5055:5055"
    environment:
      - LOG_LEVEL=info
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/overseerr/config:/app/config
    networks:
      - media-net

networks:
  media-net:
    external: true
EOF

echo "Starting services (this will take 3-5 minutes to download images)..."
echo ""

docker compose -f "$COMPOSE_DIR/media-arm64.yml" up -d

echo ""
echo "==================================================================="
echo "  ✓ Media Stack Deployed Successfully!"
echo "==================================================================="
echo ""
echo "Access your services:"
echo "  Plex:        http://localhost:32400/web"
echo "  Jellyfin:    http://localhost:8096"
echo "  Radarr:      http://localhost:7878"
echo "  Sonarr:      http://localhost:8989"
echo "  Prowlarr:    http://localhost:9696"
echo "  Overseerr:   http://localhost:5055"
echo "  Transmission: http://localhost:9091"
echo ""
echo "Check status: docker ps"
echo ""