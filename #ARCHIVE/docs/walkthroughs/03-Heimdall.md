# Heimdall - Application Dashboard

**URL:** http://localhost:8090  
**Tailscale:** http://TAILSCALE_IP:8090  
**Time:** 30 minutes

## What is Heimdall?

Your homelab homepage. One page with links to all 47 services. **Make this your browser homepage!**

## Configuration Steps

### Step 1: Initial Access
- [ ] Open http://localhost:8090
- [ ] You should see an empty dashboard

### Step 2: Add Your First Application
- [ ] Look for settings/gear icon (top right or bottom right)
- [ ] Click "+ Add" or "Add Application"

### Step 3: Add Essential Services

Copy these settings for each service:

#### Portainer
- **Title:** Portainer
- **URL:** http://localhost:9000
- **App Type:** Select "Portainer" from dropdown
- [ ] Save

#### Plex
- **Title:** Plex
- **URL:** http://localhost:32400/web
- **App Type:** Select "Plex" from dropdown
- [ ] Save

#### Jellyfin
- **Title:** Jellyfin
- **URL:** http://localhost:8096
- **App Type:** Select "Jellyfin"
- [ ] Save

#### Home Assistant
- **Title:** Home Assistant
- **URL:** http://localhost:8123
- **App Type:** Select "Home Assistant"
- [ ] Save

#### OpenWebUI
- **Title:** OpenWebUI (AI Chat)
- **URL:** http://localhost:3000
- **App Type:** May need "Custom" - upload icon
- [ ] Save

#### Grafana
- **Title:** Grafana
- **URL:** http://localhost:3003
- **App Type:** Select "Grafana"
- [ ] Save

### Step 4: Add All Other Services

Continue adding services from this list:

**Media Services:**
- Radarr (http://localhost:7878)
- Sonarr (http://localhost:8989)
- Prowlarr (http://localhost:9696)
- Overseerr (http://localhost:5055)
- Transmission (http://localhost:9091)
- Tautulli (http://localhost:8181)

**Monitoring:**
- Prometheus (http://localhost:9090)
- Uptime Kuma (http://localhost:3004)
- Netdata (http://localhost:19999)

**Storage:**
- Nextcloud (http://localhost:8097)
- Syncthing (http://localhost:8384)
- Duplicati (http://localhost:8200)
- File Browser (http://localhost:8087)

**AI & Development:**
- Code Server (http://localhost:8443)
- Jupyter (http://localhost:8888)
- Gitea (http://localhost:3001)

**Security:**
- Vaultwarden (http://localhost:8088)
- AdGuard (http://localhost:3002)

**Utilities:**
- Paperless-ngx (http://localhost:8093)
- PhotoPrism (http://localhost:2342)
- Calibre (http://localhost:8094)
- FreshRSS (http://localhost:8098)

**Network:**
- Nginx Proxy Manager (http://localhost:81)

### Step 5: Organize with Tags
- [ ] Create tags: Media, Monitoring, Storage, AI, Security, Utilities
- [ ] Tag each application appropriately
- [ ] They'll be grouped on your dashboard

### Step 6: Set as Homepage
- [ ] In your browser settings, set homepage to http://localhost:8090
- [ ] Or bookmark it in your favorites bar
- [ ] On phone: Add to home screen

### Step 7: Customize
- [ ] Click settings gear
- [ ] Choose background image (or upload your own)
- [ ] Adjust tile size
- [ ] Choose color scheme

## Tips

**Search Functionality:**
- Use search box to quickly find services
- Faster than scrolling with 47+ tiles

**Status Indicators:**
- Green dot = service is up
- Red dot = service is down
- Click tile to open service

**Mobile Access:**
- Via Tailscale: http://TAILSCALE_IP:8090
- Add to phone home screen for app-like experience

**Multiple Profiles:**
- Create different views for different purposes
- "Work" profile with dev tools
- "Media" profile with streaming services

## ✅ Verification

- [ ] All essential services added
- [ ] Tiles show correct icons
- [ ] Clicking tiles opens services
- [ ] Status indicators working
- [ ] Set as browser homepage

## Next Step

Choose your path:
- **Media:** Configure [Plex](07-Plex.md)
- **Smart Home:** Configure [Home Assistant](23-Home-Assistant.md)
- **AI:** Configure [OpenWebUI](18-OpenWebUI.md)
- **Monitoring:** Configure [Grafana](14-Grafana.md)

