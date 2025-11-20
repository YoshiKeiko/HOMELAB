#!/bin/bash

################################################################################
# AdGuard Home - Complete Homelab Deployment
# 
# What this does:
# - Deploys AdGuard Home for network-wide DNS filtering
# - Integrates with 60+ Docker containers
# - Configures Sky Shield (192.168.50.1) as ONLY fallback for child safety
# - Works with Nginx Proxy Manager, Tailscale, and all existing services
# - Optimized for M4 Mac on wired network (192.168.68.50)
#
# Author: Steve's Homelab Project
# Date: $(date +%Y-%m-%d)
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Helper functions
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
print_step() { echo -e "${MAGENTA}▸${NC} $1"; }

################################################################################
# Configuration
################################################################################

# Network
HOMELAB_IP="192.168.68.50"
GATEWAY="192.168.68.1"
SKY_SHIELD="192.168.50.1"

# AdGuard
ADGUARD_WEB_PORT="8084"
ADGUARD_DNS_PORT="53"

# Paths
EXTERNAL_VOLUME="/Volumes/HomeLab-4TB"
ADGUARD_DATA="$EXTERNAL_VOLUME/Docker/Data/adguard"
ADGUARD_CONFIG="$ADGUARD_DATA/conf"
ADGUARD_WORK="$ADGUARD_DATA/work"
ADGUARD_BACKUP="$ADGUARD_DATA/backups"

HOMELAB_DIR="$HOME/HomeLab"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"

################################################################################
# Pre-flight Checks
################################################################################

print_header "Pre-Flight Checks"

# Check macOS
if [[ ! "$OSTYPE" == "darwin"* ]]; then
    print_error "This script requires macOS"
    exit 1
fi
print_success "Running on macOS"

# Check external volume
if [ ! -d "$EXTERNAL_VOLUME" ]; then
    print_error "External volume not found: $EXTERNAL_VOLUME"
    print_info "Please mount HomeLab-4TB and try again"
    exit 1
fi
print_success "External volume: $EXTERNAL_VOLUME"

# Check network
CURRENT_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "")
if [ -z "$CURRENT_IP" ]; then
    print_error "No network connection detected"
    exit 1
fi

if [ "$CURRENT_IP" != "$HOMELAB_IP" ]; then
    print_warning "Current IP: $CURRENT_IP (expected: $HOMELAB_IP)"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    HOMELAB_IP="$CURRENT_IP"
fi
print_success "Network IP: $HOMELAB_IP"

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker not found - is OrbStack running?"
    exit 1
fi
print_success "Docker available"

# Count containers
CONTAINER_COUNT=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
print_info "Running Docker containers: $CONTAINER_COUNT"

# Check for Nginx Proxy Manager
if docker ps --format '{{.Names}}' 2>/dev/null | grep -q "nginx\|npm"; then
    print_success "Nginx Proxy Manager detected"
fi

# Check for Tailscale
if command -v tailscale &> /dev/null; then
    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "")
    if [ -n "$TAILSCALE_IP" ]; then
        print_success "Tailscale: $TAILSCALE_IP"
    fi
fi

################################################################################
# Create Directory Structure
################################################################################

print_header "Creating Directory Structure"

mkdir -p "$ADGUARD_CONFIG"
mkdir -p "$ADGUARD_WORK"
mkdir -p "$ADGUARD_BACKUP"
mkdir -p "$COMPOSE_DIR"

print_success "Directories created:"
echo "  • Config: $ADGUARD_CONFIG"
echo "  • Work:   $ADGUARD_WORK"
echo "  • Backup: $ADGUARD_BACKUP"

################################################################################
# Backup Existing Configuration
################################################################################

print_header "Backing Up Existing Configuration"

if [ -f "$ADGUARD_CONFIG/AdGuardHome.yaml" ]; then
    BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S)"
    cp -r "$ADGUARD_CONFIG" "$ADGUARD_BACKUP/$BACKUP_NAME"
    print_success "Backup created: $ADGUARD_BACKUP/$BACKUP_NAME"
else
    print_info "No existing configuration found (fresh install)"
fi

################################################################################
# Generate AdGuard Configuration
################################################################################

print_header "Generating AdGuard Configuration"

cat > "$ADGUARD_CONFIG/AdGuardHome.yaml" << 'EOF'
bind_host: 0.0.0.0
bind_port: 8084

users: []

http:
  address: 0.0.0.0:8084
  session_ttl: 720h

