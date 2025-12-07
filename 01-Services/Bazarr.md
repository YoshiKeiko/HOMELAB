# 💬 Bazarr

## Overview
| Property | Value |
|----------|-------|
| **URL** | http://192.168.50.50:6767 |
| **Container** | bazarr |
| **Image** | lscr.io/linuxserver/bazarr:latest |
| **Port** | 6767 |
| **Data** | /Volumes/HomeLab-4TB/Docker-Data/bazarr |

## Features
- Automatic subtitle downloads
- Integrates with Sonarr/Radarr
- Multiple language support
- Provider management
- Subtitle sync/adjustment

## First Setup
1. Visit http://192.168.50.50:6767
2. No default auth
3. Settings → Sonarr: Add API key from Sonarr
4. Settings → Radarr: Add API key from Radarr
5. Settings → Providers: Add OpenSubtitles, Subscene, etc.

## Integration
| Service | API Key Location |
|---------|-----------------|
| Sonarr | Sonarr → Settings → General → API Key |
| Radarr | Radarr → Settings → General → API Key |

## Subtitle Providers
- OpenSubtitles.com (account required)
- Subscene
- Addic7ed
- TVSubtitles

## Tags
#service #media #subtitles #automation
