# One-shot bootstrap sidecar: mysql client + script only. The mysql *server* service uses stock mysql:8
# (see compose). Build context = repo root (Coolify clone); scripts are baked in at build time.
ARG MYSQL_BASE=mysql:8.0.44@sha256:f37951fc3753a6a22d6c7bf6978c5e5fefcf6f31814d98c582524f98eae52b21

FROM ${MYSQL_BASE}
COPY mysql-init/mysql-app-bootstrap.sh /mysql-app-bootstrap.sh
ENTRYPOINT ["/bin/bash", "/mysql-app-bootstrap.sh"]
