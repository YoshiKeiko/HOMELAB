

**Your 22-Day Journey to an Epic HomeLab**

> *"The journey of a thousand containers begins with a single docker-compose up."* 🐳

---

## 🎯 Quick Navigation

**START HERE:**
- [00-START-HERE.md](🏠%20Epic%20HomeLab%20-%20Complete%20Documentation%20Package.md) - Main index
- [00-System-Overview.md](🏗️%20M4%20Mac%20Mini%20-%20Complete%20System%20Overview.md) - What you're building
- [00-Quick-Reference.md](🚀%20HomeLab%20Quick%20Reference%20Guide.md) - URLs, IPs, commands

**THEN FOLLOW THIS ROADMAP BELOW** ⬇️

---

## 📊 Progress Tracker

Track your completion:

### Foundation (Days 1-2):
- [ ] Day 01-02: Foundation & Accounts
- [ ] Day 01-02: M4 Mac Mini Setup
- [ ] **BONUS:** Deco Mesh Setup

### Infrastructure (Days 3-5):
- [ ] Day 03-05: Docker Infrastructure  
- [ ] **BONUS:** Remote Access Setup

### Virtualization (Days 6-12):
- [ ] Day 06-08: Proxmox Hypervisor
- [ ] Day 09-10: Windows 11 VM
- [ ] Day 11-12: Ubuntu & Kali VMs

### Services (Days 13-18):
- [ ] Day 13-14: Media Stack (Plex)
- [ ] Day 15-16: Smart Home Integration
- [ ] Day 17-18: AI Services & LLMs

### Finishing (Days 19-22):
- [ ] Day 19: Security Hardening
- [ ] Day 20: Monitoring Setup
- [ ] Day 21: Backup Strategy
- [ ] Day 22: Maintenance & RMM
- [ ] Day 22: Network Diagrams

---

# Days 1-2: Foundation

## Day 01-02: Foundation & Accounts

**File:** [Day-01-02-Foundation-and-Accounts.md](./Day-01-02-Foundation-and-Accounts.md)

**What You'll Do:**
- ✅ Create all accounts (DuckDNS, Tailscale, Docker Hub, etc.)
- ✅ Save credentials to 1Password
- ✅ Download all required software
- ✅ Install mobile apps

**Time:** 2-3 hours  
**Coffee:** ☕☕  
**Prerequisites:** 1Password, internet access

**Key Accounts:**
- DuckDNS (free DNS)
- Tailscale (VPN)
- Docker Hub
- Plex Media Server
- Home Assistant
- pCloud (you already have)

---

## Day 01-02: M4 Mac Mini Setup

**File:** [Day-01-02-M4-Mac-Mini-Setup.md](./Day-01-02-M4-Mac-Mini-Setup.md)

**What You'll Do:**
- ✅ Unbox and physically setup M4
- ✅ Install macOS Sequoia
- ✅ Configure 10GbE network (192.168.50.10)
- ✅ Format 4TB external SSD
- ✅ Enable SSH
- ✅ Install Homebrew and essential tools
- ✅ Optimize for 24/7 operation

**Time:** 3-4 hours  
**Coffee:** ☕☕☕☕  
**Prerequisites:** M4 Mac Mini, monitor, keyboard

**What You'll Have:**
- M4 on 10GbE wired (static IP)
- External 4TB SSD mounted
- SSH access configured
- Essential tools installed
- System optimized for server use

---

## BONUS: Deco Mesh Setup (Optional but Recommended)

**File:** [Day-02-BONUS-Deco-Mesh-Setup.md](./Day-02-BONUS-Deco-Mesh-Setup.md)

**What You'll Do:**
- ✅ Disable Sky router WiFi
- ✅ Setup 3x TP-Link Deco XE75 units
- ✅ Configure wired backhaul
- ✅ Create IoT network
- ✅ Migrate 43+ devices

