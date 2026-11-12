# ood-docker

Open ondemand developer environment for Swarthmore college

Before using, clone `https://github.com/swarthmore/ood-configs` into `./swarthmore-ood-configs`, and optionally remove `./swarthmore-ood-configs/.git`

Run `docker compose up` to start

The OnDemand per-user server runtime directory uses tmpfs so stale sockets and
PID files do not survive container restarts.

OnDemand startup copies the mounted profile YAML into a root-owned container file.
This is required because production OnDemand ignores non-root-owned configuration,
and macOS bind mounts can appear user-owned to the dashboard process.
Restart the OnDemand service after editing the profile YAML.

## Production dashboard configs

This Docker stack is development-only. To build dashboard and Job Composer UI
configs and assets for an existing production Open OnDemand server at
`firebird.swarthmore.edu`, run:

```sh
sh swarthmore-ood-configs/build.sh production
```

The output is `swarthmore-ood-configs/build/production/`. The `dev` argument builds
a separate localhost package without changing the working Docker environment.
See the [config repository's deployment instructions](swarthmore-ood-configs/README.md)
for installation, ownership, and production prerequisites.

## Job Composer demo

Job Composer branding, styles, and its site view override are mounted from the
config repository. Its database lives in the demo user's home directory, which
this stack does not persist across container replacement. In a fresh container,
initialize the local demo database before using Job Composer:

```sh
docker exec -u hpc.user ondemand bash -c '
  source /opt/ood/ondemand/enable
  cd /var/www/ood/apps/sys/myjobs
  mkdir -p /home/hpc.user/ondemand/data/sys/myjobs
  RAILS_ENV=production SECRET_KEY_BASE="$(openssl rand -hex 64)" bundle exec rake db:migrate
'
```

If Job Composer was opened before initialization, restart the user's web server
via the dashboard's Help menu afterward.

## Notes

* This compose strategy currently only works on `arm64`

* Current ood version used in this strategy is `3.1.1`

* The default login is `hpc.user:password`
