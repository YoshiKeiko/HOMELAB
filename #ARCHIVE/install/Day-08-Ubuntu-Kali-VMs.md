---
title: Volume 06: Ubuntu & Kali Linux VMs (Day 6)
tags: [homelab, vm, linux, ubuntu, kali]
created: 2025-11-11
type: homelab-guide
---

# Volume 06: Ubuntu & Kali Linux VMs (Day 6)

**Linux VMs for Development and Security Testing**

This volume covers Ubuntu Server and Kali Linux VM setup in Proxmox.

## What You'll Complete

- Ubuntu Server 24.04 VM (for general Linux work)
- Kali Linux VM (for security testing)
- Both VMs networked and accessible
- SSH configured with keys
- Essential tools installed
- Docker on Ubuntu (optional)

## Prerequisites

- Volume 05 complete (Proxmox running, Windows VM working)
- Ubuntu and Kali ISOs uploaded to Proxmox
- 10GB RAM available for VMs (6GB Ubuntu + 4GB Kali)

---

# Guide 32: Ubuntu Server VM

## Create VM

In Proxmox Web GUI:

1. Click: Create VM

2. **General:**
```
VM ID: 101
Name: Ubuntu-Server-HomeLab
```

3. **OS:**
```
ISO image: ubuntu-24.04-live-server-arm64.iso
Guest OS: Linux
Version: 6.x - 2.6 Kernel
```

4. **System:**
```
Graphic card: Default
Machine: Default (i440fx)
SCSI Controller: VirtIO SCSI single
Qemu Agent: Yes
```

5. **Disks:**
```
Bus: VirtIO Block
Storage: local-lvm
Size: 200 GB
Cache: Default
Discard: Yes
SSD emulation: Yes
```

6. **CPU:**
```
Sockets: 1
Cores: 2
Type: host
```

7. **Memory:**
```
Memory: 6144 MB (6GB)
Minimum: 2048 MB
```

8. **Network:**
```
Bridge: vmbr0
Model: VirtIO
```

9. Click: Finish & Start

## Install Ubuntu Server

1. **Open Console**

2. **Select:** Install Ubuntu Server

3. **Language:** English

4. **Keyboard:** English (UK)

5. **Network:**
   - Use DHCP initially
   - Note IP assigned

6. **Proxy:** (leave blank)

7. **Mirror:** Default

8. **Storage:**
   - Use entire disk
   - Set up LVM: Yes
   - Confirm

9. **Profile:**
```
Name: Steve
Server name: ubuntu-homelab
Username: steve
Password: [strong password]
```

**Save to 1Password:**
```
Title: Ubuntu Server VM - steve
Username: steve
Password: [your password]
IP: 192.168.50.51 (will configure)
SSH: ssh steve@192.168.50.51
```

10. **SSH:** Install OpenSSH server: Yes

11. **Snaps:** Skip all

12. **Installation:** Proceeds (10-15 min)

13. **Reboot:** When prompted

## Post-Install Configuration

### Set Static IP

```bash
# Login via console
# Edit netplan
sudo nano /etc/netplan/50-cloud-init.yaml
```

**Configuration:**
```yaml
network:
  version: 2
  ethernets:
    ens18:
      dhcp4: no
      addresses:
        - 192.168.50.51/24
      routes:
        - to: default
          via: 192.168.50.1
      nameservers:
        addresses:
          - 192.168.50.1
          - 1.1.1.1
```

**Apply:**
```bash
sudo netplan apply
ip addr show
```

### Install QEMU Guest Agent

```bash
sudo apt update
sudo apt install -y qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent
```

**Proxmox now shows VM IP and can shutdown properly!**

### System Updates

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl wget git htop btop vim net-tools
```

### Install Docker (Optional)

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Add user to docker group
sudo usermod -aG docker steve

# Enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Test
docker run hello-world
```

---

# Guide 33: Kali Linux VM

## Create VM

1. Click: Create VM

2. **General:**
```
VM ID: 102
Name: Kali-Linux-HomeLab
```

3. **OS:**
```
ISO image: kali-linux-2024.x-installer-arm64.iso
Type: Linux
```

4. **System:** Default settings

5. **Disks:**
```
Size: 150 GB
Bus: VirtIO Block
```

6. **CPU:**
```
Cores: 2
Type: host
```

7. **Memory:**
```
Memory: 4096 MB (4GB)
```

8. **Network:**
```
Bridge: vmbr0
Model: VirtIO
```

9. Finish & Start

## Install Kali Linux

1. **Select:** Graphical install

2. **Language:** English

3. **Location:** United Kingdom

4. **Keyboard:** British English

5. **Network:** DHCP (configure static later)

6. **Hostname:** kali-homelab

7. **Domain:** (leave blank)

8. **Root password:** [strong password]

9. **User:**
```
Full name: Steve
Username: steve
Password: [strong password]
```

**Save to 1Password:**
```
Title: Kali Linux VM - steve
Username: steve
Root Password: [root password]
User Password: [steve password]
IP: 192.168.50.53 (will configure)
SSH: ssh steve@192.168.50.53
```

10. **Partitioning:** Guided - use entire disk

11. **Desktop:** Xfce (lightweight)

12. **Install GRUB:** Yes, /dev/sda

13. **Installation:** ~20 minutes

14. **Reboot**

## Post-Install Configuration

### Set Static IP

```bash
sudo nano /etc/network/interfaces
```

