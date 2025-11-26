---
title: 📚 Volume 01: Foundation (Days 1-2) - COMPLETE GUIDE
tags: [homelab, foundation, setup, accounts]
created: 2025-11-11
type: homelab-guide
---

# 📚 Volume 01: Foundation (Days 1-2) - COMPLETE GUIDE

**Building the Foundation for Steve's Epic HomeLab**

> *"A house built on sand will fall, but a homelab built on proper foundations will serve you for years!"* 🏗️

---

## 📋 Volume Overview

**Days:** 1-2  
**Time Required:** 12-16 hours total  
**Coffee Required:** ☕☕☕☕☕☕☕☕ (8 cups minimum!)  
**Difficulty:** Beginner to Intermediate  

### What You'll Complete

By end of Day 2, you'll have:
- ✅ All accounts created and documented in 1Password
- ✅ All software downloaded and ready
- ✅ M4 Mac Mini unboxed and configured
- ✅ Network optimized with static IP
- ✅ 4TB external SSD formatted and ready
- ✅ Essential tools installed
- ✅ Solid foundation for 62+ services

---

## 🎯 Guides in This Volume

- [Guide 00: Prerequisites & Account Setup](#guide-00-prerequisites)
- [Guide 01: Hardware Preparation](#guide-01-hardware)
- [Guide 02: M4 Mac Mini Initial Setup](#guide-02-m4-initial-setup)
- [Guide 03: macOS Configuration](#guide-03-macos-configuration)
- [Guide 04: Network Setup](#guide-04-network-setup)
- [Guide 05: Storage Configuration](#guide-05-storage)
- [Guide 06: Essential Tools Installation](#guide-06-essential-tools)

---

# Guide 00: Prerequisites & Account Setup

**⏱️ Time:** 2-3 hours  
**☕ Coffee:** 2 cups  
**🎯 Difficulty:** Beginner  

## ✅ Prerequisites Checklist

Before you begin, verify you have:

### Hardware (Already Owned)
- [x] M4 Mac Mini (32GB RAM, 512GB storage)
- [x] 4TB External SSD (Samsung T7 or similar)
- [x] Sky Router (existing)
- [x] TP-Link SX1008 10GbE Switch
- [x] 10GbE cables (Cat6a or better)
- [x] Monitor (for initial setup)
- [x] Keyboard & Mouse (for initial setup)
- [x] Samsung S25 Ultra (your phone)
- [x] MacBook Air (secondary device)
- [x] iPad Pro (optional, for management)

### Network Infrastructure
- [x] CityFibre 5Gbps/5Gbps internet active
- [x] Router accessible at 192.168.50.1
- [x] Admin access to router
- [x] 10GbE switch connected
- [x] Available IP addresses: 192.168.50.10-192.168.50.100

### Existing Accounts (You Already Have)
- [x] ExpressVPN subscription active
- [x] 1Password Teams account
- [x] ChatGPT Teams subscription
- [x] Claude Pro subscription
- [x] Perplexity Pro subscription
- [x] pCloud 7TB Lifetime account
- [x] GitHub account (steve-smithit)
- [x] Microsoft account (itstevesmithIT@gmail.com)

---

## 🌐 Website Registrations & Account Creation

**CRITICAL:** Create these accounts BEFORE starting setup. Save ALL credentials in 1Password immediately!

### 1️⃣ 1Password HomeLab Vault Setup

**Do this FIRST - everything else goes in here!**

1. **Open 1Password**
   - Already installed on Samsung S25 Ultra
   - Already installed on MacBook Air
   - Install on iPad Pro if using

2. **Create HomeLab Vault**
   ```
   Open 1Password → Vaults → Create New Vault
   
   Name: HomeLab
   Description: All homelab accounts, servers, and services
   Icon: Server/Home icon
   
   Click: Create Vault
   ```

3. **Verify Vault Created**
   - [x] HomeLab vault appears in vault list
   - [x] Can switch to HomeLab vault
   - [x] Vault syncs across devices

**✅ CHECKPOINT:** HomeLab vault created and syncing

---

### 2️⃣ DuckDNS Account (Free Dynamic DNS)

**Purpose:** Your subdomain for remote access (yoshikeikohomelab.duckdns.org)

1. **Go to:** https://www.duckdns.org/

2. **Sign in with Google:**
   - Click: "Sign in with Google"
   - Authorize DuckDNS
   - You're now logged in

3. **Create Subdomain:**
   ```
   Subdomain: yoshikeikohomelab
   (Results in: yoshikeikohomelab.duckdns.org)
   
   Click: Add domain
   ```

4. **Note Your Token:**
   ```
   Token appears at top of page (long string)
   COPY THIS IMMEDIATELY!
   ```

5. **Save to 1Password:**
   ```
   1Password → HomeLab Vault → New Login
   
   Title: DuckDNS - yoshikeikohomelab
   Website: https://www.duckdns.org/
   Username: (GitHub account)
   Password: (not applicable - uses GitHub OAuth)
   
   Add Custom Field:
   - Token: [paste your token here]
   - Subdomain: yoshikeikohomelab.duckdns.org
   
   Notes: Dynamic DNS for remote access
          Free tier, updates via API
   
   Tags: dns, networking, homelab
   
   Click: Save
   ```

6. **Verify:**
   - [x] Token saved in 1Password
   - [x] Subdomain created (yoshikeikohomelab.duckdns.org)
   - [x] Can access DuckDNS dashboard

**✅ CHECKPOINT:** DuckDNS configured with subdomain

---

### 3️⃣ Tailscale Account (VPN)

**Purpose:** Secure VPN access to homelab from anywhere

1. **Go to:** https://tailscale.com/

2. **Sign Up with GitHub:**
   - Click: "Get started"
   - Click: "Sign up with Google"
   - itstevesmithit@gmail.com
   - Account created!

3. **Download Installers:**
   ```
   For M4 Mac Mini:
   - Download: Tailscale for macOS (Apple Silicon)
   - Save to: ~/Desktop/HomeLab-Project/Installers/
   
   For Samsung S25 Ultra:
   - Already installed from Guide 00 prep
   
   For MacBook Air:
   - Download: Tailscale for macOS
   ```


4. **Save to 1Password:**
   ```
   1Password → HomeLab Vault → New Login
   
   Title: Tailscale VPN Account
   Website: https://login.tailscale.com/
   Username: (GitHub account)
   Password: (not applicable - uses GitHub OAuth)
   
   Add Custom Fields:
   - Tailnet Name: [your-tailnet].ts.net
   - Admin Console: https://login.tailscale.com/admin/machines
   
   Notes: VPN for secure remote access
          Free tier: 100 devices
          Connected devices:
          - M4 Mac Mini (192.168.50.10)
          - Samsung S25 Ultra
          - MacBook Air
          - iPad Pro
   
   Tags: vpn, security, networking
   
   Click: Save
   ```

5. **Verify:**
   - [x] Tailscale account created
   - [x] Installers downloaded
   - [x] Credentials in 1Password

**✅ CHECKPOINT:** Tailscale account ready

---

### 4️⃣ Docker Hub Account

**Purpose:** Pull container images for 62+ services

1. **Go to:** https://hub.docker.com/

2. **Sign Up:**
   ```
   Email: itstevesmithIT@gmail.com
   Username: stevesmithit (or similar)
   Password: [create strong password]
   
   Click: Sign Up
   ```

3. **Verify Email:**
   - Check outlook.com inbox
   - Click verification link
   - Account activated

4. **Save to 1Password:**
   ```
   1Password → HomeLab Vault → New Login
   
   Title: Docker Hub
   Website: https://hub.docker.com/
   Username: stevesmithit
   Password: [your password]
   Email: itstevesmithIT@gmail.com
   
   Notes: Container registry for Docker images
          Free tier: unlimited public pulls
          Used for all homelab services
   
   Tags: docker, containers, homelab
   
   Click: Save
   ```

5. **Verify:**
   - [x] Account created and verified
   - [x] Can log in to Docker Hub
   - [x] Credentials in 1Password

**✅ CHECKPOINT:** Docker Hub account ready

---

### 5️⃣ Proxmox Account (Optional but Recommended)

**Purpose:** Access Proxmox forums and documentation

1. **Go to:** https://www.proxmox.com/

2. **Create Account:**
   ```
   Click: Forum or Login
   Email: itstevesmithIT@gmail.com
   Username: stevesmithit
   Password: [create strong password]
   
   Register
   ```

3. **Save to 1Password:**
   ```
   1Password → HomeLab Vault → New Login
   
   Title: Proxmox Forum Account
   Website: https://forum.proxmox.com/
   Username: stevesmithit
   Password: [your password]
   Email: itstevesmithIT@gmail.com
   
   Notes: Proxmox community forum access
          For support and updates
   
   Tags: proxmox, virtualization, support
   
   Click: Save
   ```

**✅ CHECKPOINT:** Proxmox account ready

---

### 6️⃣ Plex Account

**Purpose:** Media server management and remote access

1. **Go to:** https://www.plex.tv/

2. **Sign Up:**
   ```
   Option 1: Use Google (itstevesmithIT@gmail.com)
   Option 2: Use email directly
   
   Create account
   ```

3. **Get Plex Pass (Optional but Recommended):**
   ```
   Lifetime: £119
   Benefits:
   - Hardware transcoding
   - Mobile sync
   - Premium music features
   - Early access features
   
   Or monthly: £4.99
   ```

4. **Save to 1Password:**
   ```
   1Password → HomeLab Vault → New Login
   
   Title: Plex Media Server
   Website: https://www.plex.tv/
   Username/Email: itstevesmithIT@gmail.com
   Password: [if using email login]
   
   Add Custom Fields:
   - Plex Pass: Yes/No
   - Claim Token: (will get this during setup)
   
   Notes: Media server account
          Connected to M4 Mac Mini server
          Access: app.plex.tv
   
   Tags: media, streaming, homelab
   
   Click: Save
   ```

5. **Verify:**
   - [x] Plex account created
   - [ ] Can access plex.tv
   - [x] Credentials in 1Password

**✅ CHECKPOINT:** Plex account ready

---

### 7️⃣ Home Assistant Account (Cloud Optional)

**Purpose:** Smart home management

1. **Go to:** https://www.home-assistant.io/

2. **Create Nabu Casa Account (Optional):**
   ```
   Cloud access: £6.50/month
   Benefits:
   - Remote access without VPN
   - Alexa/Google Assistant integration
   - Support Home Assistant development
   
   OR use Tailscale for free remote access
   ```

3. **Note:** Home Assistant account created during setup, but save placeholder:
   ```
   1Password → HomeLab Vault → New Login
   
   Title: Home Assistant
   Website: http://192.168.50.10:8123
   Username: (will create during setup)
   Password: (will create during setup)
   
   Add Custom Fields:
   - Local URL: http://192.168.50.10:8123
   - Tailscale URL: http://100.x.x.x:8123
   - DuckDNS URL: https://ha.yoshikeikohomelab.duckdns.org
   
   Notes: Smart home automation platform
          43+ devices integrated:
          - 10 Sonos speakers
          - 5 Nest cameras
          - Tesla Model Y
          - Cupra Born EV
          - Easee charger
          - LG TV
          - Xbox/PS5
   
   Tags: smarthome, automation, homelab
   
   Click: Save
   ```

**✅ CHECKPOINT:** Home Assistant placeholder created

---

### 8️⃣ Cloudflare Account (Optional - Advanced)

**Purpose:** DNS management, tunnel alternative to DuckDNS

1. **Go to:** https://www.cloudflare.com/

2. **Sign Up:**
   ```
   Email: itstevesmithIT@gmail.com
   Password: [create strong password]
   
   Sign Up
   ```

3. **Add Domain (if you buy one):**
   ```
   Could purchase: smithhomelab.com or similar
   Free alternative: Use DuckDNS (already set up)
   ```

4. **Save to 1Password:**
   ```
   1Password → HomeLab Vault → New Login
   
   Title: Cloudflare DNS
   Website: https://dash.cloudflare.com/
   Username: itstevesmithIT@gmail.com
   Password: [your password]
   
   Add Custom Fields:
   - API Token: (create later if needed)
   - Domain: (if registered)
   
   Notes: Optional DNS management
          Alternative to DuckDNS for custom domain
          Free tier available
   
   Tags: dns, networking, optional
   
   Click: Save
   ```

**✅ CHECKPOINT:** Cloudflare account ready (optional)

---

### 9️⃣ Ntfy.sh Account (Push Notifications)

**Purpose:** Receive alerts from your homelab

1. **Go to:** https://ntfy.sh/

2. **Create Topic:**
   ```
   No account needed for basic use!
   Just pick a unique topic name:
   
   Topic: yoshikeikohomelab-alerts-x7k9m2
   (Add random chars to make unique)
   
   URL: https://ntfy.sh/yoshikeikohomelab-alerts
   ```

3. **Install App on Phone:**
   ```
   Samsung S25 Ultra:
   - Install: Ntfy app from Play Store
   - Subscribe to: yoshikeikohomelab-alerts
   - Allow notifications
   ```

4. **Save to 1Password:**
   ```
   1Password → HomeLab Vault → Secure Note
   
   Title: Ntfy Notifications
   
   Content:
   Topic: yoshikeikohomelab-alerts-x7k9m2
   URL: https://ntfy.sh/yoshikeikohomelab-alerts
   
   Send notification:
   curl -d "Message text" ntfy.sh/yoshikeikohomelab-alerts-x7k9m2
   
   Installed on:
   - Samsung S25 Ultra
   - MacBook Air
   
   Notes: Free push notification service
          Used for homelab alerts:
          - Backup completion
          - Service failures
          - System updates
          - Security alerts
   
   Tags: notifications, monitoring, homelab
   
   Click: Save
   ```

5. **Test Notification:**
   ```bash
   # From any terminal:
   curl -d "Test from setup" ntfy.sh/yoshikeikohomelab-alerts
   
   # Should receive notification on phone!
   ```

6. **Verify:**
   - [x] Topic name chosen and unique
   - [x] App installed on phone
   - [x] Test notification received
   - [x] Info saved in 1Password

**✅ CHECKPOINT:** Notifications working

---

### 🔟 Action1 RMM Account

**Purpose:** Remote management and patch management

1. **Go to:** https://www.action1.com/

2. **Sign Up:**
   ```
   Email: itstevesmithIT@gmail.com
   Company: Personal HomeLab
   
   Sign Up (Free tier available)
   ```

3. **Verify Email**

4. **Save to 1Password:**
   ```
   1Password → HomeLab Vault → New Login
   
   Title: Action1 RMM
   Website: https://app.action1.com/
   Username: itstevesmithIT@gmail.com
   Password: [your password]
   
   Notes: Remote monitoring and management
          Free tier: up to 100 endpoints
          Will install agent on:
          - M4 Mac Mini (host)
          - Windows 11 VM
          - Ubuntu Server VM
   
   Tags: rmm, management, monitoring
   
   Click: Save
   ```

**✅ CHECKPOINT:** Action1 account ready

---

## 📥 Software Download Checklist

**Create folder structure first:**

```bash
# On MacBook Air (before M4 arrives):
mkdir -p ~/Desktop/HomeLab-Project/Installers
mkdir -p ~/Desktop/HomeLab-Project/ISOs
mkdir -p ~/Desktop/HomeLab-Project/Documentation
```

### Essential Downloads (Get These Now):

#### For M4 Mac Mini:
- [x] **Tailscale** 
  - URL: https://tailscale.com/download/mac
  - File: Tailscale-*.pkg
  - Save to: ~/Desktop/HomeLab-Project/Installers/

- [x] **OrbStack** (Docker)
  - URL: https://orbstack.dev/download
  - File: OrbStack.dmg
  - Save to: ~/Desktop/HomeLab-Project/Installers/

- [x] **1Password** (if not installed)
  - URL: https://1password.com/downloads/mac/
  - File: 1Password-*.pkg
  - Save to: ~/Desktop/HomeLab-Project/Installers/

- [ ] **Homebrew** (will install via command)
  - URL: https://brew.sh/
  - Installation script (run during setup)

#### VM Operating Systems (ISOs):

- [x] **Proxmox VE ARM64**
  - URL: https://www.proxmox.com/en/downloads
  - File: proxmox-ve-*-arm64.iso (~1GB)
  - Save to: ~/Desktop/HomeLab-Project/ISOs/

- [x] **Ubuntu Server 24.04 ARM64**
  - URL: https://ubuntu.com/download/server/arm
  - File: ubuntu-24.04-live-server-arm64.iso (~2GB)
  - Save to: ~/Desktop/HomeLab-Project/ISOs/

- [x] **Windows 11 ARM64 Insider Preview**
  - URL: https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewARM64
  - Requires: Windows Insider account
  - File: Windows11_InsiderPreview_*.vhdx (~10GB)
  - Save to: ~/Desktop/HomeLab-Project/ISOs/

- [x] **Kali Linux ARM64**
  - URL: https://www.kali.org/get-kali/#kali-installer-images
  - File: kali-linux-2024.*-installer-arm64.iso (~4GB)
  - Save to: ~/Desktop/HomeLab-Project/ISOs/

- [x] **macOS Sequoia** (optional)
  - Create from: /Applications/Install macOS Sequoia.app
  - Will create during setup
  - Size: ~13GB

#### Optional but Recommended:

- [x] **Visual Studio Code**
  - URL: https://code.visualstudio.com/
  - File: VSCode-darwin-arm64.zip
  - Save to: ~/Desktop/HomeLab-Project/Installers/

- [x] **iTerm2** (Better terminal)
  - URL: https://iterm2.com/
  - File: iTerm2-*.zip
  - Save to: ~/Desktop/HomeLab-Project/Installers/

### Download Verification Checklist:

After downloading, verify:
- [x] All files in correct folders
- [x] No corrupted downloads (check file sizes)
- [x] ISOs can be mounted/verified
- [ ] Total space used: ~30-40GB

**✅ CHECKPOINT:** All software downloaded

---

## 📱 Mobile App Installation

**Install on Samsung S25 Ultra now (before M4 arrives):**

### Essential Apps:
- [x] **1Password** - Password manager
- [x] **Tailscale** - VPN access
- [x] **Ntfy** - Notifications
- [x] **Home Assistant** - Smart home control
- [x] **Plex** - Media streaming
- [x] **Immich** (later) - Photo backup

### Optional but Useful:
- [ ] **RustDesk** - Self-hosted remote desktop (works on Android!)
- [ ] **Apache Guacamole** - Web-based remote gateway
- [ ] **JuiceSSH** or **Termius** - SSH client
- [ ] **Grafana** (web app) - Monitoring

**✅ CHECKPOINT:** Apps installed on phone

---

## 🔐 Security Setup

### Enable 2FA Where Possible:

Use Microsoft Authenticator or Google Authenticator:

- [ ] 1Password (REQUIRED - protects everything!)
- [ ] GitHub account
- [ ] Microsoft account
- [ ] Plex account
- [ ] Cloudflare (if used)
- [ ] Action1 RMM

**Add to each service in 1Password:**
```
Edit login → Add One-Time Password
Scan QR code or enter secret
Save
```

**✅ CHECKPOINT:** 2FA enabled on critical accounts

---

## 📋 1Password Vault Organization

**Create these categories in HomeLab vault:**

```
HomeLab Vault Structure:
├─ Accounts (website logins)
│  ├─ DuckDNS
│  ├─ Tailscale
│  ├─ Docker Hub
│  ├─ Plex
│  └─ etc.
├─ Servers (server credentials)
│  ├─ M4 Mac Mini
│  ├─ Proxmox
│  ├─ Ubuntu Server VM
│  ├─ Windows 11 VM
│  └─ Kali Linux VM
├─ Services (homelab services)
│  ├─ Home Assistant
│  ├─ Nginx Proxy Manager
│  ├─ Portainer
│  └─ etc.
├─ API Keys (tokens and secrets)
│  ├─ DuckDNS Token
│  ├─ Plex Claim Token
│  └─ etc.
└─ Secure Notes (other info)
   ├─ Network Configuration
   ├─ IP Address List
   └─ Backup Procedures
```

**✅ CHECKPOINT:** 1Password organized

---

## 📝 Documentation Template

**Create these documents in 1Password Secure Notes:**

### 1. Network Configuration Note:
```
1Password → HomeLab Vault → New Secure Note

Title: Network Configuration

Content:
Router: 192.168.50.1
  - Admin: admin
  - Password: [router password]
  - CityFibre 5Gbps/5Gbps

Network: 192.168.50.0/24
Gateway: 192.168.50.1
DNS: 192.168.50.1, 1.1.1.1

Reserved IPs:
- 192.168.50.1   = Sky Router
- 192.168.50.10  = M4 Mac Mini
- 192.168.50.50  = Proxmox Host
- 192.168.50.51  = Ubuntu Server VM
- 192.168.50.52  = Windows 11 VM
- 192.168.50.53  = Kali Linux VM
- 192.168.50.54  = macOS VM (optional)

10GbE Switch: TP-Link SX1008
Ports used:
- Port 1: M4 Mac Mini
- Port 2: Router uplink

WiFi SSID: [your wifi name]
WiFi Password: [wifi password]

Tags: network, configuration, homelab

Click: Save
```

### 2. Service URLs Note:
```
1Password → HomeLab Vault → New Secure Note

Title: Service URLs - Quick Reference

Content:
Local Access (192.168.50.x):
- Proxmox: https://192.168.50.50:8006
- Home Assistant: http://192.168.50.10:8123
- Plex: http://192.168.50.10:32400/web
- Portainer: https://192.168.50.10:9443
- Nginx Proxy Manager: http://192.168.50.10:81
- Grafana: http://192.168.50.10:3001

Remote Access (DuckDNS):
- Home: https://home.yoshikeikohomelab.duckdns.org
- Plex: https://plex.yoshikeikohomelab.duckdns.org
- HA: https://ha.yoshikeikohomelab.duckdns.org

Tailscale IPs (update after setup):
- M4 Mac Mini: 100.x.x.x
- Samsung S25: 100.x.x.x
- MacBook Air: 100.x.x.x

Tags: urls, access, quick-reference

Click: Save
```

### 3. Backup Information Note:
```
1Password → HomeLab Vault → New Secure Note

Title: Backup Strategy

Content:
Primary Backup: Kopia → pCloud
- Schedule: Daily 3 AM
- Retention: 30 days daily, 12 weeks weekly
- Encryption: AES-256 (password below)
- pCloud: 7TB lifetime account

Kopia Encryption Password: [create strong password]
(This encrypts backups before upload)

GitHub: homelab-configs
- Repository: private
- All configs backed up
- SSH key: stored in 1Password

What's Backed Up:
✅ Docker configs & compose files
✅ Scripts & automation
✅ Documentation & logs
✅ Photos (Immich)
✅ Important camera clips
✅ Database exports

NOT Backed Up (by design):
❌ Media files (replaceable)
❌ Downloads folder
❌ VM disk images
❌ Old camera footage (>30 days)

Disaster Recovery:
1. New hardware
2. Install macOS
3. Restore from pCloud using Kopia
4. Run restore script
5. Time: 2-3 hours

Tags: backup, disaster-recovery, critical

Click: Save
```

**✅ CHECKPOINT:** Documentation templates created

---

## 🎯 Prerequisites Complete Checklist

Before proceeding to Guide 01, verify:

### Accounts Created:
- [x] 1Password HomeLab vault set up
- [x] DuckDNS account + subdomain (yoshikeikohomelab.duckdns.org)
- [x] Tailscale account created
- [x] Docker Hub account created
- [x] Proxmox account created (optional)
- [x] Plex account created
- [ ] Home Assistant placeholder created
- [x] Cloudflare account created (optional)
- [x] Ntfy topic created and tested
- [ ] Action1 RMM account created

### Security Configured:
- [x] 2FA enabled on critical accounts
- [x] All passwords strong and unique
- [x] Everything documented in 1Password
- [x] 1Password syncing across devices

### Software Downloaded:
- [x] Tailscale installer (.pkg)
- [ ] OrbStack (.dmg)
- [x] Proxmox ISO (~1GB)
- [x] Ubuntu Server ISO (~2GB)
- [x] Windows 11 VHDX (~10GB)
- [x] Kali Linux ISO (~4GB)
- [ ] Total: ~30-40GB downloaded

### Mobile Apps:
- [x] 1Password installed on phone
- [x] Tailscale installed on phone
- [x] Ntfy installed and subscribed
- [x] Plex app installed
- [x] Home Assistant app installed

### Documentation:
- [ ] Network configuration documented
- [ ] Service URLs template created
- [ ] Backup strategy documented
- [ ] 1Password vault organized

### Ready to Proceed:
- [x] M4 Mac Mini ready to unbox
- [x] External 4TB SSD ready
- [x] Network cables ready
- [x] Monitor, keyboard, mouse ready
- [x] All downloads transferred to USB if needed

**✅ GUIDE 00 COMPLETE!** 

---



---

#homelab #foundation #setup #accounts
