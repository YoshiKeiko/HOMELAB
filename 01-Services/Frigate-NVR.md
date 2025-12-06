# Frigate NVR

## Overview
Frigate is a Network Video Recorder (NVR) with real-time AI object detection. It integrates with Home Assistant and provides smart recording based on detected objects.

## Access
- **URL**: http://192.168.50.50:5001
- **Port**: 5001 (mapped from container port 5000)

## Features
- Real-time object detection (person, cat, dog, car, bird)
- Smart recording (only when objects detected)
- Integration with Home Assistant
- RTSP re-streaming
- Snapshot storage

## Configuration
**Config File**: `/Users/homelab/HomeLab/Docker/Data/frigate/config/config.yml`

### Cameras
| Camera | IP | Location |
|--------|-----|----------|
| hallway | 192.168.50.68 | Hallway |
| kat_kave | 192.168.50.11 | Conservatory |

### Detection Settings
| Object | Min Score | Threshold |
|--------|-----------|-----------|
| person | 0.5 | 0.7 |
| cat | 0.25 | 0.4 |
| dog | 0.25 | 0.4 |

### Storage
- **Recordings**: `/Volumes/HomeLab-4TB/Frigate/recordings`
- **Clips**: `/Volumes/HomeLab-4TB/Frigate/clips`
- **Retention**: 14 days (motion), 30 days (detections)

## Home Assistant Integration
Events published to MQTT topic: `frigate/events`

Automations trigger notifications for:
- Person detection (high priority)
- Cat detection (normal priority)

## Docker
```bash
# View logs
docker logs frigate --tail 50

# Restart
docker restart frigate

# Access shell
docker exec -it frigate /bin/sh
```

## Troubleshooting
- If cameras show "ffmpeg not running", check RTSP credentials
- CPU usage is normal (no GPU acceleration)
- Detection runs at 5 FPS to reduce load

---
*Added: 2025-12-05*
