---
title: Volume 08: Smart Home Integration (Day 9)
tags: [homelab, smart-home, iot, home-assistant]
created: 2025-11-11
type: homelab-guide
---

# Volume 08: Smart Home Integration (Day 9)

**Complete Smart Home Control Center**

This volume covers integrating your entire smart home ecosystem.

## What You'll Complete

- Home Assistant with 43+ devices
- Frigate NVR with 5 Nest cameras
- Scrypted for camera integration
- 10 Sonos speakers control
- Tesla Model Y integration
- Cupra Born EV integration
- Easee EV charger control
- Complete automation

## Prerequisites

- Volumes 01-07 complete
- Docker running
- All smart home credentials in 1Password
- Devices on network

---

# Guide 51: Home Assistant

## Deploy Home Assistant

```bash
docker compose -f docker-compose-master.yml up -d homeassistant
```

Access: http://192.168.50.10:8123

## Initial Setup

1. Create account:
   - Name: Steve
   - Username: steve
   - Password: [strong password]

2. Save to 1Password:
   ```
   Title: Home Assistant
   URL: http://192.168.50.10:8123
   Username: steve
   Password: [your password]
   ```

3. Location: Set to your home address
4. Time zone: Europe/London
5. Analytics: Opt out

## Install Integrations

### Nest Cameras (5 devices)

1. Settings → Devices & Services → Add Integration
2. Search: Google Nest
3. Sign in with Google account
4. Authorize Home Assistant
5. Select devices:
   - Front Door Camera
   - Back Garden Camera
   - Driveway Camera
   - Living Room Camera
   - Office Camera

### Sonos (10 speakers)

1. Add Integration → Sonos
2. Auto-discovers all 10 speakers
3. Group by room:
   - Living Room (2 speakers - stereo pair)
   - Kitchen (1)
   - Office (1)
   - Bedroom (2 - stereo pair)
   - Garden (2)
   - Garage (1)
   - Bathroom (1)

### Tesla Integration

1. Add Integration → Tesla
2. Credentials:
   - Email: [from 1Password]
   - Password: [from 1Password]
3. Select: Tesla Model Y
4. Exposes:
   - Location
   - Battery level
   - Charging state
   - Climate control
   - Lock/unlock
   - Charge port

### Cupra Born Integration

1. Add Integration → Volkswagen We Connect
2. Credentials: [from 1Password]
3. Select: Cupra Born
4. Similar controls as Tesla

### Easee Charger

1. Add Integration → Easee
2. Credentials: [from 1Password]
3. Exposes:
   - Charging status
   - Power usage
   - Start/stop charging
   - Load balancing

---

# Guide 52: Frigate NVR

## Deploy Frigate

```yaml
frigate:
  image: ghcr.io/blakeblackshear/frigate:stable
  container_name: frigate
  restart: unless-stopped
  privileged: true
  ports:
    - "5000:5000"
    - "8554:8554"  # RTSP
    - "8555:8555/tcp"  # WebRTC
  volumes:
    - ~/HomeLab/Docker/Configs/frigate:/config
    - /Volumes/External4TB/Frigate:/media/frigate
    - /dev/shm:/dev/shm
  environment:
    - FRIGATE_RTSP_PASSWORD=your-password
```

## Configure Frigate

Create: ~/HomeLab/Docker/Configs/frigate/config.yml

```yaml
mqtt:
  enabled: false

cameras:
  front_door:
    ffmpeg:
      inputs:
        - path: rtsp://nest-camera-1-url
          roles:
            - detect
            - record
    detect:
      width: 1920
      height: 1080
    record:
      enabled: true
      retain:
        days: 30
    snapshots:
      enabled: true
      retain:
        default: 7
    objects:
      track:
        - person
        - car
        - dog
        - cat

  back_garden:
    # Similar config for other 4 cameras
```

## Access Frigate

- Web UI: http://192.168.50.10:5000
- View live streams
- Review recordings
- View detected objects
- Manage alerts

---

# Guide 53: Scrypted

## Deploy Scrypted

```bash
docker compose -f docker-compose-master.yml up -d scrypted
```

Access: http://192.168.50.10:11080

## Setup

1. Create account
2. Add Nest cameras
3. Bridge to HomeKit (optional)
4. Enable RTSP restreaming
5. Connect to Frigate

**Benefits:**
- Better Nest camera integration
- HomeKit support
- Local streaming
- No cloud dependency

---

# Guide 54: Automations

## Example Automations

### Welcome Home
```yaml
automation:
  - alias: "Welcome Home"
    trigger:
      - platform: state
        entity_id: device_tracker.tesla_model_y
        to: "home"
    action:
      - service: light.turn_on
        target:
          entity_id: light.entrance
      - service: climate.set_temperature
        data:
          entity_id: climate.living_room
          temperature: 21
      - service: media_player.play_media
        target:
          entity_id: media_player.sonos_living_room
        data:
          media_content_id: "spotify:playlist:your-playlist"
```

### Charge at Night
```yaml
automation:
  - alias: "Start EV Charging at Low Rate"
    trigger:
      - platform: time
        at: "01:00:00"
    condition:
      - condition: state
        entity_id: binary_sensor.tesla_charging
        state: "off"
      - condition: numeric_state
        entity_id: sensor.tesla_battery
        below: 80
    action:
      - service: switch.turn_on
        target:
          entity_id: switch.easee_charger
```

### Security Alert
```yaml
automation:
  - alias: "Person Detected at Night"
    trigger:
      - platform: state
        entity_id: binary_sensor.front_door_person_detected
        to: "on"
    condition:
      - condition: time
        after: "22:00:00"
        before: "06:00:00"
    action:
      - service: notify.mobile_app
        data:
          title: "Front Door Motion"
          message: "Person detected at front door"
      - service: light.turn_on
        target:
          entity_id: light.front_porch
```

---

# Guide 55: Dashboards

## Create Custom Dashboard

1. Overview → Edit Dashboard
2. Add cards:
   - Camera feeds (5 Nest cameras)
   - Sonos controls (10 speakers)
   - Tesla status and controls
   - Cupra status
   - Easee charger status
   - Climate controls
   - Energy monitoring

## Mobile Access

1. Install Home Assistant app on Samsung S25
2. Add server: http://192.168.50.10:8123
3. Or via Tailscale: http://100.x.x.x:8123
4. Enable notifications

---

## Volume 08 Complete!

You now have:
- ✅ Home Assistant central hub
- ✅ 5 Nest cameras in Frigate
- ✅ 10 Sonos speakers integrated
- ✅ Tesla Model Y control
- ✅ Cupra Born control
- ✅ Easee charger automation
- ✅ 43+ devices total
- ✅ Custom automations
- ✅ Mobile control

**Smart Home Summary:**
```
43+ Devices:
├─ 5 Nest Cameras (via Frigate + Scrypted)
├─ 10 Sonos Speakers (multi-room audio)
├─ Tesla Model Y (location, climate, charging)
├─ Cupra Born (status, controls)
├─ Easee Charger (smart charging)
└─ + Other smart home devices
```

**Next: Volume 09 - AI Services**



---

#homelab #smart-home #iot #home-assistant
