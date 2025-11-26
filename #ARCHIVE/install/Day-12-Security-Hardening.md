---
title: Volume 10: Security Stack (Day 11)
tags: [homelab, security, hardening, wazuh]
created: 2025-11-11
type: homelab-guide
---

# Volume 10: Security Stack (Day 11)

**Enterprise-Grade Security for Your HomeLab**

This volume covers complete security hardening and monitoring.

## What You'll Complete

- Pi-hole (DNS-level ad blocking)
- Authelia (SSO + 2FA)
- CrowdSec (collaborative security)
- Fail2ban (intrusion prevention)
- Traefik (reverse proxy + security)
- Network segmentation
- Security monitoring

## Prerequisites

- Volumes 01-09 complete
- All services running
- Network configured

---

# Guide 63: Pi-hole

## Deploy Pi-hole

```bash
docker compose -f docker-compose-master.yml up -d pihole
```

Access: http://192.168.50.10:8080/admin

## Setup

**Password:**
```bash
# Get/set admin password
docker exec -it pihole pihole -a -p
# Enter new password
```

Save to 1Password.

## Configure DNS

**On Router:**
1. Login to router (192.168.50.1)
2. DHCP settings
3. Primary DNS: 192.168.50.10 (M4/Pi-hole)
4. Secondary DNS: 1.1.1.1 (fallback)
5. Save

**Or per-device:**
- Set DNS to: 192.168.50.10

## Add Blocklists

Settings → Adlists → Add:
```
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://v.firebog.net/hosts/Admiral.txt
https://v.firebog.net/hosts/Easylist.txt
```

Update Gravity:
- Tools → Update Gravity

## Results

- Blocks ads network-wide
- Blocks tracking
- Speeds up browsing
- Works on all devices
- Dashboard shows stats

---

# Guide 64: Authelia

## Deploy Authelia

```bash
docker compose -f docker-compose-master.yml up -d authelia
```

Access: http://192.168.50.10:9091

## Configuration

Create: ~/HomeLab/Docker/Configs/authelia/configuration.yml

```yaml
server:
  host: 0.0.0.0
  port: 9091

log:
  level: info

authentication_backend:
  file:
    path: /config/users.yml

access_control:
  default_policy: deny
  rules:
    - domain: "*.stevehomelab.duckdns.org"
      policy: two_factor

session:
  domain: stevehomelab.duckdns.org
  expiration: 1h
  inactivity: 5m

storage:
  local:
    path: /config/db.sqlite3

notifier:
  smtp:
    host: smtp.gmail.com
    port: 587
    username: steve-smithit@outlook.com
    password: [app-specific password]
    sender: steve-smithit@outlook.com
```

## Create User

~/HomeLab/Docker/Configs/authelia/users.yml:

```yaml
users:
  steve:
    displayname: "Steve Smith"
    password: "$argon2id$v=19$m=65536..." # Generate hash
    email: steve-smithit@outlook.com
    groups:
      - admins
```

Generate password hash:
```bash
docker exec -it authelia authelia crypto hash generate argon2
# Enter password
# Copy hash to users.yml
```

## Enable 2FA

1. Login to Authelia
2. Configure 2FA
3. Scan QR code with authenticator app
4. Save backup codes to 1Password

## Integrate with Nginx Proxy Manager

For each protected service:
1. NPM → Edit Proxy Host
2. Custom Locations → Add
```
Location: /
Forward Auth URL: http://authelia:9091/api/verify
```

Now requires login + 2FA before accessing!

---

# Guide 65: CrowdSec

## Deploy CrowdSec

```bash
docker compose -f docker-compose-master.yml up -d crowdsec
```

## Setup

**Enroll:**
```bash
# Get enrollment key
docker exec crowdsec cscli console enroll [key-from-crowdsec.net]

# Install collections
docker exec crowdsec cscli collections install crowdsecurity/nginx
docker exec crowdsec cscli collections install crowdsecurity/linux
docker exec crowdsec cscli collections install crowdsecurity/sshd
```

## Configure Bouncer

**For Nginx:**
```bash
# Generate bouncer key
docker exec crowdsec cscli bouncers add nginx-bouncer

# Add to nginx config
```

## What CrowdSec Does

- Monitors logs for attacks
- Shares threat intelligence
- Automatically blocks bad IPs
- Protects against:
  - Brute force
  - Port scanning
  - DDoS
  - Known malicious IPs

