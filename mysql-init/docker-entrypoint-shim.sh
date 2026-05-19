#!/usr/bin/env bash
# Restored so a bind mount to /docker-entrypoint-shim.sh is a file (Docker creates an empty
# DIRECTORY at the target if the source path was missing — then bash errors: "Is a directory").
#
# Current compose does not use this as entrypoint. If an old deploy still has:
#   entrypoint: ["/bin/bash", "/docker-entrypoint-shim.sh"]
#   volumes: [ "./mysql-init/docker-entrypoint-shim.sh:/docker-entrypoint-shim.sh:ro" ]
# this delegates to the official MySQL image entrypoint.
#
# This file also lives under /docker-entrypoint-initdb.d/ (whole mysql-init is mounted there).
# It must stay non-executable (chmod a-x) so mysql docker-entrypoint SOURCES it; we no-op.
# See docker-library/mysql docker_process_init_files: executable .sh is run; else sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  exec /usr/local/bin/docker-entrypoint.sh "$@"
fi
return 0
