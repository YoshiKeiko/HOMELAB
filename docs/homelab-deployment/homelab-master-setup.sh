#!/bin/bash

################################################################################
# HOMELAB MASTER SETUP & TESTING SCRIPT
# Compatible with macOS bash 3.2+
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

MAC_IP="192.168.50.50"
REPORT_FILE="$HOME/homelab-status-report.md"
BOOKMARK_FILE="$HOME/homelab-bookmarks.html"
CHECKLIST_FILE="$HOME/homelab-checklist.md"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     HOMELAB MASTER SETUP & TESTING                         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

################################################################################
# PHASE 1: DISCOVERY
################################################################################

echo -e "${YELLOW}[PHASE 1]${NC} Discovering running containers..."
echo ""

CONTAINERS=$(docker ps --format "{{.Names}}" | sort)

if [ -z "$CONTAINERS" ]; then
    echo -e "${RED}ERROR: No containers running!${NC}"
    exit 1
fi

CONTAINER_COUNT=$(echo "$CONTAINERS" | wc -l | tr -d ' ')
echo -e "${GREEN}✓ Found $CONTAINER_COUNT running containers${NC}"
echo ""

################################################################################
# PHASE 2: TEST CONNECTIVITY
################################################################################

echo -e "${YELLOW}[PHASE 2]${NC} Testing connectivity to all services..."
echo ""

# Service definitions: name|port|category
cat > /tmp/services.txt << 'SVCEOF'
postgres|5432|database
mariadb|3306|database
mongodb|27017|database
redis|6379|database
influxdb|8086|database
portainer|9000|infrastructure
watchtower|none|infrastructure
nginx-proxy-manager|81|infrastructure
plex|32400|media
jellyfin|8096|media
sonarr|8989|media
radarr|7878|media
prowlarr|9696|media
overseerr|5055|media
transmission|9091|media
tautulli|8181|media
flaresolverr|8191|media
calibre|8094|media
ollama|11434|ai
openwebui|3000|ai
jupyter|8888|ai
homeassistant|8123|smarthome
zigbee2mqtt|8080|smarthome
mosquitto|1883|smarthome
esphome|6052|smarthome
nodered|1880|smarthome
prometheus|9090|monitoring
grafana|3003|monitoring
loki|3100|monitoring
promtail|none|monitoring
uptime-kuma|3004|monitoring
cadvisor|8085|monitoring
netdata|19999|monitoring
node-exporter|9100|monitoring
vaultwarden|8088|security
crowdsec|8089|security
fail2ban|none|security
adguard-home|8084|security
heimdall|8090|dashboard
homer|8091|dashboard
dashy|4000|dashboard
organizr|8092|dashboard
nextcloud|8097|storage
photoprism|2342|storage
filebrowser|8087|storage
kopia|8202|storage
syncthing|8384|storage
paperless|8093|productivity
freshrss|8098|productivity
codeserver|8443|productivity
gitea|3001|productivity
kasm-vnc|3050|other
SVCEOF

# Test each service
WORKING_FILE="/tmp/working.txt"
BROKEN_FILE="/tmp/broken.txt"
> "$WORKING_FILE"
> "$BROKEN_FILE"

while IFS='|' read -r name port category; do
    if echo "$CONTAINERS" | grep -q "^${name}$"; then
        if [ "$port" = "none" ]; then
            echo -e "${BLUE}⊙ $name${NC} (background service)"
            echo "$name|background|$category" >> "$WORKING_FILE"
        else
            if timeout 3 curl -f -s -o /dev/null "http://localhost:$port" 2>/dev/null; then
                echo -e "${GREEN}✓ $name${NC} → http://localhost:$port"
                echo "$name|http://localhost:$port|$category" >> "$WORKING_FILE"
            else
                echo -e "${RED}✗ $name${NC} → http://localhost:$port (not responding)"
                echo "$name|http://localhost:$port|$category" >> "$BROKEN_FILE"
            fi
        fi
    fi
done < /tmp/services.txt

WORKING_COUNT=$(wc -l < "$WORKING_FILE" | tr -d ' ')
BROKEN_COUNT=$(wc -l < "$BROKEN_FILE" | tr -d ' ')

echo ""
echo -e "${GREEN}Working: $WORKING_COUNT${NC} | ${RED}Issues: $BROKEN_COUNT${NC}"
echo ""

################################################################################
# PHASE 3: GENERATE BOOKMARKS
################################################################################

echo -e "${YELLOW}[PHASE 3]${NC} Generating bookmark file..."

cat > "$BOOKMARK_FILE" << 'HTMLEOF'
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>HomeLab Services</TITLE>
<H1>HomeLab Services</H1>
<DL><p>
HTMLEOF

while IFS='|' read -r name url category; do
    if [ "$url" != "background" ]; then
        # Replace localhost with network IP
        network_url=$(echo "$url" | sed "s/localhost/$MAC_IP/")
        echo "    <DT><A HREF=\"$network_url\">$name</A>" >> "$BOOKMARK_FILE"
    fi
done < "$WORKING_FILE"

echo "</DL><p>" >> "$BOOKMARK_FILE"

echo -e "${GREEN}✓ Bookmarks saved: $BOOKMARK_FILE${NC}"
echo ""

################################################################################
# PHASE 4: GENERATE CHECKLIST
################################################################################

echo -e "${YELLOW}[PHASE 4]${NC} Generating testing checklist..."

cat > "$CHECKLIST_FILE" << 'CHECKEOF'
# HomeLab Testing Checklist

