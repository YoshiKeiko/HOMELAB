# 📚 Komga

## Overview
| Property | Value |
|----------|-------|
| **URL** | http://192.168.50.50:25600 |
| **Container** | komga |
| **Image** | gotson/komga:latest |
| **Port** | 25600 |
| **Data** | /Volumes/HomeLab-4TB/Docker-Data/komga |

## Features
- Comics and manga server
- OPDS feed support
- Web reader
- Multi-user with permissions
- Reading progress sync
- Metadata editing

## First Setup
1. Visit http://192.168.50.50:25600
2. Create admin account
3. Add library: Settings → Libraries → Add
4. Point to /data (maps to Comics folder)

## Library Paths
| Path (Container) | Host Path |
|-----------------|-----------|
| /data | /Volumes/HomeLab-4TB/Media/Comics |

## Mobile Apps
- **Android**: Tachiyomi (with Komga extension)
- **iOS**: Panels, Chunky

## Tags
#service #media #comics #manga #reading
