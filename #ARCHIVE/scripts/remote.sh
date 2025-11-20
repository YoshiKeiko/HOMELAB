#!/bin/bash

cat > "$HOME/HomeLab/docs/REMOTE_ACCESS_SETUP_GUIDE.md" << 'EOFGUIDE'
# 🌐 Access Your M4 Mac Mini From Anywhere in the House

**Complete guide to remote access from MacBook Air, iPhone, iPad, and other devices**

---

## 🎯 What You Can Access

**From your MacBook Air (or any device):**
- ✅ Full Mac desktop (RustDesk)
- ✅ All Docker services (web UIs)
- ✅ Files and folders (Finder/SSH)
- ✅ Terminal/command line (SSH)
- ✅ Media streaming (Plex, Jellyfin)

---

## 📋 Quick Access Summary

### Option 1: Web Services (Easiest!)

**From any browser on your network:**
```
http://M4-IP-ADDRESS:PORT
```

**Example:**
```
Plex:           http://192.168.1.100:32400
Grafana:        http://192.168.1.100:3000
Home Assistant: http://192.168.1.100:8123
Portainer:      http://192.168.1.100:9000
```

### Option 2: Remote Desktop (Full Control)

**RustDesk** - Control the Mac like you're sitting at it
```
Already installed and running!
```

### Option 3: File Access

**SMB/Finder** - Access files like a network drive

### Option 4: Terminal Access

**SSH** - Command line access for power users

---

## 🔍 STEP 1: Find Your M4 Mac's IP Address

### A. On the M4 Mac Itself

**Method 1: Quick Command**
```bash
ipconfig getifaddr en0
```

**Method 2: System Settings**
```
System Settings → Network → [Your Connection] → Details
```

**Method 3: Terminal**
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

**You should see something like:**
```
192.168.1.100
```

**⚠️ Write this down - you need it for everything below!**

---

## 🌐 STEP 2: Access Web Services from MacBook Air

### A. Find All Your Services and Ports

**Create a quick reference list:**

```bash
# On M4 Mac, run this to see all services:
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep -v "PORTS"
```

### B. Common Services You Can Access

**Replace `192.168.1.100` with YOUR M4 IP address:**

**Media Services:**
```
Plex:           http://192.168.1.100:32400/web
Jellyfin:       http://192.168.1.100:8096
Overseerr:      http://192.168.1.100:5055
Tautulli:       http://192.168.1.100:8181
```

**Smart Home:**
```
Home Assistant: http://192.168.1.100:8123
Node-RED:       http://192.168.1.100:1880
```

**Monitoring:**
```
Grafana:        http://192.168.1.100:3000
Portainer:      http://192.168.1.100:9000
Netdata:        http://192.168.1.100:19999
Prometheus:     http://192.168.1.100:9090
```

**Management:**
```
Kopia:          http://192.168.1.100:8202
AdGuard:        http://192.168.1.100:3080
Pi-hole:        http://192.168.1.100:8180
```

**Automation:**
```
Radarr:         http://192.168.1.100:7878
Sonarr:         http://192.168.1.100:8989
Prowlarr:       http://192.168.1.100:9696
```

**Utilities:**
```
Nextcloud:      http://192.168.1.100:8080
Paperless:      http://192.168.1.100:8000
PhotoPrism:     http://192.168.1.100:2342
Vaultwarden:    http://192.168.1.100:8280
```

### C. Create Bookmarks on MacBook Air

**Safari/Chrome - Create bookmark folder:**

```
📁 HomeLab Services
   🎬 Plex → http://192.168.1.100:32400/web
   📊 Grafana → http://192.168.1.100:3000
   🏠 Home Assistant → http://192.168.1.100:8123
   ⚙️ Portainer → http://192.168.1.100:9000
   ☁️ Kopia → http://192.168.1.100:8202
   [etc...]
```

---

## 🖥️ STEP 3: Remote Desktop Access (RustDesk)

### A. RustDesk is Already Installed!

**You already have RustDesk running on M4:**
- ✅ Installed and configured
- ✅ Running in background
- ✅ Public Key: `GZHUobkG2RJmEwzNgEkN6htLZ4PlFZSwKpFDirOTn58=`

### B. Install RustDesk on MacBook Air

**Download:**
1. Go to: **https://rustdesk.com/download**
2. Download **macOS** version
3. Install RustDesk.dmg

**Or via Homebrew:**
```bash
brew install --cask rustdesk
```

### C. Connect from MacBook Air to M4

1. **Open RustDesk** on MacBook Air

