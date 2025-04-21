#!/bin/sh
# entrypoint.sh abreviado

# 1) Detecta interfaz de la ruta por defecto
INTERFACE=$(ip route get 1 | awk '/dev/ {print $5; exit}')

# 2) Saca la IP de esa interfaz
SLIMEVR_IP=$(ip -4 -o addr show dev "$INTERFACE" \
  | awk '{print $4}' \
  | cut -d/ -f1)

export SLIMEVR_IP
echo "➡️  Usando $INTERFACE con IP $SLIMEVR_IP"

# 3) Procesa el template y arranca nginx
envsubst '$SLIMEVR_IP $WEBGUI_PORT' \
  < /etc/nginx/templates/default.conf.template \
  > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
