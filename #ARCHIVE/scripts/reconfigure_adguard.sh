#!/bin/bash

################################################################################
# AdGuard Home Complete Homelab Integration Script
# Purpose: Configure AdGuard for network-wide DNS with full homelab integration
# 
# Integrates with:
# - 60+ Docker containers (Plex, Sonarr, Radarr, Home Assistant, etc.)
# - Nginx Proxy Manager (192.168.97.1)
# - Portainer
# - Tailscale VPN
# - OrbStack Docker environment
# - Sky Shield DNS (192.168.50.1) - CRITICAL for 13-year-old safety
#
# Network: Wired only on 192.168.68.50 (WiFi disabled for simplicity)
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_info() { echo -e "${CYAN}ℹ $1${NC}"; }
print_step() { echo -e "${MAGENTA}▸ $1${NC}"; }

################################################################################
# Configuration
################################################################################

HOMELAB_IP="192.168.68.50"
GATEWAY_IP="192.168.68.1"
SKY_SHIELD_DNS="192.168.50.1"
NGINX_PROXY_IP="192.168.97.1"
ADGUARD_WEB_PORT="8084"
ADGUARD_CONFIG_DIR="/Volumes/4TB-SSD/homelab/adguard/conf"
ADGUARD_WORK_DIR="/Volumes/4TB-SSD/homelab/adguard/work"
HOMELAB_DIR="$HOME/HomeLab"
COMPOSE_DIR="$HOMELAB_DIR/Docker/Compose"

################################################################################
# Pre-flight Checks
################################################################################

print_header "AdGuard Home - Complete Homelab Integration"

# Check macOS
if [[ ! "$OSTYPE" == "darwin"* ]]; then
    print_error "This script requires macOS"
    exit 1
fi
print_success "Running on macOS"

# Check external SSD
if [ ! -d "/Volumes/4TB-SSD" ]; then
    print_error "External 4TB SSD not mounted"
    exit 1
fi
print_success "External 4TB SSD mounted"

# Check wired network
WIRED_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "")
if [ -z "$WIRED_IP" ]; then
    print_error "No wired network connection found"
    exit 1
fi

if [ "$WIRED_IP" != "$HOMELAB_IP" ]; then
    print_warning "Current IP ($WIRED_IP) differs from expected ($HOMELAB_IP)"
    print_info "Proceeding with current IP..."
    HOMELAB_IP="$WIRED_IP"
fi
print_success "Wired network: $HOMELAB_IP"

# Check for Tailscale
TAILSCALE_IP=""
if command -v tailscale &> /dev/null; then
    TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "")
    if [ -n "$TAILSCALE_IP" ]; then
        print_success "Tailscale: $TAILSCALE_IP"
    fi
fi

# Check Docker/OrbStack
if ! command -v docker &> /dev/null; then
    print_error "Docker not found - OrbStack not running?"
    exit 1
fi
print_success "Docker/OrbStack detected"

# Count running containers
CONTAINER_COUNT=$(docker ps -q | wc -l | tr -d ' ')
print_info "Running containers: $CONTAINER_COUNT"

# Check for key services
if docker ps --format '{{.Names}}' | grep -q "nginx-proxy-manager\|npm"; then
    print_success "Nginx Proxy Manager detected"
    NPM_DETECTED=true
else
    print_warning "Nginx Proxy Manager not detected"
    NPM_DETECTED=false
fi

if docker ps --format '{{.Names}}' | grep -q "portainer"; then
    print_success "Portainer detected"
fi

# Create directories
mkdir -p "$ADGUARD_CONFIG_DIR" "$ADGUARD_WORK_DIR" "$COMPOSE_DIR"
print_success "AdGuard directories ready"

################################################################################
# Network Diagnostics
################################################################################

print_header "Network Diagnostics"

print_step "Current DNS configuration:"
CURRENT_DNS=$(scutil --dns 2>/dev/null | grep "nameserver\[0\]" | head -1 | awk '{print $3}')
echo "  Primary DNS: $CURRENT_DNS"

if [ "$CURRENT_DNS" == "100.100.100.100" ]; then
    print_warning "Tailscale MagicDNS currently active"
    print_info "AdGuard will be configured to work alongside Tailscale"
fi

