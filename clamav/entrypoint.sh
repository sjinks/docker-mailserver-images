#!/bin/sh

set -eu

: "${CLAMD_LISTEN:=0.0.0.0}"
: "${CLAMD_PORT:=3310}"
: "${CLAMD_MAX_FILE_SIZE:=25M}"
: "${CLAMD_MAX_SCAN_SIZE:=100M}"
: "${CLAMD_DATABASE_WAIT_SECONDS:=600}"

escape_sed() {
    printf '%s' "$1" | sed 's/[&|]/\\&/g'
}

listen=$(escape_sed "${CLAMD_LISTEN}")
port=$(escape_sed "${CLAMD_PORT}")
max_file_size=$(escape_sed "${CLAMD_MAX_FILE_SIZE}")
max_scan_size=$(escape_sed "${CLAMD_MAX_SCAN_SIZE}")

install -d -o clamav -g clamav -m 0755 /var/lib/clamav

waited=0
until find /var/lib/clamav -maxdepth 1 -type f \( -name '*.cvd' -o -name '*.cld' \) -print -quit | grep -q .; do
    if [ "${waited}" -ge "${CLAMD_DATABASE_WAIT_SECONDS}" ]; then
        printf '%s\n' "No ClamAV database was downloaded within the configured wait period." >&2
        exit 1
    fi
    sleep 2
    waited=$((waited + 2))
done

sed \
    -e "s|@TCP_ADDR@|${listen}|g" \
    -e "s|@TCP_PORT@|${port}|g" \
    -e "s|@MAX_FILE_SIZE@|${max_file_size}|g" \
    -e "s|@MAX_SCAN_SIZE@|${max_scan_size}|g" \
    /usr/local/share/clamd.conf.template > /etc/clamav/clamd.conf

exec clamd --config-file=/etc/clamav/clamd.conf
