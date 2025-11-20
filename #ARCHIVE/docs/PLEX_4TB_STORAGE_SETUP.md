# 📦 Plex 4TB Storage Configuration Guide

## 🎯 Recommended Storage Structure

### Your 4TB External SSD Layout

```
/Volumes/YourDriveName/           (Your 4TB SSD root)
├── Media/                        (Main media folder)
│   ├── Movies/                   (All movies here)
│   │   ├── Movie Name (Year)/
│   │   │   └── Movie Name (Year).mkv
│   │   ├── Another Movie (2023)/
│   │   │   └── Another Movie (2023).mp4
│   │
│   ├── TV Shows/                 (All TV shows here)
│   │   ├── Show Name/
│   │   │   ├── Season 01/
│   │   │   │   ├── Show - S01E01.mkv
│   │   │   │   ├── Show - S01E02.mkv
│   │   │   └── Season 02/
│   │   │       └── Show - S02E01.mkv
│   │
│   ├── Music/                    (Music library)
│   │   ├── Artist Name/
│   │   │   ├── Album Name/
│   │   │   │   └── 01 - Track.mp3
│   │
│   └── Photos/                   (Photo library)
│       └── Year/
│           └── photos.jpg
│
└── Downloads/                    (Transmission downloads)
    ├── incomplete/               (Downloading files)
    └── complete/                 (Finished downloads)
        ├── movies/               (Radarr picks up from here)
        └── tv/                   (Sonarr picks up from here)
```

---

## 📍 Step 1: Find Your Drive Name

### Check What Your Drive is Called

```bash
# List all external drives
diskutil list external

# Or see mounted volumes
ls -la /Volumes/
```

**Common names:**
- "Untitled" (if not named yet)
- "External SSD"
- "Samsung T5/T7"
- "Elements"
- Custom name you gave it

**For this guide, let's say it's:** `/Volumes/External SSD`

---

## 📍 Step 2: Create Folder Structure

### Run These Commands

```bash
# Set your drive name (CHANGE THIS to match your drive!)
DRIVE="/Volumes/External SSD"

# Create main media folders
mkdir -p "$DRIVE/Media/Movies"
mkdir -p "$DRIVE/Media/TV Shows"
mkdir -p "$DRIVE/Media/Music"
mkdir -p "$DRIVE/Media/Photos"

# Create download folders for Transmission
mkdir -p "$DRIVE/Downloads/incomplete"
mkdir -p "$DRIVE/Downloads/complete/movies"
mkdir -p "$DRIVE/Downloads/complete/tv"

# Verify structure
tree -L 3 "$DRIVE" || ls -R "$DRIVE"
```

---

## 📍 Step 3: Update Plex Configuration

### Option A: Via Plex Docker Compose (RECOMMENDED)

**Edit your Plex compose file:**

```bash
nano ~/HomeLab/Docker/Compose/media.yml
```

**Find the Plex volumes section and update to:**

```yaml
services:
  plex:
    image: lscr.io/linuxserver/plex:latest
    container_name: plex
    restart: unless-stopped
    ports:
      - "32400:32400"
    environment:
      - PUID=1000
      - PGID=1000
      - VERSION=docker
      - TZ=Europe/London
    volumes:
      # Plex config (stays on Mac - small)
      - /Users/homelab/HomeLab/Docker/Data/plex/config:/config
      
      # Media libraries (on 4TB SSD - large!)
      - /Volumes/External SSD/Media/Movies:/movies
      - /Volumes/External SSD/Media/TV Shows:/tv
      - /Volumes/External SSD/Media/Music:/music
      - /Volumes/External SSD/Media/Photos:/photos
      
      # Optional: Transcode folder (temporary files)
      - /Users/homelab/HomeLab/Docker/Data/plex/transcode:/transcode
    networks:
      - homelab-net
```

**Restart Plex:**

```bash
docker compose -f ~/HomeLab/Docker/Compose/media.yml down
docker compose -f ~/HomeLab/Docker/Compose/media.yml up -d
```

### Option B: Manual Docker Command (Alternative)

```bash
# Stop current Plex
docker stop plex
docker rm plex

# Start with new paths (CHANGE /Volumes/External SSD to YOUR drive name!)
docker run -d \
  --name plex \
  --restart unless-stopped \
  --network homelab-net \
  -p 32400:32400 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e VERSION=docker \
  -e TZ=Europe/London \
  -v /Users/homelab/HomeLab/Docker/Data/plex/config:/config \
  -v "/Volumes/External SSD/Media/Movies":/movies \
  -v "/Volumes/External SSD/Media/TV Shows":/tv \
  -v "/Volumes/External SSD/Media/Music":/music \
  -v "/Volumes/External SSD/Media/Photos":/photos \
  lscr.io/linuxserver/plex:latest
```

---

## 📍 Step 4: Configure Plex Libraries

### In Plex Web Interface

1. **Open Plex:** http://localhost:32400/web

2. **Add Movie Library:**
   - Settings → Libraries → Add Library
   - Type: Movies
   - Click "Add Folders"
   - Click "Browse for Media Folder"
   - Navigate to: `/movies` (inside container)
   - Add folder
   - Next → Add Library

