#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         FIX DUPLICATI / INSTALL IF MISSING                     ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

log_step "Step 1: Checking if Duplicati exists..."
echo ""

# Check if container exists
if docker ps -a 2>/dev/null | grep -q duplicati; then
    log_info "Duplicati container exists"
    
    # Check if running
    if docker ps 2>/dev/null | grep -q duplicati; then
        log_info "Container is running"
        
        # Check logs for errors
        echo ""
        echo "Recent logs:"
        docker logs duplicati --tail 20
        
        echo ""
        log_step "Restarting Duplicati to fix connection..."
        docker restart duplicati
        
        echo "Waiting 10 seconds..."
        sleep 10
        
        echo ""
        log_info "Try accessing now: http://localhost:8200"
        
    else
        log_error "Container exists but not running"
        echo ""
        log_step "Starting Duplicati..."
        docker start duplicati
        
        echo "Waiting 10 seconds..."
        sleep 10
        
        echo ""
        log_info "Try accessing: http://localhost:8200"
    fi
    
else
    log_error "Duplicati is NOT installed"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Installing Duplicati"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    log_step "Creating Duplicati container..."
    
    # Create data directory
    mkdir -p ~/HomeLab/Docker/Data/duplicati
    
    # Run Duplicati
    docker run -d \
      --name duplicati \
      --restart unless-stopped \
      --network homelab-net \
      -p 8200:8200 \
      -e PUID=1000 \
      -e PGID=1000 \
      -e TZ=Europe/London \
      -v ~/HomeLab/Docker/Data/duplicati:/config \
      -v ~/HomeLab/Docker/Data:/source \
      -v /Volumes/HomeLab-4TB:/backups \
      lscr.io/linuxserver/duplicati:latest
    
    if [ $? -eq 0 ]; then
        log_info "Duplicati installed successfully!"
        
        echo ""
        echo "Waiting 15 seconds for startup..."
        sleep 15
        
        echo ""
        log_info "Duplicati is ready!"
        echo ""
        echo "Access at: ${CYAN}http://localhost:8200${NC}"
        echo ""
        echo "Next steps:"
        echo "  1. Open http://localhost:8200"
        echo "  2. Follow pCloud backup guide"
        echo "  3. Configure automatic backups"
    else
        log_error "Failed to install Duplicati"
        echo "Check Docker is running"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Status Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Final check
if docker ps 2>/dev/null | grep -q duplicati; then
    log_info "Duplicati is running"
    echo ""
    echo "Container info:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "NAMES|duplicati"
    echo ""
    echo "Access: ${CYAN}http://localhost:8200${NC}"
    echo ""
    echo "If still not working:"
    echo "  1. Check logs: ${CYAN}docker logs duplicati${NC}"
    echo "  2. Restart: ${CYAN}docker restart duplicati${NC}"
    echo "  3. Check port not in use: ${CYAN}lsof -i :8200${NC}"
else
    log_error "Duplicati is not running"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check Docker: docker ps"
    echo "  2. Start manually: docker start duplicati"
    echo "  3. View logs: docker logs duplicati"
fi

echo ""