

> *"What is it?"*  
> *"It's a big building with patients, but that's not important right now."* - Airplane! (1980)

**Last Updated:** November 2025  
**System Owner:** Steve  
**Primary Access Devices:** iPad Pro 12.9" M1, MacBook Air 13", Samsung S25 Ultra

---

## 🖥️ Hardware Specifications

```
╔════════════════════════════════════════════════════════════╗
║                    M4 MAC MINI (SILVER)                    ║
╠════════════════════════════════════════════════════════════╣
║  CPU:     Apple M4 (10-core CPU, 10-core GPU)              ║
║  RAM:     32GB Unified Memory                              ║
║  Storage: 512GB Internal NVMe SSD                          ║
║  Network: 10GbE (Primary) + 2.5GbE (Secondary) + WiFi 7    ║
║  Ports:   3x Thunderbolt 4, 2x USB-A, HDMI, Audio          ║
╠════════════════════════════════════════════════════════════╣
║  External Storage:                                         ║
║  └─ Samsung 990 4TB SSD (Thunderbolt 4 Enclosure, 40Gbps)  ║
╠════════════════════════════════════════════════════════════╣
║ ║  Connectivity:                                           ║
║  ├─ 10GbE Built-in → TP-Link SX1008 Switch                 ║
║  ├─ 2.5GbE USB-C Adapter (Backup/Secondary)                ║
║  ├─ WiFi 7 (Disabled - using Deco mesh instead)            ║
║  └─ TP-Link Deco XE75 Mesh (3 units, wired backhaul)       ║
╠════════════════════════════════════════════════════════════╣
║  Power: 150W PSU (internal)                                ║
║  Status: Headless (HDMI dummy adapter installed)           ║
╚════════════════════════════════════════════════════════════╝
```

**Running 24/7 at:** 192.168.50.10  
**Internet:** 5Gbps/5Gbps CityFibre via Sky Router

---

## 🎯 System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         macOS Sequoia                           │
│                      (Base Operating System)                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────┐  ┌────────────────────────────────────┐ │
│  │  UTM (VMs)        │  │  OrbStack (Docker)                 │ │
│  │  ├─ Ubuntu Server │  │  └─ 60+ Containerized Services     │ │
│  │  ├─ Windows 11    │  │     ├─ Media Stack (Plex, *arr)   │ │
│  │  ├─ Kali Linux    │  │     ├─ Smart Home (HA, Frigate)   │ │
│  │  └─ macOS Tahoe   │  │     ├─ AI (Ollama, LM Studio)     │ │
│  └───────────────────┘  │     ├─ Security (Wazuh, CrowdSec) │ │
│                          │     ├─ Monitoring (Grafana)       │ │
│                          │     ├─ Automation (N8N)           │ │
│                          │     ├─ Backups (Kopia)            │ │
│                          │     └─ [55+ more services...]     │ │
│                          └────────────────────────────────────┘ │
│                                                                 │
├─────────────────────────────────────────────────────────────────┤
│                    Storage Management                           │
│  ┌─────────────────────────┬─────────────────────────────────┐ │
│  │ Internal 512GB          │ External 4TB Samsung 990         │ │
│  ├─────────────────────────┼─────────────────────────────────┤ │
│  │ • macOS System (100GB)  │ • VMs (1.5TB)                   │ │
│  │ • Docker Volumes (200GB)│   ├─ Ubuntu: 200GB              │ │
│  │ • Logs & Cache (50GB)   │   ├─ Windows 11: 500GB          │ │
│  │ • Scratch Space (162GB) │   ├─ Kali: 150GB                │ │
│  │                         │   └─ macOS: 650GB               │ │
│  │                         │ • Media Library (1.5TB)          │ │
│  │                         │   ├─ Movies: 800GB              │ │
│  │                         │   ├─ TV Shows: 500GB            │ │
│  │                         │   ├─ Music: 100GB               │ │
│  │                         │   └─ Comics/Books: 100GB        │ │
│  │                         │ • Backups (500GB)                │ │
│  │                         │ • ROMs & Gaming (300GB)          │ │
│  │                         │ • Documents/Scans (200GB)        │ │
│  └─────────────────────────┴─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Service Breakdown by Category

### 🎬 Media Services (8 services)

| Service | Purpose | Access URL | Storage |
|---------|---------|------------|---------|
| **Plex** | Media server & streaming | https://plex.stevehomelab.duckdns.org | 1.4TB |
| **Sonarr** | TV show automation | https://sonarr.stevehomelab.duckdns.org | 500GB |
| **Radarr** | Movie automation | https://radarr.stevehomelab.duckdns.org | 800GB |
| **Prowlarr** | Indexer manager | https://prowlarr.stevehomelab.duckdns.org | 5GB |
| **Bazarr** | Subtitle automation | https://bazarr.stevehomelab.duckdns.org | 10GB |
| **qBittorrent** | Download client (+VPN) | https://qbit.stevehomelab.duckdns.org | 200GB |
| **Tdarr** | Transcoding automation | https://tdarr.stevehomelab.duckdns.org | 50GB |
| **Overseerr** | Request management | https://requests.stevehomelab.duckdns.org | 2GB |

**Total Media Stack:** ~3TB  
**CPU Usage:** 15-40% (during transcoding)  
**Network:** 500Mbps-2Gbps (during downloads)

---

