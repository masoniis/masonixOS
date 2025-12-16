# Media serv info

## Server Migration

The nixarr service stores all the media service variable state in `/data/.state` so when transferring I'm pretty sure you can just copy that directory over to the new location.

Of course, copying media will be separate and copied via `/data/media`.
