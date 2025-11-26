# 🏠 HomeLab Configuration Walkthrough Index

**Complete Step-by-Step Guide for All 47 Services**

## 📋 How to Use This Guide

1. Start with **Phase 1** (Core Services)
2. Work through each phase in order
3. Each service has checkboxes - tick them off as you complete
4. Take your time - don't rush
5. Bookmark services as you configure them

## 🗂️ Configuration Phases

### Phase 1: Core Infrastructure (Essential)
1. [Portainer](01-Portainer.md) - Docker Management (START HERE!)
2. [Watchtower](02-Watchtower.md) - Auto-updates

### Phase 2: Databases (Auto-configured)
- Already configured - no action needed
- PostgreSQL, MariaDB, MongoDB, Redis, InfluxDB

### Phase 3: Essential Dashboards
3. [Heimdall](03-Heimdall.md) - Main Dashboard (IMPORTANT!)
4. [Homer](04-Homer.md) - Alternative Dashboard
5. [Dashy](05-Dashy.md) - Modern Dashboard
6. [Organizr](06-Organizr.md) - Tabbed Dashboard

### Phase 4: Media Stack
7. [Plex](07-Plex.md) - Media Server
8. [Jellyfin](08-Jellyfin.md) - Open Source Alternative
9. [Prowlarr](09-Prowlarr.md) - Indexer Manager (Configure FIRST)
10. [Radarr](10-Radarr.md) - Movie Manager
11. [Sonarr](11-Sonarr.md) - TV Show Manager
12. [Transmission](12-Transmission.md) - Download Client
13. [Overseerr](13-Overseerr.md) - Request Management

### Phase 5: Monitoring
14. [Grafana](14-Grafana.md) - Dashboards
15. [Prometheus](15-Prometheus.md) - Metrics
16. [Uptime Kuma](16-Uptime-Kuma.md) - Uptime Monitoring
17. [Netdata](17-Netdata.md) - Real-time Monitoring

### Phase 6: AI & Development
18. [OpenWebUI](18-OpenWebUI.md) - AI Chat Interface
19. [Ollama](19-Ollama.md) - LLM Server
20. [Code Server](20-Code-Server.md) - VS Code
21. [Jupyter](21-Jupyter.md) - Python Notebooks
22. [Gitea](22-Gitea.md) - Git Server

### Phase 7: Smart Home
23. [Home Assistant](23-Home-Assistant.md) - Smart Home Hub
24. [Node-RED](24-Node-RED.md) - Automation Flows
25. [ESPHome](25-ESPHome.md) - DIY Devices

### Phase 8: Storage & Backup
26. [Nextcloud](26-Nextcloud.md) - Cloud Storage
27. [Syncthing](27-Syncthing.md) - File Sync
28. [Duplicati](28-Duplicati.md) - Backups
29. [File Browser](29-File-Browser.md) - Web File Manager

### Phase 9: Security
30. [Vaultwarden](30-Vaultwarden.md) - Password Manager
31. [AdGuard Home](31-AdGuard.md) - DNS Ad Blocking

### Phase 10: Utilities
32. [Paperless-ngx](32-Paperless.md) - Document Management
33. [PhotoPrism](33-PhotoPrism.md) - Photo Management
34. [Calibre](34-Calibre.md) - eBook Management
35. [FreshRSS](35-FreshRSS.md) - RSS Reader

## ⏱️ Time Estimates

- **Phase 1 (Core):** 15 minutes
- **Phase 3 (Dashboards):** 30 minutes
- **Phase 4 (Media):** 1-2 hours
- **Phase 5 (Monitoring):** 1 hour
- **Phase 6 (AI):** 30 minutes
- **Phase 7 (Smart Home):** 2-3 hours
- **Phase 8 (Storage):** 1 hour
- **Phase 9 (Security):** 30 minutes
- **Phase 10 (Utilities):** 1-2 hours

**Total Time:** 8-12 hours (spread over several days)

## 🎯 Quick Start Path (Essential Services Only)

If you want to get started quickly, configure these first:

1. ✅ Portainer (essential for troubleshooting)
2. ✅ Heimdall (your homepage)
3. ✅ Plex or Jellyfin (media streaming)
4. ✅ Home Assistant (if you have smart home devices)
5. ✅ OpenWebUI (if you want local AI)
6. ✅ Nextcloud (personal cloud)
7. ✅ Vaultwarden (password manager)

Then configure the rest as you need them!

---

**Your Tailscale IP:** 100.96.129.29  
**All services accessible at:** http://100.96.129.29:PORT

