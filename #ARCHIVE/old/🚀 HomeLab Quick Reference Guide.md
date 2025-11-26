

**Steve's Epic HomeLab - Quick Access Guide**

Last Updated: November 2025

---

## 📍 Network Information

| Item | Value |
|------|-------|
| **M4 Mac Mini IP** | 192.168.50.10 |
| **M4 Tailscale IP** | 100.x.x.x (check: `tailscale ip -4`) |
| **Router** | 192.168.50.1 |
| **DNS** | 192.168.50.1, 1.1.1.1 |
| **Subnet** | 255.255.255.0 |
| **Gateway** | 192.168.50.1 |
| **Internet** | 5Gbps/5Gbps CityFibre |

---

## 🌐 Service URLs

### Access at Home (Direct IP)
```
Infrastructure:
├─ Nginx Proxy Manager:  http://192.168.50.10:81
├─ Portainer:            https://192.168.50.10:9443
├─ Homer Dashboard:      http://192.168.50.10:8080
└─ Watchtower:           (background service)

Media:
├─ Plex:                 http://192.168.50.10:32400/web
├─ Sonarr:               http://192.168.50.10:8989
├─ Radarr:               http://192.168.50.10:7878
├─ Prowlarr:             http://192.168.50.10:9696
├─ Bazarr:               http://192.168.50.10:6767
├─ Overseerr:            http://192.168.50.10:5055
├─ Tdarr:                http://192.168.50.10:8265
└─ qBittorrent:          http://192.168.50.10:8112

Smart Home:
├─ Home Assistant:       http://192.168.50.10:8123
├─ Frigate NVR:          http://192.168.50.10:5000
├─ Scrypted:             https://192.168.50.10:10443
└─ Mosquitto MQTT:       192.168.50.10:1883

AI & Productivity:
├─ Ollama API:           http://192.168.50.10:11434
├─ Open WebUI:           http://192.168.50.10:3000
├─ Paperless-ngx:        http://192.168.50.10:8010
└─ Immich:               http://192.168.50.10:2283

Monitoring:
├─ Prometheus:           http://192.168.50.10:9090
├─ Grafana:              http://192.168.50.10:3001
├─ Loki:                 http://192.168.50.10:3100
├─ Uptime Kuma:          http://192.168.50.10:3002
└─ Netdata:              http://192.168.50.10:19999

Security:
├─ Pi-hole:              http://192.168.50.10:8053/admin
└─ Authelia:             http://192.168.50.10:9091

Backup & Automation:
├─ Kopia:                http://192.168.50.10:51515
└─ N8N:                  http://192.168.50.10:5678
```

### Access via DuckDNS (From Anywhere)
```
https://npm.stevehomelab.duckdns.org       → Nginx Proxy Manager
https://portainer.stevehomelab.duckdns.org → Portainer
https://home.stevehomelab.duckdns.org      → Homer Dashboard
https://plex.stevehomelab.duckdns.org      → Plex
https://ha.stevehomelab.duckdns.org        → Home Assistant
https://overseerr.stevehomelab.duckdns.org → Overseerr
https://grafana.stevehomelab.duckdns.org   → Grafana
https://status.stevehomelab.duckdns.org    → Uptime Kuma
```

---

## 🔑 Default Credentials

**CHANGE ALL OF THESE IMMEDIATELY!**

| Service | Username | Default Password |
|---------|----------|------------------|
| Nginx Proxy Manager | admin@example.com | changeme |
| Portainer | admin | (set during first login) |
| Plex | (use plex.tv account) | - |
| Home Assistant | (set during first login) | - |
| Grafana | admin | changeme |
| Pi-hole | - | changeme (WEBPASSWORD) |
| Paperless-ngx | admin | changeme |
| N8N | admin | changeme |
| qBittorrent | admin | adminadmin |
| Kopia | - | (encryption password in 1Password) |

---

## 💻 Essential SSH Commands

### Connect to M4
```bash
# From local network
ssh steve@192.168.50.10

# Via Tailscale (from anywhere)
ssh steve@100.x.x.x
# OR
ssh steve@m4-homelab
```

### System Status
```bash
# Quick status
~/HomeLab/Scripts/Monitoring/status.sh

# Network test
~/HomeLab/Scripts/Monitoring/nettest.sh

# Check services
docker ps

# View logs
docker logs -f <container-name>

# System resources
btop

# Disk space
df -h

# Check temperature
sudo powermetrics --samplers smc
```

---

## 🐳 Docker Commands

### Container Management
```bash
# List running containers
docker ps

# List all containers
docker ps -a

# Start all services
cd ~/HomeLab/Docker/Compose
docker compose -f master-stack.yml up -d

# Stop all services
docker compose -f master-stack.yml down

# Restart specific service
docker restart <container-name>

# View logs
docker logs -f <container-name>

# Access container shell
docker exec -it <container-name> bash
# or
docker exec -it <container-name> sh
```

