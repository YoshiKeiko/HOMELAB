#!/bin/bash

################################################################################
# Fix Duplicate Clients Section in AdGuard Config
# Removes duplicate and enables proper client identification
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
echo -e "${BLUE}Fixing AdGuard Configuration - Duplicate Clients Section${NC}"
echo ""

ADGUARD_CONFIG="/Volumes/HomeLab-4TB/Docker/Data/adguard/conf/AdGuardHome.yaml"

# Backup current broken config
BACKUP="${ADGUARD_CONFIG}.broken_duplicate_$(date +%Y%m%d_%H%M%S)"
cp "$ADGUARD_CONFIG" "$BACKUP"
print_success "Backed up broken config: $BACKUP"

# Remove everything after the first clients: section (the duplicate we added)
print_info "Removing duplicate clients section..."

# Find line number of FIRST clients: occurrence
FIRST_CLIENTS_LINE=$(grep -n "^clients:" "$ADGUARD_CONFIG" | head -1 | cut -d: -f1)

if [ -z "$FIRST_CLIENTS_LINE" ]; then
    print_error "Cannot find clients: section"
    exit 1
fi

print_info "First clients: section found at line $FIRST_CLIENTS_LINE"

# Keep everything up to and including the first clients section, remove the duplicate
head -n $((FIRST_CLIENTS_LINE - 1)) "$ADGUARD_CONFIG" > "${ADGUARD_CONFIG}.tmp"

# Add proper clients section
cat >> "${ADGUARD_CONFIG}.tmp" << 'EOF'
clients:
  runtime_sources:
    whois: true
    arp: true
    rdns: true
    dhcp: true
  persistent: []
EOF

# Replace config
mv "${ADGUARD_CONFIG}.tmp" "$ADGUARD_CONFIG"

print_success "Configuration fixed"

# Validate YAML syntax
print_info "Validating YAML syntax..."
if python3 -c "import yaml; yaml.safe_load(open('$ADGUARD_CONFIG'))" 2>/dev/null; then
    print_success "YAML syntax is valid"
else
    print_error "YAML validation failed - restoring backup"
    cp "$BACKUP" "$ADGUARD_CONFIG"
    exit 1
fi

# Restart AdGuard
print_info "Restarting AdGuard..."
docker restart adguard-home > /dev/null 2>&1

echo ""
print_info "Waiting for AdGuard to start..."
sleep 10

# Check if started successfully
if docker logs adguard-home 2>&1 | tail -20 | grep -q "error"; then
    print_error "AdGuard has errors - check logs"
    docker logs adguard-home --tail 30
    echo ""
    print_info "Restoring backup..."
    cp "$BACKUP" "$ADGUARD_CONFIG"
    docker restart adguard-home > /dev/null 2>&1
    exit 1
fi

# Test if accessible
print_info "Testing accessibility..."
sleep 3

if nc -zv 192.168.68.50 8084 2>&1 | grep -q succeeded; then
    print_success "Web interface: ACCESSIBLE"
else
    print_error "Web interface: NOT ACCESSIBLE"
fi

if nc -zv 192.168.68.50 53 2>&1 | grep -q succeeded; then
    print_success "DNS port: ACCESSIBLE"
else
    print_error "DNS port: NOT ACCESSIBLE"
fi

echo ""
print_success "Configuration fixed!"
echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo "1. Open: http://192.168.68.50:8084"
echo "2. Go to Query Log"
echo "3. From your phone, visit a website"
echo "4. You should now see real client IPs!"
echo ""