**Add:**
```
auto ens18
iface ens18 inet static
    address 192.168.50.53
    netmask 255.255.255.0
    gateway 192.168.50.1
    dns-nameservers 192.168.50.1 1.1.1.1
```

**Apply:**
```bash
sudo systemctl restart networking
```

### Update System

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y kali-linux-default qemu-guest-agent
sudo systemctl enable qemu-guest-agent
```

### Enable SSH

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

---

# Guide 34: SSH Key Setup

## Generate SSH Key on M4

```bash
# On M4 Mac:
ssh-keygen -t ed25519 -C "steve-smithit@outlook.com"

# Save to: ~/.ssh/id_ed25519
# Passphrase: (optional but recommended)
```

## Copy to VMs

```bash
# Copy to Ubuntu
ssh-copy-id steve@192.168.50.51

# Copy to Kali
ssh-copy-id steve@192.168.50.53

# Copy to Windows (optional, if OpenSSH installed)
```

## Test Key-Based Login

```bash
# Should login without password:
ssh steve@192.168.50.51
ssh steve@192.168.50.53
```

---

# Guide 35: VM Verification

## Ubuntu Server Checklist

- [ ] VM ID: 101
- [ ] IP: 192.168.50.51 (static)
- [ ] Hostname: ubuntu-homelab
- [ ] SSH working with keys
- [ ] QEMU agent installed
- [ ] Docker installed (optional)
- [ ] System updated
- [ ] Credentials in 1Password

**Test:**
```bash
ssh steve@192.168.50.51
docker --version  # If installed
```

## Kali Linux Checklist

- [ ] VM ID: 102
- [ ] IP: 192.168.50.53 (static)
- [ ] Hostname: kali-homelab
- [ ] SSH working with keys
- [ ] QEMU agent installed
- [ ] Xfce desktop working
- [ ] System updated
- [ ] Credentials in 1Password

**Test:**
```bash
ssh steve@192.168.50.53
sudo nmap --version
```

---

# Guide 36: Network Test

## Test Connectivity

```bash
# From M4, test all VMs:
ping -c 4 192.168.50.50  # Proxmox
ping -c 4 192.168.50.51  # Ubuntu
ping -c 4 192.168.50.52  # Windows
ping -c 4 192.168.50.53  # Kali

# SSH to each Linux VM:
ssh steve@192.168.50.51  # Ubuntu
ssh steve@192.168.50.53  # Kali

# RDP to Windows:
# Use RustDesk or Guacamole (self-hosted remote access): 192.168.50.52
```

## Speed Test Between VMs

```bash
# On Ubuntu:
sudo apt install -y iperf3
iperf3 -s

# On Kali:
sudo apt install -y iperf3
iperf3 -c 192.168.50.51

# Should see good speeds (Gbps range)
```

---

# Guide 37: Snapshots

## Create Clean Snapshots

**Ubuntu:**
```
Proxmox → VM 101 → Snapshots → Take Snapshot
Name: clean-install
Description: Fresh Ubuntu with updates and Docker
```

**Kali:**
```
Proxmox → VM 102 → Snapshots → Take Snapshot
Name: clean-install
Description: Fresh Kali with updates and tools
```

---

# Guide 38: Common Tasks

## Start/Stop VMs

**Via Proxmox GUI:**
- Select VM → Start/Stop/Restart

**Via CLI:**
```bash
# SSH to Proxmox
ssh root@192.168.50.50

# Start VM
qm start 101    # Ubuntu
qm start 102    # Kali

# Stop VM
qm stop 101
qm stop 102

# Status
qm status 101
qm list
```

## Access VMs

**SSH:**
```bash
ssh steve@192.168.50.51  # Ubuntu
ssh steve@192.168.50.53  # Kali
```

**Via Proxmox Console:**
- Proxmox GUI → VM → Console

**Kali Desktop (VNC):**
- Proxmox GUI → VM 102 → Console
- Or via VNC viewer

---

# Guide 39: Usage Examples

## Ubuntu Server Uses

- Docker host for testing
- Development environment
- Web server testing
- Database server
- CI/CD runner
- General Linux tasks

## Kali Linux Uses

**⚠️ LEGAL USE ONLY:**
- Network scanning (your own network)
- Vulnerability testing (authorized only)
- Security learning
- Penetration testing practice
- Capture The Flag (CTF) challenges

**Recommended Learning:**
- TryHackMe: https://tryhackme.com
- HackTheBox: https://hackthebox.com
- OverTheWire: https://overthewire.org

---

## Volume 06 Complete!

You now have:
- ✅ Ubuntu Server VM (192.168.50.51)
  - 6GB RAM, 2 cores, 200GB disk
  - Docker installed
  - SSH with keys
  
- ✅ Kali Linux VM (192.168.50.53)
  - 4GB RAM, 2 cores, 150GB disk
  - Security tools installed
  - SSH with keys
  
- ✅ All VMs networked together
- ✅ SSH access configured
- ✅ Clean snapshots created
- ✅ Ready for use!

**VM Summary:**
```
Proxmox Host: 192.168.50.50
├─ VM 100: Windows-HomeLab (192.168.50.52) - 8GB/3 cores
├─ VM 101: Ubuntu-Server (192.168.50.51) - 6GB/2 cores
└─ VM 102: Kali-Linux (192.168.50.53) - 4GB/2 cores

Total VM Resources: 18GB RAM, 7 cores
```

**Next: Volume 07 - Media Stack (Plex + *arr services)**



---

#homelab #vm #linux #ubuntu #kali
