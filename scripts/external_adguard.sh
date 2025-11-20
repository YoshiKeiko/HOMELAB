# Create the network
docker network create homelab-network

# Stop and remove old container
docker stop adguard-home && docker rm adguard-home

# Start with bridge mode
docker run -d \
  --name adguard-home \
  --restart unless-stopped \
  --network homelab-network \
  -p 53:53/tcp -p 53:53/udp \
  -p 3000:3000/tcp -p 3001:3001/tcp \
  -v /Volumes/HomeLab-4TB/Docker/Data/adguard/work:/opt/adguardhome/work \
  -v /Volumes/HomeLab-4TB/Docker/Data/adguard/conf:/opt/adguardhome/conf \
  adguard/adguardhome:latest

# Verify
docker ps | grep adguard