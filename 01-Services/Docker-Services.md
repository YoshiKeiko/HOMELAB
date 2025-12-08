# Docker Services Reference

## Quick Links
All services accessible at `http://192.168.50.50:PORT`

### Dashboards & Management
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Portainer | 9000 | http://192.168.50.50:9000 | Docker management |
| Heimdall | 8090 | http://192.168.50.50:8090 | App dashboard |
| Dashy | 4000 | http://192.168.50.50:4000 | Dashboard |
| Homer | 8091 | http://192.168.50.50:8091 | Dashboard |
| Organizr | 8092 | http://192.168.50.50:8092 | Tab dashboard |
| Homelab Dashboard | 8000 | http://192.168.50.50:8000 | Custom dashboard |

### Smart Home
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Home Assistant | 8123 | http://192.168.50.50:8123 | Home automation |
| Frigate | 5001 | http://192.168.50.50:5001 | NVR / AI detection |
| Node-RED | 1880 | http://192.168.50.50:1880 | Flow automation |
| Zigbee2MQTT | 8080 | http://192.168.50.50:8080 | Zigbee bridge |
| ESPHome | - | Via HA | ESP device manager |
| Mosquitto | 1883 | mqtt://192.168.50.50:1883 | MQTT broker |

### Media - Streaming
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Plex | 32400 | http://192.168.50.50:32400/web | Media server |
| Jellyfin | 8096 | http://192.168.50.50:8096 | Media server |
| Navidrome | 4533 | http://192.168.50.50:4533 | Music streaming |
| Audiobookshelf | 13378 | http://192.168.50.50:13378 | Audiobooks |

### Media - Management
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Sonarr | 8989 | http://192.168.50.50:8989 | TV shows |
| Radarr | 7878 | http://192.168.50.50:7878 | Movies |
| Prowlarr | 9696 | http://192.168.50.50:9696 | Indexer manager |
| Bazarr | 6767 | http://192.168.50.50:6767 | Subtitles |
| Overseerr | 5055 | http://192.168.50.50:5055 | Request manager |
| Tautulli | 8181 | http://192.168.50.50:8181 | Plex stats |
| Transmission | 9091 | http://192.168.50.50:9091 | Downloads |
| FlareSolverr | 8191 | http://192.168.50.50:8191 | Cloudflare bypass |

### Media - Reading
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Calibre | 8094 | http://192.168.50.50:8094 | eBook management |
| Calibre-Web | 8083 | http://192.168.50.50:8083 | eBook web UI |
| Kavita | 5004 | http://192.168.50.50:5004 | Comics/Manga |
| Komga | 25600 | http://192.168.50.50:25600 | Comics |
| FreshRSS | 8098 | http://192.168.50.50:8098 | RSS reader |

### Productivity
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Nextcloud | 8097 | http://192.168.50.50:8097 | File sync/cloud |
| Paperless-ngx | 8093 | http://192.168.50.50:8093 | Document management |
| Code Server | 8443 | http://192.168.50.50:8443 | VS Code in browser |
| Gitea | 3001 | http://192.168.50.50:3001 | Git server |
| Mealie | 9925 | http://192.168.50.50:9925 | Recipe manager |
| Grocy | 9283 | http://192.168.50.50:9283 | Grocery/inventory |
| Actual Budget | 5006 | http://192.168.50.50:5006 | Budgeting |

### Tools & Utilities
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Stirling PDF | 8078 | http://192.168.50.50:8078 | PDF tools |
| IT-Tools | 8079 | http://192.168.50.50:8079 | Dev utilities |
| File Browser | 8087 | http://192.168.50.50:8087 | Web file manager |
| MakeMKV | 5800 | http://192.168.50.50:5800 | DVD/Blu-ray ripping |
| PhotoPrism | 2342 | http://192.168.50.50:2342 | Photo management |
| Syncthing | 8384 | http://192.168.50.50:8384 | File sync |

### AI & Development
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Ollama | 11434 | http://192.168.50.50:11434 | Local LLM |
| Open WebUI | 3000 | http://192.168.50.50:3000 | LLM chat interface |
| Jupyter | - | - | Data science |

### Monitoring & Security
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Grafana | 3003 | http://192.168.50.50:3003 | Dashboards |
| Prometheus | 9090 | http://192.168.50.50:9090 | Metrics |
| Netdata | 19999 | http://192.168.50.50:19999 | Real-time monitoring |
| Uptime Kuma | 3004 | http://192.168.50.50:3004 | Uptime monitoring |
| cAdvisor | 8085 | http://192.168.50.50:8085 | Container stats |
| Loki | 3100 | http://192.168.50.50:3100 | Log aggregation |
| AdGuard Home | 8084 | http://192.168.50.50:8084 | DNS/Ad blocking |
| CrowdSec | 8089 | http://192.168.50.50:8089 | Security |
| Fail2ban | - | - | Intrusion prevention |
| Vaultwarden | 8088 | http://192.168.50.50:8088 | Password manager |

### Notifications
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| ntfy | 8280 | http://192.168.50.50:8280 | Push notifications |
| ChangeDetection | 5005 | http://192.168.50.50:5005 | Website monitoring |

### Backup & Infrastructure
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| Kopia | 8202 | http://192.168.50.50:8202 | Backup |
| Nginx Proxy Manager | 81 | http://192.168.50.50:81 | Reverse proxy |
| Watchtower | - | - | Auto-update containers |

### Databases
| Service | Port | Purpose |
|---------|------|---------|
| MariaDB | 3306 | MySQL database |
| PostgreSQL | 5432 | PostgreSQL database |
| MongoDB | 27017 | NoSQL database |
| Redis | 6379 | Cache/queue |
| InfluxDB | 8086 | Time-series DB |

### Other
| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| RetroArch | 3090 | http://192.168.50.50:3090 | Retro gaming |
| Kasm VNC | 3050 | http://192.168.50.50:3050 | Remote desktop |
| Agent DVR | 8099 | http://192.168.50.50:8099 | Camera DVR |
| Speedtest Tracker | 8765 | http://192.168.50.50:8765 | Internet speed |

---

## Container Count: 68

## Data Locations
```
/Users/homelab/HomeLab/Docker/Data/
├── homeassistant/config/
├── frigate/config/
├── plex/
├── jellyfin/
├── nextcloud/
├── paperless/
├── grafana/
├── prometheus/
└── [service]/
```

## Useful Commands

### Container Management
```bash
# List running containers
docker ps

# Restart a service
docker restart <container_name>

# View logs
docker logs <container_name> --tail 100

# Update all containers (via Watchtower)
docker exec watchtower /watchtower --run-once
```

### Health Check
```bash
# Check all container status
docker ps --format "table {{.Names}}\t{{.Status}}"

# Check resource usage
docker stats --no-stream
```

---
*Last updated: 2025-12-07*
