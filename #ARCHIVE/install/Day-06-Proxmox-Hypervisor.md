---
title: Volume 04: Proxmox Virtualization Platform (Days 5-6)
tags: [homelab, proxmox, virtualization, hypervisor]
created: 2025-11-11
type: homelab-guide
---

# Volume 04: Proxmox Virtualization Platform (Days 5-6)

**Enterprise Hypervisor on Your M4**

This volume covers complete Proxmox setup for running VMs.

## What You'll Complete

- UTM installation for running Proxmox
- Proxmox VE installation
- Web GUI access
- Network configuration (bridged to all 3 adapters)
- Storage setup
- Ready to create VMs

## Prerequisites

- Volumes 01-03 complete
- Proxmox ISO downloaded (from Volume 01)
- 16GB RAM allocated for VMs
- 6 CPU cores available

---

# Guide 13: UTM Installation

## Why UTM First?

Proxmox runs as a VM on your M4:
```
M4 Mac Mini (macOS)
├─ Docker (60+ containers)
└─ UTM
   └─ Proxmox VM
      ├─ Windows 11
      ├─ Ubuntu Server
      └─ Kali Linux
```

## Install UTM

```bash
# Via Homebrew
brew install utm

# Or download from: https://mac.getutm.app/
```

Launch UTM from Applications.

---

# Guide 14: Proxmox Installation

## Download Proxmox ISO

If not already downloaded:
```bash
cd ~/Desktop/HomeLab-Project/ISOs
# Download from: https://www.proxmox.com/en/downloads
# Get: proxmox-ve-8.x-arm64.iso (if available)
# Or use x86_64 version with emulation
```

**Note:** Proxmox ARM support is experimental. For M4, we'll use standard x86_64 with emulation.

## Create Proxmox VM in UTM

1. Open UTM
2. Click: + Create New Virtual Machine
3. Select: Virtualize (not Emulate)
4. Operating System: Linux

**Configuration:**
```
Name: Proxmox-VE
Architecture: ARM64 (or x86_64 if ARM not available)
Memory: 16384 MB (16GB)
CPU Cores: 6
Storage: 200 GB (on external SSD)
Boot ISO: proxmox-ve-*.iso
Network: Bridged (en0 - 10GbE)
```

5. Click: Save

## Install Proxmox

1. Start VM
2. Select: Install Proxmox VE (Graphical)
3. Accept EULA
4. Target Disk: /dev/sda (200GB)
5. Filesystem: ext4

**Location:**
```
Country: United Kingdom
Time Zone: Europe/London
Keyboard: UK
```

**Password:**
```
Password: [strong password]
Email: steve-smithit@outlook.com
```

**Save to 1Password:**
```
Title: Proxmox VE - root
Username: root
Password: [your password]
URL: https://192.168.50.50:8006
Notes: Proxmox hypervisor admin
```

**Network:**
```
Management Interface: ens160
Hostname: proxmox.homelab.local
IP Address: 192.168.50.50/24
Gateway: 192.168.50.1
DNS: 192.168.50.1
```

6. Click: Install
7. Wait 10-15 minutes
8. Reboot when prompted

---

# Guide 15: Proxmox Configuration

## Access Web Interface

1. Open browser: https://192.168.50.50:8006
2. Accept self-signed certificate warning
3. Login:
   - User: root
   - Password: [from 1Password]
   - Realm: Linux PAM

## Disable Enterprise Repo

```bash
# SSH to Proxmox
ssh root@192.168.50.50

# Edit sources
nano /etc/apt/sources.list

# Add:
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

# Save and exit
apt update
apt full-upgrade -y
```

## Remove Subscription Nag

```bash
sed -i.backup "s/data.status.tolower() !== 'active'/false/g" \
  /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

systemctl restart pveproxy
```

Refresh browser - nag gone!

## Update System

```bash
apt update
apt full-upgrade -y
apt install -y htop vim curl wget git
```

---

# Guide 16: Network Configuration

## Verify Network Bridge

```bash
# Check bridges
ip addr show vmbr0

# Should show:
# vmbr0: ... inet 192.168.50.50/24
```

Proxmox automatically creates vmbr0 as bridge.

