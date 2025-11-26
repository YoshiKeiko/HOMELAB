---
title: Day 05 BONUS: Remote Access - RustDesk + Guacamole
tags: [homelab, remote-access, rustdesk, guacamole]
created: 2025-11-13
updated: 2025-11-13
type: homelab-guide
---

# Day 05 BONUS: Remote Access - RustDesk + Guacamole

**⏱️ Time:** 60-90 minutes  
**☕ Coffee:** 3 cups  
**🎯 Difficulty:** Intermediate  
**📅 When:** After Docker infrastructure deployed (Volume 03 complete)

> *"I picked the wrong week to quit remote desktop!"* ☕

---

## 📋 What You're Building

**Problem:** Need reliable remote access to your Mac Mini from anywhere  
**Solution:** Self-hosted alternatives (better privacy than cloud solutions!)

**You'll deploy:**
- RustDesk server (your own relay server - works everywhere!)
- Apache Guacamole (web-based gateway - any browser, any device)
- Complete privacy (no cloud dependencies)
- Access M4 + future VMs from anywhere

---

## ✅ Prerequisites

**Before Starting:**
- [ ] Docker infrastructure deployed (Volume 03 complete)
- [ ] All 30 containers running successfully
- [ ] OrbStack working properly
- [ ] Router admin access (for port forwarding)
- [ ] DuckDNS configured and updating

**Required Information:**
- Your DuckDNS domain: `stevehomelab.duckdns.org`
- Your static IP: `192.168.50.10`
- Router admin credentials (check 1Password or router label)

---

# Part 1: Deploy RustDesk Server

## Step 1: Create RustDesk Compose File

```bash
cd ~/HomeLab/Docker/Compose

cat > rustdesk.yml << 'EOF'
services:
  # RustDesk ID Server
  rustdesk-hbbs:
    image: rustdesk/rustdesk-server:latest
    container_name: rustdesk-hbbs
    command: hbbs -r stevehomelab.duckdns.org:21117
    ports:
      - "21115:21115"
      - "21116:21116"
      - "21116:21116/udp"
      - "21118:21118"
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/rustdesk:/root
    restart: unless-stopped
    environment:
      - TZ=Europe/London

  # RustDesk Relay Server
  rustdesk-hbbr:
    image: rustdesk/rustdesk-server:latest
    container_name: rustdesk-hbbr
    command: hbbr
    ports:
      - "21117:21117"
      - "21119:21119"
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/rustdesk:/root
    restart: unless-stopped
    environment:
      - TZ=Europe/London
EOF
```

## Step 2: Deploy RustDesk

```bash
# Create data directory
mkdir -p ~/HomeLab/Docker/Data/rustdesk

# Deploy containers
docker compose -f rustdesk.yml up -d

# Wait for startup
sleep 5

# Verify both containers running
docker ps | grep rustdesk
```

**Expected output:**
```
rustdesk-hbbs   Up X seconds   0.0.0.0:21115-21116->...
rustdesk-hbbr   Up X seconds   0.0.0.0:21117->...
```

## Step 3: Get Public Key (CRITICAL - DON'T SKIP!)

```bash
# Extract the public key - you NEED this!
docker exec rustdesk-hbbs cat /root/id_ed25519.pub
```

**Example output:**
```
xK8VRUb0oP/xxxxxxxxxxxxxxxxxxxxxxx=
```

**⚠️ COPY THIS KEY IMMEDIATELY!**

## Step 4: Save to 1Password

**Create new item in 1Password:**
```
Title: RustDesk Server
Type: Server
Website: stevehomelab.duckdns.org
Username: N/A
Password: N/A

Notes:
Public Key: [paste the key from above]
ID Server: stevehomelab.duckdns.org
Relay Server: stevehomelab.duckdns.org
Ports: 21115-21119

IMPORTANT: All clients need this public key to connect!
```

## Step 5: Check Logs (Verify Working)

```bash
# Check ID server
docker logs rustdesk-hbbs

# Check relay server
docker logs rustdesk-hbbr

# Should see startup messages, no errors
```

✅ **CHECKPOINT:** RustDesk server running, public key saved to 1Password

---

# Part 2: Deploy Apache Guacamole

## Step 1: Create Guacamole Compose File

