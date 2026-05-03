#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
ENV_FILE="env/main-server.env"
[ -f "$ENV_FILE" ] || { echo "Missing $ENV_FILE"; exit 1; }
source "$ENV_FILE"
docker compose -f compose/main-server.compose.yml --env-file "$ENV_FILE" pull
if [ "${FLAK_IMAGE_MODE:-build}" = "build" ]; then docker compose -f compose/main-server.compose.yml --env-file "$ENV_FILE" build --pull; fi
docker compose -f compose/main-server.compose.yml --env-file "$ENV_FILE" up -d --remove-orphans
bash scripts/linux/health-check.sh main