## Configure Secondary Networks

For your 3 ethernet adapters setup:

**Primary (10GbE):** Already configured as vmbr0

**Backup (5GB):** Configure as vmbr1
```bash
# Edit network config
nano /etc/network/interfaces

# Add:
auto vmbr1
iface vmbr1 inet static
    address 192.168.50.51/24
    bridge-ports ens161
    bridge-stp off
    bridge-fd 0
```

**VM Network (2.5GB):** Configure as vmbr2
```bash
# Add to same file:
auto vmbr2
iface vmbr2 inet static
    address 192.168.51.1/24
    bridge-ports ens162
    bridge-stp off
    bridge-fd 0
```

Restart networking:
```bash
systemctl restart networking
```

---

# Guide 17: Storage Configuration

## Add External Storage

Mount folder from macOS to Proxmox:

1. **In UTM VM settings:**
   - Add Shared Directory
   - Path: /Volumes/External4TB/VMs
   - Mount automatically

2. **In Proxmox:**
```bash
# Create mount point
mkdir -p /mnt/external-vms

# Mount (adjust device name)
mount -t virtiofs external-vms /mnt/external-vms

# Make permanent
echo "external-vms /mnt/external-vms virtiofs defaults 0 0" >> /etc/fstab
```

3. **Add to Proxmox storage:**
   - Datacenter → Storage → Add → Directory
   - ID: external-vms
   - Directory: /mnt/external-vms
   - Content: Disk image, ISO image, Container

## Upload ISOs

Copy ISOs to Proxmox:

```bash
# From M4 Mac:
scp ~/Desktop/HomeLab-Project/ISOs/ubuntu-*.iso root@192.168.50.50:/var/lib/vz/template/iso/
scp ~/Desktop/HomeLab-Project/ISOs/kali-*.iso root@192.168.50.50:/var/lib/vz/template/iso/
scp ~/Desktop/HomeLab-Project/ISOs/Windows11*.iso root@192.168.50.50:/var/lib/vz/template/iso/
```

---

# Guide 18: Backup Configuration

## Configure Backup Storage

1. Datacenter → Storage → Add → Directory
```
ID: backups
Directory: /mnt/external-vms/Backups
Content: VZDump backup file
```

2. Datacenter → Backup → Add
```
Schedule: Daily at 02:00
Storage: backups
Mode: Snapshot
Compression: ZSTD
```

---

# Guide 19: Quick Commands

## Proxmox CLI

```bash
# List VMs
qm list

# Start VM
qm start 100

# Stop VM
qm stop 100

# VM status
qm status 100

# Create snapshot
qm snapshot 100 pre-update

# Restore snapshot
qm rollback 100 pre-update

# List snapshots
qm listsnapshot 100
```

## System Maintenance

```bash
# Update Proxmox
apt update && apt full-upgrade -y

# Clean up
apt autoremove -y
apt autoclean

# Check disk usage
df -h

# Check VM disk usage
pvesm status
```

---

# Guide 20: Access Summary

## Proxmox Access

**Local:**
- Web: https://192.168.50.50:8006
- SSH: ssh root@192.168.50.50

**Via Tailscale:**
- Web: https://100.x.x.x:8006 (M4's Tailscale IP)
- SSH: ssh root@100.x.x.x

**Via DuckDNS:**
- Can proxy via Nginx Proxy Manager
- Add: proxmox.stevehomelab.duckdns.org

**Default Credentials:**
- Username: root
- Password: [in 1Password]
- Realm: Linux PAM

---

## Volume 04 Complete!

You now have:
- ✅ UTM installed on M4
- ✅ Proxmox VE running in UTM
- ✅ Web GUI accessible
- ✅ Network bridges configured (3 adapters)
- ✅ Storage configured (external SSD)
- ✅ ISOs uploaded
- ✅ Backup system ready
- ✅ Ready to create VMs!

**Network Setup:**
```
192.168.50.50 (vmbr0) - Primary network
192.168.50.51 (vmbr1) - Backup network  
192.168.51.1  (vmbr2) - Isolated VM network
```

**Next: Volume 05 - Windows 11 VM**



---

#homelab #proxmox #virtualization #hypervisor