```bash
cd ~/HomeLab/Docker/Compose

cat > guacamole.yml << 'EOF'
services:
  # Guacamole Database
  guacamole-db:
    image: postgres:15-alpine
    container_name: guacamole-db
    restart: unless-stopped
    environment:
      - POSTGRES_DB=guacamole_db
      - POSTGRES_USER=guacamole_user
      - POSTGRES_PASSWORD=CHANGEME_SECURE_PASSWORD
      - PGDATA=/var/lib/postgresql/data/guacamole
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/guacamole/postgresql:/var/lib/postgresql/data

  # Guacamole Daemon
  guacd:
    image: guacamole/guacd:latest
    container_name: guacd
    restart: unless-stopped
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/guacamole/drive:/drive
      - /Users/homelab/HomeLab/Docker/Data/guacamole/record:/record

  # Guacamole Web Interface
  guacamole:
    image: guacamole/guacamole:latest
    container_name: guacamole
    restart: unless-stopped
    ports:
      - "8090:8080"
    environment:
      - GUACD_HOSTNAME=guacd
      - POSTGRES_HOSTNAME=guacamole-db
      - POSTGRES_DATABASE=guacamole_db
      - POSTGRES_USER=guacamole_user
      - POSTGRES_PASSWORD=CHANGEME_SECURE_PASSWORD
      - GUACAMOLE_HOME=/etc/guacamole
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/guacamole/config:/etc/guacamole
    depends_on:
      - guacd
      - guacamole-db
EOF
```

## Step 2: Generate Secure Password

```bash
# Generate a strong random password
GUAC_PASSWORD=$(openssl rand -base64 32)
echo "Generated password: $GUAC_PASSWORD"

# COPY THIS PASSWORD - you'll need it!
```

## Step 3: Update Compose File with Password

```bash
# Replace the placeholder with your actual password
# Edit the file
nano ~/HomeLab/Docker/Compose/guacamole.yml

# Find BOTH instances of: CHANGEME_SECURE_PASSWORD
# Replace with the password you generated above
# Save: Ctrl+O, Enter, Ctrl+X
```

**Or do it automatically:**
```bash
# Replace with your generated password (paste it after the =)
sed -i '' "s/CHANGEME_SECURE_PASSWORD/$GUAC_PASSWORD/g" ~/HomeLab/Docker/Compose/guacamole.yml
```

## Step 4: Create Directories

```bash
mkdir -p ~/HomeLab/Docker/Data/guacamole/{postgresql,config,drive,record}
```

## Step 5: Initialize Database

```bash
# Generate database initialization script
docker run --rm guacamole/guacamole:latest \
  /opt/guacamole/bin/initdb.sh --postgres > ~/initdb.sql

# Check the file was created
ls -lh ~/initdb.sql
```

## Step 6: Deploy Guacamole Stack

```bash
cd ~/HomeLab/Docker/Compose

# Start all three containers
docker compose -f guacamole.yml up -d

# Wait for containers to start
echo "Waiting 30 seconds for database initialization..."
sleep 30

# Check all three are running
docker ps | grep guacamole
```

**Expected output:**
```
guacamole-db    Up X seconds   5432/tcp
guacd           Up X seconds   4822/tcp
guacamole       Up X seconds   0.0.0.0:8090->8080/tcp
```

## Step 7: Initialize Database Schema

```bash
# Load the schema into the database
docker exec -i guacamole-db psql -U guacamole_user -d guacamole_db < ~/initdb.sql

# Clean up init file
rm ~/initdb.sql
```

## Step 8: Verify Guacamole is Running

```bash
# Check logs for errors
docker logs guacamole-db | tail -20
docker logs guacd | tail -20
docker logs guacamole | tail -20

# Test web interface
curl -I http://localhost:8090/guacamole
```

## Step 9: Access Guacamole Web Interface

**Open in browser:**
```
http://localhost:8090/guacamole
```

**Default Credentials (TEMPORARY):**
```
Username: guacadmin
Password: guacadmin
```

## Step 10: Change Default Password IMMEDIATELY

1. **Login** with `guacadmin` / `guacadmin`
2. Click **guacadmin** (top right) → **Settings**
3. Click **Users** tab
4. Click **guacadmin**
5. Scroll to **Change Password**
6. Enter **new password** (16+ characters, use a strong one!)
7. Click **Save**

## Step 11: Save Credentials to 1Password

```
Title: Guacamole Web Gateway
Type: Login
Website: http://localhost:8090/guacamole
Username: guacadmin
Password: [your new password]

Notes:
Database Password: [the password you generated in Step 2]
Network URL: http://192.168.50.10:8090/guacamole
Via Tailscale: http://[tailscale-ip]:8090/guacamole

Access: Web-based remote desktop gateway
        Works in any browser on any device
```

