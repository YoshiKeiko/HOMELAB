#!/bin/bash

################################################################################
# Tailscale Configuration & Testing Guide
# Complete setup verification for M4 Mac + Android
################################################################################

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Tailscale Configuration & Testing${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

################################################################################
# Step 1: Check Tailscale Status on Mac
################################################################################

echo -e "${GREEN}Step 1: Checking Tailscale Status on Mac${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if ! command -v tailscale &> /dev/null; then
    echo -e "${RED}✗ Tailscale not found. Installing...${NC}"
    brew install tailscale
else
    echo -e "${GREEN}✓ Tailscale is installed${NC}"
fi

# Check if Tailscale is running
if tailscale status &> /dev/null; then
    echo -e "${GREEN}✓ Tailscale is running${NC}"
    echo ""
    tailscale status
else
    echo -e "${YELLOW}⚠ Tailscale not connected. Starting...${NC}"
    sudo tailscale up
fi

echo ""
echo -e "${CYAN}Your Mac's Tailscale IP addresses:${NC}"
TAILSCALE_IPV4=$(tailscale ip -4 2>/dev/null)
TAILSCALE_IPV6=$(tailscale ip -6 2>/dev/null)
echo "  IPv4: ${TAILSCALE_IPV4}"
echo "  IPv6: ${TAILSCALE_IPV6}"

MAC_HOSTNAME=$(hostname)
echo "  Hostname: ${MAC_HOSTNAME}"
echo ""

################################################################################
# Step 2: Enable Screen Sharing
################################################################################

echo -e "${GREEN}Step 2: Configuring Screen Sharing${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Screen Sharing is enabled
SCREEN_SHARING_STATUS=$(sudo launchctl list | grep com.apple.screensharing || echo "not running")

if [[ "$SCREEN_SHARING_STATUS" == *"not running"* ]]; then
    echo -e "${YELLOW}⚠ Screen Sharing is not enabled${NC}"
    echo ""
    echo "To enable Screen Sharing:"
    echo "1. Open System Settings"
    echo "2. Go to General → Sharing"
    echo "3. Toggle ON 'Screen Sharing'"
    echo "4. Click (i) next to Screen Sharing"
    echo "5. Enable 'VNC viewers may control screen with password'"
    echo "6. Set a VNC password"
    echo ""
    read -p "Press Enter after enabling Screen Sharing..."
else
    echo -e "${GREEN}✓ Screen Sharing is enabled${NC}"
fi

echo ""

################################################################################
# Step 3: Android Phone Setup Instructions
################################################################################

echo -e "${GREEN}Step 3: Android Phone Setup${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "On your Android phone:"
echo ""
echo "1. Open the Tailscale app"
echo "2. You should see your Mac listed as: ${MAC_HOSTNAME}"
echo "3. Both devices should show as 'Connected'"
echo ""
echo -e "${CYAN}If you don't see your Mac:${NC}"
echo "  • Make sure you're signed into the SAME Tailscale account"
echo "  • Pull down to refresh the device list"
echo "  • Check that both devices have internet"
echo ""
read -p "Press Enter when you can see your Mac in the Tailscale app..."
echo ""

################################################################################
# Step 4: Test Connection
################################################################################

echo -e "${GREEN}Step 4: Testing Connection${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "On your Android phone, test the connection:"
echo ""
echo "Method 1: Using Tailscale App (Easiest)"
echo "  1. Tap on your Mac (${MAC_HOSTNAME})"
echo "  2. You'll see options like 'Ping', 'SSH', 'Web Browse'"
echo "  3. Tap 'Ping' - you should see replies"
echo ""
echo "Method 2: Using Chrome Browser"
echo "  1. Open Chrome on your phone"
echo "  2. Go to: http://${TAILSCALE_IPV4}:9000"
echo "  3. You should see Portainer login"
echo ""
read -p "Press Enter after testing ping/web access..."
echo ""

################################################################################
# Step 5: Screen Sharing Setup
################################################################################

echo -e "${GREEN}Step 5: Screen Sharing Setup${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${CYAN}Option A: Quick Test with Tailscale App${NC}"
echo "Unfortunately, Tailscale Android doesn't have built-in screen sharing yet."
echo ""
echo -e "${CYAN}Option B: Install VNC Viewer (Recommended)${NC}"
echo ""
echo "1. Install 'VNC Viewer' from Play Store:"
echo "   https://play.google.com/store/apps/details?id=com.realvnc.viewer.android"
echo ""
echo "2. Open VNC Viewer app"
echo ""
echo "3. Tap the '+' button to add a new connection"
echo ""
echo "4. Enter connection details:"
echo "   Address: ${TAILSCALE_IPV4}"
echo "   Name: HomeLab Mac"
echo ""
echo "5. Tap 'Connect'"
echo ""
echo "6. Enter your VNC password (set in System Settings)"
echo ""
echo "7. You should see your Mac screen!"
echo ""

################################################################################
# Step 6: Quick Access to Services
################################################################################

echo -e "${GREEN}Step 6: Quick Access URLs${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Save these URLs in Chrome on your Android phone:"
echo "(They only work when Tailscale is connected)"
echo ""
echo -e "${CYAN}Core Services:${NC}"
echo "  Portainer:       http://${TAILSCALE_IPV4}:9000"
echo "  Home Assistant:  http://${TAILSCALE_IPV4}:8123"
echo "  Heimdall:        http://${TAILSCALE_IPV4}:8090"
echo ""
echo -e "${CYAN}Media:${NC}"
echo "  Plex:            http://${TAILSCALE_IPV4}:32400/web"
echo "  Jellyfin:        http://${TAILSCALE_IPV4}:8096"
echo "  Overseerr:       http://${TAILSCALE_IPV4}:5055"
echo ""
echo -e "${CYAN}Monitoring:${NC}"
echo "  Grafana:         http://${TAILSCALE_IPV4}:3003"
echo "  Uptime Kuma:     http://${TAILSCALE_IPV4}:3004"
echo "  Netdata:         http://${TAILSCALE_IPV4}:19999"
echo ""

################################################################################
# Step 7: Test Checklist
################################################################################

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Testing Checklist${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Test each of these on your Android phone:"
echo ""
echo "[ ] 1. Can see Mac in Tailscale app"
echo "[ ] 2. Ping works in Tailscale app"
echo "[ ] 3. Can access http://${TAILSCALE_IPV4}:9000 in Chrome"
echo "[ ] 4. VNC Viewer connects successfully"
echo "[ ] 5. Can control Mac screen from phone"
echo ""

################################################################################
# Troubleshooting
################################################################################

echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}  Troubleshooting${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "If connection doesn't work:"
echo ""
echo "1. Check Tailscale status on Mac:"
echo "   tailscale status"
echo ""
echo "2. Check if both devices are online:"
echo "   tailscale ping <device-name>"
echo ""
echo "3. Restart Tailscale on Mac:"
echo "   sudo tailscale down"
echo "   sudo tailscale up"
echo ""
echo "4. Check Mac firewall (should allow Tailscale):"
echo "   System Settings → Network → Firewall"
echo ""
echo "5. Force quit and restart Tailscale app on Android"
echo ""

################################################################################
# Save Configuration
################################################################################

# Save the Tailscale IP to a file for easy reference
cat > "$HOME/HomeLab/docs/tailscale-config.txt" << EOF
═══════════════════════════════════════════════════════════════
  Tailscale Configuration
═══════════════════════════════════════════════════════════════

Mac Details:
  Hostname: ${MAC_HOSTNAME}
  IPv4:     ${TAILSCALE_IPV4}
  IPv6:     ${TAILSCALE_IPV6}

VNC Connection:
  Address:  ${TAILSCALE_IPV4}:5900
  Password: (Set in System Settings → Sharing → Screen Sharing)

Quick Access URLs:
  Portainer:       http://${TAILSCALE_IPV4}:9000
  Home Assistant:  http://${TAILSCALE_IPV4}:8123
  Plex:            http://${TAILSCALE_IPV4}:32400/web
  Grafana:         http://${TAILSCALE_IPV4}:3003
  Heimdall:        http://${TAILSCALE_IPV4}:8090

Android Apps Needed:
  - Tailscale (already installed)
  - VNC Viewer (for screen sharing)

Generated: $(date)
EOF

echo ""
echo -e "${GREEN}Configuration saved to:${NC}"
echo "$HOME/HomeLab/docs/tailscale-config.txt"
echo ""
echo -e "${GREEN}Setup complete! Test everything on your Android phone now.${NC}"
echo ""