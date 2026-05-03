#!/usr/bin/env bash
set -euo pipefail
TARGET=${1:-all}
if [[ "$TARGET" == "--help" ]]; then echo "Usage: health-check.sh [main|ram|all]"; exit 0; fi
fail=0
if [[ "$TARGET" == "main" || "$TARGET" == "all" ]]; then
 docker compose -f Flak.Management.Deployment/compose/main-server.compose.yml ps >/dev/null || fail=1
fi
if [[ "$TARGET" == "ram" || "$TARGET" == "all" ]]; then
 docker compose -f Flak.Management.Deployment/compose/ram-server.compose.yml ps >/dev/null || fail=1
fi
if [[ $fail -ne 0 ]]; then echo "Health checks failed"; exit 1; fi
echo "Health checks passed"
