#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# Validation
: "${XRAY_UUID:?Required}"
: "${XRAY_PRIVATE_KEY:?Required}"
: "${SS_PASSWORD:?Required}"
: "${MTG_SECRET:?Required}"
: "${REALITY_SERVER_NAME:=learn.microsoft.com}"

export XRAY_UUID XRAY_PRIVATE_KEY SS_PASSWORD REALITY_SERVER_NAME

echo "[1/4] Generating xray config from template..."
envsubst < xray/config.template.json > xray/config.json

echo "[2/4] Writing .env..."
cat > .env <<ENV
MTG_SECRET=${MTG_SECRET}
ENV

echo "[3/4] Pulling images..."
docker-compose pull

echo "[4/4] Starting services..."
docker-compose up -d

echo "Health check..."
sleep 3
docker-compose ps
docker-compose logs --tail=10 xray mtproto-proxy

echo "Done."
