#!/bin/bash

################################################################################
# Network-Wide AdGuard Setup + M4 High Availability Guide
################################################################################

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Network-Wide AdGuard + High Availability Setup"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Get current network info
MAC_IP=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
GATEWAY=$(netstat -nr | grep default | grep -v ":" | awk '{print $2}' | head -1)

echo -e "${CYAN}Current Setup:${NC}"
echo "  Mac IP:      ${YELLOW}${MAC_IP}${NC}"
echo "  Gateway:     ${YELLOW}${GATEWAY}${NC}"
echo ""

cat > "$HOME/HomeLab/docs/NETWORK_WIDE_ADGUARD_HA.md" << 'EOF'
# 🌐 Network-Wide AdGuard + High Availability Setup

## 📋 Current Network Info

- **Mac IP:** MAC_IP_PLACEHOLDER
- **Gateway (Deco):** GATEWAY_PLACEHOLDER

---

# Part 1: Network-Wide AdGuard (All Devices Protected)

## 🎯 Overview

**What we're doing:**
- Configure Deco router to use your Mac as DNS
- ALL devices automatically protected (phones, tablets, laptops, TVs, IoT)
- No per-device configuration needed
- Ads blocked on entire network

**Benefit:** Set once, protect everything forever!

---

## 📱 Method 1: Via Deco App (Easiest)

### Step 1: Open Deco App

1. Open **Deco app** on phone
2. Make sure you're connected to Deco network
3. Sign in

### Step 2: Configure DHCP/DNS Settings

1. Tap **"More"** (bottom right)
2. Tap **"Advanced"**
3. Tap **"DHCP Server"**

### Step 3: Set DNS Servers

You'll see DNS settings:

**Primary DNS:** Enter `MAC_IP_PLACEHOLDER`  
**Secondary DNS:** Enter `GATEWAY_PLACEHOLDER` or `1.1.1.1`

**Why this order?**
- Primary: Your Mac (AdGuard blocks ads)
- Secondary: Fallback if Mac is off/rebooting

### Step 4: Save and Reboot

1. Tap **"Save"**
2. You may need to reboot Deco (app will prompt)
3. Wait 2 minutes for Deco to restart

### Step 5: Test on Any Device

**On iPhone/Android:**
- Open Safari/Chrome
- Visit: http://ads-blocker.com/testing/
- Should say "All tests passed!" (ads blocked)

**Check AdGuard Dashboard:**
- Open: http://MAC_IP_PLACEHOLDER:8084
- Go to Query Log
- Use any device to browse
- See queries from ALL devices!

---

## 🌐 Method 2: Via Deco Web Interface (Alternative)

If you can't use the app:

1. Open browser
2. Go to: http://GATEWAY_PLACEHOLDER
3. Login with TP-Link ID
4. Navigate to Advanced → DHCP
5. Set Primary DNS: `MAC_IP_PLACEHOLDER`
6. Set Secondary DNS: `GATEWAY_PLACEHOLDER`
7. Save and reboot

---

## 🧪 Verification

### Test 1: Check Device DNS

**On any device connected to Wi-Fi:**

**Mac:**
```bash
networksetup -getdnsservers "Wi-Fi"
# Should show: MAC_IP_PLACEHOLDER
```

**iPhone:**
Settings → Wi-Fi → (i) → DNS → Should show MAC_IP_PLACEHOLDER

**Windows:**
```cmd
ipconfig /all
# Look for DNS Servers: MAC_IP_PLACEHOLDER
```

### Test 2: Ad Blocking Working

**Visit ad-heavy sites:**
- speedtest.net
- yahoo.com
- news sites

**Check AdGuard dashboard:**
- http://MAC_IP_PLACEHOLDER:8084
- Query Log should show blocked requests
- Dashboard should show % blocked (10-30% typical)

### Test 3: All Devices Protected

**Open AdGuard Query Log:**
- See queries from: iPhones, iPads, TVs, laptops
- Each device has its own IP
- All going through AdGuard!

---

## ⚠️ What Happens When Mac is Off?

**Problem:** If Mac turns off, no DNS = no internet!

