## Ghost URL / admin

Do **not** set `ADMIN_DOMAIN` to the text `SERVICE_URL_GHOST` in Coolify (that is a literal string, not a URL, and breaks Ghost with `ERR_INVALID_URL`). The compose file sets `admin__url` from `SERVICE_URL_GHOST` only. Remove `ADMIN_DOMAIN` from the app environment if you added it, or set it to a full `https://…` URL if you truly use a separate admin host.

`SERVICE_URL_GHOST` should be a full public URL with **no trailing slash** (e.g. `https://ghost-….example.com`).

## Analytics (Tinybird) and Coolify

- Compose sets `labs__publicAPI=true` and `tinybird__tracker__endpoint` to `${SERVICE_URL_GHOST}/.ghost/analytics/api/v1/page_hit`. Do **not** override the tracker URL to Tinybird’s `…/v0/events` — that address is for the **traffic-analytics** container (`PROXY_TARGET`), not for Ghost.
- Coolify’s reverse proxy must route **`/.ghost/analytics*`** on the Ghost hostname to the **traffic-analytics** service on port **3000**, with a path rewrite like this repo’s `caddy/snippets/TrafficAnalytics` (upstream should see paths such as `/api/v1/page_hit`). If that path is not proxied, page views never reach Tinybird.

## ActivityPub “Message queue is disabled”

That log line is **expected** unless you opt into Fedify’s message queue: set `USE_MQ=true` and configure Google Cloud Pub/Sub per [ActivityPub env vars](https://github.com/TryGhost/ActivityPub/blob/main/docs/env-vars.md). It is not required for basic federation.

## Migration

1. Create new app from public repository
2. Copy the ENV variables from existing ghost 5 coolify install into the new app (Helps to use developer view)
3. Login to coolify host and `cd /var/lib/docker/volumes`, then `cp -r` xxx_ghost-mysql-data and xxx_ghost-content-data 
   to yyy_ghost-mysql-data and yyy_ghost-content-data where xxx is the coolify service id of existing coolify 5 and yyy
   is the service id of your new service
4. Launch service
5. Visit the URL for the wizard and complete tiny bird setup
6. Copy the values for tinybird configuration
7. Stop the service
8. Find the volume directory for your original version of ghost 5 coolify mysql db, and the directory for the new one
   and replace the contents of the new directory with a copy of your old one 
   `/var/lib/docker/volumes/<appid>_ghost-mysql-data/`
9. Re-launch, if it looks good, stop old service, update URL's and relaunch... migrated boy!