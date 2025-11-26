---
title: Claude Code Setup Guide
tags: [homelab, claude, ai, automation, tools]
created: 2025-11-26
updated: 2025-11-26
type: guide
---

# Claude Code Setup Guide

**AI-powered terminal automation for homelab management**

Claude Code is Anthropic's CLI tool that gives Claude direct terminal access on your machine. This enables automated troubleshooting, service management, and infrastructure tasks.

---

## Prerequisites

- [ ] macOS with Homebrew installed
- [ ] Node.js 18+
- [ ] Anthropic API key or Claude Pro subscription

---

## Installation

### Step 1: Install Node.js

```bash
brew install node
```

Verify installation:
```bash
node --version  # Should be 18+
npm --version
```

### Step 2: Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

### Step 3: Run Claude Code

```bash
claude
```

On first run, you'll be prompted to authenticate with your Anthropic account.

---

## Usage

### Basic Commands

```bash
# Start interactive session
claude

# Run a single command
claude "List all running docker containers"

# Skip all permission prompts (use with caution)
claude --dangerously-skip-permissions

# Run with full authority
claude --dangerously-skip-permissions "Fix all failing homelab services"
```

### Useful Prompts for Homelab

```bash
# Health check
claude "Run the health check script at /Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh"

# Fix failing services
claude "Check why container X is failing and fix it"

# Update containers
claude "Update all docker containers to latest versions"

# Check logs
claude "Show me the last 50 lines of logs for home assistant"

# Disk usage
claude "Check disk usage and find large files"
```

---

## MCP (Model Context Protocol) Setup

MCP allows Claude Desktop app to access your terminal directly.

### Step 1: Install Claude Desktop

```bash
brew install --cask claude
```

Or download from: https://claude.ai/download

### Step 2: Configure MCP

Create the config file:

```bash
mkdir -p ~/Library/Application\ Support/Claude

cat > ~/Library/Application\ Support/Claude/claude_desktop_config.json << 'EOF'
{
  "mcpServers": {
    "terminal": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-terminal"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/homelab",
        "/Volumes/HomeLab-4TB"
      ]
    }
  }
}
EOF
```

### Step 3: Alternative - Desktop Commander

If the official MCP terminal server isn't available, use Desktop Commander:

```bash
cat > ~/Library/Application\ Support/Claude/claude_desktop_config.json << 'EOF'
{
  "mcpServers": {
    "desktop-commander": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-commander"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/homelab",
        "/Volumes/HomeLab-4TB"
      ]
    }
  }
}
EOF
```

### Step 4: Restart Claude Desktop

1. Quit Claude Desktop completely (Cmd+Q)
2. Reopen Claude Desktop
3. Look for 🔨 hammer icon or 🔌 plug icon in chat input
4. Click to verify tools are available

---

## Security Considerations

### Safe Usage

| Mode | Risk | Use Case |
|------|------|----------|
| Interactive (default) | Low | Normal troubleshooting |
| `--dangerously-skip-permissions` | High | Trusted automation tasks |

### Best Practices

1. **Review commands** before approving in interactive mode
2. **Use skip-permissions sparingly** - only for trusted tasks
3. **Limit MCP access** to specific directories if needed
4. **Don't expose** to untrusted networks

### Limiting MCP Access

For more restrictive access, specify only needed directories:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/Users/homelab/HomeLab",
        "/Users/homelab/Documents/Obsidian/HOMELAB"
      ]
    }
  }
}
```

---

## Common Tasks

### Fix Failing Services

```bash
claude --dangerously-skip-permissions "Check docker logs for any containers in crash loop, identify the issue, and fix it"
```

### Update All Containers

```bash
claude "Pull latest images and recreate all docker containers"
```

### Backup Verification

```bash
claude "Check Kopia backup status and verify last backup completed successfully"
```

### Network Diagnostics

```bash
claude "Check if all services are responding on their expected ports"
```

---

## Troubleshooting

### "command not found: claude"

Run directly with node:
```bash
node /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code/cli.js
```

Or add to PATH:
```bash
export PATH="$PATH:$(npm bin -g)"
```

### MCP Not Working in Claude Desktop

1. Check config file exists:
```bash
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

2. Restart Claude Desktop completely
3. Check for tools icon in chat input

### Permission Denied

Add execute permissions:
```bash
chmod +x /path/to/script.sh
```

---

## Integration with Homelab

### Health Check Script Location

```
/Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh
```

### Running Health Checks

```bash
# Via Claude Code
claude "Run bash /Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh"

# Direct
bash /Users/homelab/Documents/Obsidian/HOMELAB/scripts/health-check.sh
```

---

## Related Pages

- [[Health-Check-Guide]]
- [[Master-Service-List]]
- [[Troubleshooting]]

---

*Last Updated: 2025-11-26*