### 🏠 Smart Home Services (7 services)

| Service | Purpose | Access URL | Devices |
|---------|---------|------------|---------|
| **Home Assistant** | Smart home brain | https://ha.stevehomelab.duckdns.org | 43+ |
| **Scrypted** | Nest camera bridge | https://scrypted.stevehomelab.duckdns.org | 5 |
| **Frigate** | NVR + AI detection | https://frigate.stevehomelab.duckdns.org | 5 |
| **TeslaMate** | Tesla tracking | https://tesla.stevehomelab.duckdns.org | 1 |
| **EVCCv** | EV charging control | https://evcc.stevehomelab.duckdns.org | 1 |
| **Mosquitto** | MQTT broker | Internal only (port 1883) | N/A |
| **Zigbee2MQTT** | Zigbee bridge | Internal via HA | Future |

**Integrated Devices:**
- 🎵 10x Sonos speakers (1 Amp, 1 Beam, 1 Play:3, 7x Play:One)
- 📹 5x Nest Cameras (wired, 3rd gen)
- 🌡️ 1x Nest Thermostat (3rd gen)
- 🔌 Meross smart plugs
- 🚗 Tesla Model Y (2023)
- 🚗 Cupra Born EV
- 🔋 Easee Home charger (UKHBL455)
- 📺 2x LG NanoCell TVs (WebOS)
- 🎮 2x PS5
- 🎮 3x Xbox (2x Series S, 1x Series X)
- 🔊 Multiple Google Nest Mini speakers
- 📱 Samsung S24 & Brayden's Note10

**Storage:** 100GB  
**CPU Usage:** 5-10%  
**Network:** Always connected to all devices

---

### 🤖 AI & Productivity Services (11 services)

| Service | Purpose | Access URL | Models/Size |
|---------|---------|------------|-------------|
| **Ollama** | Local LLM server | https://ollama.stevehomelab.duckdns.org | 50GB |
| **Open WebUI** | ChatGPT-like interface | https://chat.stevehomelab.duckdns.org | 5GB |
| **LM Studio** | Model management | Desktop app (local) | 50GB |
| **AnythingLLM** | Document Q&A | https://llm.stevehomelab.duckdns.org | 20GB |
| **Paperless-ngx** | Document scanning/OCR | https://docs.stevehomelab.duckdns.org | 50GB |
| **Immich** | Photo backup (Google Photos alternative) | https://photos.stevehomelab.duckdns.org | 200GB |
| **Mealie** | Recipe management | https://recipes.stevehomelab.duckdns.org | 5GB |
| **Obsidian Vault** | Documentation (synced) | Obsidian Sync | 10GB |
| **Stirling-PDF** | PDF tools | https://pdf.stevehomelab.duckdns.org | 2GB |
| **IT-Tools** | Developer utilities | https://tools.stevehomelab.duckdns.org | 1GB |
| **LanguageTool** | Grammar/spell check | https://grammar.stevehomelab.duckdns.org | 5GB |

**AI Models Installed:**
- Llama 3.1 (8B, 70B)
- Mistral 7B
- CodeLlama 13B
- Vicuna 13B
- Nous Hermes 13B

**Total Storage:** ~400GB  
**CPU Usage:** 20-80% (when using AI)  
**RAM Usage:** 8-16GB (per large model)

---
### 🔐 Remote Access Services (2 services)

| Service | Purpose | Access URL | Platform |
|---------|---------|------------|----------|
| **RustDesk** | Self-hosted remote desktop | rustdesk.stevehomelab.duckdns.org:21115-21119 | All platforms |
| **Guacamole** | Web-based remote gateway | https://guacamole.stevehomelab.duckdns.org | Browser-based |

**Features:**
- 🔒 Self-hosted (complete privacy)
- 📱 Works on Android (unlike MS Remote Desktop!)
- 🌐 Browser access option (Guacamole)
- 🔑 Encrypted connections
- 📹 Session recording for compliance
- 👥 Multi-user support (Guacamole)

**Storage:** 5GB  
**CPU Usage:** <1%

---

### 🔒 Security & Network Services (9 services)

| Service | Purpose | Access URL | Protection |
|---------|---------|------------|------------|
| **Tailscale** | VPN access (primary) | System service | All services |
| **WireGuard** | VPN backup | System service | All services |
| **ExpressVPN** | qBittorrent tunnel | Container network | Download client |
| **Pi-hole** | Network-wide ad blocking | https://pihole.stevehomelab.duckdns.org | All devices |
| **Unbound** | Private DNS resolver | Internal only | DNS privacy |
| **Nginx Proxy Manager** | Reverse proxy + SSL | https://npm.stevehomelab.duckdns.org | All HTTPS |
| **Authelia** | SSO + 2FA portal | https://auth.stevehomelab.duckdns.org | All services |
| **Wazuh** | Security monitoring | https://wazuh.stevehomelab.duckdns.org | All systems |
| **CrowdSec** | IP reputation & blocking | https://crowdsec.stevehomelab.duckdns.org | All ports |
| **Fail2Ban** | Brute force protection | Integrated with NPM | SSH, Web |

**Security Features:**
- ✅ All services behind Authelia SSO
- ✅ 2FA via 1Password authenticator
- ✅ SSL certificates auto-renewed
- ✅ VPN-only external access
- ✅ Encrypted backups
- ✅ No ports exposed except 443 (HTTPS)
- ✅ Automated security updates

