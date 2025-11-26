

  

Covers **HomeLab** machine (always‑on box) with vaults at:

```
/Users/homelab/Documents/Obsidian/
```

Vaults managed:

```
ACCREDIBLE
DD
HOME
KETO
PERSONAL
PROJECTS
HOMELAB
```

Backups include:

- ☁ **GitHub** (encrypted blob per vault)
    
- 💾 **Local BACKUPS folder** (per‑vault .tar.gz snapshots)
    
- 🔐 **Per‑vault encryption keys** (BACKUP/key.txt)
    
- 🔑 **SSH keys** (per machine; reuse considerations explained)
    
- ☁ **pCloud** file‑level sync (optional but recommended)
    

---

## **0️⃣ Concept Overview**

  

Each vault is backed up in **three layers**:

1. **pCloud** – mirrors the raw vault folder (files/folders) for convenience.
    
2. **GitHub** – stores an **encrypted** **vault.tar.gz.enc** file and the Git history.
    
3. **Local BACKUPS folder** – stores compressed .tar.gz snapshots for fast restore even without internet.
    

  

All of this is driven by **one script**:

```
/Users/homelab/Documents/Obsidian/encrypted_multi_backup.sh
```

Scheduled to run every few hours via cron.

---

## **1️⃣ SSH Keys – Separate vs Reusing**

  

### **Recommended: one SSH key** 

### **per machine**

  

GitHub is happiest when **each machine** has its **own SSH key**:

- MacBook Pro → ~/.ssh/id_ed25519 (already added to GitHub)
    
- HomeLab → ~/.ssh/id_ed25519 (must also be added to GitHub)
    

  

> ✅ Safer: you can revoke one machine without breaking the other.

  

### **Why SSH key reuse caused confusion**

  

You tried to reuse the MacBook key on HomeLab by copying content around. Issues arose because:

- The key file contents and formatting must be _exact_.
    
- The public key must **match** the private key.
    
- GitHub must have the **public key** from the machine actually connecting.
    

  

To avoid this pain, we now standardise on:

  

> 🔒 **Unique SSH key per machine, each added to GitHub once.**

---

## **2️⃣ HomeLab – Correct SSH Setup**

  

On **HomeLab**:

  

### **2.1 Generate SSH key (only once)**

```
ssh-keygen -t ed25519 -C "homelab@obsidian"
```

Press **ENTER** for default location (/Users/homelab/.ssh/id_ed25519).

You can leave passphrase empty for automation.

  

### **2.2 Start ssh-agent and add key**

```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### **2.3 Create SSH config**

  

Create or edit:

```
nano ~/.ssh/config
```

Contents:

```
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    AddKeysToAgent yes
```

Then:

```
chmod 600 ~/.ssh/config
```

### **2.4 Add public key to GitHub**

  

Show public key:

```
cat ~/.ssh/id_ed25519.pub
```

Copy the entire line starting with ssh-ed25519 ....

  

Go to:

- https://github.com/settings/keys
    
- **New SSH key** → Title: HomeLab
    
- Paste key → **Add SSH key**
    

  

### **2.5 Test**

```
ssh -T git@github.com
```

You want to see:

```
Hi YoshiKeiko! You've successfully authenticated...
```

If yes → SSH is **correct**.

---

## **3️⃣ GitHub Repos per Vault (HomeLab)**

  

Each vault has a matching GitHub repo:

```
ACCREDIBLE  → git@github.com:YoshiKeiko/ACCREDIBLE.git
DD          → git@github.com:YoshiKeiko/DD.git
HOME        → git@github.com:YoshiKeiko/HOME.git
KETO        → git@github.com:YoshiKeiko/KETO.git
PERSONAL    → git@github.com:YoshiKeiko/PERSONAL.git
PROJECTS    → git@github.com:YoshiKeiko/PROJECTS.git
HOMELAB     → git@github.com:YoshiKeiko/HOMELAB.git
```

On GitHub you’ve already created these repos.

  

On **HomeLab**, ensure each vault folder exists:

```
cd /Users/homelab/Documents/Obsidian
ls
# should show: ACCREDIBLE DD HOME KETO PERSONAL PROJECTS HOMELAB
```

For **each** vault, run once:

```
cd /Users/homelab/Documents/Obsidian/ACCREDIBLE

git init
git remote remove origin 2>/dev/null
git remote add origin git@github.com:YoshiKeiko/ACCREDIBLE.git

git add .
git commit -m "Initial commit" || true
git branch -M main

git push -u origin main
```

Repeat for: DD, HOME, KETO, PERSONAL, PROJECTS, HOMELAB

(only initial setup; afterwards the backup script does the push).

---

## **4️⃣ Per‑Vault Encryption Keys**

  

Each vault has its own **encryption password file**:

```
/Users/homelab/Documents/Obsidian/VAULTNAME/BACKUP/key.txt
```

This password encrypts the vault.tar.gz before sending to GitHub.

  

For each vault:

```
mkdir -p /Users/homelab/Documents/Obsidian/VAULTNAME/BACKUP

# Example – use a long random string per vault
echo "CHANGE-THIS-TO-A-STRONG-UNIQUE-PASSWORD" > /Users/homelab/Documents/Obsidian/VAULTNAME/BACKUP/key.txt

chmod 600 /Users/homelab/Documents/Obsidian/VAULTNAME/BACKUP/key.txt
```

You can:

- Use **one master password** for all vaults (simple), or
    
- Use **different passwords** per vault (more secure).
    

  

> 🔑 The same vault must use the same password on all machines if you decrypt elsewhere.

---

## **5️⃣ Multi‑Vault Encrypted Backup Script (HomeLab)**

  

Save this script as:

```
/Users/homelab/Documents/Obsidian/encrypted_multi_backup.sh
```

```
#!/bin/bash

set -e

BASE="/Users/homelab/Documents/Obsidian"
VAULTS=("ACCREDIBLE" "DD" "HOME" "KETO" "PERSONAL" "PROJECTS" "HOMELAB")
MIN_HOURS=4
GLOBAL_BACKUPS="$BASE/BACKUPS"

mkdir -p "$GLOBAL_BACKUPS"

NOW_TS=$(date +%s)
NOW_HR=$(date "+%Y-%m-%d %H:%M:%S")

for VAULT in "${VAULTS[@]}"; do
    VAULT_PATH="$BASE/$VAULT"
    BACKUP_DIR="$VAULT_PATH/BACKUP"
    KEY_FILE="$BACKUP_DIR/key.txt"
    LAST_BACKUP_FILE="$BACKUP_DIR/last_backup.txt"
    ARCHIVE_RAW="$BACKUP_DIR/vault.tar.gz"
    ARCHIVE_ENC="$BACKUP_DIR/vault.tar.gz.enc"

    echo "============================================"
    echo "🔐 Processing vault: $VAULT"
    echo "Path: $VAULT_PATH"
    echo "============================================"

    if [ ! -d "$VAULT_PATH" ]; then
        echo "⚠️ Vault path missing, skipping."
        continue
    fi

    mkdir -p "$BACKUP_DIR"

    if [ ! -f "$KEY_FILE" ]; then
        echo "❌ Missing key file: $KEY_FILE"
        echo "   Create with: echo 'your-strong-password' > \"$KEY_FILE\""
        continue
    fi

    # Check last backup time
    if [ -f "$LAST_BACKUP_FILE" ]; then
        LAST_STR=$(cat "$LAST_BACKUP_FILE")
        LAST_TS=$(date -jf "%Y-%m-%d %H:%M:%S" "$LAST_STR" +%s 2>/dev/null || echo 0)
        if
```