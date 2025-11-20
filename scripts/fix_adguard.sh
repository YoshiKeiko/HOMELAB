#!/bin/bash

################################################################################
# Proper AdGuard DNS Setup Guide
################################################################################

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  AdGuard DNS Setup - The Right Way"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Get Mac's actual IP address
MAC_IP=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

echo -e "${YELLOW}Your Mac's IP Address:${NC} ${CYAN}${MAC_IP}${NC}"
echo ""

cat > "$HOME/HomeLab/docs/ADGUARD_SETUP.md" << EOF
# 🛡️ AdGuard Home - Proper DNS Setup

## ❌ What You Did Wrong (Don't worry, easy fix!)

You set DNS to: \`127.0.0.1\`

**Problem:** 
- \`localhost\` needs DNS to resolve
- DNS is set to \`localhost\`
- Creates infinite loop
- Nothing works!

---

## ✅ Correct Setup

### Step 1: Fix Your Mac's DNS

Your Mac's actual IP: **${MAC_IP}**

**Set DNS to your Mac's IP, not localhost:**

\`\`\`bash
# For Wi-Fi:
sudo networksetup -setdnsservers "Wi-Fi" ${MAC_IP}

# For Ethernet (if using):
sudo networksetup -setdnsservers "Ethernet" ${MAC_IP}
\`\`\`

**Verify it worked:**
\`\`\`bash
networksetup -getdnsservers "Wi-Fi"
# Should show: ${MAC_IP}
\`\`\`

---

### Step 2: Test AdGuard

**Access AdGuard:**
- Admin Panel: http://localhost:8084
- Or: http://${MAC_IP}:8084

**Test DNS is working:**
\`\`\`bash
# Should return AdGuard's IP (showing it's blocking)
nslookup doubleclick.net

# Should work normally
nslookup google.com
\`\`\`

---

### Step 3: Configure Other Devices (Optional)

**Router-Wide (Best - all devices protected):**
1. Access your router admin panel
2. Find DHCP/DNS settings
3. Set Primary DNS: \`${MAC_IP}\`
4. Set Secondary DNS: \`1.1.1.1\` (fallback)
5. Save and reboot router
6. All devices now use AdGuard!

**Individual Device:**
- iPhone/iPad: Settings → Wi-Fi → (i) → Configure DNS → Manual → Add ${MAC_IP}
- Android: Settings → Network → Wi-Fi → Advanced → DNS → ${MAC_IP}
- Windows: Network Settings → Change Adapter Options → IPv4 Properties → DNS: ${MAC_IP}

---

### Step 4: AdGuard Settings (In Admin Panel)

**Recommended Settings:**

1. **Filters:**
   - ✅ AdGuard DNS filter (enabled by default)
   - ✅ Add "EasyList" (more ad blocking)
   - ✅ Add "Peter Lowe's List"
   - Settings → DNS blocklists → Add blocklist

2. **Upstream DNS:**
   - Settings → DNS settings
   - Use these fast, private DNS servers:
   - \`1.1.1.1\` (Cloudflare)
   - \`1.0.0.1\` (Cloudflare backup)
   - \`8.8.8.8\` (Google backup)

3. **Rate Limiting:**
   - Settings → DNS settings
   - Enable rate limiting: 20 requests/second

4. **DNSSEC:**
   - Settings → DNS settings  
   - ✅ Enable DNSSEC (extra security)

5. **Query Log:**
   - Settings → General settings
   - Keep for 90 days (see what's being blocked)

---

## 🧪 Testing AdGuard is Working

### Test 1: Visit Ad-Heavy Site
- Visit: https://www.speedtest.net
- Should see blocked requests in AdGuard dashboard
- Fewer ads on page

### Test 2: Check Blocking
1. Open AdGuard: http://localhost:8084
2. Go to Query Log
3. Open a website
4. See blocked queries (red)

### Test 3: Statistics
- Dashboard shows:
  - Total queries
  - Blocked by filters (%)
  - Should be 10-30% typically

---

## 🔧 Troubleshooting

### "localhost not working anymore"

**Problem:** DNS set to 127.0.0.1 instead of actual IP

**Fix:**
\`\`\`bash
# Reset DNS to your Mac IP
sudo networksetup -setdnsservers "Wi-Fi" ${MAC_IP}

# Or temporarily use public DNS
sudo networksetup -setdnsservers "Wi-Fi" 1.1.1.1
\`\`\`

### "Websites not loading"

**Problem:** AdGuard blocking too aggressively or Mac IP changed

**Quick Fix:**
\`\`\`bash
# Use public DNS temporarily
sudo networksetup -setdnsservers "Wi-Fi" 1.1.1.1 8.8.8.8

# Then check what went wrong in AdGuard logs
\`\`\`

### "AdGuard not blocking anything"

**Check:**
1. Is AdGuard running? \`docker ps | grep adguard\`
2. Is DNS set correctly? \`networksetup -getdnsservers "Wi-Fi"\`
3. Are filters enabled? Check Settings → DNS blocklists

### "Mac IP changed (after restart/network change)"

Your Mac IP can change! When it does:

**Option 1: Static IP (Recommended)**
1. Router admin panel
2. DHCP Reservations
3. Reserve ${MAC_IP} for your Mac's MAC address
4. Never changes again!

**Option 2: Update DNS each time**
\`\`\`bash
# Get new IP
NEW_IP=\$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}' | head -1)

# Update DNS
sudo networksetup -setdnsservers "Wi-Fi" \$NEW_IP
\`\`\`

---

## 📊 What AdGuard Blocks

**Typical blocks:**
- Ad networks (doubleclick.net, googlesyndication.com)
- Tracking pixels (facebook pixel, google analytics)
- Malware domains
- Crypto miners
- Adult content (if enabled)

**What it doesn't break:**
- Normal browsing
- Streaming services
- Online shopping
- Banking

**Occasional issues:**
- Some sites detect ad blocking (rare)
- Shopping cashback trackers (can whitelist)
- Some email tracking pixels

---

## 🎯 Quick Commands Reference

**Check current DNS:**
\`\`\`bash
networksetup -getdnsservers "Wi-Fi"
\`\`\`

**Set DNS to AdGuard:**
\`\`\`bash
sudo networksetup -setdnsservers "Wi-Fi" ${MAC_IP}
\`\`\`

**Set DNS to public (bypass AdGuard):**
\`\`\`bash
sudo networksetup -setdnsservers "Wi-Fi" 1.1.1.1 8.8.8.8
\`\`\`

**Reset to automatic (DHCP):**
\`\`\`bash
sudo networksetup -setdnsservers "Wi-Fi" empty
\`\`\`

**Test DNS resolution:**
\`\`\`bash
nslookup google.com
nslookup ads.google.com  # Should be blocked
\`\`\`

**Check AdGuard status:**
\`\`\`bash
docker ps | grep adguard
docker logs adguard --tail 50
\`\`\`

---

## 💡 Pro Tips

1. **Whitelist Important Domains:**
   - If a site breaks, check Query Log
   - Find blocked domain
   - Add to whitelist

2. **Different Profiles:**
   - Create different DNS profiles for different needs
   - "Work" - less blocking
   - "Kids" - strict filtering

3. **Mobile Access:**
   - Use Tailscale + AdGuard
   - Set phone DNS to Tailscale IP
   - Ad blocking even on mobile data!

4. **Monitor Dashboard:**
   - Check weekly for blocked threats
   - See which devices query most
   - Identify problematic apps

5. **Backup Config:**
   - Settings → General → Export settings
   - Save config file
   - Easy restore if needed

---

## ✅ Verification Checklist

- [ ] DNS set to Mac IP (${MAC_IP}), not 127.0.0.1
- [ ] Can access http://localhost:8084
- [ ] Can access http://${MAC_IP}:8084
- [ ] Can browse websites normally
- [ ] AdGuard Query Log shows activity
- [ ] Dashboard shows blocked queries (10-30%)
- [ ] Tested ad-heavy site (fewer ads)
- [ ] Other devices configured (optional)
- [ ] Static IP reserved in router (recommended)

---

**You're now protected from ads, tracking, and malware! 🎉**

EOF

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Quick Fix Instructions${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Step 1: Fix your DNS right now${NC}"
echo ""
echo "Run this command:"
echo -e "${CYAN}sudo networksetup -setdnsservers \"Wi-Fi\" ${MAC_IP}${NC}"
echo ""
echo "Or if using Ethernet:"
echo -e "${CYAN}sudo networksetup -setdnsservers \"Ethernet\" ${MAC_IP}${NC}"
echo ""

echo -e "${YELLOW}Step 2: Verify it worked${NC}"
echo ""
echo "Run this:"
echo -e "${CYAN}networksetup -getdnsservers \"Wi-Fi\"${NC}"
echo ""
echo "Should show: ${MAC_IP}"
echo ""

echo -e "${YELLOW}Step 3: Test AdGuard${NC}"
echo ""
echo "1. Open: http://localhost:8084"
echo "2. Visit any website"
echo "3. Check Query Log in AdGuard - should see blocked requests"
echo ""

echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Complete Guide Created${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "View complete guide:"
echo "  open ~/HomeLab/docs/ADGUARD_SETUP.md"
echo ""

echo -e "${RED}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${RED}  KEY LESSON${NC}"
echo -e "${RED}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "❌ Never use: 127.0.0.1 or localhost as DNS"
echo "✅ Always use: Your Mac's actual IP (${MAC_IP})"
echo ""
echo "Why? DNS needs to resolve 'localhost' - can't use localhost as DNS!"
echo ""