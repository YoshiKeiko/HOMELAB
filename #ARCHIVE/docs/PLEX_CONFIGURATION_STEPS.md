# 📺 Plex Configuration Steps

## ✅ Folders Created on HomeLab-4TB

```
/Volumes/HomeLab-4TB/
├── Media/
│   ├── Movies/         ✓ Ready for Plex
│   ├── TV Shows/       ✓ Ready for Plex
│   ├── Music/          ✓ Ready for Plex
│   └── Photos/         ✓ Ready for Plex
└── Downloads/
    ├── incomplete/     ✓ Transmission downloading here
    └── complete/
        ├── movies/     ✓ Radarr picks up from here
        └── tv/         ✓ Sonarr picks up from here
```

## 🎬 Configure Plex Libraries (DO THIS NOW!)

### 1. Open Plex Web Interface

```
http://localhost:32400/web
```

### 2. Add Movie Library

1. Click **"More"** or **"+"** in the sidebar
2. Click **"Add Library"**
3. Select **"Movies"**
4. Click **"Next"**
5. Click **"Browse for Media Folder"**
6. Navigate to **`/movies`** (this is inside the container)
7. Click **"Add"**
8. Under **"Advanced"**:
   - ✅ Check "Scan my library automatically"
   - ✅ Check "Run a partial scan when changes are detected"
9. Click **"Add Library"**

### 3. Add TV Shows Library

1. Click **"+"** → **"Add Library"**
2. Select **"TV Shows"**
3. Browse to **`/tv`**
4. Click **"Add"**
5. Enable automatic scanning
6. Click **"Add Library"**

### 4. Add Music Library (Optional)

1. Add Library → **"Music"**
2. Browse to **`/music`**
3. Click **"Add Library"**

### 5. Add Photos Library (Optional)

1. Add Library → **"Photos"**
2. Browse to **`/photos`**
3. Click **"Add Library"**

### 6. Verify Test Movie

1. Go to Movies library
2. You should see **"Big Buck Bunny (2008)"**
3. If not, click **"..."** → **"Scan Library Files"**
4. Wait 30 seconds
5. Refresh page

---

## 🎯 Configure Radarr (Movie Automation)

### 1. Open Radarr

```
http://localhost:7878
```

### 2. Add Root Folder

1. **Settings** → **Media Management**
2. Click **"Add Root Folder"**
3. Enter: **`/movies`**
4. Click **"OK"**

### 3. Connect to Transmission

1. **Settings** → **Download Clients**
2. Click **"+"** → **"Transmission"**
3. Configure:
   - **Name:** Transmission
   - **Host:** transmission
   - **Port:** 9091
   - **Username:** admin
   - **Password:** transmission
   - **Category:** movies
   - **Directory:** (leave empty)
4. Click **"Test"** → Should show green checkmark
5. Click **"Save"**

### 4. Connect to Plex

1. **Settings** → **Connect**
2. Click **"+"** → **"Plex Media Server"**
3. Configure:
   - **Name:** Plex
   - **Host:** plex
   - **Port:** 32400
4. Click **"Authenticate with Plex.tv"**
5. Sign in
6. Click **"Test"** → Should work
7. Click **"Save"**

### 5. Connect to Prowlarr

1. Open Prowlarr: http://localhost:9696
2. **Settings** → **Apps**
3. Click **"+"** → **"Radarr"**
4. Get Radarr API key:
   - Open Radarr → Settings → General
   - Copy **API Key**
5. In Prowlarr:
   - **Prowlarr Server:** http://prowlarr:9696
   - **Radarr Server:** http://radarr:7878
   - **API Key:** (paste from Radarr)
6. Click **"Test"** → **"Save"**

---

## 📺 Configure Sonarr (TV Automation)

### 1. Open Sonarr

```
http://localhost:8989
```

### 2. Add Root Folder

1. **Settings** → **Media Management**
2. Click **"Add Root Folder"**
3. Enter: **`/tv`**
4. Click **"OK"**

### 3. Connect to Transmission

Same as Radarr:
- **Host:** transmission
- **Port:** 9091
- **Username:** admin
- **Password:** transmission
- **Category:** tv

### 4. Connect to Plex

Same as Radarr:
- **Host:** plex
- **Port:** 32400
- Authenticate with Plex.tv

