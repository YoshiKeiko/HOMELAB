#!/bin/bash

################################################################################
# Setup FlareSolverr to Bypass Cloudflare Protection
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         SETUP FLARESOLVERR (CLOUDFLARE BYPASS)                ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

COMPOSE_FILE="$HOME/HomeLab/Docker/Compose/media.yml"

log_step "Step 1: Adding FlareSolverr to docker-compose..."
echo ""

# Check if FlareSolverr already exists
if grep -q "flaresolverr:" "$COMPOSE_FILE"; then
    log_info "FlareSolverr already in compose file"
else
    log_info "Adding FlareSolverr..."
    
    # Backup
    cp "$COMPOSE_FILE" "$COMPOSE_FILE.backup-flare-$(date +%Y%m%d-%H%M%S)"
    
    # Detect AdGuard
    if docker ps | grep -q adguard; then
        ADGUARD_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' adguard)
        log_info "Using AdGuard DNS: $ADGUARD_IP"
        DNS_CONFIG="    dns:
      - $ADGUARD_IP
      - 1.1.1.1
      - 8.8.8.8"
    else
        DNS_CONFIG="    dns:
      - 1.1.1.1
      - 8.8.8.8"
    fi
    
    # Create temp file with FlareSolverr
    cat > /tmp/flaresolverr_service.yml << EOFFLARE

  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    restart: unless-stopped
    ports:
      - "8191:8191"
    environment:
      - LOG_LEVEL=info
      - LOG_HTML=false
      - CAPTCHA_SOLVER=none
      - TZ=Europe/London
    networks:
      - homelab-net
$DNS_CONFIG
    extra_hosts:
      - "host.docker.internal:host-gateway"
EOFFLARE

    # Insert before networks section
    awk '
    /^networks:/ && !inserted { 
        system("cat /tmp/flaresolverr_service.yml")
        inserted=1
    }
    { print }
    ' "$COMPOSE_FILE" > "$COMPOSE_FILE.tmp" && mv "$COMPOSE_FILE.tmp" "$COMPOSE_FILE"
    
    log_info "FlareSolverr added to compose file"
fi

echo ""

log_step "Step 2: Starting FlareSolverr..."
echo ""

cd ~/HomeLab/Docker/Compose
docker compose -f media.yml up -d flaresolverr

sleep 5

if docker ps | grep -q flaresolverr; then
    log_info "FlareSolverr is running"
else
    log_error "FlareSolverr failed to start"
    docker logs flaresolverr --tail 30
    exit 1
fi

echo ""

log_step "Step 3: Testing FlareSolverr..."
echo ""

# Test if FlareSolverr is responding
if curl -s http://localhost:8191 | grep -q "FlareSolverr"; then
    log_info "FlareSolverr is responding"
else
    log_error "FlareSolverr not responding on port 8191"
fi

echo ""

log_step "Step 4: Configuration instructions..."
echo ""

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║              CONFIGURE FLARESOLVERR IN PROWLARR               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

cat > "$HOME/HomeLab/docs/FLARESOLVERR_SETUP.md" << 'EOFGUIDE'
# 🔥 FlareSolverr Setup in Prowlarr

FlareSolverr bypasses Cloudflare protection on indexer sites.

## ✅ Step 1: Create FlareSolverr Tag

**In Prowlarr:** http://localhost:9696

1. **Settings** → **Tags**
2. Click **"+"** (Add new tag)
3. **Label:** `cloudflare` (or `flaresolverr`)
4. Click **✓** to save

✅ Tag created!

---

## ✅ Step 2: Add FlareSolverr as Indexer Proxy

**Still in Settings:**

1. **Settings** → **Indexers** → **Proxies** tab (at top)
2. Click **"+"** (Add proxy)
3. Select **"FlareSolverr"**

**Configure:**

| Field | Value |
|-------|-------|
| **Name** | FlareSolverr |
| **Tags** | Select `cloudflare` (or `flaresolverr`) |
| **Host** | `http://flaresolverr:8191/` |
| **Request Timeout** | 60 |

