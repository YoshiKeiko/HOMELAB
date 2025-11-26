---
title: Agent DVR & Tapo C310 Setup
tags: [homelab, surveillance, cctv, agent-dvr, tapo]
created: 2025-11-26
updated: 2025-11-26
type: guide
---

# Agent DVR & Tapo C310 Setup

**Complete surveillance setup with motion detection and recording**

---

## Overview

| Component | Detail |
|-----------|--------|
| Software | Agent DVR (iSpyConnect) |
| Camera | Tapo C310 (5MP outdoor) |
| Recording | Motion-triggered + continuous |
| Storage | /Volumes/HomeLab-4TB/AgentDVR |
| Web UI | http://192.168.50.50:8099 |

---

## Docker Deployment

### Compose File Location
`~/HomeLab/Docker/Compose/surveillance.yml`

```yaml
version: '3.8'
services:
  agent-dvr:
    image: mekayelanik/ispyagentdvr:latest
    container_name: agent-dvr
    restart: unless-stopped
    ports:
      - "8099:8090"
      - "3478:3478/udp"
      - "50000-50010:50000-50010/udp"
    environment:
      - TZ=Europe/London
    volumes:
      - ~/HomeLab/Docker/Data/agentdvr/config:/AgentDVR/Media/XML
      - /Volumes/HomeLab-4TB/AgentDVR/media:/AgentDVR/Media/WebServerRoot/Media
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8090"]
      interval: 30s
      timeout: 10s
      retries: 3
```

Deploy:
```bash
docker-compose -f surveillance.yml up -d
```

---

## Tapo C310 Camera Setup

### Get RTSP Credentials

1. Open Tapo app on phone
2. Go to camera settings
3. Advanced Settings → Camera Account
4. Create username/password for RTSP

### RTSP URL Format

```
rtsp://username:password@CAMERA_IP:554/stream1  # Main stream (5MP)
rtsp://username:password@CAMERA_IP:554/stream2  # Sub stream (lower res)
```

### Add Camera to Agent DVR

1. Go to http://192.168.50.50:8099
2. Click **+** to add device
3. Select **IP Camera**
4. Enter:
   - Name: `Tapo C310 - Front`
   - Video Source: RTSP URL above
5. Click **OK**

---

## Video Settings

### Recommended Configuration

| Setting | Value | Notes |
|---------|-------|-------|
| Resolution | 2880x1620 | 5MP native |
| Framerate | 25 fps | Full motion |
| Decoder | Hardware | Use GPU |
| Deinterlace | yadif | Reduces artifacts |

### Configure in Agent DVR

1. Click camera → **Edit**
2. **Video Source** tab:
   - URL: `rtsp://user:pass@ip:554/stream1`
   - Decoder Mode: Hardware
3. **Video** tab:
   - Resize Mode: None (full resolution)
   - Deinterlace: yadif

---

## Motion Detection

### Enable Motion Detection

1. Click camera → **Edit**
2. Go to **Detector** tab
3. Configure:
   - Detector: **Simple**
   - Overlay: **ON** (shows blue motion areas)
   - Timeout: **3 seconds**
4. Click **gear icon** for sensitivity:
   - Sensitivity: **70-80%**
   - Minimum Area: **0.5%**

---

## Recording Settings

### Configure Recording

1. Click camera → **Edit**
2. Go to **Recording** tab
3. Set:

| Setting | Value | Purpose |
|---------|-------|---------|
| Mode | Detect | Record on motion |
| Encoder | Encode or GPU Encode | Required for overlays |
| Max Record Time | 300 seconds | 5-min segments |
| Min Record Time | 15 seconds | Minimum clip length |
| Inactivity Timeout | 8 seconds | Stop after no motion |
| Buffer | 10 seconds | Pre-motion capture |
| Max Framerate | 25 | Full framerate |

### Important: Encoder Selection

| Encoder | Timestamp Overlays | CPU Usage |
|---------|-------------------|-----------|
| Raw Record | ❌ No | Low |
| Encode | ✅ Yes | Medium |
| GPU Encode | ✅ Yes | Low |

**Use "Encode" or "GPU Encode" to get timestamp overlays on recordings.**

---

## Timestamp Overlay

### Configure Timestamp

1. Camera → Edit → **Recording** tab
2. Scroll to **Timestamp** section:

| Setting | Value |
|---------|-------|
| Formatter | `{0:dd/MM/yyyy HH:mm:ss}` |
| Position | Top Left |
| Text Color | White |
| Font Size | 30 |
| Outline Color | Black |
| Outline Size | 2 |
| Show Background | ON |
| Opacity | 7 |

---

## Storage Configuration

### Camera-Level Storage

1. Camera → Edit → **Storage** tab
2. Configure:
   - Location: `/AgentDVR/Media/WebServerRoot/Media/`
   - Max Size: **500000 MB** (500GB)
   - Max Age: **720 hours** (30 days)

### Server-Level Storage

1. **Server Menu** → **Settings** → **Storage**
2. Enable storage management
3. Set global retention policies

---

## Multi-Camera Layout

### Recommended Views

| Cameras | Layout | Setting |
|---------|--------|---------|
| 2 | Side by side | 2x1 |
| 4 | Grid | 2x2 |
| 6 | Grid | 3x2 |
| 9 | Grid | 3x3 |

### Configure View

1. Click **Views** in bottom toolbar
2. Select layout (e.g., 2x1, 2x2)
3. Or click **Edit View** for custom layouts

---

## Accessing Recordings

### Via Web UI
1. Go to http://192.168.50.50:8099
2. Click **Recordings** (film icon)
3. Select camera and date range

### Direct File Access
Recordings stored at:
```
/Volumes/HomeLab-4TB/AgentDVR/media/
```

Structure:
```
/AgentDVR/media/
├── CameraName/
│   ├── 2025-11-26/
│   │   ├── 12-30-45.mp4
│   │   ├── 12-35-22.mp4
│   │   └── ...
```

---

## Backup Configuration

Recordings backed up weekly via Kopia:
- Schedule: Sunday 04:00
- Retention: 1 month
- Compression: None (already compressed)

See [[Kopia-Backup-Setup]] for details.

---

## Troubleshooting

### Camera Not Connecting

```bash
# Test RTSP URL
ffprobe rtsp://user:pass@camera_ip:554/stream1

# Check camera is online
ping camera_ip
```

### High CPU Usage

Agent DVR may use 100%+ CPU during encoding. Solutions:
- Use GPU Encode instead of Encode
- Reduce camera resolution/framerate
- Use Raw Record (no overlays)

### Recordings Not Saving

1. Check storage path permissions
2. Verify disk space available
3. Check Docker volume mount

```bash
docker exec agent-dvr ls -la /AgentDVR/Media/WebServerRoot/Media/
```

### No Timestamp on Recordings

- Encoder must be **Encode** or **GPU Encode**
- Raw Record does NOT support overlays

---

## Mobile Access

### iSpyConnect App
- iOS/Android available
- Connect to: http://YOUR_PUBLIC_IP:8099
- Requires port forwarding or VPN

### Recommended: VPN Access
Use WireGuard or Tailscale for secure remote access instead of port forwarding.

---

## Related Pages

- [[Master-Service-List]]
- [[Kopia-Backup-Setup]]
- [[Health-Check-Guide]]

---

*Last Updated: 2025-11-26*
