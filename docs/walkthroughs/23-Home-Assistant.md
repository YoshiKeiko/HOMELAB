# Home Assistant Configuration

**URL:** http://localhost:8123  
**Tailscale:** http://TAILSCALE_IP:8123  
**Time:** 2-3 hours (varies by devices)

## What You'll Connect

Based on your setup:
- 10 Sonos speakers
- 5 Nest cameras
- Tesla Model Y
- Cupra Born EV
- Easee charger
- Plus any future smart devices

## Configuration Steps

### Step 1: Initial Setup
- [ ] Open http://localhost:8123
- [ ] Wait for Home Assistant to fully start (first launch takes 2-3 minutes)
- [ ] Create your account:
  - [ ] Name
  - [ ] Username
  - [ ] Password (save to 1Password)
  - [ ] Set time zone to "Europe/London"
  - [ ] Set location (for weather, sun, etc.)

### Step 2: Skip Analytics (Optional)
- [ ] Choose whether to share analytics
- [ ] Click "Next"

### Step 3: Device Discovery
- [ ] Home Assistant will automatically discover devices on your network
- [ ] You should see some devices appear
- [ ] Don't add them yet - we'll do it properly

### Step 4: Enable Advanced Mode
- [ ] Click your username (bottom left)
- [ ] Scroll down
- [ ] Toggle "Advanced Mode" ON
- [ ] This unlocks more features

### Step 5: Install HACS (Home Assistant Community Store)

HACS gives you access to thousands of custom integrations.

**Open Terminal in Home Assistant:**
- [ ] Go to Settings → Add-ons → Add-on Store
- [ ] Install "Terminal & SSH" add-on
- [ ] Start it
- [ ] Click "Open Web UI"

**Install HACS:**
```bash
wget -O - https://get.hacs.xyz | bash -
```

- [ ] Restart Home Assistant (Settings → System → Restart)
- [ ] After restart, go to Settings → Devices & Services
- [ ] Click "+ Add Integration"
- [ ] Search for "HACS"
- [ ] Follow GitHub authorization steps
- [ ] HACS is now installed

### Step 6: Add Sonos Speakers

- [ ] Go to Settings → Devices & Services
- [ ] Click "+ Add Integration"
- [ ] Search "Sonos"
- [ ] Click "Sonos"
- [ ] It should auto-discover all 10 speakers
- [ ] Select all speakers you want to add
- [ ] Click "Submit"
- [ ] Name each speaker properly (Living Room, Bedroom, etc.)

**Sonos Features:**
- Play/pause/skip
- Volume control
- Group speakers together
- Source selection
- TTS (text-to-speech announcements)

### Step 7: Add Nest Cameras

**Option 1: Via Google (Recommended)**
- [ ] Go to Settings → Devices & Services
- [ ] Click "+ Add Integration"
- [ ] Search "Google Nest"
- [ ] Click it
- [ ] Log in with your Google account
- [ ] Authorize Home Assistant
- [ ] Select your 5 cameras
- [ ] They'll appear as camera entities

**What you get:**
- Live camera feeds
- Motion detection
- Alerts
- Recording (if Nest Aware subscription)

### Step 8: Add Tesla Model Y

**Install Tesla Custom Integration via HACS:**
- [ ] Go to HACS → Integrations
- [ ] Click "+ Explore & Download Repositories"
- [ ] Search "Tesla Custom Integration"
- [ ] Click "Download"
- [ ] Restart Home Assistant

**Add Your Tesla:**
- [ ] Settings → Devices & Services
- [ ] Click "+ Add Integration"
- [ ] Search "Tesla Custom Integration"
- [ ] Enter your Tesla account email/password
- [ ] Your Model Y should appear

**Tesla Controls:**
- Climate control (heat/cool)
- Door lock/unlock
- Charging start/stop
- Battery level
- Range
- Location
- Sentry mode

### Step 9: Add Cupra Born

**Install Volkswagen We Connect:**
- [ ] HACS → Integrations
- [ ] Search "Volkswagen We Connect ID"
- [ ] Download
- [ ] Restart
- [ ] Add integration
- [ ] Login with Cupra/VW credentials
- [ ] Select Cupra Born

**Cupra Controls:**
- Battery level
- Charging status
- Range
- Climate control
- Door lock status

### Step 10: Add Easee Charger

- [ ] Settings → Devices & Services
- [ ] "+ Add Integration"
- [ ] Search "Easee"
- [ ] Login with Easee account
- [ ] Your charger appears

**Easee Controls:**
- Start/stop charging
- Set charging current
- Schedule charging
- Monitor energy usage
- See charging statistics

### Step 11: Create Your First Dashboard

- [ ] Click "Overview" (home icon)
- [ ] Click three dots → "Edit Dashboard"
- [ ] Click "+ Add Card"

**Essential Cards to Add:**

**Weather Card:**
- [ ] Search "Weather"
- [ ] Select "Weather Forecast"
- [ ] Configure for your location

**Media Control Card:**
- [ ] Add "Media Control" card
- [ ] Select a Sonos speaker
- [ ] Repeat for other main speakers

