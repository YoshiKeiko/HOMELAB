# 🔔 Ntfy

## Overview
| Property | Value |
|----------|-------|
| **URL** | http://192.168.50.50:8280 |
| **Container** | ntfy |
| **Image** | binwiederhier/ntfy:latest |
| **Port** | 8280 |
| **Data** | /Volumes/HomeLab-4TB/Docker-Data/ntfy |

## Features
- Push notifications to any device
- REST API for sending
- Mobile apps (iOS/Android)
- Web UI for subscribing
- No account required
- Self-hosted alternative to Pushover

## First Setup
1. Visit http://192.168.50.50:8280
2. No authentication required
3. Subscribe to a topic
4. Send test notification

## Sending Notifications

### Via curl
```bash
curl -d "Test message from HomeLab" http://192.168.50.50:8280/homelab
```

### With title and priority
```bash
curl -H "Title: Alert!" -H "Priority: high" \
  -d "Something happened" http://192.168.50.50:8280/homelab
```

### With tags/emoji
```bash
curl -H "Tags: warning,server" \
  -d "Server alert" http://192.168.50.50:8280/homelab
```

## ⚠️ Known Issue: Browser Push Notifications

**Problem**: "Notifications are only supported over HTTPS"

**Cause**: Browser push notifications require secure context.

**API Still Works!** The REST API works fine over HTTP for:
- Sending notifications from scripts
- Integration with other services
- Mobile app subscriptions

**Solutions for Browser Push**:

### Option 1: Use Mobile App
- iOS: Ntfy from App Store
- Android: Ntfy from Play Store/F-Droid
- Subscribe to: http://192.168.50.50:8280

### Option 2: Nginx Proxy Manager SSL
1. Open NPM: http://192.168.50.50:81
2. Add Proxy Host: ntfy.homelab.local → 192.168.50.50:8280
3. Enable SSL
4. Access via https://ntfy.homelab.local

## HomeLab Topics
| Topic | Use |
|-------|-----|
| /homelab | General notifications |
| /alerts | Critical alerts |
| /backups | Backup status |
| /downloads | Download complete |

## Tags
#service #notifications #push #alerts #automation
