---
title: Volume 13: Maintenance & Action1 RMM (Day 14)
tags: [homelab, maintenance, updates, rmm]
created: 2025-11-11
type: homelab-guide
---

# Volume 13: Maintenance & Action1 RMM (Day 14)

**Automated Maintenance and Remote Management**

This volume covers ongoing maintenance and remote management with Action1.

## What You'll Complete

- Action1 RMM enrollment (M4 + VMs)
- Automated update procedures
- Maintenance schedules
- Health checks
- Performance optimization
- Troubleshooting guides
- Update automation

## Prerequisites

- Volumes 01-12 complete
- Action1 account (from Volume 01)
- All systems running
- Admin access to all devices

---

# Guide 91: Action1 RMM Setup

## Install Action1 Agent on M4

1. **Login to Action1:**
   - Go to: https://app.action1.com
   - Email: steve-smithit@outlook.com
   - Password: [from 1Password]

2. **Download agent:**
   - Endpoints → Add Endpoint
   - Download for macOS
   - Save to: ~/Downloads/

3. **Install agent:**
```bash
# Open package
open ~/Downloads/Action1-Agent-*.pkg

# Follow installation wizard
# Enter admin password when prompted
```

4. **Verify enrollment:**
   - Action1 dashboard → Endpoints
   - Should see: M4-HomeLab (online)

---

## Install on Windows VM

1. **RDP to Windows:** 192.168.50.52

2. **Download agent from Action1 portal**

3. **Run installer:** Action1-Agent-Windows.exe

4. **Verify:** Windows-HomeLab appears in portal

---

## Install on Linux VMs

**Ubuntu Server:**
```bash
ssh steve@192.168.50.51

# Download agent
wget https://[your-action1-url]/Action1-Agent-Linux.sh

# Install
sudo bash Action1-Agent-Linux.sh

# Verify
sudo systemctl status action1-agent
```

**Kali Linux:**
```bash
ssh steve@192.168.50.53

# Same process as Ubuntu
```

---

## Install on Proxmox

```bash
ssh root@192.168.50.50

# Download and install
wget https://[your-action1-url]/Action1-Agent-Linux.sh
bash Action1-Agent-Linux.sh
```

**Now all 5 systems managed in Action1!**

---

# Guide 92: Action1 Configuration

## Create Device Groups

**In Action1:**

1. **Devices → Groups → Create**

**Groups:**
```
Group: HomeLab-Servers
  - M4-HomeLab
  - Proxmox

Group: HomeLab-VMs
  - Windows-HomeLab
  - Ubuntu-Server
  - Kali-Linux

Group: HomeLab-All
  - All devices
```

---

## Set Up Policies

**Policy 1: Daily Health Check**
```
Name: Daily Health Check
Target: HomeLab-All
Schedule: Daily at 08:00
Actions:
  - Check disk space
  - Check CPU/RAM usage
  - Check critical services
  - Report if issues
```

**Policy 2: Weekly Updates**
```
Name: Weekly Updates
Target: HomeLab-All
Schedule: Sunday at 03:00
Actions:
  - Check for updates
  - Install security updates
  - Reboot if needed
  - Send report
```

**Policy 3: Monthly Maintenance**
```
Name: Monthly Cleanup
Target: HomeLab-All
Schedule: First Sunday at 04:00
Actions:
  - Clear temp files
  - Clear old logs
  - Optimize databases
  - Defragment (Windows only)
```

---

# Guide 93: Maintenance Scripts

## Create Maintenance Directory

```bash
mkdir -p ~/HomeLab/Scripts/Maintenance
```

---

## Daily Health Check

Create: ~/HomeLab/Scripts/Maintenance/daily-health-check.sh

```bash
#!/bin/bash

# Daily Health Check Script

LOG="/Users/steve/HomeLab/Documentation/health-check.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "=== Health Check: $TIMESTAMP ===" >> $LOG

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
echo "Disk Usage: $DISK_USAGE%" >> $LOG

if [ $DISK_USAGE -gt 90 ]; then
    curl -d "⚠️ Disk space critical: ${DISK_USAGE}%" ntfy.sh/stevehomelab-alerts-x7k9m2
fi

# Check RAM usage
RAM_USAGE=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
echo "RAM Usage: $RAM_USAGE" >> $LOG

# Check Docker containers
RUNNING=$(docker ps --format "{{.Names}}" | wc -l)
echo "Running containers: $RUNNING" >> $LOG

if [ $RUNNING -lt 60 ]; then
    curl -d "⚠️ Some containers stopped! Only $RUNNING running." ntfy.sh/stevehomelab-alerts-x7k9m2
fi

# Check VPN (Gluetun)
VPN_STATUS=$(docker inspect gluetun --format='{{.State.Status}}')
if [ "$VPN_STATUS" != "running" ]; then
    curl -d "⚠️ VPN down! Downloads exposed!" ntfy.sh/stevehomelab-alerts-x7k9m2
fi

# Check Proxmox
ping -c 1 192.168.50.50 > /dev/null 2>&1
if [ $? -ne 0 ]; then
    curl -d "⚠️ Proxmox unreachable!" ntfy.sh/stevehomelab-alerts-x7k9m2
fi

echo "Health check complete" >> $LOG
echo "" >> $LOG
```

