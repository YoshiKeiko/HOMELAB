# 🏠 HomeLab Complete Guide

**M4 Mac Mini HomeLab - Full Documentation**

---

## 📊 System Overview

**Hardware:**
- Mac Mini M4 (32GB RAM, 512GB SSD)
- 4TB External SSD (HomeLab-4TB)
- 10GbE Network Connection
- 5Gbps CityFibre Internet

**Software:**
- macOS Sequoia
- OrbStack (Docker runtime)
- Docker Compose orchestration

---

## 🌐 Service Access

### Dashboard
**Heimdall:** http://localhost:8090
- Central dashboard for all services
- Add applications via the web UI
- Customize appearance and layout

### VNC/Remote Desktop
**Web Desktop:** http://localhost:3050
- Full Ubuntu KDE desktop in browser
- Username: abc / Password: abc
- Change password on first login!

### Backup System
**Duplicati:** http://localhost:8200
- Automated backups to pCloud
- Encrypted incremental backups
- WebDAV connection to pCloud

### Media Services
**Plex:** http://localhost:32400/web
**Overseerr:** http://localhost:5055
**Radarr:** http://localhost:7878
**Sonarr:** http://localhost:8989
**Prowlarr:** http://localhost:9696
**Transmission:** http://localhost:9091 (admin/admin)

### Smart Home
**Home Assistant:** http://localhost:8123
**Node-RED:** http://localhost:1880
**Mosquitto MQTT:** localhost:1883

### Monitoring
**Grafana:** http://localhost:3000 (admin/admin)
**Prometheus:** http://localhost:9090
**Netdata:** http://localhost:19999

### Management
**Portainer:** http://localhost:9000 (if installed)
**AdGuard:** http://localhost:3080 (if installed)

---

## 🔄 How to Update Services

### Update Single Service

```bash
cd ~/HomeLab/Docker/Compose

# Pull latest image
docker compose -f [compose-file].yml pull

# Recreate container
docker compose -f [compose-file].yml up -d
```

### Update All Services

```bash
# Update everything
cd ~/HomeLab/Docker/Compose
for file in *.yml; do
    docker compose -f "$file" pull
    docker compose -f "$file" up -d
done
```

### Update with Watchtower (Automatic)

Watchtower is configured via labels. To enable:

```bash
cat > ~/HomeLab/Docker/Compose/watchtower.yml << 'EOFWT'
version: '3.8'

services:
  watchtower:
    image: containrrr/watchtower:latest
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_SCHEDULE=0 0 4 * * *
      - WATCHTOWER_LABEL_ENABLE=true
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
EOFWT

docker compose -f ~/HomeLab/Docker/Compose/watchtower.yml up -d
```

Updates run daily at 4 AM.

---

## 💾 Backup Configuration

### Duplicati Setup for pCloud

**Access:** http://localhost:8200

**Steps:**

1. **Add Backup:**
   - Click "Add backup"
   - Name: "HomeLab Docker Configs"

2. **Destination:**
   - Type: WebDAV
   - Server: `https://webdav.pcloud.com/HomeLab-Backups`
   - Username: your-pcloud-email
   - Password: your-pcloud-password (or app password if 2FA)
   - Test connection

3. **Source Data:**
   - Path: `/source` (maps to ~/HomeLab/Docker/Data)
   - Exclude: `*/cache/*`, `*/logs/*`, `*/transcode/*`

4. **Schedule:**
   - Daily at 3:00 AM

5. **Options:**
   - Retention: 30 days
   - Compression: High

6. **Encryption:**
   - Set strong passphrase
   - Save in 1Password!

7. **Save and Run** first backup

**Encryption Key Location:**
```
~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
```
⚠️ **Save this in 1Password immediately!**

---

## 🏠 Smart Home Integration

### Devices Supported
- 10x Sonos Speakers
- 5x Nest Cameras  
- Tesla Model Y
- Cupra Born EV
- Easee EV Charger

### Setup Home Assistant

1. **Access:** http://localhost:8123
2. **First Run:** Create account
3. **Add Integrations:**
   - Settings → Devices & Services → Add Integration
   - Search for: Sonos, Nest, Tesla, etc.
4. **Configure MQTT:**
   - Add MQTT integration
   - Broker: mosquitto (auto-discovered)
5. **Node-RED Integration:**
   - Add Node-RED integration for automation

---

## 📊 Monitoring Setup

### Grafana Dashboards

**Import Pre-built Dashboards:**

