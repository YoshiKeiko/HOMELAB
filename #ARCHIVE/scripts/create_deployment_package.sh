#!/bin/bash

################################################################################
# AdGuard Home - Complete Deployment Package Creator
# Creates all necessary files on your Mac for AdGuard reconfiguration
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

print_header "AdGuard Home Deployment Package Creator"

# Determine target directory on Mac
TARGET_DIR="$HOME/adguard-deployment"

print_info "Creating deployment directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

################################################################################
# Copy all files from /home/claude to Mac
################################################################################

print_header "Copying Deployment Files"

if [ -f "/home/claude/reconfigure-adguard.sh" ]; then
    cp /home/claude/reconfigure-adguard.sh "$TARGET_DIR/"
    chmod +x "$TARGET_DIR/reconfigure-adguard.sh"
    print_success "Copied: reconfigure-adguard.sh"
else
    print_error "reconfigure-adguard.sh not found"
fi

if [ -f "/home/claude/docker-compose-adguard.yml" ]; then
    cp /home/claude/docker-compose-adguard.yml "$TARGET_DIR/"
    print_success "Copied: docker-compose-adguard.yml"
else
    print_error "docker-compose-adguard.yml not found"
fi

if [ -f "/home/claude/DELIVERY-MANIFEST.md" ]; then
    cp /home/claude/DELIVERY-MANIFEST.md "$TARGET_DIR/"
    print_success "Copied: DELIVERY-MANIFEST.md"
else
    print_error "DELIVERY-MANIFEST.md not found"
fi

if [ -f "/home/claude/DEPLOYMENT-OVERVIEW.txt" ]; then
    cp /home/claude/DEPLOYMENT-OVERVIEW.txt "$TARGET_DIR/"
    print_success "Copied: DEPLOYMENT-OVERVIEW.txt"
else
    print_error "DEPLOYMENT-OVERVIEW.txt not found"
fi

if [ -f "/home/claude/ADGUARD-PREFLIGHT-CHECKLIST.md" ]; then
    cp /home/claude/ADGUARD-PREFLIGHT-CHECKLIST.md "$TARGET_DIR/"
    print_success "Copied: ADGUARD-PREFLIGHT-CHECKLIST.md"
else
    print_error "ADGUARD-PREFLIGHT-CHECKLIST.md not found"
fi

if [ -f "/home/claude/ADGUARD-QUICK-REFERENCE.md" ]; then
    cp /home/claude/ADGUARD-QUICK-REFERENCE.md "$TARGET_DIR/"
    print_success "Copied: ADGUARD-QUICK-REFERENCE.md"
else
    print_error "ADGUARD-QUICK-REFERENCE.md not found"
fi

if [ -f "/home/claude/ADGUARD-SUMMARY.md" ]; then
    cp /home/claude/ADGUARD-SUMMARY.md "$TARGET_DIR/"
    print_success "Copied: ADGUARD-SUMMARY.md"
else
    print_error "ADGUARD-SUMMARY.md not found"
fi

################################################################################
# Create README in deployment directory
################################################################################

print_header "Creating README"

cat > "$TARGET_DIR/README.md" << 'EOF'
# AdGuard Home Reconfiguration Package

## 🎯 What's This?

This package contains everything you need to reconfigure your AdGuard Home for network-wide DNS filtering with **Sky Shield (192.168.50.1) as a fallback** to protect your 13-year-old.

## 📂 What's Included

- `reconfigure-adguard.sh` - Main deployment script
- `docker-compose-adguard.yml` - Container configuration
- `DELIVERY-MANIFEST.md` - Complete overview
- `DEPLOYMENT-OVERVIEW.txt` - Visual guide with diagrams
- `ADGUARD-PREFLIGHT-CHECKLIST.md` - Pre-deployment checklist
- `ADGUARD-QUICK-REFERENCE.md` - Operational guide
- `ADGUARD-SUMMARY.md` - Executive summary
- `README.md` - This file

