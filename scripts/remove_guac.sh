#!/bin/bash

################################################################################
# Remove Guacamole (using Tailscale instead)
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Removing Guacamole (using Tailscale instead)"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Stop and remove Guacamole containers
echo "Stopping Guacamole containers..."
docker stop guacamole guacd guacamole-db 2>/dev/null || true
docker rm guacamole guacd guacamole-db 2>/dev/null || true

# Remove the compose file
COMPOSE_DIR="$HOME/HomeLab/Docker/Compose"
if [ -f "$COMPOSE_DIR/guacamole.yml" ]; then
    echo "Removing compose file..."
    rm "$COMPOSE_DIR/guacamole.yml"
fi

# Optional: Clean up data (comment out if you want to keep it)
# DATA_DIR="$HOME/HomeLab/Docker/Data/guacamole"
# if [ -d "$DATA_DIR" ]; then
#     echo "Removing data directory..."
#     rm -rf "$DATA_DIR"
# fi

echo ""
echo -e "${GREEN}✓ Guacamole removed${NC}"
echo ""
echo -e "${BLUE}You're using Tailscale instead:${NC}"
echo "  • Better performance"
echo "  • Native macOS Screen Sharing"
echo "  • Works on Android/iOS apps"
echo "  • More secure"
echo ""
echo "To access your Mac remotely:"
echo "  1. Install Tailscale on your phone (already done ✓)"
echo "  2. Use VNC Viewer app"
echo "  3. Connect to: $(tailscale ip -4 2>/dev/null || echo 'YOUR_TAILSCALE_IP')"
echo ""