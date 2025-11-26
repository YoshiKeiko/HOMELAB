---
title: Day 05 BONUS: Remote Access - RustDesk + Guacamole
tags: [homelab, remote-access, rustdesk, guacamole]
created: 2025-11-11
type: homelab-guide
---

# Day 05 BONUS: Remote Access - RustDesk + Guacamole

**⏱️ Time:** 60-90 minutes  
**☕ Coffee:** 3 cups  
**🎯 Difficulty:** Intermediate  
**📅 When:** After Day 05 (Docker infrastructure ready)

> *"I picked the wrong week to quit remote desktop!"* ☕

---

## 📋 What You're Building

**Problem:** Microsoft killed RustDesk (Microsoft Remote Desktop no longer available on Android) on Android  
**Solution:** Self-hosted alternatives (better than MS ever was!)

**You'll deploy:**
- RustDesk server (your own relay, works on Android!)
- Apache Guacamole (web-based gateway, any browser)
- Complete privacy (no cloud dependencies)
- Access M4 + VMs from anywhere

---

## ✅ Prerequisites

**Before Starting:**
- [ ] Docker infrastructure deployed (Day 03-05)
- [ ] docker-compose-master.yml exists
- [ ] Docker Compose working
- [ ] Sky router admin access (port forwarding)

---

# Part 1: Deploy RustDesk Server

## Add to docker-compose-master.yml:

**Add these services to your existing file:**

```yaml
  # RustDesk ID Server
  rustdesk-hbbs:
    image: rustdesk/rustdesk-server:latest
    container_name: rustdesk-hbbs
    command: hbbs -r rustdesk.stevehomelab.duckdns.org:21117
    ports:
      - "21115:21115"
      - "21116:21116"
      - "21116:21116/udp"
      - "21118:21118"
    volumes:
      - ~/HomeLab/Docker/Data/rustdesk:/root
    networks:
      - homelab
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
      - ~/HomeLab/Docker/Data/rustdesk:/root
    networks:
      - homelab
    restart: unless-stopped
    environment:
      - TZ=Europe/London
    depends_on:
      - rustdesk-hbbs
```

## Deploy:

```bash
# Create data directory
mkdir -p ~/HomeLab/Docker/Data/rustdesk

# Deploy containers
cd ~/HomeLab/Docker/Compose
docker compose -f docker-compose-master.yml up -d rustdesk-hbbs rustdesk-hbbr

# Verify running
docker ps | grep rustdesk

# Should see both containers running
```

## Get Public Key (IMPORTANT):

```bash
# Extract the public key
docker exec rustdesk-hbbs cat /root/id_ed25519.pub

# Copy this key - you'll need it for every client!
# Example output: xK8VRUb0oP/xxxxxxxxxxxxxxxxxxxxxxx=
```

**Save to 1Password immediately:**
```
Title: RustDesk Server
Type: Server
URL: rustdesk.stevehomelab.duckdns.org
Username: N/A
Password: N/A
Public Key: [paste the key above]
Ports: 21115-21119
Notes: Self-hosted RustDesk relay server
       All clients need this public key
```

✅ **CHECKPOINT:** RustDesk server running, public key saved

---

# Part 2: Deploy Apache Guacamole

## Add to docker-compose-master.yml:

```yaml
  # Guacamole Database
  guacamole-db:
    image: postgres:15-alpine
    container_name: guacamole-db
    restart: unless-stopped
    environment:
      - POSTGRES_DB=guacamole_db
      - POSTGRES_USER=guacamole_user
      - POSTGRES_PASSWORD=${GUACAMOLE_DB_PASSWORD}
      - PGDATA=/var/lib/postgresql/data/guacamole
    volumes:
      - ~/HomeLab/Docker/Data/guacamole/postgresql:/var/lib/postgresql/data
    networks:
      - homelab

  # Guacamole Daemon
  guacd:
    image: guacamole/guacd:latest
    container_name: guacd
    restart: unless-stopped
    networks:
      - homelab
    volumes:
      - ~/HomeLab/Docker/Data/guacamole/drive:/drive
      - ~/HomeLab/Docker/Data/guacamole/record:/record

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
      - POSTGRES_PASSWORD=${GUACAMOLE_DB_PASSWORD}
      - GUACAMOLE_HOME=/etc/guacamole
    volumes:
      - ~/HomeLab/Docker/Data/guacamole/config:/etc/guacamole
    networks:
      - homelab
    depends_on:
      - guacd
      - guacamole-db
```

## Setup:

```bash
# Create directories
mkdir -p ~/HomeLab/Docker/Data/guacamole/{postgresql,config,drive,record}

# Generate secure database password
echo "GUACAMOLE_DB_PASSWORD=$(openssl rand -base64 32)" >> ~/.env

# Source the new variable
source ~/.env

# Initialize database schema
docker run --rm guacamole/guacamole:latest   /opt/guacamole/bin/initdb.sh --postgres > ~/initdb.sql

# Deploy stack
cd ~/HomeLab/Docker/Compose
docker compose -f docker-compose-master.yml up -d guacamole-db guacd guacamole

# Wait 30 seconds for containers to start
sleep 30

# Initialize database
docker exec -i guacamole-db psql -U guacamole_user -d guacamole_db < ~/initdb.sql

# Verify all running
docker ps | grep guacamole
```

## Access Guacamole:

```
URL: http://192.168.50.10:8090/guacamole

Default Credentials:
Username: guacadmin
Password: guacadmin

⚠️ CHANGE IMMEDIATELY AFTER FIRST LOGIN!
```

## Change Default Password:

1. Login with guacadmin/guacadmin
2. Click: guacadmin (top right) → Settings
3. Click: Users → guacadmin
4. Change password (16+ characters)
5. Save

**Save new credentials to 1Password:**
```
Title: Guacamole Web Gateway
URL: http://192.168.50.10:8090/guacamole
Username: guacadmin
Password: [your new password]
Database Password: [from ~/.env GUACAMOLE_DB_PASSWORD]
Notes: Web-based remote desktop gateway
       Access from any browser
```

✅ **CHECKPOINT:** Guacamole running, password changed, saved to 1Password

---

# Part 3: Configure Sky Router Port Forwarding

## Login to Router:

```
URL: http://192.168.50.1
Username: admin
Password: [from router or Sky account]
```

## Add Port Forwarding Rules:

**Navigate to:** Port Forwarding / Virtual Servers / NAT

**Add these 6 rules:**

```
Rule 1: RustDesk ID Server
External Port: 21115
Internal Port: 21115
Protocol: TCP
Internal IP: 192.168.50.10
Enable: YES

Rule 2: RustDesk NAT Type
External Port: 21116
Internal Port: 21116
Protocol: TCP
Internal IP: 192.168.50.10
Enable: YES

Rule 3: RustDesk NAT (UDP)
External Port: 21116
Internal Port: 21116
Protocol: UDP
Internal IP: 192.168.50.10
Enable: YES

Rule 4: RustDesk Relay
External Port: 21117
Internal Port: 21117
Protocol: TCP
Internal IP: 192.168.50.10
Enable: YES

Rule 5: RustDesk Web Client
External Port: 21118
Internal Port: 21118
Protocol: TCP
Internal IP: 192.168.50.10
Enable: YES

Rule 6: RustDesk WebSocket
External Port: 21119
Internal Port: 21119
Protocol: TCP
Internal IP: 192.168.50.10
Enable: YES
```

**Save/Apply changes**

## Test Port Forwarding:

```bash
# From external network (use phone data, not home WiFi)
# Or use online port checker: portchecker.co

# Test if port 21115 is open
# Should show: OPEN or ACCESSIBLE
```

✅ **CHECKPOINT:** All 6 ports forwarded

---

# Part 4: Setup RustDesk Android Client

## Download & Install:

1. **On Samsung S25 Ultra:**
   - Open browser
   - Go to: https://rustdesk.com/
   - Download: Android APK
   - Or: F-Droid store → Search "RustDesk"

2. **Install:**
   ```
   Settings → Security → Unknown Sources → Enable
   Downloads → RustDesk.apk → Install
   ```

## Configure Client:

1. **Open RustDesk app**

2. **Tap menu (⋮) → Settings → Network**

3. **Configure servers:**
   ```
   ID Server: rustdesk.stevehomelab.duckdns.org
   
   Relay Server: rustdesk.stevehomelab.duckdns.org
   
   API Server: (leave empty)
   
   Key: [paste your public key from Part 1]
   ```

4. **Tap OK**

5. **Restart app** (completely close and reopen)

## Setup M4 for Remote Access:

```bash
# On M4 Mac Mini
# Install RustDesk
brew install rustdesk

# Launch RustDesk
open -a RustDesk

# Configure same servers:
# Settings → Network → Same settings as Android
# ID Server: rustdesk.stevehomelab.duckdns.org
# Relay Server: rustdesk.stevehomelab.duckdns.org
# Key: [your public key]

# Note the ID shown (e.g., 123456789)
# Save to 1Password!
```

## Test Connection:

1. **On Android:**
   - Enter M4's RustDesk ID
   - Tap Connect
   - Enter password (if prompted)
   - Should see M4 desktop!

✅ **CHECKPOINT:** Android app works, can connect to M4

---

# Part 5: Configure Guacamole Connections

## Add M4 Mac (VNC):

1. **Login to Guacamole:** http://192.168.50.10:8090/guacamole

2. **Enable Screen Sharing on M4:**
   ```bash
   # On M4
   System Settings → Sharing
   Toggle ON: Screen Sharing
   Set VNC password: [16+ characters]
   
   Save password to 1Password!
   ```