**CPU Usage:** 5-8%  
**Network:** Constant monitoring

---

### 📊 Monitoring & Dashboards (8 services)

| Service | Purpose | Access URL | Data Retention |
|---------|---------|------------|----------------|
| **Homer** | Main landing page | https://home.stevehomelab.duckdns.org | N/A |
| **Grafana** | Metrics visualization | https://grafana.stevehomelab.duckdns.org | 90 days |
| **Prometheus** | Metrics collection | Internal only (port 9090) | 90 days |
| **Loki** | Log aggregation | Internal via Grafana | 30 days |
| **Promtail** | Log collection | Agent on all systems | N/A |
| **Uptime Kuma** | Status monitoring | https://status.stevehomelab.duckdns.org | 365 days |
| **Netdata** | Real-time system stats | https://netdata.stevehomelab.duckdns.org | 24 hours |
| **ntopng** | Network traffic analysis | https://ntop.stevehomelab.duckdns.org | 7 days |
| **Portainer** | Docker management | https://portainer.stevehomelab.duckdns.org | N/A |

**What You're Monitoring:**
- 📈 CPU, RAM, disk, network usage (all systems)
- 🌡️ M4 temperature and power consumption
- 🌐 Internet speed tests (hourly)
- ⬆️ Upload/download bandwidth by device
- 💾 Disk space trends
- 🔄 Docker container health
- 📹 Camera uptime and events
- 🚗 EV charging sessions
- 🏠 Smart home device availability
- 🔐 Security events and alerts
- 💿 Media library growth
- ☁️ pCloud sync status

**Total Storage:** 150GB (logs + metrics)  
**CPU Usage:** 3-5%

---

### 💾 Backup & Recovery (4 services)

| Service | Purpose | Access URL | Destination |
|---------|---------|------------|-------------|
| **Kopia** | Encrypted backup engine | https://kopia.stevehomelab.duckdns.org | pCloud |
| **pCloud Sync** | Cloud storage sync | Desktop app | 7TB cloud |
| **Duplicati** | Alternative backup | https://duplicati.stevehomelab.duckdns.org | pCloud |
| **Restic** | CLI backup tool | Command line | pCloud |

**Backup Schedule:**
```
Daily (3 AM GMT):
├─ Docker volumes → pCloud (encrypted)
├─ VM snapshots → External 4TB
├─ Home Assistant config → GitHub
├─ Media metadata → pCloud
├─ Documents from Paperless → pCloud
└─ Photos from Immich → pCloud

Weekly (Sunday 4 AM GMT):
├─ Full VM backups → pCloud (encrypted)
├─ Complete system state → External 4TB
└─ Obsidian vault → GitHub + pCloud

Monthly (1st, 5 AM GMT):
├─ Bare metal recovery image → External 4TB
└─ Disaster recovery test (automated)
```

**Backup Storage:**
- Local: 500GB on 4TB external
- Cloud: ~2TB on pCloud (encrypted)
- GitHub: Configs only (~500MB)

**Retention:**
- Daily: 30 days
- Weekly: 12 weeks
- Monthly: 12 months

---

### 🎮 Entertainment & Media (10 services)

| Service | Purpose | Access URL | Library Size |
|---------|---------|------------|--------------|
| **Komga** | Comics/manga server | https://comics.stevehomelab.duckdns.org | 100GB |
| **Mylar3** | Comic automation | https://mylar.stevehomelab.duckdns.org | N/A |
| **Kapowarr** | Manga automation | https://manga.stevehomelab.duckdns.org | N/A |
| **Navidrome** | Music streaming | https://music.stevehomelab.duckdns.org | 100GB |
| **Spotify Connect** | Spotify integration | Via Home Assistant | N/A |
| **Audiobookshelf** | Audiobook server | https://audiobooks.stevehomelab.duckdns.org | 50GB |
| **RetroArch** | Retro gaming | VM + Desktop app | 300GB |
| **ROM Manager** | ROM organization | File system | 300GB |
| **FreshRSS** | RSS feed reader | https://rss.stevehomelab.duckdns.org | 5GB |
| **Calibre-web** | Ebook server | https://books.stevehomelab.duckdns.org | 20GB |

**Gaming Systems Available:**
- NES, SNES, N64
- GameBoy, GBC, GBA
- Nintendo DS
- Sega Genesis, Dreamcast
- PS1, PS2
- GameCube, Wii
- Arcade (MAME)

**Total Storage:** ~875GB

---

### 💻 Development & Automation (7 services)

| Service | Purpose | Access URL | Use Case |
|---------|---------|------------|----------|
| **Gitea** | Private Git server | https://git.stevehomelab.duckdns.org | Code repos |
| **Drone CI** | CI/CD pipelines | https://drone.stevehomelab.duckdns.org | Testing |
| **N8N** | Workflow automation | https://n8n.stevehomelab.duckdns.org | Everything! |
| **Code-server** | VS Code in browser | https://code.stevehomelab.duckdns.org | Remote dev |
| **Jupyter Lab** | Python notebooks | https://jupyter.stevehomelab.duckdns.org | Learning |
| **Action1 RMM** | Patch management | https://app.action1.com/ | Updates |
| **GitHub Actions** | External CI/CD | GitHub.com | Deployment |

