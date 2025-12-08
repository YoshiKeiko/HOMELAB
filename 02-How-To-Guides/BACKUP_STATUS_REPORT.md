# Backup Status Report

## Generated: 2025-12-07

## Backup Systems Overview

### 1. Obsidian Vaults (Encrypted Git + Local Snapshots)
| Vault | Git Backup | Local Snapshot | Last Backup | Schedule |
|-------|-----------|----------------|-------------|----------|
| ACCREDIBLE | ✓ GitHub | ✓ Local | 2025-12-07 12:00 | Every 12h |
| DD | ✓ GitHub | ✓ Local | 2025-12-07 12:00 | Every 12h |
| HOME | ✓ GitHub | ✓ Local | 2025-12-07 12:00 | Every 12h |
| KETO | ✓ GitHub | ✓ Local | 2025-12-07 12:00 | Every 12h |
| PERSONAL | ✓ GitHub | ✓ Local | 2025-12-07 12:00 | Every 12h |
| PROJECTS | ✓ GitHub | ✓ Local | 2025-12-07 12:00 | Every 12h |
| HOMELAB | ✓ GitHub | ✓ Local | 2025-12-07 12:00 | Every 12h |
| TRAINING | ✓ GitHub | ✓ Local | 2025-12-07 12:00 | Every 12h |

**Script**: `/Users/homelab/Documents/Obsidian/encrypted_multi_backup.sh`
**Log**: `/Users/homelab/Documents/Obsidian/backup_log.txt`

---

### 2. Docker Container Data Locations

#### Primary Storage: `/Users/homelab/HomeLab/Docker/Data/`
| Container | Data Path | Backed Up By |
|-----------|-----------|--------------|
| openwebui | `openwebui/data` | Time Machine + pCloud |
| zigbee2mqtt | `zigbee2mqtt/data` | Time Machine + pCloud |
| frigate | `frigate/config` | Time Machine + pCloud |
| calibre | `calibre/config + books` | Time Machine + pCloud |
| calibre-web | `calibre-web/config` | Time Machine + pCloud |
| syncthing | `syncthing/config + data` | Time Machine + pCloud |
| homeassistant | `homeassistant/config` | Time Machine + pCloud |
| plex | `plex/config` | Time Machine + pCloud |
| nginx-proxy-manager | `nginx-proxy-manager/data` | Time Machine + pCloud |
| freshrss | `freshrss/data` | Time Machine + pCloud |
| organizr | `organizr/config` | Time Machine + pCloud |
| homer | `homer/assets` | Time Machine + pCloud |
| crowdsec | `crowdsec/config + data` | Time Machine + pCloud |
| vaultwarden | `vaultwarden/data` | Time Machine + pCloud |
| uptime-kuma | `uptime-kuma/data` | Time Machine + pCloud |
| mosquitto | `mosquitto/config + data` | Time Machine + pCloud |
| jupyter | `jupyter/notebooks` | Time Machine + pCloud |
| influxdb | `influxdb/data` | Time Machine + pCloud |
| postgres | `postgres/data` | Time Machine + pCloud |
| esphome | `esphome/config` | Time Machine + pCloud |
| nodered | `nodered/data` | Time Machine + pCloud |
| prometheus | `prometheus/data` | Time Machine + pCloud |
| heimdall | `heimdall/config` | Time Machine + pCloud |
| loki | `loki/data` | Time Machine + pCloud |
| grafana | `grafana/data` | Time Machine + pCloud |
| filebrowser | `filebrowser/db` | Time Machine + pCloud |

#### External Storage: `/Volumes/HomeLab-4TB/Docker-Data/`
| Container | Data Path | Backed Up By |
|-----------|-----------|--------------|
| grocy | `grocy/` | External 4TB (manual) |
| speedtest-tracker | `speedtest-tracker/` | External 4TB (manual) |
| navidrome | `navidrome/` | External 4TB (manual) |
| retroarch | `retroarch/` | External 4TB (manual) |
| bazarr | `bazarr/` | External 4TB (manual) |
| makemkv | `makemkv/` | External 4TB (manual) |
| actual-budget | `actual-budget/` | External 4TB (manual) |
| kavita | `kavita/` | External 4TB (manual) |
| mealie | `mealie/` | External 4TB (manual) |
| komga | `komga/` | External 4TB (manual) |
| changedetection | `changedetection/` | External 4TB (manual) |
| audiobookshelf | `audiobookshelf/` | External 4TB (manual) |
| ntfy | `ntfy/` | External 4TB (manual) |
| stirling-pdf | `stirling-pdf/` | External 4TB (manual) |

#### Media Storage: `/Volumes/HomeLab-4TB/Media/`
| Content | Path | Size |
|---------|------|------|
| Movies | `Movies/` | Variable |
| TV Shows | `TV Shows/` | Variable |
| Music | `Music/` | Variable |
| Books | `Books/` | Variable |
| Comics | `Comics/` | Variable |
| Audiobooks | `Audiobooks/` | Variable |
| ROMs | `ROMs/` | Variable |

#### Frigate Recordings: `/Volumes/HomeLab-4TB/Frigate/`
| Content | Path | Retention |
|---------|------|-----------|
| Recordings | `recordings/` | Rolling |
| Clips | `clips/` | Rolling |

---

### 3. Cron Schedule
```
0 */6 * * *   sync_vaults.sh          # Sync every 6 hours
0 */12 * * *  encrypted_multi_backup.sh  # Encrypted backup every 12h
0 3 * * 0     update-ollama-models.sh    # Weekly Ollama update
```

---

### 4. Recommended Actions

#### ⚠️ NOT BACKED UP (External 4TB Data)
The `/Volumes/HomeLab-4TB/Docker-Data/` directory is NOT included in automated backups.

**Recommendation**: Set up Kopia or rclone to backup to pCloud:
```bash
# Install kopia backup for external data
# Target: pCloud WebDAV or local secondary drive
```

#### ✓ BACKED UP (Primary Data)
- All Obsidian vaults → GitHub (encrypted)
- All primary Docker data → Time Machine + pCloud sync
- HomeLab folder → Time Machine + pCloud sync

---

## Quick Commands

```bash
# Check Obsidian backup status
tail -50 /Users/homelab/Documents/Obsidian/backup_log.txt

# Force Obsidian backup now
/Users/homelab/Documents/Obsidian/encrypted_multi_backup.sh

# List all Docker volumes
docker volume ls

# Check container mounts
docker inspect <container> --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}'
```
