#!/bin/bash

################################################################################
# Identify Service on Port 8087 and Get Login Credentials
################################################################################

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${YELLOW}[→]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

clear
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         IDENTIFY SERVICE ON PORT 8087                          ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

log_step "Step 1: Finding what's running on port 8087..."
echo ""

# Check what's listening on port 8087
PORT_INFO=$(lsof -i :8087 2>/dev/null || netstat -an | grep 8087 || echo "")

if [ -n "$PORT_INFO" ]; then
    echo "Port 8087 is in use:"
    echo "$PORT_INFO"
    echo ""
else
    log_error "Nothing found on port 8087"
    echo "Port might be closed or service not running."
    echo ""
fi

# Check Docker containers with port 8087
log_step "Step 2: Checking Docker containers..."
echo ""

CONTAINER_8087=$(docker ps --format '{{.Names}}\t{{.Ports}}' | grep 8087 || echo "")

if [ -n "$CONTAINER_8087" ]; then
    log_info "Found Docker container(s) using port 8087:"
    echo ""
    echo "$CONTAINER_8087"
    echo ""
    
    # Extract container name
    CONTAINER_NAME=$(echo "$CONTAINER_8087" | awk '{print $1}')
    log_info "Container name: $CONTAINER_NAME"
    echo ""
else
    log_error "No Docker containers found on port 8087"
    echo ""
fi

# Check all your compose files for port 8087
log_step "Step 3: Searching compose files..."
echo ""

COMPOSE_DIR="$HOME/HomeLab/Docker/Compose"

if [ -d "$COMPOSE_DIR" ]; then
    echo "Searching for 8087 in compose files:"
    grep -r "8087" "$COMPOSE_DIR" 2>/dev/null | grep -v ".backup" || echo "Not found in compose files"
    echo ""
fi

# Common services that use port 8087
log_step "Step 4: Common services on port 8087..."
echo ""

cat << 'EOFSERVICES'
Port 8087 is commonly used by:

1. InfluxDB (Database)
   - Default: admin/admin or root/root
   - Or may require setup on first access

2. Calibre-Web (eBook manager)
   - Default: admin/admin123

3. Code-Server (VS Code in browser)
   - Password in config file or logs

4. Custom service from your setup

EOFSERVICES

echo ""

# If container found, get more info
if [ -n "$CONTAINER_NAME" ]; then
    log_step "Step 5: Getting container details..."
    echo ""
    
    echo "Container: $CONTAINER_NAME"
    echo "Image: $(docker inspect -f '{{.Config.Image}}' "$CONTAINER_NAME" 2>/dev/null)"
    echo ""
    
    log_step "Step 6: Checking environment variables..."
    echo ""
    
    # Get env vars that might contain credentials
    docker inspect "$CONTAINER_NAME" | grep -A 50 "Env" | grep -E "(USER|PASS|ADMIN|TOKEN|SECRET|KEY)" | head -20 || echo "No credential variables found"
    echo ""
    
    log_step "Step 7: Checking container logs for credentials..."
    echo ""
    
    echo "Last 50 lines of logs (looking for passwords/setup info):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    docker logs "$CONTAINER_NAME" --tail 50 2>&1 | grep -i -E "(password|user|admin|login|credential|token|setup|initial)" || echo "No credential info in recent logs"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    log_step "Step 8: Common login methods for this service..."
    echo ""
    
    # Check if it's a known service
    IMAGE=$(docker inspect -f '{{.Config.Image}}' "$CONTAINER_NAME" 2>/dev/null)
    
    case "$IMAGE" in
        *influxdb*)
            cat << 'EOFINFLUX'
╔═══════════════════════════════════════════════════════════════╗
║                    INFLUXDB LOGIN                              ║
╚═══════════════════════════════════════════════════════════════╝

InfluxDB on port 8087 (RPC port) is NOT the web interface!

The web interface is usually on port 8086:
  http://localhost:8086

Login methods:
1. If first time: Create admin user on web interface
2. Check environment variables in compose file
3. Check logs for initial setup token

Common credentials:
- Username: admin
- Password: (set during initial setup)
- Or check: docker logs influxdb | grep -i password

EOFINFLUX
            ;;
            
        *calibre*)
            cat << 'EOFCALIBRE'
╔═══════════════════════════════════════════════════════════════╗
║                    CALIBRE-WEB LOGIN                           ║
╚═══════════════════════════════════════════════════════════════╝

Default credentials:
  Username: admin
  Password: admin123

If that doesn't work:
1. Check config file in container
2. Reset password via container shell
3. Check logs for setup info

