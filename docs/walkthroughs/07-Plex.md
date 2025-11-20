# Plex Media Server Configuration

**URL:** http://localhost:32400/web  
**Time:** 30-60 minutes

## Prerequisites

- [ ] Media files organized in folders
- [ ] Plex account created (free at plex.tv)

## Configuration Steps

### Step 1: Initial Setup
- [ ] Open http://localhost:32400/web
- [ ] Sign in with Plex account
- [ ] Name your server (e.g., "HomeLab")
- [ ] Click "Next"

### Step 2: Add Movie Library
- [ ] Click "Add Library"
- [ ] Select "Movies"
- [ ] Click "Next"
- [ ] Click "Browse for Media Folder"
- [ ] Navigate to: `/data/movies` (inside container)
- [ ] Click "Add"
- [ ] Under "Advanced", check:
  - [ ] "Scan my library automatically"
  - [ ] "Run scanner when changes are detected"
- [ ] Click "Add Library"

### Step 3: Add TV Shows Library
- [ ] Click "Add Library" again
- [ ] Select "TV Shows"
- [ ] Browse to: `/data/tv`
- [ ] Enable automatic scanning
- [ ] Click "Add Library"

### Step 4: Add Music Library (Optional)
- [ ] Click "Add Library"
- [ ] Select "Music"
- [ ] Browse to: `/data/music`
- [ ] Enable automatic scanning
- [ ] Click "Add Library"

### Step 5: Configure Settings

#### General Settings
- [ ] Go to Settings → General
- [ ] Set friendly name
- [ ] Enable "Update my library automatically"

#### Remote Access
- [ ] Go to Settings → Remote Access
- [ ] Click "Enable Remote Access"
- [ ] Note: May not work initially - that's OK
- [ ] Use Tailscale for remote access instead

#### Transcoder Settings
- [ ] Go to Settings → Transcoder
- [ ] Set "Transcoder quality" to "Automatic"
- [ ] Enable "Use hardware acceleration when available"
- [ ] Set transcoder temp directory to `/transcode`

### Step 6: Configure Agents (Metadata)
- [ ] Settings → Agents
- [ ] For Movies: Ensure "The Movie Database" is checked
- [ ] For TV Shows: Ensure "The TVDB" is checked
- [ ] These fetch posters, descriptions, cast info

### Step 7: Test Scanning
- [ ] Add a test movie to `/Users/homelab/HomeLab/Docker/Data/plex/media/movies`
- [ ] Go to your Movies library
- [ ] Click "..." → "Scan Library Files"
- [ ] Wait a minute, movie should appear with poster

## File Organization Best Practices

**Movies:**
```
/movies
  ├── Movie Name (Year)
  │   └── Movie Name (Year).mkv
  ├── Another Movie (2023)
  │   └── Another Movie (2023).mp4
```

**TV Shows:**
```
/tv
  ├── Show Name
  │   ├── Season 01
  │   │   ├── Show Name - S01E01.mkv
  │   │   ├── Show Name - S01E02.mkv
  │   └── Season 02
  │       ├── Show Name - S02E01.mkv
```

## Features to Explore

### Collections
- Automatically groups related movies
- Star Wars collection, MCU collection, etc.
- Create custom collections

### Playlists
- Create playlists across libraries
- "Workout Music", "Kids Movies", etc.

### Sharing
- Share libraries with family/friends
- Each user gets their own watch history
- Settings → Users → "Invite Friends"

### Mobile Apps
- Download Plex app on phone/tablet
- Sign in with same account
- Access your media anywhere via Tailscale

### Plex Discovery
- Get recommendations
- Find trending content
- Track what you want to watch

## Troubleshooting

**Movies not appearing:**
- Check file names match Plex format
- Run manual scan
- Check Portainer logs: `docker logs plex`

**No posters/metadata:**
- Check internet connection
- Settings → Troubleshooting → "Refresh all metadata"

**Buffering/transcoding issues:**
- Reduce quality in player settings
- Check CPU usage in Portainer
- M4 Mac should handle 4K transcoding fine

## ✅ Verification

- [ ] Can see movie library
- [ ] Can see TV show library
- [ ] Test movie has poster and metadata
- [ ] Can play a video
- [ ] Video plays smoothly

## Next Steps

→ Configure [Radarr](10-Radarr.md) to automate movie downloads  
→ Configure [Sonarr](11-Sonarr.md) to automate TV downloads  
→ Configure [Overseerr](13-Overseerr.md) for family requests

