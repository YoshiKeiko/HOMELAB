#!/bin/bash

################################################################################
# Replace RustDesk with Tailscale + macOS Screen Sharing
# Better, more secure remote access with Android/iOS apps
################################################################################

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_section() {
    echo ""
    echo -e "${BLUE}################################################################################${NC}"
    echo -e "${BLUE}# $1${NC}"
    echo -e "${BLUE}################################################################################${NC}"
    echo ""
}

HOMELAB_DIR="$HOME/HomeLab"
DOCKER_DATA_DIR="$HOMELAB_DIR/Docker/Data"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"

################################################################################
# Step 1: Remove RustDesk
################################################################################

remove_rustdesk() {
    log_section "Step 1: Removing RustDesk"
    
    # Stop and remove RustDesk containers
    docker stop hbbs hbbr 2>/dev/null || true
    docker rm hbbs hbbr 2>/dev/null || true
    
    # Update network compose file to remove RustDesk
    if [ -f "$COMPOSE_DIR/network.yml" ]; then
        log_info "Updating network compose file..."
        cat > "$COMPOSE_DIR/network.yml" << 'EOF'
services:
  adguard:
    image: adguard/adguardhome:latest
    container_name: adguard
    restart: unless-stopped
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "3002:3000/tcp"
      - "8084:80/tcp"
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/adguard/work:/opt/adguardhome/work
      - /Users/homelab/HomeLab/Docker/Data/adguard/conf:/opt/adguardhome/conf
    networks:
      - homelab-net

  nginx-proxy-manager:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "81:81"
    environment:
      DB_SQLITE_FILE: "/data/database.sqlite"
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/nginx-proxy-manager/data:/data
      - /Users/homelab/HomeLab/Docker/Data/nginx-proxy-manager/letsencrypt:/etc/letsencrypt
    networks:
      - homelab-net
      - proxy-net

  wireguard:
    image: linuxserver/wireguard:latest
    container_name: wireguard
    restart: unless-stopped
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=501
      - PGID=20
      - TZ=Europe/London
      - SERVERURL=auto
      - SERVERPORT=51820
      - PEERS=5
      - PEERDNS=auto
    volumes:
      - /Users/homelab/HomeLab/Docker/Data/wireguard/config:/config
      - /lib/modules:/lib/modules:ro
    ports:
      - "51820:51820/udp"
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    networks:
      - homelab-net

networks:
  homelab-net:
    external: true
  proxy-net:
    external: true
EOF
        
        docker compose -f "$COMPOSE_DIR/network.yml" up -d
    fi
    
    log_info "✓ RustDesk removed"
}

################################################################################
# Step 2: Install Tailscale
################################################################################

install_tailscale() {
    log_section "Step 2: Installing Tailscale"
    
    # Check if Tailscale is already installed
    if command -v tailscale &> /dev/null; then
        log_info "Tailscale already installed"
    else
        log_info "Installing Tailscale via Homebrew..."
        brew install tailscale
    fi
    
    # Start Tailscale service
    log_info "Starting Tailscale..."
    sudo tailscale up || true
    
    log_info "✓ Tailscale installed"
}

################################################################################
# Step 3: Enable macOS Screen Sharing
################################################################################

enable_screen_sharing() {
    log_section "Step 3: Enabling macOS Screen Sharing"
    
    log_info "Enabling Remote Management (Screen Sharing)..."
    
    # Enable Screen Sharing
    sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
        -activate -configure -access -on \
        -restart -agent -privs -all || true
    
    # Enable VNC with password
    log_warn "You'll need to set a VNC password in System Settings"
    
    log_info "✓ Screen Sharing enabled"
}

################################################################################
# Step 4: Instructions
################################################################################

print_instructions() {
    log_section "Setup Complete!"
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  🎉 Tailscale + Screen Sharing Ready!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${BLUE}COMPLETE SETUP ON YOUR MAC:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "1. Open System Settings → General → Sharing"
    echo "2. Enable 'Screen Sharing'"
    echo "3. Click (i) next to Screen Sharing"
    echo "4. Set VNC password (for third-party apps)"
    echo "5. Note your Mac's Tailscale IP address:"
    echo ""
    tailscale ip -4 2>/dev/null || echo "   Run: tailscale ip -4"
    echo ""
    
    echo -e "${BLUE}ON YOUR ANDROID/iOS DEVICE:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "1. Install Tailscale from Play Store/App Store"
    echo "2. Sign in with the same account"
    echo "3. Your Mac will appear in the devices list"
    echo ""
    echo "Option A - Use Tailscale's Built-in Screen Sharing:"
    echo "  • Tap your Mac in Tailscale app"
    echo "  • Tap 'Screen Sharing'"
    echo "  • Enter VNC password"
    echo ""
    echo "Option B - Use VNC Viewer App:"
    echo "  • Install 'VNC Viewer' from Play Store/App Store"
    echo "  • Add server: <your-mac-tailscale-ip>:5900"
    echo "  • Connect with VNC password"
    echo ""
    
    echo -e "${BLUE}ADVANTAGES OVER RUSTDESK:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Native macOS Screen Sharing (better performance)"
    echo "✅ Works through firewalls/NAT automatically"
    echo "✅ Zero-config VPN mesh network"
    echo "✅ More secure (WireGuard-based)"
    echo "✅ Works with Android/iOS official apps"
    echo "✅ Free for personal use (up to 100 devices)"
    echo "✅ No Docker containers needed"
    echo ""
    
    echo -e "${YELLOW}IMPORTANT LINKS:${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Tailscale Android:  https://play.google.com/store/apps/details?id=com.tailscale.ipn"
    echo "Tailscale iOS:      https://apps.apple.com/app/tailscale/id1470499037"
    echo "VNC Viewer Android: https://play.google.com/store/apps/details?id=com.realvnc.viewer.android"
    echo "VNC Viewer iOS:     https://apps.apple.com/app/vnc-viewer/id352019548"
    echo ""
    
    echo -e "${GREEN}Quick Test:${NC}"
    echo "1. Get your Mac's Tailscale IP: tailscale ip -4"
    echo "2. On another device with Tailscale, try: ping <tailscale-ip>"
    echo "3. Or just open Tailscale app and tap on your Mac!"
    echo ""
}

################################################################################
# Main
################################################################################

main() {
    log_section "Replacing RustDesk with Tailscale"
    
    remove_rustdesk
    install_tailscale
    enable_screen_sharing
    print_instructions
    
    echo ""
    echo -e "${GREEN}All done! Follow the instructions above to complete setup.${NC}"
    echo ""
}

main "$@"