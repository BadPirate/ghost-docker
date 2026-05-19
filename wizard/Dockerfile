# Tinybird datafiles must stay in sync with Ghost — bump GHOST_VERSION when upgrading Ghost.
ARG GHOST_VERSION=6-alpine
FROM ghost:${GHOST_VERSION} AS ghost-tinybird
USER root
RUN mkdir -p /export/tinybird && \
  cp -a /var/lib/ghost/current/core/server/data/tinybird/. /export/tinybird/

FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    curl \
    jq \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSf https://tinybird.co | sh
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /data/tinybird
COPY --from=ghost-tinybird /export/tinybird ./
WORKDIR /app

COPY tinybird/tb-wrapper /usr/local/bin/tb-wrapper
COPY tinybird/getTokens.sh /usr/local/bin/get-tokens
RUN chmod +x /usr/local/bin/tb-wrapper /usr/local/bin/get-tokens

COPY wizard/package.json wizard/package-lock.json ./
RUN npm ci --omit=dev

COPY wizard/server.js ./
COPY wizard/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

RUN mkdir -p /home/tinybird && chmod 700 /home/tinybird

ENV PORT=3989
EXPOSE 3989

ENTRYPOINT ["/app/entrypoint.sh"]