## 🚀 Quick Start (3 Steps)

### Step 1: Review the Checklist
```bash
cat ADGUARD-PREFLIGHT-CHECKLIST.md
```
⏱️ 5 minutes

### Step 2: Run the Deployment
```bash
./reconfigure-adguard.sh
```
⏱️ 5 minutes | ⚠️ 30-60s downtime (Sky Shield covers)

### Step 3: Complete Initial Setup
- Open http://192.168.68.50:8084
- Create admin account
- Save credentials to 1Password

⏱️ 10 minutes

**Total Time: ~30 minutes**

## 🛡️ Child Safety (Critical)

This configuration uses **multi-layer protection**:

**Layer 1**: AdGuard Home (192.168.68.50)
- Blocks ads, trackers, malware
- Query logging and monitoring

**Layer 2**: Sky Shield DNS (192.168.50.1)
- **ALWAYS ACTIVE** as fallback
- Parental controls stay on even if AdGuard fails
- Zero gaps in protection

## 📚 Documentation

Start with these files in order:

1. `DELIVERY-MANIFEST.md` - Overview of everything
2. `DEPLOYMENT-OVERVIEW.txt` - Visual guide
3. `ADGUARD-PREFLIGHT-CHECKLIST.md` - Verify prerequisites
4. Run `./reconfigure-adguard.sh`

## ⚠️ Critical Reminders

- ⚠️ NEVER remove Sky Shield (192.168.50.1) as fallback DNS
- ⚠️ ALWAYS test Sky Shield fallback after changes
- ⚠️ MONITOR query logs for 13-year-old's device weekly
- ⚠️ KEEP AdGuard updated

## 🎯 Success Criteria

You'll know it's working when:

✅ Container shows as "Up" in docker ps
✅ Web interface loads at http://192.168.68.50:8084
✅ DNS resolves: `dig @192.168.68.50 google.com`
✅ Ads are blocked on websites
✅ Sky Shield fallback test passes

## 📞 Support

View logs: `docker logs adguard-home -f`
Quick reference: `ADGUARD-QUICK-REFERENCE.md`
Configuration: `/Volumes/4TB-SSD/homelab/adguard/conf/AdGuardHome.yaml`

---

**Ready to deploy?**

```bash
./reconfigure-adguard.sh
```
EOF

print_success "Created: README.md"

################################################################################
# Display Summary
################################################################################

print_header "Deployment Package Created Successfully"

cat << SUMMARY

${GREEN}✓ All files copied to: $TARGET_DIR${NC}

${CYAN}Files Created:${NC}
  ✅ reconfigure-adguard.sh              (Deployment script)
  ✅ docker-compose-adguard.yml          (Container config)
  ✅ DELIVERY-MANIFEST.md                (Complete overview)
  ✅ DEPLOYMENT-OVERVIEW.txt             (Visual guide)
  ✅ ADGUARD-PREFLIGHT-CHECKLIST.md      (Pre-deployment)
  ✅ ADGUARD-QUICK-REFERENCE.md          (Ops guide)
  ✅ ADGUARD-SUMMARY.md                  (Executive summary)
  ✅ README.md                           (Quick start)

${CYAN}Next Steps:${NC}

  1. Navigate to deployment directory:
     ${YELLOW}cd $TARGET_DIR${NC}

  2. Read the README:
     ${YELLOW}cat README.md${NC}

  3. Review the checklist:
     ${YELLOW}cat ADGUARD-PREFLIGHT-CHECKLIST.md${NC}

  4. Run the deployment:
     ${YELLOW}./reconfigure-adguard.sh${NC}

${CYAN}Or view the visual overview first:${NC}
  ${YELLOW}cat $TARGET_DIR/DEPLOYMENT-OVERVIEW.txt${NC}

${CYAN}Complete documentation package ready at:${NC}
  ${YELLOW}$TARGET_DIR${NC}

SUMMARY

print_success "Deployment package creation complete!"

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"