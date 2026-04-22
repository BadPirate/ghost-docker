## Ghost URL / admin

Do **not** set `ADMIN_DOMAIN` to the text `SERVICE_URL_GHOST` in Coolify (that is a literal string, not a URL, and breaks Ghost with `ERR_INVALID_URL`). The compose file sets `admin__url` from `SERVICE_URL_GHOST` only. Remove `ADMIN_DOMAIN` from the app environment if you added it, or set it to a full `https://…` URL if you truly use a separate admin host.

`SERVICE_URL_GHOST` must be a full URL with **no trailing slash** (e.g. `https://godutch.us`).

Set **`MAIL_FROM`** to a valid transactional From line, e.g. `"'Your Site' <noreply@mg.yourdomain.com>"` (see `.env.example` `mail__from`). Without it, Ghost logs `Missing mail.from config` and uses a generated address.

## Traffic analytics (same-origin)

Ghost is configured with `tinybird__tracker__endpoint: ${SERVICE_URL_GHOST}/.ghost/analytics/api/v1/page_hit` so the browser hits the **same host** as the site (CORS). Route `/.ghost/analytics` on that host to the **traffic-analytics** service (port **3000**) in Traefik/Coolify and **strip** the `/.ghost/analytics` prefix so the container sees `/api/v1/page_hit`, matching `caddy/snippets/TrafficAnalytics`.

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