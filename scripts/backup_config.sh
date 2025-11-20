#!/bin/bash

# ====== GLOBAL CONFIG FOR ALL BACKUPS ======

# Minimum hours between backups (prevents spam)
MIN_HOURS=6

# Local backup folder for all vault snapshots
LOCAL_BACKUP_ROOT="/Users/homelab/Documents/Obsidian/BACKUPS"

# Vaults list
VAULTS=(
"ACCREDIBLE"
"DD"
"HOME"
"KETO"
"PERSONAL"
"PROJECTS"
)