**Time:** 45-60 minutes  
**Coffee:** ☕☕  
**Prerequisites:** 3x Deco XE75, TP-Link switch

**Why Do This:**
- Full house WiFi coverage
- Better performance (wired backhaul)
- Separate IoT network for smart devices
- No WiFi interference with M4's 10GbE

---

# Days 3-5: Docker Infrastructure

## Day 03-05: Docker Infrastructure

**File:** [Day-03-05-Docker-Infrastructure.md](./Day-03-05-Docker-Infrastructure.md)

**What You'll Do:**
- ✅ Install OrbStack (Docker alternative for Mac)
- ✅ Create folder structure
- ✅ Deploy Portainer (management UI)
- ✅ Setup docker-compose-master.yml
- ✅ Deploy core services (Traefik, Authelia)

**Time:** 4-6 hours  
**Coffee:** ☕☕☕☕☕  
**Prerequisites:** Day 1-2 complete

**What You'll Have:**
- Docker environment ready
- Portainer management interface
- Foundation for 62+ services
- Reverse proxy configured

---

## BONUS: Remote Access Setup (Recommended)

**File:** [Day-05-BONUS-Remote-Access.md](./Day-05-BONUS-Remote-Access.md)

**What You'll Do:**
- ✅ Deploy RustDesk server
- ✅ Deploy Apache Guacamole
- ✅ Configure port forwarding
- ✅ Setup Android client
- ✅ Test remote connections

**Time:** 60-90 minutes  
**Coffee:** ☕☕☕  
**Prerequisites:** Docker infrastructure ready

**Why Do This:**
- Access M4 from anywhere
- Works on Android (unlike MS Remote Desktop!)
- Browser-based access option
- Self-hosted privacy

---

# Days 6-12: Virtual Machines

## Day 06-08: Proxmox Hypervisor

**File:** [Day-06-08-Proxmox-Hypervisor.md](./Day-06-08-Proxmox-Hypervisor.md)

**What You'll Do:**
- ✅ Install UTM (VM software for Mac)
- ✅ Create Proxmox VM
- ✅ Configure networking
- ✅ Setup Proxmox web interface
- ✅ Prepare for Windows/Linux VMs

**Time:** 3-4 hours  
**Coffee:** ☕☕☕☕  
**Prerequisites:** Proxmox ISO downloaded

**What You'll Have:**
- Proxmox running in VM
- Web interface accessible
- Ready to deploy VMs

**Reference:** [REF-Proxmox-Quick-Reference.md](./REF-Proxmox-Quick-Reference.md)

---

## Day 09-10: Windows 11 VM

**File:** [Day-09-10-Windows-11-VM.md](./Day-09-10-Windows-11-VM.md)

**What You'll Do:**
- ✅ Create Windows 11 VM in Proxmox
- ✅ Install Windows
- ✅ Configure for homelab use
- ✅ Install remote access tools
- ✅ Setup automation scripts

**Time:** 3-4 hours  
**Coffee:** ☕☕☕☕  
**Prerequisites:** Windows 11 ISO, Proxmox ready

**What You'll Have:**
- Windows 11 Pro VM (192.168.50.52)
- Accessible via RDP/Guacamole
- Gaming/Windows-only software platform

---

## Day 11-12: Ubuntu & Kali Linux VMs

**File:** [Day-11-12-Ubuntu-Kali-VMs.md](./Day-11-12-Ubuntu-Kali-VMs.md)

**What You'll Do:**
- ✅ Deploy Ubuntu Server 24.04 VM
- ✅ Deploy Kali Linux VM
- ✅ Configure both for homelab use
- ✅ Setup SSH access
- ✅ Install development tools

**Time:** 3-4 hours  
**Coffee:** ☕☕☕☕  
**Prerequisites:** ISOs downloaded, Proxmox ready

