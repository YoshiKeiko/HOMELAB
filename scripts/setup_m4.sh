#!/bin/bash

cat > "$HOME/HomeLab/docs/OVERSEERR_SETUP_GUIDE.md" << 'EOF'
# 🎭 Overseerr Complete Setup Guide

**URL:** http://localhost:5055

**Time:** 10-15 minutes

---

## 🎯 What is Overseerr?

Your family's Netflix-style request interface!

**What it does:**
- Beautiful interface to browse and request movies/TV shows
- Integrates with Plex, Radarr, and Sonarr
- Automatically downloads requested content
- Notifies when content is available
- User management (family members get their own accounts)

**The magic:**
1. Family member opens Overseerr
2. Searches for "Spider-Man"
3. Clicks "Request"
4. Radarr downloads it automatically
5. Appears in Plex
6. Family gets notification "Spider-Man is ready!"

---

## 📍 Step 1: Initial Setup

### 1. Open Overseerr

```
http://localhost:5055
```

### 2. Sign In with Plex

You'll see the welcome screen.

Click **"Sign in with Plex"**

**Why Plex?**
- Uses your existing Plex account
- No need to create another account
- Automatically imports Plex users
- Shows what's already in your library

### 3. Authorize Overseerr

1. Sign in with your **Plex account**
2. Click **"Accept"** to grant permissions
3. You'll be redirected back to Overseerr

✅ You're now signed in!

---

## 📍 Step 2: Connect to Plex Server

### 1. Select Your Plex Server

Overseerr will auto-detect your Plex server.

You should see: **"Plex"** or your server name

Click **"Select"**

### 2. Sync Libraries

Check the boxes for:
- ✅ **Movies**
- ✅ **TV Shows**

**Why?**
- Overseerr shows what's already available
- Prevents duplicate requests
- Shows "Available" vs "Request" buttons

Click **"Continue"**

### 3. Wait for Sync

Initial sync takes 30-60 seconds (depending on library size)

You'll see: "Syncing Plex libraries..."

✅ When done, click **"Continue"**

---

## 📍 Step 3: Connect to Radarr (Movies)

### 1. Click "Add Radarr Server"

You'll see the Radarr configuration screen.

### 2. Get Radarr API Key

**In a new tab:**
1. Open Radarr: http://localhost:7878
2. **Settings** → **General**
3. Scroll to **Security** section
4. Copy the **API Key** (long string of letters/numbers)

### 3. Configure Radarr in Overseerr

Back in Overseerr, enter:

| Field | Value |
|-------|-------|
| **Default Server** | ✅ Checked |
| **4K Server** | ⬜ Unchecked (unless you have 4K setup) |
| **Server Name** | `Radarr` |
| **Hostname or IP Address** | `radarr` |
| **Port** | `7878` |
| **Use SSL** | ⬜ Unchecked |
| **API Key** | (paste from Radarr) |
| **URL Base** | (leave empty) |

### 4. Test Connection

Click **"Test"**

✅ Should show: **"Radarr connection established successfully!"**

### 5. Configure Quality & Path

Overseerr will load your Radarr settings:

**Quality Profile:**
- Select: **HD-1080p** (or your preference)
- This determines download quality

**Root Folder:**
- Should auto-select: `/movies`
- This is where movies will be saved

**Minimum Availability:**
- Select: **Released** (recommended)
- Or: **In Cinemas** (downloads as soon as available)

### 6. Advanced Settings (Optional)

**Enable Scan:**
- ✅ Checked (refreshes from Radarr automatically)

**Enable Automatic Search:**
- ✅ Checked (starts download immediately on request)

### 7. Save

Click **"Add Server"**

✅ Radarr is connected!

---

## 📍 Step 4: Connect to Sonarr (TV Shows)

### 1. Click "Add Sonarr Server"

### 2. Get Sonarr API Key

**In a new tab:**
1. Open Sonarr: http://localhost:8989
2. **Settings** → **General**
3. Copy the **API Key**

### 3. Configure Sonarr in Overseerr

