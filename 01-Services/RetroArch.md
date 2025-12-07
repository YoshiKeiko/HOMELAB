---
tags: [service, gaming, emulation, retro]
port: 3090
category: Gaming
status: active
---

# 🎮 RetroArch

## Overview
Multi-system emulator running in a web-accessible container, providing retro gaming from any device on your network.

## Quick Access
- **URL**: http://192.168.50.50:3090
- **Port**: 3090 (Web Interface), 3091 (HTTPS)
- **Category**: [[#Gaming]]

## Features
- 50+ emulator cores (NES, SNES, N64, PS1, GBA, etc.)
- Web-based interface accessible from any device
- Shader support for CRT effects
- Save states and rewind
- Netplay for online multiplayer
- Achievement support (RetroAchievements)
- Controller mapping
- Customizable UI themes

## Supported Systems
- Nintendo: NES, SNES, N64, GB, GBC, GBA, DS
- Sega: Master System, Genesis, Saturn, Dreamcast
- Sony: PlayStation 1, PSP
- Atari: 2600, 7800, Lynx, Jaguar
- Arcade: MAME, FBNeo
- And many more...

## Data Locations
- **Config**: `/Volumes/HomeLab-4TB/Docker-Data/retroarch`
- **ROMs**: `/Volumes/HomeLab-4TB/Media/ROMs`

## ROM Folders
Place ROMs in appropriate subfolders:
- `/ROMs/nes` - Nintendo Entertainment System
- `/ROMs/snes` - Super Nintendo
- `/ROMs/n64` - Nintendo 64
- `/ROMs/gba` - Game Boy Advance
- `/ROMs/gb` - Game Boy / Color
- `/ROMs/genesis` - Sega Genesis
- `/ROMs/psx` - PlayStation 1
- `/ROMs/arcade` - Arcade games

## Usage
1. Access http://192.168.50.50:3090 from any browser
2. Navigate to Load Content
3. Select your ROM
4. Choose appropriate core
5. Play!

## See Also
- [[00-SERVICE-INDEX]]
- [[OVERVIEW]]