**Camera Cards:**
- [ ] Add "Picture Glance" card for each camera
- [ ] Shows live feed with tap to open

**Tesla Card:**
- [ ] Add "Entities" card
- [ ] Add Tesla battery level
- [ ] Add Tesla range
- [ ] Add Tesla location

**Cupra Card:**
- [ ] Same as Tesla
- [ ] Battery, range, charging status

**Easee Charger Card:**
- [ ] Add "Entities" card
- [ ] Show charging status
- [ ] Show power usage
- [ ] Add toggle for start/stop

### Step 12: Create Your First Automation

**Example: "Welcome Home" Automation**

- [ ] Go to Settings → Automations & Scenes
- [ ] Click "Create Automation"
- [ ] Click "Start with an empty automation"

**Trigger:**
- [ ] Click "+ Add Trigger"
- [ ] Type: Zone
- [ ] Zone: Home
- [ ] Event: Enter
- [ ] Person: You

**Actions:**
- [ ] "+ Add Action"
- [ ] Action type: Call Service
- [ ] Service: `light.turn_on`
- [ ] Target: Your lights
- [ ] Save

Now when you arrive home, lights turn on automatically!

### Step 13: More Automation Ideas

**Leaving Home:**
- Trigger: Everyone leaves home
- Actions:
  - Turn off all lights
  - Set cameras to away mode
  - Adjust thermostat
  - Lock doors (if smart locks)

**Bedtime:**
- Trigger: 11 PM (or button press)
- Actions:
  - Turn off all lights
  - Stop all Sonos speakers
  - Lock doors
  - Lower heating
  - Set cameras to night mode

**Cheap Electricity Charging:**
- Trigger: Time (when electricity is cheap)
- Actions:
  - Start Easee charger
  - Send notification
  - Stop at 6 AM

**Motion Lights:**
- Trigger: Motion detected (camera or sensor)
- Condition: Sun is down
- Action: Turn on nearby lights for 5 minutes

**Morning Routine:**
- Trigger: Alarm goes off (or time)
- Actions:
  - Gradually turn on bedroom lights
  - Start coffee maker (if smart plug)
  - Play news on Sonos
  - Preheat Tesla/Cupra

### Step 14: Install Useful Integrations

Via HACS, install these popular integrations:

**Alexa Media Player** (if you have Alexa):
- Control Alexa devices
- Send TTS notifications

**Spotify:**
- Control Spotify on Sonos
- See what's playing

**WAZE Travel Time:**
- Commute time notifications
- EV charging based on travel time

**Frigate** (if you want local camera AI):
- Person/object detection
- Better than Nest AI
- Works with your existing cameras

## Mobile App Setup

### Install Home Assistant App
- [ ] Download from Play Store/App Store
- [ ] Open app
- [ ] Scan QR code OR enter: http://TAILSCALE_IP:8123
- [ ] Login with your account
- [ ] Grant location permissions (for presence detection)
- [ ] Enable notifications

### Mobile App Features
- **Presence detection:** Knows when you're home
- **Actionable notifications:** "Garage open - close it?" with button
- **Quick actions:** Widgets for common controls
- **Camera viewing:** See all cameras in one app
- **Voice control:** "Hey Google, turn on living room lights" (via HA)

## Advanced: Node-RED Integration

For complex automations, use Node-RED:
- [ ] Open Node-RED: http://localhost:1880
- [ ] Install Home Assistant nodes
- [ ] Create visual automation flows

## Tips

**Start Simple:**
- Don't try to automate everything at once
- Start with lights, then add more

**Test Automations:**
- Use the "Run Actions" button to test without waiting for triggers

**Backup Configuration:**
- Settings → System → Backups
- Create backup weekly
- Download to safe location

**Voice Control:**
- Integrate with Google Home or Alexa
- "Hey Google, start charging the Cupra"
- "Alexa, play music in the kitchen"

**Energy Dashboard:**
- Settings → Energy
- Add your chargers
- Track EV charging costs
- See solar production (if you add solar)

## Troubleshooting

**Device not discovered:**
- Ensure device and Mac are on same network
- Check device manufacturer's HA integration docs
- May need to add manually with IP address

**Automation not triggering:**
- Check automation state (ON/OFF toggle)
- View automation traces to see what happened
- Check trigger conditions

**Slow interface:**
- Clear browser cache
- Use Chrome/Edge (not Safari)
- Check CPU usage in Portainer

## ✅ Verification

- [ ] Can log in to Home Assistant
- [ ] Sonos speakers added and controllable
- [ ] Nest cameras visible
- [ ] Tesla added with controls
- [ ] Cupra added with controls
- [ ] Easee charger controllable
- [ ] Created at least one automation
- [ ] Mobile app installed and working

## Next Steps

→ [Node-RED](24-Node-RED.md) for advanced automations  
→ [ESPHome](25-ESPHome.md) for DIY sensors  
→ Explore HACS for custom integrations

---

**This is your smart home brain. Spend time here - it's worth it!**

