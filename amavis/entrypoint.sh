#!/bin/sh

set -eu

: "${AMAVIS_CONFIG_DIR:=/run/config/amavis}"

if [ ! -d "${AMAVIS_CONFIG_DIR}" ]; then
    printf '%s\n' "Mount Amavis configuration fragments at ${AMAVIS_CONFIG_DIR}." >&2
    exit 1
fi

cp -a "${AMAVIS_CONFIG_DIR}/." /etc/amavis/conf.d/

exec amavisd foreground
