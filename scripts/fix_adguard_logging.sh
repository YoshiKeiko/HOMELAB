#!/bin/bash

################################################################################
# Fix AdGuard Client IP Logging
# Makes query log show real device IPs instead of ::1 localhost
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║ $1${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

print_header "Fixing AdGuard Client IP Logging"

ADGUARD_CONFIG="/Volumes/HomeLab-4TB/Docker/Data/adguard/conf/AdGuardHome.yaml"

# Backup
BACKUP="${ADGUARD_CONFIG}.before_client_fix_$(date +%Y%m%d_%H%M%S)"
cp "$ADGUARD_CONFIG" "$BACKUP"
print_success "Backup: $BACKUP"

print_info "Updating configuration for proper client identification..."

# Add configuration to identify real client IPs
cat >> "$ADGUARD_CONFIG" << 'EOF'

# Client identification settings
clients:
  runtime_sources:
    whois: true
    arp: true
    rdns: true
    dhcp: true
  persistent: []
EOF

print_success "Configuration updated"

# Restart AdGuard
print_info "Restarting AdGuard..."
docker restart adguard-home > /dev/null 2>&1

sleep 8

if docker ps | grep -q adguard-home; then
    print_success "AdGuard restarted"
else
    print_error "Failed to restart"
    cp "$BACKUP" "$ADGUARD_CONFIG"
    docker restart adguard-home > /dev/null 2>&1
    exit 1
fi

print_header "Testing"

echo ""
print_info "From your phone, visit a website now"
print_info "Then check: http://192.168.68.50:8084/#logs"
echo ""
print_success "You should now see real device IPs in the query log!"
echo ""