✅ **CHECKPOINT:** Guacamole running, password changed, credentials saved

---

# Part 3: Configure Router Port Forwarding

**Note:** This enables RustDesk to work from outside your home network.

## Step 1: Find Your Router Login

**Default Sky Router:**
```
URL: http://192.168.50.1
Username: admin
Password: [Check router label or Sky account]
```

If you can't access 192.168.50.1, your router might be at a different IP. Check:
```bash
# Find your gateway
netstat -nr | grep default
```

## Step 2: Login to Router

1. Open browser to your router IP
2. Enter admin credentials
3. Navigate to **Port Forwarding** section
   - May be called: "Virtual Servers", "NAT", "Port Mapping", etc.

## Step 3: Add Port Forwarding Rules

**Add these 6 rules exactly as shown:**

### Rule 1: RustDesk ID Server
```
Service Name: RustDesk-ID
External Port: 21115
Internal Port: 21115
Protocol: TCP
Internal IP: 192.168.50.10
Status: Enabled
```

### Rule 2: RustDesk NAT Type (TCP)
```
Service Name: RustDesk-NAT-TCP
External Port: 21116
Internal Port: 21116
Protocol: TCP
Internal IP: 192.168.50.10
Status: Enabled
```

### Rule 3: RustDesk NAT Type (UDP)
```
Service Name: RustDesk-NAT-UDP
External Port: 21116
Internal Port: 21116
Protocol: UDP
Internal IP: 192.168.50.10
Status: Enabled
```

### Rule 4: RustDesk Relay
```
Service Name: RustDesk-Relay
External Port: 21117
Internal Port: 21117
Protocol: TCP
Internal IP: 192.168.50.10
Status: Enabled
```

### Rule 5: RustDesk Web Client
```
Service Name: RustDesk-Web
External Port: 21118
Internal Port: 21118
Protocol: TCP
Internal IP: 192.168.50.10
Status: Enabled
```

### Rule 6: RustDesk WebSocket
```
Service Name: RustDesk-WS
External Port: 21119
Internal Port: 21119
Protocol: TCP
Internal IP: 192.168.50.10
Status: Enabled
```

## Step 4: Save and Apply

Click **Save** or **Apply** button. Some routers require a reboot.

## Step 5: Test Port Forwarding

**Method 1: Online Port Checker**
1. Go to: https://www.yougetsignal.com/tools/open-ports/
2. Enter your public IP (google "what is my ip")
3. Test port: 21115
4. Should show: **Open**

**Method 2: From Mobile Data**
```bash
# On your phone (using mobile data, NOT WiFi):
# Install a port scanner app or use online tool
# Test: [your-public-ip]:21115
```

**If ports show as closed:**
- Check router firewall settings
- Verify rules are enabled
- Restart router
- Check ISP doesn't block ports

✅ **CHECKPOINT:** All 6 ports forwarded and verified

---

# Part 4: Setup RustDesk on Mac Mini (Host)

## Step 1: Install RustDesk

```bash
brew install --cask rustdesk
```

## Step 2: Launch RustDesk

```bash
open -a RustDesk
```

**Or:** Open from Applications folder

## Step 3: Configure RustDesk

1. Click the **menu icon** (three dots or hamburger menu)
2. Select **Settings** or **ID/Relay Server**
3. Configure:

```
ID Server: stevehomelab.duckdns.org

Relay Server: stevehomelab.duckdns.org

API Server: (leave empty)

Key: [paste your public key from Part 1, Step 3]
```

4. Click **OK** or **Apply**

## Step 4: Note Your RustDesk ID

The main RustDesk window shows your **ID** (like: 123456789)

**This is your Mac Mini's ID - save it to 1Password:**
```
Title: M4 Mac Mini RustDesk ID
Type: Login
Username: homelab
Password: [will set in Step 5]

Notes:
RustDesk ID: [your ID number]
Device: M4 Mac Mini
Location: 192.168.50.10
```

## Step 5: Set a Permanent Password

1. In RustDesk main window
2. Click **Set permanent password** or similar option
3. Enter a strong password (16+ characters)
4. **Save this password to 1Password!**

## Step 6: Verify Configuration

```bash
# RustDesk should show:
# - Your ID number
# - "Ready" or "Online" status
# - Server configured (green indicator)
```

