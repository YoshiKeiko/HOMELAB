---
title: Agent DVR Setup with Tapo C310
tags: [homelab, docker, surveillance, camera, agent-dvr, tapo]
created: 2025-11-26
type: homelab-guide
---

# Agent DVR Setup with Tapo C310

**Self-hosted video surveillance for your Tapo C310 camera**

## Quick Links

- [[Day-04-Docker-Infrastructure|Docker Setup Guide]]
- [[Home Assistant]] (optional integration)
- Agent DVR UI: http://192.168.50.50:8099

---

## Prerequisites

- [ ] OrbStack/Docker running on M4
- [ ] Tapo C310 camera on network
- [ ] Tapo app installed on phone
- [ ] 1Password ready for credentials

---

## Part 1: Prepare Your Tapo C310 Camera

### Create Camera Account (Required for RTSP)

1. [ ] Open **Tapo app** on your phone
2. [ ] Tap your **C310 camera** → gear icon (⚙️)
3. [ ] Go to **Advanced Settings** → **Camera Account**
4. [ ] Tap **Understand and Agree to Use**
5. [ ] Create credentials:
   - **Username**: e.g., `agentdvr`
   - **Password**: 6-32 characters
6. [ ] **Store in 1Password immediately!**

### Set Video Quality in Tapo App

1. [ ] Camera Settings → Video Quality
2. [ ] Select **3K 5MP (2880x1620)** for best quality
3. [ ] Frame rate: **25fps**

### Find Camera IP Address

**From Tapo App:**
- Camera → Settings → Device Info → IP Address

**Camera IP:** `192.168.50.71`

---

## Part 2: Deploy Agent DVR

### Step 1: Create Directories

```bash
mkdir -p ~/HomeLab/Docker/Data/agent-dvr/{config,media,commands}
mkdir -p /Volumes/HomeLab-4TB/AgentDVR/media
```

### Step 2: Create Docker Compose File

```bash
cat > ~/HomeLab/Docker/Compose/agent-dvr.yml << 'EOF'
services:
  agent-dvr:
    image: mekayelanik/ispyagentdvr:latest
    container_name: agent-dvr
    restart: unless-stopped
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
      - AGENTDVR_WEBUI_PORT=8099
    ports:
      - "8099:8099"
      - "3478:3478/udp"
      - "50000-50010:50000-50010/udp"
    volumes:
      - ~/HomeLab/Docker/Data/agent-dvr/config:/AgentDVR/Media/XML
      - /Volumes/HomeLab-4TB/AgentDVR/media:/AgentDVR/Media/WebServerRoot/Media
      - ~/HomeLab/Docker/Data/agent-dvr/commands:/AgentDVR/Commands
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8099 || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 90s

networks:
  default:
    name: homelab
    external: true
EOF
```

### Step 3: Deploy

```bash
cd ~/HomeLab/Docker/Compose
docker network create homelab 2>/dev/null || true
docker compose -f agent-dvr.yml up -d
```

### Step 4: Verify

```bash
docker ps | grep agent-dvr
docker logs -f agent-dvr
```

Open: **http://192.168.50.50:8099**

> **Note:** ARM processors may need 30-60 seconds to fully start. Refresh the page a few times if needed.

---

## Part 3: Configure Tapo C310 in Agent DVR

### Add Camera

1. [ ] Click **Server Menu** (☰) → **Add Device** → **Video Source**
2. [ ] Name: `C310 Hallway`
3. [ ] Location: `Home` | Group: `Indoor`
4. [ ] Click **OK**

### Configure Video Source

1. [ ] Click **wrench icon** (🔧) on camera tile
2. [ ] **Source Type**: `FFmpeg`

### Video Source Tab Settings

| Setting | Value |
|---------|-------|
| Username | *(leave blank - include in URL)* |
| Password | *(leave blank - include in URL)* |
| Live URL | `rtsp://agentdvr:PASSWORD@192.168.50.71:554/stream1` |
| Record URL | `rtsp://agentdvr:PASSWORD@192.168.50.71:554/stream1` |
| Use HD Stream | `None` |

### FFMPEG Tab Settings

| Setting | Value |
|---------|-------|
| Prefer TCP | ON ✓ |
| Auto Switch | ON ✓ |
| Low Delay | ON ✓ |
| Find Best Stream | ON ✓ |

**Options box:**
```
-rtsp_transport tcp
-vf yadif=1:1
```

The `-vf yadif=1:1` fixes interlacing/jagged lines on the video.

---

## Part 4: Recording Settings

### Recording Tab

