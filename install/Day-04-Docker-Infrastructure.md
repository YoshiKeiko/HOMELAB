---
title: Volume 03: Docker Infrastructure (Days 3-4)
tags: [homelab, docker, containers, infrastructure]
created: 2025-11-11
type: homelab-guide
---

# Volume 03: Docker Infrastructure (Days 3-4)

**Building Your Container Empire**

This volume covers complete Docker setup with all 62+ services.

## What You'll Complete

- Docker & OrbStack installation
- Tailscale VPN for remote access
- DuckDNS for dynamic DNS
- Nginx Proxy Manager with SSL
- Portainer for management
- All 62+ services deployed

## Prerequisites

- Volume 01 complete (accounts, downloads)
- Volume 02 complete (M4 setup, network, storage)
- Admin access to M4
- 1Password ready

---

# Guide 07: Docker & OrbStack

## Installation

1. Install OrbStack:
```bash
brew install orbstack
```

2. Launch and configure resources:
- Memory: 16GB
- CPU: 6 cores
- Storage: 100GB

3. Verify installation:
```bash
docker --version
docker ps
docker run hello-world
```

## Docker Basics

Essential commands:
```bash
# Containers
docker ps                    # List running
docker ps -a                # List all
docker start <name>         # Start container
docker stop <name>          # Stop container
docker logs -f <name>       # Follow logs

# Images
docker images               # List images
docker pull <image>         # Download image
docker rmi <image>          # Remove image

# System
docker system df            # Disk usage
docker system prune -a      # Clean everything
```

## Docker Compose

Create folder structure:
```bash
mkdir -p ~/HomeLab/Docker/{Compose,Configs,Data}
```

Test compose file:
```bash
cat > ~/HomeLab/Docker/Compose/test.yml << 'EOF'
version: "3.8"
services:
  whoami:
    image: traefik/whoami
    ports:
      - "8080:80"
EOF

docker compose -f test.yml up -d
curl http://localhost:8080
docker compose -f test.yml down
```

---

# Guide 08: Tailscale VPN

## Setup

1. Install Tailscale:
```bash
brew install tailscale
```

2. Connect:
```bash
tailscale up
# Opens browser - sign in with GitHub
```

3. Get your Tailscale IP:
```bash
tailscale ip -4
# Note this IP - save to 1Password
```

4. Test from another device:
```bash
ssh steve@<tailscale-ip>
```

## Enable Exit Node (Optional)

```bash
sudo tailscale up --advertise-exit-node
```

Then approve in Tailscale admin console.

---

# Guide 09: DuckDNS

## Create Update Script

```bash
mkdir -p ~/HomeLab/Scripts/Maintenance

cat > ~/HomeLab/Scripts/Maintenance/duckdns-update.sh << 'EOF'
#!/bin/bash
SUBDOMAIN="stevehomelab"
TOKEN="YOUR-TOKEN-FROM-1PASSWORD"
CURRENT_IP=$(curl -s https://ipv4.icanhazip.com)
RESPONSE=$(curl -s "https://www.duckdns.org/update?domains=${SUBDOMAIN}&token=${TOKEN}&ip=${CURRENT_IP}")
echo "$(date): IP=$CURRENT_IP, Response=$RESPONSE" >> ~/HomeLab/Documentation/duckdns.log
EOF

chmod +x ~/HomeLab/Scripts/Maintenance/duckdns-update.sh
```

## Schedule Updates

```bash
cat > ~/Library/LaunchAgents/com.homelab.duckdns.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.homelab.duckdns</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/steve/HomeLab/Scripts/Maintenance/duckdns-update.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

launchctl load ~/Library/LaunchAgents/com.homelab.duckdns.plist
```

Test: `nslookup stevehomelab.duckdns.org`

---

# Guide 10: Nginx Proxy Manager

## Deploy

```bash
cat > ~/HomeLab/Docker/Compose/nginx-proxy-manager.yml << 'EOF'
version: "3.8"
services:
  npm:
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
      - ~/HomeLab/Docker/Data/nginx-proxy-manager/data:/data
      - ~/HomeLab/Docker/Data/nginx-proxy-manager/letsencrypt:/etc/letsencrypt
EOF

mkdir -p ~/HomeLab/Docker/Data/nginx-proxy-manager/{data,letsencrypt}
docker compose -f nginx-proxy-manager.yml up -d
```

## Initial Setup

1. Access: http://192.168.50.10:81
2. Login:
   - Email: admin@example.com
   - Password: changeme
3. Change immediately!
4. Save new credentials to 1Password

## SSL Certificate

1. SSL Certificates → Add
2. Domain: stevehomelab.duckdns.org
3. Email: steve-smithit@outlook.com
4. Agree to Let's Encrypt TOS
5. Save

---

# Guide 11: Portainer

## Deploy

```bash
cat > ~/HomeLab/Docker/Compose/portainer.yml << 'EOF'
version: "3.8"
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9443:9443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ~/HomeLab/Docker/Data/portainer:/data
EOF

mkdir -p ~/HomeLab/Docker/Data/portainer
docker compose -f portainer.yml up -d
```

## Setup

1. Access: https://192.168.50.10:9443
2. Create admin account
3. Save to 1Password
4. Select Docker environment
5. Connect

---

# Guide 12: Master Docker Compose

## Deploy All Services

Use the docker-compose-master.yml file:

```bash
cd ~/HomeLab/Docker/Compose
docker compose -f docker-compose-master.yml up -d
```

This deploys all 62+ services:
- Infrastructure (NPM, Portainer, Watchtower)
- Media (Plex, Sonarr, Radarr, Prowlarr, etc.)
- Smart Home (Home Assistant, Frigate, Scrypted)
- AI (Ollama, Open WebUI, Paperless, Immich)
- Monitoring (Grafana, Prometheus, Loki, Uptime Kuma)
- Security (Pi-hole, Authelia)
- Backups (Kopia)

## Verification

```bash
# Check all containers running
docker ps

# Check specific service
docker logs plex

# Access services
open http://192.168.50.10:32400  # Plex
open http://192.168.50.10:8123   # Home Assistant
```

---

## Volume 03 Complete!

You now have:
- ✅ Docker/OrbStack running
- ✅ Tailscale VPN (access from anywhere)
- ✅ DuckDNS auto-updating
- ✅ Nginx Proxy Manager with SSL
- ✅ Portainer for management
- ✅ All 62+ services deployed

**Next: Volume 04 - Proxmox Setup**



---

#homelab #docker #containers #infrastructure