**Current Setup:**
- Primary DNS: MAC_IP_PLACEHOLDER (your Mac - AdGuard)
- Secondary DNS: GATEWAY_PLACEHOLDER or 1.1.1.1 (fallback)

**When Mac is off:**
- Devices try Primary DNS (Mac) - fails
- Devices switch to Secondary DNS (Deco/Cloudflare)
- Internet works, but NO ad blocking
- 5-10 second delay when switching

**This leads to Part 2...** ⬇️

---

# Part 2: High Availability - Keep Your Homelab Running 24/7

## 🎯 The Challenge

Your homelab runs on M4 Mac. If Mac goes down (power cut, crash, restart), services stop:
- ❌ No AdGuard (no internet if Primary DNS fails)
- ❌ No Home Assistant (smart home stops)
- ❌ No Plex (no media streaming)
- ❌ No AI chat
- ❌ No monitoring

**Goal:** Make your homelab survive power cuts and restarts!

---

## 🔋 Strategy 1: Uninterruptible Power Supply (UPS)

**BEST solution for power cuts!**

### Recommended UPS for M4 Mac

**Budget Option (~£100-150):**
- APC Back-UPS 600VA (BX600MI)
- CyberPower Value 600VA
- **Runtime:** 15-30 minutes
- **Enough for:** Short power cuts, graceful shutdown

**Better Option (~£200-300):**
- APC Back-UPS Pro 900VA (BR900MI)
- CyberPower PFC Sinewave 1000VA
- **Runtime:** 30-60 minutes
- **Enough for:** Most power cuts, keep running

**Premium Option (~£400-600):**
- APC Smart-UPS 1500VA (SMT1500RMI2U)
- CyberPower OR1500ELCDRM1U
- **Runtime:** 1-2 hours
- **Enough for:** Extended outages, true high availability

### What to Plug Into UPS

**Critical (must have):**
- ✅ M4 Mac
- ✅ Primary Deco unit
- ✅ Internet modem/ONT (fiber box)
- ✅ External SSD (4TB drive)

**Nice to have:**
- Other Deco units (for mesh coverage)
- Network switch (if you have one)

**DON'T plug in:**
- ❌ Monitors
- ❌ Printers
- ❌ Desk lamps
- ❌ Anything non-critical

### UPS Setup

1. **Connect UPS:**
   - Plug UPS into wall
   - Plug Mac into UPS "battery backup" outlets
   - Plug Deco into UPS
   - Plug modem into UPS

2. **Configure Mac for UPS:**
   ```bash
   # Install APC PowerChute or CyberPower PowerPanel
   # Download from manufacturer website
   ```

3. **Set UPS Actions:**
   - When battery reaches 20%: Shut down Mac gracefully
   - Send notification to phone
   - Save all work

4. **Test:**
   - Unplug UPS from wall
   - Mac should stay on
   - Check how long battery lasts
   - Mac should shut down gracefully at 20%

### Expected Runtime

**M4 Mac Mini power draw:** ~20-40W (very efficient!)

**With 600VA UPS:**
- M4 + Deco + Modem = ~60W total
- **Runtime:** 15-30 minutes

**With 1500VA UPS:**
- Same load
- **Runtime:** 1-2 hours

**Why M4 Mac is Perfect for Homelab:**
- Low power consumption = longer UPS runtime
- Apple Silicon is VERY efficient
- Can run for hours on modest UPS

---

## 🔄 Strategy 2: Auto-Start After Power Loss

**Ensure Mac comes back online automatically after power cut**

### Configure Mac to Auto-Start

1. **Open Terminal:**
   ```bash
   sudo pmset autorestart 1
   ```

2. **Verify:**
   ```bash
   pmset -g
   # Look for: autorestart 1
   ```

3. **Additional Power Settings:**
   ```bash
   # Start on power connection
   sudo pmset powerbutton 0
   
   # Restart automatically on power loss
   sudo pmset restoredefaults
   sudo pmset autorestart 1
   
   # Restart on freeze
   sudo systemsetup -setrestartfreeze on
   
   # Wake on network access
   sudo systemsetup -setwakeonnetworkaccess on
   ```

### Set Energy Saver Settings