**N8N Workflows Running:**
- 🔄 Backup automation (daily)
- 📧 Email processing and filing
- 📸 Photo backup from phones
- 📊 Report generation (weekly)
- 🔐 Security alert routing
- 📱 Phone notification aggregation
- 🏠 Smart home automations
- 📹 Camera event processing
- 🚗 EV charging optimization
- 💿 Media organization
- 📝 Document tagging (Paperless)
- ☁️ pCloud sync monitoring

**Total Storage:** 100GB  
**Active Workflows:** 25+

---

## 🖥️ Virtual Machines

### VM 1: Ubuntu Server 24.04 LTS

```
╔════════════════════════════════════════════════╗
║        Ubuntu Server 24.04 LTS (ARM64)        ║
╠════════════════════════════════════════════════╣
║  Purpose:   Linux workhorse, Docker host      ║
║  vCPUs:     6 cores                            ║
║  RAM:       8GB                                ║
║  Storage:   200GB (External SSD)               ║
║  Network:   Bridged (192.168.50.50)           ║
╠════════════════════════════════════════════════╣
║  Running Services:                             ║
║  ├─ Additional Docker containers               ║
║  ├─ Testing environment                        ║
║  ├─ Database servers (PostgreSQL, MySQL)      ║
║  └─ Web servers (Nginx, Apache)               ║
╚════════════════════════════════════════════════╝
```

**Use Cases:**
- Testing Docker configurations
- Running databases
- Learning Linux administration
- Hosting development projects

---

### VM 2: Windows 11 Pro (ARM64)

```
╔════════════════════════════════════════════════╗
║         Windows 11 Pro (ARM64 Insider)        ║
╠════════════════════════════════════════════════╣
║  Purpose:   Windows-specific software         ║
║  vCPUs:     8 cores                            ║
║  RAM:       12GB                               ║
║  Storage:   500GB (External SSD)               ║
║  Network:   Bridged (192.168.50.51)           ║
║  License:   Windows 11 Pro (activated)        ║
╠════════════════════════════════════════════════╣
║  Installed Software:                           ║
║  ├─ Microsoft 365 Apps                         ║
║  ├─ Visual Studio Code                         ║
║  ├─ Sublime Text                               ║
║  ├─ Action1 RMM Agent                          ║
║  ├─ 1Password                                  ║
║  └─ Testing applications                       ║
╚════════════════════════════════════════════════╝
```

**Use Cases:**
- Running Windows-only software
- Testing Windows configurations
- Microsoft 365 application use
- Windows development

---

### VM 3: Kali Linux (ARM64)

```
╔════════════════════════════════════════════════╗
║          Kali Linux 2024.x (ARM64)            ║
╠════════════════════════════════════════════════╣
║  Purpose:   Penetration testing & security    ║
║  vCPUs:     4 cores                            ║
║  RAM:       4GB                                ║
║  Storage:   150GB (External SSD)               ║
║  Network:   Isolated (192.168.50.52)          ║
╠════════════════════════════════════════════════╣
║  Tools Installed:                              ║
║  ├─ Nmap (network scanning)                   ║
║  ├─ Metasploit (exploitation framework)       ║
║  ├─ Burp Suite (web app testing)              ║
║  ├─ Wireshark (packet analysis)               ║
║  ├─ John the Ripper (password cracking)       ║
║  └─ 300+ security tools                       ║
╚════════════════════════════════════════════════╝
```

**Use Cases:**
- Learning penetration testing
- Security auditing your own network
- Vulnerability assessment
- Ethical hacking practice

---

### VM 4: macOS Tahoe (Optional)

```
╔════════════════════════════════════════════════╗
║           macOS Tahoe/Sequoia (ARM64)         ║
╠════════════════════════════════════════════════╣
║  Purpose:   macOS testing environment         ║
║  vCPUs:     6 cores                            ║
║  RAM:       8GB                                ║
║  Storage:   650GB (External SSD)               ║
║  Network:   Bridged (192.168.50.53)           ║
╠════════════════════════════════════════════════╣
║  Use Cases:                                    ║
║  ├─ macOS app testing                          ║
║  ├─ Clean environment experiments             ║
║  └─ Xcode development (if needed)             ║
╚════════════════════════════════════════════════╝
```

**Note:** May not set this up initially - evaluate need later.

---

## 📱 Access Methods by Device

### iPad Pro 12.9" M1 (Primary Dashboard Device)

**Optimized For:**
- Homer dashboard (main landing page)
- Home Assistant app (smart home control)
- Grafana dashboards (monitoring)
- Plex (media browsing)
- Camera feeds (Frigate)

**Access Methods:**
1. **At Home (WiFi):**
   - Direct IP: http://192.168.50.10
   - Friendly URLs: https://home.stevehomelab.duckdns.org

2. **Away From Home:**
   - Tailscale VPN → All services available
   - Home Assistant app → Smart home control
   - Plex app → Media streaming

**Bookmarks to Create:**
- 🏠 Homer Dashboard
- 📊 Grafana Overview
- 🏡 Home Assistant
- 🎬 Plex
- 📹 Frigate Cameras
- ⚠️ Uptime Kuma Status
- 📁 Paperless Documents
- 📸 Immich Photos

---

### MacBook Air 13" (Primary Management Device)

**Optimized For:**
- SSH access to M4 and VMs
- Docker management via Portainer
- Configuration editing
- N8N workflow creation
- Code development
- Terminal administration