1. Login to Grafana (admin/admin)
2. Change password
3. Add Prometheus data source:
   - Configuration → Data Sources → Add
   - Type: Prometheus
   - URL: `http://prometheus:9090`
   - Save & Test

4. Import Dashboards:
   - Dashboards → Import
   - Dashboard ID: 1860 (Node Exporter Full)
   - Dashboard ID: 893 (Docker)
   - Dashboard ID: 11074 (Netdata)

### Netdata

Real-time system monitoring at http://localhost:19999

Features:
- CPU, RAM, Disk, Network monitoring
- Docker container stats
- Alert notifications
- Beautiful real-time graphs

---

## 🔧 Maintenance Tasks

### Daily (Automated)
- ✅ Duplicati backups (3 AM)
- ✅ Watchtower updates (4 AM)

### Weekly
- [ ] Check backup logs
- [ ] Review Grafana dashboards
- [ ] Check disk space

### Monthly
- [ ] Test restore from backup
- [ ] Review and clean old media
- [ ] Update documentation
- [ ] Check service logs for errors

---

## 🆘 Troubleshooting

### Service Won't Start

```bash
# Check logs
docker logs [container-name]

# Restart service
docker restart [container-name]

# Recreate service
cd ~/HomeLab/Docker/Compose
docker compose -f [compose-file].yml down
docker compose -f [compose-file].yml up -d
```

### Can't Access Service

```bash
# Check if running
docker ps | grep [service-name]

# Check ports
docker port [container-name]

# Check network
docker network inspect homelab-net
```

### Backup Fails

1. Check Duplicati logs
2. Verify pCloud credentials
3. Test WebDAV connection
4. Check available space

### Out of Disk Space

```bash
# Check usage
df -h

# Clean Docker
docker system prune -a

# Clean old logs
find ~/HomeLab/Docker/Data -name "*.log" -mtime +30 -delete
```

---

## 📱 Mobile Access

### From iPhone/iPad

**Web Services:**
- Open Safari
- Navigate to: `http://M4-IP:PORT`
- Add to Home Screen for app-like experience

**Home Assistant:**
- Install Home Assistant app from App Store
- Configure with M4 IP address

**VNC Desktop:**
- Open: `http://M4-IP:3050`
- Full desktop in browser

---

## 🔐 Security Recommendations

### Passwords to Set
- [ ] Grafana admin password
- [ ] Transmission password
- [ ] VNC desktop password
- [ ] Home Assistant account
- [ ] Duplicati web password

### Save in 1Password
- [ ] All service passwords
- [ ] Duplicati encryption key
- [ ] pCloud credentials
- [ ] Repository encryption password

### Network Security
- ✅ Services only on local network
- ✅ No internet exposure (yet)
- ⏳ Add Tailscale for remote access (future)
- ⏳ Add reverse proxy with auth (future)

---

## 🚀 Future Enhancements

### Phase 2 - Media Enhancement
- Jellyfin (Plex alternative)
- Tautulli (Plex statistics)
- Bazarr (subtitle downloads)
- Lidarr (music automation)

### Phase 3 - Productivity
- Nextcloud (personal cloud)
- Paperless-ngx (document management)
- PhotoPrism (photo library)
- Calibre (ebook library)

### Phase 4 - Advanced
- Authelia (SSO authentication)
- Traefik (reverse proxy)
- Databases (PostgreSQL, MariaDB)
- CrowdSec (security)

### Phase 5 - VMs
- UTM for Windows 11 ARM
- Additional Linux VMs
- Testing environments

---

## 📚 Additional Documentation

**Configuration Files:**
```
~/HomeLab/Docker/Compose/        - All compose files
~/HomeLab/Docker/Data/           - Service data
~/HomeLab/docs/                  - Documentation
~/HomeLab/scripts/               - Utility scripts
~/HomeLab/backups/               - Local backups
```

**Important Files:**
```
~/HomeLab/docs/DUPLICATI_ENCRYPTION_KEY.txt
~/HomeLab/docs/SERVICES_LIST.txt
~/HomeLab/docs/HOMELAB_GUIDE.md (this file)
```

---

## ✅ Quick Reference

**Restart All Services:**
```bash
docker restart $(docker ps -q)
```

**View All Logs:**
```bash
docker compose -f ~/HomeLab/Docker/Compose/*.yml logs -f
```

**Check Service Status:**
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

**Backup Now:**
```bash
# Via Duplicati web UI
open http://localhost:8200
# Click "Run now" on backup job
```

**Access Dashboard:**
```bash
open http://localhost:8090
```

---

**Your HomeLab is fully deployed and documented!** 🎉
