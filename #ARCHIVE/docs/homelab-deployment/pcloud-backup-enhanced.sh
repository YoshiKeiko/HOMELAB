#!/bin/bash

################################################################################
# ENHANCED PCLOUD BACKUP - Includes Obsidian Vault
################################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     ENHANCED HOMELAB BACKUP (with Obsidian Vault)         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Configuration
BACKUP_DIR="$HOME/homelab-backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="homelab-config-$TIMESTAMP"
OBSIDIAN_VAULT="$HOME/Documents/Obsidian"
OBSIDIAN_BACKUP_DIR="$OBSIDIAN_VAULT/BACKUPS"

mkdir -p "$BACKUP_DIR/$BACKUP_NAME"
mkdir -p "$OBSIDIAN_BACKUP_DIR"

echo -e "${YELLOW}[1/6]${NC} Backing up Docker configs..."

# Backup Docker Compose files
echo "  → Docker Compose files"
mkdir -p "$BACKUP_DIR/$BACKUP_NAME/compose"
find ~/homelab/Docker -name "*.yml" -o -name "*.yaml" 2>/dev/null | while read file; do
    cp "$file" "$BACKUP_DIR/$BACKUP_NAME/compose/" 2>/dev/null || true
done

# Backup container configs
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

# Backup scripts and docs
echo "  → Scripts and documentation"
cp "$0" "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
cp ~/homelab-*.md "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
cp ~/homelab-*.sh "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true

echo -e "${GREEN}✓ Docker configs backed up${NC}"
echo ""

# Backup Obsidian Vault
echo -e "${YELLOW}[2/6]${NC} Backing up Obsidian vault..."

if [ -d "$OBSIDIAN_VAULT" ]; then
    VAULT_BACKUP="$OBSIDIAN_BACKUP_DIR/vault-backup-$TIMESTAMP.zip"
    
    echo "  → Creating vault zip: vault-backup-$TIMESTAMP.zip"
    cd "$HOME/Documents"
    zip -r "$VAULT_BACKUP" Obsidian \
        -x "Obsidian/.obsidian/workspace*" \
        -x "Obsidian/.trash/*" \
        -x "Obsidian/BACKUPS/*" \
        > /dev/null 2>&1
    
    VAULT_SIZE=$(du -h "$VAULT_BACKUP" | cut -f1)
    echo "  → Vault backup size: $VAULT_SIZE"
    
    # Copy vault backup to main backup
    cp "$VAULT_BACKUP" "$BACKUP_DIR/$BACKUP_NAME/"
    
    echo -e "${GREEN}✓ Obsidian vault backed up${NC}"
else
    echo -e "${YELLOW}! Obsidian vault not found at $OBSIDIAN_VAULT${NC}"
fi
echo ""

# Create main archive
echo -e "${YELLOW}[3/6]${NC} Compressing all backups..."
cd "$BACKUP_DIR"
tar czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"
rm -rf "$BACKUP_NAME"

BACKUP_SIZE=$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)
echo -e "${GREEN}✓ Backup created: ${BACKUP_SIZE}${NC}"
echo ""

# Install pCloud CLI
echo -e "${YELLOW}[4/6]${NC} Checking pCloud CLI..."

if ! command -v pcloud &> /dev/null; then
    echo "  Installing pCloud CLI..."
    curl -L -o /tmp/pcloud https://p-def8.pcloud.com/cBZHNzLboZZJ37ZZZvAgjX7Z0ZydZZZZkZ5ZZZ0HZZo5ZkZvx0ZsHZGUZDUZikZzHZxUZqHZ7kZTHZEXZq9ZZaHZ01ZrcH0ZGJHZfsZR5H0aZ15ZkpfUZCjnx/pcloudcc 2>/dev/null
    chmod +x /tmp/pcloud
    sudo mv /tmp/pcloud /usr/local/bin/pcloud
    echo -e "${GREEN}✓ pCloud CLI installed${NC}"
else
    echo -e "${GREEN}✓ pCloud CLI already installed${NC}"
fi
echo ""

# Upload instructions
echo -e "${YELLOW}[5/6]${NC} Upload to pCloud"
echo ""
echo -e "${BLUE}OPTION 1: Using pCloud CLI (Recommended)${NC}"
echo "  1. Login: ${GREEN}pcloud${NC}"
echo "  2. Enter your pCloud credentials"
echo "  3. Upload: ${GREEN}pcloud upload $BACKUP_DIR/${BACKUP_NAME}.tar.gz /HomeLab-Backups/${NC}"
echo ""
echo -e "${BLUE}OPTION 2: Using pCloud Web${NC}"
echo "  1. Go to: ${GREEN}https://my.pcloud.com${NC}"
echo "  2. Create folder: ${GREEN}HomeLab-Backups${NC}"
echo "  3. Upload: ${GREEN}$BACKUP_DIR/${BACKUP_NAME}.tar.gz${NC}"
echo ""

