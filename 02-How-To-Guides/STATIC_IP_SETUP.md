# 🌐 Static IP Setup for M4 Mac + TP-Link Deco XE75 Pro

## 📋 Current Network Info

- **Current IP:** 192.168.68.50
- **MAC Address:** d0:11:e5:bb:70:0b
- **Gateway (Deco):** 192.168.68.1

---

## 🎯 Two Methods (Choose One)

### Method 1: Address Reservation (RECOMMENDED ⭐)
**Best for:** Homelab servers, easy setup, no Mac changes needed

**Pros:**
- ✅ Mac still gets IP via DHCP (automatic)
- ✅ Always gets the SAME IP
- ✅ Works after Mac restarts
- ✅ No manual network configuration
- ✅ Survives macOS updates

**Cons:**
- ⚠️ Need Deco app to configure

---

### Method 2: Manual Static IP on Mac
**Best for:** When you can't access router, temporary testing

**Pros:**
- ✅ No router access needed
- ✅ Immediate configuration

**Cons:**
- ⚠️ Must manually configure DNS, gateway
- ⚠️ Can break if network settings change
- ⚠️ macOS updates might reset

---

## ⭐ Method 1: Address Reservation (RECOMMENDED)

This is the BEST way - Mac thinks it's using DHCP, but always gets the same IP!

### Step 1: Open Deco App

1. Open **Deco app** on your phone
2. Make sure you're connected to your Deco network
3. Sign in if needed

### Step 2: Find Your Mac

1. Tap **bottom menu** → tap the house/network icon
2. Tap **"Clients"** or **"Devices"**
3. Look for your device:
   - Name: **"homelab"** or **"homelab's M4"**
   - MAC: **d0:11:e5:bb:70:0b**
   - IP: **192.168.68.50**
4. Tap on your Mac

### Step 3: Reserve the Address

1. On device details page, look for **"Reserve IP"** or **"Address Reservation"**
2. Toggle it **ON** or tap **"Reserve this IP address"**
3. The current IP (192.168.68.50) will be reserved
4. Tap **"Save"** or **"Apply"**

### Step 4: Verify

**On Mac, renew DHCP:**
```bash
# Release current IP
sudo ipconfig set en0 DHCP

# Wait 5 seconds
sleep 5

# Check you got the same IP back
ifconfig en0 | grep "inet "
```

You should see: **192.168.68.50** (same IP!)

### Step 5: Test Persistence

**Restart Mac:**
```bash
sudo reboot
```

**After restart, check IP:**
```bash
ifconfig en0 | grep "inet "
```

Should still be: **192.168.68.50** ✅

---

## 🔧 Method 2: Manual Static IP (Alternative)

Only use this if you can't access the Deco app!

### Step 1: Get Network Info

You need these values (already collected):

- **IP Address:** 192.168.68.50
- **Subnet Mask:** 255.255.255.0 (typical for home networks)
- **Router (Gateway):** 192.168.68.1
- **DNS Server:** 192.168.68.1 (use Deco as DNS for now)

### Step 2: Configure Static IP on Mac

**Option A: Via System Settings (GUI)**

1. **Open System Settings**
2. Click **Network**
3. Click **Wi-Fi** (or Ethernet if using)
4. Click **Details** button
5. Click **TCP/IP** tab
6. Change **"Configure IPv4"** from **"Using DHCP"** to **"Manually"**
7. Enter:
   - **IP Address:** 192.168.68.50
   - **Subnet Mask:** 255.255.255.0
   - **Router:** 192.168.68.1
8. Click **DNS** tab
9. Click **"+"** and add DNS servers:
   - 192.168.68.50 (for AdGuard)
   - 192.168.68.1 (backup)
   - 1.1.1.1 (backup)
10. Click **OK**
11. Click **Apply**

**Option B: Via Command Line**

```bash
# Set static IP
sudo networksetup -setmanual "Wi-Fi" 192.168.68.50 255.255.255.0 192.168.68.1

# Set DNS servers
sudo networksetup -setdnsservers "Wi-Fi" 192.168.68.50 192.168.68.1 1.1.1.1
```

### Step 3: Verify

```bash
# Check IP
ifconfig en0 | grep "inet "

# Check DNS
networksetup -getdnsservers "Wi-Fi"

# Test connectivity
ping -c 3 8.8.8.8
ping -c 3 google.com
```

---

## 🧪 After Setup - Configure AdGuard DNS

Once you have static IP (either method):

### Update DNS to Use AdGuard

**Via System Settings:**
1. Network → Wi-Fi → Details → DNS
2. Remove all DNS servers
3. Add **192.168.68.50** as first DNS
4. Add **192.168.68.1** as backup
5. Apply

**Via Command Line:**
```bash
sudo networksetup -setdnsservers "Wi-Fi" 192.168.68.50 192.168.68.1
```

### Test AdGuard

```bash
# Should resolve via AdGuard
nslookup google.com

# Should be blocked
nslookup doubleclick.net
```

**Open AdGuard dashboard:**
- http://localhost:8084
- Check Query Log
- Should see DNS queries appearing