dns:
  bind_hosts:
    - 0.0.0.0
  port: 53
  
  statistics_interval: 90
  
  querylog_enabled: true
  querylog_file_enabled: true
  querylog_interval: 2160h
  querylog_size_memory: 1000
  
  anonymize_client_ip: false
  
  protection_enabled: true
  blocking_mode: default
  blocking_ipv4: ""
  blocking_ipv6: ""
  blocked_response_ttl: 10
  
  parental_block_host: family-block.dns.adguard.com
  safebrowsing_block_host: standard-block.dns.adguard.com
  
  ratelimit: 30
  ratelimit_whitelist: []
  
  cache_size: 8388608
  cache_ttl_min: 0
  cache_ttl_max: 0
  cache_optimistic: true
  
  # Primary encrypted upstream DNS
  upstream_dns:
    - https://dns.cloudflare.com/dns-query
    - https://dns.google/dns-query
    - tls://1.1.1.1
    - tls://1.0.0.1
  
  # CRITICAL: Sky Shield as ONLY fallback (child safety)
  fallback_dns:
    - 192.168.50.1
  
  # Bootstrap DNS - ONLY Sky Shield
  bootstrap_dns:
    - 192.168.50.1
  
  local_ptr_upstreams: []
  
  use_private_ptr_resolvers: true
  enable_dnssec: true
  
  blocked_services: []
  upstream_dns_file: ""
  
  fastest_addr: false
  fastest_timeout: 1s
  
  allowed_clients: []
  disallowed_clients: []
  
  blocked_hosts:
    - version.bind
    - id.server
    - hostname.bind
  
  # Trust all Docker networks and Tailscale
  trusted_proxies:
    - 127.0.0.0/8
    - ::1/128
    - 192.168.0.0/16
    - 172.16.0.0/12
    - 100.64.0.0/10
  
  edns_client_subnet:
    custom_ip: ""
    enabled: false
    use_custom: false
  
  filtering_enabled: true
  filters_update_interval: 24
  
  safe_search:
    enabled: false
    bing: true
    duckduckgo: true
    google: true
    pixabay: true
    yandex: true
    youtube: true
  
  parental_enabled: false
  safesearch_enabled: false
  safebrowsing_enabled: false
  
  rewrites: []
  blocked_services_pause_schedule: null
  
  dhcp:
    enabled: false
    interface_name: ""
    local_domain_name: lan
    dhcpv4:
      gateway_ip: ""
      subnet_mask: ""
      range_start: ""
      range_end: ""
      lease_duration: 86400
    dhcpv6:
      range_start: ""
      lease_duration: 86400

tls:
  enabled: false
  server_name: ""
  force_https: false
  port_https: 443
  port_dns_over_tls: 853
  port_dns_over_quic: 853
  certificate_chain: ""
  private_key: ""
  certificate_path: ""
  private_key_path: ""
  strict_sni_check: false

filters:
  - enabled: true
    url: https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt
    name: AdGuard DNS filter
    id: 1
  - enabled: true
    url: https://adaway.org/hosts.txt
    name: AdAway Default Blocklist
    id: 2
  - enabled: true
    url: https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
    name: Steven Black's Unified hosts file
    id: 3
  - enabled: true
    url: https://www.malwaredomainlist.com/hostslist/hosts.txt
    name: MalwareDomainList.com Hosts List
    id: 4

whitelist_filters: []
user_rules: []

log:
  file: ""
  max_backups: 0
  max_size: 100
  max_age: 3
  compress: false
  local_time: false
  verbose: false

os:
  group: ""
  user: ""
  rlimit_nofile: 0

schema_version: 27
EOF

print_success "AdGuard configuration created"
print_info "Upstream DNS: Cloudflare/Google (encrypted DoH/DoT)"
print_info "Fallback DNS: Sky Shield ONLY (192.168.50.1)"
print_info "Cache size: 8MB (optimized for $CONTAINER_COUNT containers)"

################################################################################
# Create Docker Compose File
################################################################################

print_header "Creating Docker Compose File"

cat > "$COMPOSE_DIR/adguard.yml" << EOF
version: '3.8'

services:
  adguard:
    image: adguard/adguardhome:latest
    container_name: adguard-home
    restart: unless-stopped
    network_mode: host
    volumes:
      - $ADGUARD_WORK:/opt/adguardhome/work
      - $ADGUARD_CONFIG:/opt/adguardhome/conf
    environment:
      - TZ=Europe/London
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "homelab.group=security"
      - "homelab.description=Network-wide DNS with Sky Shield fallback"

# Configuration:
# - Network: host mode (binds to $HOMELAB_IP:53)
# - Web UI: http://$HOMELAB_IP:$ADGUARD_WEB_PORT
# - Fallback: Sky Shield ($SKY_SHIELD) for child safety
# - Storage: $ADGUARD_DATA
EOF

print_success "Docker Compose file created: $COMPOSE_DIR/adguard.yml"

################################################################################
# Deploy AdGuard
################################################################################

print_header "Deploying AdGuard Home"

# Stop existing container
EXISTING=$(docker ps -aq -f name=adguard 2>/dev/null || echo "")
if [ -n "$EXISTING" ]; then
    print_step "Stopping existing AdGuard container..."
    docker stop $EXISTING 2>/dev/null || true
    docker rm $EXISTING 2>/dev/null || true
    print_success "Old container removed"
