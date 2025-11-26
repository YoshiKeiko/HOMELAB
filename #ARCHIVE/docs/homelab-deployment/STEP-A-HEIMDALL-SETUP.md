# STEP A: HEIMDALL & HOMEPAGE SETUP

**Time Required:** 5 minutes  
**Goal:** Get organized dashboard with icons + custom homepage in Brave

---

## Part 1: Set Custom Homepage in Brave (2 minutes)

### 1. Download Homepage File
[Download homepage-bookmarks.html](computer:///mnt/user-data/outputs/homepage-bookmarks.html)

Save to: `~/homelab-deployment/homepage-bookmarks.html`

### 2. Configure Brave Browser

**Open Brave Settings:**
```
Brave Menu → Settings → Get Started
```

**Set Homepage:**
1. Under "On startup" select: **Open a specific page or set of pages**
2. Click "Add a new page"
3. Enter: `file:///Users/homelab/homelab-deployment/homepage-bookmarks.html`
4. Click "Add"

**Set New Tab:**
1. Scroll to "Appearance" section
2. Under "New Tab Page" → "Show home button" → Toggle ON
3. Under "Home button" → Select "Custom address"
4. Enter: `file:///Users/homelab/homelab-deployment/homepage-bookmarks.html`

### 3. Test It
1. Close Brave completely (Cmd+Q)
2. Reopen Brave
3. Should see your beautiful custom dashboard!

**Homepage Features:**
- ✅ Color-coded categories
- ✅ Working services in blue/purple gradient
- ✅ Broken services in red (marked with ⚠️)
- ✅ Quick links at top for most-used services
- ✅ All 40+ services organized

---

## Part 2: Import Heimdall Config (3 minutes)

### 1. Open Heimdall
```
http://192.168.50.50:8090
```

### 2. Access Settings
- Click the **gear icon** (⚙️) in top right corner

### 3. Scroll to Import Section
- Scroll all the way to the bottom
- Find "Import/Export" section

### 4. Import Configuration
1. Click "Choose File" under Import
2. Select: `heimdall-config.yml` from `~/homelab-deployment/`
3. Click "Import"

### 5. Verify Import
You should now see all services organized in categories:
- 📊 Infrastructure
- 🎬 Media Management  
- 🔽 Media Automation
- 🏠 Smart Home
- 🤖 AI & ML Services
- 📊 Monitoring
- 🔐 Security
- 📁 Storage & Files
- 📄 Productivity
- 📱 Dashboards
- 🛠️ Utilities

**With proper vendor icons for each service!**

---

## Part 3: Customize Heimdall (Optional)

### Add Custom Background
1. Settings → Appearance
2. Upload background image
3. Adjust opacity

### Rearrange Services
1. Click and drag service tiles
2. Move to different categories
3. Changes save automatically

### Add New Services
1. Click "+" in any category
2. Fill in:
   - Name
   - URL
   - Icon (auto-detected or manual)
3. Save

---

## ✅ COMPLETION CHECKLIST

- [ ] Homepage file downloaded
- [ ] Brave configured to use custom homepage
- [ ] Custom homepage displays correctly
- [ ] Heimdall config file downloaded
- [ ] Heimdall config imported successfully
- [ ] All services showing with proper icons
- [ ] Services organized in categories

---

## 📸 What You Should See

**Custom Homepage:**
- Purple/blue gradient background
- Quick links at top (Heimdall, Portainer, Plex, HA)
- Services in colored boxes
- Working services = blue/purple
- Broken services = red with ⚠️

**Heimdall Dashboard:**
- Clean organized layout
- Category headers with emojis
- Each service has proper icon
- Color-coded by category
- Click any service → opens directly

---

## 🎯 BENEFITS

**Custom Homepage:**
- ✅ Instant access to all services
- ✅ Visual status (see what's broken)
- ✅ Works offline (local file)
- ✅ Fast (no external loading)
- ✅ Beautiful gradient design

**Heimdall:**
- ✅ Professional dashboard
- ✅ Proper vendor icons
- ✅ Organized categories
- ✅ Click to launch services
- ✅ Can be accessed from any device

---

## Next Step

When ready, move to **STEP C: BACKUP SETUP**