### 5. Connect to Prowlarr

1. Get Sonarr API key
2. In Prowlarr → Settings → Apps
3. Add Sonarr
4. Configure and test

---

## 🎭 Configure Overseerr (Request Management)

### 1. Open Overseerr

```
http://localhost:5055
```

### 2. Sign In with Plex

1. Click **"Use your Plex account"**
2. Sign in with Plex
3. Grant permissions

### 3. Connect Plex Server

1. Select your Plex server
2. Click **"Sync Libraries"**
3. Select Movies and TV Shows libraries
4. Click **"Continue"**

### 4. Connect Radarr

1. Click **"Add Radarr Server"**
2. Configure:
   - **Server Name:** Radarr
   - **Hostname/IP:** radarr
   - **Port:** 7878
   - **API Key:** (from Radarr Settings → General)
   - **Quality Profile:** HD-1080p (or your preference)
   - **Root Folder:** /movies
3. Click **"Test"** → **"Save"**

### 5. Connect Sonarr

Same process as Radarr:
- **Hostname:** sonarr
- **Port:** 8989
- **Root Folder:** /tv

### 6. Start Using!

Now family can request content through Overseerr's beautiful interface!

---

## 🧪 Test Your Complete Setup

### Test 1: Manual File Addition

1. Download a sample movie file
2. Place in: `/Volumes/HomeLab-4TB/Media/Movies/Movie Name (Year)/`
3. Name it: `Movie Name (Year).mkv`
4. Wait 1-2 minutes
5. Check Plex - should appear!

### Test 2: Automated Download

1. Open Overseerr: http://localhost:5055
2. Search for a movie
3. Click **"Request"**
4. Watch the magic:
   - Check Radarr - appears in queue
   - Check Transmission - starts downloading
   - Wait for download to complete
   - Radarr moves to Movies folder
   - Plex scans and adds to library
5. Movie appears in Plex! 🎉

---

## 📊 Monitor Your Setup

### Plex Dashboard

- **Tautulli:** http://localhost:8181
  - Connect to Plex
  - See what's being watched
  - Usage statistics
  - User activity

### Download Progress

- **Transmission:** http://localhost:9091
  - See active downloads
  - Manage queue
  - Set bandwidth limits

### System Health

- **Portainer:** http://localhost:9000
  - Check container status
  - View logs
  - Resource usage

---

## 🔧 Transmission Settings

### Configure Download Behavior

1. Open Transmission: http://localhost:9091
2. Click **wrench icon** (Settings)

**Downloading Tab:**
- Download to: `/downloads/incomplete`
- Move completed to: `/downloads/complete`
- ✅ Check "Keep incomplete downloads in..."

**Speed Tab:**
- Upload limit: 1000 KB/s (adjust for your upload speed)
- Download limit: Unlimited (or set if needed)

**Peers Tab:**
- Max peers: 50
- Max peers per torrent: 40

**Network Tab:**
- Peer port: 51413
- ✅ "Use port forwarding"
- ✅ "Enable µTP"

Click **Save** after changes.

---

## ✅ Configuration Complete Checklist

### Plex
- [ ] Movies library added (/movies)
- [ ] TV Shows library added (/tv)
- [ ] Automatic scanning enabled
- [ ] Test movie visible

### Radarr
- [ ] Root folder set (/movies)
- [ ] Transmission connected
- [ ] Plex connected
- [ ] Prowlarr connected

### Sonarr
- [ ] Root folder set (/tv)
- [ ] Transmission connected
- [ ] Plex connected
- [ ] Prowlarr connected

### Overseerr
- [ ] Plex authenticated
- [ ] Libraries synced
- [ ] Radarr connected
- [ ] Sonarr connected

### Testing
- [ ] Test movie shows in Plex
- [ ] Requested movie downloaded successfully
- [ ] Movie appeared in Plex automatically

---

## 🎉 You're Done!

Your complete media automation system is ready:

1. **Request content** in Overseerr
2. **Automatic download** via Radarr/Sonarr + Transmission
3. **Automatic organization** with proper naming
4. **Automatic scanning** in Plex
5. **Stream anywhere** via Plex apps

**Enjoy your personal Netflix! 🍿**

