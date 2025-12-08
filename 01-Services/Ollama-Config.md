# Ollama AI Configuration

## Current Setup (Updated: 2025-12-07)

### Active Model
- **Default Model**: `qwen2.5:14b` (9GB, faster responses)
- **Alternative**: `qwen2.5:32b` (19GB, more capable but slower)

### Endpoints
| Service | URL | Status |
|---------|-----|--------|
| Ollama API | http://192.168.50.50:11434 | ✓ Active |
| Open WebUI | http://192.168.50.50:3000 | ✓ Active |
| Jupyter | http://192.168.50.50:8888 | ✓ Active |

### Auto-Update Schedule
- **Script**: `/Users/homelab/HomeLab/scripts/update-ollama-models.sh`
- **Schedule**: Weekly (Sunday 3am) via cron
- **Actions**: Updates all models, warms up default model for 24h keep-alive

### Open WebUI Configuration
- **Data Path**: `/Users/homelab/HomeLab/Docker/Data/openwebui/data`
- **Default**: Set `qwen2.5:14b` as default in web interface Settings → Models

### Model Comparison
| Model | Size | Speed | Use Case |
|-------|------|-------|----------|
| qwen2.5:14b | 9GB | Fast | Daily tasks, quick responses |
| qwen2.5:32b | 19GB | Slower | Complex reasoning, longer context |

### Commands
```bash
# Check running models
ollama ps

# Switch to 14b (default)
curl -s http://localhost:11434/api/generate -d '{"model":"qwen2.5:14b","prompt":"test","stream":false,"keep_alive":"24h"}'

# Switch to 32b (heavy tasks)
curl -s http://localhost:11434/api/generate -d '{"model":"qwen2.5:32b","prompt":"test","stream":false,"keep_alive":"24h"}'

# Update all models
/Users/homelab/HomeLab/scripts/update-ollama-models.sh
```