**What You'll Have:**
- Ubuntu Server (192.168.50.51) - Linux workstation
- Kali Linux (192.168.50.53) - Security testing
- Both accessible via SSH/Guacamole

---

# Days 13-18: Core Services

## Day 13-14: Media Stack (Plex)

**File:** [Day-13-14-Media-Stack-Plex.md](./Day-13-14-Media-Stack-Plex.md)

**What You'll Do:**
- ✅ Deploy Plex Media Server
- ✅ Deploy Sonarr, Radarr, Prowlarr
- ✅ Deploy qBittorrent (with VPN)
- ✅ Deploy Overseerr (requests)
- ✅ Configure automation pipeline

**Time:** 4-5 hours  
**Coffee:** ☕☕☕☕☕  
**Prerequisites:** Docker ready, Plex account

**What You'll Have:**
- Automated media downloading
- Plex streaming to all devices
- Request system for family
- 1.5TB media library ready

---

## Day 15-16: Smart Home Integration

**File:** [Day-15-16-Smart-Home-Integration.md](./Day-15-16-Smart-Home-Integration.md)

**What You'll Do:**
- ✅ Deploy Home Assistant
- ✅ Deploy Frigate (camera AI)
- ✅ Integrate 43+ devices:
  - 10x Sonos speakers
  - 5x Nest cameras
  - Nest thermostat
  - Tesla Model Y
  - Cupra Born EV
  - Easee charger
  - Smart plugs

**Time:** 5-6 hours  
**Coffee:** ☕☕☕☕☕☕  
**Prerequisites:** Docker ready, devices on network

**What You'll Have:**
- Central smart home control
- AI camera detection
- Automations for everything
- EV charging management

---

## Day 17-18: AI Services & LLMs

**File:** [Day-17-18-AI-Services-LLMs.md](./Day-17-18-AI-Services-LLMs.md)

**What You'll Do:**
- ✅ Deploy Ollama (local LLMs)
- ✅ Deploy LM Studio
- ✅ Deploy Open WebUI
- ✅ Download AI models (8B-70B sizes)
- ✅ Setup API access

**Time:** 3-4 hours  
**Coffee:** ☕☕☕☕  
**Prerequisites:** Docker ready, lots of disk space

**What You'll Have:**
- Local AI models running
- Private ChatGPT alternative
- API for automation
- No cloud dependencies

---

# Days 19-22: Security & Maintenance

## Day 19: Security Hardening

**File:** [Day-19-Security-Hardening.md](./Day-19-Security-Hardening.md)

**What You'll Do:**
- ✅ Deploy Wazuh (SIEM)
- ✅ Deploy CrowdSec (threat blocking)
- ✅ Deploy Fail2ban
- ✅ Deploy Authelia (SSO)
- ✅ Configure firewall rules
- ✅ Setup security monitoring

**Time:** 4-5 hours  
**Coffee:** ☕☕☕☕☕  
**Prerequisites:** All services deployed

**What You'll Have:**
- Enterprise-grade security
- Automated threat response
- Single sign-on for all services
- Security dashboards

---

## Day 20: Monitoring Setup

**File:** [Day-20-Monitoring-Setup.md](./Day-20-Monitoring-Setup.md)

**What You'll Do:**
- ✅ Deploy Grafana (dashboards)
- ✅ Deploy Prometheus (metrics)
- ✅ Deploy Loki (logs)
- ✅ Deploy Uptime Kuma (status)
- ✅ Deploy Netdata (real-time stats)
- ✅ Create dashboards

**Time:** 3-4 hours  
**Coffee:** ☕☕☕☕  
**Prerequisites:** All services running

**What You'll Have:**
- Beautiful dashboards
- Real-time monitoring
- Historical metrics (90 days)
- Alert system

---

## Day 21: Backup Strategy

**File:** [Day-21-Backup-Strategy.md](./Day-21-Backup-Strategy.md)

