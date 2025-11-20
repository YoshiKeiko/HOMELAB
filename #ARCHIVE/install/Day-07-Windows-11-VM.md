---
title: Volume 05: Windows 11 Pro VM (Day 6)
tags: [homelab, vm, windows, windows11]
created: 2025-11-11
type: homelab-guide
---

# Volume 05: Windows 11 Pro VM (Day 6)

**Running Full Windows in Proxmox**

This volume covers complete Windows 11 VM setup in Proxmox.

## What You'll Complete

- Download Windows 11 ARM Insider Preview
- Create VM in Proxmox with optimal settings
- Install VirtIO drivers
- Complete Windows installation
- Configure networking and RDP
- Install essential software
- Action1 RMM agent

## Prerequisites

- Volume 04 complete (Proxmox running)
- Windows Insider account (from Volume 01)
- 8GB RAM available for Windows VM
- 500GB disk space on external SSD

---

# Guide 21: Getting Windows 11 ARM

## Download from Windows Insider

1. Go to: https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewARM64

2. Sign in with Microsoft account

3. Join Windows Insider Program:
   - Select: Beta Channel (stable) or Dev Channel
   - Agree to terms

4. Download:
   - Edition: Windows 11 Pro ARM64
   - Language: English (United Kingdom)
   - Format: VHDX (~10GB)

5. Upload to Proxmox:
```bash
# From M4 Mac:
scp ~/Downloads/Windows11_ARM64*.vhdx root@192.168.50.50:/var/lib/vz/template/iso/
```

## Alternative: CrystalFetch

```bash
# On Mac:
brew install --cask crystalfetch

# Launch and download Windows 11 ARM64
```

---

# Guide 22: Create Windows 11 VM

## VM Configuration

In Proxmox Web GUI:

1. Click: Create VM

2. **General:**
```
Node: proxmox
VM ID: 100
Name: Windows-11-Pro
```

3. **OS:**
```
Use CD/DVD: No
Guest OS: Microsoft Windows
Version: 11/2022/2025
```

4. **System:**
```
Graphic card: Default
Machine: q35
BIOS: OVMF (UEFI)
Add EFI Disk: Yes
  Storage: local-lvm
  Format: raw
  Pre-Enroll keys: No
Add TPM: Yes
  Storage: local-lvm
  Version: v2.0
SCSI Controller: VirtIO SCSI single
Qemu Agent: Yes (check)
```

5. **Disks:**
```
Bus/Device: SCSI
Storage: local-lvm
Disk size: 500 GB
Cache: Write back
Discard: Yes
SSD emulation: Yes
```

**Import existing VHDX:**
```bash
# SSH to Proxmox
ssh root@192.168.50.50

# Convert VHDX to qcow2
qemu-img convert -f vhdx -O qcow2 \
  /var/lib/vz/template/iso/Windows11_ARM64.vhdx \
  /var/lib/vz/images/100/vm-100-disk-0.qcow2

# Attach to VM (via GUI: Hardware → Add → Existing Disk)
```

6. **CPU:**
```
Sockets: 1
Cores: 3
Type: host
```

7. **Memory:**
```
Memory: 8192 MB (8GB)
Minimum: 4096 MB
Ballooning: Yes
```

8. **Network:**
```
Bridge: vmbr0
Model: VirtIO (paravirtualized)
MAC: auto
```

9. Click: Finish

---

# Guide 23: VirtIO Drivers

## Download VirtIO ISO

```bash
# SSH to Proxmox
cd /var/lib/vz/template/iso/

# Download VirtIO drivers
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
```

## Attach to VM

In Proxmox GUI:
1. Select Windows VM
2. Hardware → Add → CD/DVD Drive
3. Bus: SATA
4. ISO: virtio-win.iso
5. Add

---

# Guide 24: Windows Installation

## Start Installation

1. Start VM (click Start)
2. Open Console (click Console)

**If using VHDX import:**
- Windows boots directly
- Skip to first login

**If using ISO:**
- Follow standard Windows installation
- At disk selection: Load Driver
- Browse to E:\vioscsi\w11\ARM64\
- Install driver
- Disk now appears
- Continue installation

## First Setup

```
Region: United Kingdom
Keyboard: UK
Network: Skip for now (configure after)
Account: Create local account
  Name: Steve
  Password: [strong password]
  Security questions: Answer 3
```

**Save to 1Password:**
```
Title: Windows 11 VM - Steve Account
Username: Steve
Password: [your password]
IP: 192.168.50.52 (will configure)
Notes: Windows 11 Pro ARM VM on Proxmox
       Administrator account
```

## Install VirtIO Drivers

After first boot:

1. **Open Device Manager**
   - Right-click Start → Device Manager

2. **Update Unknown Devices:**
   - Right-click each → Update Driver
   - Browse: E:\ (virtio-win CD)
   - Install all drivers