| Field | Value |
|-------|-------|
| **Default Server** | ✅ Checked |
| **4K Server** | ⬜ Unchecked |
| **Server Name** | `Sonarr` |
| **Hostname or IP Address** | `sonarr` |
| **Port** | `8989` |
| **Use SSL** | ⬜ Unchecked |
| **API Key** | (paste from Sonarr) |
| **URL Base** | (leave empty) |

### 4. Test Connection

Click **"Test"**

✅ Should show: **"Sonarr connection established successfully!"**

### 5. Configure Quality & Path

**Quality Profile:**
- Select: **HD-1080p** or **Any**

**Root Folder:**
- Should show: `/tv`

**Language Profile:**
- Select: **English** (or your preference)

**Season Folder:**
- ✅ Checked (organizes by season)

### 6. Advanced Settings

**Enable Scan:** ✅ Checked

**Enable Automatic Search:** ✅ Checked

### 7. Save

Click **"Add Server"**

✅ Sonarr is connected!

---

## 📍 Step 5: Configure Settings

### 1. Click "Continue" or "Finish Setup"

You're now on the Overseerr homepage!

### 2. Access Settings

Click your **profile icon** (top right) → **Settings**

---

### General Settings

**Settings → General**

**Application Title:**
- Change to: "Family Media Requests" (or keep "Overseerr")

**Application URL:**
- If using Tailscale: `http://YOUR_TAILSCALE_IP:5055`
- Otherwise: `http://localhost:5055`

**Enable CSRF Protection:**
- ✅ Checked

