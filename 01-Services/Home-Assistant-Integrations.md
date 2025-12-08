# Home Assistant - Complete Integration Guide

## Overview
Home Assistant running in Docker on homelab Mac Mini.
- **URL**: http://192.168.50.50:8123
- **Config**: `/Users/homelab/HomeLab/Docker/Data/homeassistant/config/`

## Installed Integrations

### Core Integrations (Built-in)

| Integration | Device/Service | Status |
|-------------|---------------|--------|
| Backup | System backups | ✅ Active |
| Brother | DCP-L3550CDW Printer | ✅ Active |
| DLNA | Plex Media Server | ✅ Active |
| Google Translate | TTS | ✅ Active |
| Met.no | Weather (Home) | ✅ Active |
| MQTT | 192.168.50.50:1883 | ✅ Active |
| Radio Browser | Internet radio | ✅ Active |
| Shopping List | Shopping list | ✅ Active |
| Sonos | 10 speakers | ✅ Active |
| Sun | Sun position | ✅ Active |
| WebOS TV | LG 75NANO996NA (Lounge) | ✅ Active |
| go2rtc | Stream proxy | ✅ Active |

### HACS Integrations (Custom)

| Integration | Purpose | Status |
|-------------|---------|--------|
| HACS | Integration manager | ✅ Active |
| Harmony | Logitech Harmony Hub | ✅ Active |
| Meross Cloud | Smart plugs (5) | ✅ Active |
| Meross LAN | Local Meross control | ✅ Installed |
| Tapo Control | Tapo cameras (4) | ✅ Active |
| Easee | EV Charger | ✅ Active |
| Tesla Custom | Tesla vehicle | ⏳ Needs setup |
| Volkswagen Carnet | Cupra Born | ⏳ Needs setup |
| TP-Link Deco | Mesh network | ⏳ Needs setup |

### Mobile Apps

| Device | Platform | User |
|--------|----------|------|
| SM-S938B | Android | Steve (primary) |
| SM-S921B | Android | Secondary |

---

## Integration Details

### Sonos (10 Speakers)
Speakers discovered via zeroconf:
- Hall
- Living Room (3 units - likely soundbar + surrounds)
- Kitchen (2 units)
- Office
- Media Room
- Portable
- Sub Mini

**Entities**: `media_player.kitchen`, `media_player.living_room`, `media_player.office`, etc.

### Meross Smart Plugs (5 units)
| Name | Entity | Status |
|------|--------|--------|
| Left Lamp Like | `switch.left_lamp_like_mss110_main_channel` | Online |
| Right Light Init | `switch.right_light_init_mss110_main_channel` | Online |
| Kat Cave | `switch.kat_cave_mss110_main_channel` | Online |
| M@ | `switch.m_mss110_main_channel` | Online |
| Shork Charge | `switch.shork_charge_mss110_main_channel` | Offline |

### Harmony Hub (Cinema Room)
- **Location**: Cinema/Media Room
- **Activities**: Configured via Harmony app
- **Entity**: `remote.cinema_room`

### LG WebOS TV
- **Model**: 75NANO996NA
- **IP**: 192.168.50.102
- **Entity**: `media_player.lg_webos_tv_75nano996na`
- **Features**: Power, volume, source, apps, notifications

### Easee EV Charger
- **Account**: steve@accredible.com
- **Model**: Easee One
- **IP**: 192.168.50.128
- **Features**: Start/stop charging, current limit, scheduling

### Tapo Cameras
See [[Cameras-Frigate]] for full documentation.

---

## Pending Setup

### Tesla Custom
```
Settings → Devices & Services → + Add Integration → Tesla Custom
Enter Tesla account email and password
```

### Volkswagen Carnet (Cupra Born)
```
Settings → Devices & Services → + Add Integration → Volkswagen
Enter Cupra Connect email and password
Select region: EU
```

### TP-Link Deco
```
Settings → Devices & Services → + Add Integration → TP-Link Deco
Enter main Deco IP: 192.168.50.59
Enter Deco admin password
```

---

## Custom Components Location
```
/Users/homelab/HomeLab/Docker/Data/homeassistant/config/custom_components/
├── easee/
├── hacs/
├── meross_cloud/
├── meross_lan/
├── tapo_control/
├── tesla_custom/
├── tplink_deco/
└── volkswagencarnet/
```

---

## Adding New Integrations

### Via UI (Recommended)
```
Settings → Devices & Services → + Add Integration → Search
```

### Via HACS
```
HACS → Integrations → + Explore & Download Repositories → Search → Install
Then restart HA and add via UI
```

### Manual Install
1. Download integration to `custom_components/`
2. Restart Home Assistant
3. Add via Settings → Devices & Services

---
*Last updated: 2025-12-07*