| Setting | Value |
|---------|-------|
| Mode | `Detect` (records on motion) |
| Encoder | `Encode` or `GPU Encode` (for timestamps) |
| Max Record Time | `300` (5 min segments) |
| Min Record Time | `15` |
| Inactivity Timeout | `8` |
| Buffer | `10` (captures 10 sec before motion) |
| Max Framerate | `25` |

### Advanced Settings

| Setting | Value |
|---------|-------|
| Codec | `Default` |
| Adaptive Framerate | `1` |
| Save Thumbnails | ON ✓ |
| Reduce | `Native` (full resolution) |

---

## Part 5: Timestamp Overlay

For timestamps to appear on recordings, Encoder must be set to `Encode` or `GPU Encode` (not Raw Record).

### Timestamp Settings

| Setting | Value |
|---------|-------|
| Formatter | `{0:dd/MM/yyyy HH:mm:ss}` |
| Position | `Top Left` |
| Text Color | White |
| Font Size | `30` |
| Outline Color | Black |
| Outline Size | `2` |
| Show Background | ON ✓ |
| Opacity | `7` |

---

## Part 6: Motion Detection

### Detector Tab

| Setting | Value |
|---------|-------|
| Detector | `Simple` |
| Overlay | ON ✓ |
| Timeout | `3` |
| Sensitivity | `70-80` |

Click the **gear icon** (⚙️) next to "Simple" for more sensitivity options.

---

## Part 7: Storage Settings

### Camera Storage (per camera)

| Setting | Value |
|---------|-------|
| Location | `/AgentDVR/Media/WebServerRoot/Media/` |
| Max Size | `500000` MB (500GB) |
| Max Age | `720` hours (30 days) |

### Server Storage Settings

**Server Menu** (☰) → **Settings** → **Storage**

Enable storage management and set global limits.

---

## Troubleshooting

### Camera Won't Connect

```bash
# Test RTSP directly
docker exec -it agent-dvr ffmpeg -rtsp_transport tcp -i "rtsp://user:pass@192.168.50.71:554/stream1" -frames:v 1 -f null -
```

### Jagged/Interlaced Video

Add to FFMPEG Options:
```
-vf yadif=1:1
```

### Low FPS (showing 10 instead of 25)

1. Check Tapo app → Video Quality → 25fps
2. Recording tab → Max Framerate → `25` or `0`
3. General tab → Max Framerate → `0` (unlimited)

### Fuzzy/Low Quality

- Use `stream1` not `stream2`
- Put full HD URL in both Live URL and Record URL
- Set Use HD Stream to `None`
- Tapo app → Video Quality → **3K 5MP**

### Timestamps Not on Recordings

Change Encoder from `Raw Record` to `Encode` or `GPU Encode`

### Test Stream with VLC

```bash
/Applications/VLC.app/Contents/MacOS/VLC "rtsp://agentdvr:PASSWORD@192.168.50.71:554/stream1"
```

---

## Container Management

```bash
# Start
docker compose -f ~/HomeLab/Docker/Compose/agent-dvr.yml up -d

# Stop
docker compose -f ~/HomeLab/Docker/Compose/agent-dvr.yml down

# View logs
docker logs -f agent-dvr

# Restart
docker compose -f ~/HomeLab/Docker/Compose/agent-dvr.yml restart

# Update to latest image
docker compose -f ~/HomeLab/Docker/Compose/agent-dvr.yml pull
docker compose -f ~/HomeLab/Docker/Compose/agent-dvr.yml up -d
```

---

## Quick Reference

| Item | Value |
|------|-------|
| Web UI | http://192.168.50.50:8099 |
| Camera IP | 192.168.50.71 |
| RTSP HQ | `rtsp://user:pass@192.168.50.71:554/stream1` |
| RTSP LQ | `rtsp://user:pass@192.168.50.71:554/stream2` |
| Config | `~/HomeLab/Docker/Data/agent-dvr/config` |
| Recordings | `/Volumes/HomeLab-4TB/AgentDVR/media` |
| Docker Image | `mekayelanik/ispyagentdvr:latest` |
| Container | `agent-dvr` |
| Port | `8099` |

---

## 1Password Entry

Create "Agent DVR - Tapo C310":
- Camera RTSP Username: `agentdvr`
- Camera RTSP Password: `[from 1Password]`
- Camera IP: `192.168.50.71`
- RTSP URL: `rtsp://agentdvr:PASSWORD@192.168.50.71:554/stream1`
- Agent DVR URL: `http://192.168.50.50:8099`

---

*Last Updated: 2025-11-26*
