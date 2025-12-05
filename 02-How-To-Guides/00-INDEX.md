# 📖 How-To Guides - Complete Index

Step-by-step tutorials for common HomeLab tasks.

---

## 🔄 Backup & Recovery

### [[Backup-to-pCloud|Complete Backup to pCloud]]
How to backup all configs, containers, and Obsidian vault to cloud storage.

**Time:** 10 minutes  
**Frequency:** Weekly recommended

### [[RCLONE_GUIDE|Complete rclone Guide]]
Cloud storage sync, backup, and migration using rclone. Includes Google Drive download script.

**Time:** Variable  
**Use cases:** Cloud migration, sync, backup, mount cloud storage

### [[Automated-Backups|Setup Automated Daily Backups]]
Configure cron job for automatic nightly backups.

**Time:** 5 minutes  
**Setup once:** Runs automatically

### [[Restore-from-Backup|Restore from Backup]]
How to restore services or complete system from backup.

**Time:** 30 minutes - 4 hours  
**When needed:** Service failure or disaster

---

## 🐳 Docker & Container Management

### [[Add-New-Service|Add a New Docker Service]]
Step-by-step process to add a new containerized service.

**Prerequisites:**
- Docker Compose knowledge
- Service documentation
- Network understanding

### [[Update-Containers|Update All Docker Containers]]
Safely update all containers to latest versions.

**Time:** 30 minutes  
**Frequency:** Monthly

### [[Remove-Service|Remove a Docker Service]]
Properly remove a service including volumes and configs.

**Time:** 5 minutes

### [[Troubleshoot-Containers|Troubleshoot Docker Containers]]
Common Docker issues and solutions.

---

## 🌐 Network Configuration

### [[Configure-Static-IP|Setup Static IP Address]]
Configure Mac Mini with static IP for reliable access.

**Time:** 10 minutes  
**Required:** Initial setup

### [[Port-Forwarding|Configure Port Forwarding]]
Setup port forwarding on router for external access.

**Time:** 15 minutes per service  
**Security:** Use VPN or Cloudflare Tunnel instead

### [[DNS-Configuration|Configure Custom DNS]]
Setup local DNS for easy service access.

**Time:** 20 minutes

---

## 📊 Monitoring & Maintenance

### [[Setup-Grafana-Dashboards|Setup Grafana Dashboards]]
Import and configure monitoring dashboards.

**Time:** 30 minutes  
**Benefit:** Visual metrics for everything

### [[Configure-Alerts|Configure Monitoring Alerts]]
Setup alerts for service failures and resource issues.

**Time:** 45 minutes  
**Benefit:** Get notified of problems

### [[Check-System-Health|Daily System Health Check]]
Quick daily checks to ensure everything is running smoothly.

**Time:** 5 minutes daily

---

## 🎬 Media Management

### [[Setup-Plex-Library|Setup Plex Media Library]]
Add and organize your media in Plex.

**Time:** 30 minutes

### [[Configure-Sonarr-Radarr|Configure Sonarr & Radarr]]
Setup TV and movie automation.

**Time:** 1 hour  
**Prerequisites:** Indexers, download client

### [[Add-Indexers-Prowlarr|Add Indexers to Prowlarr]]
Configure indexers for media searching.

**Time:** 20 minutes

### [[Optimize-Plex-Transcoding|Optimize Plex Transcoding]]
Configure Plex for best streaming performance.

**Time:** 15 minutes

---

## 🏡 Smart Home

### [[Setup-Home-Assistant|Initial Home Assistant Setup]]
Configure Home Assistant for your devices.

**Time:** 1-2 hours  
**Complexity:** Moderate

### [[Create-Automation|Create Node-RED Automation]]
Build visual automation flows.

**Time:** 30 minutes per automation

### [[Add-Zigbee-Device|Add Zigbee Devices]]
Pair Zigbee devices via Zigbee2MQTT.

**Time:** 5 minutes per device