# Create automated backup script
echo -e "${YELLOW}[6/6]${NC} Creating automated backup script..."

mkdir -p ~/homelab/Scripts

cat > ~/homelab/Scripts/auto-backup-pcloud.sh << 'AUTO_END'
#!/bin/bash
# Automated pCloud Backup with Obsidian
# Run daily via cron: 0 2 * * * ~/homelab/Scripts/auto-backup-pcloud.sh

BACKUP_DIR="$HOME/homelab-backups"
TIMESTAMP=$(date +%Y%m%d)
BACKUP_NAME="homelab-config-$TIMESTAMP"
OBSIDIAN_VAULT="$HOME/Documents/Obsidian"
OBSIDIAN_BACKUP_DIR="$OBSIDIAN_VAULT/BACKUPS"

mkdir -p "$BACKUP_DIR/$BACKUP_NAME"
mkdir -p "$OBSIDIAN_BACKUP_DIR"

# Backup Docker configs
find ~/homelab/Docker -name "*.yml" -o -name "*.yaml" 2>/dev/null | while read file; do
    cp "$file" "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
done

# Backup key container configs
for container in adguard-home heimdall grafana prometheus nginx-proxy-manager homeassistant; do
    if docker ps --format "{{.Names}}" | grep -q "^${container}$"; then
        docker exec "$container" tar czf - /config 2>/dev/null > "$BACKUP_DIR/$BACKUP_NAME/${container}.tar.gz" 2>/dev/null || true
    fi
done

# Backup Obsidian vault
if [ -d "$OBSIDIAN_VAULT" ]; then
    VAULT_BACKUP="$OBSIDIAN_BACKUP_DIR/vault-backup-$TIMESTAMP.zip"
    cd "$HOME/Documents"
    zip -r "$VAULT_BACKUP" Obsidian \
        -x "Obsidian/.obsidian/workspace*" \
        -x "Obsidian/.trash/*" \
        -x "Obsidian/BACKUPS/*" \
        > /dev/null 2>&1
    cp "$VAULT_BACKUP" "$BACKUP_DIR/$BACKUP_NAME/"
fi

# Compress
cd "$BACKUP_DIR"
tar czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"
rm -rf "$BACKUP_NAME"

# Upload to pCloud (configure pcloud CLI first)
# pcloud upload "${BACKUP_NAME}.tar.gz" /HomeLab-Backups/

# Keep only last 7 days
find "$BACKUP_DIR" -name "homelab-config-*.tar.gz" -mtime +7 -delete
find "$OBSIDIAN_BACKUP_DIR" -name "vault-backup-*.zip" -mtime +7 -delete

echo "Backup complete: ${BACKUP_NAME}.tar.gz (includes Obsidian vault)"
AUTO_END

chmod +x ~/homelab/Scripts/auto-backup-pcloud.sh

echo -e "${GREEN}✓ Automated backup script created${NC}"
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     BACKUP COMPLETE                                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Backup Location:${NC} $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
echo -e "${GREEN}Backup Size:${NC} $BACKUP_SIZE"
echo -e "${GREEN}Obsidian Backup:${NC} $OBSIDIAN_BACKUP_DIR/vault-backup-$TIMESTAMP.zip ($VAULT_SIZE)"
echo ""
echo -e "${CYAN}What's Included:${NC}"
echo "  ✓ Docker Compose files"
echo "  ✓ Container configurations"
echo "  ✓ Scripts and documentation"
echo "  ✓ Obsidian vault (zipped)"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Upload backup to pCloud (see instructions above)"
echo "  2. Schedule automated backups:"
echo "     ${GREEN}crontab -e${NC}"
echo "     Add: ${GREEN}0 2 * * * ~/homelab/Scripts/auto-backup-pcloud.sh${NC}"
echo ""
echo -e "${YELLOW}Obsidian Vault Backups:${NC}"
echo "  Location: $OBSIDIAN_BACKUP_DIR"
echo "  Retention: Last 7 days"
echo "  Latest: vault-backup-$TIMESTAMP.zip"
echo ""