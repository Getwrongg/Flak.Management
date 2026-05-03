#!/usr/bin/env bash
set -euo pipefail
if [[ "${1:-}" == "--help" ]]; then echo "Usage: smoke-test.sh"; exit 0; fi
MANAGEMENT_WEB_URL=${MANAGEMENT_WEB_URL:-http://127.0.0.1:5100}
MANAGEMENT_API_URL=${MANAGEMENT_API_URL:-http://127.0.0.1:5101}
IDENTITY_API_URL=${IDENTITY_API_URL:-http://127.0.0.1:5102}
CACHE_API_URL=${CACHE_API_URL:-http://127.0.0.1:5201}
check(){ local u="$1"; if curl -fsS "$u" >/dev/null; then echo "PASS $u"; else echo "FAIL $u"; return 1; fi }
check "$MANAGEMENT_WEB_URL/health/live"
check "$MANAGEMENT_API_URL/health/live"
check "$MANAGEMENT_API_URL/api/info"
check "$IDENTITY_API_URL/health/live"
check "$IDENTITY_API_URL/api/info"
check "$CACHE_API_URL/api/cache/health"
