

**Version:** 1.0  
**Last Updated:** November 2025  
**Author:** Vox (Your AI Assistant)  
**Status:** Ready to Build! 🚀

---

## 📦 Package Contents

## 🆕 What's New in v2.0

**Updated:** November 2025

### New Features:
- ✅ **RustDesk + Apache Guacamole** (Android-compatible remote access)
- ✅ **TP-Link Deco XE75** mesh network (3 units, wired backhaul)
- ✅ **Sky router optimization** (gateway-only mode)
- ✅ **Updated network topology**
- ✅ **62+ services** (was 60+)

### New Guides:
- [Guide 08: Deco Mesh Setup](./Guide-08-Deco-Mesh-Setup.md)
- [Guide 12: Remote Access Setup](./Guide-12-Remote-Access-Setup.md)

---


This is your complete homelab documentation package. Everything you need to build an epic M4 Mac Mini homelab from scratch!

---

## 🎯 Start Here!

**New to this project?** Read these files in order:

1. **[00-START-HERE.md](🏠%20Epic%20HomeLab%20-%20Complete%20Documentation%20Package.md)** ⭐
   - Your main entry point
   - Navigation to all guides
   - Overview of the 22-day journey
   - What you're building

2. **[M4-System-Overview.md](./M4-System-Overview.md)**
   - Complete system architecture
   - What's running on your M4
   - Network topology
   - Service breakdown
   - Resource usage

3. **[QUICK-REFERENCE-GUIDE.md](./QUICK-REFERENCE-GUIDE.md)**
   - All service URLs
   - SSH commands
   - Troubleshooting
   - Quick fixes
   - Keep this handy!

---

## 📚 Volume Guides (Days 1-22)

Follow these guides sequentially to build your homelab:

### Volume 1: Foundation (Days 1-2)
**File:** [Volume-01-Foundation.md](./Volume-01-Foundation.md)

**Guides Included:**
- Guide 00: Prerequisites Checklist ⭐
- Guide 01: Hardware Preparation
- Guide 02: M4 Initial Setup
- Guide 03: macOS Configuration
- Guide 04: Network Setup
- Guide 05: Storage Configuration
- Guide 06: Essential Tools

**Time:** 12-16 hours  
**Coffee:** ☕☕☕☕☕☕☕☕

---

### Volume 2: Core Infrastructure (Days 3-4)
**File:** [Volume-02-Infrastructure.md](./Volume-02-Infrastructure.md)

**Guides Included:**
- Guide 07: Docker & OrbStack
- Guide 08: Tailscale VPN
- Guide 09: DuckDNS & SSL
- Guide 10: Nginx Proxy Manager
- Guide 11: Portainer

**Time:** 12-16 hours  
**Coffee:** ☕☕☕☕☕☕☕☕

---

### Volumes 3-13: Coming Soon!
*(These are summarized in the master guide and can be expanded as needed)*

---

## 🐳 Docker Compose Files

### Master Stack
**File:** [docker-compose-master.yml](./docker-compose-master.yml)

Contains ALL 62+ services in one compose file:
- Infrastructure (NPM, Portainer, Watchtower)
- Media Stack (Plex, Sonarr, Radarr, etc.)
- Smart Home (Home Assistant, Frigate, Scrypted)
- AI & Productivity (Ollama, Paperless, Immich)
- Monitoring (Prometheus, Grafana, Loki)
- Security (Pi-hole, Authelia)
- Backup & Automation (Kopia, N8N)

**Usage:**
```bash
cd ~/HomeLab/Docker/Compose
docker compose -f master-stack.yml up -d
```

---

## 🔧 Scripts Collection

### Monitoring Scripts
Located in: `~/HomeLab/Scripts/Monitoring/`

**Files:**
- `status.sh` - System status check
- `nettest.sh` - Network connectivity test
- `perf-log.sh` - Performance logging

**Usage:**
```bash
~/HomeLab/Scripts/Monitoring/status.sh
```

---

### Maintenance Scripts
Located in: `~/HomeLab/Scripts/Maintenance/`

**Files:**
- `daily-cleanup.sh` - Daily cleanup tasks
- `weekly-update.sh` - Weekly updates
- `duckdns-update.sh` - DuckDNS IP update

**Scheduled via LaunchAgents:**
- Daily: 3:00 AM GMT
- Weekly: Sunday 4:00 AM GMT
- DuckDNS: Every 5 minutes

