# Portainer - Docker Management

**URL:** http://localhost:9000  
**Tailscale:** http://TAILSCALE_IP:9000  
**Time:** 5 minutes

## What is Portainer?

Your control panel for all Docker containers. Essential for managing your homelab.

## Configuration Steps

### Step 1: Initial Access
- [ ] Open http://localhost:9000
- [ ] You should see the Portainer login/setup page

### Step 2: Create Admin Account
- [ ] Set username (e.g., `admin`)
- [ ] Set a **strong** password (save to 1Password)
- [ ] Click "Create User"

### Step 3: Connect to Docker
- [ ] Select "Docker" (not Kubernetes)
- [ ] Choose "Connect using socket"
- [ ] Click "Connect"

### Step 4: Explore the Interface
- [ ] Click "local" environment
- [ ] Click "Containers" - you should see all 47 services
- [ ] Click on a container to view:
  - Logs (useful for troubleshooting)
  - Stats (CPU/RAM usage)
  - Console (execute commands)

### Step 5: Bookmark It
- [ ] Bookmark http://localhost:9000
- [ ] You'll use this CONSTANTLY

## What You Can Do

**View All Containers:**
- See which are running (green)
- Which are stopped (red)
- Resource usage for each

**Manage Containers:**
- Start/Stop/Restart any service
- View real-time logs
- Check resource usage
- Execute commands inside containers

**Troubleshooting:**
- When a service isn't working, check logs here first
- Restart containers with one click
- See error messages immediately

## Common Tasks

**Restart a Service:**
1. Click "Containers"
2. Find the service
3. Click the circular arrow icon

**View Logs:**
1. Click container name
2. Click "Logs" tab
3. Toggle "Auto-refresh" for live logs

**Check Resource Usage:**
1. Click container name
2. Click "Stats" tab
3. See CPU, RAM, Network usage

## Tips

- Keep Portainer open in a pinned browser tab
- Check logs when troubleshooting ANY service
- Use the search box to find containers quickly
- Set up Portainer app on your phone for mobile management

## ✅ Verification

- [ ] Can log in to Portainer
- [ ] Can see all 47 containers
- [ ] Can view logs of any container
- [ ] Can restart a test container successfully

## Next Step

→ Configure [Heimdall Dashboard](03-Heimdall.md) to access all your services easily

