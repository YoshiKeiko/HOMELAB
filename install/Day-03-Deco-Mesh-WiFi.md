---
title: Day 02 BONUS: TP-Link Deco XE75 Mesh Setup
tags: [homelab, network, wifi, mesh, deco]
created: 2025-11-11
type: homelab-guide
---

# Day 02 BONUS: TP-Link Deco XE75 Mesh Setup

**⏱️ Time:** 45-60 minutes  
**☕ Coffee:** 2 cups  
**🎯 Difficulty:** Intermediate  
**📅 When:** After Day 02 (M4 setup complete)

> *"Looks like I picked the right week to setup a mesh network!"* ☕

---

## 📋 What You're Building

**Problem:** Sky router WiFi = single point, limited coverage, interference  
**Solution:** Professional mesh network with wired backhaul

**You'll have:**
- 3 TP-Link Deco XE75 access points
- Wired Ethernet backhaul (via TP-Link switch)
- Full house coverage
- Sky router optimized (gateway-only, WiFi disabled)
- Separate IoT network for 43+ smart devices

---

## ✅ Prerequisites

**Hardware:**
- [ ] 3x TP-Link Deco XE75 units (unboxed)
- [ ] 3x Ethernet cables (Cat5e minimum)
- [ ] TP-Link SX1008 switch (from Day 01)
- [ ] Sky router access (admin login)

**Before Starting:**
- [ ] M4 Mac Mini setup complete (Day 02)
- [ ] M4 on 10GbE wired (192.168.50.10)
- [ ] TP-Link switch connected to Sky router
- [ ] Deco app installed on Samsung S25 Ultra

---

# Part 1: Disable Sky Router WiFi

## Why?
- Eliminates interference with 10GbE
- Better performance (router does routing only)
- No device confusion (one network)

## Steps:

1. **Login to Sky Router:**
   ```
   URL: http://192.168.50.1
   Username: admin
   Password: [from router label]
   ```

2. **Navigate:** Wireless → Wireless Settings

3. **Disable both bands:**
   - 2.4GHz WiFi: OFF
   - 5GHz WiFi: OFF
   - Save/Apply

4. **Verify:** WiFi networks disappear on phone

5. **Test:** M4 still has internet (wired 10GbE)
   ```bash
   ping 8.8.8.8
   ```

✅ **CHECKPOINT:** Sky WiFi off, M4 wired working

---

# Part 2: Position Deco Units

## Recommended Layout:

**Deco #1 - Main (Living Room):**
- Central location
- Connect to: TP-Link Switch Port 2
- Covers: Living room, kitchen, front

**Deco #2 - Office:**
- Home office
- Connect to: TP-Link Switch Port 3
- Covers: Office, back garden

**Deco #3 - Bedroom:**
- Upstairs/main bedroom
- Connect to: TP-Link Switch Port 4
- Covers: All bedrooms

## Physical Setup:

1. Place each Deco unit
2. Run Ethernet cable to switch
3. Plug in power
4. Wait for pulsing blue LED (~2 min)

**Switch Layout:**
```
TP-Link SX1008:
Port 1: M4 Mac Mini (10GbE)
Port 2: Deco #1 (Main)
Port 3: Deco #2 (Office)
Port 4: Deco #3 (Bedroom)
Port 5-7: Available
Port 8: Uplink to Sky Router
```

✅ **CHECKPOINT:** All 3 Decos powered, pulsing blue

---

# Part 3: Setup Main Deco

## On Samsung S25 Ultra:

1. **Open Deco app**

2. **Create/login TP-Link account:**
   - Email: steve-smithit@outlook.com
   - Password: [generate strong one]
   - **Save to 1Password immediately!**

