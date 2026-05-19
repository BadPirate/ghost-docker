#!/bin/sh
# Wizard is now always-running: server.js picks proxy vs setup-wizard mode
# from TINYBIRD_* env vars (or WIZARD_SKIP=1 to force proxy mode).
set -e
mkdir -p /home/tinybird
exec node /app/server.js
