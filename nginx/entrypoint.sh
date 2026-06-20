#!/bin/sh

SLIMEVR_IP=$(ip -4 -o addr show dev eth0 2>/dev/null | awk '{print $4}' | cut -d/ -f1)
[ -z "$SLIMEVR_IP" ] && SLIMEVR_IP="127.0.0.1"

export SLIMEVR_IP

envsubst '$SLIMEVR_IP $WEBGUI_PORT' \
  < /etc/nginx/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
