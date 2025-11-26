---
title: Volume 14: Network Diagrams & Access Guide (Day 14)
tags: [homelab]
created: 2025-11-11
type: homelab-guide
---

# Volume 14: Network Diagrams & Access Guide (Day 14)

**Complete System Overview and Quick Reference**

This is your final volume - complete network diagrams, service URLs, and quick reference guide.

## What's In This Volume

- Complete network topology
- All service access URLs
- Hardware summary
- Software inventory
- Quick command reference
- Access credentials guide
- Family sharing guide
- Next steps and expansion

---

# Complete Network Topology

```
INTERNET (5Gbps CityFibre)
        |
    [Router]
 192.168.50.1
        |
        |
 [TP-Link SX1008]
  10GbE Switch
        |
        ├─────────────────────────────────┐
        |                                 |
   [M4 Mac Mini]                   [Other Devices]
 192.168.50.10                     - MacBook Air
        |                          - Samsung S25
        |                          - iPad Pro
        |                          - Smart Home Devices
        |
    ┌───┴───┬─────────┬──────────┐
    |       |         |          |
  [en0]  [en1]    [en2]      [UTM/Proxmox]
 10GbE   5GB     2.5GB      
Primary Backup  VM Net
        |
    [Proxmox]
 192.168.50.50
        |
    ┌───┴──┬─────────┬────────┐
    |      |         |        |
[Win11] [Ubuntu] [Kali]   [Future VMs]
 .52     .51      .53
```

---

# Hardware Summary

## M4 Mac Mini
```
Model: Mac Mini (M4, 2024)
CPU: Apple M4 (10-core)
RAM: 32GB unified memory
Storage: 512GB internal SSD
Serial: [in 1Password]
Location: [Your office/room]

Network Interfaces:
- en0: 10GbE (built-in) → Primary
- en1: 5GB USB-C adapter → Backup/Failover
- en2: 2.5GB adapter → VM isolated network

IP Addresses:
- Primary: 192.168.50.10
- Backup: 192.168.50.11
- VM Network: 192.168.51.1
- Tailscale: 100.x.x.x
```

## External Storage
```
Model: Samsung T7 (or your model)
Capacity: 4TB
Connection: USB-C (Thunderbolt 4)
Mount: /Volumes/External4TB
Format: APFS

Contents:
├─ Media: 2TB (Plex library)
├─ Photos: 200GB (Immich)
├─ Frigate: 500GB (camera recordings)
├─ VMs: 1TB (Proxmox VMs)
├─ Backups: 200GB (local cache)
└─ Free: ~100GB
```

## Network Hardware
```
Router: [Your router model]
- IP: 192.168.50.1
- Speed: 5Gbps CityFibre

Switch: TP-Link SX1008
- Ports: 8x 10GbE
- Location: [Your location]

Adapters:
- Built-in 10GbE (M4)
- 5GB USB-C Ethernet
- 2.5GB Ethernet
```

---

# IP Address Allocation

```
Network: 192.168.50.0/24 (Main)

Infrastructure:
192.168.50.1   - Router
192.168.50.10  - M4 Mac Mini (primary)
192.168.50.11  - M4 Mac Mini (backup interface)
192.168.50.50  - Proxmox Host

Virtual Machines:
192.168.50.51  - Ubuntu Server
192.168.50.52  - Windows 11 Pro
192.168.50.53  - Kali Linux

Reserved for Future:
192.168.50.60-99 - Additional VMs/services

Network: 192.168.51.0/24 (Isolated VM Network)
192.168.51.1   - M4 Bridge
192.168.51.10-254 - VM private network

Tailscale VPN:
100.x.x.x - M4 (Tailscale mesh network)
```

---

# Service Access URLs

## Infrastructure
```
Proxmox:              https://192.168.50.10:8006
Portainer:            https://192.168.50.10:9443
Nginx Proxy Manager:  http://192.168.50.10:81
Watchtower:           (No UI - runs automatically)
```

## Media Services
```
Plex:                 http://192.168.50.10:32400/web
Sonarr:               http://192.168.50.10:8989
Radarr:               http://192.168.50.10:7878
Prowlarr:             http://192.168.50.10:9696
qBittorrent:          http://192.168.50.10:8112
Bazarr:               http://192.168.50.10:6767
Overseerr:            http://192.168.50.10:5055
Tdarr:                http://192.168.50.10:8265
```

## Smart Home
```
Home Assistant:       http://192.168.50.10:8123
Frigate:              http://192.168.50.10:5000
Scrypted:             http://192.168.50.10:11080
```

## AI Services
```
Ollama:               http://192.168.50.10:11434
Open WebUI:           http://192.168.50.10:3000
Paperless-ngx:        http://192.168.50.10:8010
Immich:               http://192.168.50.10:2283
```

## Security
```
Pi-hole:              http://192.168.50.10:8080/admin
Authelia:             http://192.168.50.10:9091
CrowdSec:             https://app.crowdsec.net
```