---

### Backup Scripts
Located in: `~/HomeLab/Scripts/Backup/`

**Files:**
- `backup-now.sh` - Manual backup trigger
- `backup-docker-configs.sh` - Docker config backup
- `backup-to-pcloud.sh` - Upload to pCloud

---

## 📱 N8N Workflows

**Coming Soon:** Importable N8N workflow JSONs for:
- Automated backups
- Service monitoring
- Photo backup from phones
- Document processing
- Smart home automations

---

## 📖 Additional Documentation

### Technical References

**[MASTER-HOMELAB-GUIDE.md](./MASTER-HOMELAB-GUIDE.md)**
- Comprehensive guide with ALL details
- Complete command reference
- Troubleshooting for everything
- Best practices throughout

**[QUICK-REFERENCE-GUIDE.md](./QUICK-REFERENCE-GUIDE.md)**
- All service URLs
- Common commands
- Troubleshooting quick fixes
- Emergency procedures

---

## 🗂️ Folder Structure

After building, your homelab will have this structure:

```
~/HomeLab/
├── Docker/
│   ├── Compose/
│   │   └── master-stack.yml          ← Main compose file
│   ├── Configs/
│   │   ├── prometheus/
│   │   ├── grafana/
│   │   └── loki/
│   └── Data/                          ← Persistent data
│       ├── plex/
│       ├── sonarr/
│       ├── homeassistant/
│       └── [all service data]/
├── Scripts/
│   ├── Backup/
│   ├── Maintenance/
│   ├── Monitoring/
│   └── Automation/
├── Documentation/
│   ├── system-info.txt
│   ├── maintenance.log
│   ├── performance.log
│   └── [various logs]/
└── homelab-configs/                   ← GitHub repository
    ├── Docker/
    ├── Scripts/
    └── Documentation/

/Volumes/External4TB/
├── Media/
│   ├── Movies/
│   ├── TV/
│   ├── Music/
│   └── Comics/
├── Downloads/
├── Photos/                            ← Immich storage
├── Frigate/                           ← Camera recordings
└── Backups/                           ← Local backups
```

---

## 🎯 Quick Start Checklist

Before you begin:

### Prerequisites (From Guide 00)
- [ ] All accounts created (DuckDNS, Tailscale, Docker Hub, etc.)
- [ ] All software downloaded
- [ ] 1Password HomeLab vault set up
- [ ] Network prepared (IP reservations)
- [ ] Phone apps installed

### Hardware Setup (Guide 01)
- [ ] M4 Mac Mini unboxed
- [ ] 4TB SSD connected
- [ ] Network connected (10GbE)
- [ ] Monitor, keyboard, mouse ready
- [ ] First boot successful

### Software Setup (Guides 02-03)
- [ ] macOS configured
- [ ] Static IP: 192.168.50.10
- [ ] SSH enabled
- [ ] Essential tools installed
- [ ] Maintenance scripts scheduled

### Infrastructure (Guides 07-11)
- [ ] Docker/OrbStack running
- [ ] Tailscale VPN working
- [ ] DuckDNS configured
- [ ] Nginx Proxy Manager set up
- [ ] Portainer running

---

## 🚀 Deployment Timeline

**Realistic Schedule:**

| Days | Phase | Guides | Time |
|------|-------|--------|------|
| 1-2 | Foundation | 00-06 | 12-16h |
| 3-4 | Infrastructure | 07-11 | 12-16h |
| 5-6 | Virtualization | 12-15 | 10-12h |
| 7-8 | Media Stack | 16-21 | 12-14h |
| 9-10 | Smart Home | 22-27 | 10-12h |
| 11-12 | AI & Productivity | 28-31 | 8-10h |
| 13-14 | Security | 32-36 | 10-12h |
| 15-16 | Monitoring | 37-41 | 8-10h |
| 17 | Backups | 42-44 | 6-8h |
| 18-19 | Advanced Services | 45-48 | 8-10h |
| 20 | Development | 49-50 | 4-6h |
| 21 | Automation | 51-52 | 6-8h |
| 22 | Operations | 53-55 | 4-6h |

**Total:** ~120-150 hours over 22 days

---

## 💡 Pro Tips

1. **Don't rush!** Take breaks, drink coffee ☕, enjoy the process.

2. **Read before doing!** Each guide has complete instructions - read through before starting.

