# 🌐 NETWORK CONFIGURATION

## Current Setup

**Mac Mini IP Address:** 192.168.50.50  
**Subnet Mask:** 255.255.252.0  
**Gateway/DNS:** 192.168.50.1  
**Network Speed:** 10GbE (6+ GB/s up/down)

---

## Why This Configuration?

You're using the **192.168.50.x** network range because:

✅ **10GbE Performance**: Direct connection to 10GbE switch  
✅ **6+ GB/s speeds**: vs <1GB/s on 192.168.68.x network  
✅ **TP-Link SX1008 Switch**: Optimal routing through 10GbE infrastructure

---

## AdGuard DNS Configuration

### Current DNS Settings (on Mac)
- **Primary DNS:** 192.168.50.1 (Sky Shield)
- **Mac IP:** 192.168.50.50

### AdGuard Home Setup

AdGuard Home is accessible at:
- **Local:** http://localhost:8084
- **Network:** http://192.168.50.50:8084

### To Enable Network-Wide Ad Blocking

**Option 1: Router DNS (Recommended)**
1. Access Sky router admin: http://192.168.50.1
2. Find DHCP/DNS settings
3. Set primary DNS: `192.168.50.50` (AdGuard)
4. Set secondary DNS: `192.168.50.1` (Sky Shield fallback)
5. Save and reboot router

**Option 2: Per-Device DNS**
On each device, manually set DNS to `192.168.50.50`

---

## Access URLs (Updated)

All services now accessible at: **http://192.168.50.50:PORT**

### Quick Access
- **Heimdall Dashboard:** http://192.168.50.50:8090
- **Portainer:** http://192.168.50.50:9000
- **AdGuard Home:** http://192.168.50.50:8084
- **Plex:** http://192.168.50.50:32400/web
- **Home Assistant:** http://192.168.50.50:8123
- **Grafana:** http://192.168.50.50:3003

### From Other Devices

**iPhone/iPad/Other Mac:**
```
Open browser → http://192.168.50.50:8090
```

**Smart TV/Console:**
```
Open browser → http://192.168.50.50:32400/web
Or install Plex app
```

---

## Network Diagram

```
Internet (5Gbps CityFibre)
          ↓
   Sky Router (192.168.50.1)
          ↓
TP-Link SX1008 10GbE Switch
          ↓
   ┌──────┴──────┬──────────┐
   ↓             ↓          ↓
M4 Mac Mini   Other      External
(10GbE)       Devices    Storage
192.168.50.50           (4TB SSD)
   ↓
Docker Services (56 containers)
   ↓
AdGuard Home (DNS on port 53)
```

---

## Testing Network Performance

```bash
# Test local speed
curl -o /dev/null http://192.168.50.50:9000

# Test from another device
ping 192.168.50.50

# Check network interface
ifconfig | grep -A 4 "192.168.50.50"
```

---

## DNS Resolution

### Current Setup
Your Mac uses **192.168.50.1** as DNS, which means:
- Sky Shield is handling DNS
- AdGuard is NOT filtering your Mac's traffic yet

### To Fix (Mac uses AdGuard)
```bash
# System Settings → Network → Ethernet (10GbE)
# DNS Servers: Change to 192.168.50.50
```

### To Test AdGuard
```bash
# Test DNS resolution through AdGuard
dig @192.168.50.50 doubleclick.net

# Should return 0.0.0.0 (blocked)
```

---

## All Files Updated

✅ homelab-master-setup.sh  
✅ heimdall-config.yml  
✅ HOMELAB-HANDBOOK.md  
✅ DEPLOYMENT-PACKAGE.md  
✅ pcloud-backup-setup.sh

All now reference **192.168.50.50** instead of 192.168.68.50

