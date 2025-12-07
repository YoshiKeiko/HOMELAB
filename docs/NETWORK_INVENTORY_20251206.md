# 🌐 HomeLab Network Inventory
> Last Updated: December 6, 2025
> Network: 192.168.50.0/24

## 🖥️ Core Infrastructure

| Device | IP Address | MAC Address | Notes |
|--------|------------|-------------|-------|
| Sky Router (Gateway) | 192.168.50.1 | e8:76:40:fe:27:8e | Main router |
| **HomeLab Server** | **192.168.50.50** | d0:11:e5:bb:70:b | M4 Mac Mini (32GB) |
| **MacBook Pro** | **192.168.50.55** | 8a:4f:08:d5:4d:16 | Static IP |
| Deco XE75 Pro | 192.168.50.59 | 50:3d:d1:fa:20:0 | Mesh WiFi |
| Deco Node | 192.168.50.70 | 50:3d:d1:fa:42:b5 | Mesh WiFi |
| Deco Node | 192.168.50.121 | 50:3d:d1:fa:65:b0 | Mesh WiFi |

## 📹 Cameras (Tapo C230)

| Camera | IP Address | MAC Address | Status |
|--------|------------|-------------|--------|
| Conservatory | 192.168.50.11 | 78:20:51:42:4b:0d | ✅ In HA |
| Hallway | 192.168.50.68 | 78:20:51:42:67:45 | ✅ In HA |

## 🎵 Sonos Speakers (10 devices)

| Speaker | Location | MAC Address |
|---------|----------|-------------|
| RINCON_000E587B527001400 | Hall | 00:0e:58:7b:52:70 |
| RINCON_5CAAFD25F82801400 | Living Room | 5c:aa:fd:25:f8:28 |
| RINCON_000E58CB38B201400 | Office | 00:0e:58:cb:38:b2 |
| RINCON_B8E937888B3E01400 | Kitchen | b8:e9:37:88:8b:3e |
| RINCON_5CAAFD9D4DDE01400 | Kitchen | 5c:aa:fd:9d:4d:de |
| RINCON_542A1BDB9B5001400 | Living Room | 54:2a:1b:db:9b:50 |
| RINCON_949F3EF1BC6401400 | Media Room | 94:9f:3e:f1:bc:64 |
| RINCON_38420B348C2001400 | Portable | 38:42:0b:34:8c:20 |
| RINCON_5CAAFD291CC401400 | Living Room | 5c:aa:fd:29:1c:c4 |
| RINCON_804AF2625FF801400 | Sub Mini | 80:4a:f2:62:5f:f8 |

## 📺 Entertainment

| Device | IP Address | MAC Address | Status |
|--------|------------|-------------|--------|
| **LG WebOS TV** | 192.168.50.41 | 60:45:e8:7e:6a:f0 | ⚠️ Not in HA |
| **Harmony Hub** | 192.168.50.15 | c8:db:26:04:26:6c | ⚠️ Not in HA |
| Google Nest Mini | 192.168.50.82 | 14:c1:4e:9a:80:aa | ⚠️ Not in HA |
| Nest Device | 192.168.50.152 | 18:b4:30:74:7d:23 | ⚠️ Not in HA |
| Nest Device | 192.168.50.154 | 14:c1:4e:92:ce:6b | ⚠️ Not in HA |

## ⚡ Smart Home / EV

| Device | IP Address | MAC Address | Status |
|--------|------------|-------------|--------|
| **Easee Charger** | 192.168.50.128 | 58:bf:25:2b:7e:34 | ⚠️ Not in HA |

## 🖨️ Other Devices

| Device | IP Address | MAC Address | Status |
|--------|------------|-------------|--------|
| Brother Printer | 192.168.50.139 | 80:2b:f9:a1:28:9a | ✅ In HA |
| Octo CAD Lite | 192.168.50.217 | 8c:4f:00:18:4d:88 | 3D Printer |

## 📱 Personal Devices

| Device | IP Address | MAC Address |
|--------|------------|-------------|
| iPhone | 192.168.50.81 | 16:20:87:09:58:fe |
| iPad | 192.168.50.43 | 5a:ec:94:1a:31:b6 |
| MacBook Air | 192.168.50.116 | d2:ca:63:a4:a7:51 |
| MacBook Pro | 192.168.50.149 | ce:2c:6e:69:b1:00 |
| Brayden's Note10 | 192.168.50.189 | ee:46:7c:52:93:39 |
| Dee's S24 | 192.168.50.220 | d2:fa:66:6a:87:01 |
| IT Support Device | 192.168.50.44 | 02:00:fe:6c:ef:19 |

---

## 🏠 Home Assistant Integrations

### ✅ Currently Configured
- **Sonos** - 10 speakers auto-discovered
- **Tapo Control** - 2 cameras (192.168.50.68, 192.168.50.11)
- **MQTT** - Broker at 192.168.50.50:1883
- **Brother Printer** - DCP-L3550CDW
- **Mobile App** - Samsung SM-S938B (notifications enabled)
- **HACS** - Custom components installed
- **Met Weather** - Home location
- **Frigate NVR** - AI camera detection

### ⚠️ Recommended to Add
1. **LG WebOS TV** (192.168.50.41) - Settings → Devices → Add Integration → LG webOS Smart TV
2. **Harmony Hub** (192.168.50.15) - Settings → Devices → Add Integration → Logitech Harmony Hub
3. **Google Nest** (192.168.50.82, etc.) - Settings → Devices → Add Integration → Google Nest
4. **Easee Charger** (192.168.50.128) - HACS → Easee EV Charger integration

---

## 📊 Service Credentials Summary

| Service | Port | Username | Password | Status |
|---------|------|----------|----------|--------|
| Portainer | 9000 | admin | (set on first login) | ✅ |
| PhotoPrism | 2342 | admin | NgYbA3RJYb7he1PRaERRXZektQvevPQ | ✅ |
| File Browser | 8087 | admin | admin | ✅ (reset) |
| Transmission | 9091 | admin | transmission | ✅ |
| Jupyter | 8888 | - | token: b34cdbecb84ec12d499589d0e5e45b93bfc38057c871e619 | ✅ |
| NPM | 81 | admin@example.com | changeme | ✅ |
| Vaultwarden | 8088 | (create account) | - | ✅ |
| Home Assistant | 8123 | (your account) | - | ✅ |

---

## 🔧 Docker Services (55 containers)

### Running Services
| Category | Services |
|----------|----------|
| **Media** | Plex, Jellyfin, Sonarr, Radarr, Prowlarr, Overseerr, Transmission, Tautulli |
| **Smart Home** | Home Assistant, Node-RED, Zigbee2MQTT, ESPHome, Mosquitto |
| **AI** | Ollama, Open WebUI |
| **Monitoring** | Grafana, Prometheus, Loki, Promtail, Uptime Kuma, Netdata, cAdvisor |
| **Security** | Vaultwarden, CrowdSec, Fail2ban |
| **Storage** | Nextcloud, PhotoPrism, File Browser, Syncthing, Kopia |
| **Surveillance** | Frigate NVR, Agent DVR |
| **Dashboards** | Heimdall, Homer, Dashy, Organizr |
| **Databases** | PostgreSQL, MariaDB, MongoDB, Redis, InfluxDB |
| **Other** | Portainer, NPM, Gitea, Code Server, Paperless-ngx, FreshRSS, Calibre |
