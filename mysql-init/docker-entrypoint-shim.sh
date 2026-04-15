#!/usr/bin/env bash
# Prepends mysqld --init-file so activitypub DB + grants are applied on every MySQL start,
# not only when /docker-entrypoint-initdb.d runs (first empty volume only).
set -euo pipefail

f=/tmp/activitypub-boot.sql
printf 'CREATE DATABASE IF NOT EXISTS `activitypub`;
CREATE USER IF NOT EXISTS '\''%s'\''@'\''%s'\'' IDENTIFIED BY '\''%s'\'';
GRANT ALL ON `activitypub`.* TO '\''%s'\''@'\''%s'\'';
FLUSH PRIVILEGES;
' "${MYSQL_USER}" "%" "${MYSQL_PASSWORD}" "${MYSQL_USER}" "%" >"$f"

exec /usr/local/bin/docker-entrypoint.sh mysqld --init-file="$f"