3. **Add TV Shows Library:**
   - Add Library → TV Shows
   - Browse to: `/tv`
   - Add folder → Add Library

4. **Add Music Library:**
   - Add Library → Music
   - Browse to: `/music`
   - Add folder → Add Library

5. **Add Photos Library:**
   - Add Library → Photos
   - Browse to: `/photos`
   - Add folder → Add Library

---

## 📍 Step 5: Update Media Automation Services

### Update Radarr (Movies)

**Edit compose file:**
```bash
nano ~/HomeLab/Docker/Compose/media.yml
```

**Update Radarr volumes:**

```yaml
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/radarr:/config
      
      # Movie library (same path as Plex sees)
      - /Volumes/External SSD/Media/Movies:/movies
      
      # Downloads folder (where Transmission saves)
      - /Volumes/External SSD/Downloads:/downloads
```

**Configure in Radarr:**
1. Open Radarr: http://localhost:7878
2. Settings → Media Management
3. Root Folder: `/movies`
4. Settings → Download Clients → Transmission
   - Category: movies
   - Directory: `/downloads/complete/movies`

### Update Sonarr (TV Shows)

**Update Sonarr volumes:**

```yaml
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/sonarr:/config
      
      # TV library (same path as Plex sees)
      - /Volumes/External SSD/Media/TV Shows:/tv
      
      # Downloads folder
      - /Volumes/External SSD/Downloads:/downloads
```

**Configure in Sonarr:**
1. Open Sonarr: http://localhost:8989
2. Settings → Media Management
3. Root Folder: `/tv`
4. Settings → Download Clients → Transmission
   - Category: tv
   - Directory: `/downloads/complete/tv`

### Update Transmission (Downloads)

**Update Transmission volumes:**

```yaml
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/transmission:/config
      
      # Downloads go to 4TB
      - /Volumes/External SSD/Downloads:/downloads
```

**Configure in Transmission:**
1. Open Transmission: http://localhost:9091
2. Settings (wrench icon)
3. Downloading:
   - Download to: `/downloads/incomplete`
   - Move completed to: `/downloads/complete`

---

## 🔄 Complete Media Flow

### How It All Works Together

```
1. Request Movie in Overseerr
   ↓
2. Overseerr tells Radarr
   ↓
3. Radarr searches via Prowlarr
   ↓
4. Radarr sends torrent to Transmission
   ↓
5. Transmission downloads to:
   /Volumes/External SSD/Downloads/incomplete/
   ↓
6. When complete, moves to:
   /Volumes/External SSD/Downloads/complete/movies/
   ↓
7. Radarr detects complete download
   ↓
8. Radarr moves & renames to:
   /Volumes/External SSD/Media/Movies/Movie (Year)/Movie.mkv
   ↓
9. Radarr tells Plex to scan library
   ↓
10. Movie appears in Plex! 🎉
```

---

## 📍 Step 6: Restart All Services

```bash
# Restart entire media stack
docker compose -f ~/HomeLab/Docker/Compose/media.yml restart

# Or restart individually
docker restart plex
docker restart radarr
docker restart sonarr
docker restart transmission
```

---

## ⚠️ Important Considerations

### Drive Must Be Mounted Before Docker Starts

**Problem:** If Mac restarts, drive might not be mounted when Docker starts

**Solution 1: Auto-Mount on Login**
1. System Settings → Users & Groups
2. Your user → Login Items
3. Add your external drive
4. Check "Hide" so it doesn't open Finder

**Solution 2: Ensure Drive is Mounted Script**

Create: `~/ensure-drive-mounted.sh`

```bash
#!/bin/bash
DRIVE="/Volumes/External SSD"

if [ ! -d "$DRIVE" ]; then
    echo "Drive not mounted!"
    # Send notification
    osascript -e 'display notification "External SSD not mounted!" with title "HomeLab Warning"'
    exit 1
fi

echo "Drive mounted OK"
```

Add to crontab:
```bash
crontab -e
# Add this line:
*/5 * * * * ~/ensure-drive-mounted.sh
```

### What Stays on Mac, What Goes on 4TB

**Mac Internal (512GB) - Small files:**
- ✅ Docker configs
- ✅ Databases
- ✅ Application data
- ✅ Logs
- ✅ Thumbnails/metadata
- **Total:** ~50-100GB

**4TB External - Large files:**
- ✅ Movies (large!)
- ✅ TV Shows (large!)
- ✅ Music
- ✅ Photos
- ✅ Downloads (temporary)
- **Can use:** All 4TB!

### Backup Strategy

**4TB Drive:**
- Clone to second 4TB drive weekly (Carbon Copy Cloner)
- Or: Backblaze B2 cloud backup

**Mac Internal:**
- Time Machine to external drive
- Or: Duplicati to cloud

---

## 🧪 Testing Your Setup

### Test 1: Check Mounts

```bash
# Inside Plex container
docker exec plex ls -la /movies
docker exec plex ls -la /tv

# Should show your media folders
```

### Test 2: Add Test Movie