**Via System Settings:**
1. System Settings → Energy Saver (or Battery)
2. **Uncheck** "Put hard disks to sleep when possible"
3. **Check** "Start up automatically after a power failure"
4. **Check** "Wake for network access"

**Via Command Line:**
```bash
# Never sleep
sudo pmset -a sleep 0
sudo pmset -a disksleep 0
sudo pmset -a displaysleep 10

# Wake on network
sudo pmset -a womp 1

# Auto restart on power loss
sudo pmset -a autorestart 1
```

### Test Auto-Restart

1. **Simulate power loss:**
   ```bash
   sudo shutdown -h now
   ```

2. **Wait for Mac to fully power off**

3. **"Restore power"** - press power button once

4. **Mac should boot automatically** without pressing power button again

---

## 🐳 Strategy 3: Docker Auto-Restart Policies

**Ensure all services start automatically when Mac boots**

### Check Current Restart Policies

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.RestartPolicy}}'
```

**Should all show:** `unless-stopped` or `always`

### Fix Services Without Auto-Restart

**For individual container:**
```bash
docker update --restart unless-stopped CONTAINER_NAME
```

**Fix all containers at once:**
```bash
for container in $(docker ps -aq); do
  docker update --restart unless-stopped $container
done
```

### Verify All Set

```bash
docker ps --format 'table {{.Names}}\t{{.RestartPolicy}}'
# All should show: unless-stopped
```

**Restart policies explained:**
- `no` - Never restart (BAD for homelab)
- `always` - Always restart, even if manually stopped
- `unless-stopped` - Restart unless you manually stopped it (BEST)
- `on-failure` - Only restart if container crashes

---

## 📊 Strategy 4: Monitoring & Alerts

**Know immediately if something goes wrong!**

### Setup Uptime Kuma Alerts

1. **Open Uptime Kuma:** http://localhost:3004

2. **Add Monitors for Critical Services:**
   - Home Assistant (http://localhost:8123)
   - Plex (http://localhost:32400)
   - AdGuard (http://localhost:8084)
   - Your Mac (ping monitor)

3. **Configure Notifications:**
   - Settings → Notifications
   - Add notification method:
     - **Discord** (free webhook)
     - **Telegram** (free bot)
     - **Email** (via Gmail SMTP)
     - **Pushover** (phone push - £5 one-time)

4. **Test Alerts:**
   - Stop a container: `docker stop plex`
   - Should get alert within 60 seconds
   - Restart: `docker start plex`
   - Should get "back online" alert

### Recommended Alert Setup

**Critical (immediate alerts):**
- Internet connection down
- Mac offline
- AdGuard down
- Home Assistant down

**Important (5 min delay):**
- Plex down
- Database down
- Monitoring down

**Low priority (15 min delay):**
- Individual utility services

---

## 🔐 Strategy 5: Automated Backups

**Your data must survive disasters!**

### Configure Duplicati for Auto-Backup

1. **Open Duplicati:** http://localhost:8200

2. **Create Backup Job:**
   - Click "Add backup"
   - Name: "Homelab Critical Data"

3. **Select Destination:**
   - **Option 1:** External USB drive
   - **Option 2:** Backblaze B2 (cloud - £5/TB/month)
   - **Option 3:** Google Drive (free 15GB)

4. **Select Source Folders:**
   ```
   /Users/homelab/HomeLab/Docker/Data/
   ```

   **Critical folders:**
   - `vaultwarden/` (passwords!)
   - `homeassistant/` (smart home config)
   - `nextcloud/` (your files)
   - `photoprism/` (photos)
   - `paperless/` (documents)
   - `grafana/` (dashboards)

5. **Set Schedule:**
   - Daily at 3 AM
   - Keep last 30 versions

6. **Enable Encryption:**
   - Set strong password
   - **SAVE THIS PASSWORD** - can't recover without it!

7. **Test Restore:**
   - Run backup once
   - Try restoring a test file
   - Verify it works!

### Backup External SSD

Your 4TB SSD has all media and data!

**Option 1: Duplicate to Second Drive**
- Buy second 4TB external SSD
- Use Carbon Copy Cloner or SuperDuper
- Clone weekly

**Option 2: Cloud Backup**
- Use Backblaze Personal Backup (£7/month unlimited)
- Backs up all external drives automatically
- Slower but automatic

**Option 3: NAS Backup**
- Synology/QNAP NAS
- Sync homelab data to NAS
- NAS can also run services (redundancy!)

---

## 🌍 Strategy 6: Redundant DNS

**Make sure internet works even if Mac is down**

### Problem

Current setup:
- Primary DNS: MAC_IP_PLACEHOLDER (AdGuard on Mac)
- Secondary DNS: GATEWAY_PLACEHOLDER (fallback)

**If Mac is off:**
- Devices try Mac DNS → fails → wait → try fallback
- 5-10 second delay
- No ad blocking

### Solution 1: Second AdGuard Instance (Advanced)

**Run AdGuard on another device:**

**Raspberry Pi Option:**
- Buy Raspberry Pi 4 (£50)
- Install Pi-hole or AdGuard Home
- Set as Secondary DNS
- Both block ads!

**Old Laptop Option:**
- Use old laptop/desktop
- Install Docker + AdGuard
- Set as Secondary DNS

**Deco Setup:**
- Primary DNS: MAC_IP_PLACEHOLDER (Mac - AdGuard)
- Secondary DNS: 192.168.68.x (Pi/Laptop - AdGuard)
- Both block ads, automatic failover!

### Solution 2: Graceful Degradation (Simple)

**Accept temporary loss of ad blocking:**

**Deco DNS Setup:**
- Primary: MAC_IP_PLACEHOLDER (Mac - AdGuard when running)
- Secondary: 1.1.1.1 (Cloudflare - always works)

**Result:**
- Mac running = Ad blocking ✅
- Mac down = No ad blocking, but internet works ✅
- Acceptable for home use!

### Solution 3: Cloud-Based Filtering (Backup)

**Use cloud DNS when Mac is down:**

**NextDNS (Free tier - 300k queries/month):**
1. Sign up: https://nextdns.io
2. Configure ad blocking
3. Get custom DNS: `abc123.dns.nextdns.io`
4. Deco Secondary DNS: abc123.dns.nextdns.io

**Result:**
- Mac up = Local AdGuard (fast, private)
- Mac down = Cloud AdGuard (works, less private)

---

## 🎯 Complete High Availability Setup

**Recommended Configuration:**

### Hardware
- ✅ UPS (APC Back-UPS Pro 900VA minimum)
- ✅ M4 Mac plugged into UPS
- ✅ Primary Deco plugged into UPS
- ✅ Modem/ONT plugged into UPS
- ✅ External SSD on UPS

### Mac Configuration
- ✅ Auto-restart on power: `sudo pmset autorestart 1`
- ✅ Never sleep: `sudo pmset -a sleep 0`
- ✅ Wake on network: `sudo pmset -a womp 1`
- ✅ All services restart policy: `unless-stopped`

### Network Configuration
- ✅ Mac has reserved IP: MAC_IP_PLACEHOLDER
- ✅ Deco Primary DNS: MAC_IP_PLACEHOLDER
- ✅ Deco Secondary DNS: 1.1.1.1 (or Pi-hole if you set one up)

### Backups
- ✅ Duplicati daily backup to cloud/external
- ✅ Critical folders backed up
- ✅ Tested restore process
- ✅ External SSD cloned weekly (optional but recommended)

### Monitoring
- ✅ Uptime Kuma monitoring all services
- ✅ Phone alerts configured
- ✅ Tested alert delivery

---

## 📋 Testing Your High Availability Setup

### Test 1: Simulated Power Cut

**With UPS connected:**

1. Unplug UPS from wall
2. Mac should stay on ✅
3. Internet should work ✅
4. Check runtime (should be 15-60 min depending on UPS)
5. Mac should auto-shutdown at 20% battery
6. Plug UPS back in
7. Mac should auto-boot ✅
8. All services should auto-start ✅

### Test 2: Hard Shutdown

**Without UPS (simulate Mac crash):**

1. Hard shutdown: Hold power button 10 seconds
2. Release, press power button once
3. Mac should boot automatically ✅
4. Wait 3-5 minutes for all services to start
5. Check all services: `docker ps`
6. Test critical services:
   - AdGuard: http://localhost:8084
   - Home Assistant: http://localhost:8123
   - Plex: http://localhost:32400

### Test 3: Network Resilience

**Test DNS failover:**

1. Stop Mac completely
2. Try browsing on phone
3. Should work after 5-10 seconds (using Secondary DNS) ✅
4. No ad blocking (expected)
5. Start Mac
6. Ad blocking resumes ✅

### Test 4: Service Recovery

**Test individual service failure:**

1. Stop critical service: `docker stop homeassistant`
2. Wait for Uptime Kuma alert ✅
3. Restart Mac: `sudo reboot`
4. After boot, check service: `docker ps | grep homeassistant`
5. Should be running ✅

### Test 5: Backup Recovery

**Test disaster recovery:**

1. Stop Vaultwarden: `docker stop vaultwarden`
2. Delete data: `rm -rf ~/HomeLab/Docker/Data/vaultwarden/*`
3. Restore from Duplicati
4. Start Vaultwarden: `docker start vaultwarden`
5. Login should work with restored passwords ✅

---

## 🚨 Emergency Procedures

### Mac Won't Boot After Power Cut

**Symptoms:** Black screen, no response

**Try:**
1. Unplug everything (including UPS)
2. Wait 60 seconds
3. Plug power only
4. Press power button
5. If still dead, try SMC reset:
   - Unplug power
   - Wait 15 seconds
   - Plug power back
   - Wait 5 seconds
   - Press power button

### Services Not Starting After Reboot

**Check Docker:**
```bash
docker ps -a
# Shows all containers, even stopped ones
```

**Restart stuck services:**
```bash
docker restart portainer homeassistant plex grafana
```

**Nuclear option (restart all):**
```bash
docker restart $(docker ps -aq)
```

### Internet Not Working

**Quick diagnosis:**
```bash
# Can you reach gateway?
ping GATEWAY_PLACEHOLDER

# Can you reach internet?
ping 8.8.8.8

# Is DNS working?
nslookup google.com
```

**Fix:**
```bash
# Reset DNS to safe values
sudo networksetup -setdnsservers "Wi-Fi" 1.1.1.1 8.8.8.8

# Test internet
ping google.com

# Once working, set back to AdGuard
sudo networksetup -setdnsservers "Wi-Fi" MAC_IP_PLACEHOLDER GATEWAY_PLACEHOLDER
```

---

## 💰 Cost Breakdown

### Minimum Setup (Good)
- **UPS:** £100-150 (APC BX600MI)
- **Backups:** £0 (use Google Drive free tier)
- **Total:** ~£100

**Gets you:**
- Survives short power cuts
- Auto-restart after power loss
- Basic backup protection

### Recommended Setup (Better)
- **UPS:** £200-300 (APC BR900MI)
- **Backups:** £7/month (Backblaze Personal)
- **Monitoring:** £5 one-time (Pushover)
- **Total:** ~£215 + £7/month

**Gets you:**
- Survives most power cuts (30-60 min)
- Cloud backup (unlimited)
- Phone alerts
- Good reliability

### Premium Setup (Best)
- **UPS:** £400-600 (APC SMT1500)
- **Secondary Pi-hole:** £50 (Raspberry Pi 4)
- **Backup NAS:** £300 (Synology DS220+)
- **Cloud Backup:** £7/month (Backblaze)
- **Total:** ~£750-950 + £7/month

**Gets you:**
- Survives extended outages (1-2 hours)
- Redundant ad blocking (Pi-hole backup)
- Local + cloud backup
- Enterprise-grade reliability

---

## ✅ Final Checklist

### Network-Wide AdGuard
- [ ] Deco Primary DNS set to MAC_IP_PLACEHOLDER
- [ ] Deco Secondary DNS set (1.1.1.1 or Pi-hole)
- [ ] Tested on multiple devices
- [ ] AdGuard Query Log shows all devices

### High Availability
- [ ] UPS purchased and installed
- [ ] M4 Mac on UPS
- [ ] Deco on UPS
- [ ] Modem on UPS
- [ ] Tested runtime (unplugged UPS)

### Auto-Recovery
- [ ] Auto-restart enabled: `pmset -g | grep autorestart`
- [ ] Never sleep: `pmset -g | grep sleep`
- [ ] All containers restart policy: `unless-stopped`
- [ ] Tested power-off/power-on cycle

### Monitoring
- [ ] Uptime Kuma installed and configured
- [ ] Critical services monitored
- [ ] Alerts configured (phone notifications)
- [ ] Tested alert delivery

### Backups
- [ ] Duplicati configured
- [ ] Daily backup scheduled
- [ ] Critical folders included
- [ ] Encryption enabled
- [ ] Tested restore

### Tested Scenarios
- [ ] Power cut simulation (unplugged UPS)
- [ ] Hard shutdown and recovery
- [ ] DNS failover (Mac off)
- [ ] Service auto-restart after reboot
- [ ] Backup restore

---

## 🎓 Summary

**You now have:**

1. **Network-Wide Protection**
   - All devices (phones, tablets, computers, TVs) block ads
   - Configured once in Deco router
   - Works automatically for everyone

2. **Power Protection**
   - UPS keeps Mac running during power cuts
   - Graceful shutdown prevents data corruption
   - Auto-restart brings everything back online

3. **Service Reliability**
   - All services restart automatically
   - Monitoring alerts you to problems
   - Internet works even if Mac is down (fallback DNS)

4. **Data Safety**
   - Daily automated backups
   - Can recover from disasters
   - Multiple backup destinations

**Your homelab is now enterprise-grade! 🎉**

---

**Next Steps:**
1. Order UPS (today!)
2. Configure network DNS (5 minutes)
3. Set up power settings (5 minutes)
4. Configure backups (30 minutes)
5. Test everything (1 hour)

**You're building something awesome! 🚀**

EOF

# Replace placeholders
sed -i '' "s/MAC_IP_PLACEHOLDER/${MAC_IP}/g" "$HOME/HomeLab/docs/NETWORK_WIDE_ADGUARD_HA.md"
sed -i '' "s/GATEWAY_PLACEHOLDER/${GATEWAY}/g" "$HOME/HomeLab/docs/NETWORK_WIDE_ADGUARD_HA.md"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Complete Guide Created!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "View complete guide:"
echo "  ${CYAN}open ~/HomeLab/docs/NETWORK_WIDE_ADGUARD_HA.md${NC}"
echo ""
echo -e "${YELLOW}Quick Start - Network-Wide AdGuard:${NC}"
echo ""
echo "1. Open Deco app"
echo "2. More → Advanced → DHCP Server"
echo "3. Set DNS:"
echo "   Primary: ${CYAN}${MAC_IP}${NC}"
echo "   Secondary: ${CYAN}${GATEWAY}${NC} or ${CYAN}1.1.1.1${NC}"
echo "4. Save and reboot"
echo "5. Test on any device!"
echo ""
echo -e "${YELLOW}Quick Start - High Availability:${NC}"
echo ""
echo "1. Order UPS (${CYAN}APC Back-UPS Pro 900VA${NC} recommended)"
echo "2. Enable auto-restart:"
echo "   ${CYAN}sudo pmset autorestart 1${NC}"
echo "3. Disable sleep:"
echo "   ${CYAN}sudo pmset -a sleep 0${NC}"
echo "4. Check Docker restart policies:"
echo "   ${CYAN}docker ps --format 'table {{.Names}}\t{{.RestartPolicy}}'${NC}"
echo ""
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${MAGENTA}  Your homelab will survive:${NC}"
echo -e "${MAGENTA}  • Power cuts (with UPS)${NC}"
echo -e "${MAGENTA}  • Mac crashes (auto-restart)${NC}"
echo -e "${MAGENTA}  • Service failures (Docker restarts)${NC}"
echo -e "${MAGENTA}  • Data loss (automated backups)${NC}"
echo -e "${MAGENTA}  • Network issues (fallback DNS)${NC}"
echo -e "${MAGENTA}═══════════════════════════════════════════════════════════════${NC}"
echo ""