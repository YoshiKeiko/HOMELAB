---
title: Volume 07: Media Stack (Days 7-8)
tags: [homelab, media, plex, automation, arr]
created: 2025-11-11
type: homelab-guide
---

# Volume 07: Media Stack (Days 7-8)

**Complete Media Automation with Plex + *arr Services**

This volume covers your complete media automation setup.

## What You'll Complete

- Plex Media Server (streaming)
- Sonarr (TV show automation)
- Radarr (Movie automation)
- Prowlarr (Indexer management)
- qBittorrent (Download client with ExpressVPN)
- Bazarr (Subtitle automation)
- Overseerr (Request management)
- Tdarr (Transcoding automation)
- All services linked and working together

## Prerequisites

- Volumes 01-06 complete
- Docker running (from Volume 03)
- External 4TB storage mounted
- Plex account (from Volume 01)
- ExpressVPN account

---

# Guide 40: Plex Media Server

## Deploy Plex

Already configured in docker-compose-master.yml:

```yaml
plex:
  image: plexinc/pms-docker:latest
  container_name: plex
  restart: unless-stopped
  network_mode: host
  environment:
    - TZ=Europe/London
    - PLEX_CLAIM=claim-xxxxxxxxxxxx
  volumes:
    - ~/HomeLab/Docker/Data/plex:/config
    - /Volumes/External4TB/Media:/media
    - ~/HomeLab/Docker/Data/plex/transcode:/transcode
```

## Get Claim Token

1. Go to: https://www.plex.tv/claim/
2. Login with your Plex account
3. Copy claim token (valid 4 minutes)
4. Add to docker-compose-master.yml

## Start Plex

```bash
cd ~/HomeLab/Docker/Compose
docker compose -f docker-compose-master.yml up -d plex
```

## Setup Plex

1. Access: http://192.168.50.10:32400/web
2. Sign in with Plex account
3. Name server: M4-HomeLab
4. Add Library:
   - Movies: /media/Movies
   - TV Shows: /media/TV
   - Music: /media/Music

## Configure Remote Access

1. Settings → Remote Access
2. Enable: Manually specify public port
3. Port: 32400
4. Apply

**Access anywhere:**
- Local: http://192.168.50.10:32400/web
- Remote: https://app.plex.tv (auto-discovers)
- Apps: Plex app on phone/TV

---

# Guide 41: Prowlarr (Indexers)

## Deploy Prowlarr

```bash
docker compose -f docker-compose-master.yml up -d prowlarr
```

Access: http://192.168.50.10:9696

## Setup Indexers

1. **Add Indexers:**
   - Indexers → Add Indexer
   - Search for public trackers
   - Add: 1337x, RARBG, etc.
   - Configure credentials if needed

2. **Connect to Apps:**
   - Settings → Apps → Add Application
   - Type: Sonarr
   - Prowlarr Server: http://prowlarr:9696
   - Sonarr Server: http://sonarr:8989
   - API Key: (get from Sonarr)
   
   - Type: Radarr
   - Similar config

**Prowlarr now manages indexers for all *arr apps!**

---

# Guide 42: Sonarr (TV Shows)

## Deploy Sonarr

```bash
docker compose -f docker-compose-master.yml up -d sonarr
```

Access: http://192.168.50.10:8989

## Initial Setup

1. **Media Management:**
   - Settings → Media Management
   - Root Folder: /tv
   - Episode Naming: Standard
   - Permissions: 755

2. **Connect Prowlarr:**
   - Settings → Indexers
   - Already connected via Prowlarr!

3. **Connect Download Client:**
   - Settings → Download Clients → Add
   - Type: qBittorrent
   - Host: qbittorrent
   - Port: 8112
   - Username: admin
   - Password: (from qBittorrent)

4. **Connect Plex:**
   - Settings → Connect → Add
   - Type: Plex Media Server
   - Host: 192.168.50.10
   - Port: 32400
   - Auth Token: (from Plex Settings → Network)