## Monitoring
```
Grafana:              http://192.168.50.10:3010
Prometheus:           http://192.168.50.10:9090
Loki:                 http://192.168.50.10:3100
Uptime Kuma:          http://192.168.50.10:3001
```

## Backup
```
Kopia:                http://192.168.50.10:51515
pCloud:               https://my.pcloud.com
```

## Remote Access
```
Tailscale:            https://login.tailscale.com
DuckDNS:              https://www.duckdns.org
Your Domain:          stevehomelab.duckdns.org
```

---

# External Access (via DuckDNS)

**Setup in Nginx Proxy Manager:**

```
plex.stevehomelab.duckdns.org       → Plex
home.stevehomelab.duckdns.org       → Home Assistant
ai.stevehomelab.duckdns.org         → Open WebUI
photos.stevehomelab.duckdns.org     → Immich
docs.stevehomelab.duckdns.org       → Paperless
requests.stevehomelab.duckdns.org   → Overseerr
monitor.stevehomelab.duckdns.org    → Grafana
proxmox.stevehomelab.duckdns.org    → Proxmox

All with Let's Encrypt SSL certificates ✅
```

---

# Quick Command Reference

## Docker
```bash
# View all containers
docker ps

# View specific container logs
docker logs -f <container-name>

# Restart container
docker restart <container-name>

# Update all containers
cd ~/HomeLab/Docker/Compose
docker compose -f docker-compose-master.yml pull
docker compose -f docker-compose-master.yml up -d

# Clean system
docker system prune -a --volumes
```

## Proxmox
```bash
# SSH to Proxmox
ssh root@192.168.50.50

# List VMs
qm list

# Start/Stop VM
qm start 101
qm stop 101

# VM status
qm status 101

# Create snapshot
qm snapshot 101 pre-update

# Console access
qm terminal 101
```

## Backups
```bash
# Manual backup
docker exec kopia kopia snapshot create ~/HomeLab/Docker/Configs

# List snapshots
docker exec kopia kopia snapshot list

# Restore snapshot
docker exec kopia kopia restore [snapshot-id] /restore-path
```

## Monitoring
```bash
# Check system resources
htop
top

# Check disk space
df -h

# Check network
ifconfig
netstat -an
```

---

# Credentials Management

**All credentials stored in 1Password:**

```
HomeLab Vault contains:

Accounts:
- M4 Mac Mini (admin account)
- Proxmox (root)
- Windows VM (Steve)
- Ubuntu VM (steve)
- Kali VM (steve + root)
- All Docker services
- Cloud accounts

API Keys:
- Plex
- DuckDNS
- Tailscale
- OpenAI (if used)
- ExpressVPN

Backup:
- Kopia encryption password
- pCloud credentials

Certificates:
- Let's Encrypt (auto-renewed)
```

**⚠️ NEVER store passwords in plain text files!**

---

# Family Sharing Guide

## Share with Family/Friends

### Plex
```
1. Plex → Settings → Users & Sharing
2. Invite Friend by Email
3. They create Plex account
4. Select what libraries to share
5. They can watch on any device!
```

### Overseerr (Media Requests)
```
1. Share URL: https://requests.stevehomelab.duckdns.org
2. They sign in with Plex account
3. They can request movies/shows
4. You approve
5. Automatic download!
```

### Immich (Photos - Optional)
```
1. Create user account for family member
2. Share albums
3. They install Immich app
4. Auto-backup their photos
```

### Home Assistant (Smart Home)
```
1. Create user account
2. Limited dashboard access
3. Can control lights, climate, etc.
4. No access to system settings
```

---

# System Statistics

## Total Resources

**M4 Mac Mini:**
```
CPU: 10 cores (6 for Docker, 4 for macOS/VMs)
RAM: 32GB (16GB Docker, 16GB macOS/VMs)
Storage: 512GB internal + 4TB external
Network: 10GbE primary, 5GB backup, 2.5GB VM
```

**Docker Containers:**
```
Total: 60+ containers
Categories:
- Infrastructure: 10
- Media: 15
- Smart Home: 5
- AI: 8
- Security: 6
- Monitoring: 10
- Other: 6+
```

**Virtual Machines:**
```
Total: 3 VMs
- Windows 11: 8GB RAM, 3 cores, 500GB
- Ubuntu: 6GB RAM, 2 cores, 200GB
- Kali: 4GB RAM, 2 cores, 150GB
Total: 18GB RAM, 7 cores, 850GB
```

**Smart Home:**
```
Total: 43+ devices
- 5 Nest cameras
- 10 Sonos speakers
- 2 EVs (Tesla + Cupra)
- 1 Easee charger
- + other smart devices
```

---

# Expansion Ideas

## Future Additions

**Hardware:**
- [ ] NAS for additional backup
- [ ] More RAM (upgrade to 64GB or 128GB later)
- [ ] Additional external storage
- [ ] UPS (uninterruptible power supply)

**Software/Services:**
- [ ] Nextcloud (self-hosted cloud)
- [ ] Bitwarden (self-hosted password manager)
- [ ] Wireguard (additional VPN)
- [ ] Jellyfin (Plex alternative)
- [ ] Calibre-web (ebook library)
- [ ] BookStack (documentation wiki)
- [ ] GitLab/Gitea (self-hosted Git)
- [ ] Minecraft server (if gaming)