3. **In Guacamole:**
   - Settings → Connections → New Connection
   ```
   Name: M4 Mac Mini (VNC)
   Protocol: VNC
   
   Network:
   Hostname: localhost
   Port: 5900
   
   Authentication:
   Password: [VNC password]
   
   Display:
   Color depth: True color (32-bit)
   
   Save
   ```

4. **Test:** Click connection, should see M4 desktop

## Add Windows 11 VM (RDP):

**After Day 09 when Windows VM deployed:**

```
Settings → Connections → New Connection

Name: Windows 11 VM
Protocol: RDP

Network:
Hostname: 192.168.50.52
Port: 3389

Authentication:
Username: Steve
Password: [Windows password]

Save
```

## Add Ubuntu VM (SSH):

**After Day 11 when Ubuntu deployed:**

```
Settings → Connections → New Connection

Name: Ubuntu Server
Protocol: SSH

Network:
Hostname: 192.168.50.51
Port: 22

Authentication:
Username: steve
Password: [or use SSH key]

Save
```

✅ **CHECKPOINT:** Guacamole connections configured

---

# Part 6: Test Remote Access

## From Home WiFi:

**RustDesk:**
1. Open app on phone
2. Connect to M4 using ID
3. Should work instantly

**Guacamole:**
1. Browser: http://192.168.50.10:8090/guacamole
2. Login
3. Click M4 connection
4. Should see desktop

## From External Network:

**RustDesk:**
1. Disable WiFi (use mobile data)
2. Open RustDesk
3. Connect to M4 using ID
4. Should work (via your relay server!)

**Guacamole:**
- Need to setup DuckDNS first (Day 06)
- Then: https://guacamole.stevehomelab.duckdns.org

---

# Troubleshooting

## RustDesk "Connection Failed":

```bash
# Check containers running
docker ps | grep rustdesk

# Check logs
docker logs rustdesk-hbbs
docker logs rustdesk-hbbr

# Verify public key matches
docker exec rustdesk-hbbs cat /root/id_ed25519.pub

# Check ports forwarded
# Use portchecker.co to test ports 21115-21119

# Restart containers
docker restart rustdesk-hbbs rustdesk-hbbr
```

## Guacamole Won't Load:

```bash
# Check all containers
docker ps | grep guacamole

# Check database
docker logs guacamole-db

# Check daemon
docker logs guacd

# Check web
docker logs guacamole

# Restart stack
docker restart guacamole-db guacd guacamole

# Re-initialize database if needed
docker exec -i guacamole-db psql -U guacamole_user -d guacamole_db < ~/initdb.sql
```

## Can't Connect to M4 VNC:

```bash
# On M4, check Screen Sharing enabled
System Settings → Sharing → Screen Sharing: ON

# Test VNC locally
# From M4 terminal:
nc -zv localhost 5900

# Should show: succeeded

# Check firewall
# System Settings → Network → Firewall
# If enabled, allow Screen Sharing
```

---

# Verification Checklist

**RustDesk Server:**
- [ ] Both containers running
- [ ] Public key saved to 1Password
- [ ] Ports 21115-21119 forwarded
- [ ] Android app configured
- [ ] Can connect to M4

**Guacamole:**
- [ ] All 3 containers running
- [ ] Web interface accessible
- [ ] Default password changed
- [ ] M4 VNC connection working
- [ ] Credentials in 1Password

**Remote Access:**
- [ ] Works from home WiFi
- [ ] RustDesk works on mobile data
- [ ] All credentials backed up

---

# What You've Achieved

**Remote Access Solutions:**

**RustDesk (Native Apps):**
- ✅ Android compatible (unlike MS!)
- ✅ iOS compatible
- ✅ Windows/Mac/Linux apps
- ✅ Self-hosted (complete privacy)
- ✅ Works on mobile data

**Guacamole (Browser):**
- ✅ Access from any browser
- ✅ No app installation needed
- ✅ Supports RDP, VNC, SSH
- ✅ Multi-protocol gateway
- ✅ Session recording capable

**Benefits:**
- Complete privacy (self-hosted)
- Works on Android
- Access M4 + all VMs
- Better than RustDesk (self-hosted)
- Free forever!

---

## 🎉 BONUS GUIDE COMPLETE!

**You can now:**
- Remote into M4 from anywhere
- Use Android app on Samsung S25
- Access via any web browser
- Connect to VMs (once deployed)
- Maintain complete privacy!

**Next Steps:**
- Continue with Day 06 (Proxmox)
- Add more Guacamole connections as you deploy VMs
- Access your homelab from anywhere! ✅

*"I am serious about remote access. And don't call me Shirley."* ☕😎


---

#homelab #remote-access #rustdesk #guacamole
