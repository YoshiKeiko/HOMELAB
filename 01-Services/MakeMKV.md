# 💿 MakeMKV

## Overview
| Property | Value |
|----------|-------|
| **URL** | http://192.168.50.50:5800 |
| **Container** | makemkv |
| **Image** | jlesage/makemkv:latest |
| **Port** | 5800 (Web), 5900 (VNC) |
| **Data** | /Volumes/HomeLab-4TB/Docker-Data/makemkv |

## Features
- DVD/Blu-ray ripping
- Web-based GUI
- MKV output format
- Preserves all tracks (audio, subtitles)
- Chapter markers preserved

## First Setup
1. Visit http://192.168.50.50:5800
2. No authentication required
3. Insert disc, click to scan
4. Select titles and rip

## Paths
| Path (Container) | Host Path |
|-----------------|-----------|
| /output | /Volumes/HomeLab-4TB/Media/Rips |

## Notes
- Requires USB disc drive connected to Mac Mini
- Beta key needed (free during beta): https://makemkv.com/forum/viewtopic.php?t=1053
- Output goes to Rips folder for further processing

## Tags
#service #media #ripping #dvd #bluray
