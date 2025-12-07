# 🏠 HomeLab Credentials & Status Report
> Generated: December 6, 2025 00:55 UTC
> HomeLab Server: 192.168.50.50
> MacBook Pro: 192.168.50.55

---

## ✅ Services Status Summary

| Service | Port | Status | Credentials |
|---------|------|--------|-------------|
| **Portainer** | 9000 | ✅ Working | Your existing login |
| **Home Assistant** | 8123 | ✅ Working | Your existing login |
| **Plex** | 32400 | ✅ Working | Access via /web path |
| **Jellyfin** | 8096 | ✅ Working | Your existing login |
| **Grafana** | 3003 | ✅ Working | Your existing login |
| **Frigate NVR** | 5001 | ✅ Working | No auth required |
| **Agent DVR** | 8099 | ✅ Working | Your existing login |
| **Uptime Kuma** | 3004 | ✅ Working | Your existing login |
| **Open WebUI** | 3000 | ✅ Working | Your existing login |
| **Kopia** | 8202 | ✅ Working | Your existing login |
| **File Browser** | 8087 | ✅ **RESET** | `admin` / `admin` |
| **PhotoPrism** | 2342 | ✅ Working | `admin` / `NgYbA3RJYb7he1PRaERRXZektQvevPQ` |
| **Transmission** | 9091 | ✅ **RESET** | `admin` / `homelab123` |
| **Jupyter** | 8888 | ✅ Working | Token: `b34cdbecb84ec12d499589d0e5e45b93bfc38057c871e619` |
| **Homer** | 8091 | ✅ **FIXED** | Config created |
| **Nextcloud** | 8097 | ⚠️ Setup Required | `admin` / `NgYbA3RJYb7he1PRaERRXZektQvevPQ` |
| **InfluxDB** | 8086 | ⚠️ Already Setup | Check existing credentials |
| **Vaultwarden** | 8088 | ✅ Working | Your existing login |
| **CrowdSec** | 8089 | ⚠️ API Only | No web dashboard |
| **Loki** | 3100 | ✅ Working | API endpoint only |
| **Node Exporter** | 9100 | ✅ Working | Access /metrics |
| **Mosquitto MQTT** | 1883 | ✅ Working | MQTT protocol only |
| **FlareSolverr** | 8191 | ✅ Ready | No auth |
| **Calibre** | 8094 | ✅ Working | Web desktop interface |
| **Calibre Server** | 8095 | ⚠️ Issues | Check container |

---

## 📱 Home Assistant Integrations

### Currently Active
- ✅ **Sonos** - 6 speakers discovered (Kitchen, Media Room, Living Room, Hall, Office, Portable)
- ✅ **Tapo Cameras** - 2 cameras (Hallway, Kat Kave)
- ✅ **MQTT** - Connected to Mosquitto
- ✅ **Mobile App** - Samsung SM-S938B (your phone)
- ✅ **Frigate** - Connected
- ✅ **Brother Printer** - DCP-L3550CDW
- ✅ **Met.no Weather** - Forecast
- ✅ **HACS** - Installed

### Ready to Add (Manual Setup Required in HA UI)
1. **LG WebOS TV** (192.168.50.41)
   - Go to Settings → Devices & Services → Add Integration → LG webOS Smart TV
   - Enter IP: 192.168.50.41
   - Follow on-screen pairing prompt on TV

2. **Harmony Hub** (192.168.50.15)
   - Go to Settings → Devices & Services → Add Integration → Logitech Harmony Hub
   - Enter IP: 192.168.50.15

3. **Google Nest** (192.168.50.82)
   - Requires Google Cloud setup - use Google Home integration via HACS if needed

---

## 🔔 Automations Configured

| Automation | Trigger | Action |
|------------|---------|--------|
| Backup Script Notification | Webhook | Phone notification |
| Hallway Motion Detected | Tapo camera motion | Phone notification + image |
| Kat Kave Motion Detected | Tapo camera motion | Phone notification + image |
| Frigate Person Detected | MQTT event | Phone notification + thumbnail |
| Frigate Cat Detected | MQTT event | Phone notification + thumbnail |
| **NEW:** Service Down Alert | Webhook | Phone notification (red) |
| **NEW:** HomeLab Startup | HA start | Phone notification |
| **NEW:** Kopia Backup Complete | Webhook | Phone notification |

