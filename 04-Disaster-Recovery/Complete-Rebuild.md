# 🚨 Disaster Recovery - Complete Rebuild Guide

This guide will help you rebuild your entire homelab from scratch in case of catastrophic failure.

---

## 📋 Prerequisites

### What You Need
- [ ] M4 Mac Mini with macOS
- [ ] 4TB External SSD
- [ ] Internet connection
- [ ] Latest backup from pCloud
- [ ] This documentation
- [ ] 2-4 hours of time

### Backup Locations
- **pCloud:** https://my.pcloud.com → HomeLab-Backups folder
- **Local:** `~/homelab-backups/` (if available)
- **Obsidian:** `~/Documents/Obsidian/BACKUPS/` (if available)

---

## 🔄 Recovery Scenarios

### Scenario 1: Single Service Failure
See [[Service-Recovery|Service Recovery Guide]]

### Scenario 2: Docker/OrbStack Corruption
See [[Docker-Recovery|Docker Recovery]]

### Scenario 3: Complete System Failure
**THIS GUIDE** - Full rebuild from scratch

---

## 🏗️ Complete Rebuild Procedure

### Phase 1: System Preparation (30 minutes)

#### Step 1: Install OrbStack
```bash
# Download OrbStack
open https://orbstack.dev/download

# Install and launch OrbStack
# Follow installation wizard
```

**Verification:**
```bash
docker --version
# Should show: Docker version XX.X.X

docker ps
# Should show: empty list (normal for fresh install)
```

#### Step 2: Create Directory Structure
```bash
# Create homelab directories
mkdir -p ~/homelab/{Docker,Scripts,configs}
mkdir -p ~/homelab-backups
mkdir -p ~/homelab-deployment

# Create external storage mount point
mkdir -p /Volumes/4TB-BACKUP
```

#### Step 3: Download Backup from pCloud
1. Go to https://my.pcloud.com
2. Navigate to `HomeLab-Backups`
3. Download latest `homelab-config-YYYYMMDD-HHMMSS.tar.gz`
4. Save to `~/homelab-backups/`

#### Step 4: Extract Backup
```bash
cd ~/homelab-backups
tar xzf homelab-config-YYYYMMDD-HHMMSS.tar.gz
cd homelab-config-YYYYMMDD-HHMMSS
ls -la
# Should see: compose/, configs/, scripts/, etc.
```

---

### Phase 2: Network Configuration (15 minutes)

#### Step 1: Configure Static IP
```bash
# System Settings → Network → Ethernet
# Configure IPv4: Manual
# IP Address: 192.168.50.50
# Subnet Mask: 255.255.255.0
# Router: 192.168.50.1
# DNS: 1.1.1.1, 1.0.0.1
```

#### Step 2: Verify Network
```bash
ifconfig
# Should show: 192.168.50.50

ping -c 3 8.8.8.8
# Should succeed

ping -c 3 google.com
# Should succeed
```

---

### Phase 3: Docker Network Setup (10 minutes)

#### Step 1: Create Networks
```bash
# Create homelab network
docker network create homelab-network

# Create database network
docker network create database-net

# Verify
docker network ls
# Should show: homelab-network, database-net
```

---

### Phase 4: Restore Core Services (45 minutes)

#### Infrastructure Services (First!)

**1. MariaDB (Required by other services)**
```bash
cd ~/homelab/Docker
docker-compose -f database-stack.yml up -d mariadb
sleep 30
docker logs mariadb --tail 20
```

**2. PostgreSQL (Required by other services)**
```bash
docker-compose -f database-stack.yml up -d postgres
sleep 30
docker logs postgres --tail 20
```

**3. Redis (Required by Paperless)**
```bash
docker-compose -f database-stack.yml up -d redis
docker logs redis --tail 10
```

**4. Portainer (Docker Management)**
```bash
docker-compose -f core-stack.yml up -d portainer
# Wait 30 seconds
# Access: http://192.168.50.50:9000
# Create admin account
```