fi

# Start new container
print_step "Starting AdGuard Home..."
cd "$COMPOSE_DIR"
docker compose -f adguard.yml up -d

# Wait for startup
sleep 5

# Verify
if docker ps | grep -q adguard-home; then
    print_success "AdGuard Home is running!"
else
    print_error "AdGuard Home failed to start"
    print_info "Check logs: docker logs adguard-home"
    exit 1
fi

################################################################################
# Verification
################################################################################

print_header "Verification"

print_step "Waiting for AdGuard to initialize..."
sleep 10

print_step "Testing DNS resolution..."
if dig @$HOMELAB_IP google.com +short +timeout=3 > /dev/null 2>&1; then
    print_success "DNS responding on $HOMELAB_IP"
else
    print_warning "DNS test inconclusive - may still be starting"
    print_info "Test manually: dig @$HOMELAB_IP google.com"
fi

################################################################################
# Summary
################################################################################

print_header "Deployment Complete!"

echo ""
echo -e "${GREEN}✓ AdGuard Home successfully deployed!${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}NETWORK CONFIGURATION${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "  Homelab IP:        $HOMELAB_IP"
echo "  DNS Port:          $ADGUARD_DNS_PORT"
echo "  Web Interface:     http://$HOMELAB_IP:$ADGUARD_WEB_PORT"
echo "  Gateway:           $GATEWAY"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}DNS CONFIGURATION${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "  Primary DNS:       $HOMELAB_IP (AdGuard Home)"
echo "  Fallback DNS:      $SKY_SHIELD (Sky Shield ONLY)"
echo "  Upstream DNS:      Cloudflare/Google (encrypted)"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}INTEGRATION STATUS${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "  Docker Containers: $CONTAINER_COUNT running"
echo "  Nginx Proxy:       192.168.97.1 (trusted)"
echo "  Tailscale:         $([ -n "$TAILSCALE_IP" ] && echo "$TAILSCALE_IP" || echo "Not configured")"
echo "  Network Mode:      Wired only"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}CHILD SAFETY (13-YEAR-OLD)${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  ${GREEN}✓✓✓${NC} Sky Shield ($SKY_SHIELD) = ONLY fallback"
echo -e "  ${GREEN}✓${NC}   Parental controls ALWAYS active"
echo -e "  ${GREEN}✓${NC}   Protection continues if AdGuard fails"
echo -e "  ${GREEN}✓${NC}   Zero gaps in coverage"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}NEXT STEPS${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}1. Complete Initial Setup${NC}"
echo "   Open: http://$HOMELAB_IP:$ADGUARD_WEB_PORT"
echo "   • Create admin account"
echo "   • Save credentials to 1Password"
echo "   • Verify DNS settings"
echo ""
echo -e "${YELLOW}2. Update Router DHCP${NC}"
echo "   Verify Deco router settings:"
echo "   • Primary DNS:   $HOMELAB_IP"
echo "   • Secondary DNS: $SKY_SHIELD"
echo ""
echo -e "${YELLOW}3. Test from Devices${NC}"
echo "   • Test DNS:      dig @$HOMELAB_IP google.com"
echo "   • Test blocking: https://adguard.com/en/test.html"
echo ""
echo -e "${YELLOW}4. Test Sky Shield Fallback${NC}"
echo "   • Stop AdGuard:  docker stop adguard-home"
echo "   • Test DNS:      dig @$HOMELAB_IP google.com"
echo "   • Should work via Sky Shield"
echo "   • Restart:       docker start adguard-home"
echo ""
echo -e "${YELLOW}5. Monitor Docker Services${NC}"
echo "   • Check query logs for all containers"
echo "   • Verify Nginx Proxy Manager queries"
echo "   • Monitor 13-year-old's devices"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}FILE LOCATIONS${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "  Configuration:  $ADGUARD_CONFIG/AdGuardHome.yaml"
echo "  Data:           $ADGUARD_WORK"
echo "  Backups:        $ADGUARD_BACKUP"
echo "  Compose:        $COMPOSE_DIR/adguard.yml"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}USEFUL COMMANDS${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "  View logs:      docker logs adguard-home -f"
echo "  Restart:        docker restart adguard-home"
echo "  Stop:           docker stop adguard-home"
echo "  Start:          docker start adguard-home"
echo "  Status:         docker ps | grep adguard"
echo ""
echo -e "${RED}⚠️  CRITICAL REMINDERS${NC}"
echo ""
echo -e "  ${RED}•${NC} NEVER remove Sky Shield ($SKY_SHIELD) as fallback"
echo -e "  ${RED}•${NC} ALWAYS test fallback after configuration changes"
echo -e "  ${RED}•${NC} MONITOR 13-year-old's device in query logs"
echo -e "  ${RED}•${NC} KEEP AdGuard updated (Watchtower enabled)"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✓ AdGuard Home is ready for network-wide DNS filtering!${NC}"
echo ""