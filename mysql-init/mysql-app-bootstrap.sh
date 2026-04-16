#!/usr/bin/env bash
# Runs after mysqld is healthy (network_mode: service:mysql|db). Idempotent:
# - sync app user password with env (CREATE USER IF NOT EXISTS + ALTER USER)
# - CREATE DATABASE + GRANT for each name in MYSQL_MULTIPLE_DATABASES (comma-separated)
# Replaces initdb.d-only scripts: official mysql image is unchanged; no custom mysqld image.
set -euo pipefail
: "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD is required}"
: "${MYSQL_USER:?MYSQL_USER is required}"
: "${MYSQL_PASSWORD:?MYSQL_PASSWORD is required}"

for _ in $(seq 1 60); do
  if mysqladmin ping -h 127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" --silent 2>/dev/null; then
    break
  fi
  sleep 1
done

if ! mysqladmin ping -h 127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}" --silent 2>/dev/null; then
  echo "mysql-app-bootstrap: mysqld not reachable on 127.0.0.1" >&2
  exit 1
fi

printf 'CREATE USER IF NOT EXISTS '\''%s'\''@'\''%s'\'' IDENTIFIED BY '\''%s'\'';
ALTER USER '\''%s'\''@'\''%s'\'' IDENTIFIED BY '\''%s'\'';
' "${MYSQL_USER}" "%" "${MYSQL_PASSWORD}" \
  "${MYSQL_USER}" "%" "${MYSQL_PASSWORD}" \
  | mysql -h 127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}"

if [ -n "${MYSQL_MULTIPLE_DATABASES:-}" ]; then
  # shellcheck disable=SC2001
  for db in $(echo "${MYSQL_MULTIPLE_DATABASES}" | tr ',' ' '); do
    db="$(echo "${db}" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [ -z "${db}" ] && continue
    printf 'CREATE DATABASE IF NOT EXISTS `%s`;
GRANT ALL ON `%s`.* TO '\''%s'\''@'\''%s'\'';
' "${db}" "${db}" "${MYSQL_USER}" "%" \
      | mysql -h 127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}"
  done
fi

printf 'FLUSH PRIVILEGES;\n' | mysql -h 127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}"
