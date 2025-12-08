# HomeLab Backup & Configuration Status

## Generated: 2025-12-07 23:45

---

## ✅ COMPLETED TASKS

### 1. Ollama Optimization
| Item | Before | After |
|------|--------|-------|
| Default Model | qwen2.5:32b (19GB) | qwen2.5:14b (9GB) |
| Network Binding | localhost only | 0.0.0.0 (all interfaces) |
| Keep-Alive | Not set | 24 hours |
| Auto-Update Script | ✓ Updated | Uses 14b as default |

### 2. Files Updated
| File | Location | Changes |
|------|----------|---------|
| update-ollama-models.sh | `/Users/homelab/HomeLab/scripts/` | Default model → 14b |
| homebrew.mxcl.ollama.plist | `~/Library/LaunchAgents/` | Added OLLAMA_HOST=0.0.0.0 |
| BOOKMARKS.html | `/Users/homelab/Documents/` | AI section shows qwen2.5:14b |
| homepage-bookmarks.html | `/Users/homelab/Documents/` | AI section shows qwen2.5:14b |
| BOOKMARKS_REMOTE.html | `HOMELAB/docs/` | Updated Ollama description |
| Ollama-Config.md | `HOMELAB/01-Services/` | NEW - full config docs |
| BACKUP_STATUS_REPORT.md | `HOMELAB/02-How-To-Guides/` | NEW - backup overview |

---

## 📊 BACKUP STATUS TABLE

### Obsidian Vaults (Encrypted Git Backup)
| Vault | Status | Last Backup | Schedule | Destination |
|-------|--------|-------------|----------|-------------|
| ACCREDIBLE | ✅ | 2025-12-07 12:00 | Every 12h | GitHub (encrypted) |
| DD | ✅ | 2025-12-07 12:00 | Every 12h | GitHub (encrypted) |
| HOME | ✅ | 2025-12-07 12:00 | Every 12h | GitHub (encrypted) |
| KETO | ✅ | 2025-12-07 12:00 | Every 12h | GitHub (encrypted) |
| PERSONAL | ✅ | 2025-12-07 12:00 | Every 12h | GitHub (encrypted) |
| PROJECTS | ✅ | 2025-12-07 12:00 | Every 12h | GitHub (encrypted) |
| HOMELAB | ✅ | 2025-12-07 12:00 | Every 12h | GitHub (encrypted) |
| TRAINING | ✅ | 2025-12-07 12:00 | Every 12h | GitHub (encrypted) |

### Docker Data - Primary Storage (Time Machine + pCloud)
| Container | Data Location | Status |
|-----------|---------------|--------|
| Open WebUI | `Docker/Data/openwebui/data` | ✅ Backed up |
| Home Assistant | `Docker/Data/homeassistant/config` | ✅ Backed up |
| Vaultwarden | `Docker/Data/vaultwarden/data` | ✅ Backed up |
| Plex | `Docker/Data/plex/config` | ✅ Backed up |
| Zigbee2MQTT | `Docker/Data/zigbee2mqtt/data` | ✅ Backed up |
| Node-RED | `Docker/Data/nodered/data` | ✅ Backed up |
| Grafana | `Docker/Data/grafana/data` | ✅ Backed up |
| Prometheus | `Docker/Data/prometheus/data` | ✅ Backed up |
| Nginx Proxy | `Docker/Data/nginx-proxy-manager/` | ✅ Backed up |
| Uptime Kuma | `Docker/Data/uptime-kuma/data` | ✅ Backed up |
| Heimdall | `Docker/Data/heimdall/config` | ✅ Backed up |
| All others | `Docker/Data/*` | ✅ Backed up |

### Docker Data - External 4TB (⚠️ NOT AUTOMATED)
| Container | Data Location | Status | Recommendation |
|-----------|---------------|--------|----------------|
| Grocy | `/Volumes/HomeLab-4TB/Docker-Data/grocy` | ⚠️ Manual | Setup Kopia |
| Mealie | `/Volumes/HomeLab-4TB/Docker-Data/mealie` | ⚠️ Manual | Setup Kopia |
| Actual Budget | `/Volumes/HomeLab-4TB/Docker-Data/actual-budget` | ⚠️ Manual | Setup Kopia |
| Kavita | `/Volumes/HomeLab-4TB/Docker-Data/kavita` | ⚠️ Manual | Setup Kopia |
| Audiobookshelf | `/Volumes/HomeLab-4TB/Docker-Data/audiobookshelf` | ⚠️ Manual | Setup Kopia |
| Komga | `/Volumes/HomeLab-4TB/Docker-Data/komga` | ⚠️ Manual | Setup Kopia |
| Navidrome | `/Volumes/HomeLab-4TB/Docker-Data/navidrome` | ⚠️ Manual | Setup Kopia |
| RetroArch | `/Volumes/HomeLab-4TB/Docker-Data/retroarch` | ⚠️ Manual | Setup Kopia |
| SpeedTest | `/Volumes/HomeLab-4TB/Docker-Data/speedtest-tracker` | ⚠️ Manual | Setup Kopia |
| ChangeDetection | `/Volumes/HomeLab-4TB/Docker-Data/changedetection` | ⚠️ Manual | Setup Kopia |

### Media Storage (Not backed up - replaceable)
| Type | Location | Size | Notes |
|------|----------|------|-------|
| Movies | `/Volumes/HomeLab-4TB/Media/Movies` | Variable | Replaceable |
| TV Shows | `/Volumes/HomeLab-4TB/Media/TV Shows` | Variable | Replaceable |
| Music | `/Volumes/HomeLab-4TB/Media/Music` | Variable | Consider backup |
| Books | `/Volumes/HomeLab-4TB/Media/Books` | Variable | Consider backup |
| Audiobooks | `/Volumes/HomeLab-4TB/Media/Audiobooks` | Variable | Consider backup |

### Frigate Recordings
| Type | Location | Retention |
|------|----------|-----------|
| Recordings | `/Volumes/HomeLab-4TB/Frigate/recordings` | Rolling (auto-delete) |
| Clips | `/Volumes/HomeLab-4TB/Frigate/clips` | Rolling (auto-delete) |

---

## 🕐 CRON SCHEDULE

| Schedule | Script | Purpose |
|----------|--------|---------|
| Every 6h | `sync_vaults.sh` | Git sync for all vaults |
| Every 12h | `encrypted_multi_backup.sh` | Encrypted backup to GitHub |
| Sunday 3am | `update-ollama-models.sh` | Update Ollama models |

---

## 🔗 VERIFIED URLS

| Service | URL | Status |
|---------|-----|--------|
| Open WebUI | http://192.168.50.50:3000 | ✅ Working |
| Ollama API | http://192.168.50.50:11434 | ✅ Working |
| Home Assistant | http://192.168.50.50:8123 | ✅ Working |
| Portainer | http://192.168.50.50:9000 | ✅ Working |
| File Browser | http://192.168.50.50:8087 | ✅ Working |
| Netdata | http://192.168.50.50:19999 | ✅ Working |

---

## ⚠️ ACTION ITEMS

1. **Set qwen2.5:14b as default in Open WebUI**
   - Go to http://192.168.50.50:3000
   - Settings → Models → Set default model

2. **Setup backup for External 4TB data**
   - Consider Kopia to pCloud for critical app data
   - Priority: Actual Budget, Mealie, Kavita

3. **Consider backing up irreplaceable media**
   - Music library (if personal collection)
   - Books/eBooks
   - Audiobooks

---

*Report generated by Claude - 2025-12-07*