**Dashboard:** https://app.crowdsec.net

---

# Guide 66: Fail2ban

## Deploy Fail2ban

```bash
docker compose -f docker-compose-master.yml up -d fail2ban
```

## Configuration

Create: ~/HomeLab/Docker/Configs/fail2ban/jail.local

```ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5
destemail = steve-smithit@outlook.com
action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log

[nginx-http-auth]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log

[nginx-noscript]
enabled = true
port = http,https
logpath = /var/log/nginx/access.log

[nginx-badbots]
enabled = true
port = http,https
logpath = /var/log/nginx/access.log
```

## Check Status

```bash
# List jails
docker exec fail2ban fail2ban-client status

# Check specific jail
docker exec fail2ban fail2ban-client status sshd

# Unban IP
docker exec fail2ban fail2ban-client set sshd unbanip 1.2.3.4
```

---

# Guide 67: Network Segmentation

## VLANs Setup

**Your networks:**
```
192.168.50.0/24 - Main network (trusted devices)
192.168.51.0/24 - IoT network (smart home devices)
192.168.52.0/24 - Guest network
```

**Firewall Rules:**

**IoT → Main: Deny** (except Home Assistant)
**Guest → Main: Deny**
**Main → Everything: Allow**

## Implementation

**On TP-Link Switch:**
1. Enable VLANs
2. Assign ports:
   - Port 1-4: VLAN 50 (main)
   - Port 5-6: VLAN 51 (IoT)
   - Port 7-8: VLAN 52 (guest)

**On Router:**
1. Create virtual interfaces
2. Set firewall rules
3. Separate DHCP pools

---

# Guide 68: Security Monitoring

## Wazuh (Optional)

For enterprise-level SIEM:

```bash
docker compose -f docker-compose-master.yml up -d wazuh
```

**Features:**
- Security event monitoring
- Compliance (PCI-DSS, GDPR)
- Vulnerability detection
- File integrity monitoring
- Log analysis

## Uptime Kuma

Already deployed for monitoring:

Access: http://192.168.50.10:3001

**Add security checks:**
- SSH login attempts
- Failed auth logs
- Suspicious traffic
- Service availability

---

# Guide 69: Backup Security

## Secure Backups

**Kopia with encryption:**
```bash
# Already configured in Volume 12
# Using AES-256 encryption
# Password in 1Password
```

**Backup security measures:**
- Encrypted at rest
- Encrypted in transit
- Password protected
- Offsite (pCloud)
- Versioned (can restore old versions)
- Immutable (can't be deleted by ransomware)

---

# Guide 70: Security Checklist

## Daily

- [ ] Review Pi-hole blocked queries
- [ ] Check Authelia login attempts
- [ ] Review CrowdSec alerts

## Weekly

- [ ] Review Fail2ban bans
- [ ] Check for failed auth attempts
- [ ] Update Docker containers
- [ ] Review firewall logs

## Monthly

- [ ] Update all services
- [ ] Review access logs
- [ ] Rotate passwords
- [ ] Test backups
- [ ] Security audit

## Security Hardening

- [x] All services behind authentication
- [x] 2FA enabled (Authelia)
- [x] DNS filtering (Pi-hole)
- [x] Intrusion prevention (Fail2ban, CrowdSec)
- [x] Network segmentation
- [x] Encrypted backups
- [x] Regular updates
- [x] Monitoring enabled
- [x] SSH key-only (no passwords)
- [x] Firewall configured

---

## Volume 10 Complete!

You now have:
- ✅ Pi-hole blocking ads/tracking network-wide
- ✅ Authelia providing SSO + 2FA
- ✅ CrowdSec detecting threats
- ✅ Fail2ban blocking attackers
- ✅ Network segmented by trust level
- ✅ All services secured
- ✅ Security monitoring active
- ✅ Enterprise-grade security!

**Security Stack:**
```
Defense in Depth:
├─ Network Layer
│  ├─ VLANs (segmentation)
│  └─ Firewall rules
├─ DNS Layer
│  └─ Pi-hole (ad/tracker blocking)
├─ Application Layer
│  ├─ Authelia (SSO + 2FA)
│  ├─ CrowdSec (threat intelligence)
│  └─ Fail2ban (intrusion prevention)
└─ Monitoring
   ├─ Logs centralized
   ├─ Alerts configured
   └─ Regular audits
```

**Next: Volume 11 - Monitoring Stack**



---

#homelab #security #hardening #wazuh
