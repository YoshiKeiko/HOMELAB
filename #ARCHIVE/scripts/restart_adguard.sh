#!/bin/bash

################################################################################
# Emergency AdGuard Restart & Diagnostics
################################################################################

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
echo -e "${RED}Emergency AdGuard Recovery${NC}"
echo ""

# Check if container exists
print_info "Checking AdGuard container..."
if docker ps -a | grep -q adguard-home; then
    print_success "Container found"
    
    # Check if running
    if docker ps | grep -q adguard-home; then
        print_info "Container is running - checking logs..."
        echo ""
        echo "Last 20 log lines:"
        docker logs adguard-home --tail 20
        echo ""
        
        # Try restart
        print_info "Restarting AdGuard..."
        docker restart adguard-home
        sleep 8
    else
        print_error "Container is stopped!"
        print_info "Starting AdGuard..."
        docker start adguard-home
        sleep 8
    fi
else
    print_error "AdGuard container not found!"
    print_info "Need to redeploy - run: bash /home/claude/deploy-adguard.sh"
    exit 1
fi

# Verify it's running
echo ""
if docker ps | grep -q adguard-home; then
    print_success "AdGuard is now running!"
    
    # Check ports
    print_info "Checking if ports are accessible..."
    sleep 3
    
    if nc -zv 192.168.68.50 53 2>&1 | grep -q succeeded; then
        print_success "DNS port 53: OK"
    else
        print_error "DNS port 53: NOT ACCESSIBLE"
    fi
    
    if nc -zv 192.168.68.50 8084 2>&1 | grep -q succeeded; then
        print_success "Web port 8084: OK"
    else
        print_error "Web port 8084: NOT ACCESSIBLE"
    fi
    
    echo ""
    print_success "AdGuard should be accessible now!"
    echo ""
    echo "Web interface: http://192.168.68.50:8084"
    echo "DNS test: dig @192.168.68.50 google.com"
    
else
    print_error "AdGuard failed to start!"
    echo ""
    echo "Check logs:"
    docker logs adguard-home --tail 50
    exit 1
fi

echo ""