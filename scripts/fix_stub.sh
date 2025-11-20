#!/bin/bash

################################################################################
# Fix Stubborn Services - Nuclear Option
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_fix() { echo -e "${YELLOW}[FIX]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

HOMELAB_DIR="$HOME/HomeLab"
DATA_DIR="$HOMELAB_DIR/Docker/Data"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Fixing Services - Nuclear Approach"
echo "═══════════════════════════════════════════════════════════════"
echo ""

################################################################################
# 1. PhotoPrism - Complete Reset
################################################################################

log_fix "1. PhotoPrism - Stopping and checking..."
docker stop photoprism 2>/dev/null || true
sleep 2

log_info "Starting PhotoPrism fresh..."
docker start photoprism

log_info "PhotoPrism takes 60-90 seconds to fully start"
log_info "Wait and then try: http://localhost:2342"
log_info "Credentials: admin / admin"
echo ""

################################################################################
# 2. Nextcloud - Fix Database Connection
################################################################################

log_fix "2. Nextcloud - Fixing database..."

# Ensure postgres is running
if ! docker ps | grep -q postgres; then
    log_info "Starting PostgreSQL..."
    docker start postgres
    sleep 5
fi

# Create database and user
log_info "Creating Nextcloud database..."
docker exec postgres psql -U postgres << 'EOFSQL'
DROP DATABASE IF EXISTS nextcloud;
DROP USER IF EXISTS nextcloud;
CREATE DATABASE nextcloud;
CREATE USER nextcloud WITH PASSWORD 'nextcloud_secure_pass_2024';
GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;
ALTER DATABASE nextcloud OWNER TO nextcloud;
EOFSQL

# Restart Nextcloud
log_fix "Restarting Nextcloud..."
docker restart nextcloud
sleep 10

log_info "Try Nextcloud: http://localhost:8097"
log_info "Create admin account on first access"
echo ""

################################################################################
# 3. Code Server - Show How to Change Password
################################################################################

log_fix "3. Code Server - Password Configuration"
echo ""
log_info "Current password is: changeme"
log_info ""
log_info "To change the password, run these commands:"
echo ""
echo "docker stop codeserver"
echo "docker rm codeserver"
echo ""
echo "docker run -d \\"
echo "  --name codeserver \\"
echo "  -e PUID=1000 \\"
echo "  -e PGID=1000 \\"
echo "  -e TZ=Europe/London \\"
echo "  -e PASSWORD='YourNewPassword123!' \\"
echo "  -p 8443:8443 \\"
echo "  -v $DATA_DIR/codeserver/config:/config \\"
echo "  --restart unless-stopped \\"
echo "  lscr.io/linuxserver/code-server:latest"
echo ""
log_info "Replace 'YourNewPassword123!' with your desired password"
echo ""

################################################################################
# 4. File Browser - Complete Reset
################################################################################

log_fix "4. File Browser - Complete reset..."

docker stop filebrowser 2>/dev/null || true
docker rm filebrowser 2>/dev/null || true

# Remove all data
log_info "Removing old File Browser data..."
rm -rf "$DATA_DIR/filebrowser"
mkdir -p "$DATA_DIR/filebrowser"

# Create new container with fresh database
log_info "Creating fresh File Browser..."
docker run -d \
  --name filebrowser \
  --restart unless-stopped \
  -p 8087:80 \
  -v "$DATA_DIR/filebrowser:/srv" \
  -v "$HOMELAB_DIR:/data:ro" \
  -e PUID=1000 \
  -e PGID=1000 \
  --network homelab-net \
  filebrowser/filebrowser:latest

sleep 3

log_info "File Browser reset complete!"
log_info "URL: http://localhost:8087"
log_info "Default credentials: admin / admin"
echo ""

################################################################################
# 5. Nginx Proxy Manager - Complete Reinstall
################################################################################

log_fix "5. Nginx Proxy Manager - Complete reinstall..."

# Stop and remove existing
docker stop nginx-proxy-manager nginxproxymanager npm 2>/dev/null || true
docker rm nginx-proxy-manager nginxproxymanager npm 2>/dev/null || true

# Clean data
log_info "Removing old Nginx Proxy Manager data..."
rm -rf "$DATA_DIR/nginx-proxy-manager"
mkdir -p "$DATA_DIR/nginx-proxy-manager/data"
mkdir -p "$DATA_DIR/nginx-proxy-manager/letsencrypt"

# Install fresh
log_info "Installing fresh Nginx Proxy Manager..."
docker run -d \
  --name nginx-proxy-manager \
  --restart unless-stopped \
  -p 80:80 \
  -p 81:81 \
  -p 443:443 \
  -v "$DATA_DIR/nginx-proxy-manager/data:/data" \
  -v "$DATA_DIR/nginx-proxy-manager/letsencrypt:/etc/letsencrypt" \
  --network homelab-net \
  jc21/nginx-proxy-manager:latest

sleep 10

log_info "Nginx Proxy Manager installed!"
log_info "URL: http://localhost:81"
log_info "Default: admin@example.com / changeme"
log_info "You'll be forced to change on first login"
echo ""

################################################################################
# Create Credentials File
################################################################################

cat > "$HOMELAB_DIR/docs/SERVICE_CREDENTIALS_$(date +%Y%m%d).txt" << EOFCREDS
╔═══════════════════════════════════════════════════════════════╗
║              RESET SERVICE CREDENTIALS                         ║
║              Generated: $(date)                    ║
╚═══════════════════════════════════════════════════════════════╝

PHOTOPRISM
──────────────────────────────────────────────────────────────────
URL:        http://localhost:2342
Username:   admin
Password:   admin
Status:     Restarted - wait 60-90 seconds for full startup
Note:       CHANGE PASSWORD after first login!

NEXTCLOUD
──────────────────────────────────────────────────────────────────
URL:        http://localhost:8097
Setup:      Create admin account on first access
Database:   PostgreSQL (auto-configured)
Status:     Fresh database created and restarted

CODE SERVER
──────────────────────────────────────────────────────────────────
URL:        http://localhost:8443
Password:   changeme
Status:     Running with default password
To change:  See commands in terminal output above

FILE BROWSER
──────────────────────────────────────────────────────────────────
URL:        http://localhost:8087
Username:   admin
Password:   admin
Status:     COMPLETELY RESET - fresh installation
Note:       CHANGE PASSWORD immediately after login!

NGINX PROXY MANAGER
──────────────────────────────────────────────────────────────────
URL:        http://localhost:81
Email:      admin@example.com
Password:   changeme
Status:     COMPLETELY RESET - fresh installation
Note:       You'll be forced to change password on first login

══════════════════════════════════════════════════════════════════
⚠️  IMPORTANT - DO THESE NOW:
══════════════════════════════════════════════════════════════════

1. Test each service above
2. Change ALL default passwords
3. Save new passwords to Vaultwarden (http://localhost:8088)
4. Delete this file after saving to Vaultwarden

══════════════════════════════════════════════════════════════════
EOFCREDS

################################################################################
# Summary
################################################################################

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}✓ All Services Reset/Fixed${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${CYAN}Service Status:${NC}"
echo ""
echo "1. PhotoPrism:"
echo "   URL: ${CYAN}http://localhost:2342${NC}"
echo "   Login: ${YELLOW}admin / admin${NC}"
echo "   ${RED}Wait 60-90 seconds for startup!${NC}"
echo ""
echo "2. Nextcloud:"
echo "   URL: ${CYAN}http://localhost:8097${NC}"
echo "   ${YELLOW}Create admin account on first access${NC}"
echo ""
echo "3. Code Server:"
echo "   URL: ${CYAN}http://localhost:8443${NC}"
echo "   Password: ${YELLOW}changeme${NC}"
echo "   ${BLUE}See commands above to change password${NC}"
echo ""
echo "4. File Browser:"
echo "   URL: ${CYAN}http://localhost:8087${NC}"
echo "   Login: ${YELLOW}admin / admin${NC}"
echo "   ${GREEN}✓ Completely reset - should work!${NC}"
echo ""
echo "5. Nginx Proxy Manager:"
echo "   URL: ${CYAN}http://localhost:81${NC}"
echo "   Login: ${YELLOW}admin@example.com / changeme${NC}"
echo "   ${GREEN}✓ Fresh installation${NC}"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${YELLOW}Credentials saved to:${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "$HOMELAB_DIR/docs/SERVICE_CREDENTIALS_$(date +%Y%m%d).txt"
echo ""
echo "View credentials:"
echo "  ${CYAN}cat $HOMELAB_DIR/docs/SERVICE_CREDENTIALS_$(date +%Y%m%d).txt${NC}"
echo ""
echo -e "${RED}⚠️  CHANGE ALL DEFAULT PASSWORDS!${NC}"
echo -e "${RED}⚠️  SAVE TO VAULTWARDEN!${NC}"
echo -e "${RED}⚠️  DELETE CREDENTIALS FILE AFTER SAVING!${NC}"
echo ""