EOFCALIBRE
            ;;
            
        *code-server*)
            cat << 'EOFCODE'
╔═══════════════════════════════════════════════════════════════╗
║                    CODE-SERVER LOGIN                           ║
╚═══════════════════════════════════════════════════════════════╝

Password location:
1. Check environment variable PASSWORD
2. Check ~/.config/code-server/config.yaml
3. Check docker logs for generated password

Get password:
  docker logs code-server | grep -i password

EOFCODE
            ;;
            
        *)
            echo "Unknown service. Check the documentation for:"
            echo "  Image: $IMAGE"
            echo "  Container: $CONTAINER_NAME"
            ;;
    esac
    
    echo ""
    log_step "Step 9: Credential recovery options..."
    echo ""
    
    cat << 'EOFRECOVERY'
╔═══════════════════════════════════════════════════════════════╗
║              CREDENTIAL RECOVERY METHODS                       ║
╚═══════════════════════════════════════════════════════════════╝

Method 1: Check compose file
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Look for environment variables in your compose file that set
username/password.

Method 2: Check container logs
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Many services print initial credentials or setup URLs on first run.

  docker logs CONTAINER_NAME | grep -i password
  docker logs CONTAINER_NAME --tail 200

Method 3: Check config files
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Access container and look at config files:

  docker exec -it CONTAINER_NAME bash
  cat /config/config.yaml
  cat /app/config.json

Method 4: Check 1Password
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
You might have saved the credentials in 1Password Teams.

Search for: "8087" or the service name

Method 5: Reset credentials
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Most services have a password reset method:

1. Stop container
2. Delete/rename config file
3. Restart container (triggers initial setup)
4. Set new credentials

Method 6: Recreate container
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Nuclear option (preserves data if volumes configured correctly):

  docker stop CONTAINER_NAME
  docker rm CONTAINER_NAME
  docker compose -f ~/HomeLab/Docker/Compose/FILE.yml up -d

EOFRECOVERY
    
    echo ""
    
    # Create service-specific recovery guide
    cat > "$HOME/HomeLab/docs/PORT_8087_SERVICE.txt" << EOFGUIDE
╔═══════════════════════════════════════════════════════════════╗
║              PORT 8087 SERVICE INFORMATION                     ║
╚═══════════════════════════════════════════════════════════════╝

Service: $CONTAINER_NAME
Image: $IMAGE
Port: 8087
URL: http://localhost:8087

Container Details:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
$(docker inspect "$CONTAINER_NAME" | grep -A 10 "Env" | head -15)

Quick Commands:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

View logs:
  docker logs $CONTAINER_NAME

View live logs:
  docker logs $CONTAINER_NAME -f

Access container shell:
  docker exec -it $CONTAINER_NAME bash
  # or
  docker exec -it $CONTAINER_NAME sh

Restart container:
  docker restart $CONTAINER_NAME

Check compose file:
  grep -A 20 "$CONTAINER_NAME" ~/HomeLab/Docker/Compose/*.yml

Environment variables:
  docker inspect $CONTAINER_NAME | grep -A 50 Env

Generated: $(date)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOFGUIDE
    
    log_info "Service info saved to: ~/HomeLab/docs/PORT_8087_SERVICE.txt"
    echo ""
fi

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    NEXT STEPS                                  ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

if [ -n "$CONTAINER_NAME" ]; then
    echo "1. ${CYAN}Check the logs for credentials:${NC}"
    echo "   docker logs $CONTAINER_NAME | grep -i password"
    echo ""
    
    echo "2. ${CYAN}Check environment variables:${NC}"
    echo "   docker inspect $CONTAINER_NAME | grep -A 50 Env"
    echo ""
    
    echo "3. ${CYAN}Access container to find config:${NC}"
    echo "   docker exec -it $CONTAINER_NAME bash"
    echo "   cat /config/*.yaml 2>/dev/null"
    echo ""
    
    echo "4. ${CYAN}Check your compose file:${NC}"
    echo "   grep -A 30 '$CONTAINER_NAME' ~/HomeLab/Docker/Compose/*.yml"
    echo ""
    
    echo "5. ${CYAN}Check 1Password:${NC}"
    echo "   Search for: '$CONTAINER_NAME' or '8087'"
    echo ""
else
    echo "Port 8087 might not be in use or service is not running."
    echo ""
    echo "Check all running containers:"
    echo "  ${CYAN}docker ps${NC}"
    echo ""
    echo "Check all defined ports:"
    echo "  ${CYAN}grep -r '8087' ~/HomeLab/Docker/Compose/${NC}"
    echo ""
fi

echo ""