**Installed Applications:**
- Tailscale (VPN)
- VS Code or Sublime Text
- Terminal (SSH)
- Obsidian (documentation)
- 1Password
- Plex desktop app
- Home Assistant Companion

**Typical Workflows:**
1. SSH into M4: `ssh steve@192.168.50.10`
2. Manage Docker: https://portainer.stevehomelab.duckdns.org
3. Edit configs in VS Code
4. Create N8N workflows
5. Monitor Grafana dashboards
6. Review logs in Loki

---

### Samsung S25 Ultra (Mobile Access)

**Optimized For:**
- Push notifications (Ntfy, Home Assistant)
- Quick status checks
- Camera viewing on-the-go
- Media control (Plex)
- Smart home control
- Emergency access

**Apps Installed:**
- Home Assistant Companion (primary)
- Ntfy (push notifications)
- Tailscale (VPN)
- Plex (media)
- 1Password (credentials)
- Immich (photo backup - auto-upload)

**Notification Types Received:**
- 🚨 Security alerts (Wazuh, CrowdSec)
- 💾 Backup status
- 🔌 VPN disconnections
- 📹 Camera motion (Frigate)
- 🔋 EV charging updates
- ⚠️ Service downtime
- 📊 Critical thresholds exceeded

---

## 🌐 Network Topology

```
Internet (5Gbps/5Gbps CityFibre)
                              │
                              │
                      ┌───────▼────────┐
                      │  Sky Router    │
                      │ 192.168.50.1   │
                      │ (Gateway Only) │
                      │ WiFi: DISABLED │
                      └───────┬────────┘
                              │
                      ┌───────▼────────┐
                      │  TP-Link       │
                      │  SX1008        │
                      │  10GbE Switch  │
                      └───────┬────────┘
                              │
                ┌─────────────┼─────────────┬──────────────┐
                │             │             │              │
        ┌───────▼──────┐  ┌──▼──────┐  ┌──▼──────┐  ┌───▼────┐
        │ M4 Mac Mini  │  │ Deco #1 │  │ Deco #2 │  │ Deco #3│
        │ 192.168.50.10│  │ (Main)  │  │ (Office)│  │ (Bed)  │
        │    (10GbE)   │  │ WIRED   │  │ WIRED   │  │ WIRED  │
        └──────────────┘  └─────────┘  └─────────┘  └────────┘
                               │            │            │
                               └────────────┴────────────┘
                                        │
                                WiFi 6E Mesh Network
                               (All wireless devices)

```

Mesh Network Coverage:
├─ Deco #1 (Main): Living room, kitchen, front of house
├─ Deco #2 (Office): Home office, back garden
└─ Deco #3 (Bedroom): Upstairs bedrooms, bathroom
WiFi Devices (43+):
├─ Smart Home (192.168.50.200-254)
│  ├─ 10x Sonos speakers
│  ├─ 5x Nest cameras
│  ├─ 1x Nest thermostat
│  ├─ Multiple Nest Mini speakers
│  ├─ Meross smart plugs
│  ├─ Easee charger
│  ├─ Tesla Model Y
│  └─ Cupra Born
├─ Computers/Tablets
│  ├─ MacBook Air
│  ├─ MacBook Pro
│  ├─ iPad Pro
│  ├─ Windows laptops
│  └─ M2 Mac Mini
├─ Gaming Consoles
│  ├─ 2x PS5
│  └─ 3x Xbox One Series
└─ Mobile Devices
├─ Samsung S25 Ultra
├─ Samsung S24
└─ Brayden's Note10

**Network Benefits:**
- 🚀 Wired backhaul = maximum throughput
- 📶 Better WiFi coverage (3 access points)
- 🔄 Seamless roaming between Decos
- ⚡ Sky router optimized (gateway-only, no WiFi interference)
- 🎯 Dedicated 10GbE for M4 (no WiFi contention)


**IP Address Allocation:**
```
192.168.50.1        Sky Router (gateway)
192.168.50.10       M4 Mac Mini (static)
192.168.50.50-69    VMs
  .50 → Ubuntu Server
  .51 → Windows 11
  .52 → Kali Linux
  .53 → macOS (if used)
192.168.50.100-199  Docker services (dynamic)
192.168.50.201      Brother Printer (static)
192.168.50.202-254  IoT devices (DHCP)
```

---

## 💪 System Capabilities

### What This System Can Do:

✅ **Stream 4K media** to 5+ devices simultaneously  
✅ **Transcode 3 streams** at once (hardware accelerated)  
✅ **Monitor 43+ smart home devices** 24/7  
✅ **Record 5 camera feeds** with AI detection  
✅ **Run 4 virtual machines** concurrently  
✅ **Host 62+ containerized services** efficiently  
✅ **Process AI queries** with local LLMs (8B-70B models)  
✅ **Scan & OCR documents** automatically  
✅ **Backup 2TB+ data** to cloud (encrypted)  
✅ **Block ads** for entire network  
✅ **Monitor security** across all systems  
✅ **Automate downloads** via VPN  
✅ **Sync photos** from phones automatically  
✅ **Track EV charging** and statistics  
✅ **Serve retro games** to any device  
✅ **Provide remote access** securely via VPN  

### Performance Expectations:

**Idle (No Active Use):**
- CPU: 10-15%
- RAM: 12-16GB / 32GB
- Power: 25-35W
- Network: <10Mbps

**Normal Use (Media Streaming + Smart Home):**
- CPU: 20-40%
- RAM: 18-22GB / 32GB
- Power: 45-65W
- Network: 50-500Mbps

**Heavy Use (Transcoding + AI + Backups):**
- CPU: 60-90%
- RAM: 26-30GB / 32GB
- Power: 85-120W
- Network: 1-3Gbps

**Peak Load (Everything at Once):**
- CPU: 95-100% (throttles gracefully)
- RAM: 30-32GB / 32GB (swap used)
- Power: 120-145W (within spec)
- Network: 3-5Gbps (maxing your connection!)

---

## 🔧 Maintenance Schedule

### Automated (No Action Required)

**Daily (3:00 AM GMT):**
- Docker container health checks
- Log rotation
- Incremental backups to pCloud
- Database optimization
- Disk space cleanup
- Security scan updates

**Weekly (Sunday 4:00 AM GMT):**
- Full system updates (via Action1)
- Full VM backups
- Certificate renewal checks
- Network speed tests aggregation
- Prometheus/Loki data pruning

**Monthly (1st, 5:00 AM GMT):**
- Bare metal backup image
- Disaster recovery test
- Storage health check (SMART)
- Security audit report
- N8N workflow health check

### Manual (Steve's Tasks)

**Daily (5 minutes):**
- Check Homer dashboard status
- Review Uptime Kuma (all green?)
- Glance at Grafana CPU/RAM
- Check Ntfy notifications

**Weekly (30 minutes):**
- Review Wazuh security alerts
- Check backup success logs
- Update media library metadata
- Review disk space trends
- Test one random service

**Monthly (2 hours):**
- Review all service logs
- Update documentation
- Test disaster recovery
- Review N8N workflows
- Clean up old Docker images
- Audit 1Password credentials

---

## 📊 Resource Usage Summary

### Storage Breakdown (Total: 4.5TB)

```
Internal 512GB SSD:
├─ macOS System      100GB  ████████████░░░░░░░░░░░░░░░░░  20%
├─ Docker Volumes    200GB  ████████████████████████░░░░░  39%
├─ Logs & Cache       50GB  ██████░░░░░░░░░░░░░░░░░░░░░░  10%
└─ Scratch Space     162GB  ████████████████░░░░░░░░░░░░  32%

External 4TB SSD:
├─ Virtual Machines    1.5TB  ██████████░░░░░░░░░░░░░░░░  38%
├─ Media Library       1.5TB  ██████████░░░░░░░░░░░░░░░░  38%
├─ Backups             500GB  ███░░░░░░░░░░░░░░░░░░░░░░░  13%
├─ ROMs & Gaming       300GB  ██░░░░░░░░░░░░░░░░░░░░░░░░   8%
└─ Documents/Scans     200GB  █░░░░░░░░░░░░░░░░░░░░░░░░░   5%

pCloud (7TB available):
└─ Encrypted Backups     2TB  █░░░░░░░░░░░░░░░░░░░░░░░░░  29%
```

### CPU Allocation

```
Service Category          CPU Cores    Usage (Avg)    Usage (Peak)
═══════════════════════════════════════════════════════════════════
macOS System              2 cores      10%            25%
Docker Containers         4 cores      25%            70%
Virtual Machines          3 cores      15%            60%
AI Processing (on-demand) 1-8 cores    0-80%          100%
───────────────────────────────────────────────────────────────────
Total Available           10 cores     
Average Usage                          50%            
Peak Usage                                            100%
```

### Memory Allocation

```
Component                 Allocated    Used (Avg)     Used (Peak)
═══════════════════════════════════════════════════════════════════
macOS System              4GB          3.5GB          4GB
OrbStack (Docker)         12GB         8GB            12GB
Virtual Machines          12GB         10GB           12GB
  ├─ Ubuntu               4GB          3GB            4GB
  ├─ Windows              6GB          5GB            6GB
  └─ Kali                 2GB          2GB            2GB
Cache & Buffers           4GB          2GB            4GB
───────────────────────────────────────────────────────────────────
Total Available           32GB
Average Usage                          23.5GB
Peak Usage                                            32GB
```

### Network Usage

```
Service Type              Bandwidth Usage
═══════════════════════════════════════════════════════════════════
Media Streaming           Up to 500Mbps per stream
Downloads (VPN)           500Mbps - 2Gbps sustained
Backups                   1-2Gbps (during backup window)
Smart Home                <1Mbps constant
Camera Recording          25Mbps (5 cameras × 5Mbps each)
Remote Access             Variable (up to 100Mbps)
Monitoring/Logs           <5Mbps constant
───────────────────────────────────────────────────────────────────
Average Total             500Mbps - 1Gbps
Peak Total                3-4Gbps (during heavy backup + download)
```

---

## 🎯 Quick Access Dashboard URLs

Save these to your devices' home screens/bookmarks:

### 🏠 Primary Dashboards
- **Homer (Main):** https://home.stevehomelab.duckdns.org
- **Home Assistant:** https://ha.stevehomelab.duckdns.org
- **Grafana:** https://grafana.stevehomelab.duckdns.org
- **Uptime Kuma:** https://status.stevehomelab.duckdns.org

