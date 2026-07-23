#!/bin/sh

set -eu

: "${NGINX_CONFIG_DIR:=/run/config/nginx}"

if [ ! -f "${NGINX_CONFIG_DIR}/nginx.conf" ]; then
    printf '%s\n' "Mount an nginx.conf at ${NGINX_CONFIG_DIR}." >&2
    exit 1
fi

cp -a "${NGINX_CONFIG_DIR}/." /etc/nginx/
nginx -t

exec nginx -g 'daemon off;'