**What You'll Do:**
- ✅ Deploy Kopia (encrypted backups)
- ✅ Configure pCloud sync
- ✅ Setup automated schedules:
  - Daily: Docker volumes
  - Weekly: VM snapshots
  - Monthly: Full system
- ✅ Test restore procedures

**Time:** 3-4 hours  
**Coffee:** ☕☕☕☕  
**Prerequisites:** pCloud account, all services running

**What You'll Have:**
- Automated encrypted backups
- 2TB+ backed up to pCloud
- Disaster recovery ready
- Monthly restore tests

---

## Day 22: Maintenance & RMM

**File:** [Day-22-Maintenance-and-RMM.md](./Day-22-Maintenance-and-RMM.md)

**What You'll Do:**
- ✅ Deploy Action1 RMM
- ✅ Setup automated patching
- ✅ Configure maintenance schedules
- ✅ Create runbooks
- ✅ Document procedures

**Time:** 2-3 hours  
**Coffee:** ☕☕☕  
**Prerequisites:** Everything else complete

**What You'll Have:**
- Automated patch management
- Maintenance calendar
- Documented procedures
- Production-ready homelab!

---

## Day 22: Network Diagrams

**File:** [Day-22-Network-Diagrams-Final.md](./Day-22-Network-Diagrams-Final.md)

**What You'll Do:**
- ✅ Review complete network topology
- ✅ Understand all connections
- ✅ Document everything
- ✅ Create backup diagrams

**Time:** 1 hour  
**Coffee:** ☕  
**Prerequisites:** Everything deployed

**What You'll Have:**
- Complete network documentation
- Visual diagrams
- Reference for troubleshooting

---

# 🎉 Completion Checklist

## Foundation ✅
- [ ] All accounts created
- [ ] M4 Mac Mini configured
- [ ] Network optimized (10GbE + mesh)
- [ ] Remote access working

## Infrastructure ✅
- [ ] Docker running (62+ services)
- [ ] Proxmox deployed
- [ ] 3 VMs operational

## Core Services ✅
- [ ] Media stack automated
- [ ] Smart home integrated
- [ ] AI services running

## Security & Ops ✅
- [ ] Security hardened
- [ ] Monitoring dashboards live
- [ ] Backups automated
- [ ] Maintenance scheduled

---

# 📊 Final Stats

**What You Built:**

```
Hardware:
├─ M4 Mac Mini (32GB RAM, 10GbE)
├─ 4TB External SSD
├─ 10GbE Network
└─ Mesh WiFi (3 Decos)

Software:
├─ macOS Sequoia (host)
├─ OrbStack/Docker (62+ services)
├─ Proxmox (hypervisor)
└─ 3 VMs (Windows, Ubuntu, Kali)

Services:
├─ Media Stack (Plex, *arr)
├─ Smart Home (Home Assistant, Frigate)
├─ AI Services (Ollama, LM Studio)
├─ Security (Wazuh, CrowdSec)
├─ Monitoring (Grafana, Prometheus)
├─ Backup (Kopia, pCloud)
├─ Remote Access (RustDesk, Guacamole)
└─ [55+ more services...]

Total Service Count: 62+
Storage Used: ~2.5TB / 4TB
Power: 45-65W average
Uptime: 24/7/365
Awesomeness: 💯
```

---

# 🚀 You're Done!

**Congratulations! You've built:**
- ✅ Enterprise-grade homelab
- ✅ Professional infrastructure
- ✅ Automated everything
- ✅ Secure & monitored
- ✅ Backed up & maintained
- ✅ Epic achievement! 🎉

**Now enjoy your homelab!** ☕

*"Looks like I picked the right 22 days to build a homelab!"* 😎

---

**Next Steps:**
- Use your services
- Add more features
- Share with family
- Join r/homelab community
- Help others build theirs!

**Version:** 2.0  
**Total Time Investment:** ~80-100 hours over 22 days  
**Worth It:** Absolutely! 💯
