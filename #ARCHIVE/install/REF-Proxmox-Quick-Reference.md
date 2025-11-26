---
title: 🚀 Proxmox Quick Reference Card
tags: [homelab, proxmox, virtualization, hypervisor]
created: 2025-11-11
type: homelab-guide
---

# 🚀 Proxmox Quick Reference Card

**Steve's Proxmox HomeLab Cheat Sheet**

---

## 🌐 Access URLs

```
Proxmox Web GUI: https://192.168.50.50:8006
Username: root  |  steve@pve
Password: [from 1Password]

VMs:
├─ Ubuntu Server: ssh steve@192.168.50.51
├─ Windows 11: rdp://192.168.50.52
└─ Kali Linux: ssh steve@192.168.50.53
```

---

## ⚡ Quick Commands

### VM Management
```bash
# List all VMs
qm list

# Start VM
qm start 100

# Stop VM
qm stop 100

# Reboot VM
qm reboot 100

# VM status
qm status 100

# Enter VM console
qm terminal 100
```

### Backup & Restore
```bash
# Manual backup
vzdump 100 --storage backups --mode snapshot --compress zstd

# List backups
ls /mnt/external-4tb/Proxmox-Backups/

# Restore VM
qmrestore /path/to/backup.vma.zst 100 --storage local-lvm
```

### Snapshots
```bash
# Create snapshot
qm snapshot 100 pre-update

# List snapshots
qm listsnapshot 100

# Rollback snapshot
qm rollback 100 pre-update

# Delete snapshot
qm delsnapshot 100 pre-update
```

### System Updates
```bash
# Update Proxmox
apt update && apt full-upgrade -y

# Check if reboot needed
[ -f /var/run/reboot-required ] && echo "Reboot needed"

# Reboot
reboot
```

### Storage
```bash
# List storage
pvesm status

# Check disk usage
df -h

# Check VM disk usage
qm disk rescan
```

### Network
```bash
# Show bridges
ip addr show vmbr0

# Show VM network
qm config 100 | grep net

# Test connectivity
ping 192.168.50.51
```

---

## 🔧 Common Tasks

### Create New VM
1. Web GUI → Create VM
2. Set Name, ID
3. Select ISO
4. Configure: CPU/RAM/Disk
5. Set Network: vmbr0
6. Finish → Start

### Clone VM
```bash
# CLI
qm clone 100 200 --name new-vm-name

# Or Web GUI: Right-click VM → Clone
```

### Change VM Resources
```bash
# Add CPU cores
qm set 100 --cores 4

# Add RAM
qm set 100 --memory 8192

# Resize disk (can only grow!)
qm resize 100 virtio0 +50G
```

### Fix VM Not Starting
```bash
# Check VM config
qm config 100

# Check system logs
journalctl -xe

# Check storage
pvesm status

# Force unlock VM
qm unlock 100

# Try starting again
qm start 100
```

---

## 📊 Monitoring

### System Resources
```bash
# CPU/RAM
top
htop

# Disk I/O
iotop

# Network
iftop
nload
```

### VM Performance
```bash
# VM CPU usage
qm monitor 100
# Type: info cpus

# VM memory
qm config 100 | grep memory
```

---

## 🛡️ Firewall

### Enable Datacenter Firewall
```bash
# Web GUI:
# Datacenter → Firewall → Options
# Enable Firewall: Yes

# Allow SSH
# Datacenter → Firewall → Add
# Direction: IN
# Action: ACCEPT
# Protocol: TCP
# Dest port: 22
```

---

## 💾 Backup Schedule

```
Daily: 02:00 AM (all VMs)
Storage: /mnt/external-4tb/Proxmox-Backups/
Retention: 7 days
Compression: ZSTD
Mode: Snapshot
```

---

## 🔑 Important Locations

```
VM Configs: /etc/pve/qemu-server/
ISOs: /var/lib/vz/template/iso/
Backups: /var/lib/vz/dump/ (or external storage)
Logs: /var/log/pve/
```

---

## 🆘 Emergency Procedures

### Proxmox Won't Boot
1. Boot into recovery mode (GRUB menu)
2. Check /etc/network/interfaces
3. Check /etc/pve/ permissions
4. Repair: `pve-cluster updatecerts --force`

### VM Locked
```bash
qm unlock 100
```

### Reset Root Password
```bash
# Boot from rescue ISO
# Mount root partition
mount /dev/mapper/pve-root /mnt
chroot /mnt
passwd root
exit
reboot
```

### Restore from Backup
1. Web GUI → Storage → backups
2. Select backup file
3. Restore
4. Select target

---

## 📱 Mobile Access

**Via Tailscale:**
```
1. Connect to Tailscale on phone
2. Open browser: https://100.x.x.x:8006
3. Login with credentials
4. Manage VMs from phone!
```

---

## 🎯 VM IP Addresses

```
192.168.50.50 → Proxmox host
192.168.50.51 → Ubuntu Server
192.168.50.52 → Windows 11
192.168.50.53 → Kali Linux
192.168.50.54 → macOS (optional)
```

---

## ⚙️ Useful Aliases

Add to `~/.bashrc`:

```bash
alias vmlist='qm list'
alias vmstart='qm start'
alias vmstop='qm stop'
alias vmssh='ssh steve@'
alias backupnow='vzdump --all --storage backups --mode snapshot'
alias updateprox='apt update && apt full-upgrade -y'
```

---

## 📞 Support Resources

- Proxmox Forum: https://forum.proxmox.com/
- Proxmox Wiki: https://pve.proxmox.com/wiki/
- r/Proxmox: https://reddit.com/r/Proxmox
- Your docs: ~/HomeLab/Documentation/

---

*Keep this handy - you'll use it daily!* 📌

**Created by Vox for Steve's HomeLab** ☕


---

#homelab #proxmox #virtualization #hypervisor