**Smart Home:**
- [ ] More cameras
- [ ] Smart locks
- [ ] Automated blinds
- [ ] Energy monitoring
- [ ] Garden irrigation automation

**VMs:**
- [ ] Home Assistant OS VM (instead of Docker)
- [ ] pfSense firewall VM
- [ ] Additional Linux distros for learning
- [ ] Server 2022 (Windows Server)

---

# Support & Resources

## Official Documentation
```
Docker:        https://docs.docker.com
Proxmox:       https://pve.proxmox.com/wiki
Home Assistant: https://www.home-assistant.io/docs
Plex:          https://support.plex.tv
Grafana:       https://grafana.com/docs
```

## Community Forums
```
r/homelab:     https://reddit.com/r/homelab
r/selfhosted:  https://reddit.com/r/selfhosted
r/plex:        https://reddit.com/r/plex
r/homeassistant: https://reddit.com/r/homeassistant
```

## Your Documentation
```
Location: ~/HomeLab/Documentation/
- Volumes 01-14 (these guides)
- Build journal
- Backup logs
- Maintenance logs
- Network diagrams
```

---

# Next Steps

## Week 1
- [ ] Familiarize yourself with all services
- [ ] Test each service thoroughly
- [ ] Set up family access to Plex/Overseerr
- [ ] Configure Home Assistant automations
- [ ] Test backups and restores

## Month 1
- [ ] Monitor system stability
- [ ] Optimize resource allocation
- [ ] Add media to Plex
- [ ] Set up preferred Overseerr workflows
- [ ] Customize Home Assistant dashboard

## Ongoing
- [ ] Keep services updated
- [ ] Monitor Grafana dashboards
- [ ] Review Action1 reports
- [ ] Expand smart home
- [ ] Add new services as needed

---

# Congratulations! 🎉

**You've built an enterprise-grade homelab!**

## What You've Accomplished:

✅ **60+ Docker containers** running sophisticated services  
✅ **3 Virtual Machines** (Windows, Ubuntu, Kali)  
✅ **Complete media automation** (Plex + *arr stack)  
✅ **43+ smart home devices** integrated  
✅ **Local AI services** (Ollama, Immich, Paperless)  
✅ **Enterprise security** (Pi-hole, Authelia, 2FA)  
✅ **Comprehensive monitoring** (Grafana, Prometheus)  
✅ **Automated encrypted backups** (Kopia → pCloud)  
✅ **Remote access** (Tailscale + DuckDNS)  
✅ **Remote management** (Action1 RMM)  

## System Value:

**Equivalent Commercial Services:**
```
Plex Pass:              £100/year
Google Photos:          £200/year
Office 365:             £80/year
VPN Service:            £100/year
Cloud Storage (2TB):    £96/year
ChatGPT Plus:           £200/year
Smart Home Hub:         £150
Media Automation:       £300/year
Monitoring Tools:       £500/year

Total Savings: £1,700+/year

Your Setup: One-time hardware + minimal running costs!
```

## Skills Gained:

- Docker containerization
- Virtualization (Proxmox)
- Network configuration
- Security hardening
- Monitoring & observability
- Backup strategies
- Smart home automation
- AI/ML deployment
- System administration
- Troubleshooting

---

# Final Checklist

## Verify Everything Works:

- [ ] M4 Mac Mini running 24/7
- [ ] All 60+ Docker containers running
- [ ] Proxmox accessible
- [ ] All 3 VMs running
- [ ] Plex streaming media
- [ ] Home Assistant controlling devices
- [ ] Grafana showing metrics
- [ ] Backups running daily
- [ ] Remote access working (Tailscale)
- [ ] Action1 monitoring all systems
- [ ] All passwords in 1Password
- [ ] Documentation complete

## Test Critical Functions:

- [ ] Stream from Plex on phone
- [ ] Request media via Overseerr
- [ ] Control smart home from anywhere
- [ ] Access M4 via SSH remotely
- [ ] View Grafana dashboards remotely
- [ ] Restore a file from backup
- [ ] Receive alert notifications

---

# Thank You!

**You did it!** You've built something amazing.

This homelab will serve you for years, evolving with your needs.

**Remember:**
- Keep exploring and learning
- Join homelab communities
- Share your knowledge
- Expand as needed
- Most importantly: Have fun! 🎯

**Questions? Issues?**
- Review relevant volume
- Check logs
- Search communities
- Experiment safely

**Happy homelabbing!** 🚀

---

## Volume 14 Complete!

**All 14 volumes finished!**

You now have:
- ✅ Complete network diagrams
- ✅ All service URLs documented
- ✅ Hardware summary
- ✅ Quick command reference
- ✅ Family sharing guide
- ✅ Expansion ideas
- ✅ Everything documented!

**Total Project: 14 days, 62+ services, unlimited possibilities!**



---

#homelab
