#!/bin/bash

################################################################################
# AdGuard Network Connectivity Diagnostics
# Checks why devices aren't connecting to AdGuard
################################################################################

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
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

print_header "AdGuard Connectivity Diagnostics"

HOMELAB_IP="192.168.68.50"

## 1. Check if AdGuard container is running
print_info "Checking AdGuard container status..."
if docker ps | grep -q adguard-home; then
    print_success "AdGuard container is running"
else
    print_error "AdGuard container is NOT running!"
    echo "  Fix: docker start adguard-home"
    exit 1
fi

## 2. Check network mode
print_info "Checking network mode..."
NETWORK_MODE=$(docker inspect adguard-home --format '{{.HostConfig.NetworkMode}}')
if [ "$NETWORK_MODE" = "host" ]; then
    print_success "Network mode: host (correct)"
else
    print_error "Network mode: $NETWORK_MODE (should be 'host')"
fi

## 3. Check if port 53 is listening
print_info "Checking if DNS port 53 is listening..."
if lsof -nP -iTCP:53 -sTCP:LISTEN 2>/dev/null | grep -q .; then
    print_success "Port 53/TCP is listening"
    lsof -nP -iTCP:53 -sTCP:LISTEN 2>/dev/null | grep -v COMMAND
else
    print_warning "Port 53/TCP not detected (may need sudo)"
fi

if lsof -nP -iUDP:53 2>/dev/null | grep -q .; then
    print_success "Port 53/UDP is listening"
    lsof -nP -iUDP:53 2>/dev/null | head -3
else
    print_warning "Port 53/UDP not detected (may need sudo)"
fi

## 4. Check macOS Firewall status
print_info "Checking macOS Firewall..."
FIREWALL_STATUS=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null)
echo "  $FIREWALL_STATUS"

if echo "$FIREWALL_STATUS" | grep -q "enabled"; then
    print_warning "macOS Firewall is ENABLED - may be blocking DNS"
    print_info "Checking if Docker/AdGuard is allowed..."
    /usr/libexec/ApplicationFirewall/socketfilterfw --listapps 2>/dev/null | grep -i docker || echo "  Docker not in firewall rules"
fi

## 5. Test local DNS
print_info "Testing DNS from M4 itself..."
if dig @$HOMELAB_IP google.com +short +timeout=2 > /dev/null 2>&1; then
    print_success "DNS works from M4 (localhost)"
else
    print_error "DNS NOT working even from M4!"
fi

## 6. Test from network interface
print_info "Testing external network access to port 53..."
nc -zv $HOMELAB_IP 53 2>&1 | head -2

## 7. Check for other DNS services
print_info "Checking for conflicting DNS services..."
if pgrep -x "mDNSResponder" > /dev/null; then
    print_info "mDNSResponder running (normal for macOS)"
fi

if docker ps --format '{{.Names}}' | grep -qi "pihole\|unbound\|bind"; then
    print_warning "Other DNS containers detected!"
    docker ps --format '{{.Names}}' | grep -i "pihole\|unbound\|bind"
fi

## 8. Check AdGuard is actually listening
print_info "Checking AdGuard container logs..."
docker logs adguard-home 2>&1 | tail -20 | grep -i "listening\|started\|port\|bind" || echo "  (No relevant log entries)"

print_header "Network Configuration"

echo "M4 IP Address:"
ifconfig en0 2>/dev/null | grep "inet " | awk '{print "  "$2}' || echo "  Not found on en0"
ifconfig en1 2>/dev/null | grep "inet " | awk '{print "  "$2}' || echo "  Not found on en1"

echo ""
echo "AdGuard should be listening on: $HOMELAB_IP:53"
echo ""

print_header "Recommended Fixes"

echo ""
echo -e "${YELLOW}1. Disable macOS Firewall (Temporarily for testing):${NC}"
echo "   System Settings → Network → Firewall → Turn Off"
echo ""
echo -e "${YELLOW}2. Or Allow Docker through Firewall:${NC}"
echo "   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/Docker.app"
echo "   sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp /Applications/Docker.app"
echo ""
echo -e "${YELLOW}3. Check if port 53 is reachable from another device:${NC}"
echo "   From Android/iPhone: Install 'Network Analyzer' app"
echo "   Scan: $HOMELAB_IP port 53"
echo ""
echo -e "${YELLOW}4. Restart AdGuard with proper permissions:${NC}"
echo "   docker restart adguard-home"
echo ""
echo -e "${YELLOW}5. Check AdGuard web interface:${NC}"
echo "   http://$HOMELAB_IP:8084"
echo "   Settings → DNS Settings"
echo "   Verify 'Listen on all interfaces' is selected"
echo ""

print_header "Quick Tests from Android Device"

echo ""
echo "After making changes, test from your Android:"
echo ""
echo "1. Install 'DNS Lookup' or 'Network Tools' app"
echo "2. Set DNS server to: $HOMELAB_IP"
echo "3. Lookup: google.com"
echo "4. Should work if firewall fixed"
echo ""