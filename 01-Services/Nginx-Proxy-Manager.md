# Nginx-Proxy-Manager

## Overview

**Category:** Infrastructure  
**Port:** `81`  
**URL:** [http://192.168.50.50:81](http://192.168.50.50:81)  
**Status:** ✅ Operational

Reverse proxy manager with SSL certificate automation

---

## Purpose

Route external traffic to internal services with automatic SSL certificates

---

## Quick Access

🌐 **Web Interface:** http://192.168.50.50:81  
🔑 **Default Credentials:** `admin@example.com / changeme (change on first login)`  
📖 **Related Docs:** [[00-SERVICE-INDEX]]

---

## Key Features

- Reverse proxy
- SSL certificates
- Access lists
- Custom locations
- Stream proxying

---

## Common Tasks

### Add proxy host
[Step-by-step guide for add proxy host]

### Request SSL certificate
[Step-by-step guide for request ssl certificate]

### Configure redirects
[Step-by-step guide for configure redirects]

### Setup access control
[Step-by-step guide for setup access control]


---

## Configuration

### Initial Setup
1. Access web interface at http://192.168.50.50:81
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
docker ps | grep nginx-proxy-manager

# View recent logs
docker logs nginx-proxy-manager --tail 50

# Restart service
docker restart nginx-proxy-manager
```

### Common Issues

#### Issue: Check proxy host configuration
**Solution:** [Resolution steps]

#### Issue: Verify DNS records
**Solution:** [Resolution steps]

#### Issue: Review SSL certificate status
**Solution:** [Resolution steps]


---

## Related Services

- [[All web services]]

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

#infrastructure #proxy #ssl #nginx

---

*Last Updated: November 19, 2025*  
*Service Version: Latest*
