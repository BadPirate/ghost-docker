#!/usr/bin/env bash
# Idempotent activitypub DB + user + grants. Use with network_mode: service:mysql so root uses 127.0.0.1 like initdb scripts.
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
  echo "ensure-activitypub: mysqld not reachable on 127.0.0.1" >&2
  exit 1
fi

# CREATE USER IF NOT EXISTS does not refresh the password when the user already exists (e.g. volume from an
# older deploy or different MYSQL_PASSWORD). ALTER USER keeps Coolify env and MySQL in sync.
printf 'CREATE DATABASE IF NOT EXISTS `activitypub`;
CREATE USER IF NOT EXISTS '\''%s'\''@'\''%s'\'' IDENTIFIED BY '\''%s'\'';
ALTER USER '\''%s'\''@'\''%s'\'' IDENTIFIED BY '\''%s'\'';
GRANT ALL ON `activitypub`.* TO '\''%s'\''@'\''%s'\'';
FLUSH PRIVILEGES;
' "${MYSQL_USER}" "%" "${MYSQL_PASSWORD}" \
  "${MYSQL_USER}" "%" "${MYSQL_PASSWORD}" \
  "${MYSQL_USER}" "%" \
  | mysql -h 127.0.0.1 -uroot -p"${MYSQL_ROOT_PASSWORD}"
