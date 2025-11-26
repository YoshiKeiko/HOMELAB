# Agent DVR

**Status**: 🟢 Active  
**Category**: Surveillance / NVR  
**Port**: 8190 (Web UI), 3478 (TURN server)  
**Docker Image**: `mekayelanik/ispyagentdvr:latest` (ARM64)  
**Documentation**: [Agent DVR Docs](https://www.ispyconnect.com/userguide-agent-dvr.aspx)

## Overview

Agent DVR is a free, open-source DVR/NVR platform for managing IP cameras. It provides live viewing, motion detection, recording, alerts, and integrates with various camera protocols including RTSP.

## Quick Links

- **Web UI**: http://192.168.68.50:8190
- **Local Access**: http://localhost:8190

## Cameras Configured

| Camera | Model | Location | RTSP Stream |
|--------|-------|----------|-------------|
| Tapo C310 | TP-Link | TBD | `rtsp://[user]:[pass]@[ip]:554/stream1` |

## Configuration

### Docker Compose

Located at: `~/docker/surveillance/docker-compose.yml`

```yaml
services:
  agent-dvr:
    image: mekayelanik/ispyagentdvr:latest
    container_name: agent-dvr
    restart: unless-stopped
    ports:
      - "8190:8090"
      - "3478:3478/udp"
    volumes:
      - ./agent-dvr/config:/AgentDVR/Media/XML
      - ./agent-dvr/media:/AgentDVR/Media/WebServerRoot/Media
      - ./agent-dvr/commands:/AgentDVR/Commands
    environment:
      - TZ=Europe/London
```

### Storage Paths

| Path | Purpose |
|------|---------|
| `~/docker/surveillance/agent-dvr/config` | Configuration files |
| `~/docker/surveillance/agent-dvr/media` | Recorded footage |
| `~/docker/surveillance/agent-dvr/commands` | Custom commands |

## Tapo C310 Setup

### Prerequisites

1. Tapo C310 connected to your network
2. Tapo app installed on phone
3. Camera account credentials created in Tapo app

### Enable RTSP on Tapo C310

1. Open **Tapo app** on your phone
2. Select your **C310 camera**
3. Tap **Settings** (gear icon)
4. Go to **Advanced Settings**
5. Select **Camera Account**
6. **Create** a username and password (this is for RTSP, not your Tapo cloud account)
7. Note down these credentials

### RTSP URL Format

```
# Main stream (1080p)
rtsp://[username]:[password]@[camera_ip]:554/stream1

# Sub stream (lower resolution, less bandwidth)
rtsp://[username]:[password]@[camera_ip]:554/stream2
```

**Example:**
```
rtsp://admin:MySecurePass123@192.168.68.100:554/stream1
```

### Finding Camera IP

Check your router's DHCP client list or use:
```bash
# Scan network for Tapo devices
nmap -sn 192.168.68.0/24 | grep -B2 "TP-LINK\|TAPO"
```

## Adding Camera to Agent DVR

1. Open Agent DVR web UI: http://192.168.68.50:8190
2. Click **+ Add Device** → **Video Source**
3. Configure:
   - **Name**: Tapo C310 - [Location]
   - **Source Type**: RTSP (FFmpeg)
   - **Video Source URL**: `rtsp://[user]:[pass]@[camera_ip]:554/stream1`
4. Click **OK** to save
5. The camera feed should appear

## Motion Detection Settings

Recommended settings for Tapo C310:

| Setting | Value |
|---------|-------|
| Motion Detector | Simple |
| Sensitivity | 70-80% |
| Trigger Delay | 2 seconds |
| Buffer | 5 seconds pre, 10 seconds post |

## Recording Configuration

### Continuous Recording
- Enable **24/7 Recording** in camera settings
- Set max file size: 100MB
- Set max duration: 15 minutes per file

### Motion-Based Recording
- Enable **Record on Motion**
- Pre-record buffer: 5 seconds
- Post-record: 10 seconds

## Storage Management

Agent DVR can auto-delete old recordings:

1. Go to **Server Settings** → **Storage**
2. Set **Max Storage**: 500GB (adjust based on your 4TB drive)
3. Enable **Auto-delete** when storage limit reached
4. **Archive Days**: 30 (keep 30 days of footage)

## Troubleshooting

### Camera Not Connecting

```bash
# Test RTSP stream with ffmpeg
ffmpeg -i "rtsp://[user]:[pass]@[camera_ip]:554/stream1" -frames:v 1 test.jpg

# Check if port 554 is open
nc -zv [camera_ip] 554
```

### High CPU Usage

- Use sub-stream (`stream2`) instead of main stream
- Reduce motion detection sensitivity
- Lower frame rate in camera settings

### Connection Drops

- Check camera is on stable power
- Verify network connectivity
- Try sub-stream for more reliability

## Integration with Home Assistant

Agent DVR can integrate with Home Assistant via RTSP proxy:

```yaml
# In Home Assistant configuration.yaml
camera:
  - platform: generic
    name: Tapo C310
    still_image_url: http://192.168.68.50:8190/media/camera1/snapshot.jpg
    stream_source: rtsp://192.168.68.50:8190/live/camera1
```

## Backup

Configuration is stored in:
- `~/docker/surveillance/agent-dvr/config/`

Add to your backup routine:
```bash
# Add to pCloud backup script
rsync -av ~/docker/surveillance/agent-dvr/config/ /path/to/backup/agent-dvr/
```

## Related

- [[AdGuard-Home]] - DNS filtering
- [[00-SERVICE-INDEX]] - All services
- [[NETWORK-CONFIG]] - Network configuration

## Tags

#surveillance #cameras #nvr #tapo #docker #security
