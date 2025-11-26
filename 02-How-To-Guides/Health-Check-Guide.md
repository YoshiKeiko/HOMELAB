---
title: Health Check Guide
tags: [homelab, monitoring, health, scripts]
created: 2025-11-26
updated: 2025-11-26
type: guide
---

# Health Check Guide

**Automated monitoring and verification of all homelab services**

---

## Quick Health Check

Run the health check script:

```bash
bash /Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh
```

Or with Claude Code:

```bash
claude "Run the health check script and summarize any failures"
```

---

## What the Health Check Does

1. **Lists all running containers** - Shows total count
2. **Tests all web UIs** - HTTP request to each service
3. **Shows container status** - Running/stopped/healthy
4. **Reports stopped containers** - Any failed services
5. **Disk space** - System and external drive usage
6. **Docker disk usage** - Images, containers, volumes
7. **Memory usage** - Top 20 containers by RAM

---

## Expected HTTP Codes

| Code | Meaning | Status |
|------|---------|--------|
| 200 | OK | ✅ Working |
| 301/302 | Redirect | ✅ Working (redirects to login) |
| 303 | See Other | ✅ Working |
| 307 | Temporary Redirect | ✅ Working |
| 401 | Unauthorized | ✅ Working (needs auth) |
| 000 | Connection Failed | ❌ Problem |
| 500+ | Server Error | ❌ Problem |

---

## Health Check Script

Location: `/Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh`

```bash
#!/bin/bash

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║          HOMELAB CONTAINER HEALTH CHECK                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"

# ... (full script in scripts folder)
```

---

## Services Checked

### Core Infrastructure
- Portainer (9000)
- Heimdall (8090)
- Grafana (3003)
- Prometheus (9090)
- Uptime Kuma (3004)
- AdGuard Home (8084)

### Media Stack
- Plex (32400)
- Jellyfin (8096)
- Sonarr (8989)
- Radarr (7878)
- Prowlarr (9696)
- Overseerr (5055)
- Tautulli (8181)
- Transmission (9091)

### Smart Home & IoT
- Home Assistant (8123)
- Node-RED (1880)
- Zigbee2MQTT (8080)
- ESPHome (6052)

### AI & Development
- Ollama API (11434)
- Open WebUI (3000)
- Jupyter (8888)
- Code Server (8443)
- Gitea (3001)

### Productivity & Documents
- Nextcloud (8097)
- Paperless (8093)
- Calibre (8094)
- FreshRSS (8098)
- PhotoPrism (2342)
- Vaultwarden (8088)

### Monitoring & Databases
- Netdata (19999)
- cAdvisor (8085)
- Loki (3100)
- InfluxDB (8086)

### Surveillance
- Agent DVR (8099)

### Dashboards
- Homer (8091)
- Dashy (4000)
- Organizr (8092)

### Security & Infrastructure
- Nginx Proxy Manager (81)
- Filebrowser (8087)

### Backup
- Kopia (8202)
- Syncthing (8384)

### Other
- KASM VNC (3050)
- Flaresolverr (8191)

---

## Troubleshooting Failed Services

### HTTP 000 - Connection Failed

Container is running but web UI not responding:

```bash
# Check container logs
docker logs <container_name> --tail 50

# Check port binding
docker port <container_name>

# Check if service is listening inside container
docker exec <container_name> netstat -tlnp
```

### Container Not Running

```bash
# Check status
docker ps -a | grep <container_name>

# Start container
docker start <container_name>

# Check logs for crash reason
docker logs <container_name>
```

### Container Restarting (Crash Loop)

```bash
# Check logs for error
docker logs <container_name> --tail 100

# Common fixes:
# - Missing config file
# - Permission issues
# - Port conflict
# - Missing environment variable
```

---

## Manual Quick Test

Test a single service:

```bash
curl -s -o /dev/null -w "%{http_code}" http://192.168.50.50:8090
```

Test all services:

```bash
for port in 8090 8091 8092 4000 9000 32400 8096 8989 7878; do
  echo -n "Port $port: "
  curl -s -o /dev/null -w "%{http_code}\n" --max-time 5 "http://192.168.50.50:$port"
done
```

---

## Scheduling Health Checks

### Cron Job (Optional)

```bash
# Run every hour and log results
0 * * * * /Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh >> /Users/homelab/health-check.log 2>&1
```

### Uptime Kuma (Recommended)

Use Uptime Kuma (http://192.168.50.50:3004) for:
- Continuous monitoring
- Notifications on failure
- Historical uptime tracking

---

## Related Pages

- [[Master-Service-List]]
- [[Troubleshooting]]
- [[Claude-Code-Setup]]

---

*Last Updated: 2025-11-26*