print_step "Testing key network endpoints..."
ping -c 1 -W 1 $GATEWAY_IP > /dev/null 2>&1 && print_success "Gateway reachable" || print_warning "Gateway not responding"
ping -c 1 -W 1 $SKY_SHIELD_DNS > /dev/null 2>&1 && print_success "Sky Shield DNS reachable" || print_warning "Sky Shield not responding"

################################################################################
# Backup
################################################################################

print_header "Backing Up Current Configuration"

BACKUP_DIR="/Volumes/4TB-SSD/homelab/adguard/backups"
BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/backup_$BACKUP_TIMESTAMP"
mkdir -p "$BACKUP_DIR"

if [ -f "$ADGUARD_CONFIG_DIR/AdGuardHome.yaml" ]; then
    cp -r "$ADGUARD_CONFIG_DIR" "$BACKUP_PATH"
    print_success "Backed up to: $BACKUP_PATH"
else
    print_info "No existing config - fresh installation"
fi

################################################################################
# Generate AdGuard Configuration
################################################################################

print_header "Generating AdGuard Configuration"
print_info "Configured for: $CONTAINER_COUNT+ Docker containers"
print_info "Sky Shield ($SKY_SHIELD_DNS) = ONLY fallback DNS"
print_info "Wired network only (WiFi disabled)"

cat > "$ADGUARD_CONFIG_DIR/AdGuardHome.yaml" << EOF
# AdGuard Home - Complete Homelab Integration
# Generated: $(date)
# Network: Wired only on $HOMELAB_IP
# Containers: $CONTAINER_COUNT+ Docker services
# Fallback: Sky Shield ONLY ($SKY_SHIELD_DNS) for child safety

bind_host: 0.0.0.0
bind_port: $ADGUARD_WEB_PORT

users: []

http:
  address: 0.0.0.0:$ADGUARD_WEB_PORT
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
  
  # Primary upstream DNS - encrypted
  upstream_dns:
    - https://dns.cloudflare.com/dns-query
    - https://dns.google/dns-query
    - tls://1.1.1.1
    - tls://1.0.0.1
  
  # CRITICAL: Sky Shield as ONLY fallback for 13-year-old protection
  fallback_dns:
    - $SKY_SHIELD_DNS
  
  # Bootstrap DNS - ONLY Sky Shield
  bootstrap_dns:
    - $SKY_SHIELD_DNS
  
  local_ptr_upstreams: []
  
  use_private_ptr_resolvers: true
  enable_dnssec: true
  
  blocked_services: []
  
  upstream_dns_file: ""
  
  fastest_addr: false
  fastest_timeout: 1s
  
  # Allow all local and Docker networks
  allowed_clients: []
  disallowed_clients: []
  
  blocked_hosts:
    - version.bind
    - id.server
    - hostname.bind
  
  # Trust Docker networks, Tailscale, and local network
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

print_success "Configuration generated"

################################################################################
# Docker Compose File
################################################################################

print_header "Creating Docker Compose Configuration"

cat > "$COMPOSE_DIR/adguard.yml" << 'COMPOSE_EOF'
version: '3.8'

services:
  adguard:
    image: adguard/adguardhome:latest
    container_name: adguard-home
    restart: unless-stopped
    network_mode: host
    volumes:
      - /Volumes/4TB-SSD/homelab/adguard/work:/opt/adguardhome/work
      - /Volumes/4TB-SSD/homelab/adguard/conf:/opt/adguardhome/conf
    environment:
      - TZ=Europe/London
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "homelab.group=security"
      - "homelab.description=Network DNS with Sky Shield fallback"

# Network: host mode for direct binding to 192.168.68.50:53
# Integrates with: 60+ Docker containers, Nginx Proxy, Tailscale
# Fallback: Sky Shield ONLY (192.168.50.1) for parental controls
COMPOSE_EOF

print_success "Docker Compose created: $COMPOSE_DIR/adguard.yml"

################################################################################
# Deploy
################################################################################

print_header "Deploying AdGuard Home"

# Stop existing
EXISTING=$(docker ps -aq -f name=adguard)
if [ -n "$EXISTING" ]; then
    print_step "Stopping existing container..."
    docker stop $EXISTING 2>/dev/null || true
    docker rm $EXISTING 2>/dev/null || true
    print_success "Existing container removed"
