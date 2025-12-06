# 📑 Service Index

Complete index of all 39 operational services in your HomeLab.

---

## 🔧 Infrastructure (3 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Portainer]] | 9000 | http://192.168.50.50:9000 | Docker management |
| [[Nginx-Proxy-Manager]] | 81 | http://192.168.50.50:81 | Reverse proxy & SSL |
| [[AdGuard-Home]] | 8084 | http://192.168.155.2:8084 | Network ad blocker |

---

## 🎬 Media Services (8 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Plex]] | 32400 | http://192.168.50.50:32400/web | Media server |
| [[Jellyfin]] | 8096 | http://192.168.50.50:8096 | Alternative media server |
| [[Sonarr]] | 8989 | http://192.168.50.50:8989 | TV show automation |
| [[Radarr]] | 7878 | http://192.168.50.50:7878 | Movie automation |
| [[Prowlarr]] | 9696 | http://192.168.50.50:9696 | Indexer manager |
| [[Overseerr]] | 5055 | http://192.168.50.50:5055 | Media requests |
| [[Transmission]] | 9091 | http://192.168.50.50:9091/transmission/web/ | Download client |
| [[Tautulli]] | 8181 | http://192.168.50.50:8181 | Plex statistics |

---

## 🏡 Smart Home (4 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Home-Assistant]] | 8123 | http://192.168.50.50:8123 | Smart home hub |
| [[Node-RED]] | 1880 | http://192.168.50.50:1880 | Automation flows |
| [[Zigbee2MQTT]] | 8080 | http://192.168.50.50:8080 | Zigbee bridge |
| [[ESPHome]] | 6052 | http://192.168.50.50:6052 | ESP device manager |

---

## 🤖 AI Services (3 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Open-WebUI]] | 3000 | http://192.168.50.50:3000 | ChatGPT interface |
| [[Ollama]] | 11434 | http://192.168.50.50:11434 | Local LLM engine |
| [[Jupyter]] | 8888 | http://192.168.50.50:8888 | Data science notebooks |

---

## 📊 Monitoring (7 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Grafana]] | 3003 | http://192.168.50.50:3003 | Metrics dashboards |
| [[Prometheus]] | 9090 | http://192.168.50.50:9090 | Metrics collection |
| [[Uptime-Kuma]] | 3004 | http://192.168.50.50:3004 | Uptime monitoring |
| [[Netdata]] | 19999 | http://192.168.50.50:19999 | Real-time stats |
| [[cAdvisor]] | 8085 | http://192.168.50.50:8085 | Container metrics |
| [[Loki]] | 3100 | http://192.168.50.50:3100 | Log aggregation |
| [[InfluxDB]] | 8086 | http://192.168.50.50:8086 | Time-series database |

---

## 🔐 Security (2 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Vaultwarden]] | 8088 | http://192.168.50.50:8088 | Password manager |
| [[CrowdSec]] | 8089 | http://192.168.50.50:8089 | Security IPS |

---

## 💾 Storage & Backup (5 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Nextcloud]] | 8097 | http://192.168.50.50:8097 | Cloud storage |
| [[PhotoPrism]] | 2342 | http://192.168.50.50:2342 | Photo management |
| [[File-Browser]] | 8087 | http://192.168.50.50:8087 | Web file manager |
| [[Syncthing]] | 8384 | http://192.168.50.50:8384 | File sync |
| [[Kopia]] | 8202 | http://192.168.50.50:8202/repo | Backup solution |

---

## 📄 Productivity (4 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Paperless-ngx]] | 8093 | http://192.168.50.50:8093 | Document management |
| [[FreshRSS]] | 8098 | http://192.168.50.50:8098 | RSS reader |
| [[Calibre]] | 8094 | http://192.168.50.50:8094 | E-book manager |
| [[Code-Server]] | 8443 | http://192.168.50.50:8443 | VS Code in browser |
| [[Gitea]] | 3001 | http://192.168.50.50:3001 | Git server |

---

## 📱 Dashboards (3 Services)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[Heimdall]] | 8090 | http://192.168.50.50:8090 | Main dashboard |
| [[Homer]] | 8091 | http://192.168.50.50:8091 | Simple dashboard |
| [[Organizr]] | 8092 | http://192.168.50.50:8092 | Unified dashboard |

---

## 🖥️ Utilities (1 Service)

| Service | Port | URL | Purpose |
|---------|------|-----|---------|
| [[VNC-Desktop]] | 3050 | http://192.168.50.50:3050 | Ubuntu desktop |

---

## Quick Navigation

### By Category
- [[#Infrastructure]]
- [[#Media Services]]
- [[#Smart Home]]
- [[#AI Services]]
- [[#Monitoring]]
- [[#Security]]
- [[#Storage & Backup]]
- [[#Productivity]]
- [[#Dashboards]]

### By Function
**Management:** [[Portainer]] • [[Nginx-Proxy-Manager]] • [[AdGuard-Home]]  
**Media:** [[Plex]] • [[Jellyfin]] • [[Overseerr]]  
**Automation:** [[Sonarr]] • [[Radarr]] • [[Prowlarr]]  
**Smart Home:** [[Home-Assistant]] • [[Node-RED]]  
**AI:** [[Open-WebUI]] • [[Ollama]]  
**Monitoring:** [[Grafana]] • [[Prometheus]] • [[Uptime-Kuma]]  
**Security:** [[Vaultwarden]] • [[CrowdSec]]  
**Storage:** [[Nextcloud]] • [[Kopia]]  

---

## Service Status

✅ **Operational:** 39 services  
⚠️ **Issues:** 0 services  
🔧 **Maintenance:** 0 services

Last checked: [[Uptime-Kuma]]

---

## Related Documentation

- [[../00-START-HERE/Service-Overview|Service Overview]]
- [[../02-How-To-Guides/Add-New-Service|How to Add a Service]]
- [[../04-Disaster-Recovery/Service-Recovery|Service Recovery]]
- [[../09-Reference/Port-Mappings|Port Reference]]

---

*Total Services: 39*  
*Last Updated: November 19, 2025*

## Recently Added (Dec 2025)

| Service | Port | Category | Status |
|---------|------|----------|--------|
| Frigate NVR | 5001 | Security | ✅ Active |
| HACS | - | Home Assistant | ✅ Active |
| Tapo Integration | - | Home Assistant | ✅ Active |

