#!/bin/bash

# ARM64-Compatible Media Stack for M4 Mac Mini
# This version only includes images that definitely support ARM64

set -euo pipefail

HOMELAB_DIR="$HOME/HomeLab"
DOCKER_DATA_DIR="$HOMELAB_DIR/Docker/Data"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"

echo "Deploying ARM64-Compatible Media Stack..."

# Remove any failed attempts
docker compose -f "$COMPOSE_DIR/media-complete.yml" down 2>/dev/null || true

# Create minimal working media stack (ARM64 verified)
cat > "$COMPOSE_DIR/media-complete.yml" << 'EOF'
services:
  # Plex - ARM64 native
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

  # Jellyfin - ARM64 native
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    ports:
      - "8096:8096"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/jellyfin/config:/config
      - /Users/homelab/HomeLab/Docker/Data/jellyfin/cache:/cache
      - /Users/homelab/HomeLab/Docker/Data/plex/media:/media
    networks:
      - media-net

  # Radarr - ARM64 native via LinuxServer
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

  # Sonarr - ARM64 native via LinuxServer
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

  # Prowlarr - ARM64 native via LinuxServer
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

  # Transmission - ARM64 native via LinuxServer
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

  # Overseerr - ARM64 supported
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

echo "Starting media stack (this will take a few minutes to pull images)..."
docker compose -f "$COMPOSE_DIR/media-complete.yml" up -d

echo ""
echo "✓ ARM64-Compatible Media Stack Deployed!"
echo ""
echo "Services running:"
echo "  - Plex:        http://localhost:32400/web"
echo "  - Jellyfin:    http://localhost:8096"
echo "  - Radarr:      http://localhost:7878"
echo "  - Sonarr:      http://localhost:8989"
echo "  - Prowlarr:    http://localhost:9696"
echo "  - Overseerr:   http://localhost:5055"
echo "  - Transmission: http://localhost:9091"
echo ""
echo "Skipped (no ARM64 support):"
echo "  - Lidarr, Readarr, Bazarr, Tautulli, qBittorrent, SABnzbd"
echo ""
echo "Check status:"
echo "  docker ps"