4. Click **"Test"**
   - Should show: ✅ "Test successful"

5. Click **"Save"**

✅ FlareSolverr proxy configured!

---

## ✅ Step 3: Apply Tag to Cloudflare-Blocked Indexers

**For EACH indexer that's blocked by Cloudflare:**

### Apply to 1337x:

1. **Indexers** → Click on **"1337x"**
2. Scroll to **Tags** section
3. Select: `cloudflare` (or `flaresolverr`)
4. Click **"Test"**
   - Should now work! ✅
5. Click **"Save"**

### Apply to Other Blocked Indexers:

Repeat for any indexer showing Cloudflare errors:
- TorrentGalaxy (if blocked)
- The Pirate Bay (if blocked)
- Kickass Torrents (if blocked)
- Any others showing Cloudflare challenge

**Just add the tag, test, save!**

---

## ✅ Step 4: Test Indexers

**Test each indexer:**

1. Go to indexer
2. Click **"Test"**
3. Should show ✅ green checkmark
4. No more Cloudflare errors!

**Test search:**

1. Click **Search** (top right in Prowlarr)
2. Search: "Inception"
3. Should see results from all indexers including 1337x!

---

## 🎯 Which Indexers Need FlareSolverr?

### Usually Need It:
- ✅ **1337x** (always)
- ✅ **The Pirate Bay** (often)
- ✅ **Kickass Torrents** (often)
- ✅ **TorrentGalaxy** (sometimes)

### Usually Don't Need It:
- ❌ **EZTV** (no Cloudflare)
- ❌ **YTS** (no Cloudflare)
- ❌ **Nyaa** (no Cloudflare)
- ❌ **Torlock** (no Cloudflare)

**Apply the tag only to indexers that fail without it!**

---

## 💡 Quick Apply Method

**To apply FlareSolverr tag to ALL indexers at once:**

1. **Indexers** tab
2. Select checkboxes for all indexers
3. Click **"Mass Editor"** (bottom)
4. **Tags** → Add → `cloudflare`
5. Click **"Apply"**

**This applies FlareSolverr to everything!**

(But individually is better - only use where needed)

---

## 🔍 Verify It's Working

### Check Indexer Status:

**Settings → Indexers**

All indexers should show:
- ✅ Green status
- ✅ Last query time (recent)
- ✅ No Cloudflare errors

### Test Real Search:

**In Radarr:** http://localhost:7878

1. **Movies** → **Add New**
2. Search: "Inception"
3. Add movie
4. Click **magnifying glass** (manual search)
5. Should see results from 1337x and others! 🎉

---

## 🚨 Troubleshooting

### FlareSolverr Not Connecting

**Check it's running:**
```bash
docker ps | grep flaresolverr
```

**Check logs:**
```bash
docker logs flaresolverr --tail 50
```

**Test URL:**
```bash
curl http://localhost:8191
```
Should return HTML with "FlareSolverr"

**Restart if needed:**
```bash
docker restart flaresolverr
```

### Indexers Still Failing

**1. Check tag is applied:**
   - Indexers → Click indexer → Tags section
   - Should have `cloudflare` tag

**2. Check proxy is configured:**
   - Settings → Indexers → Proxies
   - Should see FlareSolverr with test successful

**3. Increase timeout:**
   - Edit FlareSolverr proxy
   - Request Timeout: 90 seconds
   - Save and test

**4. Check FlareSolverr logs:**
   - Look for actual request attempts
   - Should show solving challenges

### "Too Many Requests" Error

FlareSolverr has rate limits:

**Solution:** Add delay between requests
- Settings → Indexers → [Indexer]
- Query Limit: Reduce to 50
- Grab Limit: Reduce to 20

---

## ⚙️ Advanced Configuration

### FlareSolverr Environment Variables

**Edit in docker-compose if needed:**

```yaml
environment:
  - LOG_LEVEL=info          # Or: debug (more logs)
  - LOG_HTML=false          # Set true to debug
  - CAPTCHA_SOLVER=none     # Or: harvester, hcaptcha-solver
  - TZ=Europe/London
  - HEADLESS=true           # Don't change
```

