# 🎧 Audiobookshelf

## Overview
| Property | Value |
|----------|-------|
| **URL** | http://192.168.50.50:13378 |
| **Container** | audiobookshelf |
| **Image** | ghcr.io/advplyr/audiobookshelf:latest |
| **Port** | 13378 |
| **Data** | /Volumes/HomeLab-4TB/Docker-Data/audiobookshelf |

## Features
- Audiobook and podcast streaming
- Multi-user support with progress sync
- Mobile apps (iOS/Android)
- Chapter support
- Sleep timer
- Playback speed control

## First Setup
1. Visit http://192.168.50.50:13378
2. Create admin account on first visit
3. Add library pointing to audiobooks folder

## Libraries
| Library | Path (Container) | Host Path |
|---------|-----------------|-----------|
| Audiobooks | /audiobooks | /Volumes/HomeLab-4TB/Media/Audiobooks |
| Podcasts | /podcasts | /Volumes/HomeLab-4TB/Media/Podcasts |

## Troubleshooting
### Unauthorized Error After Login
- Clear browser cookies/cache for the site
- Try incognito window
- Restart container: `docker restart audiobookshelf`

## Tags
#service #media #audiobooks #podcasts
