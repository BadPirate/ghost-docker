## Ghost URL / admin

Do **not** set `ADMIN_DOMAIN` to the text `SERVICE_URL_GHOST` in Coolify (that is a literal string, not a URL, and breaks Ghost with `ERR_INVALID_URL`). The compose file sets `admin__url` from `SERVICE_URL_GHOST` only. Remove `ADMIN_DOMAIN` from the app environment if you added it, or set it to a full `https://…` URL if you truly use a separate admin host.

## Migration

1. Create new app from public repository
2. Copy the ENV variables from existing ghost 5 coolify install into the new app (Helps to use developer view)
3. Login to coolify host and `cd /var/lib/docker/volumes`, then `cp -r` xxx_ghost-mysql-data and xxx_ghost-content-data 
   to yyy_ghost-mysql-data and yyy_ghost-content-data where xxx is the coolify service id of existing coolify 5 and yyy
   is the service id of your new service
4. Launch service