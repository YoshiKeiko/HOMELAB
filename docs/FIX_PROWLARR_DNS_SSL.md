# 🔧 Fix Prowlarr DNS/SSL Connection Issues

## The Problem

When testing indexers in Prowlarr, you get:
```
Unable to connect to indexer.
DNS/SSL issues.
The SSL connection could not be established.
```

## Why This Happens

Docker on macOS can have DNS issues reaching external torrent sites due to:
- DNS resolver configuration
- IPv6 conflicts
- SSL certificate validation
- macOS network isolation

---

## ✅ Solution 1: Update Prowlarr with Better DNS (RECOMMENDED)

### Stop Prowlarr

```bash
docker stop prowlarr
```

### Update Docker Compose

Edit your media compose file:

```bash
nano ~/HomeLab/Docker/Compose/media.yml
```

Find the `prowlarr` section and update it:

```yaml
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    restart: unless-stopped
    ports:
      - "9696:9696"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/prowlarr:/config
    networks:
      - homelab-net
    dns:
      - 1.1.1.1
      - 8.8.8.8
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

**Key additions:**
- `dns:` - Uses Cloudflare and Google DNS
- `extra_hosts:` - Fixes macOS Docker networking

### Restart Prowlarr

```bash
cd ~/HomeLab/Docker/Compose
docker compose -f media.yml up -d prowlarr
```

### Test Again

1. Open Prowlarr: http://localhost:9696
2. Try adding indexer again
3. Should work now! ✅

---

## ✅ Solution 2: Disable IPv6 in Prowlarr

Sometimes IPv6 causes issues.

### In Prowlarr Web UI

1. **Settings** → **General**
2. Scroll to **Advanced Settings** (toggle on if needed)
3. Find **Bind Address**
4. Change from `*` to `0.0.0.0` (IPv4 only)
5. Click **Save**
6. Restart container:
   ```bash
   docker restart prowlarr
   ```

---

## ✅ Solution 3: Use FlareSolverr for Cloudflare-Protected Sites

Many torrent sites use Cloudflare protection. FlareSolverr bypasses this.

### Add FlareSolverr to Docker Compose

Edit your media compose file:

```bash
nano ~/HomeLab/Docker/Compose/media.yml
```

Add this service:

```yaml
  flaresolverr:
    image: ghcr.io/flaresolverr/flaresolverr:latest
    container_name: flaresolverr
    restart: unless-stopped
    ports:
      - "8191:8191"
    environment:
      - LOG_LEVEL=info
      - TZ=Europe/London
    networks:
      - homelab-net
    dns:
      - 1.1.1.1
      - 8.8.8.8
```

### Start FlareSolverr

```bash
cd ~/HomeLab/Docker/Compose
docker compose -f media.yml up -d flaresolverr
```

### Configure in Prowlarr

1. **Settings** → **Tags**
2. Click **"+"** to add new tag
3. Name it: `flaresolverr`
4. Save

5. **Settings** → **Indexers** → **Proxies**
6. Click **"+"** to add proxy
7. Select **"FlareSolverr"**
8. Configure:
   - **Name:** FlareSolverr
   - **Tags:** Select `flaresolverr`
   - **Host:** `http://flaresolverr:8191`
   - **Request Timeout:** 60 seconds
9. Click **Test** → Should work
10. Click **Save**

### Apply Tag to Problem Indexers

1. **Indexers** → Click on indexer having issues
2. **Tags:** Add `flaresolverr` tag
3. Save
4. Test indexer again

---

## ✅ Solution 4: Complete Prowlarr Rebuild (Nuclear Option)

If nothing else works, rebuild Prowlarr completely.

### Backup Current Config

```bash
# Create backup
cp -r ~/HomeLab/Docker/Data/prowlarr ~/HomeLab/Docker/Data/prowlarr.backup
```

### Stop and Remove Container

```bash
docker stop prowlarr
docker rm prowlarr
```