✅ **CHECKPOINT:** RustDesk installed on Mac, ID saved, password set

---

# Part 5: Setup RustDesk on Android

## Step 1: Download RustDesk

**Official Method (Recommended):**
1. Open browser on phone
2. Go to: https://github.com/rustdesk/rustdesk/releases
3. Download latest Android APK file
4. May need to enable "Install from Unknown Sources"

**Alternative - F-Droid:**
1. Install F-Droid app store
2. Search: "RustDesk"
3. Install

**Alternative - Google Play:**
- May be available on Google Play Store
- Search: "RustDesk"

## Step 2: Install the App

1. Open downloaded APK
2. Android may warn about unknown source
3. **Settings** → **Install Unknown Apps** → Allow for your browser
4. Install RustDesk

## Step 3: Configure RustDesk on Android

1. **Open RustDesk app**
2. Tap **menu** (≡ or ⋮) → **Settings**
3. Tap **Network** or **ID/Relay Server**
4. Configure:

```
ID Server: stevehomelab.duckdns.org

Relay Server: stevehomelab.duckdns.org

API Server: (leave empty)

Key: [paste your public key - get it from 1Password]
```

5. Tap **OK**
6. **Close app completely** (swipe away from recents)
7. **Reopen app**

## Step 4: Test Connection

**From Home WiFi:**
1. Enter your Mac Mini's RustDesk ID
2. Tap **Connect**
3. Enter the permanent password you set
4. Should see Mac desktop!

**From Mobile Data (External):**
1. Turn OFF WiFi (use mobile data only)
2. Open RustDesk
3. Enter Mac Mini's ID
4. Tap Connect
5. Enter password
6. Should connect via your relay server!

✅ **CHECKPOINT:** Android app working, can connect to Mac from anywhere

---

# Part 6: Configure Guacamole Connections

## Connection 1: M4 Mac Mini (VNC)

### Enable Screen Sharing on Mac:

```bash
# On your Mac Mini:
# Open System Settings
# Go to: General → Sharing
# Toggle ON: Screen Sharing
# Click (i) info button
# Set VNC password (16+ characters)
# Allow access for: All users or specific users
```

**Save VNC password to 1Password immediately!**

### Add Connection in Guacamole:

1. **Login to Guacamole:** http://localhost:8090/guacamole
2. Click **Settings** (top right) → **Connections**
3. Click **New Connection**
4. Fill in:

```
Edit Connection

Name: M4 Mac Mini (VNC)
Location: ROOT
Protocol: VNC

Parameters:

Network:
  Hostname: localhost
  Port: 5900
  
Authentication:
  Password: [your VNC password]
  
Display:
  Color depth: True color (32-bit)
  Cursor: Remote
  
Advanced:
  Read-only: (unchecked)
  
Click Save
```

### Test the Connection:

1. Return to **Home**
2. Click **M4 Mac Mini (VNC)**
3. Should see your Mac desktop in browser!

**Troubleshooting:**
- If connection fails, check Screen Sharing is enabled
- Try hostname: `192.168.50.10` instead of `localhost`
- Check firewall isn't blocking VNC

## Connection 2: Example SSH Connection

**For future use when you have Ubuntu VM:**

```
Settings → Connections → New Connection

Name: Ubuntu Server (SSH)
Protocol: SSH

Parameters:
Network:
  Hostname: 192.168.50.51
  Port: 22
  
Authentication:
  Username: homelab
  Password: [Ubuntu password]
  
Terminal:
  Color scheme: Gray on black
  Font size: 12
  
Click Save
```

## Connection 3: Example RDP Connection

**For future use when you have Windows VM:**

```
Settings → Connections → New Connection

Name: Windows 11 VM (RDP)
Protocol: RDP

Parameters:
Network:
  Hostname: 192.168.50.52
  Port: 3389
  
Authentication:
  Username: homelab
  Password: [Windows password]
  Domain: (leave empty)
  
Display:
  Color depth: True color (32-bit)
  Resolution: 1920x1080
  
Click Save
```

✅ **CHECKPOINT:** Guacamole connections configured and working

---

# Part 7: Test All Remote Access Methods

## Test 1: Local Access (Home Network)

### RustDesk from Mac to Mac:
```bash
# On Mac Mini, open RustDesk
# Enter your own ID (connects to yourself)
# Should work locally
```

### RustDesk from Android to Mac:
1. Connect to home WiFi
2. Open RustDesk on phone
3. Enter Mac ID
4. Connect
5. Should see Mac desktop

