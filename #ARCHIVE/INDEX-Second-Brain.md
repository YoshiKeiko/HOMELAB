# 🧠 HomeLab Second Brain - Navigation Hub

---
tags: [homelab, index, second-brain, moc, navigation]
aliases: [HomeLab Hub, Navigation, MOC]
created: 2025-11-11
---

> *Your Map of Content (MOC) for the complete homelab documentation*

## 🎯 Quick Access

### 📖 Essential Starting Points
- [[MASTER-HomeLab-Complete]] - **Everything in ONE file** ⭐
- [[M4 Mac Mini - Complete System Overview]] - Architecture & specs
- [[HomeLab Installation Roadmap]] - 22-day implementation plan
- [[HomeLab Quick Reference Guide]] - Quick commands & URLs

---

## 🗺️ Map of Content (MOC)

### 🏗️ Foundation & Setup
*Days 1-2: Getting started*

**Core Setup:**
- [[Day-01-02-Foundation-and-Accounts]] - Accounts, prerequisites, 1Password
- [[Day-01-02-M4-Mac-Mini-Setup]] - M4 unboxing, macOS, network

**Related Concepts:**
- #foundation #accounts #1password #duckdns #tailscale
- #hardware #m4 #macos #network #10gbe

**Key Services:** DuckDNS, Tailscale, 1Password, pCloud

---

### 🌐 Network Infrastructure  
*Days 2-3: Professional networking*

**Mesh WiFi:**
- [[Day-02-BONUS-Deco-Mesh-Setup]] - Bonus guide
- [[Day-03-Deco-Mesh-WiFi]] - Complete mesh setup

**Key Concepts:**
- #network #wifi #mesh #deco #sky-router
- Wired backhaul, IoT network, 43+ devices

**Hardware:** TP-Link Deco XE75 (3 units), Sky Router (gateway mode)

---

### 🐳 Docker & Containers
*Days 3-5: Container infrastructure*

**Docker Setup:**
- [[Day-03-05-Docker-Infrastructure]] - OrbStack, Portainer, 62+ services

**Related Guides:**
- [[Day-13-14-Media-Stack-Plex]] - Media containers
- [[Day-15-16-Smart-Home-Integration]] - IoT containers
- [[Day-17-18-AI-Services-LLMs]] - AI containers

**Key Concepts:**
- #docker #containers #orbstack #portainer #compose
- docker-compose-master.yml, persistent volumes, networks

**Services:** 62+ containerized applications

---

### 🔐 Remote Access
*Day 5: Access from anywhere*

**Remote Desktop:**
- [[Day-05-BONUS-Remote-Access]] - Bonus guide  
- [[Day-05-Remote-Access]] - Complete setup

