# Portainer

## Overview

**Category:** Infrastructure  
**Port:** `9000`  
**URL:** [http://192.168.50.50:9000](http://192.168.50.50:9000)  
**Status:** ✅ Operational

Docker container management platform with web UI

---

## Purpose

Visual interface to manage all Docker containers, images, networks, and volumes

---

## Quick Access

🌐 **Web Interface:** http://192.168.50.50:9000  
🔑 **Default Credentials:** `Set during first login`  
📖 **Related Docs:** [[00-SERVICE-INDEX]]

---

## Key Features

- Container management
- Image management
- Volume management
- Network configuration
- Stack deployment

---

## Common Tasks

### View container logs
[Step-by-step guide for view container logs]

### Restart containers
[Step-by-step guide for restart containers]

### Update images
[Step-by-step guide for update images]

### Monitor resources
[Step-by-step guide for monitor resources]

### Deploy stacks
[Step-by-step guide for deploy stacks]


---

## Configuration

### Initial Setup
1. Access web interface at http://192.168.50.50:9000
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
docker ps | grep portainer

# View recent logs
docker logs portainer --tail 50

# Restart service
docker restart portainer
```

### Common Issues

#### Issue: Check if container is running
**Solution:** [Resolution steps]

#### Issue: Verify port 9000 is accessible
**Solution:** [Resolution steps]

#### Issue: Review Docker logs
**Solution:** [Resolution steps]


---

## Related Services

- [[All Docker services]]

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

#infrastructure #docker #management

---

*Last Updated: November 19, 2025*  
*Service Version: Latest*