**Hide Available Media:**
- ⬜ Unchecked (shows what's already available)
- Or: ✅ Checked (only shows unavailable content)

**Allow Partial Series Requests:**
- ✅ Checked (request specific seasons)

**Display Language:**
- English

---

### User Settings

**Settings → Users**

**Default Permissions:**

Set what new users can do by default:

- ✅ **Request** (can request content)
- ✅ **Request Movies**
- ✅ **Request TV Shows**
- ⬜ **Auto-Approve** (you approve requests manually)
- ⬜ **Manage Requests** (only admins)

**Note:** You can override per-user later

---

### Notification Settings

**Settings → Notifications**

Get notified when content is requested/available!

#### Email Notifications (Recommended)

**Settings → Notifications → Email**

1. Click **"Email"**
2. **Enable Agent:** ✅ Checked

**SMTP Configuration (use Gmail):**

| Field | Value |
|-------|-------|
| **Email Address** | your-email@gmail.com |
| **SMTP Host** | smtp.gmail.com |
| **SMTP Port** | 587 |
| **Enable SSL** | ✅ Checked |
| **SMTP User** | your-email@gmail.com |
| **SMTP Password** | (App Password - see below) |

**How to get Gmail App Password:**
1. Go to: https://myaccount.google.com/apppasswords
2. Select app: "Mail"
3. Select device: "Mac"
4. Click "Generate"
5. Copy the 16-character password
6. Paste in Overseerr

**Notification Types:**

Select what you want emails for:
- ✅ **Media Requested** (someone requests content)
- ✅ **Media Automatically Approved** 
- ✅ **Media Available** (download complete!)
- ✅ **Media Failed** (download failed)
- ⬜ **Media Approved** (if manual approval)
- ⬜ **Media Declined**

**Test:** Click "Test" to send test email

✅ Should receive email!

#### Discord Notifications (Alternative)

**If you have Discord:**

**Settings → Notifications → Discord**

1. Create Discord webhook in your server
2. Paste webhook URL
3. Enable notifications
4. Test

#### Telegram Notifications (Alternative)

**If you have Telegram:**

**Settings → Notifications → Telegram**

1. Create bot with @BotFather
2. Get bot token
3. Get your chat ID
4. Configure in Overseerr

---

## 📍 Step 6: Invite Family Members

### 1. Settings → Users

**You'll see:**
- Your account (Admin)
- Any Plex users (auto-imported)

### 2. Import Plex Users

If you share your Plex server with family:

Click **"Import Plex Users"**

✅ All Plex users appear in Overseerr automatically!

### 3. Set Permissions Per User

Click on each user:

**Request Limits:**
- **Movie Request Limit:** 10 per week
- **TV Request Limit:** 10 per week
- Or set to: "Unlimited"

**Permissions:**
- ✅ **Request**
- ✅ **Request Movies**
- ✅ **Request TV Shows**
- ✅ **Auto-Approve** (trust them)
- Or ⬜ (you approve manually)

**Save** changes

### 4. Share Overseerr with Family

**Via Tailscale (Recommended):**
```
http://YOUR_TAILSCALE_IP:5055
```

**Or via Home Network:**
```
http://YOUR_MAC_IP:5055
```

Tell family members to:
1. Open that URL
2. Sign in with their Plex account
3. Start requesting!

---

## 📍 Step 7: Test It Works!

### 1. Request a Movie

1. Click **"Browse"** → **"Movies"**
2. Or: Use search box (top)
3. Search for: "Big Buck Bunny" (or any movie)
4. Click on the movie
5. Click **"Request"**

**What happens:**
1. Request appears in Overseerr (Requests tab)
2. Request sent to Radarr
3. Radarr searches via Prowlarr
4. Radarr sends to Transmission
5. Movie downloads
6. Radarr moves to `/movies`
7. Plex scans and adds
8. Overseerr marks as "Available"
9. You get notification! 📧

### 2. Monitor Request

**In Overseerr:**
- Click **"Requests"** (sidebar)
- See your request
- Status: "Pending" → "Processing" → "Available"

**In Radarr:**
- Open Radarr: http://localhost:7878
- Click **"Queue"**
- See movie downloading

**In Transmission:**
- Open: http://localhost:9091
- See active download

### 3. Check Plex

Wait for download to complete (depends on size)

**In Plex:**
- Open: http://localhost:32400/web
- Go to Movies library
- Your requested movie appears! 🎉

---

## 🎨 Customize Overseerr

### Change Theme

**Settings → General → Display Language**

- Light theme
- Dark theme (default)

### Add Custom Background

**Settings → General**

Upload custom background image for login screen

### Discovery Settings

**Settings → Discovery**

**Enable/Disable sections:**
- ✅ Popular Movies
- ✅ Trending
- ✅ Upcoming
- ✅ Now Playing in Theaters
- ✅ Popular TV Shows

---

## 👥 User Guide (Share with Family)

**How to Use Overseerr:**

### For Family Members

**1. Access Overseerr:**
```
http://[YOUR_IP]:5055
```

**2. Sign In:**
- Click "Sign in with Plex"
- Use your Plex account

**3. Request Content:**

**To Request a Movie:**
1. Search for movie
2. Click on it
3. Click "Request"
4. Done! You'll get notified when ready

**To Request a TV Show:**
1. Search for show
2. Click on it
3. Select seasons you want
4. Click "Request"

**Check Status:**
- Click "Requests" (sidebar)
- See all your requests
- Status shows: Pending → Available

**When Available:**
- You get notification
- Content appears in Plex!
- Start watching

---

## 📊 Managing Requests (Admin)

### View All Requests

**Requests tab:**
- See all pending requests
- See approved/declined
- Filter by user

### Approve/Decline Manually

If auto-approve is off:

1. Click on request
2. Click **"Approve"** or **"Decline"**
3. Add note (optional)

### Issue Management

If download fails:

1. Request shows **"Failed"**
2. Click on request
3. Click **"Retry"** or **"Report Issue"**
4. Radarr/Sonarr tries again

---

## 🧪 Testing Checklist

- [ ] Logged in with Plex account
- [ ] Plex server connected
- [ ] Libraries synced (Movies + TV Shows)
- [ ] Radarr connected and tested
- [ ] Sonarr connected and tested
- [ ] Email notifications configured
- [ ] Test movie request sent
- [ ] Request appeared in Radarr
- [ ] Download started in Transmission
- [ ] Movie appeared in Plex
- [ ] Notification received
- [ ] Family members invited

---

## 🔧 Troubleshooting

### Can't Sign In with Plex

**Problem:** "Unable to sign in"

**Fix:**
1. Make sure Plex is running: http://localhost:32400/web
2. Sign into Plex first
3. Then try Overseerr again
4. Check Overseerr can reach Plex: Settings → Plex

### Request Not Going to Radarr

**Problem:** Request stuck at "Pending"

**Check:**
1. Radarr is running: http://localhost:7878
2. In Overseerr → Settings → Radarr
3. Click "Test" - should be successful
4. Check API key is correct
5. Check "Enable Automatic Search" is checked

### Movie Downloads But Doesn't Appear in Plex

**Problem:** Radarr shows complete, but not in Plex

**Fix:**
1. Check Radarr connected to Plex:
   - Radarr → Settings → Connect
   - Should have Plex Media Server configured
2. Manually scan Plex library
3. Check movie is in correct folder

### Notifications Not Working

**Problem:** Not receiving emails

**Check:**
1. Gmail app password (not regular password)
2. SSL enabled
3. Port 587
4. Test notification
5. Check spam folder

---

## 💡 Pro Tips

### Request Limits

Set weekly limits per user to prevent abuse:
- Settings → Users → [User] → Request Limits
- Example: 5 movies + 3 TV shows per week

### Quality Profiles

Create multiple quality profiles in Radarr:
- HD-1080p (default)
- HD-720p (smaller files)
- Ultra-HD-4K (if you have space)

In Overseerr, users can choose quality when requesting.

### Auto-Approve Trusted Users

For your account and close family:
- Settings → Users → [User]
- ✅ Auto-Approve Movies
- ✅ Auto-Approve TV

For kids/friends:
- ⬜ Auto-Approve (you review requests first)

### Mobile Access

**Bookmark on phone:**
1. Open Overseerr on phone browser
2. Share → "Add to Home Screen"
3. Looks like a real app!

**Via Tailscale:**
- Install Tailscale on phone
- Access: `http://YOUR_TAILSCALE_IP:5055`
- Request from anywhere!

---

## ✅ Setup Complete!

**You now have:**
- ✅ Beautiful request interface
- ✅ Automatic downloads
- ✅ Plex integration
- ✅ User management
- ✅ Notifications
- ✅ Family-friendly system

**Your family can now:**
1. Browse available content
2. Request new movies/shows
3. Get notified when ready
4. Start watching in Plex

**No more text messages asking for content! 🎉**

---

## 📱 Quick Reference

**Overseerr:** http://localhost:5055

**Admin access:**
- Your profile icon → Settings
- Manage users, notifications, services

**User access:**
- Discover → Browse content
- Search → Find specific titles
- Requests → Track your requests

**Family shares:**
- Via Tailscale: `http://[TAILSCALE_IP]:5055`
- Sign in with Plex account
- Start requesting!

**The complete media request system! 🍿**

EOF

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Overseerr Setup Guide Created"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "View complete guide:"
echo "  open ~/HomeLab/docs/OVERSEERR_SETUP_GUIDE.md"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Quick Setup Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Open Overseerr: http://localhost:5055"
echo ""
echo "2. Sign in with Plex account"
echo ""
echo "3. Select Plex server → Sync libraries (Movies + TV)"
echo ""
echo "4. Add Radarr:"
echo "   - Get API key from Radarr (Settings → General)"
echo "   - Host: radarr"
echo "   - Port: 7878"
echo "   - API Key: (paste)"
echo "   - Quality: HD-1080p"
echo "   - Root Folder: /movies"
echo ""
echo "5. Add Sonarr:"
echo "   - Get API key from Sonarr (Settings → General)"
echo "   - Host: sonarr"
echo "   - Port: 8989"
echo "   - API Key: (paste)"
echo "   - Root Folder: /tv"
echo ""
echo "6. Test request:"
echo "   - Search for a movie"
echo "   - Click Request"
echo "   - Check Radarr and Transmission"
echo "   - Wait for it to appear in Plex!"
echo ""
echo "Complete step-by-step in the guide above!"
echo ""