### Guacamole in Browser:
1. Open: http://localhost:8090/guacamole
2. Login
3. Click M4 connection
4. Should see Mac desktop in browser

## Test 2: Remote Access (External Network)

### RustDesk from Mobile Data:
1. **Turn OFF WiFi** on phone
2. Use **mobile data** only
3. Open RustDesk
4. Enter Mac ID
5. Connect
6. Should work via your relay server!

### Guacamole via DuckDNS:
**Note:** Requires Nginx Proxy Manager configuration

1. In NPM, create proxy host:
```
Domain: guacamole.stevehomelab.duckdns.org
Forward to: localhost:8090
SSL Certificate: Your DuckDNS certificate
```

2. Then access from anywhere:
```
https://guacamole.stevehomelab.duckdns.org
```

## Test 3: Performance Check

**Things to test:**
- [ ] Mouse movement is smooth
- [ ] Keyboard input works correctly
- [ ] Screen updates are reasonably fast
- [ ] Copy/paste works (Guacamole)
- [ ] Sound works (if enabled)

**Performance Tips:**
- Lower resolution for slower connections
- RustDesk: Adjust quality settings in-session
- Guacamole: Use 16-bit color for better speed

✅ **CHECKPOINT:** All remote access methods tested and working

---

# Troubleshooting Guide

## RustDesk Issues

### "Connection Failed" or "Timeout"

**Check servers are running:**
```bash
docker ps | grep rustdesk
```

**Check logs:**
```bash
docker logs rustdesk-hbbs
docker logs rustdesk-hbbr
```

**Verify public key:**
```bash
# Get key from server
docker exec rustdesk-hbbs cat /root/id_ed25519.pub

# Compare with key in client settings
```

**Restart containers:**
```bash
cd ~/HomeLab/Docker/Compose
docker compose -f rustdesk.yml restart
```

### "Invalid Server Configuration"

