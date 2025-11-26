#!/bin/bash

################################################################################
# Enable IPv6 DNS in AdGuard Home
# Makes AdGuard respond to both IPv4 and IPv6 DNS queries
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

print_header "Enabling IPv6 DNS in AdGuard"

ADGUARD_CONFIG="/Volumes/HomeLab-4TB/Docker/Data/adguard/conf/AdGuardHome.yaml"

# Backup
BACKUP="${ADGUARD_CONFIG}.before_ipv6_$(date +%Y%m%d_%H%M%S)"
cp "$ADGUARD_CONFIG" "$BACKUP"
print_success "Backup: $BACKUP"

# Get IPv6 address
print_info "Detecting IPv6 address..."
IPV6_ADDR=$(ifconfig en0 2>/dev/null | grep "inet6 " | grep -v "fe80:" | grep -v "deprecated" | head -1 | awk '{print $2}')

if [ -z "$IPV6_ADDR" ]; then
    IPV6_ADDR=$(ifconfig en1 2>/dev/null | grep "inet6 " | grep -v "fe80:" | grep -v "deprecated" | head -1 | awk '{print $2}')
fi

if [ -n "$IPV6_ADDR" ]; then
    print_success "IPv6 address: $IPV6_ADDR"
else
    print_info "No IPv6 address found, will listen on :: (all IPv6)"
    IPV6_ADDR="::"
fi

# Update config to listen on both IPv4 and IPv6
print_info "Updating AdGuard configuration..."

# Change bind_hosts to include both IPv4 and IPv6
sed -i.tmp "s/bind_hosts:/bind_hosts:\n    - '::'/g" "$ADGUARD_CONFIG"

# Also ensure we're binding to 0.0.0.0 for IPv4
if ! grep -q "0.0.0.0" "$ADGUARD_CONFIG"; then
    sed -i.tmp "s/bind_hosts:/bind_hosts:\n    - 0.0.0.0/g" "$ADGUARD_CONFIG"
fi

rm -f "${ADGUARD_CONFIG}.tmp"

print_success "Configuration updated"

# Restart AdGuard
print_info "Restarting AdGuard Home..."
docker restart adguard-home > /dev/null 2>&1

sleep 8

if docker ps | grep -q adguard-home; then
    print_success "AdGuard restarted successfully"
else
    print_error "Failed to restart - restoring backup"
    cp "$BACKUP" "$ADGUARD_CONFIG"
    docker restart adguard-home > /dev/null 2>&1
    exit 1
fi

print_header "Verification"

print_info "AdGuard is now listening on:"
docker logs adguard-home 2>&1 | grep "listening to" | tail -4

echo ""
print_success "IPv6 DNS now enabled!"
echo ""
print_info "Test from your Android phone:"
echo "  1. Make sure connected to Deco WiFi"
echo "  2. Try accessing onlyfans.com"
echo "  3. Should be blocked!"
echo ""
print_info "Check AdGuard query log:"
echo "  http://192.168.68.50:8084"
echo "  You should now see IPv6 queries appearing"
echo ""