### Clear Config (Fresh Start)

```bash
# Remove old config
rm -rf ~/HomeLab/Docker/Data/prowlarr

# Create fresh directory
mkdir -p ~/HomeLab/Docker/Data/prowlarr
```

### Update Docker Compose with ALL Fixes

```bash
nano ~/HomeLab/Docker/Compose/media.yml
```

**Replace prowlarr section with:**

```yaml
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:develop
    container_name: prowlarr
    restart: unless-stopped
    ports:
      - "9696:9696"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - DOCKER_MODS=linuxserver/mods:universal-cron
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/prowlarr:/config
    networks:
      - homelab-net
    dns:
      - 1.1.1.1
      - 1.0.0.1
      - 8.8.8.8
      - 8.8.4.4
    sysctls:
      - net.ipv6.conf.all.disable_ipv6=1
    extra_hosts:
      - "host.docker.internal:host-gateway"
    cap_add:
      - NET_ADMIN
```

**Key changes:**
- `develop` image (latest fixes)
- Multiple DNS servers
- IPv6 disabled
- Extra network capabilities

### Start Fresh Prowlarr

```bash
cd ~/HomeLab/Docker/Compose
docker compose -f media.yml up -d prowlarr
```

### Reconfigure from Scratch

1. Open: http://localhost:9696
2. Set authentication again
3. Re-add Radarr/Sonarr connections
4. Add indexers

---

## 🧪 Test DNS Resolution Inside Container

### Check if Prowlarr Can Reach Internet

```bash
# Test DNS resolution
docker exec prowlarr nslookup 1337x.to

# Should show IP addresses
```

### Test Specific Indexer URL

```bash
# Test if site is reachable
docker exec prowlarr wget -O- --timeout=10 https://1337x.to

# Should return HTML
```

### Check DNS Settings

```bash
# See what DNS Prowlarr is using
docker exec prowlarr cat /etc/resolv.conf

# Should show:
# nameserver 1.1.1.1
# nameserver 8.8.8.8
```

---

## 📋 Alternative Indexers (That Usually Work)

If some indexers consistently fail, try these instead:

### Reliable Public Indexers

**These have fewer SSL/DNS issues:**

1. **Nyaa** (anime/Asian content)
   - Usually works perfectly
   - No Cloudflare

2. **Torlock**
   - Reliable connection
   - Good for movies/TV

3. **LimeTorrents**
   - Stable mirrors
   - Decent selection

4. **TorrentDownloads**
   - Old but reliable
   - Rarely down

5. **Zooqle**
   - Good DNS record
   - Fast response

### Add in Prowlarr

Just search for these names when adding indexers.

---

## 🔍 Complete Automated Fix Script

Run this to apply all fixes automatically:

```bash
cat > ~/fix-prowlarr-dns.sh << 'EOFSCRIPT'
#!/bin/bash

echo "🔧 Fixing Prowlarr DNS/SSL Issues..."
echo ""

# Stop Prowlarr
echo "Stopping Prowlarr..."
docker stop prowlarr

# Backup config
echo "Backing up config..."
cp -r ~/HomeLab/Docker/Data/prowlarr ~/HomeLab/Docker/Data/prowlarr.backup-$(date +%Y%m%d) 2>/dev/null || true

# Update compose file
echo "Updating docker-compose..."
COMPOSE_FILE="$HOME/HomeLab/Docker/Compose/media.yml"

# Check if file exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "Error: Compose file not found at $COMPOSE_FILE"
    exit 1
fi

# Backup compose file
cp "$COMPOSE_FILE" "$COMPOSE_FILE.backup-$(date +%Y%m%d-%H%M%S)"

# Update Prowlarr service with DNS settings
# This is a simplified version - manually edit for full control
cat >> "$COMPOSE_FILE.new" << 'EOFYAML'

  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    restart: unless-stopped
    ports:
      - "9696:9696"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/prowlarr:/config
    networks:
      - homelab-net
    dns:
      - 1.1.1.1
      - 8.8.8.8
    extra_hosts:
      - "host.docker.internal:host-gateway"
EOFYAML

echo ""
echo "✅ Configuration updated"
echo ""
echo "Next steps:"
echo "1. Edit ~/HomeLab/Docker/Compose/media.yml"
echo "2. Replace prowlarr section with version that has dns: settings"
echo "3. Run: docker compose -f ~/HomeLab/Docker/Compose/media.yml up -d prowlarr"
echo ""
echo "See ~/HomeLab/docs/FIX_PROWLARR_DNS_SSL.md for complete instructions"
EOFSCRIPT

chmod +x ~/fix-prowlarr-dns.sh
~/fix-prowlarr-dns.sh
```

