# Home Assistant - Devices to Add & NFC Ideas

## Currently Integrated ✅

| Device | Integration | IP |
|--------|------------|-----|
| Sonos Speakers (10) | sonos | Various |
| Meross Smart Plugs (5) | meross_cloud | Various |
| Harmony Hub | harmony | 192.168.50.15 |
| Brother Printer | brother | - |
| Tapo Cameras (3) | tapo_control | .11, .68, .120 |
| MQTT Broker | mqtt | 192.168.50.50 |
| Samsung Phones (2) | mobile_app | - |

---

## Devices NOT Yet Integrated 🔴

### High Priority - Easy Setup

| Device | IP | Integration | Notes |
|--------|-----|-------------|-------|
| **LG WebOS TV** | 192.168.50.41 | `webostv` | Built-in, auto-discovery |
| **Google Nest Mini** | 192.168.50.154 | `cast` | Built-in Google Cast |
| **Tesla** | 192.168.50.106 | `tesla_fleet` or `tessie` | Charging, climate, location |
| **Easee EV Charger** | 192.168.50.128 | `easee` | HACS - charging control |
| **ESP Device** | 192.168.50.93 | `esphome` | ESPHome already running |

### Medium Priority

| Device | IP | Integration | Notes |
|--------|-----|-------------|-------|
| **TP-Link Deco** | 192.168.50.59 | `tplink_deco` | HACS - device tracker |
| **Xbox** | 192.168.50.21 | `xbox` | Built-in - power, game info |
| **Cupra/Seat** | 192.168.50.27 | `seat` | HACS - Cupra Connect |
| **OctoPrint (3D Printer)** | 192.168.50.217 | `octoprint` | Built-in - print status |

### Device Tracking (Presence Detection)

| Device | IP | Method |
|--------|-----|--------|
| iPad | 192.168.50.43 | `ping` / `nmap` tracker |
| iPhone | 192.168.50.81 | `ping` / `nmap` tracker |
| MacBook Air | 192.168.50.116 | `ping` / `nmap` tracker |
| MacBook Pro | 192.168.50.149 | `ping` / `nmap` tracker |
| Dee's S24 | 192.168.50.220 | HA Companion App |

---

## NFC Automation Ideas 💡

### Desk/Office
| Tag Location | Action | Entities |
|-------------|--------|----------|
| ✅ Desk | Toggle desk lamps | `switch.left_lamp_like`, `switch.right_light_init` |
| Monitor stand | Toggle PC setup (monitor, speakers, lamp) | Multiple switches |
| Under desk | Start/stop work timer or focus mode | Input boolean + notifications |

### Living Room
| Tag Location | Action | Entities |
|-------------|--------|----------|
| Coffee table | Movie mode (dim lights, TV on, Sonos) | Scene or script |
| Remote caddy | Toggle LG TV | `media_player.lg_webos_tv` |
| Sofa arm | Play/pause Sonos | `media_player.living_room` |

### Bedroom
| Tag Location | Action | Entities |
|-------------|--------|----------|
| Nightstand | Goodnight routine (all lights off, lock doors) | Scene |
| Bedside | Toggle bedside lamp | Meross switch |
| Alarm clock | Morning routine (lights on, coffee, news) | Script |

### Kitchen
| Tag Location | Action | Entities |
|-------------|--------|----------|
| Fridge | Add item to shopping list | `shopping_list.add_item` |
| Coffee machine | Start coffee playlist on Sonos | Media player |
| Timer spot | Start cooking timer | Timer helper |

### Entrance/Hallway
| Tag Location | Action | Entities |
|-------------|--------|----------|
| Door frame | Leaving home (lights off, cameras on) | Scene |
| Key hook | Arriving home (lights on, disarm) | Scene |
| Coat hook | Toggle hallway lights | Light entity |

### Car/Garage
| Tag Location | Action | Entities |
|-------------|--------|----------|
| Car mount | Start Tesla charging | `button.tesla_charge_start` |
| Dashboard | Toggle Easee charger | `switch.easee_charger` |
| Garage door | Check home status notification | Script |

### Media/Entertainment
| Tag Location | Action | Entities |
|-------------|--------|----------|
| Game controller | Xbox on + TV input switch | Xbox + LG TV |
| Vinyl record | Play specific Sonos playlist | Media player |
| Cinema seat | Cinema mode (Harmony activity) | `remote.cinema_room` |

### Utility
| Tag Location | Action | Entities |
|-------------|--------|----------|
| 3D printer | Check OctoPrint status | Notification |
| Laundry | Start washer done timer | Timer + notification |
| Pet food | Log feeding time | Input datetime |

---

## Quick Setup Commands

### Add LG TV
```
Settings → Devices & Services → + Add Integration → LG webOS Smart TV
```

### Add Google Cast
```
Settings → Devices & Services → + Add Integration → Google Cast
(Auto-discovers Nest Mini)
```

### Add Easee (HACS)
```
HACS → Integrations → Search "Easee" → Install → Restart HA
Settings → Add Integration → Easee → Enter credentials
```

### Add Tesla
```
Settings → Devices & Services → + Add Integration → Tesla Fleet
(Requires Tesla account linking)
```

---
*Updated: 2025-12-07*