### Maintenance
```bash
# Update all containers
cd ~/HomeLab/Docker/Compose
docker compose -f master-stack.yml pull
docker compose -f master-stack.yml up -d

# Clean up
docker system prune -af --volumes

# View disk usage
docker system df

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune
```

---

## 🔧 Common Tasks

### Restart Everything
```bash
# Restart M4 (safe)
sudo shutdown -r now

# Or just restart Docker
docker restart $(docker ps -aq)
```

### Check Internet Speed
```bash
speedtest-cli
```

### Update DuckDNS Manually
```bash
~/HomeLab/Scripts/Maintenance/duckdns-update.sh
```

### Backup Now
```bash
~/HomeLab/Scripts/Backup/backup-now.sh
```

### View System Logs
```bash
# macOS system log
log show --predicate 'eventMessage contains "error"' --last 1h

# Docker logs
docker compose -f ~/HomeLab/Docker/Compose/master-stack.yml logs --tail=100
```

---

## 📊 Monitoring & Alerts

### Check System Health
```bash
# CPU & Memory
top

# Better view
btop

# Network usage
nload

# Disk I/O
iostat 1
```

### Grafana Dashboards
Access: https://grafana.stevehomelab.duckdns.org

Key Dashboards:
- System Overview
- Docker Containers
- Network Traffic
- Disk Usage
- Service Uptime

### Uptime Kuma
Access: https://status.stevehomelab.duckdns.org

All service status at a glance

---

## 🆘 Troubleshooting

### Container Won't Start
```bash
# Check logs
docker logs <container-name>

# Check compose file syntax
docker compose -f <file>.yml config

# Recreate container
docker compose -f <file>.yml up -d --force-recreate <service-name>
```

### Can't Access Service
```bash
# 1. Check container is running
docker ps | grep <service-name>

# 2. Check container logs
docker logs <container-name>

# 3. Check port is open
sudo lsof -i :<port-number>

# 4. Test connectivity
curl http://192.168.50.10:<port>

# 5. Check firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --listapps
```

### Network Issues
```bash
# Test router
ping 192.168.50.1

# Test DNS
nslookup google.com

# Test internet
ping 8.8.8.8

# Check 10GbE connection
ifconfig

# Speed test
speedtest-cli

# Detailed network
mtr google.com
```

### Disk Full
```bash
# Check space
df -h

# Find large files
ncdu /

# Clean Docker
docker system prune -af --volumes

# Clean logs
sudo rm -rf ~/Library/Logs/*
```

### SSL Certificate Issues
1. Log into Nginx Proxy Manager
2. Go to SSL Certificates
3. Delete and recreate certificate
4. Wait 5 minutes for renewal

### VPN Not Working
```bash
# Check Tailscale status
tailscale status

# Restart Tailscale
sudo tailscale down
sudo tailscale up

# Check Gluetun (for qBittorrent)
docker logs gluetun | tail -50
```

---

## 💾 Backup & Recovery

### Manual Backup
```bash
# Backup Docker configs
~/HomeLab/Scripts/Backup/backup-docker-configs.sh

# Backup to pCloud
~/HomeLab/Scripts/Backup/backup-to-pcloud.sh

# Backup GitHub configs
cd ~/HomeLab/homelab-configs
git add .
git commit -m "Manual backup $(date)"
git push
```

### Restore from Backup
```bash
# Restore Docker volumes
kopia restore <snapshot-id> ~/HomeLab/Docker/Data

# Restore configs
cd ~/HomeLab/homelab-configs
git pull

# Restart services
docker compose -f ~/HomeLab/Docker/Compose/master-stack.yml up -d
```

### Disaster Recovery
See: `~/HomeLab/Documentation/Disaster-Recovery.md`

---

## 📱 Mobile Access

### From Samsung S25 Ultra
1. Connect to Tailscale
2. Open: https://home.stevehomelab.duckdns.org
3. Access all services!

### Home Assistant App
- Configured with: http://192.168.50.10:8123
- Or via Tailscale: http://100.x.x.x:8123

### Plex App
- Auto-discovers server on local network
- Or add manually: 192.168.50.10

---

## 🔐 Security

### Change Default Passwords
See table above - change EVERYTHING!

### Enable 2FA
Where available:
- Authelia (enable for all services)
- 1Password (already enabled)
- GitHub (already enabled)

### Firewall Status
```bash
# Check firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

# Should be: Firewall is enabled. (State = 1)
```

### Security Scans
```bash
# Port scan (from another device)
nmap 192.168.50.10

# Container vulnerabilities
docker scan <image-name>
```

---

## 📞 Emergency Contacts

### If Everything Explodes