### 🎬 Media
- **Plex:** https://plex.stevehomelab.duckdns.org
- **Overseerr (Requests):** https://requests.stevehomelab.duckdns.org
- **Comics (Komga):** https://comics.stevehomelab.duckdns.org
- **Music (Navidrome):** https://music.stevehomelab.duckdns.org

### 📹 Cameras
- **Frigate NVR:** https://frigate.stevehomelab.duckdns.org
- **Scrypted:** https://scrypted.stevehomelab.duckdns.org

### 🤖 AI
- **Open WebUI (Chat):** https://chat.stevehomelab.duckdns.org
- **AnythingLLM:** https://llm.stevehomelab.duckdns.org

### 📄 Documents
- **Paperless-ngx:** https://docs.stevehomelab.duckdns.org
- **Photos (Immich):** https://photos.stevehomelab.duckdns.org

### 🔧 Management
- **Portainer (Docker):** https://portainer.stevehomelab.duckdns.org
- **Nginx Proxy Manager:** https://npm.stevehomelab.duckdns.org
- **N8N Automation:** https://n8n.stevehomelab.duckdns.org

### 🔒 Security
- **Authelia (SSO):** https://auth.stevehomelab.duckdns.org
- **Pi-hole:** https://pihole.stevehomelab.duckdns.org
- **Wazuh:** https://wazuh.stevehomelab.duckdns.org

---

## 🚀 System Boot Sequence

When the M4 Mac Mini starts up:

```
T+0:00  ┌─────────────────────────────────────────┐
        │ 1. macOS Boot (Sequoia)                 │
        │    └─ System integrity check            │
        └─────────────────────────────────────────┘
T+0:30  ┌─────────────────────────────────────────┐
        │ 2. Mount External 4TB SSD               │
        │    └─ APFS encrypted volume             │
        └─────────────────────────────────────────┘
T+0:45  ┌─────────────────────────────────────────┐
        │ 3. Network Configuration                │
        │    ├─ 10GbE link up                     │
        │    └─ Static IP assigned: .50.10        │
        └─────────────────────────────────────────┘
T+1:00  ┌─────────────────────────────────────────┐
        │ 4. OrbStack Startup                     │
        │    └─ Docker daemon initialized         │
        └─────────────────────────────────────────┘
T+1:30  ┌─────────────────────────────────────────┐
        │ 5. Core Services Start (Priority 1)    │
        │    ├─ Tailscale VPN                     │
        │    ├─ Pi-hole DNS                       │
        │    ├─ Nginx Proxy Manager               │
        │    └─ Authelia SSO                      │
        └─────────────────────────────────────────┘
T+2:00  ┌─────────────────────────────────────────┐
        │ 6. Infrastructure Services (Priority 2) │
        │    ├─ Prometheus                        │
        │    ├─ Loki                              │
        │    ├─ Grafana                           │
        │    └─ Portainer                         │
        └─────────────────────────────────────────┘
T+2:30  ┌─────────────────────────────────────────┐
        │ 7. Application Services (Priority 3)    │
        │    ├─ Home Assistant                    │
        │    ├─ Plex                              │
        │    ├─ Frigate                           │
        │    ├─ Sonarr/Radarr                     │
        │    └─ [50+ other containers]            │
        └─────────────────────────────────────────┘
T+3:00  ┌─────────────────────────────────────────┐
        │ 8. Virtual Machines (Priority 4)        │
        │    ├─ Ubuntu Server VM                  │
        │    ├─ Windows 11 VM (if configured)     │
        │    └─ Kali Linux VM (if configured)     │
        └─────────────────────────────────────────┘
T+4:00  ┌─────────────────────────────────────────┐
        │ 9. Health Checks & Notifications        │
        │    ├─ All services verified             │
        │    ├─ Network connectivity tested       │
        │    ├─ Backup status checked             │
        │    └─ Push notification sent: "Ready!"  │
        └─────────────────────────────────────────┘
T+5:00  ✅ SYSTEM FULLY OPERATIONAL
```

**Total boot time:** ~5 minutes to full operation  
**You'll receive:** Ntfy push notification when ready

---

## 📞 Emergency Contact Information

### If Everything Explodes 💥

1. **Reboot Everything:**
   ```
   sudo shutdown -r now
   ```
   Wait 5 minutes, everything will come back up.

2. **Check Status Page:**
   - https://status.stevehomelab.duckdns.org
   - Shows what's up/down

3. **Check Logs:**
   - SSH: `ssh steve@192.168.50.10`
   - Logs: `docker logs <container-name>`
   - System: `sudo tail -f /var/log/system.log`

4. **Nuclear Option (Restore from Backup):**
   - See Guide 54: Disaster Recovery
   - Your backups are in pCloud
   - Recovery time: ~4 hours

### Support Resources

- **Reddit:** r/homelab, r/selfhosted, r/homeassistant
- **Discord:** Home Assistant Discord, Plex Discord
- **Forums:** Home Assistant Community, Plex Forums
- **Documentation:** This Obsidian vault!

---

## 🎓 Skills You'll Gain

By building and maintaining this system, you'll learn:

✅ **System Administration**
- Linux server management
- macOS advanced configuration
- Windows server administration
- User & permission management

✅ **Networking**
- TCP/IP fundamentals
- DNS configuration
- VPN technologies
- Firewall rules
- Network monitoring
- VLAN concepts

