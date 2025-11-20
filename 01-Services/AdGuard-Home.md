# AdGuard-Home

## Overview

**Category:** Infrastructure  
**Port:** `8084`  
**URL:** [http://192.168.155.2:8084](http://192.168.155.2:8084)  
**Status:** ✅ Operational

Network-wide ad blocker and DNS server

---

## Purpose

Block ads and trackers for all devices on your network

---

## Quick Access

🌐 **Web Interface:** http://192.168.155.2:8084  
🔑 **Default Credentials:** `Set during initial setup`  
📖 **Related Docs:** [[00-SERVICE-INDEX]]

---

## Key Features

- DNS filtering
- Ad blocking
- Parental controls
- Query logging
- Statistics

---

## Common Tasks

### Update filter lists
[Step-by-step guide for update filter lists]

### Check query log
[Step-by-step guide for check query log]

### Whitelist domains
[Step-by-step guide for whitelist domains]

### Configure client settings
[Step-by-step guide for configure client settings]


---

## Configuration

### Initial Setup
1. Access web interface at http://192.168.155.2:8084
2. Complete initial configuration wizard
3. Set strong credentials
4. Configure service-specific settings

### Advanced Configuration
[Service-specific advanced configuration steps]

---

## Troubleshooting

### Service Not Responding
```bash
# Check if container is running
docker ps | grep adguard-home

# View recent logs
docker logs adguard-home --tail 50

# Restart service
docker restart adguard-home
```

### Common Issues

#### Issue: Verify DNS settings on devices
**Solution:** [Resolution steps]

#### Issue: Check filter list updates
**Solution:** [Resolution steps]

#### Issue: Review blocked queries
**Solution:** [Resolution steps]


---

## Related Services

- [[Network configuration]]

[[00-SERVICE-INDEX|← Back to Service Index]]

---

## Monitoring

- **Uptime:** [[Uptime-Kuma]]
- **Metrics:** [[Grafana]]
- **Logs:** [[Loki]]

---

## Backup

This service is included in:
- [[Backup-to-pCloud|pCloud Backup]]
- [[Automated-Backups|Automated Daily Backups]]

---

## Tags

#infrastructure #dns #security #adblock

---

*Last Updated: November 19, 2025*  
*Service Version: Latest*
