#!/bin/bash

################################################################################
# Retrieve All Service Credentials
################################################################################

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Retrieving Service Credentials"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Function to safely get env var from container
get_env() {
    docker exec "$1" printenv "$2" 2>/dev/null || echo "Not set"
}

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  GRAFANA CREDENTIALS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "URL: http://localhost:3003"
echo ""

GRAFANA_PASS=$(get_env grafana GF_SECURITY_ADMIN_PASSWORD)
if [ "$GRAFANA_PASS" = "Not set" ]; then
    echo -e "${YELLOW}Default Credentials:${NC}"
    echo "  Username: admin"
    echo "  Password: admin"
    echo ""
    echo -e "${CYAN}Note: You'll be prompted to change password on first login${NC}"
else
    echo "Username: admin"
    echo "Password: $GRAFANA_PASS"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  NEXTCLOUD CREDENTIALS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "URL: http://localhost:8097"
echo ""

NEXTCLOUD_USER=$(get_env nextcloud NEXTCLOUD_ADMIN_USER)
NEXTCLOUD_PASS=$(get_env nextcloud NEXTCLOUD_ADMIN_PASSWORD)

if [ "$NEXTCLOUD_USER" = "Not set" ]; then
    echo -e "${YELLOW}First-time setup - create account on first access${NC}"
else
    echo "Username: $NEXTCLOUD_USER"
    echo "Password: $NEXTCLOUD_PASS"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  PHOTOPRISM CREDENTIALS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "URL: http://localhost:2342"
echo ""

PHOTOPRISM_PASS=$(get_env photoprism PHOTOPRISM_ADMIN_PASSWORD)
if [ "$PHOTOPRISM_PASS" = "Not set" ]; then
    echo -e "${YELLOW}Default: admin / admin${NC}"
else
    echo "Username: admin"
    echo "Password: $PHOTOPRISM_PASS"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  CODE SERVER CREDENTIALS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "URL: http://localhost:8443"
echo ""

CODE_PASS=$(get_env codeserver PASSWORD)
if [ "$CODE_PASS" = "Not set" ]; then
    echo -e "${YELLOW}Default Password: changeme${NC}"
    echo -e "${CYAN}⚠️  CHANGE THIS!${NC}"
else
    echo "Password: $CODE_PASS"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  FILE BROWSER CREDENTIALS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "URL: http://localhost:8087"
echo ""
echo -e "${YELLOW}Default Credentials:${NC}"
echo "  Username: admin"
echo "  Password: admin"
echo -e "${CYAN}⚠️  CHANGE THIS after first login!${NC}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  JUPYTER TOKEN${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "URL: http://localhost:8888"
echo ""
echo "Getting token from logs..."
JUPYTER_TOKEN=$(docker logs jupyter 2>&1 | grep "token=" | tail -1 | grep -o "token=[^&]*" | cut -d= -f2)
if [ -n "$JUPYTER_TOKEN" ]; then
    echo "Token: $JUPYTER_TOKEN"
    echo ""
    echo "Or use this URL:"
    echo "http://localhost:8888/?token=$JUPYTER_TOKEN"
else
    echo -e "${YELLOW}Run this to get token:${NC}"
    echo "  docker logs jupyter | grep token"
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  NGINX PROXY MANAGER${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "URL: http://localhost:81"
echo ""
echo -e "${YELLOW}Default Credentials:${NC}"
echo "  Email: admin@example.com"
echo "  Password: changeme"
echo -e "${CYAN}⚠️  You'll be forced to change on first login${NC}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  SERVICES REQUIRING ACCOUNT CREATION${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "These services need you to create an account on first access:"
echo ""
echo "  • Portainer         http://localhost:9000"
echo "  • Vaultwarden       http://localhost:8088"
echo "  • OpenWebUI         http://localhost:3000"
echo "  • Home Assistant    http://localhost:8123"
echo "  • Uptime Kuma       http://localhost:3004"
echo "  • Plex              http://localhost:32400/web (use Plex account)"
echo "  • Jellyfin          http://localhost:8096"
echo "  • Gitea             http://localhost:3001"
echo "  • AdGuard Home      http://localhost:8084"
echo ""

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  SERVICES WITH NO LOGIN${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "These services work immediately with no login:"
echo ""
echo "  • Heimdall          http://localhost:8090"
echo "  • Netdata           http://localhost:19999"
echo "  • Prometheus        http://localhost:9090"
echo "  • Transmission      http://localhost:9091"
echo "  • Syncthing         http://localhost:8384"
echo "  • Duplicati         http://localhost:8200"
echo "  • Node-RED          http://localhost:1880"
echo "  • Radarr            http://localhost:7878"
echo "  • Sonarr            http://localhost:8989"
echo "  • Prowlarr          http://localhost:9696"
echo "  • Overseerr         http://localhost:5055"
echo "  • Calibre           http://localhost:8094"
echo "  • FreshRSS          http://localhost:8098"
echo "  • Homer             http://localhost:8091"
echo "  • Dashy             http://localhost:4000"
echo "  • Organizr          http://localhost:8092"
echo ""

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  IMPORTANT SECURITY NOTES${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "1. Save all passwords to Vaultwarden: http://localhost:8088"
echo "2. Change default passwords immediately:"
echo "   - Code Server: changeme"
echo "   - File Browser: admin/admin"
echo "   - Nginx Proxy Manager: admin@example.com/changeme"
echo ""
echo "3. After saving to Vaultwarden, you can delete this output"
echo ""

# Create credentials file
CRED_FILE="$HOME/HomeLab/docs/CREDENTIALS_$(date +%Y%m%d-%H%M%S).txt"
cat > "$CRED_FILE" << EOF
═══════════════════════════════════════════════════════════════
  HOMELAB CREDENTIALS - $(date)
═══════════════════════════════════════════════════════════════

GRAFANA
-------
URL: http://localhost:3003
Username: admin
Password: ${GRAFANA_PASS:-admin (default - will prompt to change)}

NEXTCLOUD
---------
URL: http://localhost:8097
Username: ${NEXTCLOUD_USER:-Create on first access}
Password: ${NEXTCLOUD_PASS:-Create on first access}

PHOTOPRISM
----------
URL: http://localhost:2342
Username: admin
Password: ${PHOTOPRISM_PASS:-admin (default)}

CODE SERVER
-----------
URL: http://localhost:8443
Password: ${CODE_PASS:-changeme} ⚠️ CHANGE THIS!

FILE BROWSER
------------
URL: http://localhost:8087
Username: admin
Password: admin ⚠️ CHANGE THIS!

JUPYTER
-------
URL: http://localhost:8888
Token: ${JUPYTER_TOKEN:-Run: docker logs jupyter | grep token}

NGINX PROXY MANAGER
-------------------
URL: http://localhost:81
Email: admin@example.com
Password: changeme ⚠️ CHANGE THIS!

═══════════════════════════════════════════════════════════════
⚠️  SAVE THESE TO VAULTWARDEN THEN DELETE THIS FILE!
═══════════════════════════════════════════════════════════════
EOF

echo ""
echo -e "${CYAN}Credentials saved to:${NC}"
echo "  $CRED_FILE"
echo ""
echo -e "${YELLOW}View it:${NC}"
echo "  cat $CRED_FILE"
echo ""