2. **Get M4 RustDesk ID:**
   - On M4 Mac: Open RustDesk app
   - Find **"Your Desktop ID"**
   - Should show: 9-digit number (e.g., `123-456-789`)

3. **Connect:**
   - On MacBook Air RustDesk
   - Enter M4's RustDesk ID
   - Click **"Connect"**
   - Enter password (if set)

4. **You're in!** 
   - Full desktop access
   - Control M4 like you're there
   - See everything in real-time

### D. Permanent Password (Recommended)

**On M4 Mac:**

1. Open RustDesk
2. Click **Settings** (gear icon)
3. Go to **"Security"** tab
4. Set **"Permanent Password"**
5. Enter strong password

**Save in 1Password:**
```
Title:    M4 Mac Mini RustDesk Access
Username: [RustDesk ID: 123-456-789]
Password: [permanent password]
Notes:    Remote desktop access to M4 Mac
```

---

## 📁 STEP 4: File Access (Network Drive)

### A. Enable File Sharing on M4 Mac

**On M4 Mac:**

1. **System Settings** → **General** → **Sharing**
2. Enable **"File Sharing"** ✅
3. Click **"File Sharing"** to configure

**Shared Folders:**

Add these folders:
```
✅ /Users/homelab/HomeLab
✅ /Volumes/HomeLab-4TB
```

**Permissions:**
- Your user: Read & Write
- Everyone: No Access (or Read Only)

### B. Connect from MacBook Air

**Method 1: Finder (GUI)**

1. Open **Finder**
2. Press **Cmd + K** (Go → Connect to Server)
3. Enter:
   ```
   smb://192.168.1.100
   ```
4. Click **"Connect"**
5. Login with M4 username/password
6. Choose shared folders

**Bookmark for easy access:**
- Drag server to Finder sidebar

**Method 2: Command Line**
```bash
# Mount HomeLab folder
mkdir -p ~/M4-HomeLab
mount_smbfs //homelab@192.168.1.100/HomeLab ~/M4-HomeLab

# Mount 4TB drive
mkdir -p ~/M4-4TB
mount_smbfs //homelab@192.168.1.100/HomeLab-4TB ~/M4-4TB
```

### C. Auto-Mount on Login (MacBook Air)

**Create mount script:**

```bash
cat > ~/auto-mount-m4.sh << 'EOFMOUNT'
#!/bin/bash

# Mount M4 Mac shares
mkdir -p ~/M4-HomeLab
mkdir -p ~/M4-4TB

mount_smbfs //homelab@192.168.1.100/HomeLab ~/M4-HomeLab 2>/dev/null
mount_smbfs //homelab@192.168.1.100/HomeLab-4TB ~/M4-4TB 2>/dev/null

echo "M4 shares mounted!"
EOFMOUNT

chmod +x ~/auto-mount-m4.sh
```

**Add to Login Items:**
1. System Settings → General → Login Items
2. Click **"+"**
3. Add `auto-mount-m4.sh`

---

## 🔐 STEP 5: SSH Access (Terminal)

### A. Enable SSH on M4 Mac (If Not Already)

**On M4 Mac:**

1. **System Settings** → **General** → **Sharing**
2. Enable **"Remote Login"** ✅
3. Set access: "Only these users" → Add your user

### B. Connect from MacBook Air

**Basic connection:**
```bash
ssh homelab@192.168.1.100
```

**First time:**
- Will ask to verify fingerprint
- Type `yes`
- Enter M4 password

### C. SSH Key Setup (No Password!)

**On MacBook Air:**

```bash
# Generate SSH key if you don't have one
ssh-keygen -t ed25519 -C "macbook-air"

# Copy key to M4 Mac
ssh-copy-id homelab@192.168.1.100

# Now SSH without password!
ssh homelab@192.168.1.100
```

### D. SSH Config (Easy Shortcuts)

**On MacBook Air, create config:**

```bash
cat > ~/.ssh/config << 'EOFSSH'
Host m4
    HostName 192.168.1.100
    User homelab
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    
Host m4-root
    HostName 192.168.1.100
    User homelab
    IdentityFile ~/.ssh/id_ed25519
EOFSSH

chmod 600 ~/.ssh/config
```

**Now just type:**
```bash
ssh m4
# Connects automatically!
```

---

## 📱 STEP 6: Mobile Access (iPhone/iPad)

### A. Web Services

**Safari on iPhone/iPad:**
```
http://192.168.1.100:32400/web    (Plex)
http://192.168.1.100:8123         (Home Assistant)
http://192.168.1.100:3000         (Grafana)
```