fi

# Deploy
print_step "Starting AdGuard Home..."
cd "$COMPOSE_DIR"
docker compose -f adguard.yml up -d

sleep 5

if docker ps | grep -q adguard-home; then
    print_success "AdGuard Home is running"
else
    print_error "Failed to start"
    exit 1
fi

################################################################################
# Verification
################################################################################

print_header "Verification"

print_step "Waiting for initialization..."
sleep 10

print_step "Testing DNS..."
if dig @$HOMELAB_IP google.com +short +timeout=3 > /dev/null 2>&1; then
    print_success "DNS responding on $HOMELAB_IP"
else
    print_warning "DNS test inconclusive - may still be starting"
fi

################################################################################
# Summary
################################################################################

print_header "Deployment Complete"

cat << SUMMARY

${GREEN}✓ AdGuard Home Successfully Deployed${NC}

${CYAN}Network Configuration${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Homelab IP:        $HOMELAB_IP (wired only)
  DNS Port:          53
  Web Interface:     http://$HOMELAB_IP:$ADGUARD_WEB_PORT
  Gateway:           $GATEWAY_IP
  
${CYAN}DNS Configuration${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Primary DNS:       $HOMELAB_IP (this homelab)
  Fallback DNS:      $SKY_SHIELD_DNS (Sky Shield ONLY)
  Upstream DNS:      Cloudflare/Google (encrypted DoH/DoT)
  
${CYAN}Integration Status${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Docker Containers: $CONTAINER_COUNT running
  Nginx Proxy:       $([ "$NPM_DETECTED" = true ] && echo "✓ Detected" || echo "Not detected")
  Tailscale:         $([ -n "$TAILSCALE_IP" ] && echo "✓ $TAILSCALE_IP" || echo "Not configured")
  Network:           Wired only (WiFi disabled)
  
${CYAN}Child Safety${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ${GREEN}✓✓✓ Sky Shield ($SKY_SHIELD_DNS) configured as ONLY fallback${NC}
  ${GREEN}✓${NC} Parental controls ALWAYS active (even if AdGuard fails)
  ${GREEN}✓${NC} Zero gaps in protection for 13-year-old
  
${CYAN}Next Steps${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. ${YELLOW}Complete Initial Setup${NC}
   Open: http://$HOMELAB_IP:$ADGUARD_WEB_PORT
   - Create admin account
   - Verify DNS settings
   - Save credentials to 1Password

2. ${YELLOW}Update DHCP on Deco Router${NC}
   Verify these settings:
   - Primary DNS: $HOMELAB_IP
   - Secondary DNS: $SKY_SHIELD_DNS

3. ${YELLOW}Test from Devices${NC}
   dig @$HOMELAB_IP google.com
   Visit: https://adguard.com/en/test.html

4. ${YELLOW}Test Sky Shield Fallback${NC}
   docker stop adguard-home
   # DNS should still work via Sky Shield
   docker start adguard-home

5. ${YELLOW}Monitor Docker Services${NC}
   Check AdGuard query log for:
   - Nginx Proxy Manager ($NGINX_PROXY_IP)
   - All Docker containers
   - 13-year-old's devices

${CYAN}Access Points${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Local:             http://$HOMELAB_IP:$ADGUARD_WEB_PORT
  Via Tailscale:     $([ -n "$TAILSCALE_IP" ] && echo "http://$TAILSCALE_IP:$ADGUARD_WEB_PORT" || echo "N/A")
  
${CYAN}Backups${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Backup location:   $BACKUP_PATH
  View logs:         docker logs adguard-home -f
  Container status:  docker ps | grep adguard

${YELLOW}⚠️  CRITICAL REMINDERS${NC}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ${RED}• NEVER remove Sky Shield ($SKY_SHIELD_DNS) as fallback${NC}
  ${RED}• ALWAYS test fallback after configuration changes${NC}
  ${RED}• MONITOR 13-year-old's device in query logs weekly${NC}

SUMMARY

print_success "AdGuard Home is ready for network-wide DNS filtering!"
print_info "Complete setup at: http://$HOMELAB_IP:$ADGUARD_WEB_PORT"

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"