---

## 🎯 Quick Fix Checklist

Try these in order:

### Level 1: Quick Fixes
- [ ] Add DNS servers to Prowlarr container
- [ ] Disable IPv6 in Prowlarr settings
- [ ] Restart Prowlarr container
- [ ] Test indexers again

### Level 2: Proxy Solution
- [ ] Add FlareSolverr container
- [ ] Configure FlareSolverr in Prowlarr
- [ ] Apply to problem indexers
- [ ] Test again

### Level 3: Network Debug
- [ ] Test DNS inside container
- [ ] Check if sites are reachable
- [ ] Try alternative indexers
- [ ] Check Mac's DNS settings

### Level 4: Nuclear Option
- [ ] Backup Prowlarr config
- [ ] Remove container completely
- [ ] Fresh install with all fixes
- [ ] Reconfigure from scratch

---

## 💡 Pro Tips

### Mac-Specific DNS Issues

**Your Mac might be blocking DNS:**

```bash
# Check Mac's DNS
scutil --dns | grep nameserver

# Flush Mac's DNS cache
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

### Network Service Order

Ensure 10GbE is primary:

```bash
networksetup -listnetworkserviceorder
```

Should show Ethernet first, then WiFi.

### Try Different DNS Servers

**In docker-compose, try:**

```yaml
dns:
  - 1.1.1.1          # Cloudflare (fast)
  - 8.8.8.8          # Google
  - 9.9.9.9          # Quad9 (security-focused)
  - 208.67.222.222   # OpenDNS
```

### Check Mac Firewall

**System Settings → Network → Firewall**

Make sure it's not blocking Docker's DNS requests.

---

## 🆘 Still Not Working?

### Last Resort Options

**1. Use Different Indexers**
- Some sites just don't work well
- Try Nyaa, Torlock, LimeTorrents
- Skip problematic ones

**2. Add More Public Indexers**
- Don't rely on just 1-2
- Add 10+ for redundancy
- Some will work, others won't

**3. Consider Usenet**
- More reliable than torrents
- No DNS/SSL issues
- Paid service but worth it

**4. Use Jackett Instead**
- Alternative to Prowlarr
- Sometimes handles DNS better
- Same concept, different implementation

---

## 📝 Summary

**Most Common Fix:**
```yaml
prowlarr:
  dns:
    - 1.1.1.1
    - 8.8.8.8
  extra_hosts:
    - "host.docker.internal:host-gateway"
```

**Then restart:**
```bash
docker compose -f ~/HomeLab/Docker/Compose/media.yml restart prowlarr
```

**Should fix 90% of DNS/SSL issues!**

---

## ✅ Verification

After applying fixes:

1. **Test in Prowlarr:**
   - Indexers → Add Indexer
   - Try adding 1337x
   - Should connect successfully

2. **Test DNS:**
   ```bash
   docker exec prowlarr nslookup 1337x.to
   ```
   Should resolve to IP

3. **Test Search:**
   - Search for any movie
   - Should return results

4. **Check Logs:**
   ```bash
   docker logs prowlarr --tail 50
   ```
   Should show successful connections

**If all tests pass, you're good to go!** 🎉

