# 1. Stop and remove container completely
docker stop duplicati
docker rm duplicati

# 2. Delete ALL Duplicati data
rm -rf ~/HomeLab/Docker/Data/duplicati

# 3. Recreate directory
mkdir -p ~/HomeLab/Docker/Data/duplicati

# 4. Get encryption key again
ENCRYPTION_KEY=$(openssl rand -base64 32)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚠️  SAVE THIS KEY IN 1PASSWORD:"
echo "$ENCRYPTION_KEY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 5. Create completely fresh container
docker run -d \
  --name duplicati \
  --restart unless-stopped \
  -p 8202:8200 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e SETTINGS_ENCRYPTION_KEY="$ENCRYPTION_KEY" \
  -v ~/HomeLab/Docker/Data/duplicati:/config \
  -v ~/HomeLab/Docker/Data:/source \
  lscr.io/linuxserver/duplicati:latest

# 6. Wait and watch logs
echo "Waiting 30 seconds..."
sleep 30

# 7. Check logs
docker logs duplicati --tail 20

# 8. Open browser
open http://localhost:8202