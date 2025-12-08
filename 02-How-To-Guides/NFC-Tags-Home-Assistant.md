# NFC Tags with Home Assistant

## Overview
Use NFC tags with your Android phone to trigger Home Assistant automations - toggle lights, run scenes, control devices with a tap.

## Requirements
- Home Assistant with Companion App installed on Android
- NFC tags (NTAG215 or similar)
- Devices integrated into Home Assistant

## Setup Steps

### 1. Write the NFC Tag
1. Open **HA Companion App** on your phone
2. Go to **Settings → Companion App → NFC Tags**
3. Tap **"Write Tag"**
4. Hold phone to the NFC tag until confirmed
5. Optionally name the tag

### 2. Find Your Tag ID
1. In Home Assistant web UI: **Settings → Tags**
2. Your written tag will appear with its ID (e.g., `24f84f40-a2c2-46ae-b7fd-24b7d838f9a1`)
3. The ID shown here is what HA uses internally (may differ from what the app shows)

### 3. Create the Automation

#### Via UI:
1. **Settings → Automations & Scenes → Create Automation**
2. **Trigger**: Tag → select your tag
3. **Action**: Choose service (e.g., `switch.toggle`, `light.turn_on`)
4. Select target entities
5. Save

#### Via YAML:
Add to `automations.yaml`:

```yaml
- id: nfc_toggle_desk_lamps
  alias: NFC - Toggle Desk Lamps
  triggers:
  - tag_id: 24f84f40-a2c2-46ae-b7fd-24b7d838f9a1
    trigger: tag
  actions:
  - target:
      entity_id:
        - switch.left_lamp_like_mss110_main_channel
        - switch.right_light_init_mss110_main_channel
    action: switch.toggle
  mode: single
```

### 4. Reload Automations
**Developer Tools → YAML → Reload Automations**

### 5. Test
Tap your phone on the NFC tag - the automation should trigger.

## Troubleshooting

### Tag not triggering automation
1. Check **Settings → Tags** for the correct tag ID
2. The tag ID in HA may differ from what the Companion app displays
3. Verify automation is enabled in **Settings → Automations**

### Entities not responding
1. Confirm entities exist in **Developer Tools → States**
2. Test the service manually in **Developer Tools → Services**

### Tag not being read
1. Ensure NFC is enabled on your phone
2. Try holding phone in different positions (NFC antenna location varies)
3. Re-write the tag if corrupted

## Current NFC Automations

| Tag Location | Tag ID | Action |
|-------------|--------|--------|
| Desk | `24f84f40-a2c2-46ae-b7fd-24b7d838f9a1` | Toggle Left & Right desk lamps |

---
*Created: 2025-12-07*
