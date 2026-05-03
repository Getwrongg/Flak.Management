#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../../.."
ENV_FILE="Flak.Management.Deployment/env/main-server.env"
[ -f "$ENV_FILE" ] || { echo "Missing $ENV_FILE"; exit 1; }
source "$ENV_FILE"
export ConnectionStrings__PlatformDatabase="Host=127.0.0.1;Port=${POSTGRES_HOST_PORT:-5432};Database=${POSTGRES_DB};Username=${POSTGRES_USER};Password=${POSTGRES_PASSWORD}"
dotnet run --project src/Flak.Infrastructure/Flak.Infrastructure.csproj -- migrate