**5. Nginx Proxy Manager**
```bash
docker-compose -f core-stack.yml up -d nginx-proxy-manager
# Access: http://192.168.50.50:81
# Login: admin@example.com / changeme
# Change password immediately!
```

**6. AdGuard Home**
```bash
docker-compose -f core-stack.yml up -d adguard-home
# Access: http://192.168.155.2:8084
# Complete setup wizard
```

#### Verification
```bash
docker ps | grep -E "mariadb|postgres|redis|portainer|nginx|adguard"
# All should show "Up"
```

---

### Phase 5: Restore Media Stack (30 minutes)

```bash
cd ~/homelab/Docker

# Start Plex
docker-compose -f media-stack.yml up -d plex
sleep 30

# Start Jellyfin
docker-compose -f media-stack.yml up -d jellyfin

# Start *arr suite
docker-compose -f media-stack.yml up -d sonarr radarr prowlarr

# Start download client
docker-compose -f media-stack.yml up -d transmission

# Start request manager
docker-compose -f media-stack.yml up -d overseerr

# Start Plex stats
docker-compose -f media-stack.yml up -d tautulli

# Verify all running
docker ps | grep -E "plex|jellyfin|sonarr|radarr|prowlarr|transmission|overseerr|tautulli"
```

**Configuration:**
1. Plex: http://192.168.50.50:32400/web → Add libraries
2. Sonarr/Radarr: Connect to Prowlarr for indexers
3. Overseerr: Connect to Plex and *arr services

---

### Phase 6: Restore Smart Home (20 minutes)

```bash
cd ~/homelab/Docker

# Start Home Assistant
docker-compose -f smarthome-stack.yml up -d homeassistant
sleep 60  # HA takes longer to start

# Start Node-RED
docker-compose -f smarthome-stack.yml up -d nodered

# Start Zigbee2MQTT
docker-compose -f smarthome-stack.yml up -d zigbee2mqtt

# Start ESPHome
docker-compose -f smarthome-stack.yml up -d esphome

# Verify
docker ps | grep -E "homeassistant|nodered|zigbee|esphome"
```

**Configuration:**
1. Home Assistant: http://192.168.50.50:8123 → Restore from backup
2. Node-RED: Import flows from backup
3. Zigbee2MQTT: Configure coordinator

---

### Phase 7: Restore Monitoring (20 minutes)

```bash
cd ~/homelab/Docker

# Start Prometheus
docker-compose -f monitoring-stack.yml up -d prometheus

# Start Grafana
docker-compose -f monitoring-stack.yml up -d grafana

# Start other monitoring
docker-compose -f monitoring-stack.yml up -d uptime-kuma netdata loki

# Verify
docker ps | grep -E "prometheus|grafana|kuma|netdata|loki"
```

**Configuration:**
1. Grafana: http://192.168.50.50:3003 → admin/admin (change!)
2. Add Prometheus datasource
3. Import dashboards from backup
4. Uptime Kuma: Setup monitoring checks

---

### Phase 8: Restore Remaining Services (30 minutes)

#### AI Services
```bash
docker-compose -f ai-stack.yml up -d ollama open-webui jupyter
```

#### Storage Services
```bash
docker-compose -f storage-stack.yml up -d nextcloud photoprism kopia syncthing filebrowser
```

#### Productivity Services
```bash
docker-compose -f productivity-stack.yml up -d paperless freshsss calibre codeserver gitea
```

#### Security Services
```bash
docker-compose -f security-stack.yml up -d vaultwarden crowdsec
```

#### Dashboards
```bash
docker-compose -f dashboard-stack.yml up -d heimdall homer organizr
```

---

### Phase 9: Restore Configurations (30 minutes)

#### Restore Container Configs from Backup
```bash
cd ~/homelab-backups/homelab-config-YYYYMMDD-HHMMSS/configs

# Heimdall
tar xzf heimdall-config.tar.gz -C /tmp/
docker cp /tmp/config heimdall:/
docker restart heimdall

# Grafana
tar xzf grafana-config.tar.gz -C /tmp/
docker cp /tmp/config grafana:/
docker restart grafana

# Repeat for other services...
```

