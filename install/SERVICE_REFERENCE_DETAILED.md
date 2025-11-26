# 🏠 HomeLab Complete Service Reference
## With Detailed Explanations for Every Service

**Last Updated:** Mon 17 Nov 2025 10:52:00 GMT  
**Total Services:** 47  
**Tailscale IP:** 100.96.129.29

---

## 🚀 Quick Navigation

[Core](#core) | [Media](#media) | [AI](#ai) | [Smart Home](#smart-home) | [Monitoring](#monitoring) | [Storage](#storage) | [Security](#security) | [Dashboards](#dashboards) | [Utilities](#utilities)

---

<a name="core"></a>
## 🔧 Core Infrastructure

### Portainer
- **URL:** [http://localhost:9000](http://localhost:9000)
- **Remote:** [http://100.96.129.29:9000](http://100.96.129.29:9000)

**What it is:** A comprehensive web-based management tool for Docker containers. Think of it as Mission Control for your entire homelab.

**What it does:**
- View all 47 containers at a glance with status, uptime, and resource usage
- Start, stop, restart services with one click
- View real-time logs without command line
- Monitor CPU, memory, and network usage per container
- Execute commands inside containers
- Manage Docker networks, volumes, and images

**Why you need it:** Managing 47 services via command line would be painful. Portainer makes it visual, intuitive, and fast. Essential for troubleshooting when something goes wrong.

**Pro tip:** Bookmark this - you'll use it constantly!

---

### Watchtower
- **No web interface** (runs automatically)

**What it is:** Your personal system administrator that keeps everything up-to-date while you sleep.

**What it does:**
- Checks for new Docker image versions every night at 4 AM
- Automatically pulls updates and restarts containers
- Cleans up old images to save disk space
- Sends notifications (if configured)
- Maintains your service uptime during updates

**Why you need it:** Security patches and bug fixes happen constantly. Watchtower ensures you're always running the latest, most secure versions without lifting a finger.

**Pro tip:** It runs silently in the background - just check Portainer logs occasionally to see what it updated.

---

<a name="media"></a>
## 🎬 Media Services

### Plex Media Server
- **URL:** [http://localhost:32400/web](http://localhost:32400/web)
- **Remote:** [http://100.96.129.29:32400/web](http://100.96.129.29:32400/web)

**What it is:** Your personal Netflix. A professional-grade media server that turns your media collection into a streaming service.

**What it does:**
- Organizes movies, TV shows, music, and photos with beautiful artwork
- Automatically downloads posters, plot summaries, cast info, ratings
- Transcodes video in real-time for any device (phone,tablet, TV, browser)
- Remembers what you've watched and where you stopped
- Provides Continue Watching, Recently Added, and recommendations
- Works on 1000+ devices including Samsung TV, Apple TV, Roku, Fire TV
- Streams remotely with automatic quality adjustment
- Supports multiple users with individual watch histories

**Why you need it:** Stop juggling files and folders. Get a proper streaming experience with your own content. Works better than many paid streaming services.

**Setup notes:** Sign in with a free Plex account. Point it to your media folder. It handles the rest.

---

### Jellyfin
- **URL:** [http://localhost:8096](http://localhost:8096)
- **Remote:** [http://100.96.129.29:8096](http://100.96.129.29:8096)

**What it is:** 100% free and open-source alternative to Plex. No account required, no premium features, no telemetry.

**What it does:**
Everything Plex does, but:
- No internet connection required for streaming
- No account/login needed
- Supports more video codecs natively (AV1, HEVC, etc.)
- No phone home to company servers
- Completely customizable
- Active open-source development community

**Why you need it:** 
- Backup if Plex servers go down
- Better codec support
- Privacy-focused (no data sent to external servers)
- Great for testing without affecting Plex

**Pro tip:** Use Plex as primary, Jellyfin as backup. Both read from the same media folder.

---

### Radarr
- **URL:** [http://localhost:7878](http://localhost:7878)
- **Remote:** [http://100.96.129.29:7878](http://100.96.129.29:7878)

**What it is:** Automated movie collection manager. Like having a personal assistant who knows when movies you want become available.

**What it does:**
- Tracks movies you want to watch (via watchlist or manual add)
- Monitors release dates for upcoming films
- Automatically searches when movies become available
- Filters by quality (4K, 1080p, 720p) and file size
- Sends torrents to Transmission automatically
- Renames files to proper format: "Movie Name (Year).mkv"
- Tells Plex/Jellyfin to scan when download completes
- Can upgrade quality automatically (720p → 1080p → 4K)

**Why you need it:** Add a movie to your list, go to sleep, wake up to find it in Plex. Completely automated cinema.

**Setup:** Connect to Prowlarr (for searches), Transmission (for downloads), and Plex (for notifications).

---

### Sonarr
- **URL:** [http://localhost:8989](http://localhost:8989)
- **Remote:** [http://100.96.129.29:8989](http://100.96.129.29:8989)

**What it is:** Like Radarr, but specifically designed for TV shows with episode and season tracking.

**What it does:**
- Tracks TV shows and monitors for new episodes
- Automatically downloads new episodes as they air (usually within hours)
- Handles season packs vs. individual episodes
- Manages daily shows, anime, and standard series differently
- Tracks what you've watched (syncs with Plex)
- Renames episodes: "Show Name - S01E01 - Episode Title.mkv"
- Can backfill missing episodes from earlier seasons
- Handles series with multiple seasons gracefully

**Why you need it:** Never miss an episode. Add a show once, and every episode appears in Plex automatically forever.

**Pro tip:** Combine with Overseerr so family can request shows without accessing Sonarr directly.

---

### Prowlarr
- **URL:** [http://localhost:9696](http://localhost:9696)
- **Remote:** [http://100.96.129.29:9696](http://100.96.129.29:9696)

**What it is:** Centralized indexer manager. The master control for where Radarr/Sonarr search for content.

**What it does:**
- Manages "indexers" (websites that index torrents/newsgroups)
- Configure once, syncs to Radarr, Sonarr, and other *arr apps
- Tests indexers to verify they're working
- Tracks statistics (searches, grabs, failures)
- Can ban bad indexers automatically
- Supports Usenet and torrent indexers
- Flaresolverr integration for Cloudflare-protected sites

**Why you need it:** Without Prowlarr, you'd configure 10+ indexers in Radarr, then again in Sonarr, then again if you add more apps. With Prowlarr, configure once.

**Setup:** Add your indexers here first, then connect Radarr/Sonarr to Prowlarr.

---

### Overseerr
- **URL:** [http://localhost:5055](http://localhost:5055)
- **Remote:** [http://100.96.129.29:5055](http://100.96.129.29:5055)

**What it is:** A gorgeous, Netflix-style interface for requesting content. Your family's favorite app.

**What it does:**
- Beautiful discovery interface (like Netflix browse page)
- Shows what's already available in Plex
- Lets users request movies/shows they want
- Sends requests directly to Radarr/Sonarr
- Tracks request status (pending, approved, downloading, available)
- Sends notifications when requested content is ready
- Can require approval for requests (or auto-approve trusted users)
- Shows trailers, ratings, cast info
- User management with permission levels

**Why you need it:** 
- Non-technical family members can request content easily
- Keeps people out of Radarr/Sonarr (where they might break things)
- Looks professional and polished
- Makes sharing your media server feel like a real service

**Setup:** Connect to Plex (to show existing content) and Radarr/Sonarr (to send requests).

---

### Transmission
- **URL:** [http://localhost:9091](http://localhost:9091)
- **Remote:** [http://100.96.129.29:9091](http://100.96.129.29:9091)

**What it is:** Lightweight, efficient BitTorrent client. The workhorse that actually downloads your media.

**What it does:**
- Downloads torrents sent by Radarr/Sonarr
- Manages download queue (max active torrents)
- Throttles bandwidth (so it doesn't kill your internet)
- Seeds torrents to maintain ratio
- Web interface for monitoring progress
- Can pause/resume downloads
- Watches folder for .torrent files
- Integrates perfectly with *arr apps

**Why you need it:** Radarr and Sonarr are the brains, Transmission is the muscle. Simple, reliable, gets the job done.

**Pro tip:** Set download/upload speed limits so it doesn't affect your other internet usage.

---

<a name="ai"></a>
## 🤖 AI & Development

### OpenWebUI
- **URL:** [http://localhost:3000](http://localhost:3000)
- **Remote:** [http://100.96.129.29:3000](http://100.96.129.29:3000)

**What it is:** Beautiful ChatGPT-style interface for running AI models locally on your Mac. No OpenAI subscription needed.

**What it does:**
- Chat with AI models (Llama, Mistral, etc.) completely offline
- Multiple conversations/chats with history
- Code syntax highlighting for programming questions
- Upload documents and ask questions about them
- Generate images (with appropriate models)
- Create custom prompts and templates
- Share conversations
- No data sent to external servers - completely private

**Why you need it:**
- Free unlimited AI chat (no ChatGPT subscription)
- Privacy - your conversations stay on your Mac
- Works offline
- Can run uncensored models
- Use for coding help, writing, research, brainstorming

**Setup:** It's already connected to Ollama. Just download models and start chatting.

**Models to try:** `llama3.2` (fast), `mistral` (smart), `codellama` (coding), `llava` (vision)

---

### Ollama
- **API:** [http://localhost:11434](http://localhost:11434)
- **Remote:** [http://100.96.129.29:11434](http://100.96.129.29:11434)

**What it is:** The engine that runs AI models on your Mac. Like having GPT-4 running locally.

**What it does:**
- Downloads and runs large language models (LLMs)
- Provides API that OpenWebUI connects to
- Manages model storage and loading
- Optimizes for Mac M4 chip (fast!)
- Can run multiple models
- Streams responses in real-time

**Download models:**
```bash
docker exec ollama ollama pull llama3.2
docker exec ollama ollama pull mistral
docker exec ollama ollama pull codellama
```

**Why you need it:** Powers OpenWebUI. Without Ollama, OpenWebUI is just an empty shell.

---

### Code Server (VS Code)
- **URL:** [http://localhost:8443](http://localhost:8443)
- **Remote:** [http://100.96.129.29:8443](http://100.96.129.29:8443)
- **Password:** `changeme` ⚠️ **CHANGE THIS!**

**What it is:** Full Visual Studio Code running in your browser. Same editor Microsoft makes, but accessible from anywhere.

**What it does:**
- Complete VS Code experience (extensions, themes, settings)
- Edit code from any device (even your phone or iPad)
- Terminal access built-in
- Git integration
- Can open folders from your Mac
- All extensions from VS Code marketplace work
- Multiple file tabs, split panes, everything

**Why you need it:**
- Code from your iPad on the couch
- Access your development environment remotely
- No need to install VS Code on every device
- Great for quick edits when you're away from your desk

**Pro tip:** Access via Tailscale on your phone to fix bugs while traveling!

---

### Jupyter Notebook
- **URL:** [http://localhost:8888](http://localhost:8888)
- **Remote:** [http://100.96.129.29:8888](http://100.96.129.29:8888)

**What it is:** Interactive Python environment for data science, machine learning, and experimentation.

**What it does:**
- Run Python code in interactive cells
- Mix code, visualizations, and markdown notes
- Create data analysis reports
- Test machine learning models
- Generate charts and graphs inline
- Share notebooks as documents
- Comes with scientific libraries (pandas, numpy, matplotlib, scikit-learn)

**Why you need it:** Perfect for Python learning, data analysis, or AI experiments. Much better than running Python scripts.

**Get token:** `docker logs jupyter` - look for the login token

---

### Gitea
- **URL:** [http://localhost:3001](http://localhost:3001)
- **Remote:** [http://100.96.129.29:3001](http://100.96.129.29:3001)
- **SSH:** Port 2222

**What it is:** Self-hosted GitHub. Your private Git server for code.

**What it does:**
- Host unlimited private repositories
- Web interface like GitHub
- Issue tracking
- Pull requests and code review
- Organizations and teams
- Wikis for documentation
- SSH and HTTPS git access
- Webhooks for CI/CD

**Why you need it:**
- Keep personal projects private
- No GitHub/GitLab subscription needed
- Full control over your code
- Great for homelab infrastructure-as-code

**Pro tip:** Store all your homelab scripts and configs here!

---

<a name="smart-home"></a>
## 🏠 Smart Home

### Home Assistant
- **URL:** [http://localhost:8123](http://localhost:8123)
- **Remote:** [http://100.96.129.29:8123](http://100.96.129.29:8123)

**What it is:** The brain of your smart home. Connects and controls everything - Sonos, Nest cameras, Tesla, EV chargers, lights, thermostats, everything.

**What it does:**
- Discovers and connects to 2000+ smart home brands automatically
- Creates unified dashboard for all devices
- Complex automations ("when X happens, do Y and Z")
- Location awareness (knows when you're home)
- Voice control integration (Alexa, Google Home)
- Schedules and timers
- Presence detection
- Energy monitoring
- Custom dashboards for tablets/wall displays

**Your devices it can control:**
- 10 Sonos speakers - group them, control volume, play music
- 5 Nest cameras - view feeds, motion detection
- Tesla Model Y - check charge, climate control, lock/unlock
- Cupra Born EV - same as Tesla
- Easee charger - start/stop charging, set schedules
- Plus any future smart devices you add

**Automations you can create:**
- "Arrive home → turn on lights, start music"
- "Everyone leaves → turn off everything, arm cameras"
- "Bedtime → lock doors, turn off lights, lower heat"
- "Electricity cheap → charge EVs"
- "Motion detected → turn on lights, send notification"

**Why you need it:** Makes all your smart devices work together instead of 10 separate apps.

**Setup:** Spend an afternoon adding devices. Create automations. Thank yourself forever.

---

### Node-RED
- **URL:** [http://localhost:1880](http://localhost:1880)
- **Remote:** [http://100.96.129.29:1880](http://100.96.129.29:1880)

**What it is:** Visual programming for smart home automations. Drag-and-drop automation builder.

**What it does:**
- Creates complex automations visually (no coding)
- Connects Home Assistant to other services
- Can trigger on webhooks, timers, device states
- Sends notifications (Pushover, Telegram, email)
- Makes HTTP requests to APIs
- Processes data (if/then/else logic)
- Stores data in databases
- Generates graphs and reports

**Why you need it:** Some automations are too complex for Home Assistant alone. Node-RED handles the complex stuff.

**Example use cases:**
- "If electricity price below X, charge EVs and send notification"
- "Count Nest camera motion events, graph daily"
- "Turn off Sonos speakers when nobody's home (detected by phones)"

**Pro tip:** Use Home Assistant for simple automations, Node-RED for complex workflows.

---

### Mosquitto MQTT
- **Port:** 1883 (no web interface)
- **WebSocket:** 9001

**What it is:** Message broker for IoT devices. The postal service for your smart home.

**What it does:**
- Allows devices to publish messages (e.g., "motion detected")
- Other devices subscribe to messages (e.g., light listens for motion)
- Extremely lightweight and fast
- Standard protocol (MQTT) used by tons of devices
- Buffers messages if devices are offline
- Secure with username/password

**Why you need it:** Many smart home devices speak MQTT. Zigbee2MQTT sends all Zigbee device data here. Home Assistant reads it.

**You don't interact with it directly** - it works in the background letting devices talk to each other.

---

### Zigbee2MQTT
- **URL:** [http://localhost:8080](http://localhost:8080)
- **Remote:** [http://100.96.129.29:8080](http://100.96.129.29:8080)
- **Requires:** Zigbee USB adapter

**What it is:** Bridge between Zigbee smart devices and Home Assistant (via MQTT).

**What it does:**
- Connects to Zigbee devices (sensors, lights, switches, plugs)
- Translates Zigbee messages to MQTT
- Allows pairing new Zigbee devices
- Shows device battery levels
- Updates device firmware
- Works with 2000+ Zigbee devices
- No proprietary hub needed (Hue, Tradfri, Aqara all work)

**Why you need it:** Zigbee devices are cheap and reliable. This lets you use them without buying each manufacturer's hub.

**Note:** Requires a Zigbee USB stick ($15-30). ConBee II or Sonoff recommended.

---

### ESPHome
- **URL:** [http://localhost:6052](http://localhost:6052)
- **Remote:** [http://100.96.129.29:6052](http://100.96.129.29:6052)

**What it is:** Tool for creating DIY smart devices with ESP8266/ESP32 chips ($2-5 each).

**What it does:**
- Write device config in YAML
- Compiles firmware automatically
- Uploads to ESP chip over WiFi
- Integrates directly with Home Assistant
- Supports sensors, relays, LEDs, displays, everything
- Updates devices wirelessly

**Why you need it:** Build custom sensors and switches for pennies. Want a temperature sensor in every room? $10 total instead of $200 in commercial sensors.

**DIY projects you can make:**
- Temperature/humidity sensors
- Smart plugs
- Door sensors
- LED light strips
- Garage door opener
- Custom displays

**Pro tip:** Start with a pre-made project, then customize.

---

<a name="monitoring"></a>
## 📊 Monitoring & Logging

### Grafana
- **URL:** [http://localhost:3003](http://localhost:3003)
- **Remote:** [http://100.96.129.29:3003](http://100.96.129.29:3003)
- **Login:** admin / (from credentials file)

**What it is:** Professional-grade monitoring dashboards. See everything about your homelab in beautiful graphs.

**What it does:**
- Creates stunning visualizations from your data
- Real-time monitoring of all services
- Historical graphs (CPU, memory, disk, network)
- Alerts when things go wrong (email, Slack, Discord)
- Templates for common dashboards
- Multiple data sources (Prometheus, InfluxDB, Loki)
- Share dashboards with others
- Dark/light themes

**Dashboards you should create:**
- System resources (CPU, RAM, disk)
- Docker container stats
- Network traffic
- Service uptime
- Smart home device status
- EV charging costs

**Why you need it:** See problems before they become critical. Track long-term trends. Impress yourself with how professional it looks.

**Pro tip:** Import community dashboards instead of building from scratch.

---

### Prometheus
- **URL:** [http://localhost:9090](http://localhost:9090)
- **Remote:** [http://100.96.129.29:9090](http://100.96.129.29:9090)

**What it is:** Metrics collection system. Constantly asks every service "how are you doing?" and remembers the answers.

**What it does:**
- Scrapes metrics from services every 15 seconds
- Stores time-series data efficiently
- Powers Grafana's graphs
- Can query metrics with PromQL language
- Built-in alerting rules
- Service discovery (finds new containers automatically)

**Why you need it:** Grafana shows pretty graphs. Prometheus is what collects the data for those graphs.

**You'll rarely use the Prometheus UI directly** - Grafana is the interface. But it's essential infrastructure.

---

### Loki
- **URL:** [http://localhost:3100](http://localhost:3100)
- **Remote:** [http://100.96.129.29:3100](http://100.96.129.29:3100)

**What it is:** Log aggregation system. Like Prometheus, but for logs instead of metrics.

**What it does:**
- Collects logs from all Docker containers
- Stores logs efficiently (compressed)
- Powers Grafana's log viewer
- Can search logs across all services
- Filter by container, time, keywords
- Correlate logs with metrics

**Why you need it:** When something breaks, you need logs. Loki collects them all in one place so you can debug through Grafana instead of running `docker logs` 47 times.

**Pro tip:** In Grafana, split screen with metrics on top, logs on bottom. See exactly what happened when.

---

### Uptime Kuma
- **URL:** [http://localhost:3004](http://localhost:3004)
- **Remote:** [http://100.96.129.29:3004](http://100.96.129.29:3004)

**What it is:** Beautiful uptime monitoring. Checks if your services are alive and alerts you if they're not.

**What it does:**
- Pings services every minute to check if they're up
- Checks HTTP status codes
- Can check TCP ports
- Monitors response time
- Creates status pages (public or private)
- Sends alerts (email, Discord, Telegram, SMS, 90+ methods)
- Shows uptime percentage
- Beautiful interface

**Why you need it:** Know immediately when a service goes down. See uptime history. Create a status page to share.

**Setup:** Add each of your 47 services with their URL. Get notifications when things break.

**Pro tip:** Check it daily - you'll catch issues before you notice them affecting you.

---

### Netdata
- **URL:** [http://localhost:19999](http://localhost:19999)
- **Remote:** [http://100.96.129.29:19999](http://100.96.129.29:19999)

**What it is:** Real-time system monitoring dashboard. Every metric, every second, no configuration.

**What it does:**
- Monitors EVERYTHING about your Mac (1000+ metrics)
- Updates every second (real-time)
- CPU per core, per process
- Memory breakdown by application
- Disk I/O, network traffic, everything
- Container-specific metrics
- Zero configuration - works out of the box
- Beautiful, fast interface

**Why you need it:** When something's wrong RIGHT NOW, Netdata shows you what. Grafana shows trends over time, Netdata shows this exact second.

**Use case:** "Mac feels slow" → open Netdata → see which container is using 90% CPU → fix it

---

### cAdvisor
- **URL:** [http://localhost:8085](http://localhost:8085)
- **Remote:** [http://100.96.129.29:8085](http://100.96.129.29:8085)

**What it is:** Container resource monitoring. Shows exactly what each Docker container is doing.

**What it does:**
- Tracks CPU, memory, network, disk per container
- Historical graphs (last hour)
- Can compare containers
- Feeds data to Prometheus
- Shows container isolation metrics

**Why you need it:** Figure out which of your 47 containers is hogging resources.

**Pro tip:** Usually view this data in Grafana, but the direct UI is useful for quick checks.

---

### Node Exporter
- **Port:** 9100 (metrics endpoint at /metrics)

**What it is:** System metrics exporter for Prometheus. Makes your Mac's stats available to Prometheus.

**What it does:**
- Exposes system metrics (CPU, RAM, disk, network)
- Prometheus scrapes these metrics
- No web UI - just an endpoint with data
- Lightweight background service

**Why you need it:** Without this, Prometheus can't see your Mac's resource usage.

---

### Promtail
- **No web interface**

**What it is:** Log shipper. Sends Docker container logs to Loki.

**What it does:**
- Watches Docker logs in real-time
- Parses and labels log entries
- Ships them to Loki
- Adds metadata (container name, host, etc.)

**Why you need it:** Without Promtail, Loki has no logs to store.

---

<a name="storage"></a>
## 💾 Storage & Backup

### Nextcloud
- **URL:** [http://localhost:8097](http://localhost:8097) *(custom port)*
- **Remote:** [http://100.96.129.29:8097](http://100.96.129.29:8097)
- **Login:** admin / (from credentials file)

**What it is:** Your private Dropbox/Google Drive. Cloud storage that you control.

**What it does:**
- File storage and sync across devices
- Calendar and contacts sync
- Photo auto-upload from phone
- Document collaboration (online editing)
- Video calls
- Tasks and notes
- Music streaming
- News/RSS reader
- 100+ apps to extend functionality
- Desktop/mobile clients available
- Share files with others (with passwords/expiration)

**Why you need it:**
- Stop paying Google/Dropbox/iCloud
- Unlimited storage (limited only by your disk)
- Complete privacy
- Access files from anywhere via Tailscale
- Automatic phone photo backup

**Apps to install:**
- Desktop client (sync files)
- Android/iOS app (auto-upload photos)

---

### Syncthing
- **URL:** [http://localhost:8384](http://localhost:8384)
- **Remote:** [http://100.96.129.29:8384](http://100.96.129.29:8384)

**What it is:** Peer-to-peer file synchronization. Like Dropbox, but without the cloud - devices sync directly.

**What it does:**
- Syncs folders between devices continuously
- Works Mac ↔ Android, Mac ↔ Linux, any combination
- No central server (devices talk directly)
- Encrypted transfers
- Version history (file versioning)
- Selective sync (ignore certain files)
- Conflict resolution

**Why you need it:** 
- Sync files to phone without Nextcloud
- Backup important folders to other devices
- Keep projects in sync across computers
- Free alternative to cloud sync services

**Use cases:**
- Phone photos → Mac automatically
- Documents folder synced to laptop
- Music folder to phone

---

### Duplicati
- **URL:** [http://localhost:8200](http://localhost:8200)
- **Remote:** [http://100.96.129.29:8200](http://100.96.129.29:8200)

**What it is:** Encrypted backup solution. Backs up your data to external storage or cloud.

**What it does:**
- Encrypted backups (AES-256)
- Incremental backups (only changes)
- Compression (saves space)
- Deduplication (no duplicate data)
- Scheduled backups
- Restore to any point in time
- Backup to: External drive, Google Drive, OneDrive, S3, B2, FTP, many more
- Verify backups automatically
- Email notifications

**Why you need it:** Your homelab data is valuable. Backups protect against:
- Hardware failure
- Accidental deletion
- Ransomware
- Disk corruption

**What to backup:**
- Docker configs
- Nextcloud files
- Home Assistant config
- Paperless documents
- PhotoPrism photos
- Important media

**Pro tip:** 3-2-1 rule: 3 copies, 2 different media types, 1 offsite.

---

### File Browser
- **URL:** [http://localhost:8087](http://localhost:8087)
- **Remote:** [http://100.96.129.29:8087](http://100.96.129.29:8087)
- **Default:** admin / admin ⚠️ **CHANGE THIS!**

**What it is:** Web-based file manager. Like Finder/Explorer but in a browser.

**What it does:**
- Browse all your homelab files
- Upload/download files
- Create/delete/rename files and folders
- Edit text files in browser
- Share files with temporary links
- Search files
- Preview images, videos, documents
- Zip/unzip files
- Multiple user accounts with permissions

**Why you need it:**
- Access files from phone/tablet
- Quick way to upload files when away from Mac
- Share files without Nextcloud
- Manage Docker volumes directly

**Root folder:** Configured to show your entire HomeLab directory.

**Pro tip:** Use via Tailscale to access files when traveling.

---

<a name="security"></a>
## 🔒 Security

### Vaultwarden
- **URL:** [http://localhost:8088](http://localhost:8088)
- **Remote:** [http://100.96.129.29:8088](http://100.96.129.29:8088)

**What it is:** Self-hosted password manager. Open-source Bitwarden server.

**What it does:**
- Stores all passwords encrypted
- Browser extensions (Chrome, Firefox, Safari, Edge)
- Mobile apps (Android, iOS)
- Generates strong passwords
- Auto-fills login forms
- Secure password sharing
- Two-factor authentication
- Checks for breached passwords
- Credit card and identity storage
- Secure notes
- Emergency access

**Why you need it:**
- Stop reusing passwords
- All Bitwarden apps work with it
- Free (Bitwarden premium features included)
- Your data never leaves your server
- Better than 1Password/LastPass

**Setup:**
1. Create account at http://localhost:8088
2. Install browser extension
3. Point extension to your server URL
4. Import passwords from other managers

**Pro tip:** Access via Tailscale works perfectly - you can use it anywhere.

---

### Fail2ban
- **No web interface** (monitors logs)

**What it is:** Intrusion prevention system. Bans IP addresses that show malicious activity.

**What it does:**
- Watches log files for failed login attempts
- After X failures, temporarily bans that IP
- Works with SSH, web servers, any service that logs
- Can ban for hours, days, or permanently
- Email notifications of bans
- Protects against brute force attacks
- Configurable ban rules per service

**Why you need it:** If you expose any services to the internet (even via Tailscale), this protects against attacks.

**It works silently** - you won't notice it unless you check logs or get notification emails.

---

### CrowdSec
- **URL:** [http://localhost:8089](http://localhost:8089)
- **Remote:** [http://100.96.129.29:8089](http://100.96.129.29:8089)

**What it is:** Collaborative security. Like Fail2ban, but smarter and crowd-sourced.

**What it does:**
- Monitors logs for attacks
- Bans malicious IPs automatically
- Shares threat intelligence with other CrowdSec users
- Benefits from global attack data (if someone attacks others, you're protected)
- Machine learning to detect attacks
- Multiple blocklists (bouncers)
- Can integrate with firewall, nginx, etc.

**Why you need it:** More powerful than Fail2ban. Learns from attacks across the internet, not just your server.

**Setup:** Register at crowdsec.net (free) to share/receive threat intelligence.

**Pro tip:** Use both CrowdSec and Fail2ban - they complement each other.

---

<a name="dashboards"></a>
## 🎨 Dashboards

### Heimdall
- **URL:** [http://localhost:8090](http://localhost:8090)
- **Remote:** [http://100.96.129.29:8090](http://100.96.129.29:8090)

**What it is:** Application dashboard. Your homelab homepage. **START HERE!**

**What it does:**
- Displays all your services as tiles
- One-click access to any service
- Automatic icons (finds them for you)
- Status indicators (green = up, red = down)
- Search services by name
- Custom backgrounds
- Tags to organize services
- Multiple users with different dashboards

**Why you need it:** Instead of bookmarking 47 URLs, bookmark this one page. Everything you need at a glance.

**Setup:**
1. Open Heimdall
2. Click gear icon → Add Application
3. Add each service with name and URL
4. Heimdall auto-finds icons

**This should be your browser homepage.**

**Pro tip:** On your phone browser, "Add to Home Screen" for Heimdall - instant homelab access.

---

### Homer
- **URL:** [http://localhost:8091](http://localhost:8091)
- **Remote:** [http://100.96.129.29:8091](http://100.96.129.29:8091)

**What it is:** Static dashboard configured via YAML file. More configurable than Heimdall, less user-friendly.

**What it does:**
- Service organization by category
- Custom colors and icons
- Status checking
- Dark/light themes
- Search functionality
- Lightweight (static HTML)
- Can be themed extensively

**Why you might prefer it over Heimdall:**
- Configuration as code (YAML)
- More visual customization
- Can version control your config
- Slightly faster (no database)

**Note:** Edit config in `/Users/homelab/HomeLab/Docker/Data/homer/assets/config.yml`

---

### Dashy
- **URL:** [http://localhost:4000](http://localhost:4000)
- **Remote:** [http://100.96.129.29:4000](http://100.96.129.29:4000)

**What it is:** Modern, feature-rich dashboard. Most powerful of the three dashboard options.

**What it does:**
- Everything Heimdall and Homer do, plus:
- Widgets (weather, RSS, calendar, system stats)
- Multi-page dashboards
- Icons everywhere
- Customizable CSS
- Service health checks
- Hotkeys for services
- Multiple color schemes
- Mobile-optimized

**Why you might prefer it:**
- Most features
- Looks most modern
- Great on tablets
- Supports widgets

**Trade-off:** Slightly heavier than Heimdall/Homer.

**Choose one dashboard as your main, ignore the others.**

---

### Organizr
- **URL:** [http://localhost:8092](http://localhost:8092)
- **Remote:** [http://100.96.129.29:8092](http://100.96.129.29:8092)

**What it is:** Dashboard with tabs. Access services without leaving the dashboard.

**What it does:**
- Embeds services in iframes
- Tab-based navigation
- Single sign-on (one login for all services)
- User management
- Custom homepage
- Service pings

**Why you might prefer it:**
- Access everything without opening 47 tabs
- Good for tablets mounted on wall
- Cleaner than having services in separate tabs

**Trade-off:** Some services don't work well in iframes.

---

<a name="utilities"></a>
## 🛠️ Utilities

### Paperless-ngx
- **URL:** [http://localhost:8093](http://localhost:8093)
- **Remote:** [http://100.96.129.29:8093](http://100.96.129.29:8093)

**What it is:** Document management system. Scan, OCR, organize, and search all your paper documents.

**What it does:**
- Scans documents (or import PDFs)
- OCR (makes documents searchable)
- Auto-tagging by keywords
- Full-text search
- Organizes by date, tags, correspondents
- Email integration (forward docs to Paperless)
- Duplicate detection
- Document versioning
- Generates thumbnails
- Export to PDF/ZIP

**Why you need it:** Go paperless. Scan receipts, bills, manuals, documents. Never lose important papers again. Find any document in seconds.

**Workflow:**
1. Scan/photograph document with phone
2. Upload to consume folder (or email it)
3. Paperless OCRs and files it automatically
4. Search for it anytime

**Great for:**
- Tax documents
- Receipts
- Warranties and manuals
- Bills and statements
- Contracts
- Medical records

---

### PhotoPrism
- **URL:** [http://localhost:2342](http://localhost:2342)
- **Remote:** [http://100.96.129.29:2342](http://100.96.129.29:2342)
- **Login:** admin / (from credentials file)

**What it is:** AI-powered photo management. Google Photos alternative you control.

**What it does:**
- Organizes photos automatically
- Facial recognition (finds people)
- Object detection ("show me photos with dogs")
- Location tagging (map view)
- Duplicate detection
- RAW image support
- Video support
- Albums and favorites
- Timeline view
- Powerful search ("sunset in 2023")
- Mobile apps available
- Share albums

**Why you need it:**
- Organize lifetime of photos
- Find photos instantly
- Privacy (no Google scanning your photos)
- No storage limits
- Works offline

**Setup:** Point it at your photo folders, let it index. Takes a while initially.

**Pro tip:** Use with Nextcloud auto-upload - photos from phone → Nextcloud → PhotoPrism organizes them

---

### Calibre
- **URL:** [http://localhost:8094](http://localhost:8094)
- **Remote:** [http://100.96.129.29:8094](http://100.96.129.29:8094)

**What it is:** eBook library manager. iTunes for eBooks.

**What it does:**
- Organize eBook collection
- Convert between formats (EPUB, MOBI, PDF, etc.)
- Edit metadata (title, author, cover, etc.)
- Fetch book info from online databases
- Built-in eBook reader
- Sync to eReaders (Kindle, Kobo, etc.)
- Content server (read books in browser)
- Search and filter library
- Send books via email

**Why you need it:**
- Organize hundreds/thousands of eBooks
- Read eBooks on any device
- Convert formats for different readers
- Automatic metadata

**Content Server** on port 8095 lets you read books in browser from any device.

---

### FreshRSS
- **URL:** [http://localhost:8098](http://localhost:8098) *(custom port)*
- **Remote:** [http://100.96.129.29:8098](http://100.96.129.29:8098)

**What it is:** Self-hosted RSS feed reader. Google Reader alternative.

**What it does:**
- Subscribe to RSS feeds (blogs, news sites, podcasts)
- Unified feed of all subscriptions
- Mark as read/unread
- Star important items
- Filter and search
- Categories and folders
- Keyboard shortcuts
- Mobile-optimized interface
- API for mobile apps
- OPML import/export

**Why you need it:**
- Follow blogs without visiting sites
- Get news in one place
- No algorithm deciding what you see
- Works with any RSS feed
- Multiple reading views

**Setup:** Import your feeds (OPML), or subscribe to sites one by one.

**Pro tip:** Works great with mobile RSS apps like Reeder or NetNewsWire via API.

---

## 🗄️ Databases
(Background services - you won't access these directly)

### PostgreSQL
- **Port:** 5432
- Used by: Nextcloud, Paperless-ngx, Home Assistant (optionally)

### MariaDB
- **Port:** 3306
- Used by: PhotoPrism

### MongoDB  
- **Port:** 27017
- Available for any services that need NoSQL

### Redis
- **Port:** 6379
- Used by: Paperless-ngx for caching

### InfluxDB
- **URL:** [http://localhost:8086](http://localhost:8086)
- Time-series database for metrics

---

## 📱 Remote Access

**Via Tailscale** (recommended):
- Your Mac IP: 100.96.129.29
- Access format: `http://100.96.129.29:PORT`
- Works from anywhere (home, work, vacation)
- Encrypted automatically
- No port forwarding needed

**Screen Sharing via VNC:**
- Install VNC Viewer on phone
- Connect to: 100.96.129.29:5900
- Enter Mac VNC password
- Control Mac from anywhere

---

**Total Services: 47**  
**Last Updated: Mon 17 Nov 2025 10:52:00 GMT**  
**Tailscale IP: 100.96.129.29**

---

Need help? Check service logs: `docker logs <container-name>`