---

## 📱 Configure Other Devices (Optional)

### Router-Wide (Best - Protects Everything)

**Configure in Deco App:**

1. Open Deco app
2. Tap **More** (bottom right)
3. Tap **Advanced**
4. Tap **DHCP Server**
5. Set **Primary DNS:** 192.168.68.50
6. Set **Secondary DNS:** 192.168.68.1 or 1.1.1.1
7. Save

**Result:** All devices on network now use AdGuard! 🎉

### Individual Devices

**iPhone/iPad:**
1. Settings → Wi-Fi
2. Tap (i) next to your network
3. Configure DNS → Manual
4. Remove existing, add: 192.168.68.50

**Android:**
1. Settings → Network & Internet → Wi-Fi
2. Long press your network → Modify
3. Advanced → DNS → 192.168.68.50

**Windows:**
1. Network Settings → Change adapter options
2. Right-click Wi-Fi → Properties
3. IPv4 → Properties
4. Use these DNS: 192.168.68.50

---

## 🔧 Troubleshooting

### "Lost internet after static IP"

**Problem:** Wrong gateway or DNS

**Fix:**
```bash
# Switch back to DHCP temporarily
sudo networksetup -setdhcp "Wi-Fi"

# Wait 10 seconds
sleep 10

# Check what DHCP gave you
ifconfig en0 | grep "inet "
netstat -nr | grep default

# Use those values for static config
```

### "IP conflict" error

**Problem:** Another device has 192.168.68.50

**Fix:** Choose different IP in same range
```bash
# Use .100, .101, .102, etc.
# Make sure it's OUTSIDE your Deco's DHCP range
# (Usually 192.168.68.100-192.168.68.200)

# Check Deco DHCP range in app:
# More → Advanced → DHCP Server
```

### "Mac IP keeps changing"

**Problem:** DHCP reservation not set

**Fix:** Use Method 1 (Address Reservation in Deco app)

### "Can't access Deco app"

**Problem:** App requires login/internet

**Temporary workaround:**

1. Access Deco via web interface:
   - Open: http://192.168.68.1
   - Login with TP-Link ID
   - Limited features, but can set reservation

2. Or use Method 2 (manual static IP on Mac)

---

## ⚠️ Important Notes

### IP Address Range

Your network is probably: **192.168.68.x** or **192.168.1.x**

**Safe static IPs to use:**
- .10 to .50 (usually safe, outside DHCP pool)
- Current IP: 192.168.68.50 (safest - already assigned to you)

**Avoid:**
- .1 (router/gateway)
- .100-200 (typical DHCP range)
- .255 (broadcast)

### DHCP Range

Check your Deco's DHCP range:
- Deco app → More → Advanced → DHCP Server
- Typical: 192.168.68.100 - 192.168.68.200

Choose static IP **outside** this range to avoid conflicts!

### DNS Priority

**For AdGuard to work, DNS must be set in this order:**
1. 192.168.68.50 (your Mac - AdGuard)
2. 192.168.68.1 (Deco - backup)
3. 1.1.1.1 (Cloudflare - backup)

---

## ✅ Verification Checklist

**Static IP Configured:**
- [ ] Mac has static IP: 192.168.68.50
- [ ] IP persists after reboot
- [ ] Can browse internet
- [ ] Can ping 192.168.68.1

**AdGuard Working:**
- [ ] DNS set to 192.168.68.50
- [ ] Can access http://localhost:8084
- [ ] Query Log shows activity
- [ ] Ads are blocked

**Network Services:**
- [ ] Can access all HomeLab services
- [ ] Tailscale still works
- [ ] Other devices can connect

---

## 🎯 Quick Commands Reference

**Check current IP:**
```bash
ifconfig en0 | grep "inet "
```

**Check DNS:**
```bash
networksetup -getdnsservers "Wi-Fi"
```

**Switch to DHCP:**
```bash
sudo networksetup -setdhcp "Wi-Fi"
```

**Set static IP:**
```bash
sudo networksetup -setmanual "Wi-Fi" 192.168.68.50 255.255.255.0 192.168.68.1
```

**Set DNS:**
```bash
sudo networksetup -setdnsservers "Wi-Fi" 192.168.68.50 192.168.68.1
```

**Test connectivity:**
```bash
ping -c 3 8.8.8.8
ping -c 3 google.com
```

**Renew DHCP (if using reservation):**
```bash
sudo ipconfig set en0 DHCP
```

---

## 🏆 Recommended Setup

**Best practice for homelab:**

1. ✅ Use **Address Reservation** in Deco (Method 1)
2. ✅ Keep Mac on DHCP (gets reserved IP automatically)
3. ✅ Set DNS to 192.168.68.50 (for AdGuard)
4. ✅ Set backup DNS to 192.168.68.1 or 1.1.1.1
5. ✅ Configure router-wide DNS (all devices protected)

**This gives you:**
- Static IP that survives restarts
- AdGuard protection
- No manual configuration needed
- Easy to maintain

---

**You're ready! Follow Method 1 for the best experience! 🎉**