**Add to Home Screen:**
1. Open service in Safari
2. Tap **Share** icon
3. **"Add to Home Screen"**
4. Now it's an app icon!

### B. RustDesk Mobile

**Install RustDesk app:**
- App Store → Search "RustDesk"
- Install RustDesk

**Connect:**
- Enter M4 RustDesk ID
- Enter password
- Full desktop access from phone!

### C. SSH from iPhone/iPad

**Install Termius (best SSH app):**
- App Store → "Termius"
- Free for basic use

**Setup:**
1. Add new host
2. Hostname: `192.168.1.100`
3. Username: `homelab`
4. Password: [M4 password]
5. Save

**Now SSH from your phone!**

---

## 🏠 STEP 7: Setup Dashboard (Optional)

### A. Install Homer Dashboard

**Makes accessing everything easier!**

```bash
# On M4 Mac
cat > ~/HomeLab/Docker/Compose/dashboard.yml << 'EOFDASH'
version: '3.8'

services:
  homer:
    image: b4bz/homer:latest
    container_name: homer
    restart: unless-stopped
    ports:
      - "8090:8080"
    volumes:
      - ~/HomeLab/Docker/Data/homer:/www/assets
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
EOFDASH

# Start it
docker compose -f ~/HomeLab/Docker/Compose/dashboard.yml up -d
```

**Access:** http://192.168.1.100:8090

### B. Configure Homer

**Create config:**

```bash
mkdir -p ~/HomeLab/Docker/Data/homer
cat > ~/HomeLab/Docker/Data/homer/config.yml << 'EOFHOMER'
---
title: "HomeLab Dashboard"
subtitle: "M4 Mac Mini"
logo: "logo.png"

header: true
footer: false

columns: "auto"

services:
  - name: "Media"
    icon: "fas fa-film"
    items:
      - name: "Plex"
        logo: "https://www.plex.tv/wp-content/themes/plex/assets/img/plex-logo.svg"
        subtitle: "Media Server"
        url: "http://192.168.1.100:32400/web"
        target: "_blank"
      
      - name: "Overseerr"
        subtitle: "Request Media"
        url: "http://192.168.1.100:5055"
        target: "_blank"

  - name: "Smart Home"
    icon: "fas fa-home"
    items:
      - name: "Home Assistant"
        subtitle: "Home Automation"
        url: "http://192.168.1.100:8123"
        target: "_blank"

  - name: "Monitoring"
    icon: "fas fa-chart-line"
    items:
      - name: "Grafana"
        subtitle: "Dashboards"
        url: "http://192.168.1.100:3000"
        target: "_blank"
      
      - name: "Portainer"
        subtitle: "Docker Management"
        url: "http://192.168.1.100:9000"
        target: "_blank"

  - name: "Management"
    icon: "fas fa-cog"
    items:
      - name: "Kopia"
        subtitle: "Backups"
        url: "http://192.168.1.100:8202"
        target: "_blank"
      
      - name: "AdGuard"
        subtitle: "DNS"
        url: "http://192.168.1.100:3080"
        target: "_blank"
EOFHOMER
```

**Restart Homer:**
```bash
docker restart homer
```

**Now you have one page with links to everything!**

---

## 🔒 STEP 8: Security Best Practices

### A. Use Strong Passwords

**All access points should have passwords:**
- ✅ M4 Mac user account
- ✅ RustDesk permanent password
- ✅ SSH keys (recommended over passwords)
- ✅ Each Docker service

### B. Firewall on M4 Mac

**Already enabled, but verify:**

```bash
# Check firewall status
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

# Should show: enabled
```

### C. Local Network Only

**Currently setup:**
- ✅ Only accessible on home network
- ✅ NOT exposed to internet
- ✅ Safe for now

**Later (optional):**
- Add Tailscale for secure remote access
- Add Cloudflare tunnel
- Add reverse proxy with auth

---

## 📊 STEP 9: Static IP for M4 Mac (Recommended!)

### Why Static IP?

**Problem with dynamic IP:**
- IP might change after router restart
- All your bookmarks break
- Have to find new IP each time

**Solution: Reserve IP in router**

### A. Current IP Address

```bash
# On M4 Mac
ipconfig getifaddr en0
```

Example: `192.168.1.100`

### B. Find M4 MAC Address

```bash
# On M4 Mac
ifconfig en0 | grep ether
```

Example: `12:34:56:78:9a:bc`

### C. Reserve IP in Router

**Steps vary by router, but generally:**

