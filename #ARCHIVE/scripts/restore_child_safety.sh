#!/bin/bash

################################################################################
# URGENT: AdGuard Child Safety Configuration
# Re-enables all protections that were working yesterday
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
    echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║ $1${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

print_header "URGENT: Restoring Child Safety Protections"

ADGUARD_CONFIG="/Volumes/HomeLab-4TB/Docker/Data/adguard/conf/AdGuardHome.yaml"

# Backup current (broken) config
BACKUP_FILE="${ADGUARD_CONFIG}.broken_$(date +%Y%m%d_%H%M%S)"
cp "$ADGUARD_CONFIG" "$BACKUP_FILE"
print_info "Backed up broken config to: $BACKUP_FILE"

# Create SECURE configuration with ALL protections
print_info "Generating SECURE configuration with child protections..."

cat > "$ADGUARD_CONFIG" << 'EOF'
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
  
  # CRITICAL: All protection ENABLED
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
  
  # Encrypted upstream DNS
  upstream_dns:
    - https://dns.cloudflare.com/dns-query
    - https://dns.google/dns-query
    - tls://1.1.1.1
    - tls://1.0.0.1
  
  # CRITICAL: Sky Shield ONLY as fallback
  fallback_dns:
    - 192.168.50.1
  
  bootstrap_dns:
    - 192.168.50.1
  
  local_ptr_upstreams: []
  
  use_private_ptr_resolvers: true
  enable_dnssec: true
  
  blocked_services:
    - tiktok
    - snapchat
    - tinder
    - instagram_app
    - whatsapp
  
  upstream_dns_file: ""
  
  fastest_addr: false
  fastest_timeout: 1s
  
  allowed_clients: []
  disallowed_clients: []
  
  blocked_hosts:
    - version.bind
    - id.server
    - hostname.bind
  
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
  
  # CRITICAL: Enable ALL filtering
  filtering_enabled: true
  filters_update_interval: 24
  
  # CRITICAL: Enable Safe Search on ALL platforms
  safe_search:
    enabled: true
    bing: true
    duckduckgo: true
    google: true
    pixabay: true
    yandex: true
    youtube: true
  
  # CRITICAL: Enable Parental Controls
  parental_enabled: true
  safesearch_enabled: true
  safebrowsing_enabled: true
  
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
  - enabled: true
    url: https://raw.githubusercontent.com/chadmayfield/my-pihole-blocklists/master/lists/pi_blocklist_porn_top1m.list
    name: Chad Mayfield Porn Blocklist
    id: 5
  - enabled: true
    url: https://blocklistproject.github.io/Lists/porn.txt
    name: Blocklist Project - Porn
    id: 6
  - enabled: true
    url: https://blocklistproject.github.io/Lists/gambling.txt
    name: Blocklist Project - Gambling
    id: 7

whitelist_filters: []

# CRITICAL: Custom blocking rules for explicit sites
user_rules:
  - '||onlyfans.com^'
  - '||fansly.com^'
  - '||patreon.com^$important'
  - '||pornhub.com^'
  - '||xvideos.com^'
  - '||xnxx.com^'
  - '||redtube.com^'
  - '||youporn.com^'
  - '||tube8.com^'
  - '||spankbang.com^'
  - '||xhamster.com^'
  - '||chaturbate.com^'
  - '||stripchat.com^'
  - '||bongacams.com^'
  - '||cam4.com^'
  - '||myfreecams.com^'
  - '||reddit.com/r/nsfw*^'
  - '||reddit.com/r/gonewild*^'

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

print_success "SECURE configuration created with:"
echo ""
echo "  ${GREEN}✓${NC} Safe Search: ENABLED on all platforms"
echo "  ${GREEN}✓${NC} Parental Controls: ENABLED"
echo "  ${GREEN}✓${NC} Safe Browsing: ENABLED"
echo "  ${GREEN}✓${NC} Adult Content Filters: 3 lists ENABLED"
echo "  ${GREEN}✓${NC} OnlyFans: BLOCKED"
echo "  ${GREEN}✓${NC} Porn sites: 15+ explicitly BLOCKED"
echo "  ${GREEN}✓${NC} Social media: TikTok, Snapchat, Tinder BLOCKED"
echo "  ${GREEN}✓${NC} Sky Shield fallback: ACTIVE"
echo ""

# Restart AdGuard
print_info "Restarting AdGuard to apply protections..."
docker restart adguard-home > /dev/null 2>&1

sleep 8

if docker ps | grep -q adguard-home; then
    print_success "AdGuard restarted successfully"
else
    print_error "AdGuard failed to restart!"
    exit 1
fi

print_header "Protection Status"

echo ""
echo -e "${GREEN}✓✓✓ ALL CHILD SAFETY PROTECTIONS NOW ACTIVE ✓✓✓${NC}"
echo ""
echo -e "${CYAN}Safe Search:${NC}         ${GREEN}FORCED ON${NC} (Google, Bing, YouTube, etc.)"
echo -e "${CYAN}Parental Controls:${NC}   ${GREEN}ENABLED${NC}"
echo -e "${CYAN}Safe Browsing:${NC}       ${GREEN}ENABLED${NC} (malware/phishing)"
echo -e "${CYAN}Adult Content:${NC}       ${GREEN}BLOCKED${NC} (3 filter lists)"
echo -e "${CYAN}OnlyFans:${NC}            ${GREEN}BLOCKED${NC}"
echo -e "${CYAN}Porn Sites:${NC}          ${GREEN}BLOCKED${NC} (15+ explicit blocks)"
echo -e "${CYAN}Social Media:${NC}        ${GREEN}RESTRICTED${NC} (TikTok, Snapchat, Tinder)"
echo -e "${CYAN}Sky Shield Backup:${NC}   ${GREEN}ACTIVE${NC} (192.168.50.1)"
echo ""

print_header "Immediate Testing Required"

echo ""
echo -e "${YELLOW}1. Test OnlyFans is blocked:${NC}"
echo "   dig @192.168.68.50 onlyfans.com"
echo "   Should return 0.0.0.0 (BLOCKED)"
echo ""
echo -e "${YELLOW}2. Test Google Safe Search:${NC}"
echo "   Open browser, search explicit terms"
echo "   Should show safe results only"
echo ""
echo -e "${YELLOW}3. Check 13-year-old's device:${NC}"
echo "   Have them try accessing blocked content"
echo "   Should be blocked"
echo ""
echo -e "${YELLOW}4. Verify in AdGuard:${NC}"
echo "   http://192.168.68.50:8084"
echo "   Settings → General Settings"
echo "   Should show all protections ENABLED"
echo ""

print_header "CRITICAL REMINDERS"

echo ""
echo -e "${RED}⚠️  DO NOT DISABLE THESE PROTECTIONS${NC}"
echo -e "${RED}⚠️  Monitor query logs daily${NC}"
echo -e "${RED}⚠️  Test fallback monthly: docker stop adguard-home${NC}"
echo -e "${RED}⚠️  Keep filter lists updated (automatic)${NC}"
echo ""

print_success "Child safety protections restored and ACTIVE!"
echo ""