```bash
DRIVE="/Volumes/External SSD"

# Create test movie folder
mkdir -p "$DRIVE/Media/Movies/Test Movie (2024)"

# Create fake movie file (1MB)
dd if=/dev/zero of="$DRIVE/Media/Movies/Test Movie (2024)/Test Movie (2024).mkv" bs=1m count=1

# Scan library in Plex
# Should appear in Plex within a minute
```

### Test 3: Full Automation Test

1. In Overseerr: Request a movie
2. Watch Radarr: Should pick it up
3. Watch Transmission: Should start downloading
4. Watch Downloads folder: File appears
5. When complete: Radarr moves to Movies
6. Check Plex: Movie appears!

---

## 📊 Disk Space Management

### Monitor 4TB Usage

```bash
# Check free space
df -h "/Volumes/External SSD"

# Check folder sizes
du -sh "/Volumes/External SSD/Media"/*
du -sh "/Volumes/External SSD/Downloads"/*
```

### Clean Up Downloads

```bash
# After Radarr/Sonarr move files, clean downloads
rm -rf "/Volumes/External SSD/Downloads/complete/movies/*"
rm -rf "/Volumes/External SSD/Downloads/complete/tv/*"
```

Or set Transmission to auto-delete after 7 days.

---

## 🚨 Troubleshooting

### "No such file or directory" in Plex

**Problem:** Drive not mounted or path wrong

**Check:**
```bash
# Is drive mounted?
ls -la /Volumes/

# Does media folder exist?
ls -la "/Volumes/External SSD/Media"

# Restart Plex
docker restart plex
```

### Radarr Can't Move Files

**Problem:** Permission issues

**Fix:**
```bash
# Set permissions on 4TB
sudo chown -R $(whoami):staff "/Volumes/External SSD/Media"
sudo chmod -R 755 "/Volumes/External SSD/Media"
```

### Plex Can't See New Files

**Problem:** Automatic scanning disabled

**Fix:**
1. Plex → Settings → Library
2. Check "Scan my library automatically"
3. Check "Run a partial scan when changes are detected"
4. Or manually: Library → Scan Library Files

---

## ✅ Complete Setup Checklist

### Path Configuration
- [ ] 4TB drive named and mounted
- [ ] Created Media/Movies folder
- [ ] Created Media/TV Shows folder
- [ ] Created Media/Music folder
- [ ] Created Media/Photos folder
- [ ] Created Downloads/incomplete folder
- [ ] Created Downloads/complete/movies folder
- [ ] Created Downloads/complete/tv folder

### Docker Configuration
- [ ] Updated Plex volumes in compose file
- [ ] Updated Radarr volumes in compose file
- [ ] Updated Sonarr volumes in compose file
- [ ] Updated Transmission volumes in compose file
- [ ] Restarted all media containers

### Plex Configuration
- [ ] Added Movies library (/movies)
- [ ] Added TV Shows library (/tv)
- [ ] Added Music library (/music)
- [ ] Added Photos library (/photos)
- [ ] Enabled automatic scanning
- [ ] Test movie appears in Plex

### Radarr/Sonarr Configuration
- [ ] Root folder set to /movies in Radarr
- [ ] Root folder set to /tv in Sonarr
- [ ] Transmission connected in both
- [ ] Download paths configured
- [ ] Test automation works

### System Configuration
- [ ] Drive auto-mounts on login
- [ ] Permissions set correctly
- [ ] Backup strategy planned
- [ ] Disk space monitoring set up

---

## 📝 Quick Reference Commands

```bash
# Find your drive name
diskutil list external

# Create folder structure (CHANGE DRIVE NAME!)
DRIVE="/Volumes/External SSD"
mkdir -p "$DRIVE/Media"/{Movies,TV\ Shows,Music,Photos}
mkdir -p "$DRIVE/Downloads"/{incomplete,complete/{movies,tv}}

# Check free space
df -h "$DRIVE"

# Check folder sizes
du -sh "$DRIVE/Media"/*

# Test Plex can see folders
docker exec plex ls -la /movies

# Restart media stack
docker compose -f ~/HomeLab/Docker/Compose/media.yml restart

# Check container mounts
docker inspect plex | grep -A 10 Mounts
```

---

## 🎯 Recommended Final Structure

```
Mac Internal (512GB):
└── /Users/homelab/HomeLab/Docker/Data/
    ├── plex/config/          (10-20GB - metadata, thumbnails)
    ├── radarr/               (500MB - config)
    ├── sonarr/               (500MB - config)
    ├── transmission/         (100MB - config)
    └── all other services/   (30-50GB total)

4TB External:
└── /Volumes/External SSD/
    ├── Media/
    │   ├── Movies/           (Use most space here!)
    │   ├── TV Shows/         (Second most space)
    │   ├── Music/            (50-200GB)
    │   └── Photos/           (50-500GB)
    └── Downloads/
        ├── incomplete/       (Temporary - deletes after)
        └── complete/         (Temporary - deletes after move)
```

**This gives you:**
- ✅ ~3.5TB for movies/TV
- ✅ Fast metadata on Mac SSD
- ✅ Large media on 4TB
- ✅ Automatic organization
- ✅ Room to grow!

---

**Your media empire awaits! 🎬🍿**