1. Login to router (usually `192.168.1.1`)
2. Find **"DHCP Reservations"** or **"Static IP"**
3. Add reservation:
   - MAC Address: `12:34:56:78:9a:bc`
   - IP Address: `192.168.1.100`
   - Name: `M4-Mac-Mini`
4. Save

**Now M4 will ALWAYS have same IP!**

---

## 📱 STEP 10: Create Quick Access Reference

### A. Print/Save This Chart

**On MacBook Air, create bookmark folder:**

```
📁 M4 HomeLab
   📄 All Services (see list below)
   🖥️ RustDesk → Open app, enter M4 ID
   📁 Files → smb://192.168.1.100
   💻 SSH → Terminal: ssh m4
   📊 Dashboard → http://192.168.1.100:8090
```

### B. Create Text File Reference

**On MacBook Air:**

```bash
cat > ~/M4-Access-Guide.txt << 'EOFREF'
╔═══════════════════════════════════════════════════════════════╗
║              M4 MAC MINI ACCESS GUIDE                          ║
╚═══════════════════════════════════════════════════════════════╝

M4 IP Address: 192.168.1.100

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Remote Desktop (Full Control)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RustDesk App → Enter M4 ID: [write ID here]
Password: [in 1Password]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File Access
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Finder: Cmd+K → smb://192.168.1.100

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Terminal Access
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ssh homelab@192.168.1.100
(or just: ssh m4)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Web Services
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Dashboard:      http://192.168.1.100:8090
Plex:           http://192.168.1.100:32400/web
Home Assistant: http://192.168.1.100:8123
Grafana:        http://192.168.1.100:3000
Portainer:      http://192.168.1.100:9000
Kopia:          http://192.168.1.100:8202

[Add all your other services here]

═══════════════════════════════════════════════════════════════
EOFREF

echo "Access guide saved to: ~/M4-Access-Guide.txt"
```

---

## ✅ Complete Setup Checklist

Remote Access Setup:
- [ ] Found M4 IP address
- [ ] Set static IP in router (recommended)
- [ ] Tested web service access from MacBook
- [ ] Created bookmarks for all services
- [ ] RustDesk installed on MacBook Air
- [ ] Connected via RustDesk successfully
- [ ] Set RustDesk permanent password
- [ ] Password saved in 1Password
- [ ] File sharing enabled on M4
- [ ] Mounted network drives on MacBook
- [ ] SSH enabled on M4 Mac
- [ ] SSH key setup (passwordless)
- [ ] Created SSH config shortcut
- [ ] Dashboard installed (optional)
- [ ] Access guide created
- [ ] Mobile access tested

Security:
- [ ] All passwords strong and in 1Password
- [ ] Firewall enabled on M4
- [ ] Access limited to local network only
- [ ] RustDesk permanent password set

---

## 🎉 Summary

**You can now access M4 Mac from anywhere in your house via:**

1. **Web Browser** → http://192.168.1.100:[PORT]
   - All Docker services
   - Perfect for quick checks

2. **RustDesk** → Full desktop control
   - Like you're sitting at the Mac
   - Perfect for admin tasks

3. **File Sharing** → Network drive access
   - Transfer files easily
   - Edit configs directly

4. **SSH** → Command line access
   - Power user features
   - Run scripts remotely

5. **Mobile Apps** → Access from phone/iPad
   - Control smart home
   - Watch Plex
   - Check monitoring

**Everything is accessible from your MacBook Air, iPhone, iPad, or any device on your network!** 🎯

---

## 🔮 Future Enhancements (Optional)

**When you want internet access:**
- Tailscale (secure VPN)
- Cloudflare Tunnel
- WireGuard
- Reverse proxy with authentication

**Advanced dashboards:**
- Heimdall
- Dashy
- Organizr
- Homarr

**For now, local network access is perfect and secure!**

EOFGUIDE

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Remote Access Setup Guide Created!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "View guide:"
echo "  open ~/HomeLab/docs/REMOTE_ACCESS_SETUP_GUIDE.md"
echo ""
echo "Quick start:"
echo ""
echo "1. Find M4 IP address:"
echo "   ipconfig getifaddr en0"
echo ""
echo "2. Access services from MacBook Air:"
echo "   http://M4-IP:PORT"
echo ""
echo "3. Remote desktop:"
echo "   Install RustDesk on MacBook Air"
echo "   Connect to M4 RustDesk ID"
echo ""
echo "Complete guide has all details!"
echo ""

chmod +x /mnt/user-data/outputs/create-remote-access-guide.sh