3. **Install QEMU Guest Agent:**
   - E:\guest-agent\qemu-ga-x86_64.msi
   - Install
   - Restart

---

# Guide 25: Network Configuration

## Set Static IP

1. Settings → Network & Internet → Ethernet

2. Edit IP settings:
```
IP assignment: Manual
IPv4: On

IP address: 192.168.50.52
Subnet prefix: 24
Gateway: 192.168.50.1
Preferred DNS: 192.168.50.1
Alternate DNS: 1.1.1.1
```

3. Save

## Set Computer Name

1. Settings → System → About

2. Rename this PC:
```
New name: Windows-HomeLab
```

3. Restart

## Test Network

```powershell
# Open PowerShell
ping 192.168.50.1
ping google.com
```

---

# Guide 26: Windows Configuration

## Windows Updates

1. Settings → Windows Update
2. Check for updates
3. Install all available
4. Restart as needed

## Activate Windows

1. Settings → Activation
2. Change product key
3. Enter Windows 11 Pro key
4. Activate

**Or run unactivated for homelab (has watermark but fully functional)**

## Essential Settings

**Privacy:**
- Settings → Privacy & Security
- Turn OFF most telemetry
- Keep Windows Update ON

**Performance:**
- Settings → System → Power
- Power mode: Best Performance

**Remote Desktop:**
- Settings → System → Remote Desktop
- Enable Remote Desktop: ON
- Network Level Authentication: ON

**Test RDP:**
```bash
# From Mac:
# Install RustDesk or Guacamole (self-hosted remote access) from App Store
# Add PC: 192.168.50.52
# Username: Steve
# Connect!
```

---

# Guide 27: Software Installation

## Windows Terminal

From Microsoft Store:
- Search: Windows Terminal
- Install

## Browsers

Download and install:
- Google Chrome or Firefox
- Edge already installed

## Utilities

Download and install:
- 7-Zip (https://7-zip.org)
- Notepad++ (https://notepad-plus-plus.org)
- PuTTY (for SSH to other VMs)

## Action1 RMM Agent

1. Go to: https://app.action1.com
2. Login: steve-smithit@outlook.com
3. Download agent
4. Install agent
5. VM appears in Action1 dashboard

**Save to 1Password:**
```
Update Action1 entry:
Add note: Windows-HomeLab VM enrolled
```

---

# Guide 28: Optimization

## Disable Unnecessary Services

Services.msc → Disable:
- Xbox services (if not gaming)
- Windows Search (if not needed)
- Superfetch

## Disk Cleanup

- Run: Disk Cleanup
- Select: Clean up system files
- Delete temporary files

## Windows Defender

- Already active
- No additional antivirus needed for VM

---

# Guide 29: Snapshots

## Create Clean Snapshot

In Proxmox:
1. Select Windows VM
2. Snapshots → Take Snapshot
```
Name: clean-install
Include RAM: No
Description: Fresh Windows 11 install with updates
```

3. Take Snapshot

**Now you can always restore to this point!**

---

# Guide 30: Access Methods

## Local Access

**Via Proxmox Console:**
- Proxmox GUI → VM 100 → Console

**Via RDP:**
- RustDesk or Guacamole (self-hosted remote access)
- Server: 192.168.50.52
- User: Steve

## Remote Access

**Via Tailscale:**
- RDP to: 100.x.x.50 (Proxmox Tailscale IP routing)

**Via DuckDNS:**
- Set up port forward in Nginx Proxy Manager
- rdp.stevehomelab.duckdns.org

---

# Guide 31: Verification

## Checklist

- [ ] Windows 11 Pro installed and activated
- [ ] Static IP: 192.168.50.52
- [ ] Computer name: Windows-HomeLab
- [ ] All Windows updates installed
- [ ] VirtIO drivers installed
- [ ] QEMU Guest Agent installed
- [ ] Remote Desktop working
- [ ] Network connectivity confirmed
- [ ] Action1 agent installed
- [ ] Clean snapshot created
- [ ] Credentials in 1Password

## Performance Test

```powershell
# Check CPU
wmic cpu get name

# Check RAM
wmic memorychip get capacity

# Check disk
wmic diskdrive get size

# Network speed
# Install: speedtest-cli
speedtest
```

---

## Volume 05 Complete!

You now have:
- ✅ Windows 11 Pro VM running in Proxmox
- ✅ Fully configured and updated
- ✅ Remote Desktop enabled
- ✅ VirtIO drivers for performance
- ✅ Action1 RMM monitoring
- ✅ Clean snapshot for recovery
- ✅ Accessible via RDP locally and remotely

**Windows 11 VM Specs:**
```
VM ID: 100
Name: Windows-HomeLab
IP: 192.168.50.52
RAM: 8GB
CPU: 3 cores
Disk: 500GB
OS: Windows 11 Pro ARM64
```

**Next: Volume 06 - Ubuntu & Kali Linux VMs**



---

#homelab #vm #windows #windows11
