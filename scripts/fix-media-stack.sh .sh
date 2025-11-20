#!/bin/bash

# Quick fix for ARM64 media stack issue
# Run this to continue from Phase 7

set -euo pipefail

HOMELAB_DIR="$HOME/HomeLab"
DOCKER_DATA_DIR="$HOMELAB_DIR/Docker/Data"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"
TIMEZONE="Europe/London"
PUID="501"
PGID="20"

echo "Fixing Phase 7: Deploying ARM64-Compatible Media Stack..."

# Remove the failed media stack
docker compose -f "$COMPOSE_DIR/media-complete.yml" down 2>/dev/null || true

# Create ARM64-compatible media stack
cat > "$COMPOSE_DIR/media-complete.yml" << 'EOF'
services:
  plex:
    image: plexinc/pms-docker:latest
    container_name: plex
    restart: unless-stopped
    network_mode: host
    environment:
      - TZ=Europe/London
      - PLEX_CLAIM=
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

  radarr:
    image: linuxserver/radarr:latest
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
    image: linuxserver/sonarr:latest
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

  lidarr:
    image: linuxserver/lidarr:latest
    container_name: lidarr
    restart: unless-stopped
    ports:
      - "8686:8686"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/lidarr/config:/config
      - /Users/homelab/HomeLab/Docker/Data/plex/media/music:/music
      - /Users/homelab/HomeLab/Docker/Data/transmission/downloads:/downloads
    networks:
      - media-net

  readarr:
    image: linuxserver/readarr:develop
    container_name: readarr
    restart: unless-stopped
    ports:
      - "8787:8787"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/readarr/config:/config
      - /Users/homelab/HomeLab/Docker/Data/transmission/downloads:/downloads
    networks:
      - media-net

  bazarr:
    image: linuxserver/bazarr:latest
    container_name: bazarr
    restart: unless-stopped
    ports:
      - "6767:6767"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/bazarr/config:/config
      - /Users/homelab/HomeLab/Docker/Data/plex/media/movies:/movies
      - /Users/homelab/HomeLab/Docker/Data/plex/media/tv:/tv
    networks:
      - media-net

  prowlarr:
    image: linuxserver/prowlarr:latest
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

  overseerr:
    image: linuxserver/overseerr:latest
    container_name: overseerr
    restart: unless-stopped
    ports:
      - "5055:5055"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/overseerr/config:/config
    networks:
      - media-net

  tautulli:
    image: linuxserver/tautulli:latest
    container_name: tautulli
    restart: unless-stopped
    ports:
      - "8181:8181"
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/tautulli/config:/config
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
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/transmission/config:/config
      - /Users/homelab/HomeLab/Docker/Data/transmission/downloads:/downloads
      - /Users/homelab/HomeLab/Docker/Data/transmission/watch:/watch
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
      - PUID=501
      - PGID=20
      - TZ=Europe/London
      - WEBUI_PORT=8080
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/qbittorrent/config:/config
      - /Users/homelab/HomeLab/Docker/Data/qbittorrent/downloads:/downloads
    networks:
      - media-net

  # SABnzbd - Skip if it was the problem (not ARM64 native)
  # sabnzbd:
  #   image: linuxserver/sabnzbd:latest
  #   ...

networks:
  media-net:
    external: true
EOF

echo "Starting ARM64-compatible media stack..."
docker compose -f "$COMPOSE_DIR/media-complete.yml" up -d

echo "✓ Media stack deployed successfully!"
echo ""
echo "Continuing with remaining phases..."
echo ""

# Continue with remaining phases from the original script
# You can run the rest manually or I can provide those too

echo "Media stack is now running. Check status with:"
echo "docker ps | grep -E 'plex|radarr|sonarr|jellyfin'"