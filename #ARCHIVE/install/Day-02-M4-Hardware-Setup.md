---
title: 📚 Volume 02: M4 Mac Mini Hardware & macOS Setup (Days 1-2)
tags: [homelab, hardware, m4, network, setup]
created: 2025-11-11
type: homelab-guide
---

# 📚 Volume 02: M4 Mac Mini Hardware & macOS Setup (Days 1-2)

**Setting Up Your M4 Mac Mini for 24/7 HomeLab Operation**

> *"First, you must build the foundation. Then, you can build the tower."* 🏗️

---

## 📋 Volume Overview

**Days:** 1-2 (overlaps with Volume 01)  
**Time Required:** 4-6 hours  
**Coffee Required:** ☕☕☕☕  
**Difficulty:** Beginner to Intermediate  

### What You'll Complete

By end of Day 2, you'll have:
- ✅ M4 Mac Mini unboxed and physically set up
- ✅ macOS Sequoia installed and configured
- ✅ All 3 network adapters configured (10GbE + 5GB + 2.5GB)
- ✅ Static IP address set (192.168.50.10)
- ✅ 4TB external SSD formatted and mounted
- ✅ SSH enabled for remote access
- ✅ Essential tools installed (Homebrew, btop, etc.)
- ✅ macOS optimized for 24/7 server operation
- ✅ Automatic login configured
- ✅ System ready for Docker and Proxmox

---

## 🎯 Guides in This Volume

