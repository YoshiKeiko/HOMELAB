#!/bin/bash

################################################################################
# Reset Duplicati Password
################################################################################

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }
log_warn() { echo -e "${MAGENTA}[!]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         RESET DUPLICATI PASSWORD                               ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

log_warn "This will reset Duplicati to fresh state (no password)"
echo ""
echo "Your backup job configurations will be DELETED."
echo "You'll need to reconfigure pCloud backup."
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""

log_step "Step 1: Stopping Duplicati..."
docker stop duplicati 2>/dev/null || true
log_info "Stopped"
echo ""

log_step "Step 2: Backing up current config..."
BACKUP_DIR="$HOME/HomeLab/Docker/Data/duplicati-backup-$(date +%Y%m%d-%H%M%S)"
cp -r "$HOME/HomeLab/Docker/Data/duplicati" "$BACKUP_DIR" 2>/dev/null || true
log_info "Backup saved to: $BACKUP_DIR"
echo ""

log_step "Step 3: Clearing Duplicati config..."
rm -rf "$HOME/HomeLab/Docker/Data/duplicati"
mkdir -p "$HOME/HomeLab/Docker/Data/duplicati"
log_info "Config cleared"
echo ""

log_step "Step 4: Starting Duplicati with fresh config..."
docker start duplicati
echo ""

log_info "Waiting 30 seconds for startup..."
for i in {30..1}; do
    echo -ne "\r${YELLOW}Starting in $i seconds...  ${NC}"
    sleep 1
done
echo -e "\r${GREEN}Duplicati is ready!                ${NC}"

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                  ✓ PASSWORD RESET COMPLETE                    ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

echo "Duplicati has been reset to fresh state!"
echo ""
echo "Access at: ${CYAN}http://localhost:8202${NC}"
echo ""
echo "✅ No password required now!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Open Duplicati: ${CYAN}http://localhost:8202${NC}"
echo ""
echo "2. (Optional) Set new password:"
echo "   Settings → Password → Enter new password → Save"
echo ""
echo "3. Configure pCloud backup:"
echo "   Add Backup → Configure new backup"
echo "   - Storage: WebDAV"
echo "   - Server: https://webdav.pcloud.com"
echo "   - Path: /HomeLab-Backups"
echo "   - Source: /source"
echo ""
echo "4. Complete guide:"
echo "   ${CYAN}open ~/HomeLab/docs/PCLOUD_BACKUP_COMPLETE_GUIDE.md${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Open browser
log_step "Opening Duplicati in browser..."
sleep 2
open http://localhost:8202 2>/dev/null || echo "Open manually: http://localhost:8202"

echo ""
log_info "Reset complete! Duplicati is ready to configure."
echo ""

# Create quick reference
cat > "$HOME/HomeLab/docs/DUPLICATI_ACCESS.txt" << EOFREF
╔═══════════════════════════════════════════════════════════════╗
║              DUPLICATI ACCESS INFORMATION                      ║
╚═══════════════════════════════════════════════════════════════╝

Access Duplicati:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

From M4 Mac:
  http://localhost:8202

From MacBook Air:
  http://M4-IP:8202

Password:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Default: None (no password)

To set password:
  1. Open Duplicati
  2. Settings (gear icon)
  3. Scroll to "User Interface"
  4. Set password
  5. Save
  6. Store in 1Password!

Important Keys:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Settings Encryption Key (for container):
   Stored in 1Password: "Duplicati Settings Encryption Key"
   
2. Web Interface Password (optional):
   Set in Settings, store in 1Password
   
3. Backup Encryption Passphrase (critical!):
   Set when creating backup job
   MUST store in 1Password - needed for restore!

Quick Commands:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Restart:
  docker restart duplicati

View logs:
  docker logs duplicati

Check status:
  docker ps | grep duplicati

Reset password (this script):
  ~/reset-duplicati-password.sh

═══════════════════════════════════════════════════════════════
Last reset: $(date)
═══════════════════════════════════════════════════════════════
EOFREF

echo "Access info saved to: ~/HomeLab/docs/DUPLICATI_ACCESS.txt"
echo ""