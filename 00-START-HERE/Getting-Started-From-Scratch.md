---
title: Getting Started From Scratch
tags: [homelab, setup, guide, quickstart]
created: 2025-11-26
updated: 2025-11-26
type: guide
---

# Getting Started From Scratch

**Complete guide to recreating this homelab from nothing**

This guide will help you build the same 53-container homelab infrastructure on an M4 Mac Mini.

---

## Hardware Requirements

### Primary Server
- **Mac Mini M4** (or any Apple Silicon Mac)
  - 32GB RAM recommended (16GB minimum)
  - 512GB+ internal SSD
- **External Storage**: 4TB SSD/HDD for media and recordings
- **Network**: 10GbE preferred, 1GbE minimum

### Network Equipment
- Router with DHCP reservation capability
- Gigabit or faster switch
- Static IP for the server (192.168.50.50 in this setup)

### Smart Home (Optional)
- Zigbee coordinator (Sonoff, ConBee, etc.)
- Smart home devices
- IP cameras (Tapo C310 compatible with Agent DVR)

---

## Phase 1: Base System Setup

### 1.1 Configure Static IP

1. System Settings → Network → Ethernet
2. Configure IPv4: Manually
3. Set IP: `192.168.50.50`
4. Subnet: `255.255.255.0`
5. Router: `192.168.50.1`
6. DNS: `8.8.8.8, 8.8.4.4`

### 1.2 Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Add to PATH:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 1.3 Install OrbStack (Docker)

```bash
brew install --cask orbstack
```

Start OrbStack and verify:
```bash
docker --version
docker-compose --version
```

### 1.4 Mount External Storage

1. Connect 4TB drive
2. Format as APFS (Disk Utility)
3. Name it: `HomeLab-4TB`
4. It will mount at: `/Volumes/HomeLab-4TB`

---

## Phase 2: Directory Structure

Create the homelab folder structure:

```bash
mkdir -p ~/HomeLab/Docker/{Compose,Data}
mkdir -p /Volumes/HomeLab-4TB/{Media,Downloads,AgentDVR/media,Backups}
```

### Folder Structure

```
~/HomeLab/
├── Docker/
│   ├── Compose/          # Docker compose files
│   │   ├── core.yml
│   │   ├── media.yml
│   │   ├── smarthome.yml
│   │   ├── monitoring.yml
│   │   ├── ai.yml
│   │   ├── productivity.yml
│   │   ├── databases.yml
│   │   ├── dashboards.yml
│   │   ├── backup.yml
│   │   └── security.yml
│   └── Data/             # Container persistent data
│       ├── portainer/
│       ├── heimdall/
│       ├── plex/
│       └── ... (each container)

/Volumes/HomeLab-4TB/
├── Media/
│   ├── Movies/
│   ├── TV/
│   └── Music/
├── Downloads/
├── AgentDVR/
│   └── media/
└── Backups/
```

---

## Phase 3: Deploy Core Services

### 3.1 Core Infrastructure (core.yml)

```yaml
version: '3.8'
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ~/HomeLab/Docker/Data/portainer:/data

  heimdall:
    image: lscr.io/linuxserver/heimdall:latest
    container_name: heimdall
    restart: unless-stopped
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
    ports:
      - "8090:80"
    volumes:
      - ~/HomeLab/Docker/Data/heimdall:/config

  nginx-proxy-manager:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - "80:80"
      - "81:81"
      - "443:443"
    volumes:
      - ~/HomeLab/Docker/Data/npm/data:/data
      - ~/HomeLab/Docker/Data/npm/letsencrypt:/etc/letsencrypt

  adguard-home:
    image: adguard/adguardhome:latest
    container_name: adguard-home
    restart: unless-stopped
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "8084:80"
      - "3053:3000"
    volumes:
      - ~/HomeLab/Docker/Data/adguard/work:/opt/adguardhome/work
      - ~/HomeLab/Docker/Data/adguard/conf:/opt/adguardhome/conf
```

Deploy:
```bash
cd ~/HomeLab/Docker/Compose
docker-compose -f core.yml up -d
```

### 3.2 Continue with Other Stacks

See detailed compose files in:
- [[03-Deployment/Docker-Compose-Files]]
- `~/HomeLab/Docker/Compose/` directory

---

## Phase 4: Essential Services Quick Deploy

### Deploy All Services

```bash
cd ~/HomeLab/Docker/Compose

# Core first
docker-compose -f core.yml up -d

# Then databases (other services depend on these)
docker-compose -f databases.yml up -d

# Then everything else
docker-compose -f media.yml up -d
docker-compose -f smarthome.yml up -d
docker-compose -f monitoring.yml up -d
docker-compose -f ai.yml up -d
docker-compose -f productivity.yml up -d
docker-compose -f dashboards.yml up -d
docker-compose -f backup.yml up -d
docker-compose -f security.yml up -d
```

---

## Phase 5: Post-Deploy Configuration

### 5.1 AdGuard Home Setup

1. Go to http://192.168.50.50:3053 (initial setup)
2. Set admin password
3. Configure upstream DNS: `https://dns.cloudflare.com/dns-query`
4. Add Sky Shield as fallback: `175.176.98.48` (parental controls)
5. Enable blocklists

### 5.2 Portainer Setup

1. Go to http://192.168.50.50:9000
2. Create admin account
3. Add local Docker environment

### 5.3 Home Assistant Setup

1. Go to http://192.168.50.50:8123
2. Create account
3. Discover devices
4. Add integrations

### 5.4 Media Stack Setup

1. **Plex**: http://192.168.50.50:32400/web - Claim server
2. **Sonarr/Radarr**: Add download client (Transmission)
3. **Prowlarr**: Add indexers, sync to Sonarr/Radarr
4. **Overseerr**: Connect to Plex/Sonarr/Radarr

---

## Phase 6: Install Management Tools

### 6.1 Install Node.js

```bash
brew install node
```

### 6.2 Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

### 6.3 Configure MCP for Claude Desktop

```bash
brew install --cask claude

mkdir -p ~/Library/Application\ Support/Claude

cat > ~/Library/Application\ Support/Claude/claude_desktop_config.json << 'EOF'
{
  "mcpServers": {
    "desktop-commander": {
      "command": "npx",
      "args": ["-y", "@wonderwhy-er/desktop-commander"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/homelab",
        "/Volumes/HomeLab-4TB"
      ]
    }
  }
}
EOF
```

Restart Claude Desktop.

---

## Phase 7: Verify Installation

Run the health check:

```bash
bash /Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh
```

Expected: All 53 services showing ✅

---

## Quick Reference

| Task | Command |
|------|---------|
| Start all services | `docker-compose -f <stack>.yml up -d` |
| Stop all services | `docker-compose -f <stack>.yml down` |
| View logs | `docker logs <container> --tail 50` |
| Restart container | `docker restart <container>` |
| Update container | `docker-compose -f <stack>.yml pull && docker-compose -f <stack>.yml up -d` |
| Health check | `bash ~/Documents/Obsidian/HOMELAB/scripts/health-check.sh` |

---

## Next Steps

1. [[Master-Service-List]] - All services with URLs and ports
2. [[Health-Check-Guide]] - Monitoring and troubleshooting
3. [[Claude-Code-Setup]] - AI-powered management
4. [[Kopia-Backup-Setup]] - Automated backups to pCloud
5. [[Agent-DVR-Tapo-C310-Setup]] - Camera surveillance

---

*Last Updated: 2025-11-26*
