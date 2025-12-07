# 👁️ ChangeDetection

## Overview
| Property | Value |
|----------|-------|
| **URL** | http://192.168.50.50:5005 |
| **Container** | changedetection |
| **Image** | ghcr.io/dgtlmoon/changedetection.io:latest |
| **Port** | 5005 |
| **Data** | /Volumes/HomeLab-4TB/Docker-Data/changedetection |

## Features
- Website change monitoring
- Visual diff comparison
- Email/notification alerts
- CSS selector filtering
- JavaScript rendering support
- Multiple check intervals

## First Setup
1. Visit http://192.168.50.50:5005
2. No authentication by default
3. Click "Add" to monitor a URL
4. Set check interval
5. Configure notifications

## Use Cases
- Price drop alerts
- Stock availability
- News monitoring
- Job listings
- Documentation changes

## Notification Options
- Email
- Discord
- Slack
- Ntfy (local!)
- Telegram
- Many more via Apprise

## Integration with Ntfy
Notification URL: `ntfy://192.168.50.50:8280/changedetection`

## Tags
#service #tools #monitoring #alerts #automation