3. **Add first Deco:**
   - Tap: +
   - Select: Deco XE75
   - Scan QR code (bottom of Deco #1)
   - Location: Living Room

4. **Configure network:**
   ```
   WiFi Name: SteveHomeNet
   Password: [16+ char password]
   
   Save to 1Password:
   Title: Home WiFi - SteveHomeNet
   Type: Wireless Router
   SSID: SteveHomeNet
   Password: [your password]
   Security: WPA3
   ```

5. **CRITICAL - Operation Mode:**
   ```
   Select: Access Point Mode
   (NOT Router Mode!)
   
   Why? Sky router is already your router.
   Decos provide WiFi only.
   ```

6. **Wait for setup:** 3-5 minutes
   - LED: Pulsing blue → Solid white
   - Solid white = SUCCESS!

7. **Test:** Connect phone to SteveHomeNet

✅ **CHECKPOINT:** Main Deco working, phone connected

---

# Part 4: Add Satellite Decos

## Add Deco #2 (Office):

1. In Deco app: Tap +
2. Select: Add Another Deco
3. Scan QR code (Deco #2)
4. Location: Office
5. Wait 2-3 minutes
6. Verify: Shows "Wired" in app (Ethernet icon)

## Add Deco #3 (Bedroom):

1. Repeat same process
2. Scan QR code (Deco #3)
3. Location: Bedroom
4. Verify: Shows "Wired" in app

## Verify All 3:

**In app you should see:**
- All 3 Decos: Connected
- All 3 showing: Wired (Ethernet icons)
- All 3 LEDs: Solid white
- Network name: SteveHomeNet

✅ **CHECKPOINT:** All 3 Decos operational with wired backhaul

---

# Part 5: Advanced Configuration

## Address Reservation:

```
More → Advanced → Address Reservation

Add:
- M4 Mac Mini: 192.168.50.10
- Brother Printer: 192.168.50.201
- Windows VM: 192.168.50.52 (future)
- Ubuntu VM: 192.168.50.51 (future)
```

## DHCP Range:

```
More → Advanced → DHCP Server

Start: 192.168.50.100
End: 192.168.50.199

(Keeps .1-.99 for static, .200-254 for IoT)
```

## Enable Features:

```
More → Advanced

Fast Roaming: ON (seamless handoff)
Beamforming: ON (better signal)
Network Optimization: ON (auto channel)
```

## IoT Network (Recommended):

```
More → Advanced → IoT Network

Enable: ON
SSID: SteveHomeNet-IoT
Password: [different from main]
Frequency: 2.4GHz only
Security: WPA2

Use for: Nest cameras, Sonos, smart plugs
(43+ IoT devices)

Save to 1Password!
```

---

# Part 6: Migrate All Devices

## Critical Devices First:

1. **MacBook Air** → SteveHomeNet
2. **iPad Pro** → SteveHomeNet
3. **M2 Mac Mini** → SteveHomeNet

## Smart Home (use IoT network):

**5x Nest Cameras:**
- Google Home app
- Each camera → WiFi settings
- Connect to: SteveHomeNet-IoT

**10x Sonos Speakers:**
- Sonos app
- Settings → System → Network
- Update WiFi → SteveHomeNet-IoT
- Takes 5-10 min for all

**Other Smart Devices:**
- Nest thermostat → SteveHomeNet-IoT
- Nest Minis → SteveHomeNet-IoT
- Meross plugs → SteveHomeNet-IoT
- Easee charger → SteveHomeNet-IoT

## Gaming/Entertainment:

- 2x PS5 → SteveHomeNet
- 3x Xbox → SteveHomeNet
- Smart TVs → SteveHomeNet

## Cars:

- Tesla Model Y → SteveHomeNet
- Cupra Born → SteveHomeNet

## VERIFY M4 STILL WIRED:

```bash
# SSH to M4
ssh steve@192.168.50.10

# Check interface
ifconfig en0 | grep "10GbaseT"

# Should show: 10GbaseT <full-duplex>
# This confirms M4 on 10GbE, NOT WiFi!
```

✅ **CHECKPOINT:** All 43+ devices connected, M4 still wired

---

# Part 7: Coverage Testing

## Walk Test:

**Living Room (Deco #1):**
- Signal: Excellent
- Speed: 400-500 Mbps
- Connected to: Deco #1

**Office (Deco #2):**
- Signal: Excellent
- Speed: 400-500 Mbps
- Connected to: Deco #2

**Bedroom (Deco #3):**
- Signal: Excellent
- Speed: 400-500 Mbps
- Connected to: Deco #3

**Roaming Test:**
- Walk living room → office → bedroom
- Should seamlessly switch Decos
- No disconnections

**Outdoor:**
- Front garden: Good signal
- Back garden: Good signal
- Driveway: Good signal

---

# Part 8: Backup & Maintenance

## Create Backup:

```
More → System → Backup & Restore

Create Backup
Download to phone
Upload to 1Password as document

Title: Deco Mesh Configuration Backup
Type: Document
File: deco-backup-YYYYMMDD.bin
```

## Enable Auto-Update:

```
More → System → Firmware Update

Auto-update: ON
Check monthly
Updates take ~5 minutes
```

---

# Troubleshooting

## Deco Won't Connect:

1. Check Ethernet cable plugged in
2. Check switch port has link light
3. Power cycle Deco (unplug 10s)
4. Factory reset: Hold reset button 10s

## Slow WiFi:

1. Verify wired backhaul in app (Ethernet icon)
2. Update firmware
3. Run network optimization
4. Reboot all Decos

## Device Can't Connect:

1. Correct password (case-sensitive)
2. Try 2.4GHz IoT network if 5GHz fails
3. Forget network and reconnect
4. Check not blocked in Deco app

## M4 Using WiFi Instead of Wired:

```bash
# Check interface priority
networksetup -listnetworkserviceorder

# Ethernet should be first
# If WiFi first, reorder:
networksetup -ordernetworkservices "Ethernet" "Wi-Fi"
```

---

# Verification Checklist

**Sky Router:**
- [ ] WiFi disabled (both bands)
- [ ] Still routing traffic
- [ ] Accessible at 192.168.50.1

**Deco Mesh:**
- [ ] All 3 units solid white LED
- [ ] All 3 showing wired backhaul in app
- [ ] Network: SteveHomeNet
- [ ] IoT network: SteveHomeNet-IoT
- [ ] Settings backed up to 1Password

**Devices:**
- [ ] All 43+ devices reconnected
- [ ] Smart home on IoT network
- [ ] M4 still on wired 10GbE
- [ ] Full coverage everywhere

**Performance:**
- [ ] WiFi speeds 400-500 Mbps
- [ ] Seamless roaming working
- [ ] No dead zones
- [ ] Low latency

---

# What You've Achieved

**Before:**
- Sky router WiFi (single point)
- Limited coverage (~70%)
- WiFi interference with 10GbE
- 43+ devices on one AP

**After:**
- Professional mesh (3 access points)
- Full coverage (100%)
- Wired backhaul (maximum speed)
- Separate IoT network
- No 10GbE interference
- Sky router optimized

**Network Stats:**
```
Coverage: 100% (was ~70%)
Speed: 400-500 Mbps everywhere
Latency: <5ms on mesh
Devices: 43+ all connected
Reliability: Excellent
```

---

## 🎉 BONUS GUIDE COMPLETE!

**Next Steps:**
- Continue with Day 03 (Docker Infrastructure)
- Or proceed through your remaining volumes
- Network is now OPTIMIZED! ✅

*"Surely you can't be serious about this amazing network?"*  
*"I am serious. And don't call me Shirley."* ☕😎


---

#homelab #network #wifi #mesh #deco