**Key Services:**
- [[Day-05-Remote-Access#RustDesk|RustDesk]] - Self-hosted relay (Android!)
- [[Day-05-Remote-Access#Guacamole|Apache Guacamole]] - Web gateway

**Concepts:**
- #remote-access #rustdesk #guacamole #android #self-hosted
- Port forwarding, public key authentication

---

### 💻 Virtualization
*Days 6-8: Hypervisor & VMs*

**Proxmox Setup:**
- [[Day-06-08-Proxmox-Hypervisor]] - UTM, Proxmox installation
- [[REF-Proxmox-Quick-Reference]] - Quick commands

**Virtual Machines:**
- [[Day-09-10-Windows-11-VM]] - Windows 11 Pro VM
- [[Day-11-12-Ubuntu-Kali-VMs]] - Linux VMs (Ubuntu + Kali)

**Key Concepts:**
- #proxmox #virtualization #hypervisor #vm
- #windows #windows11 #ubuntu #kali #linux
- Static IPs: Windows (.52), Ubuntu (.51), Kali (.53)

---

### 🎬 Media Stack
*Days 13-14: Automated media*

**Complete Media Automation:**
- [[Day-13-14-Media-Stack-Plex]] - Plex, *arr suite, automation

**Services:**
- [[Day-13-14-Media-Stack-Plex#Plex|Plex Media Server]] - Streaming
- [[Day-13-14-Media-Stack-Plex#Sonarr|Sonarr]] - TV automation
- [[Day-13-14-Media-Stack-Plex#Radarr|Radarr]] - Movie automation  
- Prowlarr, Bazarr, qBittorrent, Overseerr

**Concepts:**
- #media #plex #automation #arr #sonarr #radarr
- VPN integration, 1.5TB library, 4K streaming

---

### 🏠 Smart Home
*Days 15-16: IoT integration*

**Smart Home Hub:**
- [[Day-15-16-Smart-Home-Integration]] - Home Assistant, Frigate, 43+ devices

**Integrations:**
- 10x [[Day-15-16-Smart-Home-Integration#Sonos|Sonos speakers]]
- 5x [[Day-15-16-Smart-Home-Integration#Nest|Nest cameras]]
- [[Day-15-16-Smart-Home-Integration#Tesla|Tesla Model Y]]
- [[Day-15-16-Smart-Home-Integration#Cupra|Cupra Born EV]]
- [[Day-15-16-Smart-Home-Integration#Easee|Easee Charger]]

**Concepts:**
- #smart-home #iot #home-assistant #frigate #cameras
- #sonos #nest #tesla #ev #charging
- AI detection, automations, energy monitoring

---

### 🤖 AI Services
*Days 17-18: Local LLMs*

**Local AI:**
- [[Day-17-18-AI-Services-LLMs]] - Ollama, LM Studio, Open WebUI

**Models:**
- Llama 3, Mistral, Phi-3, CodeLlama
- 8B to 70B parameter models

**Concepts:**
- #ai #llm #ollama #lm-studio #machine-learning
- Local inference, privacy, API access

---

### 🛡️ Security
*Day 19: Hardening*

**Security Stack:**
- [[Day-19-Security-Hardening]] - Wazuh, CrowdSec, Fail2ban, Authelia

**Services:**
- [[Day-19-Security-Hardening#Wazuh|Wazuh SIEM]] - Security monitoring
- [[Day-19-Security-Hardening#CrowdSec|CrowdSec]] - Threat blocking
- [[Day-19-Security-Hardening#Authelia|Authelia]] - SSO/2FA

**Concepts:**
- #security #hardening #wazuh #crowdsec #siem
- Firewall rules, SSO, automated responses

---

### 📊 Monitoring
*Day 20: Observability*

**Monitoring Stack:**
- [[Day-20-Monitoring-Setup]] - Grafana, Prometheus, Loki

**Dashboards:**
- [[Day-20-Monitoring-Setup#Grafana|Grafana]] - Visualization
- [[Day-20-Monitoring-Setup#Prometheus|Prometheus]] - Metrics
- [[Day-20-Monitoring-Setup#Loki|Loki]] - Log aggregation
- Uptime Kuma, Netdata, ntopng

**Concepts:**
- #monitoring #grafana #prometheus #observability
- #metrics #logs #dashboards #alerts
- 90-day retention, real-time stats

---

### 💾 Backup & Recovery
*Day 21: Data protection*

**Backup Strategy:**
- [[Day-21-Backup-Strategy]] - Kopia, pCloud, automated backups

**Schedule:**
- Daily: Docker volumes → pCloud
- Weekly: VM snapshots → External + pCloud
- Monthly: Full system → External + pCloud

**Concepts:**
- #backup #disaster-recovery #kopia #pcloud
- Encrypted backups, 3-2-1 strategy, automated testing

---

### 🔧 Maintenance
*Day 22: Operations*

**Maintenance & Updates:**
- [[Day-22-Maintenance-and-RMM]] - Action1, patching, procedures
- [[Day-22-Network-Diagrams-Final]] - Complete topology

**Concepts:**
- #maintenance #updates #action1 #rmm #patching
- Automated updates, maintenance windows, runbooks

---

## 🔗 Cross-References

### By Technology:
- **Networking:** [[Day-03-Deco-Mesh-WiFi]] → [[Day-22-Network-Diagrams-Final]]
- **Docker:** [[Day-03-05-Docker-Infrastructure]] → All service guides
- **VMs:** [[Day-06-08-Proxmox-Hypervisor]] → [[Day-09-10-Windows-11-VM]] → [[Day-11-12-Ubuntu-Kali-VMs]]
- **Services:** [[Day-13-14-Media-Stack-Plex]] + [[Day-15-16-Smart-Home-Integration]] + [[Day-17-18-AI-Services-LLMs]]
- **Operations:** [[Day-19-Security-Hardening]] + [[Day-20-Monitoring-Setup]] + [[Day-21-Backup-Strategy]]

### By Phase:
1. **Foundation** → Days 1-2
2. **Infrastructure** → Days 3-6  
3. **Platforms** → Days 7-12
4. **Services** → Days 13-18
5. **Operations** → Days 19-22

---

## 🏷️ Tag Index

### Core Tags:
- #homelab - All files
- #foundation - Setup & accounts
- #infrastructure - Network, Docker, Proxmox
- #services - Media, Smart Home, AI
- #operations - Security, Monitoring, Backup

### Technology Tags:
- #docker #containers #compose
- #proxmox #virtualization #vm
- #network #wifi #mesh #10gbe
- #media #plex #automation #arr
- #smart-home #iot #home-assistant
- #ai #llm #ollama #machine-learning
- #security #monitoring #backup

### Service Tags:
- #rustdesk #guacamole (Remote access)
- #plex #sonarr #radarr (Media)
- #home-assistant #frigate (Smart home)
- #ollama #lm-studio (AI)
- #wazuh #crowdsec (Security)
- #grafana #prometheus (Monitoring)
- #kopia #pcloud (Backup)

---

## 📈 Progress Tracking

Use this MOC to track your implementation:

- [ ] Foundation & Setup (Days 1-2)
- [ ] Network Infrastructure (Day 3)
- [ ] Docker & Containers (Days 4-5)
- [ ] Remote Access (Day 5)
- [ ] Virtualization (Days 6-8)
- [ ] Virtual Machines (Days 9-12)
- [ ] Media Stack (Days 13-14)
- [ ] Smart Home (Days 15-16)
- [ ] AI Services (Days 17-18)
- [ ] Security (Day 19)
- [ ] Monitoring (Day 20)
- [ ] Backups (Day 21)
- [ ] Maintenance (Day 22)

---

## 🎨 Graph View Tips

**In Obsidian:**
1. Open Graph View: `Ctrl+G` / `Cmd+G`
2. Filter by tags: `tag:#docker` `tag:#media` `tag:#security`
3. Group by colors for each phase
4. See relationships between guides

**Suggested Colors:**
- 🔵 Foundation & Setup
- 🟢 Infrastructure  
- 🟡 Services & Applications
- 🟠 Security & Operations
- ⚫ Reference Documents

---

## 📊 Statistics

**Your HomeLab:**
- Hardware: M4 Mac Mini (32GB, 10GbE)
- Storage: 512GB internal + 4TB external
- Network: 10GbE wired + Deco mesh WiFi
- Services: 62+ Docker containers
- VMs: 3 (Windows, Ubuntu, Kali)
- Smart Devices: 43+
- Documentation: 100,000+ words

---

#homelab #second-brain #moc #index #navigation