## Add TV Show

1. Series → Add New
2. Search: Your favorite show
3. Root Folder: /tv
4. Monitor: All Episodes
5. Add

**Sonarr automatically:**
- Searches for episodes
- Downloads via qBittorrent
- Renames and organizes
- Updates Plex

---

# Guide 43: Radarr (Movies)

## Deploy Radarr

```bash
docker compose -f docker-compose-master.yml up -d radarr
```

Access: http://192.168.50.10:7878

## Setup (Similar to Sonarr)

1. **Media Management:**
   - Root Folder: /movies
   - Movie Naming: Standard

2. **Indexers:** Via Prowlarr

3. **Download Client:** qBittorrent

4. **Connect Plex**

## Add Movie

1. Movies → Add New
2. Search: Movie name
3. Add to: /movies
4. Monitor: Yes
5. Add

---

# Guide 44: qBittorrent with VPN

## Deploy Gluetun + qBittorrent

```yaml
# In docker-compose-master.yml:
gluetun:
  image: qmcgaw/gluetun:latest
  container_name: gluetun
  cap_add:
    - NET_ADMIN
  ports:
    - "8112:8112"  # qBittorrent Web UI
  environment:
    - VPN_SERVICE_PROVIDER=expressvpn
    - OPENVPN_USER=your-username
    - OPENVPN_PASSWORD=your-password
    - SERVER_COUNTRIES=UK

qbittorrent:
  network_mode: "service:gluetun"  # Routes through VPN!
```

**Get ExpressVPN credentials:**
1. Go to: https://www.expressvpn.com/setup
2. Copy username and password
3. Add to docker-compose-master.yml

**Start:**
```bash
docker compose -f docker-compose-master.yml up -d gluetun qbittorrent
```

## Configure qBittorrent

Access: http://192.168.50.10:8112

**Default credentials:**
- Username: admin
- Password: adminadmin

**Change immediately!**

**Settings:**
- Downloads → Save path: /downloads/complete
- Connection → Listening port: 6881
- Speed → Global rate limits: (set to your preference)

**Test VPN:**
1. Check IP: https://ipleak.net
2. Should show ExpressVPN IP, NOT your home IP!

---

# Guide 45: Bazarr (Subtitles)

## Deploy Bazarr

```bash
docker compose -f docker-compose-master.yml up -d bazarr
```

Access: http://192.168.50.10:6767

## Setup

1. **Languages:**
   - Settings → Languages
   - Add: English

2. **Connect Sonarr:**
   - Settings → Sonarr
   - Address: http://sonarr:8989
   - API Key: (from Sonarr)

3. **Connect Radarr:**
   - Similar config

4. **Subtitle Providers:**
   - Settings → Providers
   - Add: OpenSubtitles, Subscene, etc.

**Bazarr automatically downloads subtitles for all media!**

---

# Guide 46: Overseerr (Requests)

## Deploy Overseerr

```bash
docker compose -f docker-compose-master.yml up -d overseerr
```

Access: http://192.168.50.10:5055

## Setup

1. **Plex Connection:**
   - Sign in with Plex
   - Select server: M4-HomeLab

2. **Connect Sonarr:**
   - Settings → Services → Sonarr
   - Add Server
   - URL: http://sonarr:8989
   - API Key: (from Sonarr)

3. **Connect Radarr:**
   - Similar config

## Use Overseerr

**Share with family/friends:**
- Give them: overseerr.stevehomelab.duckdns.org
- They can request movies/shows
- You approve
- Automatically downloads!

---

# Guide 47: Tdarr (Transcoding)

## Deploy Tdarr

```bash
docker compose -f docker-compose-master.yml up -d tdarr
```

Access: http://192.168.50.10:8265

## Setup

1. **Libraries:**
   - Add Library
   - Source: /media/Movies
   - Transcode cache: /temp