- Double-check server addresses (no http://, no trailing /)
- Should be: `stevehomelab.duckdns.org`
- Verify DuckDNS is updating: `nslookup stevehomelab.duckdns.org`

### Can't Connect from Mobile Data

**Check port forwarding:**
- Use online port checker: https://www.yougetsignal.com/tools/open-ports/
- Test port 21115
- Must show as "Open"

**Check firewall:**
- Router firewall might be blocking
- ISP might block certain ports

**Alternative:**
- Use Tailscale instead
- Connect to Tailscale on phone
- Use Mac's Tailscale IP in RustDesk

## Guacamole Issues

### Web Interface Won't Load

**Check all containers:**
```bash
docker ps | grep guacamole

# Should show 3 containers: guacamole-db, guacd, guacamole
```

**Check logs:**
```bash
docker logs guacamole-db | tail -30
docker logs guacd | tail -30
docker logs guacamole | tail -30
```

**Common issue - Database not initialized:**
```bash
# Re-run initialization
docker run --rm guacamole/guacamole:latest \
  /opt/guacamole/bin/initdb.sh --postgres > ~/initdb.sql

docker exec -i guacamole-db psql -U guacamole_user -d guacamole_db < ~/initdb.sql

rm ~/initdb.sql

# Restart Guacamole
docker restart guacamole
```

### "Invalid Login" After Changing Password

- Try original credentials: guacadmin / guacadmin
- If that works, change password again more carefully
- If that doesn't work, reinitialize database (will lose settings)

### VNC Connection to Mac Fails

**Check Screen Sharing enabled:**
```bash
# System Settings → General → Sharing
# Screen Sharing must be ON
```

**Test VNC locally:**
```bash
nc -zv localhost 5900
# Should show: succeeded
```

**Try different hostname:**
- In Guacamole connection, try:
  - `localhost`
  - `127.0.0.1`
  - `192.168.50.10`

**Check firewall:**
```bash
# System Settings → Network → Firewall
# If enabled, allow Screen Sharing
```

### Black Screen or No Display

- Check color depth setting (try different options)
- Verify cursor setting (Remote vs Local)
- Try disabling hardware acceleration in browser
- Clear browser cache

## Port Forwarding Issues

### Ports Show as Closed

**Verify rules are saved:**
- Log back into router
- Check all 6 rules are present and enabled

**Check router firewall:**
- Some routers have separate firewall settings
- Make sure ports aren't blocked

**Test from correct location:**
- Must test from OUTSIDE your network
- Use mobile data, not home WiFi
- Or use online port checker

**ISP may block ports:**
- Some ISPs block common ports
- Try using different ports (requires changing everywhere)
- Or use Tailscale VPN instead

### Router Won't Save Settings

- Try different browser
- Clear browser cache
- Update router firmware
- Reboot router after making changes

## Performance Issues

### Slow Connection

**Reduce quality:**
- RustDesk: In-session settings → Lower quality
- Guacamole: Connection settings → 16-bit color

**Check bandwidth:**
```bash
# Run speed test
# You need decent upload speed (5+ Mbps recommended)
```

**Check server load:**
```bash
docker stats
# Make sure Mac isn't overloaded
```

### Laggy Mouse/Keyboard

- Close other applications on Mac
- Reduce screen resolution
- Use wired ethernet instead of WiFi (on Mac)
- Check for OrbStack CPU usage

---

# Security Considerations

## Best Practices

### Change Default Passwords
- [x] Guacamole admin password
- [ ] Add 2FA to Guacamole (via Authelia later)
- [ ] Use strong RustDesk passwords (16+ characters)

### Limit Exposure
- Only forward necessary ports
- Use Nginx Proxy Manager for Guacamole (not direct port)
- Consider using Tailscale instead of port forwarding
- Enable Fail2ban to block brute force attempts

### Monitor Access
- Check Guacamole connection history
- Review RustDesk logs periodically
- Set up Uptime Kuma alerts

### Backup Configuration
```bash
# Backup RustDesk keys
cp ~/HomeLab/Docker/Data/rustdesk/id_ed25519* ~/HomeLab/Backups/

# Backup Guacamole database
docker exec guacamole-db pg_dump -U guacamole_user guacamole_db > ~/HomeLab/Backups/guacamole-backup.sql
```

---

# What You've Achieved

## Remote Access Solutions Deployed:

### RustDesk (Native Application)
- ✅ Self-hosted relay server
- ✅ Works on Mac, Windows, Linux, Android, iOS
- ✅ Complete privacy (no cloud dependency)
- ✅ Fast direct connections
- ✅ Works from anywhere (via your relay)
- ✅ Free forever!

### Guacamole (Web-Based)
- ✅ Access from any browser
- ✅ No app installation needed
- ✅ Supports VNC, RDP, SSH, Telnet
- ✅ Multi-protocol gateway
- ✅ Session recording capable
- ✅ Works on any device with a browser

## Benefits:
- **Complete privacy** - Self-hosted, your data never leaves your network
- **No subscriptions** - Unlike TeamViewer, AnyDesk, etc.
- **Better performance** - Direct connections when on same network
- **Multiple protocols** - VNC for Mac, RDP for Windows, SSH for Linux
- **Access anywhere** - Via mobile data, any WiFi, any device
- **Future-proof** - Will work with all VMs you deploy (Proxmox)

---

# Next Steps

## Immediate Tasks:
- [ ] Test RustDesk from different locations
- [ ] Test Guacamole from different devices
- [ ] Add monitoring to Uptime Kuma
- [ ] Document your RustDesk ID and passwords

## When You Deploy VMs (Volume 04):
- [ ] Add Windows VM RDP connection to Guacamole
- [ ] Add Ubuntu VM SSH connection to Guacamole
- [ ] Install RustDesk on Windows VM
- [ ] Test remote access to VMs

## Security Hardening:
- [ ] Set up Nginx Proxy Manager for Guacamole
- [ ] Add SSL certificate for external access
- [ ] Configure Fail2ban for Guacamole
- [ ] Consider adding Authelia 2FA

## Optional Enhancements:
- [ ] Configure Guacamole session recording
- [ ] Set up Guacamole connection groups
- [ ] Create Guacamole user accounts for others
- [ ] Add more connections as you deploy services

---

## 🎉 BONUS GUIDE COMPLETE!

**You can now:**
- ✅ Remote into M4 Mac Mini from anywhere
- ✅ Use Android app on your phone
- ✅ Access via any web browser (no app needed)
- ✅ Connect securely with complete privacy
- ✅ Ready to add VMs when you deploy Proxmox!

**Access URLs:**
- **Guacamole:** http://localhost:8090/guacamole
- **RustDesk Server:** Running on ports 21115-21119
- **Mac RustDesk ID:** [Check app or 1Password]

*"I am serious about remote access. And don't call me Shirley."* ☕😎

---

#homelab #remote-access #rustdesk #guacamole #corrected
