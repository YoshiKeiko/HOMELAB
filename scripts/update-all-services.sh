#!/bin/bash

echo "Updating all HomeLab services..."
echo ""

cd ~/HomeLab/Docker/Compose

for file in *.yml; do
    echo "Updating $file..."
    docker compose -f "$file" pull
    docker compose -f "$file" up -d
    echo ""
done

echo "All services updated!"
docker ps --format "table {{.Names}}\t{{.Status}}"