2. **Transcoding Rules:**
   - Use H.265 (HEVC) for space saving
   - Target quality: Same as source
   - Audio: AAC stereo

3. **Schedule:**
   - Transcode during off-peak hours
   - Queue settings: 2 concurrent

**Tdarr automatically optimizes your media library!**

---

# Guide 48: Workflow Example

## How It All Works Together

1. **User requests movie via Overseerr**
   - Family member searches "Inception"
   - Clicks: Request

2. **Radarr receives request**
   - Searches indexers via Prowlarr
   - Finds best quality release
   - Sends to qBittorrent

3. **qBittorrent downloads (via VPN)**
   - Downloads through ExpressVPN
   - IP hidden
   - Saves to /downloads/complete

4. **Radarr processes**
   - Detects completed download
   - Renames: "Inception (2010).mkv"
   - Moves to: /media/Movies/Inception (2010)/
   - Notifies Plex

5. **Bazarr adds subtitles**
   - Detects new movie
   - Downloads English subtitles
   - Saves alongside movie

6. **Tdarr optimizes (optional)**
   - Transcodes to H.265
   - Saves disk space
   - Maintains quality

7. **Plex updates library**
   - Scans for new media
   - Adds metadata and posters
   - Ready to watch!

8. **User watches**
   - Opens Plex app
   - "Inception" appears
   - Streams perfectly!

**All automatic!** ✨

---

# Guide 49: Access URLs

## Service Access

```
Plex:       http://192.168.50.10:32400/web
Sonarr:     http://192.168.50.10:8989
Radarr:     http://192.168.50.10:7878
Prowlarr:   http://192.168.50.10:9696
qBittorrent: http://192.168.50.10:8112
Bazarr:     http://192.168.50.10:6767
Overseerr:  http://192.168.50.10:5055
Tdarr:      http://192.168.50.10:8265
```

## Add to Nginx Proxy Manager

For each service:
1. Proxy Hosts → Add
2. Domain: plex.stevehomelab.duckdns.org
3. Forward: 192.168.50.10:32400
4. SSL: Your certificate
5. Save

**Now accessible via:**
- plex.stevehomelab.duckdns.org
- sonarr.stevehomelab.duckdns.org
- etc.

---

# Guide 50: Maintenance

## Regular Tasks

**Weekly:**
- Check download queue
- Review Overseerr requests
- Clear completed downloads

**Monthly:**
- Update containers:
  ```bash
  docker compose -f docker-compose-master.yml pull
  docker compose -f docker-compose-master.yml up -d
  ```
- Review disk space
- Check Tdarr progress

## Troubleshooting

**Downloads not starting:**
```bash
# Check VPN
docker logs gluetun

# Check qBittorrent
docker logs qbittorrent

# Verify VPN IP
curl --interface eth0 ifconfig.me
```

**Plex not updating:**
```bash
# Force library scan
docker exec plex /usr/lib/plexmediaserver/Plex\ Media\ Scanner --scan
```

---

## Volume 07 Complete!

You now have:
- ✅ Plex Media Server streaming
- ✅ Sonarr managing TV shows
- ✅ Radarr managing movies
- ✅ Prowlarr managing indexers
- ✅ qBittorrent with ExpressVPN (safe downloads)
- ✅ Bazarr auto-downloading subtitles
- ✅ Overseerr for family requests
- ✅ Tdarr optimizing media
- ✅ Fully automated media pipeline!

**Media Stack Summary:**
```
Request (Overseerr)
  ↓
Search (Prowlarr → Sonarr/Radarr)
  ↓
Download (qBittorrent via VPN)
  ↓
Process (Sonarr/Radarr)
  ↓
Subtitles (Bazarr)
  ↓
Optimize (Tdarr - optional)
  ↓
Stream (Plex)
```

**Next: Volume 08 - Smart Home (Home Assistant, Frigate, Nest cameras, Sonos, Tesla)**



---

#homelab #media #plex #automation #arr
