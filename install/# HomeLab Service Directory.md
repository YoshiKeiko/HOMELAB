# HomeLab Service Directory
**Last Updated:** 2025-11-13  
**Total Containers:** 30  
**Status:** ✅ All Services Deployed

---

## 🔗 Quick Access Dashboard

### Primary Access Methods

| Access Method | URL | Notes |
|---------------|-----|-------|
| **Local (Mac Mini)** | `localhost` | Direct access on the Mac |
| **Local Network** | `192.168.50.10` | From any device on your network |
| **Remote (Tailscale)** | `100.x.x.x` | Replace with your Tailscale IP |
| **Internet** | `stevehomelab.duckdns.org` | Via Nginx Proxy Manager |

---

## 🏗️ Infrastructure Services

| Service | Local URL | Network URL | Status | Credentials |
|---------|-----------|-------------|--------|-------------|
| **Nginx Proxy Manager** | [http://localhost:81](http://localhost:81) | http://192.168.50.10:81 | ✅ Configured | 🔐 1Password |
| **Portainer** | [https://localhost:9443](https://localhost:9443) | https://192.168.50.10:9443 | ✅ Configured | 🔐 1Password |
| **Watchtower** | Background Service | - | ✅ Running | No UI |
| **DuckDNS** | stevehomelab.duckdns.org | - | ✅ Auto-updating | Token in 1Password |
| **Tailscale** | Menu Bar App | - | ✅ Connected | Google Account |

### Infrastructure Notes
- **Nginx Proxy Manager**: Reverse proxy with SSL certificates
- **Portainer**: Docker container management interface  
- **Watchtower**: Auto-updates Docker containers at 4 AM daily
- **DuckDNS**: Updates every 5 minutes via LaunchAgent
- **Tailscale**: VPN for remote access

---

## 🎬 Media Stack

| Service | Local URL | Network URL | Port | Status |
|---------|-----------|-------------|------|--------|
| **Plex Media Server** | [http://localhost:32400/web](http://localhost:32400/web) | http://192.168.50.10:32400/web | 32400 | ✅ Running |
| **Sonarr** (TV Shows) | [http://localhost:8989](http://localhost:8989) | http://192.168.50.10:8989 | 8989 | ✅ Running |
| **Radarr** (Movies) | [http://localhost:7878](http://localhost:7878) | http://192.168.50.10:7878 | 7878 | ✅ Running |
| **Prowlarr** (Indexers) | [http://localhost:9696](http://localhost:9696) | http://192.168.50.10:9696 | 9696 | ✅ Running |
| **Transmission** (Torrents) | [http://localhost:9091](http://localhost:9091) | http://192.168.50.10:9091 | 9091 | ✅ Running |
| **Bazarr** (Subtitles) | [http://localhost:6767](http://localhost:6767) | http://192.168.50.10:6767 | 6767 | ✅ Running |

### Media Stack Setup Tasks
- [ ] Configure Plex libraries pointing to `/Volumes/HomeLab-4TB/Media`
- [ ] Add Plex account and claim server
- [ ] Connect Sonarr/Radarr to Prowlarr indexers
- [ ] Configure Transmission download paths
- [ ] Set up quality profiles in Sonarr/Radarr
- [ ] Configure Bazarr for subtitle languages

### Media Storage Paths
```
Movies:     /Volumes/HomeLab-4TB/Media/Movies
TV Shows:   /Volumes/HomeLab-4TB/Media/TV
Music:      /Volumes/HomeLab-4TB/Media/Music
Downloads:  /Volumes/HomeLab-4TB/Downloads
```

---

## 🏠 Smart Home

| Service | Local URL | Network URL | Port | Status |
|---------|-----------|-------------|------|--------|
| **Home Assistant** | [http://localhost:8123](http://localhost:8123) | http://192.168.50.10:8123 | 8123 | ✅ Running |
| **Frigate** (NVR) | [http://localhost:5000](http://localhost:5000) | http://192.168.50.10:5000 | 5000 | ✅ Running |
| **Scrypted** | [http://localhost:10443](http://localhost:10443) | http://192.168.50.10:10443 | 10443 | ✅ Running |

### Smart Home Devices to Integrate
- **Sonos Speakers:** 10 devices
- **Nest Cameras:** 5 devices  
- **Tesla Model Y**
- **Cupra Born EV**
- **Easee Charger**
- Additional smart home devices (43+ total)

### Smart Home Setup Tasks
- [ ] Complete Home Assistant onboarding
- [ ] Integrate Sonos speakers
- [ ] Add Nest cameras to Frigate
- [ ] Configure Tesla integration
- [ ] Set up EV charger automation
- [ ] Create Home Assistant dashboards

---

## 🤖 AI Services

| Service | Local URL | Network URL | Port | Status |
|---------|-----------|-------------|------|--------|
| **Ollama** (LLM Backend) | [http://localhost:11434](http://localhost:11434) | http://192.168.50.10:11434 | 11434 | ✅ Running |
| **Open WebUI** (Chat Interface) | [http://localhost:3000](http://localhost:3000) | http://192.168.50.10:3000 | 3000 | ✅ Running |
| **Paperless-ngx** (Documents) | [http://localhost:8010](http://localhost:8010) | http://192.168.50.10:8010 | 8010 | ✅ Running |
| **Immich** (Photos) | [http://localhost:2283](http://localhost:2283) | http://192.168.50.10:2283 | 2283 | ✅ Running |

### AI Services Setup Tasks
- [ ] Download Ollama models: `ollama pull llama2`, `ollama pull mistral`
- [ ] Create Open WebUI account
- [ ] Configure Paperless-ngx document scanning
- [ ] Upload photos to Immich
- [ ] Set up Immich facial recognition
- [ ] Configure Paperless consumption directory

### Ollama Quick Commands
```bash
# Pull models
docker exec -it ollama ollama pull llama2
docker exec -it ollama ollama pull mistral
docker exec -it ollama ollama pull codellama

# List installed models
docker exec -it ollama ollama list
```

---

## 📊 Monitoring & Dashboards

| Service | Local URL | Network URL | Port | Status |
|---------|-----------|-------------|------|--------|
| **Homepage** (Dashboard) | [http://localhost:3003](http://localhost:3003) | http://192.168.50.10:3003 | 3003 | ✅ Running |
| **Uptime Kuma** (Status) | [http://localhost:3001](http://localhost:3001) | http://192.168.50.10:3001 | 3001 | ✅ Running |
| **Grafana** (Visualization) | [http://localhost:3002](http://localhost:3002) | http://192.168.50.10:3002 | 3002 | ✅ Running |
| **Prometheus** (Metrics) | [http://localhost:9090](http://localhost:9090) | http://192.168.50.10:9090 | 9090 | ✅ Running |
| **Loki** (Logs) | [http://localhost:3100](http://localhost:3100) | http://192.168.50.10:3100 | 3100 | ✅ Running |

### Monitoring Setup Tasks
- [ ] Configure Homepage dashboard with service widgets
- [ ] Add all services to Uptime Kuma monitoring
- [ ] Set up Grafana data source (Prometheus)
- [ ] Import Grafana dashboards for Docker monitoring
- [ ] Configure Loki log collection
- [ ] Set up alert rules in Prometheus
- [ ] Configure notification channels (email/Slack)

### Default Credentials
- **Grafana:** Username: `admin` / Password: `admin` (change on first login)

---

## 🔒 Security Services

| Service | Local URL | Network URL | Port | Status |
|---------|-----------|-------------|------|--------|
| **Pi-hole** (DNS Filter) | [http://localhost:8081/admin](http://localhost:8081/admin) | http://192.168.50.10:8081/admin | 8081 | ✅ Running |
| **Authelia** (SSO/2FA) | [http://localhost:9092](http://localhost:9092) | http://192.168.50.10:9092 | 9092 | ✅ Running |
| **Fail2ban** | Command line only | - | - | ✅ Running |

### Security Setup Tasks
- [ ] Change Pi-hole admin password (currently: `changeme`)
- [ ] Configure Pi-hole blocklists
- [ ] Set router DNS to point to Pi-hole (192.168.50.10)
- [ ] Configure Authelia authentication
- [ ] Set up 2FA in Authelia
- [ ] Configure Fail2ban for Nginx logs
- [ ] Review Fail2ban blocked IPs regularly

### Default Credentials
- **Pi-hole:** Password: `changeme` (change immediately!)

---

## 💾 Backup Services

| Service | Local URL | Network URL | Port | Status |
|---------|-----------|-------------|------|--------|
| **Kopia** (Backup) | [http://localhost:51515](http://localhost:51515) | http://192.168.50.10:51515 | 51515 | ✅ Running |

### Backup Setup Tasks
- [ ] Configure Kopia repository on pCloud
- [ ] Set up backup schedules for Docker data
- [ ] Configure encryption password (save to 1Password!)
- [ ] Test backup and restore
- [ ] Set up automated backup verification
- [ ] Configure retention policies

### Backup Locations
- **Source:** `/Users/homelab/HomeLab/Docker/Data`
- **Source:** `/Volumes/HomeLab-4TB` (external storage)
- **Destination:** pCloud (encrypted)

### Default Credentials
- **Username:** `admin`
- **Password:** `changeme` (change immediately!)

---

## 🌐 External Services (Not Self-Hosted)

| Service | URL | Purpose | Status |
|---------|-----|---------|--------|
| **1Password Teams** | [1password.com](https://1password.com) | Password Management | ✅ Active |
| **ChatGPT Teams** | [chat.openai.com](https://chat.openai.com) | AI Assistant | ✅ Active |
| **Claude Pro** | [claude.ai](https://claude.ai) | AI Assistant | ✅ Active |
| **Perplexity Pro** | [perplexity.ai](https://perplexity.ai) | AI Search | ✅ Active |
| **ExpressVPN** | [expressvpn.com](https://expressvpn.com) | VPN Service | ✅ Active |
| **pCloud** | [pcloud.com](https://pcloud.com) | Cloud Backup Storage | ✅ Active |
| **DuckDNS** | [duckdns.org](https://duckdns.org) | Dynamic DNS | ✅ Active |
| **Tailscale** | [login.tailscale.com](https://login.tailscale.com) | VPN Network | ✅ Active |

---

## 🔧 System Management

### Docker Commands
```bash
# View all containers
docker ps

# View all containers (including stopped)
docker ps -a

# View logs for a service
docker logs <container-name>
docker logs -f <container-name>  # Follow logs

# Restart a service
docker restart <container-name>

# Stop/Start a service
docker stop <container-name>
docker start <container-name>

# View container stats
docker stats

# Clean up unused images/containers
docker system prune -a
```

### Service Management Scripts
```bash
# Location of compose files
cd ~/HomeLab/Docker/Compose

# Start a service
docker compose -f <service>.yml up -d

# Stop a service
docker compose -f <service>.yml down

# View service logs
docker compose -f <service>.yml logs -f

# Restart a service
docker compose -f <service>.yml restart
```

### Important File Locations
```bash
Docker Compose Files:  ~/HomeLab/Docker/Compose/
Docker Data:           ~/HomeLab/Docker/Data/
Docker Configs:        ~/HomeLab/Docker/Configs/
External Storage:      /Volumes/HomeLab-4TB/
Scripts:               ~/HomeLab/Scripts/
Documentation:         ~/HomeLab/Documentation/
```

---

## 📋 Service Configuration Priority

### Phase 1: Essential Services (Do First) ✅
- [x] Nginx Proxy Manager
- [x] Portainer  
- [x] Tailscale
- [x] DuckDNS

### Phase 2: Media Services (Do Next)
- [ ] Plex (configure libraries)
- [ ] Prowlarr (add indexers)
- [ ] Sonarr (connect to Prowlarr)
- [ ] Radarr (connect to Prowlarr)
- [ ] Transmission (configure downloads)

### Phase 3: Monitoring (Do After Media)
- [ ] Homepage (add service widgets)
- [ ] Uptime Kuma (add monitors)
- [ ] Grafana (import dashboards)

### Phase 4: Smart Home (Do When Ready)
- [ ] Home Assistant (onboarding)
- [ ] Frigate (camera setup)
- [ ] Device integrations

### Phase 5: Security Hardening
- [ ] Pi-hole (configure DNS)
- [ ] Authelia (set up SSO)
- [ ] SSL certificates via NPM
- [ ] Fail2ban rules

### Phase 6: AI & Advanced
- [ ] Ollama (download models)
- [ ] Open WebUI (configure)
- [ ] Paperless (document scanning)
- [ ] Immich (photo upload)

### Phase 7: Backups
- [ ] Kopia (configure pCloud)
- [ ] Test backup/restore
- [ ] Automate schedules

---

## 🚨 Default Passwords to Change

| Service | Current Password | Action Required |
|---------|------------------|-----------------|
| Pi-hole | `changeme` | ⚠️ Change immediately |
| Kopia | `changeme` | ⚠️ Change immediately |
| Grafana | `admin` | ⚠️ Change on first login |

**Save all new passwords to 1Password!**

---

## 📞 Support & Documentation

### Official Documentation
- **Docker:** [docs.docker.com](https://docs.docker.com)
- **Plex:** [support.plex.tv](https://support.plex.tv)
- **Home Assistant:** [home-assistant.io](https://home-assistant.io)
- **Nginx Proxy Manager:** [nginxproxymanager.com](https://nginxproxymanager.com)
- **Portainer:** [docs.portainer.io](https://docs.portainer.io)

### Troubleshooting Commands
```bash
# Check container health
docker ps --filter "status=running"

# View system resources
docker stats --no-stream

# Check OrbStack status
ps aux | grep orbstack

# Check Tailscale status
tailscale status

# Check DuckDNS updates
cat ~/HomeLab/Documentation/duckdns.log

# Test network connectivity
ping 192.168.50.10
curl http://localhost:81
```

### Common Issues & Solutions

**Container won't start:**
```bash
docker logs <container-name>
docker restart <container-name>
```

**Can't access service:**
1. Check container is running: `docker ps | grep <name>`
2. Check port isn't blocked: `lsof -i :<port>`
3. Try localhost vs 192.168.50.10
4. Check OrbStack is running

**Storage full:**
```bash
docker system df
docker system prune -a  # Careful: removes unused images
```

---

## 📊 System Status Overview

### Hardware
- **Mac Mini:** M4, 32GB RAM, 512GB SSD
- **External Storage:** 4TB SSD (HomeLab-4TB)
- **Network:** 10GbE (TP-Link SX1008)
- **Internet:** 5Gbps CityFibre

### Network Configuration
- **Static IP:** 192.168.50.10
- **Subnet:** 255.255.255.0
- **Gateway:** 192.168.50.1
- **DNS:** 192.168.50.1 (will change to Pi-hole)
- **Tailscale IP:** [Save from menu bar]

### Storage Usage
```bash
# Check Docker storage
docker system df

# Check external drive
df -h /Volumes/HomeLab-4TB

# Check internal SSD
df -h /
```

---

## 🎯 Next Actions

### Immediate (Today)
1. ⚠️ Change default passwords (Pi-hole, Kopia, Grafana)
2. 📝 Save all passwords to 1Password
3. 🎬 Configure Plex and add media
4. 🔍 Add services to Uptime Kuma

### This Week
1. Set up Homepage dashboard
2. Configure Sonarr/Radarr/Prowlarr
3. Set up Home Assistant
4. Configure monitoring in Grafana

### This Month
1. Set up automated backups to pCloud
2. Configure all smart home devices
3. Set up SSL certificates for external access
4. Deploy Proxmox for VMs (Volume 04)

---

## 💡 Pro Tips

1. **Bookmark Homepage:** Make http://localhost:3003 your main dashboard
2. **Use Portainer:** Easier than command line for quick container management
3. **Check Uptime Kuma:** Monitor service health at a glance
4. **Grafana Dashboards:** Import pre-built Docker dashboards from grafana.com
5. **Pi-hole Stats:** Great for seeing what's being blocked on your network
6. **Tailscale:** Access everything securely from anywhere

---

**Document Version:** 1.0  
**Created:** 2025-11-13  
**Last Updated:** 2025-11-13  
**Total Services:** 30 containers + 8 external services

---

*This document should be saved to: `~/HomeLab/Documentation/Service-Directory.md`*