#### Restore Databases
```bash
# If you have database dumps
docker exec -i mariadb mysql -u root -pPASSWORD < photoprism-backup.sql
docker exec -i postgres psql -U postgres < paperless-backup.sql
```

---

### Phase 10: Verification & Testing (20 minutes)

#### Test All Services
```bash
cd ~/homelab-deployment
./homelab-working-test.sh
# Should show 39/39 services operational
```

#### Manual Checks
- [ ] Portainer shows all containers running
- [ ] Plex can stream media
- [ ] Home Assistant controls devices
- [ ] Grafana displays metrics
- [ ] Vaultwarden accessible
- [ ] All dashboards load

#### Test Integrations
- [ ] Overseerr → Sonarr/Radarr connection
- [ ] Sonarr/Radarr → Prowlarr connection
- [ ] Transmission downloads work
- [ ] Home Assistant → Node-RED flows
- [ ] Grafana → Prometheus datasource

---

## 📊 Recovery Time Objectives

| Component | RTO | Priority |
|-----------|-----|----------|
| Infrastructure | 30 min | P0 |
| Core Services | 1 hour | P0 |
| Media Stack | 1.5 hours | P1 |
| Smart Home | 2 hours | P1 |
| Monitoring | 2.5 hours | P2 |
| All Services | 3-4 hours | - |

---

## 🆘 Emergency Contacts

### If This Guide Doesn't Work

1. **Check Backups**
   - Verify backup file integrity
   - Download older backup if needed
   - Check Obsidian vault backup

2. **Review Logs**
   ```bash
   docker logs <container-name>
   ```

3. **Start Fresh**
   - Remove all containers
   - Remove all volumes
   - Start Phase 1 again

4. **Community Help**
   - r/homelab subreddit
   - r/selfhosted subreddit
   - Docker forums

---

## 📝 Post-Recovery Checklist

After successful recovery:

- [ ] Update all container images
- [ ] Verify all configurations
- [ ] Test all integrations
- [ ] Run full backup
- [ ] Update this documentation with any changes
- [ ] Document what caused the failure
- [ ] Implement prevention measures

---

## 🔐 Critical Information

### Default Credentials (Change Immediately!)
- **Grafana:** admin / admin
- **Nginx Proxy:** admin@example.com / changeme
- **PhotoPrism:** admin / insecure

### Important Paths
```
Docker Configs: ~/homelab/Docker/
Backups: ~/homelab-backups/
External Storage: /Volumes/4TB-BACKUP/
Obsidian Vault: ~/Documents/Obsidian/
```

### Network Information
- **Static IP:** 192.168.50.50
- **Gateway:** 192.168.50.1
- **DNS:** 1.1.1.1, 1.0.0.1
- **Subnet:** 255.255.255.0

---

## 📚 Related Documentation

- [[Service-Recovery|Individual Service Recovery]]
- [[../02-How-To-Guides/Backup-to-pCloud|Backup Procedures]]
- [[../03-Deployment/DEPLOYMENT-PACKAGE|Original Deployment]]
- [[../09-Reference/Command-Reference|Command Reference]]

---

## 🎯 Prevention

**To avoid needing this guide:**

1. **Regular Backups**
   - Run daily automated backups
   - Upload weekly to pCloud
   - Verify backup integrity monthly

2. **Monitoring**
   - Watch Uptime Kuma for service failures
   - Check Grafana for resource issues
   - Review logs regularly

3. **Maintenance**
   - Update containers monthly
   - Test disaster recovery quarterly
   - Document all changes

4. **Redundancy**
   - Multiple dashboard options
   - Alternative media servers
   - Backup DNS servers

---

**Remember:** Having this guide and regular backups means you're never more than a few hours from a fully operational homelab!

---

*Last Updated: November 19, 2025*  
*Tested: November 2025*  
*Recovery Time: 3-4 hours*
