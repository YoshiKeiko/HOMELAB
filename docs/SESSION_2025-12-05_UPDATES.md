# HomeLab Session Notes - December 5, 2025

## Summary
Major updates to Home Assistant, Frigate NVR, Obsidian backups, and service diagnostics.

---

## 🎯 Changes Made

### 1. Home Assistant Enhancements

**HACS Installed**
- Location: `/Users/homelab/HomeLab/Docker/Data/homeassistant/config/custom_components/hacs`
- Purpose: Home Assistant Community Store for custom integrations

**Tapo Cameras Integration**
- Hallway Camera: 192.168.50.68
- Kat Kave Camera: 192.168.50.11
- Entities: `camera.hallway_hd_stream`, `camera.kat_kave_hd_stream`
- Features: Pan/tilt controls, motion detection, night vision settings

**Automations Created**
| Automation | Trigger | Action |
|------------|---------|--------|
| Backup Script Notification | Webhook: `obsidian_backup_notify` | Push to phone |
| Hallway Motion Detected | Tapo motion event | Push with snapshot |
| Kat Kave Motion Detected | Tapo motion event | Push with snapshot |
| Frigate Person Detected | MQTT frigate/events | Push with thumbnail |
| Frigate Cat Detected | MQTT frigate/events | Push with thumbnail |

**Mobile Notifications**
- Device: SM-S938B (Samsung Galaxy)
- Service: `notify.mobile_app_sm_s938b`
- Webhook URL: `http://192.168.50.50:8123/api/webhook/obsidian_backup_notify`

---

### 2. Frigate NVR Configuration

**Config Location**: `/Users/homelab/HomeLab/Docker/Data/frigate/config/config.yml`
**Web UI**: http://192.168.50.50:5001
**Storage**: `/Volumes/HomeLab-4TB/Frigate/recordings`

**Detection Objects**
- person (threshold: 0.7)
- cat (threshold: 0.4) 🐱
- dog (threshold: 0.4)
- car
- bird

**Cameras**
```yaml
cameras:
  hallway:
    rtsp: rtsp://agentdvr:PASSWORD@192.168.50.68:554/stream1
  kat_kave:
    rtsp: rtsp://agentdvr:PASSWORD@192.168.50.11:554/stream1
```

**Retention**
- Motion recordings: 14 days
- Detection clips: 30 days
- Snapshots: 30 days

---

### 3. Obsidian Backup System

**Scripts Location**: `/Users/homelab/Documents/Obsidian/`

**Cron Jobs**
```
0 */6 * * *   sync_vaults.sh          # Git pull from GitHub
0 */12 * * *  encrypted_multi_backup.sh # Encrypted backup + push
```

**Vaults Backed Up**
ACCREDIBLE, DD, HOME, KETO, PERSONAL, PROJECTS, HOMELAB, TRAINING

**New Feature**: Push notifications on backup completion!

---

### 4. AgentDVR Changes
- Recording disabled (migrated to Frigate)
- Old recordings deleted from `/Volumes/HomeLab-4TB/AgentDVR/media/`
- Container still running for RTSP relay

---

## 🔧 Service Status & Credentials

### Working Services
| Service | Port | Status |
|---------|------|--------|
| Home Assistant | 8123 | ✅ |
| Frigate | 5001 | ✅ |
| Portainer | 9000 | ✅ |
| Grafana | 3003 | ✅ |
| Prometheus | 9090 | ✅ |
| AdGuard | 8084 | ✅ |
| Plex | 32400 | ✅ |
| Jellyfin | 8096 | ✅ |
| Sonarr | 8989 | ✅ |
| Radarr | 7878 | ✅ |
| Prowlarr | 9696 | ✅ |
| Uptime Kuma | 3004 | ✅ |
| Paperless | 8093 | ✅ |
| Gitea | 3001 | ✅ |
| Node-RED | 1880 | ✅ |
| Syncthing | 8384 | ✅ |
| Kopia | 8202 | ✅ |
| Calibre | 8094/8095 | ✅ |

### Credentials Reference
| Service | URL | Credentials |
|---------|-----|-------------|
| Jupyter | :8888 | Token: `b34cdbecb84ec12d499589d0e5e45b93bfc38057c871e619` |
| PhotoPrism | :2342 | admin / insecure |
| NPM | :81 | admin@example.com / changeme |
| Transmission | :9091 | Check docker env |

### Services Needing Setup
| Service | Port | Issue |
|---------|------|-------|
| Nextcloud | 8097 | Initial setup required |
| InfluxDB | 8086 | No admin user |
| Vaultwarden | 8088 | Slow loading |
| Homer | 8091 | No config |

---

## 📱 Network Devices Discovered

| Device | IP | HA Integration |
|--------|-----|----------------|
| Harmony Hub | .15 | Logitech Harmony |
| LG TV | .41 | LG webOS |
| Google Nest Mini | .82 | Google Cast |
| Tesla | .106 | Tesla |
| Easee EV Charger | .128 | Easee |
| ESPHome Device | .93 | ESPHome |
| Sonos | .26, .115 | ✅ Already added |
| Brother Printer | .139 | ✅ Already added |

---

## 🔄 Auto-Update System

**Watchtower** handles automatic Docker container updates
- Runs daily
- Automatically pulls new images
- Recreates containers with new versions
- Last update: 3 containers updated (postgres, calibre, esphome)

---

## 📋 TODO
- [ ] Set up SSH between Mac Mini (.50) and MacBook Pro (.162)
- [ ] Configure Nextcloud initial setup
- [ ] Set up InfluxDB admin
- [ ] Add remaining HA integrations (Harmony, LG TV, Tesla, Easee)
- [ ] Configure pCloud backup
- [ ] Set up local SSL via Nginx Proxy Manager

---

## 📁 Important File Locations

```
Home Assistant Config:
/Users/homelab/HomeLab/Docker/Data/homeassistant/config/

Frigate Config:
/Users/homelab/HomeLab/Docker/Data/frigate/config/

Frigate Recordings:
/Volumes/HomeLab-4TB/Frigate/recordings/

Obsidian Backup Scripts:
/Users/homelab/Documents/Obsidian/

Docker Data:
/Users/homelab/HomeLab/Docker/Data/
```

---

*Generated: 2025-12-05 22:40*