---

## Weekly Update Script

Create: ~/HomeLab/Scripts/Maintenance/weekly-updates.sh

```bash
#!/bin/bash

# Weekly Update Script

LOG="/Users/steve/HomeLab/Documentation/updates.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "=== Weekly Updates: $TIMESTAMP ===" >> $LOG

# Update macOS
echo "Checking macOS updates..." >> $LOG
softwareupdate --list >> $LOG 2>&1
# Note: Auto-install disabled, check manually

# Update Homebrew
echo "Updating Homebrew..." >> $LOG
brew update >> $LOG 2>&1
brew upgrade >> $LOG 2>&1
brew cleanup >> $LOG 2>&1

# Update Docker containers
echo "Updating Docker containers..." >> $LOG
cd ~/HomeLab/Docker/Compose
docker compose -f docker-compose-master.yml pull >> $LOG 2>&1
docker compose -f docker-compose-master.yml up -d >> $LOG 2>&1

# Clean Docker
echo "Cleaning Docker..." >> $LOG
docker system prune -af --volumes >> $LOG 2>&1

# Update Ollama models
echo "Updating Ollama models..." >> $LOG
docker exec ollama ollama pull llama3.2:3b >> $LOG 2>&1

echo "Updates complete" >> $LOG
curl -d "✅ Weekly updates completed successfully" ntfy.sh/stevehomelab-alerts-x7k9m2
```

---

## Monthly Cleanup Script

Create: ~/HomeLab/Scripts/Maintenance/monthly-cleanup.sh

```bash
#!/bin/bash

# Monthly Cleanup Script

LOG="/Users/steve/HomeLab/Documentation/cleanup.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "=== Monthly Cleanup: $TIMESTAMP ===" >> $LOG

# Clear temp files
echo "Clearing temp files..." >> $LOG
rm -rf ~/Library/Caches/* >> $LOG 2>&1
rm -rf /tmp/* >> $LOG 2>&1

# Clear old logs (keep 30 days)
echo "Cleaning old logs..." >> $LOG
find ~/HomeLab/Documentation/*.log -mtime +30 -delete >> $LOG 2>&1

# Clean Docker logs
echo "Cleaning Docker logs..." >> $LOG
truncate -s 0 $(docker inspect --format='{{.LogPath}}' $(docker ps -qa)) >> $LOG 2>&1

# Optimize Plex database
echo "Optimizing Plex..." >> $LOG
docker exec plex sqlite3 /config/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Databases/com.plexapp.plugins.library.db "VACUUM;" >> $LOG 2>&1

# Verify backups
echo "Verifying backups..." >> $LOG
docker exec kopia kopia repository validate-provider >> $LOG 2>&1

echo "Cleanup complete" >> $LOG
curl -d "✅ Monthly cleanup completed" ntfy.sh/stevehomelab-alerts-x7k9m2
```

---

## Make Scripts Executable

```bash
chmod +x ~/HomeLab/Scripts/Maintenance/*.sh
```

---

# Guide 94: Automated Scheduling

## Schedule via LaunchAgents

**Daily Health Check:**
```bash
cat > ~/Library/LaunchAgents/com.homelab.health.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.homelab.health</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/steve/HomeLab/Scripts/Maintenance/daily-health-check.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
EOF

launchctl load ~/Library/LaunchAgents/com.homelab.health.plist
```

**Weekly Updates:**
```bash
cat > ~/Library/LaunchAgents/com.homelab.updates.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.homelab.updates</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/steve/HomeLab/Scripts/Maintenance/weekly-updates.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>0</integer>
        <key>Hour</key>
        <integer>3</integer>
    </dict>
</dict>
</plist>
EOF

launchctl load ~/Library/LaunchAgents/com.homelab.updates.plist
```

---

# Guide 95: Troubleshooting Guide

## Common Issues

### Docker Container Won't Start

```bash
# Check logs
docker logs <container-name>

# Check if port already in use
lsof -i :<port-number>

# Restart container
docker restart <container-name>

# Rebuild container
docker compose up -d --force-recreate <container-name>
```

### Service Not Accessible

```bash
# Check if container running
docker ps | grep <service>

# Check network
docker network inspect homelab-network

# Check firewall
# macOS: System Settings → Network → Firewall

# Test locally
curl http://localhost:<port>
```

### High CPU Usage

```bash
# Find culprit
docker stats

# Check M4 resources
top

# Restart high-usage container
docker restart <container-name>
```

### Out of Disk Space

```bash
# Check usage
df -h

# Find large files
du -sh /Volumes/External4TB/*

# Clean Docker
docker system prune -a --volumes

# Clear Plex temp
rm -rf ~/HomeLab/Docker/Data/plex/transcode/*
```

