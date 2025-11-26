#!/bin/bash

################################################################################
# PCLOUD BACKUP AUTOMATION
# Backs up all Docker configs to pCloud
################################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     PCLOUD BACKUP SETUP                                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Configuration
BACKUP_DIR="$HOME/homelab-backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="homelab-config-$TIMESTAMP"

mkdir -p "$BACKUP_DIR/$BACKUP_NAME"

echo -e "${YELLOW}[1/5]${NC} Creating backup archive..."

# Backup Docker Compose files
echo "  → Docker Compose files"
mkdir -p "$BACKUP_DIR/$BACKUP_NAME/compose"
find ~/homelab/Docker -name "*.yml" -o -name "*.yaml" 2>/dev/null | while read file; do
    cp "$file" "$BACKUP_DIR/$BACKUP_NAME/compose/" 2>/dev/null || true
done

# Backup individual container configs (not data, just configs)
echo "  → Container configurations"
mkdir -p "$BACKUP_DIR/$BACKUP_NAME/configs"

CONTAINERS=(
    "adguard-home"
    "heimdall"
    "grafana"
    "prometheus"
    "nginx-proxy-manager"
    "vaultwarden"
    "homeassistant"
    "nodered"
)

for container in "${CONTAINERS[@]}"; do
    if docker ps --format "{{.Names}}" | grep -q "^${container}$"; then
        echo "    ✓ $container"
        docker exec "$container" tar czf - /config 2>/dev/null > "$BACKUP_DIR/$BACKUP_NAME/configs/${container}-config.tar.gz" 2>/dev/null || true
    fi
done

# Backup this script and handbook
echo "  → Scripts and documentation"
cp "$0" "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
cp ~/homelab-*.md "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
cp ~/homelab-*.sh "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true

# Create archive
echo ""
echo -e "${YELLOW}[2/5]${NC} Compressing backup..."
cd "$BACKUP_DIR"
tar czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"
BACKUP_SIZE=$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)
echo -e "${GREEN}✓ Backup created: ${BACKUP_SIZE}${NC}"

# Install pCloud CLI if not present
echo ""
echo -e "${YELLOW}[3/5]${NC} Checking pCloud CLI..."

if ! command -v pcloud &> /dev/null; then
    echo "  Installing pCloud CLI..."
    
    # Download and install pCloud CLI for macOS
    curl -L -o /tmp/pcloud https://p-def8.pcloud.com/cBZHNzLboZZJ37ZZZvAgjX7Z0ZydZZZZkZ5ZZZ0HZZo5ZkZvx0ZsHZGUZDUZikZzHZxUZqHZ7kZTHZEXZq9ZZaHZ01ZrcH0ZGJHZfsZR5H0aZ15ZkpfUZCjnx/pcloudcc

    chmod +x /tmp/pcloud
    sudo mv /tmp/pcloud /usr/local/bin/pcloud
    
    echo -e "${GREEN}✓ pCloud CLI installed${NC}"
else
    echo -e "${GREEN}✓ pCloud CLI already installed${NC}"
fi

echo ""
echo -e "${YELLOW}[4/5]${NC} Uploading to pCloud..."
echo ""
echo -e "${BLUE}ACTION REQUIRED:${NC}"
echo "1. Run: ${GREEN}pcloud${NC}"
echo "2. Login with your pCloud credentials"
echo "3. Run: ${GREEN}pcloud upload ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz /HomeLab-Backups/${NC}"
echo ""
echo "Or use the pCloud web interface:"
echo "  1. Go to https://my.pcloud.com"
echo "  2. Create folder: HomeLab-Backups"
echo "  3. Upload: $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
echo ""

# Create automation script
echo -e "${YELLOW}[5/5]${NC} Creating automated backup script..."

cat > ~/homelab/Scripts/auto-backup-pcloud.sh << 'AUTO_END'
#!/bin/bash
# Automated pCloud Backup
# Run this daily via cron: 0 2 * * * ~/homelab/Scripts/auto-backup-pcloud.sh

BACKUP_DIR="$HOME/homelab-backups"
TIMESTAMP=$(date +%Y%m%d)
BACKUP_NAME="homelab-config-$TIMESTAMP"

mkdir -p "$BACKUP_DIR/$BACKUP_NAME"

# Backup compose files
find ~/homelab/Docker -name "*.yml" -o -name "*.yaml" 2>/dev/null | while read file; do
    cp "$file" "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
done

# Backup key configs
for container in adguard-home heimdall grafana prometheus nginx-proxy-manager; do
    if docker ps --format "{{.Names}}" | grep -q "^${container}$"; then
        docker exec "$container" tar czf - /config 2>/dev/null > "$BACKUP_DIR/$BACKUP_NAME/${container}.tar.gz" 2>/dev/null || true
    fi
done

# Compress
cd "$BACKUP_DIR"
tar czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"
rm -rf "$BACKUP_NAME"

# Upload to pCloud (after you've configured pcloud CLI)
# pcloud upload "${BACKUP_NAME}.tar.gz" /HomeLab-Backups/

# Keep only last 7 days
find "$BACKUP_DIR" -name "homelab-config-*.tar.gz" -mtime +7 -delete

echo "Backup complete: ${BACKUP_NAME}.tar.gz"
AUTO_END

chmod +x ~/homelab/Scripts/auto-backup-pcloud.sh

echo -e "${GREEN}✓ Automated backup script created${NC}"
echo ""
echo -e "${BLUE}To schedule daily backups:${NC}"
echo "  crontab -e"
echo "  Add: ${GREEN}0 2 * * * ~/homelab/Scripts/auto-backup-pcloud.sh${NC}"
echo ""

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     BACKUP COMPLETE                                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Backup Location:${NC} $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
echo -e "${GREEN}Backup Size:${NC} $BACKUP_SIZE"
echo ""

