#!/bin/bash

################################################################################
# AdGuard Parental Controls + Sky Shield Integration Guide
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
echo "  AdGuard Parental Controls + Sky Shield Guide"
echo "═══════════════════════════════════════════════════════════════"
echo ""

MAC_IP=$(ifconfig | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

cat > "$HOME/HomeLab/docs/ADGUARD_PARENTAL_CONTROLS.md" << 'EOF'
# 🛡️ AdGuard Parental Controls + Sky Shield Integration

## 🎯 Quick Answers

### Does AdGuard Block Adult Content?

**Out of the box: NO** ❌  
**With configuration: YES** ✅

AdGuard Home focuses on **ads and tracking** by default.  
You need to enable **Parental Control** features manually.

### Sky Shield vs AdGuard

| Feature | Sky Shield | AdGuard (configured) |
|---------|-----------|----------------------|
| **Adult content** | ✅ Yes | ✅ Yes (after setup) |
| **Malware** | ✅ Yes | ✅ Yes |
| **Phishing** | ✅ Yes | ✅ Yes |
| **Ad blocking** | ❌ No | ✅ Yes |
| **Custom controls** | ❌ Limited | ✅ Extensive |
| **Works offline** | ❌ No | ✅ Yes (local) |

**Good news:** You can have BOTH! Keep Sky Shield as backup!

---

## 🔧 Part 1: Enable Parental Controls in AdGuard

### Step 1: Access AdGuard Home

Open: http://localhost:8084

### Step 2: Enable Safe Browsing

1. **Settings** (left sidebar)
2. **General Settings**
3. Scroll to **"Safe Browsing"** section
4. Enable these:
   - ✅ **Use AdGuard browsing security web service**
   - ✅ **Use AdGuard parental control web service**

**What this does:**
- Blocks malware sites
- Blocks phishing sites  
- Blocks adult content sites

### Step 3: Enable Parental Control Blocklists

1. **Filters** (left sidebar)
2. **DNS blocklists**
3. Click **"Add blocklist"**
4. Add these family-friendly lists:

**Essential Parental Control Lists:**

**1. AdGuard DNS Family Protection filter**
```
https://adguardteam.github.io/AdGuardSDNSFilter/Filters/adguard_family_filter.txt
```
- Blocks adult content
- Blocks dating sites
- Blocks gambling

**2. Family Friendly filter by CleanBrowsing**
```
https://raw.githubusercontent.com/paulgb/BarbBlock/master/BarbBlock.txt
```

**3. CPBF - Cyber Threat Coalition**
```
https://threatfox.abuse.ch/downloads/hostfile/
```
- Blocks malware
- Blocks phishing

**4. Peter Lowe's Adult filter**
```
https://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblock&showintro=0&mimetype=plaintext
```

**5. OISD Big List (includes adult sites)**
```
https://big.oisd.nl/
```
- Comprehensive blocking
- Regularly updated

### Step 4: Enable Safe Search

1. **Settings** → **General Settings**
2. Scroll to **"Parental Control"**
3. Enable:
   - ✅ **Enforce Safe Search on Google**
   - ✅ **Enforce Safe Search on Bing**
   - ✅ **Enforce Safe Search on YouTube**
   - ✅ **Enforce Safe Search on DuckDuckGo**

**What this does:**
- Google: Filters adult images/videos
- YouTube: Restricted mode (no age-restricted content)
- Bing: Strict filtering
- All search engines: Safer results

### Step 5: Block Services (Optional)

1. **Filters** → **Blocked Services**
2. Block categories you want:
   - Dating sites
   - Social media (TikTok, Snapchat for kids)
   - Gaming (during homework hours)
   - Adult content services

### Step 6: Custom Blocklist

Add specific sites you want blocked:

1. **Filters** → **Custom filtering rules**
2. Add rules like:
```
||pornhub.com^
||xvideos.com^
||xnxx.com^
||reddit.com/r/nsfw^
```

Or block entire categories:
```
||*.xxx^
||*.porn^
||*.adult^
```

---

## 🌐 Part 2: DNS Configuration with Sky

### Understanding Your Setup

You have TWO internet connections:

**Sky Broadband:**
- Sky Router: **192.168.50.1**
- Sky Shield built-in
- Your old connection

**CityFibre (New):**
- TP-Link Deco: **192.168.68.1**
- Your current network
- Faster (5Gbps!)

### Option 1: Keep Sky Shield as Backup (RECOMMENDED)

**Deco DNS Configuration:**
```
Primary DNS:   MAC_IP_PLACEHOLDER    (AdGuard - blocks ads + adult)
Secondary DNS: 192.168.50.1          (Sky Shield - adult filtering backup)
```

**Why this is BEST:**

✅ **When Mac is running:**
- All traffic → AdGuard
- Blocks ads + tracking + adult content
- Fast (local)

✅ **When Mac is down/rebooting:**
- Traffic → Sky Shield
- Still blocks adult content
- No ads blocked, but protection maintained

✅ **Double protection:**
- AdGuard might miss something → Sky catches it
- Sky Shield might miss something → AdGuard catches it

### Option 2: Use Deco as Backup

**Deco DNS Configuration:**
```
Primary DNS:   MAC_IP_PLACEHOLDER    (AdGuard)
Secondary DNS: 192.168.68.1          (Deco)
```

**Result:**
- When Mac down → uses Deco's DNS (usually ISP default)
- No filtering when Mac down ❌
- Less protection

**Don't use this unless Sky router is disconnected!**

### Option 3: Use Cloudflare Family

**Deco DNS Configuration:**
```
Primary DNS:   MAC_IP_PLACEHOLDER    (AdGuard)
Secondary DNS: 1.1.1.3               (Cloudflare for Families - blocks malware + adult)
```

**Alternative:**
```
Primary DNS:   MAC_IP_PLACEHOLDER    (AdGuard)
Secondary DNS: 1.1.1.2               (Cloudflare for Families - blocks malware only)
```

**Result:**
- When Mac down → Cloudflare filters
- Still blocks adult content ✅
- No ads blocked
- Fast, reliable

---

## 🏆 RECOMMENDED SETUP

### Best Configuration for Your Situation

**Deco DNS Settings:**
```
Primary DNS:   MAC_IP_PLACEHOLDER    (Your Mac - AdGuard with parental controls)
Secondary DNS: 192.168.50.1          (Sky Shield - backup filtering)
```

**OR if Sky router not connected:**
```
Primary DNS:   MAC_IP_PLACEHOLDER    (Your Mac - AdGuard with parental controls)
Secondary DNS: 1.1.1.3               (Cloudflare Family - blocks malware + adult)
```

### Configure in Deco App

1. **Open Deco app**
2. **More** → **Advanced** → **DHCP Server**
3. **Primary DNS:** `MAC_IP_PLACEHOLDER`
4. **Secondary DNS:** `192.168.50.1` or `1.1.1.3`
5. **Save**

---

## 🧪 Testing Parental Controls

### Test 1: Adult Content Blocking

**Try accessing blocked sites (use a device in incognito/private mode):**

**Should be BLOCKED:**
- pornhub.com
- xvideos.com
- Any .xxx domain
- Reddit NSFW sections

**Result page should show:**
- AdGuard blocked message
- Or blank page
- Check AdGuard Query Log → shows as blocked (red)

### Test 2: Safe Search

**Google:**
1. Search for anything
2. Add `&safe=off` to URL
3. Should redirect to safe search anyway

**YouTube:**
1. Try accessing age-restricted video
2. Should show "Restricted mode" message

### Test 3: Check AdGuard Logs

1. Open http://localhost:8084
2. **Query Log**
3. Browse normally on any device
4. Look for RED entries (blocked)
5. Should see adult sites blocked

### Test 4: Test Failover

**With Sky Shield as secondary:**
1. Stop Mac: `sudo shutdown -h now`
2. Try accessing blocked adult site on phone
3. Should STILL be blocked (Sky Shield working!)
4. Start Mac
5. Check AdGuard logs - should resume blocking

---

## 👨‍👩‍👧‍👦 Advanced Parental Controls

### Per-Device Profiles

**Kids' devices get stricter filtering:**

1. **AdGuard → Filters → Custom rules**
2. Add device-specific rules:

```
# Block social media for kids' iPad (IP: 192.168.68.50)
[/192.168.68.50/]facebook.com^
[/192.168.68.50/]instagram.com^
[/192.168.68.50/]tiktok.com^
[/192.168.68.50/]snapchat.com^
```

**Your devices get normal filtering:**
- No social media blocking
- Adult content still blocked
- Ads blocked

### Time-Based Blocking

**Block gaming sites during homework hours:**

Unfortunately, AdGuard doesn't support time-based rules directly.

**Workaround options:**

**Option 1: Use Home Assistant**
1. Create automation in Home Assistant
2. Time trigger: 3 PM (after school)
3. Action: Block gaming IPs in AdGuard
4. Time trigger: 8 PM (after homework)
5. Action: Unblock gaming IPs

**Option 2: Use Deco Parental Controls**
1. Deco app → Profiles
2. Create "Kids" profile
3. Assign kids' devices
4. Set time limits for specific sites/categories
5. Works alongside AdGuard!

### Website Whitelist

**Allow specific sites that get falsely blocked:**

1. **Settings** → **DNS allowlists**
2. Add domains you trust:
```
example-educational-site.com
kids-safe-game.com
```

---

## 📊 Comparing Filtering Levels

### Level 1: No Filtering
**DNS:** ISP default (1.1.1.1)
- ❌ No ad blocking
- ❌ No adult content blocking
- ❌ No malware protection

### Level 2: Ad Blocking Only
**DNS:** AdGuard (default config)
- ✅ Blocks ads
- ✅ Blocks tracking
- ❌ No adult content blocking

### Level 3: Sky Shield
**DNS:** 192.168.50.1
- ❌ No ad blocking
- ✅ Blocks adult content
- ✅ Blocks malware
- ✅ ISP-level filtering

### Level 4: AdGuard + Parental Controls (RECOMMENDED)
**DNS:** AdGuard (with config from this guide)
- ✅ Blocks ads
- ✅ Blocks tracking
- ✅ Blocks adult content
- ✅ Blocks malware
- ✅ Blocks phishing
- ✅ Safe Search enforced
- ✅ Customizable

### Level 5: Layered Defense (BEST)
**DNS:** AdGuard (primary) + Sky Shield (secondary)
- ✅ Everything from Level 4
- ✅ Backup filtering when Mac down
- ✅ Double protection layer
- ✅ Sky Shield catches what AdGuard misses

---

## 🔍 What Gets Blocked?

### With Full Configuration

**Adult Content:**
- ✅ Pornographic websites
- ✅ Adult video sites
- ✅ Explicit image sites
- ✅ Dating/hookup sites
- ✅ .xxx domains
- ✅ NSFW Reddit/social media

**Gambling:**
- ✅ Online casinos
- ✅ Betting sites
- ✅ Poker sites

**Malware & Threats:**
- ✅ Known malware sites
- ✅ Phishing sites
- ✅ Scam sites
- ✅ Crypto-mining sites

**Ads & Tracking:**
- ✅ Ad networks
- ✅ Tracking pixels
- ✅ Analytics (optional)
- ✅ Pop-ups

**Optional (if you configure):**
- ⚙️ Social media
- ⚙️ Gaming sites
- ⚙️ Video streaming
- ⚙️ Specific sites you choose

### What DOESN'T Get Blocked

**Normal websites:**
- ✅ News sites (BBC, CNN, etc.)
- ✅ Shopping (Amazon, eBay)
- ✅ Banking
- ✅ Email
- ✅ Education sites
- ✅ Work sites

**Encrypted content:**
- ⚠️ HTTPS content inside apps (WhatsApp messages, etc.)
- ⚠️ VPN traffic (bypasses AdGuard)
- ⚠️ Tor browser (bypasses filtering)

**Note:** DNS filtering can't see inside encrypted connections, only domain names.

---

## 🚸 Managing Kids' Access

### Transparent Approach (Recommended)

**Tell kids about filtering:**
- Explain why it's there
- Show them AdGuard dashboard
- Discuss what's blocked and why
- Build digital literacy

### Monitoring Without Invading Privacy

**AdGuard Query Log shows:**
- ✅ Which device accessed what
- ✅ What got blocked
- ✅ When it happened

**What you CAN'T see:**
- ❌ Content of messages
- ❌ What's inside encrypted sites
- ❌ App-specific content

**Privacy balance:**
- See domains (google.com, youtube.com)
- Don't see specifics (which video, which search)

### Teaching Moments

**When something gets blocked:**
1. Check Query Log
2. See what was blocked
3. Discuss with kids if appropriate
4. Whitelist if it was false positive

---

## 🔧 Troubleshooting

### Adult Site Not Getting Blocked

**Check:**
1. AdGuard running? `docker ps | grep adguard`
2. Filters enabled? Settings → DNS blocklists
3. Safe Browsing enabled? Settings → General
4. DNS correct? `networksetup -getdnsservers "Wi-Fi"`
5. Browser not using VPN/proxy?

**Fix:**
- Add site manually to blocklist
- Update filters (Settings → General → Update)
- Clear browser cache

### Legitimate Site Getting Blocked

**Example:** Educational site incorrectly flagged

**Fix:**
1. Settings → DNS allowlists
2. Add domain
3. Or disable specific filter temporarily

### Kids Bypassing Filter

**Common methods:**

**1. VPN/Proxy:**
- Block VPN apps/sites in Blocked Services
- Or disable VPN on kids' devices

**2. Mobile Data:**
- Turn off mobile data on kids' devices
- Or configure their phone to use Mac as DNS even on mobile data

**3. Changing DNS on Device:**
- Use Deco Parental Controls to lock settings
- Or admin password on kids' devices

---

## 📱 Per-Device Configuration

### Kids' Devices

**Stricter filtering:**
- All adult content blocked
- Safe Search enforced
- Social media limited
- Gaming sites time-limited (via Deco)

### Your Devices

**Standard filtering:**
- Adult content blocked (you choose level)
- Ads blocked
- Normal browsing not affected

### Guest Network

**Basic filtering:**
- Adult content blocked
- Ads blocked
- No personal data tracked

---

## ✅ Setup Checklist

### AdGuard Configuration
- [ ] Safe Browsing enabled
- [ ] Parental Control web service enabled
- [ ] Family-friendly blocklists added
- [ ] Safe Search enforced
- [ ] Custom adult site rules added
- [ ] Tested blocking works

### Network Configuration
- [ ] Deco Primary DNS: MAC_IP_PLACEHOLDER
- [ ] Deco Secondary DNS: 192.168.50.1 or 1.1.1.3
- [ ] All devices using correct DNS
- [ ] Tested failover to secondary DNS

### Testing
- [ ] Adult sites blocked
- [ ] Safe Search working
- [ ] Legitimate sites work
- [ ] Ads blocked
- [ ] Query Log shows activity
- [ ] Kids' devices properly filtered

### Monitoring
- [ ] Know how to check Query Log
- [ ] Set up regular filter updates
- [ ] Discussed filtering with family
- [ ] Whitelist process defined

---

## 🎯 Summary

### Your Final Configuration

**DNS Setup:**
```
Primary:   MAC_IP_PLACEHOLDER (AdGuard - full filtering)
Secondary: 192.168.50.1 (Sky Shield - backup filtering)
```

**AdGuard Blocks:**
- ✅ Ads and tracking
- ✅ Adult content
- ✅ Malware and phishing
- ✅ Gambling
- ✅ Custom blocklists

**Sky Shield Provides:**
- ✅ Backup filtering when Mac down
- ✅ ISP-level protection
- ✅ Additional safety layer

**Result:**
- 🛡️ Better than Sky Shield alone (blocks ads too)
- 🛡️ Better than AdGuard alone (backup when Mac down)
- 🛡️ Double-layer protection
- 🛡️ Customizable per-device

**You have the BEST of both worlds! 🎉**

---

## 📞 Quick Reference

**Access AdGuard:**
```
http://localhost:8084
```

**Check DNS:**
```bash
networksetup -getdnsservers "Wi-Fi"
```

**Test blocking:**
```bash
nslookup blocked-site.com
# Should return blocked IP or error
```

**View logs:**
- AdGuard → Query Log
- Filter by device
- See what's blocked

**Update filters:**
- Settings → General → Check for updates

---

**Your family is now protected! 🛡️👨‍👩‍👧‍👦**

EOF

# Replace MAC_IP_PLACEHOLDER
sed -i '' "s/MAC_IP_PLACEHOLDER/${MAC_IP}/g" "$HOME/HomeLab/docs/ADGUARD_PARENTAL_CONTROLS.md"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Complete Guide Created!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "View complete guide:"
echo "  ${CYAN}open ~/HomeLab/docs/ADGUARD_PARENTAL_CONTROLS.md${NC}"
echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}  Quick Answer:${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${RED}AdGuard does NOT block adult content by default!${NC}"
echo ""
echo "You need to enable Parental Controls:"
echo ""
echo "1. Open AdGuard: ${CYAN}http://localhost:8084${NC}"
echo "2. Settings → General Settings"
echo "3. Enable:"
echo "   ✅ Use AdGuard browsing security"
echo "   ✅ Use AdGuard parental control"
echo "4. Filters → DNS blocklists → Add family filters"
echo "5. Settings → Enforce Safe Search (Google, YouTube, etc.)"
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  DNS Configuration - RECOMMENDED:${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Deco DNS Settings:"
echo "  Primary:   ${CYAN}${MAC_IP}${NC}  (AdGuard - ads + adult + malware)"
echo "  Secondary: ${CYAN}192.168.50.1${NC}  (Sky Shield - backup filtering)"
echo ""
echo -e "${BLUE}Why this is BEST:${NC}"
echo "  ✅ Mac running = AdGuard blocks everything"
echo "  ✅ Mac down = Sky Shield still protects"
echo "  ✅ Double layer protection"
echo "  ✅ You keep Sky Shield filtering"
echo ""
echo -e "${YELLOW}Alternative (if Sky router disconnected):${NC}"
echo "  Secondary: ${CYAN}1.1.1.3${NC}  (Cloudflare Family - malware + adult)"
echo ""
echo -e "${RED}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${RED}  DON'T use 192.168.68.1 (Deco) as secondary!${NC}"
echo -e "${RED}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Deco doesn't filter anything - it just passes to ISP DNS"
echo "You'd lose ALL filtering when Mac is down!"
echo ""
echo "Use Sky Shield (192.168.50.1) or Cloudflare (1.1.1.3) instead."
echo ""