1. **Reboot the M4**
   ```bash
   sudo shutdown -r now
   ```
   Wait 5 minutes for services to start

2. **Check Uptime Kuma**
   https://status.stevehomelab.duckdns.org

3. **Check individual services**
   Use Homer dashboard or direct IPs

4. **Restore from backup**
   See Disaster Recovery guide

### Support Resources
- Reddit: r/homelab, r/selfhosted
- Discord: Home Assistant Discord
- Forums: Plex Forums, HomeAssistant Community
- This vault: Full documentation!

---

## 🎯 Performance Targets

| Metric | Target | Check |
|--------|--------|-------|
| Internet Speed | 4-5Gbps | `speedtest-cli` |
| Local Network | 9-10Gbps | `iperf3 -c <server>` |
| CPU Usage (idle) | 10-20% | `btop` |
| RAM Usage | 18-24GB / 32GB | `btop` |
| Disk Usage | <80% | `df -h` |
| Container Uptime | >99% | Uptime Kuma |
| Plex Streams | 3-5 simultaneous | Works! |

---

## 📚 Documentation Locations

```
~/HomeLab/
├── Documentation/
│   ├── system-info.txt         → System specs
│   ├── maintenance.log         → Maintenance history
│   ├── performance.log         → Performance metrics
│   └── disaster-recovery.md    → Recovery procedures
├── Scripts/
│   ├── Backup/                 → Backup scripts
│   ├── Maintenance/            → Maintenance scripts
│   └── Monitoring/             → Monitoring scripts
└── homelab-configs/            → GitHub repository
    └── (all configs backed up here)
```

---

## ⚙️ Automated Tasks

### Daily (3:00 AM GMT)
- System cleanup
- Docker cleanup
- Log rotation
- Incremental backups

### Weekly (Sunday 4:00 AM GMT)
- System updates (Homebrew)
- Container updates (Watchtower)
- Full backups
- Certificate renewal check

### Hourly
- DuckDNS update (every 5 min)
- Performance logging
- Service health checks

---

## 🎨 Customization

### Adding New Service
1. Add to `docker-compose-master.yml`
2. Run: `docker compose up -d <service-name>`
3. Add proxy host in Nginx Proxy Manager
4. Update Homer dashboard
5. Add to Uptime Kuma monitoring
6. Commit to GitHub

### Updating Service
```bash
docker compose pull <service-name>
docker compose up -d <service-name>
```

---

## 🚀 Quick Start After Reboot

M4 will auto-start everything, but if you need manual:

```bash
# 1. SSH into M4
ssh steve@192.168.50.10

# 2. Check services
docker ps

# 3. If containers stopped:
cd ~/HomeLab/Docker/Compose
docker compose -f master-stack.yml up -d

# 4. Verify status
~/HomeLab/Scripts/Monitoring/status.sh

# 5. Check dashboards
open https://home.stevehomelab.duckdns.org
```

---

## 💡 Pro Tips

1. **Use aliases** (in ~/.zshrc):
   ```bash
   alias homelab='cd ~/HomeLab'
   alias dcu='docker compose up -d'
   alias dcd='docker compose down'
   alias dps='docker ps'
   alias hlb-status='~/HomeLab/Scripts/Monitoring/status.sh'
   ```

2. **Bookmark these**:
   - Homer: https://home.stevehomelab.duckdns.org
   - Portainer: https://portainer.stevehomelab.duckdns.org
   - Grafana: https://grafana.stevehomelab.duckdns.org

3. **Set up phone widgets**:
   - Home Assistant: Quick home controls
   - Uptime Kuma: Service status
   - Plex: Continue watching

4. **Use Tailscale**:
   - Always connected = always accessible
   - No port forwarding needed
   - Secure by default

---

## 📖 Further Reading

| Topic | Location |
|-------|----------|
| Full Setup Guide | START-HERE.md |
| System Overview | M4-System-Overview.md |
| Infrastructure | Volume-02-Infrastructure.md |
| Media Setup | Volume-04-Media-Stack.md |
| Smart Home | Volume-05-Smart-Home.md |
| Security | Volume-07-Security.md |

---

## ✅ Health Check Checklist

Run this weekly:

- [ ] All containers running: `docker ps`
- [ ] Disk space <80%: `df -h`
- [ ] Backups completing: Check Kopia logs
- [ ] SSL certs valid: Check NPM
- [ ] Updates available: Check Watchtower notifications
- [ ] Internet speed: `speedtest-cli`
- [ ] No security alerts: Check Wazuh dashboard
- [ ] Services responding: Check Uptime Kuma

---

**Last Updated:** November 2025  
**Maintained By:** Steve  
**Coffee Required:** Perpetual ☕∞

---

*"Surely you can manage all this?"*  
*"I can manage it. And don't call me Shirley."* 😎
