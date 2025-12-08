# Camera System Documentation

## Overview
4 Tapo cameras integrated with Home Assistant and Frigate NVR for 24/7 recording with AI object detection.

## Camera Inventory

| Camera | IP Address | Model | Location | Resolution | Frigate |
|--------|------------|-------|----------|------------|---------|
| Hallway | 192.168.50.68 | C230 | Front hallway | 1280x720 | ✅ |
| Kat Kave | 192.168.50.11 | C210 | Cat room | 1280x720 | ✅ |
| Conservatory | 192.168.50.120 | C210 | Conservatory | 1920x1080 | ✅ |
| Office | 192.168.50.104 | C210 | Office | 1280x720 | ✅ |

## Credentials

### RTSP Stream Access
- **Username**: `agentdvr`
- **Password**: `a4dX4dRhsd_sB.V6FkdYmiFhBqq3jJAF`
- **Cloud Password**: `DY32JJ*tqMPu22WTpkpER@sGFEjA@7Ea`

### RTSP URLs
```
rtsp://agentdvr:a4dX4dRhsd_sB.V6FkdYmiFhBqq3jJAF@192.168.50.68:554/stream1   # Hallway
rtsp://agentdvr:a4dX4dRhsd_sB.V6FkdYmiFhBqq3jJAF@192.168.50.11:554/stream1   # Kat Kave
rtsp://agentdvr:a4dX4dRhsd_sB.V6FkdYmiFhBqq3jJAF@192.168.50.120:554/stream1  # Conservatory
rtsp://agentdvr:a4dX4dRhsd_sB.V6FkdYmiFhBqq3jJAF@192.168.50.104:554/stream1  # Office
```

## Home Assistant Integration

### Tapo Control (HACS)
Each camera provides extensive entities:
- `camera.[name]_hd_stream` - High definition stream
- `camera.[name]_sd_stream` - Standard definition stream
- `switch.[name]_privacy` - Privacy mode toggle
- `switch.[name]_auto_track` - Auto tracking (PTZ cameras)
- `switch.[name]_notifications` - Push notifications
- `button.[name]_reboot` - Reboot camera
- `siren.[name]_siren` - Built-in siren
- `light.[name]_floodlight_timed` - Floodlight (if equipped)
- Plus motion detection, pet detection, vehicle detection controls

### Camera Entity Examples
```yaml
# View camera in dashboard
camera.hallway_hd_stream
camera.kat_kave_hd_stream
camera.conservatory_hd_stream
camera.office_hd_stream
```

## Frigate NVR

### Access
- **URL**: http://192.168.50.50:5001
- **Config**: `/Users/homelab/HomeLab/Docker/Data/frigate/config/config.yml`

### Recording Settings
- **Retention**: 14 days (motion events)
- **Alerts retention**: 30 days
- **Detection retention**: 30 days
- **Snapshots**: 30 days

### Object Detection
Tracking enabled for:
- Person (min_score: 0.5, threshold: 0.7)
- Cat (min_score: 0.25, threshold: 0.4)
- Dog (min_score: 0.25, threshold: 0.4)
- Car
- Bird

### Frigate Config Location
```
/Users/homelab/HomeLab/Docker/Data/frigate/config/config.yml
```

### MQTT Integration
- **Broker**: 192.168.50.50:1883
- **Topic**: `frigate/events` - All detection events

## Automations

### Motion Notifications (Currently Disabled)
Located in `automations.yaml`:
- `hallway_motion_notification`
- `kat_kave_motion_notification`
- `conservatory_motion_notification`

### Frigate Person/Cat Detection (Currently Disabled)
- `frigate_person_detected` - Notifies when person detected
- `frigate_cat_detected` - Notifies when cat spotted

## Adding a New Camera

### 1. Add to Home Assistant
```
Settings → Devices & Services → + Add Integration → Tapo
Enter: IP, username (agentdvr), password, cloud password
```

### 2. Add to Frigate
Edit `/Users/homelab/HomeLab/Docker/Data/frigate/config/config.yml`:
```yaml
cameras:
  new_camera_name:
    ffmpeg:
      inputs:
        - path: rtsp://agentdvr:PASSWORD@IP_ADDRESS:554/stream1
          roles:
            - detect
            - record
    detect:
      enabled: true
      width: 1280
      height: 720
      fps: 5
    record:
      enabled: true
    snapshots:
      enabled: true
    objects:
      track:
        - person
        - cat
        - dog
```

### 3. Restart Frigate
```bash
docker restart frigate
```

## Troubleshooting

### Camera offline
1. Check ping: `ping 192.168.50.XX`
2. Check RTSP: `ffprobe rtsp://...`
3. Reboot via HA: `button.[name]_reboot`

### Frigate not recording
1. Check logs: `docker logs frigate --tail 100`
2. Verify RTSP URL works
3. Check disk space: `docker exec frigate df -h`

### High CPU usage
- Reduce fps from 5 to 3
- Reduce resolution
- Enable hardware acceleration if available

---
*Last updated: 2025-12-07*