### VPN Not Working

```bash
# Check Gluetun
docker logs gluetun

# Test VPN IP
docker exec gluetun curl ifconfig.me

# Restart VPN
docker restart gluetun qbittorrent
```

---

# Guide 96: Performance Optimization

## M4 Optimization

**Check resources:**
```bash
# CPU usage
top -l 1 | head -n 10

# RAM usage
vm_stat

# Disk I/O
iostat -w 5
```

**Optimize Docker:**
```bash
# Clean unused data
docker system prune -a --volumes

# Optimize OrbStack settings
# Settings → Resources
# Adjust CPU/RAM allocation
```

**Optimize macOS:**
- Disable unused startup items
- Clear caches monthly
- Restart weekly
- Monitor Activity Monitor

---

## Container Optimization

**Review resource limits:**
```yaml
# In docker-compose.yml
services:
  plex:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          memory: 2G
```

---

# Guide 97: Update Procedures

## Before Updates

```bash
# Backup configs
~/HomeLab/Scripts/Backup/pre-backup.sh

# Create VM snapshots
# Proxmox → Each VM → Snapshots → Take Snapshot

# Note: "pre-update-[date]"
```

## Update Docker Containers

```bash
cd ~/HomeLab/Docker/Compose

# Pull latest images
docker compose -f docker-compose-master.yml pull

# Recreate containers
docker compose -f docker-compose-master.yml up -d

# Check logs
docker compose -f docker-compose-master.yml logs -f
```

## Update VMs

**Windows:**
- Windows Update (automated)
- Or via Action1: Run Windows Update policy

**Ubuntu/Kali:**
```bash
ssh steve@192.168.50.51
sudo apt update && sudo apt full-upgrade -y
```

## Update Proxmox

```bash
ssh root@192.168.50.50

apt update
apt full-upgrade -y

# May require reboot
reboot
```

---

# Guide 98: Monthly Checklist

## Every Month:

- [ ] Review Action1 reports
- [ ] Check Grafana dashboards
- [ ] Verify all backups successful
- [ ] Test restore (random file)
- [ ] Review disk space usage
- [ ] Update all containers
- [ ] Update all VMs
- [ ] Check for security updates
- [ ] Review access logs
- [ ] Clean Docker system
- [ ] Optimize Plex database
- [ ] Check certificate expiry
- [ ] Review failed login attempts
- [ ] Update documentation if needed

**Time required: 1-2 hours**

---

# Guide 99: Quarterly Tasks

## Every 3 Months:

- [ ] Full system backup test
- [ ] Review and update passwords
- [ ] Audit user access
- [ ] Review security logs
- [ ] Check hardware health
- [ ] Clean physical dust
- [ ] Update documentation
- [ ] Review and optimize automations
- [ ] Capacity planning review

**Time required: 3-4 hours**

---

# Guide 100: Emergency Procedures

## M4 Unresponsive

1. **Try SSH:** `ssh steve@192.168.50.10`
2. **Try Tailscale:** `ssh steve@100.x.x.x`
3. **Physical access:** Connect monitor + keyboard
4. **Hard reset:** Hold power button 10 seconds
5. **Recovery:** Boot recovery mode (Cmd+R on startup)

## Critical Service Down

1. **Check container:** `docker ps`
2. **Check logs:** `docker logs <name>`
3. **Restart:** `docker restart <name>`
4. **Recreate:** `docker compose up -d --force-recreate <name>`
5. **Restore config:** From backup if corrupted

## Network Issues

1. **Check router:** Ping 192.168.50.1
2. **Check switch:** Check lights
3. **Check cables:** Reseat connections
4. **Check adapters:** `ifconfig`
5. **Restart networking:** `sudo networksetup -setnetworkserviceenabled "Ethernet" off && sudo networksetup -setnetworkserviceenabled "Ethernet" on`

---

## Volume 13 Complete!

You now have:
- ✅ Action1 RMM managing all systems
- ✅ Automated daily health checks
- ✅ Weekly update automation
- ✅ Monthly cleanup scripts
- ✅ Comprehensive troubleshooting guide
- ✅ Performance optimization
- ✅ Emergency procedures
- ✅ Complete maintenance schedule!

**Maintenance Schedule:**
```
Daily (Automated @ 8AM):
- Health checks
- Disk space monitoring
- Service status checks
- Alert if issues

Weekly (Automated @ 3AM Sunday):
- Update Docker containers
- Clean Docker system
- Update Brew packages
- Update Ollama models

Monthly (1st Sunday):
- Clear temp files
- Clean old logs
- Optimize databases
- Verify backups
- Manual review (1-2 hours)

Quarterly:
- Full system audit
- Password rotation
- Capacity planning
- Documentation update
```

**Next: Volume 14 - Network Diagrams & Final Guide**



---

#homelab #maintenance #updates #rmm
