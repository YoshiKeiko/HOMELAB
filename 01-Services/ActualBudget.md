# 💰 Actual Budget

## Overview
| Property | Value |
|----------|-------|
| **URL** | http://192.168.50.50:5006 |
| **Container** | actual-budget |
| **Image** | actualbudget/actual-server:latest |
| **Port** | 5006 |
| **Data** | /Volumes/HomeLab-4TB/Docker-Data/actual-budget |

## Features
- Zero-based budgeting
- Bank sync support
- Reports and analytics
- Multi-device sync
- Local-first data
- Import from YNAB

## First Setup
1. Visit http://192.168.50.50:5006
2. Create password on first visit
3. Create or import budget

## ⚠️ Known Issue: SharedArrayBuffer Error

**Problem**: "Actual requires access to SharedArrayBuffer to function properly"

**Cause**: SharedArrayBuffer requires secure context (HTTPS) due to browser security policies.

**Solutions**:

### Option 1: Use Nginx Proxy Manager (Recommended)
1. Open NPM: http://192.168.50.50:81
2. Add Proxy Host for actual.homelab.local
3. Enable SSL with Let's Encrypt or self-signed
4. Access via https://actual.homelab.local

### Option 2: Chrome Flag (Development Only)
1. Open chrome://flags
2. Enable "Insecure origins treated as secure"
3. Add http://192.168.50.50:5006

### Option 3: Use Desktop App
- Download from: https://actualbudget.com/download

## Tags
#service #home #budget #finance #money
