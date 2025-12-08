# Network Inventory

## Network Infrastructure

### Router/Gateway
| Device | IP | MAC | Notes |
|--------|-----|-----|-------|
| Sky Gigafast Router (SCER11BEL) | 192.168.50.1 | e8:76:40:fe:27:8e | Main router, connected to ONT |

### Mesh Network (TP-Link Deco XE75 Pro)
| Device | IP | MAC | Notes |
|--------|-----|-----|-------|
| Deco Main | 192.168.50.59 | 50:3d:d1:fa:20:0 | Primary mesh node |
| Deco Node 2 | 192.168.50.70 | 50:3d:d1:fa:42:b5 | Secondary |
| Deco Node 3 | 192.168.50.121 | 50:3d:d1:fa:65:b0 | Secondary |

---

## Homelab Server
| Device | IP | MAC | Notes |
|--------|-----|-----|-------|
| Mac Mini (homelab) | 192.168.50.50 | d0:11:e5:bb:70:b | Docker host, HA, Frigate, etc. |

---

## Smart Home Devices

### Cameras (Tapo)
| Device | IP | MAC | Model | Location |
|--------|-----|-----|-------|----------|
| Hallway | 192.168.50.68 | 78:20:51:42:67:45 | C230 | Front hallway |
| Kat Kave | 192.168.50.11 | 78:20:51:42:4b:d | C210 | Cat room |
| Conservatory | 192.168.50.120 | 98:25:4a:82:88:10 | C210 | Conservatory |
| Office | 192.168.50.104 | - | C210 | Office |

### Smart Plugs (Meross MSS110)
| Device | IP | MAC |
|--------|-----|-----|
| Left Lamp Like | 192.168.50.110 | 48:e1:e9:a6:98:67 |
| Right Light Init | 192.168.50.163 | 48:e1:e9:a6:98:9c |
| Kat Cave | 192.168.50.40 | 48:e1:e9:da:e5:fa |
| M@ | 192.168.50.155 | 48:e1:e9:a6:98:94 |
| Shork Charge | - | 48:e1:e9:a6:98:9a (offline) |

### Smart Home Hubs
| Device | IP | MAC | Notes |
|--------|-----|-----|-------|
| Harmony Hub | 192.168.50.15 | c8:db:26:4:26:6c | Cinema Room |
| Google Nest Mini | 192.168.50.154 | 14:c1:4e:92:ce:6b | Voice assistant |

### Sonos Speakers
| Device | IP | MAC |
|--------|-----|-----|
| Sonos (Kitchen) | 192.168.50.111 | b8:e9:37:88:8b:3e |
| Sonos (Living Room) | 192.168.50.26 | 54:2a:1b:db:9b:50 |
| Sonos | 192.168.50.115 | 5c:aa:fd:9d:4d:de |
| Sonos | 192.168.50.109 | 38:42:b:34:8c:20 |
| Sonos | 192.168.50.114 | 94:9f:3e:f1:bc:64 |

---

## Entertainment

### TVs (LG WebOS)
| Device | IP | MAC | Model | Location |
|--------|-----|-----|-------|----------|
| Lounge TV | 192.168.50.102 | - | 75NANO996NA (75") | Living Room |
| Kitchen TV | TBD | - | 50" 9th Gen | Kitchen |
| Office TV | TBD | - | - | Office |

### Gaming Consoles
| Device | IP | Notes |
|--------|-----|-------|
| Xbox One X | 192.168.50.21 | xboxone-s hostname |
| Xbox One S #1 | TBD | - |
| Xbox One S #2 | TBD | - |
| PS5 #1 | TBD | - |
| PS5 #2 | TBD | - |
| Nintendo Switch | TBD | No HA integration |

---

## Vehicles

### EV Charging
| Device | IP | MAC | Notes |
|--------|-----|-----|-------|
| Easee One Charger | 192.168.50.128 | 58:bf:25:2b:7e:34 | EV charger |

### Connected Cars
| Vehicle | Integration | Notes |
|---------|-------------|-------|
| Tesla | Tesla Custom | Pending setup |
| Cupra Born | Volkswagen Carnet | Pending setup |
| Cupra (Infotainment) | 192.168.50.27 | WiFi connected |

---

## Computers & Mobile

### Computers
| Device | IP | Notes |
|--------|-----|-------|
| MacBook Air | 192.168.50.116 | d2:ca:63:a4:a7:51 |
| MacBook Pro | 192.168.50.149 | ce:2c:6e:69:b1:0 |
| IT Support | 192.168.50.44 | Work laptop |

### Mobile Devices
| Device | IP | Notes |
|--------|-----|-------|
| SM-S938B | - | Steve's phone (HA app) |
| SM-S921B | - | Secondary phone (HA app) |
| iPad | 192.168.50.43 | 5a:ec:94:1a:31:b6 |
| Dee's S24 | 192.168.50.220 | d2:fa:66:6a:87:1 |

---

## Other Devices

| Device | IP | MAC | Notes |
|--------|-----|-----|-------|
| Brother Printer | 192.168.50.139 | - | DCP-L3550CDW |
| ESP Device | 192.168.50.93 | 84:d:8e:8d:8a:58 | Unknown purpose |
| OctoPrint | 192.168.50.217 | 8c:4f:0:18:4d:88 | 3D printer |

---

## IP Ranges

| Range | Purpose |
|-------|---------|
| 192.168.50.1-9 | Network infrastructure |
| 192.168.50.10-49 | Smart home / IoT |
| 192.168.50.50-99 | Servers / Services |
| 192.168.50.100-149 | Cameras / Entertainment |
| 192.168.50.150-199 | Computers |
| 192.168.50.200-254 | Mobile / Dynamic |

---
*Last updated: 2025-12-07*
