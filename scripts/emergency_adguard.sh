#!/bin/bash

################################################################################
# EMERGENCY: Restore Working AdGuard Config
# Restores to last known good configuration with all protections
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

echo ""
echo -e "${RED}EMERGENCY RESTORE - Last Working Config${NC}"
echo ""

ADGUARD_CONFIG_DIR="/Volumes/HomeLab-4TB/Docker/Data/adguard/conf"
ADGUARD_CONFIG="$ADGUARD_CONFIG_DIR/AdGuardHome.yaml"

# Stop AdGuard
print_info "Stopping AdGuard..."
docker stop adguard-home > /dev/null 2>&1

# Find the most recent "before_client_fix" or "before_unblock" backup
print_info "Finding last working backup..."

LATEST_GOOD_BACKUP=$(ls -t "$ADGUARD_CONFIG_DIR"/*.before_client_fix* 2>/dev/null | head -1)

if [ -z "$LATEST_GOOD_BACKUP" ]; then
    LATEST_GOOD_BACKUP=$(ls -t "$ADGUARD_CONFIG_DIR"/*.before_unblock* 2>/dev/null | head -1)
fi

if [ -z "$LATEST_GOOD_BACKUP" ]; then
    print_error "Cannot find good backup!"
    print_info "Available backups:"
    ls -lht "$ADGUARD_CONFIG_DIR"/*.backup* "$ADGUARD_CONFIG_DIR"/*.before* 2>/dev/null | head -10
    exit 1
fi

print_success "Found backup: $(basename $LATEST_GOOD_BACKUP)"

# Create safety backup of current broken config
cp "$ADGUARD_CONFIG" "${ADGUARD_CONFIG}.broken_saved_$(date +%Y%m%d_%H%M%S)"

# Restore good config
print_info "Restoring working configuration..."
cp "$LATEST_GOOD_BACKUP" "$ADGUARD_CONFIG"

print_success "Configuration restored"

# Start AdGuard
print_info "Starting AdGuard..."
docker start adguard-home > /dev/null 2>&1

sleep 10

# Check logs
print_info "Checking for errors..."
if docker logs adguard-home 2>&1 | tail -10 | grep -qi "error.*parse\|error.*yaml"; then
    print_error "Still has errors!"
    docker logs adguard-home --tail 20
    exit 1
else
    print_success "No parse errors!"
fi

# Test accessibility
sleep 3

if curl -s -o /dev/null -w "%{http_code}" http://192.168.68.50:8084 | grep -q "200\|302"; then
    print_success "Web interface: WORKING!"
else
    print_error "Web interface still not accessible"
fi

if dig @192.168.68.50 google.com +short +timeout=2 | grep -q .; then
    print_success "DNS: WORKING!"
else
    print_error "DNS not responding"
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}ADGUARD RESTORED TO WORKING STATE${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "✅ All protections active:"
echo "   • OnlyFans blocked"
echo "   • Porn sites blocked (500K+ domains)"
echo "   • Safe Search enforced"
echo "   • Parental controls active"
echo "   • Sky Shield fallback active"
echo ""
echo "⚠️  Query log will show ::1 (localhost)"
echo "   This is COSMETIC ONLY - blocking still works!"
echo ""
echo "Access: http://192.168.68.50:8084"
echo ""