### Webhook URLs for Notifications
```bash
# Service Alert
curl -X POST http://192.168.50.50:8123/api/webhook/service_alert \
  -H "Content-Type: application/json" \
  -d '{"title":"Service Name","message":"Description of issue"}'

# Backup Notification
curl -X POST http://192.168.50.50:8123/api/webhook/kopia_backup_complete \
  -H "Content-Type: application/json" \
  -d '{"message":"Docker backup completed: 2.7GB"}'
```

---

## 🌐 Network Devices Discovered

| IP | Device | Status |
|----|--------|--------|
| 192.168.50.1 | Sky Router | Gateway |
| 192.168.50.11 | **Tapo C230** | Kat Kave camera ✅ |
| 192.168.50.15 | **Harmony Hub** | Ready to add to HA |
| 192.168.50.18 | Sonos Play:3 | Hall ✅ |
| 192.168.50.20 | Sonos Play:1 | Office ✅ |
| 192.168.50.26 | Sonos Beam | Living Room ✅ |
| 192.168.50.40 | Unknown Device | Check manually |
| 192.168.50.41 | **LG WebOS TV** | Ready to add to HA |
| 192.168.50.43 | iPad | - |
| 192.168.50.50 | **HomeLab Server** | M4 Mac Mini |
| 192.168.50.55 | **MacBook Pro** | Static IP |
| 192.168.50.59 | Deco XE75 Pro | Mesh node |
| 192.168.50.68 | **Tapo C230** | Hallway camera ✅ |
| 192.168.50.69 | Unknown Device | Check manually |
| 192.168.50.70 | Deco mesh unit | Mesh node |
| 192.168.50.81 | iPhone | - |
| 192.168.50.82 | **Google Nest Mini** | Smart speaker |
| 192.168.50.109 | Sonos Roam | Portable ✅ |
| 192.168.50.114 | Sonos Play:1 | Media Room ✅ |
| 192.168.50.115 | Sonos Play:1 | Kitchen ✅ |

---

## 🔐 All Credentials Reference

### Storage & Files
| Service | URL | Username | Password |
|---------|-----|----------|----------|
| File Browser | :8087 | admin | admin |
| PhotoPrism | :2342 | admin | NgYbA3RJYb7he1PRaERRXZektQvevPQ |
| Nextcloud | :8097 | admin | NgYbA3RJYb7he1PRaERRXZektQvevPQ |
| Syncthing | :8384 | - | No auth by default |

### Media
| Service | URL | Username | Password |
|---------|-----|----------|----------|
| Transmission | :9091 | admin | homelab123 |
| Plex | :32400/web | Plex account | - |
| Jellyfin | :8096 | Your account | - |

### Development
| Service | URL | Auth |
|---------|-----|------|
| Jupyter | :8888 | Token: b34cdbecb84ec12d499589d0e5e45b93bfc38057c871e619 |
| Code Server | :8443 | changeme |
| Gitea | :3001 | Your account |

### Databases
| Service | Port | Notes |
|---------|------|-------|
| PostgreSQL | 5432 | User: postgres, Pass in compose file |
| MariaDB | 3306 | Check compose file |
| MongoDB | 27017 | No auth by default |
| Redis | 6379 | No auth |
| InfluxDB | 8086 | Already configured |

### Nginx Proxy Manager
| Service | URL | Email | Password |
|---------|-----|-------|----------|
| NPM | :81 | admin@example.com | changeme |

---

## 📋 Next Steps

### Manual Actions Required:
1. [ ] Add LG TV to Home Assistant (Settings → Integrations)
2. [ ] Add Harmony Hub to Home Assistant
3. [ ] Change default passwords (File Browser, NPM, Transmission)
4. [ ] Complete Nextcloud setup wizard
5. [ ] Test all notifications on phone
6. [ ] Set up SSL via Nginx Proxy Manager if needed

### Optional Enhancements:
- Add more Tapo cameras if you have them
- Set up Google Nest integration via HACS
- Configure Grafana dashboards for HA metrics
- Add UPS monitoring via NUT
