#!/bin/bash

# Production dashboard config must be root-owned, including from the user's view.
install -D -o root -g root -m 0644 /etc/ood/site-config/swarthmore.yml \
  /etc/ood/config/ondemand.d/swarthmore.yml || exit 1

# Start ondemand-dex in the background
# config.yaml is default 
runuser -u ondemand-dex -- /usr/sbin/ondemand-dex serve /etc/ood/dex/config.yaml &

# Start httpd in the foreground
exec /usr/sbin/httpd -D FOREGROUND
