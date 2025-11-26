---
title: Volume 09: AI Services (Day 10)
tags: [homelab, ai, llm, ollama, machine-learning]
created: 2025-11-11
type: homelab-guide
---

# Volume 09: AI Services (Day 10)

**Local AI with Ollama, Document Management, and Photo Organization**

This volume covers AI-powered services running locally.

## What You'll Complete

- Ollama (local LLM server)
- Open WebUI (ChatGPT-like interface)
- LM Studio integration
- Paperless-ngx (document management with OCR)
- Immich (Google Photos alternative)
- All running locally with privacy

## Prerequisites

- Volumes 01-08 complete
- Docker running
- 16GB RAM available
- External storage for photos/documents

---

# Guide 56: Ollama

## Deploy Ollama

```bash
docker compose -f docker-compose-master.yml up -d ollama
```

Access: http://192.168.50.10:11434

## Pull Models

```bash
# SSH to M4 or use terminal

# Pull models
docker exec -it ollama ollama pull llama3.2:3b
docker exec -it ollama ollama pull mistral:7b
docker exec -it ollama ollama pull codellama:7b
docker exec -it ollama ollama pull phi3:mini

# List models
docker exec -it ollama ollama list
```

## Test Ollama

```bash
# Chat with model
docker exec -it ollama ollama run llama3.2:3b

>>> Hello! How are you?
>>> exit
```

---

# Guide 57: Open WebUI

## Deploy Open WebUI

```bash
docker compose -f docker-compose-master.yml up -d open-webui
```

Access: http://192.168.50.10:3000

## Setup

1. Create admin account:
   - Name: Steve
   - Email: steve-smithit@outlook.com
   - Password: [strong password]

2. Save to 1Password

3. Connect to Ollama:
   - Settings → Connections
   - Ollama URL: http://ollama:11434
   - Test connection

## Use Open WebUI

- ChatGPT-like interface
- Select model: llama3.2, mistral, etc.
- All runs locally on M4!
- Private - no data sent to cloud

**Access via Tailscale from phone:**
- http://100.x.x.x:3000 (M4's Tailscale IP)
- Your personal ChatGPT on phone!

---

# Guide 58: LM Studio Integration

## Install LM Studio on M4

```bash
# Download from: https://lmstudio.ai
# Install to /Applications/
```

## Configure LM Studio

1. Download models via GUI
2. Start local server
3. API compatible with OpenAI

## Alternative to Open WebUI

Use LM Studio's native interface:
- Better for M4 optimization
- Apple Silicon optimized
- GPU acceleration
- Local file access

---

# Guide 59: Paperless-ngx

## Deploy Paperless

```bash
docker compose -f docker-compose-master.yml up -d paperless-ngx
```

Access: http://192.168.50.10:8010

## Setup

1. Create superuser:
   - Username: steve
   - Email: steve-smithit@outlook.com
   - Password: [strong password]

2. Save to 1Password

## Configure OCR

- Settings → OCR
- Language: English
- Enable: Text recognition
- Enable: Barcode detection

## Usage

**Upload documents:**
1. Drag and drop PDFs, images
2. Paperless OCRs automatically
3. Extracts text, dates, correspondents
4. Fully searchable

**Organization:**
- Tags: Bills, Receipts, Contracts, Medical
- Correspondents: Companies, people
- Document types: Invoice, Letter, etc.

**Workflows:**
- Email documents to Paperless
- Mobile app upload
- Automatic inbox processing

**Benefits:**
- Searchable archive
- OCR all documents
- Encrypted storage
- Version history
- Email integration

---

# Guide 60: Immich

## Deploy Immich

```bash
docker compose -f docker-compose-master.yml up -d immich-server immich-machine-learning
```

Access: http://192.168.50.10:2283

## Setup

1. Create admin account:
   - Name: Steve Smith
   - Email: steve-smithit@outlook.com
   - Password: [strong password]

2. Save to 1Password

## Configure Storage

- External Library: /photos
- Points to: /Volumes/External4TB/Photos/Immich

## Features

**Photo Management:**
- Upload from phone (iOS/Android app)
- Automatic backup
- Face recognition (local ML)
- Object detection
- Smart search: "dog", "beach", "birthday"
- Timeline view
- Albums and sharing

**Machine Learning:**
- Runs locally (no cloud)
- Face detection and clustering
- Object/scene recognition
- Smart search
- Duplicate detection

**Mobile App:**
1. Install Immich app (iOS/Android)
2. Server URL: http://192.168.50.10:2283
3. Or via Tailscale: http://100.x.x.x:2283
4. Enable auto-backup
5. Replaces Google Photos!

**Privacy:**
- All processing local
- No cloud upload
- Full control of data
- Encrypted storage

---

# Guide 61: AI Service Access

## URLs

```
Ollama API:    http://192.168.50.10:11434
Open WebUI:    http://192.168.50.10:3000
Paperless:     http://192.168.50.10:8010
Immich:        http://192.168.50.10:2283
```

## Add to Nginx Proxy Manager

For external access:
- ai.stevehomelab.duckdns.org → Open WebUI
- docs.stevehomelab.duckdns.org → Paperless
- photos.stevehomelab.duckdns.org → Immich

---

# Guide 62: Model Management

## Recommended Models

**For M4 (32GB RAM):**

**Small (fast, efficient):**
- llama3.2:3b (3GB) - General chat
- phi3:mini (2GB) - Fast responses
- mistral:7b (4GB) - Better quality

**Medium (balanced):**
- llama3.1:8b (8GB) - Good all-rounder
- codellama:13b (7GB) - Code generation

**Large (best quality, slower):**
- llama3.1:70b (40GB) - Best quality
- mixtral:8x7b (26GB) - Fast large model

## Download Models

```bash
# Via CLI
docker exec -it ollama ollama pull llama3.1:8b

# Or via Open WebUI:
# Settings → Models → Pull a model
```

---

## Volume 09 Complete!

You now have:
- ✅ Ollama running multiple local LLMs
- ✅ Open WebUI (ChatGPT alternative)
- ✅ LM Studio for desktop AI
- ✅ Paperless-ngx (intelligent document management)
- ✅ Immich (Google Photos alternative)
- ✅ All AI processing locally (private!)
- ✅ Mobile access via apps

**AI Stack Summary:**
```
Local AI Services:
├─ Ollama (LLM server)
│  ├─ llama3.2:3b
│  ├─ mistral:7b
│  └─ codellama:7b
├─ Open WebUI (chat interface)
├─ Paperless-ngx (OCR + document AI)
└─ Immich (photo AI + face recognition)

All running on M4, fully private!
```

**Next: Volume 10 - Security Stack**



---

#homelab #ai #llm #ollama #machine-learning