---

## 🔐 Security

### [[Setup-Vaultwarden|Setup Vaultwarden Password Manager]]
Configure self-hosted password manager.

**Time:** 20 minutes  
**Important:** Use strong master password

### [[Configure-2FA|Enable Two-Factor Authentication]]
Setup 2FA for critical services.

**Time:** 10 minutes per service  
**Recommended:** All external-facing services

### [[Review-Security-Logs|Review Security Logs]]
Check CrowdSec and system logs for threats.

**Time:** 10 minutes weekly

---

## 💾 Storage Management

### [[Manage-4TB-Storage|Manage External 4TB Storage]]
Setup and maintain external SSD storage.

**Time:** 30 minutes initial setup

### [[Configure-Nextcloud|Setup Nextcloud]]
Configure personal cloud storage.

**Time:** 45 minutes

### [[Organize-Media-Library|Organize Media Library]]
Best practices for media file organization.

**Time:** Ongoing

---

## 🤖 AI Services

### [[Setup-Ollama-Models|Download Ollama Models]]
Install and manage local LLM models.

**Time:** 30 minutes - 2 hours  
**Note:** Large downloads

### [[Configure-Open-WebUI|Configure Open WebUI]]
Setup ChatGPT-like interface.

**Time:** 15 minutes

---

## 🎨 Customization

### [[Customize-Heimdall|Customize Heimdall Dashboard]]
Add services and organize your main dashboard.

**Time:** 30 minutes

### [[Create-Custom-Dashboard|Create Custom Dashboard]]
Build personalized dashboard with bookmarks.

**Time:** 1 hour

### [[Setup-Themes|Apply Custom Themes]]
Customize appearance of services.

**Time:** 20 minutes per service

---

## 🔧 Troubleshooting

### [[Service-Not-Responding|Service Not Responding]]
Diagnose and fix unresponsive services.

**Common issues:**
- Container stopped
- Port conflict
- Network issues
- Configuration error

### [[High-Resource-Usage|High CPU/RAM Usage]]
Identify and resolve resource problems.

**Tools:**
- Netdata for real-time stats
- Grafana for historical data
- cAdvisor for container metrics

### [[Database-Issues|Database Connection Issues]]
Fix MariaDB, PostgreSQL, or Redis problems.

**Common fixes:**
- Restart database container
- Check network connectivity
- Verify credentials

---

## 📱 Mobile Access

### [[Setup-Remote-Access|Setup Secure Remote Access]]
Access homelab from anywhere safely.

**Options:**
- Tailscale (recommended)
- WireGuard VPN
- Cloudflare Tunnel

**Time:** 1 hour

### [[Configure-Mobile-Apps|Configure Mobile Apps]]
Setup apps for Plex, Home Assistant, etc.

**Time:** 30 minutes

---

## 🎓 Learning Resources

### [[Docker-Basics|Docker Basics for HomeLab]]
Essential Docker concepts and commands.

### [[Networking-101|HomeLab Networking 101]]
Understanding your network setup.

### [[Monitoring-Explained|Monitoring Stack Explained]]
How Prometheus, Grafana, and Loki work together.

---

## Quick Reference

### Most Common Tasks
1. [[Backup-to-pCloud|Run Backup]] (Weekly)
2. [[Check-System-Health|Health Check]] (Daily)
3. [[Update-Containers|Update Containers]] (Monthly)
4. [[Add-New-Service|Add Service]] (As needed)

### Emergency Procedures
1. [[Service-Not-Responding|Fix Unresponsive Service]]
2. [[../04-Disaster-Recovery/Service-Recovery|Recover Failed Service]]
3. [[../04-Disaster-Recovery/Complete-Rebuild|Complete System Rebuild]]

---

## Contributing

Found a better way to do something? Add your notes to the relevant guide!

This vault is a living document - keep it updated as you learn.

---

*Total Guides: 31+*  
*Last Updated: December 4, 2025*