✅ **Containerization**
- Docker fundamentals
- Docker Compose
- Container networking
- Volume management
- Image optimization

✅ **Virtualization**
- Virtual machine creation
- Resource allocation
- Network bridging
- Snapshot management

✅ **Security**
- SSL/TLS certificates
- Authentication & authorization
- Firewall configuration
- Intrusion detection
- Vulnerability scanning
- Encryption best practices

✅ **Automation**
- Workflow creation (N8N)
- Bash scripting
- Python scripting
- CI/CD pipelines
- Scheduled tasks

✅ **Monitoring**
- Metrics collection
- Log aggregation
- Alerting systems
- Dashboard creation
- Performance analysis

✅ **Backup & Recovery**
- Backup strategies (3-2-1 rule)
- Encryption
- Disaster recovery
- Testing procedures

---

## 🎯 Future Expansion Ideas

Once you've mastered the basics, consider:

### Hardware Additions
- 🖥️ **Second M4 Mac Mini** (High Availability cluster)
- 💾 **NAS Device** (Synology/QNAP for dedicated storage)
- 🔌 **UPS** (Battery backup for power outages)
- 📡 **Better WiFi** (UniFi AP for separate IoT network)
- 🎮 **Gaming PC** (For GPU-intensive tasks)

### Software Additions
- 📧 **Email Server** (Mail-in-a-Box or Mailcow)
- 🗣️ **Voice Assistant** (Rhasspy or Mycroft)
- 🌐 **Website Hosting** (Personal blog, portfolio)
- 💬 **Chat Server** (Matrix Synapse)
- 📞 **VOIP Server** (FreePBX/Asterisk)
- 🎨 **Design Tools** (Excalidraw, Draw.io)
- 📚 **Wiki** (BookStack or Wiki.js)

### Advanced Projects
- 🤖 **Custom AI Models** (Fine-tuned for your needs)
- 🏠 **Advanced Automations** (Presence detection, ML)
- 🔐 **HSM** (Hardware Security Module)
- 📡 **Software Defined Radio** (RTL-SDR integration)
- 🌐 **Mesh Network** (For IoT devices)

---

## 💡 Pro Tips

### Optimization Tips
1. **Keep Docker images updated** (weekly)
2. **Monitor disk space** (set alerts at 80%)
3. **Review logs regularly** (catch issues early)
4. **Test backups monthly** (backups you don't test are useless)
5. **Document changes** (in Obsidian vault)
6. **Label everything** (cables, devices, VMs)
7. **Use version control** (Git for all configs)
8. **Keep 1Password updated** (with all credentials)

### Power User Shortcuts
```bash
# SSH to M4 from MacBook
alias homelab='ssh steve@192.168.50.10'

# Quick Docker commands
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dlogs='docker logs -f'
alias dstop='docker stop $(docker ps -aq)'
alias dstart='docker start $(docker ps -aq)'

# Service status
alias status='curl -s https://status.stevehomelab.duckdns.org'

# Backup now
alias backup-now='ssh steve@192.168.50.10 "~/Scripts/backup-now.sh"'
```

### Troubleshooting Workflow
1. Check Uptime Kuma (what's down?)
2. Check Grafana (resource issue?)
3. Check container logs (error messages?)
4. Check network (connectivity issue?)
5. Reboot the specific service
6. Reboot the whole system (last resort)

---

## 🎬 Final Words

Steve, this M4 Mac Mini is going to be your:
- 📺 Personal Netflix (Plex)
- 🏠 Smart home brain (Home Assistant)
- 🤖 Private AI assistant (Ollama)
- 🔐 Security headquarters (Wazuh, Pi-hole)
- 📊 Data center dashboard (Grafana)
- 💾 Backup vault (Kopia → pCloud)
- 🎮 Retro arcade (RetroArch)
- 💻 Development lab (VMs, Code-server)
- 🚗 EV monitor (TeslaMate)
- 📹 Security system (Frigate)

**All running 24/7 on one tiny silver box! **

This isn't just a server - it's a learning platform, entertainment center, smart home hub, and personal cloud all in one.

**Your 5Gbps internet connection is about to get a workout!** 💪

---

**Ready to build this?**  
**Next Step:** [Go to START HERE Guide](🏠%20Epic%20HomeLab%20-%20Complete%20Documentation%20Package.md)

---

```
     _____ _                 _       _    _                      _       _     
    / ____| |               ( )     | |  | |                    | |     | |    
   | (___ | |_ _____   _____| |___  | |__| | ___  _ __ ___   ___| | __ _| |__  
    \___ \| __/ _ \ \ / / _ \ / __| |  __  |/ _ \| '_ ` _ \ / _ \ |/ _` | '_ \ 
    ____) | ||  __/\ V /  __/ \__ \ | |  | | (_) | | | | | |  __/ | (_| | |_) |
   |_____/ \__\___| \_/ \___|_|___/ |_|  |_|\___/|_| |_| |_|\___|_|\__,_|_.__/ 
                                                                                 
```

*"Surely you can't be serious?"*  
*"I am serious. And don't call me Shirley."*  

**Let's build something EPIC! 🚀☕**

---

*Document Version: 1.0*  
*Last Updated: November 2025*  
**Total Services:** 62+ (including RustDesk + Guacamole)
*Total Storage: 4.5TB*  
*Coffee Required: Infinite ☕∞*