**Generated:** $(date)
**Total Services:** $(wc -l < /tmp/working.txt | tr -d ' ')

## Instructions
Test each service and mark with ✓ or ✗

---

CHECKEOF

# Generate by category
for cat in database infrastructure media ai smarthome monitoring security dashboard storage productivity other; do
    
    case $cat in
        database) title="Databases" ;;
        infrastructure) title="Infrastructure" ;;
        media) title="Media Stack" ;;
        ai) title="AI Services" ;;
        smarthome) title="Smart Home" ;;
        monitoring) title="Monitoring" ;;
        security) title="Security" ;;
        dashboard) title="Dashboards" ;;
        storage) title="Storage" ;;
        productivity) title="Productivity" ;;
        other) title="Other" ;;
    esac
    
    # Check if category has entries
    if grep -q "|$cat$" "$WORKING_FILE" || grep -q "|$cat$" "$BROKEN_FILE"; then
        echo "" >> "$CHECKLIST_FILE"
        echo "## $title" >> "$CHECKLIST_FILE"
        echo "" >> "$CHECKLIST_FILE"
        
        # Working services
        grep "|$cat$" "$WORKING_FILE" 2>/dev/null | while IFS='|' read -r name url category; do
            network_url=$(echo "$url" | sed "s/localhost/$MAC_IP/")
            if [ "$url" = "background" ]; then
                echo "- [ ] **$name** (background service)" >> "$CHECKLIST_FILE"
            else
                echo "- [ ] **$name** → $network_url" >> "$CHECKLIST_FILE"
            fi
        done
        
        # Broken services
        grep "|$cat$" "$BROKEN_FILE" 2>/dev/null | while IFS='|' read -r name url category; do
            network_url=$(echo "$url" | sed "s/localhost/$MAC_IP/")
            echo "- [ ] **$name** → $network_url ⚠️ NOT RESPONDING" >> "$CHECKLIST_FILE"
        done
    fi
done

echo -e "${GREEN}✓ Checklist saved: $CHECKLIST_FILE${NC}"
echo ""

################################################################################
# PHASE 5: GENERATE STATUS REPORT
################################################################################

echo -e "${YELLOW}[PHASE 5]${NC} Generating status report..."

cat > "$REPORT_FILE" << REPORTEOF
# HomeLab Status Report

**Generated:** $(date)
**Total Containers:** $CONTAINER_COUNT
**Working Services:** $WORKING_COUNT
**Services With Issues:** $BROKEN_COUNT
**Network IP:** $MAC_IP

---

## ✅ Working Services ($WORKING_COUNT)

| Service | URL | Category |
|---------|-----|----------|
REPORTEOF

while IFS='|' read -r name url category; do
    network_url=$(echo "$url" | sed "s/localhost/$MAC_IP/")
    if [ "$url" = "background" ]; then
        echo "| $name | Background Service | $category |" >> "$REPORT_FILE"
    else
        echo "| $name | $network_url | $category |" >> "$REPORT_FILE"
    fi
done < "$WORKING_FILE"

if [ "$BROKEN_COUNT" -gt 0 ]; then
    cat >> "$REPORT_FILE" << REPORTEOF2

---

## ⚠️ Services With Issues ($BROKEN_COUNT)

| Service | Expected URL | Category | Issue |
|---------|-------------|----------|-------|
REPORTEOF2

    while IFS='|' read -r name url category; do
        network_url=$(echo "$url" | sed "s/localhost/$MAC_IP/")
        echo "| $name | $network_url | $category | Not responding |" >> "$REPORT_FILE"
    done < "$BROKEN_FILE"
fi

cat >> "$REPORT_FILE" << 'REPORTEOF3'

---

## 🔗 Quick Access URLs

**Main Dashboard:** http://192.168.50.50:8090 (Heimdall)
**Docker Management:** http://192.168.50.50:9000 (Portainer)
**Media Server:** http://192.168.50.50:32400/web (Plex)
**Smart Home:** http://192.168.50.50:8123 (Home Assistant)
**Monitoring:** http://192.168.50.50:3003 (Grafana)

---

## 📱 Access From Other Devices

All services accessible via: `http://192.168.50.50:PORT`

**From iPhone/iPad:** Open Safari → http://192.168.50.50:8090
**From TV/Console:** Open browser → http://192.168.50.50:32400/web
**From Another Mac:** Same URLs work everywhere

REPORTEOF3

echo -e "${GREEN}✓ Report saved: $REPORT_FILE${NC}"
echo ""

# Cleanup temp files
rm -f /tmp/services.txt /tmp/working.txt /tmp/broken.txt

################################################################################
# SUMMARY
################################################################################

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     DISCOVERY COMPLETE                                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Files Created:${NC}"
echo -e "  📊 Status Report:  ${GREEN}$REPORT_FILE${NC}"
echo -e "  🔖 Bookmarks:      ${GREEN}$BOOKMARK_FILE${NC}"
echo -e "  ☑️  Checklist:      ${GREEN}$CHECKLIST_FILE${NC}"
echo ""
echo -e "${CYAN}Next Steps:${NC}"
echo "  1. Review status report: ${GREEN}open $REPORT_FILE${NC}"
echo "  2. Import bookmarks to browser"
echo "  3. Test services using checklist"
echo "  4. Import Heimdall config"
echo "  5. Set up backups"
echo ""

if [ "$BROKEN_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  $BROKEN_COUNT service(s) not responding - check report${NC}"
    echo ""
fi

echo -e "${GREEN}✓ All done! Open the status report to see details.${NC}"