- [Guide 01: Hardware Unboxing & Physical Setup](#guide-01-hardware-unboxing)
- [Guide 02: macOS Initial Setup](#guide-02-macos-initial-setup)
- [Guide 03: Network Configuration (3 Adapters)](#guide-03-network-configuration)
- [Guide 04: Storage Configuration](#guide-04-storage-configuration)
- [Guide 05: SSH & Remote Access](#guide-05-ssh-remote-access)
- [Guide 06: Essential Tools Installation](#guide-06-essential-tools)
- [Guide 07: macOS Optimization for Servers](#guide-07-macos-optimization)

---

# Guide 01: Hardware Unboxing & Physical Setup

**⏱️ Time:** 30 minutes  
**☕ Coffee:** 1 cup  
**🎯 Difficulty:** Beginner  

## ✅ Prerequisites

Before unboxing, verify you have:

### From Volume 01:
- [x] All accounts created in 1Password
- [x] Software downloads completed
- [x] Mobile apps installed on Samsung S25 Ultra

### Physical Items Ready:
- [x] M4 Mac Mini (sealed box)
- [x] 4TB External SSD (Samsung T7 or similar)
- [x] TP-Link SX1008 10GbE Switch
- [x] 10GbE Ethernet cable (Cat6a or better)
- [x] 5GB USB-C Ethernet adapter
- [x] 2.5GB Ethernet adapter
- [x] Additional Ethernet cables
- [x] Monitor with HDMI/USB-C cable
- [x] Keyboard (USB or Bluetooth)
- [x] Mouse (USB or Bluetooth)
- [x] Power outlet with surge protector

---

## 📦 Unboxing M4 Mac Mini

### Step 1: Unbox Carefully

1. **Open M4 Mac Mini box:**
   ```
   - Remove outer sleeve
   - Lift top of box
   - Inside: M4 Mac Mini, power cable, documentation
   ```

2. **Inspect contents:**
   - [x] M4 Mac Mini unit (silver/space gray)
   - [x] Power cable (UK plug)
   - [x] Documentation
   - [x] Apple stickers (because why not! 😄)

3. **Check for damage:**
   - [x] No dents or scratches on chassis
   - [x] Ports look clean and undamaged
   - [x] No rattling sounds when gently shaken

### Step 2: Understand M4 Mac Mini Ports

**Front of M4 Mac Mini:**
```
┌─────────────────────────────┐
│  🔊  ○ ○                    │  
│                              │
└─────────────────────────────┘
   Speaker  USB-C  Headphone
           (USB 3)
```

**Back of M4 Mac Mini:**
```
┌─────────────────────────────────────────┐
│  ⚡ ═══ ○ ○ ○ 🌐 ◐                    │
└─────────────────────────────────────────┘
   Power    USB-C Ports    10GbE   HDMI
   Port     (Thunderbolt 5)  Port
```

**Ports breakdown:**
- **Power:** Kettle-style power inlet
- **3x Thunderbolt 5/USB-C ports** (back):
  - Support: USB 4, Thunderbolt 5, DisplayPort, charging
  - Speed: Up to 120 Gbps (Thunderbolt 5)
  - Use for: External SSD, USB-C Ethernet adapters, displays
- **2x USB-A ports** (front):
  - USB 3.1 Gen 2 (10 Gbps)
  - Use for: Keyboard, mouse, USB drives
- **1x 10 Gigabit Ethernet port** (back):
  - RJ45 connector
  - Supports: 10GbE, 5GbE, 2.5GbE, 1GbE, 100Mbps (auto-negotiates)
  - This is your PRIMARY network connection!
- **1x HDMI port** (back):
  - HDMI 2.1
  - Supports: 8K @ 60Hz or 4K @ 240Hz
  - Use for: Monitor during setup
- **1x 3.5mm headphone jack** (front):
  - High-impedance headphone support
  - We won't use this for homelab

**✅ CHECKPOINT:** Understand all ports and their purposes

---

## 🔌 Physical Setup & Cable Management

### Step 1: Choose Location

**Ideal location for 24/7 operation:**

**Requirements:**
- [x] Near router/network switch (within 2 meters for 10GbE cable)
- [x] Good ventilation (M4 needs airflow even though it's quiet)
- [x] Accessible power outlet
- [x] Desk/shelf that won't be disturbed
- [x] Away from heat sources
- [x] Reasonably dust-free area

**NOT recommended:**
- ❌ Inside closed cabinet (heat buildup)
- ❌ Under cushions/fabric (blocks vents)
- ❌ Direct sunlight
- ❌ Extremely dusty area

**Ventilation notes:**
```
M4 Mac Mini ventilation:
- Intake: Bottom (circular intake holes)
- Exhaust: Back (through port area)
- Keep 5cm clearance on all sides
- Bottom must not be blocked!
```

### Step 2: Connect External Storage

1. **Prepare 4TB External SSD:**
   ```
   Samsung T7 (or similar)
   - Connect USB-C cable to SSD
   - Will connect to M4 in a moment
   ```

2. **Choose USB-C port:**
   ```
   Best practice: Use LEFTMOST Thunderbolt port (back)
   Why: Fastest, most reliable, keeps cable tidy
   ```

**Don't connect yet - wait for macOS setup!**

### Step 3: Connect Network Adapters

**You have 3 Ethernet adapters total:**

#### Primary: Built-in 10GbE (ALWAYS USE THIS)
```
Location: Back of M4 (RJ45 port)
Speed: 10 Gbps
Connect to: TP-Link SX1008 10GbE Switch Port 1
Cable: Cat6a or Cat7 (2m or less for best performance)
Use: Main network connection for everything
```

**Connect now:**
1. **Plug Cat6a/Cat7 cable into M4's 10GbE port (back)**
2. **Other end into TP-Link switch Port 1**
3. **Verify:** Cable clicks into place, lights may blink

#### Secondary: 5GB USB-C Ethernet Adapter (OPTIONAL - For Later)
```
Speed: 5 Gbps (5000 Mbps)
Connect to: USB-C Thunderbolt port (middle or right)
Use case options:
- Failover/backup network connection
- Direct connection to second switch
- Isolated management network
- VM bridge network
```

**Don't connect yet - configure in Guide 03**

#### Tertiary: 2.5GB Ethernet Adapter (OPTIONAL - For Later)
```
Speed: 2.5 Gbps (2500 Mbps)
Connect to: USB-C Thunderbolt port or USB-A (check adapter type)
Use case options:
- Dedicated Proxmox management network
- Isolated VM network (security testing with Kali)
- Guest network
- Lab network
```

**Don't connect yet - configure in Guide 03**

**For now:** Only 10GbE connected to switch!

### Step 4: Connect Display & Input

1. **Connect Monitor:**
   ```
   HDMI cable from monitor → M4 HDMI port (back)
   OR
   USB-C/Thunderbolt cable → USB-C port (if monitor supports)
   
   Turn on monitor
   ```

2. **Connect Keyboard:**
   ```
   USB keyboard → Front USB-A port
   OR
   Bluetooth keyboard → Pair after macOS boots
   ```

3. **Connect Mouse:**
   ```
   USB mouse → Front USB-A port
   OR
   Bluetooth mouse → Pair after macOS boots
   ```

### Step 5: Connect Power

1. **Plug power cable into M4:**
   ```
   Kettle-style power inlet on back
   Pushed in firmly until seated
   ```

2. **Plug other end into surge protector:**
   ```
   Verify surge protector is ON
   ```

3. **M4 powers on automatically when plugged in!**
   ```
   You'll hear: Soft startup chime
   You'll see: Apple logo on monitor
   ```

**If it doesn't start:**
- Check power cable fully inserted both ends
- Check surge protector is on
- Check monitor input is set correctly

**✅ CHECKPOINT:** M4 is powered on and booting

---

## 🎬 First Boot & Setup Assistant

### macOS Sequoia Setup Assistant Walkthrough

**The M4 will boot to setup assistant. Follow these steps exactly:**

### 1. Select Country/Region
```
Screen: "Select Your Country or Region"

Action:
- Select: United Kingdom
- Click: Continue
```

**✅ Verified:** UK selected

### 2. Written and Spoken Languages
```
Screen: "Select Your Languages"

Primary language: English (UK)
Voice control language: English (UK)

Click: Continue
```

**✅ Verified:** English UK selected

### 3. Accessibility
```
Screen: "Accessibility"

Question: Do you need accessibility features?

Action:
- Select: Not Now (unless you need them)
- Click: Continue

Note: Can enable later in System Settings
```

**✅ Verified:** Accessibility configured

### 4. Connect to Network
```
Screen: "Connect to a Wi-Fi Network"

CRITICAL: See your 10GbE cable connected?

Action:
- Look for: Ethernet connection detected
- Should show: "Connected via Ethernet"
- If not showing Ethernet:
  - Check cable connections
  - Select WiFi temporarily (can remove later)
- Click: Continue
```

**Expected:** Ethernet (10GbE) detected automatically  
**Shows as:** "Ethernet" or "Wired Connection"

**✅ Verified:** Network connected

### 5. Data & Privacy
```
Screen: "Data & Privacy"

Information about how Apple uses your data

Action:
- Read if interested (or skip)
- Click: Continue
```

**✅ Verified:** Privacy info acknowledged

### 6. Migration Assistant
```
Screen: "Transfer Information to This Mac"

Question: Transfer from another Mac?

Action:
- Select: Not Now
- Click: Continue

Why: Fresh install is cleaner for servers
Note: We'll manually copy what we need later
```

**✅ Verified:** No migration

### 7. Sign in with Apple ID
```
Screen: "Sign In with Your Apple ID"

Action - YOUR CHOICE:

Option A (Recommended): Sign in
- Email: steve-smithit@outlook.com
- Password: [your Apple ID password]
- Benefits: iCloud, App Store, easier setup
- Continue with 2FA if enabled

Option B: Set Up Later
- Click: "Set Up Later"
- Confirm: "Skip"
- Why: More private, but need Apple ID for App Store
```

**My recommendation:** Sign in with Apple ID  
**Why:** Needed for App Store, easier management

**If signing in:**
```
- Enter Apple ID: steve-smithit@outlook.com
- Enter password
- Complete 2FA on Samsung S25 Ultra
- Click: Continue
```

**✅ Verified:** Apple ID configured

### 8. Terms and Conditions
```
Screen: "Terms and Conditions"

Action:
- Click: Agree
- Confirm: Agree
```

**✅ Verified:** Terms accepted

### 9. Create Computer Account
```
Screen: "Create a Computer Account"

CRITICAL - SAVE THESE IN 1PASSWORD IMMEDIATELY!

Full name: Steve
Account name: steve (will auto-fill)
Password: [CREATE STRONG PASSWORD]
Hint: (optional, but consider: "Stored in 1Password")

Click: Continue
```

**STOP HERE - SAVE TO 1PASSWORD:**

```
Open 1Password on Samsung S25 Ultra:

1Password → HomeLab Vault → New Login

Title: M4 Mac Mini - Steve User Account
Username: steve
Password: [the password you just created]

Add Custom Fields:
- Full Name: Steve
- Computer Name: (will set in next step)
- macOS Version: Sequoia 15.x
- IP Address: 192.168.50.10 (will configure)
- SSH: ssh steve@192.168.50.10
- Tailscale IP: (will configure later)

Notes: Main user account on M4 Mac Mini
       Admin privileges
       Used for all homelab management
       
Tags: m4, macos, admin, homelab

SAVE IMMEDIATELY!
```

**✅ Verified:** Password saved in 1Password before continuing

Click: **Continue** in macOS setup

### 10. Enable Location Services
```
Screen: "Enable Location Services"

Action:
- Select: Enable Location Services
- Click: Continue

Why: Useful for time zone, weather, etc.
Privacy: Can disable specific apps later
```

**✅ Verified:** Location services enabled

### 11. Select Time Zone
```
Screen: "Select Your Time Zone"

Should auto-detect: Europe/London (GMT)

Verify:
- Time zone: London
- City: London
- Time: Should show correct time

Click: Continue
```

**✅ Verified:** Time zone correct

### 12. Analytics
```
Screen: "Analytics"

Question: Share analytics with Apple?

Action - YOUR CHOICE:

Recommended for server: Uncheck all
- Share Mac Analytics: ☐
- Share iCloud Analytics: ☐
- Share crash and usage data with app developers: ☐

Why: Less data sent, better for server operation

Click: Continue
```

**✅ Verified:** Analytics preferences set

### 13. Screen Time
```
Screen: "Screen Time"

Action:
- Select: Set Up Later
- Click: Continue

Why: Not needed for server operation
Note: This is for monitoring app usage, parental controls
```

**✅ Verified:** Screen Time skipped

### 14. Siri
```
Screen: "Enable Ask Siri"

Action:
- Uncheck: Enable Ask Siri
- Click: Continue

Why: Not needed for headless server operation
Note: Siri uses resources we'd rather dedicate to services
```

**✅ Verified:** Siri disabled

### 15. FileVault Disk Encryption
```
Screen: "Encrypt Your Mac"

CRITICAL DECISION:

For HomeLab Server:
- Select: Don't encrypt
- Click: Continue
- Confirm: "Don't Encrypt"

Why?
- Easier disaster recovery
- Remote boot/restart without password entry
- Performance (encryption adds tiny overhead)
- Physical security: Keep M4 in secure location
- Our data security: Individual service encryption (Docker, VMs)

Note: If M4 were a laptop (risk of theft), enable FileVault
      For home server in secure location, not needed
```

**⚠️ IMPORTANT CONSIDERATION:**

**Encrypt if:**
- M4 is portable/might be stolen
- Required by compliance/work policy
- Storing extremely sensitive data

**Don't encrypt if:**
- M4 stays in secure home location (recommended)
- Want easy recovery and remote management
- Prioritize convenience over disk encryption

**For homelab:** Don't encrypt (easier management)

**✅ Verified:** Encryption decision made

### 16. Touch ID Setup
```
Screen: "Set Up Touch ID"

Action:
- Click: Set Up Later
- Confirm: Continue

Why: M4 Mac Mini doesn't have built-in Touch ID
Note: Can add Magic Keyboard with Touch ID later if wanted
```

**✅ Verified:** Touch ID skipped

### 17. Choose Your Look
```
Screen: "Choose Your Look"

Appearance options:
- Light
- Dark
- Auto (switches based on time of day)

Recommendation:
- Select: Dark
- Why: Easier on eyes, looks cool, uses less display power

Click: Continue
```

**✅ Verified:** Appearance selected

### 18. Setup Complete!
```
Screen: Welcome animation

macOS finishes setup
Desktop loads
You're in!
```

**✅ macOS Sequoia is installed and ready!**

---

## 🎉 First Boot Complete!

**At this point you should see:**
- macOS desktop (Dock at bottom, menu bar at top)
- Wallpaper (Sequoia default background)
- Empty desktop or default icons

**Verify basics:**
- [x] Mouse cursor moves
- [x] Keyboard types
- [x] Monitor display is clear
- [x] Network connected (see WiFi/Ethernet icon in menu bar)

---

## 🖥️ Initial System Configuration

### Set Computer Name

**Make it easy to identify on network!**

1. **Open System Settings:**
   ```
   Click: Apple menu  (top left)
   Click: System Settings
   ```

2. **Navigate to Sharing:**
   ```
   Left sidebar → General → Sharing
   ```

3. **Set Computer Name:**
   ```
   Local hostname: m4-homelab
   
   Computer Name will auto-update to: m4-homelab.local
   
   This is your hostname on local network!
   ```

4. **Verify hostname:**
   ```
   Open Terminal:
   - Applications → Utilities → Terminal
   - OR: Cmd+Space, type "terminal", Enter
   
   Type: hostname
   Press: Enter
   
   Should show: m4-homelab.local
   ```

**Save to 1Password (update existing entry):**
```
Update: M4 Mac Mini - Steve User Account

Add/Update Custom Field:
- Computer Name: m4-homelab
- Local Hostname: m4-homelab.local

Save
```

**✅ CHECKPOINT:** Computer name set to m4-homelab

---

## 🔌 Connect External 4TB SSD

**Now that macOS is running, connect your storage:**

### Step 1: Connect SSD

1. **Plug USB-C cable from 4TB SSD into M4:**
   ```
   Use: Leftmost Thunderbolt port (back of M4)
   Connection: Should be USB-C to USB-C
   ```

2. **SSD should mount automatically:**
   ```
   You'll see: SSD icon appear on desktop
   OR: In Finder sidebar under "Locations"
   
   Name: Probably "Samsung T7" or "Untitled"
   ```

3. **If it doesn't appear:**
   ```
   - Check cable connections
   - Try different Thunderbolt port
   - Check SSD has power LED lit
   - Open Finder → Sidebar should show external drive
   ```

**✅ CHECKPOINT:** 4TB SSD connected and detected

### Step 2: Check Current Format

**We need to verify/reformat for optimal macOS performance:**

1. **Open Disk Utility:**
   ```
   Applications → Utilities → Disk Utility
   OR: Cmd+Space, type "disk utility", Enter
   ```

2. **Select your 4TB SSD:**
   ```
   Left sidebar → External section
   Click: Your 4TB SSD (should show ~4TB capacity)
   ```

3. **Check current format:**
   ```
   Look at top info section:
   Format: Probably "exFAT" or "NTFS" or "APFS"
   ```

**Current format determines what we do next:**

---

### If Format is APFS (Apple File System):
```
✅ PERFECT! Already optimal for macOS.
Skip to "Configure External SSD" below.
```

### If Format is exFAT or FAT32 or NTFS:
```
⚠️ NEED TO REFORMAT to APFS for best performance

CRITICAL: This will ERASE the SSD!
- Make sure it's empty or data is backed up
- We want fresh start anyway
```

**To Reformat to APFS:**

1. **In Disk Utility, with SSD selected:**
   ```
   Click: Erase (top toolbar)
   ```

2. **Erase dialog appears:**
   ```
   Name: External4TB
   Format: APFS
   Scheme: GUID Partition Map
   
   Click: Erase
   ```

3. **Confirmation:**
   ```
   "Are you sure you want to erase...?"
   Click: Erase
   ```

4. **Wait for format:**
   ```
   Takes: 30-60 seconds
   Progress bar appears
   
   When done: "Erase process complete"
   Click: Done
   ```

5. **SSD remounts automatically:**
   ```
   Desktop icon reappears: "External4TB"
   Format now: APFS
   ```

**✅ CHECKPOINT:** 4TB SSD formatted as APFS

---

### Step 3: Configure External SSD

**Set it to mount automatically on boot:**

1. **Open Terminal:**
   ```
   Applications → Utilities → Terminal
   ```

2. **Get SSD UUID:**
   ```bash
   diskutil info /Volumes/External4TB | grep UUID
   ```
   
   **Copy the UUID** (looks like: 12345678-ABCD-1234-ABCD-123456789ABC)

3. **Add to /etc/fstab (auto-mount):**
   ```bash
   # Open fstab for editing (create if doesn't exist)
   sudo nano /etc/fstab
   
   # Password: Your Mac password
   
   # Add this line (replace UUID_HERE with your UUID):
   UUID=UUID_HERE /Volumes/External4TB apfs rw,auto
   
   # Save: Ctrl+X, Y, Enter
   ```

4. **Verify:**
   ```bash
   # Unmount
   diskutil unmount /Volumes/External4TB
   
   # Remount (tests auto-mount)
   diskutil mount /Volumes/External4TB
   
   # Should mount automatically
   ```

**Save to 1Password:**
```
1Password → HomeLab Vault → Secure Note

Title: External 4TB SSD Configuration

Content:
Name: External4TB
Format: APFS
Mount: /Volumes/External4TB
UUID: [your UUID]
Connection: Thunderbolt (leftmost port)
Use: Main storage for homelab
      - VMs: /Volumes/External4TB/VMs
      - Media: /Volumes/External4TB/Media
      - Backups: /Volumes/External4TB/Backups
      - Docker data: /Volumes/External4TB/Docker-Data

Tags: storage, configuration, homelab

Save
```

**✅ CHECKPOINT:** 4TB SSD configured and auto-mounting

---

## 📁 Create Folder Structure

**Organize your external SSD now:**

```bash
# Open Terminal

# Create main directories
mkdir -p /Volumes/External4TB/VMs
mkdir -p /Volumes/External4TB/Media/{Movies,TV,Music,Photos,Comics}
mkdir -p /Volumes/External4TB/Downloads
mkdir -p /Volumes/External4TB/Backups
mkdir -p /Volumes/External4TB/Docker-Data
mkdir -p /Volumes/External4TB/ISOs
mkdir -p /Volumes/External4TB/Frigate

# Create symlinks to home directory for easy access
ln -s /Volumes/External4TB ~/External4TB
ln -s /Volumes/External4TB/Media ~/Media
ln -s /Volumes/External4TB/VMs ~/VMs

# Verify structure
ls -la /Volumes/External4TB/
```

**You should see:**
```
/Volumes/External4TB/
├── Backups/
├── Docker-Data/
├── Downloads/
├── Frigate/
├── ISOs/
├── Media/
│   ├── Movies/
│   ├── TV/
│   ├── Music/
│   ├── Photos/
│   └── Comics/
└── VMs/
```

**✅ CHECKPOINT:** Folder structure created

---

## ✅ Guide 01 Complete Checklist

Before proceeding to Guide 02, verify:

**Hardware:**
- [x] M4 Mac Mini unboxed and inspected
- [x] All cables connected (10GbE, HDMI, power)
- [x] 4TB external SSD connected
- [x] Monitor, keyboard, mouse working
- [x] M4 powered on and running

**macOS Setup:**
- [x] macOS Sequoia installed
- [x] User account created (steve)
- [x] Password saved in 1Password
- [x] Computer name set (m4-homelab)
- [x] Time zone correct (Europe/London)
- [x] Network connected (10GbE working)

**Storage:**
- [x] 4TB SSD formatted to APFS
- [x] Named "External4TB"
- [x] Auto-mounting configured
- [x] Folder structure created
- [x] Symlinks to home directory created

**Documentation:**
- [ ] Account info updated in 1Password
- [ ] SSD configuration saved
- [ ] Computer name noted

---

**🎉 Congratulations!** Your M4 Mac Mini is physically set up and macOS is installed!

**Next:** Guide 02 - Network Configuration (setting up all 3 ethernet adapters)

**Take a 5-minute break! ☕**

---

*End of Guide 01*


---

#homelab #hardware #m4 #network #setup