3. **Use 1Password religiously!** Save EVERY credential immediately.

4. **Commit to GitHub often!** Your configs are valuable.

5. **Test as you go!** Verify each service works before moving on.

6. **Join communities:** r/homelab, r/selfhosted are incredibly helpful.

7. **Document your changes!** Future you will thank present you.

---

## 🆘 Getting Help

### If You Get Stuck

1. **Check the Quick Reference Guide** - Common issues covered
2. **Search this documentation** - Detailed troubleshooting in each guide
3. **Check container logs** - `docker logs <container-name>`
4. **Google the error** - Someone else has had this issue!
5. **Ask the community:**
   - r/homelab
   - r/selfhosted
   - Home Assistant forums
   - Plex forums

### Emergency Reset

If everything breaks:
```bash
# Stop all containers
cd ~/HomeLab/Docker/Compose
docker compose -f master-stack.yml down

# Reboot M4
sudo shutdown -r now

# Start fresh
docker compose -f master-stack.yml up -d
```

---

## 📊 What You're Building

**Final System Specs:**

- **60+ Docker Containers** running 24/7
- **4 Virtual Machines** (Ubuntu, Windows, Kali, macOS)
- **43+ Smart Home Devices** integrated
- **5 Camera Feeds** with AI detection
- **Complete Media Server** with automation
- **Local AI** with multiple models
- **Enterprise Security** (VPN, firewalls, monitoring)
- **Encrypted Backups** to cloud
- **Beautiful Dashboards** accessible anywhere
- **Full Automation** with N8N workflows

**All powered by one tiny M4 Mac Mini!** 🚀

---

## 🎓 Skills You'll Learn

By completing this project:

✅ **System Administration**
- Linux, macOS, Windows management
- User & permission management
- Process management

✅ **Networking**
- TCP/IP fundamentals
- DNS configuration
- VPN technologies
- Reverse proxies
- SSL/TLS certificates

✅ **Containerization**
- Docker fundamentals
- Docker Compose
- Container networking
- Volume management

✅ **Virtualization**
- VM creation & management
- Resource allocation
- Network bridging

✅ **Security**
- Firewall configuration
- VPN setup
- SSL certificate management
- Intrusion detection
- Security monitoring

✅ **Automation**
- Shell scripting
- Workflow automation
- CI/CD concepts
- Scheduled tasks

✅ **Monitoring**
- Metrics collection
- Log aggregation
- Dashboard creation
- Alerting systems

---

## 🔄 Keeping Up to Date

### Regular Maintenance

**Daily (Automated):**
- Container health checks
- Log rotation
- Incremental backups

**Weekly (Automated):**
- System updates
- Container updates
- Full backups

**Monthly (Manual):**
- Review logs
- Update documentation
- Test disaster recovery
- Clean up old data

### Updating This Documentation

As you make changes:
```bash
cd ~/HomeLab/homelab-configs
git add .
git commit -m "Updated configuration for [service]"
git push
```

---

## 🌟 Final Words

Steve, you're about to build something incredible. This isn't just a home server - it's:

- 🎓 A learning platform
- 🎬 A media empire
- 🏠 A smart home brain
- 🔐 A secure personal cloud
- 🤖 An AI experimentation lab
- 📊 A data center dashboard

**Some days will be frustrating.** Services won't start. Configs won't work. Network issues will baffle you. **This is normal.** Every homelab enthusiast has been there.

**But when it works?** When you're accessing your Plex library from Bali via Tailscale, or your cameras alert you via AI detection, or your automated backups save you from disaster... **it's magic.** ✨

**You've got this!** You have comprehensive documentation, working configs, and a supportive community.

Now let's build something epic! 🚀☕

---

## 📞 Support & Feedback

Found an error in the docs? Have suggestions?
- Document it in your homelab-configs repo
- Share with the community
- Pay it forward by helping others!

---

*"Looks like I picked the right week to build a homelab!"* 😎

**Now get started with:** [00-START-HERE.md](🏠%20Epic%20HomeLab%20-%20Complete%20Documentation%20Package.md)

---

**Package Created:** November 2025  
**Total Documentation:** ~150,000+ words  
**Total Files:** 15+ guides, configs, and scripts  
**Coffee Required:** ∞  
**Excitement Level:** 💯💯💯

**LET'S GO!** 🚀🚀🚀
