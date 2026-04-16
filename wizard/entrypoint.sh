#!/bin/sh
set -e

mkdir -p /home/tinybird

# All five must be non-empty (after stripping whitespace-only).
for v in TINYBIRD_API_URL TINYBIRD_WORKSPACE_ID TINYBIRD_ADMIN_TOKEN TINYBIRD_TRACKER_TOKEN TINYBIRD_TRACKER_ENDPOINT; do
  eval "val=\$$v"
  if [ -z "$(echo "$val" | tr -d '[:space:]')" ]; then
    exec node /app/server.js
  fi
done

exit 0