**Restart after changes:**
```bash
docker compose -f ~/HomeLab/Docker/Compose/media.yml restart flaresolverr
```

---

## 📊 FlareSolverr Status

**Check if working:**

Visit: http://localhost:8191

Should show:
```
FlareSolverr v3.x.x

Status: OK
Sessions: 0
```

**View in Prowlarr logs:**

When indexers use FlareSolverr, you'll see in Prowlarr logs:
```
Using FlareSolverr proxy for 1337x
Challenge solved successfully
```

---

## ✅ Complete Setup Checklist

- [ ] FlareSolverr container running
- [ ] Port 8191 accessible (http://localhost:8191)
- [ ] Tag created in Prowlarr (`cloudflare`)
- [ ] FlareSolverr proxy added in Prowlarr
- [ ] Proxy test successful
- [ ] Tag applied to 1337x
- [ ] 1337x test successful (no Cloudflare error)
- [ ] Tag applied to other blocked indexers
- [ ] All indexers show green status
- [ ] Test search returns results from all indexers
- [ ] Radarr can search and find content

---

## 🎉 Success!

**You can now use ANY indexer, even if protected by Cloudflare!**

**Common Cloudflare-protected sites that now work:**
- ✅ 1337x
- ✅ The Pirate Bay
- ✅ Kickass Torrents
- ✅ TorrentGalaxy
- ✅ Many others!

**Your indexers are now unstoppable!** 🔥

EOFGUIDE

echo "Complete guide created at:"
echo "  ~/HomeLab/docs/FLARESOLVERR_SETUP.md"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${CYAN}CONFIGURE IN PROWLARR NOW${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "${YELLOW}Step 1: Create Tag${NC}"
echo "  1. Open Prowlarr: ${CYAN}http://localhost:9696${NC}"
echo "  2. Settings → Tags → Add"
echo "  3. Name: ${CYAN}cloudflare${NC}"
echo "  4. Save"
echo ""

echo "${YELLOW}Step 2: Add FlareSolverr Proxy${NC}"
echo "  1. Settings → Indexers → Proxies tab"
echo "  2. Click '+' → Select FlareSolverr"
echo "  3. Configure:"
echo "     Name: FlareSolverr"
echo "     Tags: cloudflare"
echo "     Host: ${CYAN}http://flaresolverr:8191/${NC}"
echo "     Timeout: 60"
echo "  4. Test → Should succeed ✅"
echo "  5. Save"
echo ""

echo "${YELLOW}Step 3: Apply to 1337x${NC}"
echo "  1. Indexers → Click '1337x'"
echo "  2. Tags: Add '${CYAN}cloudflare${NC}'"
echo "  3. Test → Should work now! ✅"
echo "  4. Save"
echo ""

echo "${YELLOW}Step 4: Repeat for Other Blocked Indexers${NC}"
echo "  - Add '${CYAN}cloudflare${NC}' tag to:"
echo "    • The Pirate Bay (if blocked)"
echo "    • Kickass Torrents (if blocked)"
echo "    • TorrentGalaxy (if blocked)"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${GREEN}Quick Test${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "After configuration:"
echo "  1. Prowlarr → Search → 'Inception'"
echo "  2. Should see results from 1337x! 🎉"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ${MAGENTA}FlareSolverr Status${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if docker ps | grep -q flaresolverr; then
    echo "FlareSolverr: ${GREEN}RUNNING${NC} ✅"
    echo "Web interface: ${CYAN}http://localhost:8191${NC}"
    echo "Container logs: ${CYAN}docker logs flaresolverr${NC}"
else
    echo "FlareSolverr: ${RED}NOT RUNNING${NC} ❌"
    echo "Start with: ${CYAN}docker start flaresolverr${NC}"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "${GREEN}✓ FlareSolverr setup complete!${NC}"
echo ""
echo "Now configure in Prowlarr (see steps above)"
echo "Full guide: ${CYAN}open ~/HomeLab/docs/FLARESOLVERR_SETUP.md${NC}"
echo ""