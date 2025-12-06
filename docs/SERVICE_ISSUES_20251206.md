# 🔧 HomeLab Service Issues & Fixes
> Generated: December 6, 2025
> Run these commands on the HomeLab (192.168.50.50)

## ❌ Critical Issues (Not Working)

### 1. Vaultwarden (:8088) - Freezes/Doesn't Load
```bash
# Check container status
docker ps -a | grep vaultwarden
docker logs vaultwarden --tail 50

# Restart the container
docker restart vaultwarden

# If still broken, recreate:
docker stop vaultwarden
docker rm vaultwarden
docker run -d \
  --name vaultwarden \
  --restart unless-stopped \
  -v ~/HomeLab/Docker/Data/vaultwarden:/data \
  -p 8088:80 \
  vaultwarden/server:latest
```

### 2. CrowdSec (:8089) - Not Working
```bash
# Check status
docker ps -a | grep crowdsec
docker logs crowdsec --tail 50

# CrowdSec dashboard requires enrollment
docker exec crowdsec cscli dashboard setup
# Follow the enrollment key instructions

# Restart
docker restart crowdsec
```

### 3. Loki (:3100) - 404 Error
```bash
# Check if container exists
docker ps -a | grep loki

# If not running:
docker pull grafana/loki:latest
docker run -d \
  --name loki \
  --restart unless-stopped \
  -p 3100:3100 \
  -v ~/HomeLab/Docker/Data/loki:/loki \
  grafana/loki:latest

# If running but 404, check config:
docker logs loki --tail 50
```

### 4. Node Exporter (:9100) - Not Working
```bash
# Node exporter doesn't have a web UI - access /metrics
curl http://localhost:9100/metrics

# If not running:
docker run -d \
  --name node-exporter \
  --restart unless-stopped \
  --net=host \
  --pid=host \
  -v /:/host:ro,rslave \
  quay.io/prometheus/node-exporter:latest \
  --path.rootfs=/host
```

### 5. Mosquitto MQTT (:1883) - Empty Response
```bash
# MQTT broker doesn't have HTTP interface - test with mosquitto client
docker exec -it mosquitto mosquitto_sub -t test -C 1 &
docker exec -it mosquitto mosquitto_pub -t test -m "hello"

# Check logs
docker logs mosquitto --tail 50

# Restart
docker restart mosquitto

# If authentication issues, check config:
docker exec -it mosquitto cat /mosquitto/config/mosquitto.conf
```

---

## ⚠️ Warning Issues (Need Configuration)

### 6. Plex (:32400) - Bad Request
```bash
# This usually means Plex needs to be accessed via web UI
# Try: http://192.168.50.50:32400/web

# If still broken, check logs:
docker logs plex --tail 50

# Restart
docker restart plex
```

### 7. Transmission (:9091) - No Login
```bash
# Check if authentication is enabled
docker exec transmission cat /config/settings.json | grep -i auth

# To enable authentication, edit settings.json:
docker stop transmission
# Edit ~/HomeLab/Docker/Data/transmission/config/settings.json
# Set: "rpc-authentication-required": true
# Set: "rpc-username": "admin"
# Set: "rpc-password": "your_password"
docker start transmission
```

### 8. Jupyter (:8888) - Token Required
```bash
# Get the current token:
docker logs jupyter 2>&1 | grep token

# Or generate a new token:
docker exec jupyter jupyter server list

# To disable token (not recommended):
# Add to jupyter config: c.ServerApp.token = ''
```

### 9. InfluxDB (:8086) - No Admin
```bash
# First-time setup - access http://192.168.50.50:8086
# Follow the setup wizard to create admin user

# Or via CLI:
docker exec -it influxdb influx setup \
  --username admin \
  --password HomeLab123! \
  --org homelab \
  --bucket homelab \
  --force
```

### 10. File Browser (:8087) - Credential Issue
```bash
# Default credentials: admin / admin
# If that doesn't work, reset:
docker stop filebrowser
rm ~/HomeLab/Docker/Data/filebrowser/filebrowser.db
docker start filebrowser
# Default login will be: admin / admin
```

### 11. PhotoPrism (:2342) - Default Login
```bash
# Default credentials: admin / insecure
# Or admin / admin

# To reset admin password:
docker exec -it photoprism photoprism passwd admin
```

### 12. Nextcloud (:8097) - Not Setup
```bash
# Access http://192.168.50.50:8097
# Complete the setup wizard:
# - Create admin account
# - Database: PostgreSQL (if using) or SQLite
# - Data folder: /var/www/html/data
```

### 13. Homer (:8091) - No Config Found
```bash
# Create default config:
cat > ~/HomeLab/Docker/Data/homer/config.yml << 'EOF'
title: "Steve's HomeLab"
subtitle: "Service Dashboard"
logo: "logo.png"
header: true
footer: '<p>HomeLab Dashboard</p>'

services:
  - name: "Infrastructure"
    icon: "fas fa-server"
    items:
      - name: "Portainer"
        logo: "https://www.portainer.io/hubfs/portainer-logo-black.svg"
        url: "http://192.168.50.50:9000"
      - name: "Home Assistant"
        logo: "https://www.home-assistant.io/images/home-assistant-logo.svg"
        url: "http://192.168.50.50:8123"
EOF

docker restart homer
```

### 14. Calibre Server (:8095)
```bash
# Check if calibre-web or calibre content server
docker ps -a | grep calibre

# If not running:
docker restart calibre
# or calibre-web if that's the container name
```

---

## 🔄 Quick Fix Script

Run this on the HomeLab to restart all problematic services:

```bash
#!/bin/bash
echo "Restarting problematic services..."

services=(vaultwarden crowdsec loki node-exporter mosquitto plex transmission jupyter influxdb filebrowser photoprism nextcloud homer calibre)

for service in "${services[@]}"; do
    if docker ps -a --format '{{.Names}}' | grep -q "^${service}$"; then
        echo "Restarting $service..."
        docker restart "$service" 2>/dev/null
    else
        echo "⚠️  $service container not found"
    fi
done

echo "Done! Wait 30 seconds then test services."
```

---

## 📝 Service Status Checklist

| Service | Port | Status | Action Needed |
|---------|------|--------|---------------|
| Vaultwarden | 8088 | ❌ | Restart/Recreate |
| CrowdSec | 8089 | ❌ | Setup Dashboard |
| Loki | 3100 | ❌ | Check Container |
| Node Exporter | 9100 | ❌ | Use /metrics endpoint |
| Mosquitto | 1883 | ❌ | No HTTP UI (use MQTT client) |
| Plex | 32400 | ⚠️ | Use /web path |
| Transmission | 9091 | ⚠️ | Enable auth |
| Jupyter | 8888 | ⚠️ | Get token |
| InfluxDB | 8086 | ⚠️ | Run setup |
| File Browser | 8087 | ⚠️ | Reset credentials |
| PhotoPrism | 2342 | ⚠️ | admin/insecure |
| Nextcloud | 8097 | ⚠️ | Complete setup |
| Homer | 8091 | ⚠️ | Create config |
| Calibre Server | 8095 | ⚠️ | Check container |
| FlareSolverr | 8191 | ✅ | Working |

---

## 🔗 Links

- HomeLab Server: `192.168.50.50`
- MacBook Pro: `192.168.50.55`
- SSH: `ssh homelab@192.168.50.50`
