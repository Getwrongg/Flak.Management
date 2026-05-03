#!/usr/bin/env bash
set -euo pipefail
command -v docker >/dev/null
docker compose version >/dev/null
echo "Environment validation passed"
