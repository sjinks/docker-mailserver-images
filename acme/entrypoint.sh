#!/bin/sh

set -eu

: "${CERTBOT_RENEW_INTERVAL:=43200}"

while :; do
    certbot renew --non-interactive
    sleep "${CERTBOT_RENEW_INTERVAL}"
done
