# 🏠 Homelab Documentation Index

## Quick Access

| Service | URL | Status |
|---------|-----|--------|
| **Home Assistant** | http://192.168.50.50:8123 | ✅ |
| **Frigate NVR** | http://192.168.50.50:5001 | ✅ |
| **Portainer** | http://192.168.50.50:9000 | ✅ |
| **Grafana** | http://192.168.50.50:3003 | ✅ |
| **Plex** | http://192.168.50.50:32400/web | ✅ |

---

## 📚 Documentation Structure

### 01-Services
- [[Docker-Services]] - Complete list of 68 Docker containers with ports
- [[Home-Assistant-Integrations]] - All HA integrations and setup
- [[Cameras-Frigate]] - Camera system documentation

### 02-How-To-Guides
- [[NFC-Tags-Home-Assistant]] - NFC tag automation setup
- [[HA-Devices-To-Add-NFC-Ideas]] - Devices to integrate & NFC ideas

### 06-Network
- [[Network-Inventory]] - All network devices and IPs

---

## 🖥️ Infrastructure Overview

### Server
- **Mac Mini** - 192.168.50.50
- **OS**: macOS with OrbStack (Docker)
- **Containers**: 68 services

### Network
- **Router**: Sky Gigafast (SCER11BEL)
- **Mesh**: TP-Link Deco XE75 Pro (3 nodes)
- **DNS**: AdGuard Home

---

## 🏠 Smart Home Summary

### Integrations Active
| Integration | Devices |
|-------------|---------|
| Sonos | 10 speakers |
| Meross | 5 smart plugs |
| Tapo | 4 cameras |
| Harmony | 1 hub |
| LG WebOS | 1 TV (2 pending) |
| Easee | 1 EV charger |

### Integrations Pending Setup
- Tesla Custom (installed)
- Volkswagen Carnet / Cupra (installed)
- TP-Link Deco (installed)
- Xbox (3 consoles)
- Google Cast (Nest Mini)

---

## 🚗 Vehicles

| Vehicle | Integration | Status |
|---------|-------------|--------|
| Tesla | Tesla Custom | ⏳ Needs setup |
| Cupra Born | Volkswagen Carnet | ⏳ Needs setup |
| Easee Charger | Easee | ✅ Active |

---

## 📹 Cameras

| Camera | IP | Frigate | HA |
|--------|-----|---------|-----|
| Hallway | 192.168.50.68 | ✅ | ✅ |
| Kat Kave | 192.168.50.11 | ✅ | ✅ |
| Conservatory | 192.168.50.120 | ✅ | ✅ |
| Office | 192.168.50.104 | ✅ | ✅ |

---

## 🔌 NFC Automations

| Location | Action |
|----------|--------|
| Desk | Toggle Left & Right lamps |

See [[HA-Devices-To-Add-NFC-Ideas]] for more ideas.

---

## 🔧 Maintenance

### Regular Tasks
- [ ] Check Frigate recordings
- [ ] Review HA logs for errors
- [ ] Update containers via Watchtower
- [ ] Backup HA config

### Useful Commands
```bash
# Restart Home Assistant
docker restart homeassistant

# Check Frigate status
curl http://192.168.50.50:5001/api/stats

# View HA logs
tail -f /Users/homelab/HomeLab/Docker/Data/homeassistant/config/home-assistant.log
```

---

## 📝 Recent Changes

### 2025-12-07
- Added Office camera to Frigate
- Installed Tesla Custom, Easee, Volkswagen Carnet, TP-Link Deco integrations
- Added LG WebOS TV (Lounge)
- Created NFC desk lamp automation
- Set up Meross Cloud integration

---

*Last updated: 2025-12-07*
