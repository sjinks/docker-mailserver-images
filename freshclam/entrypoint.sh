#!/bin/sh

set -eu

: "${FRESHCLAM_CHECKS:=12}"
: "${FRESHCLAM_MIRROR:=database.clamav.net}"

escape_sed() {
    printf '%s' "$1" | sed 's/[&|]/\\&/g'
}

checks=$(escape_sed "${FRESHCLAM_CHECKS}")
mirror=$(escape_sed "${FRESHCLAM_MIRROR}")

install -d -o clamav -g clamav -m 0755 /var/lib/clamav

sed \
    -e "s|@CHECKS@|${checks}|g" \
    -e "s|@MIRROR@|${mirror}|g" \
    /usr/local/share/freshclam.conf.template > /etc/clamav/freshclam.conf

exec freshclam --foreground --config-file=/etc/clamav/freshclam.conf
