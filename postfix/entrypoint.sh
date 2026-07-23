#!/bin/sh

set -eu

: "${POSTFIX_CONFIG_DIR:=/run/config/postfix}"

if [ ! -f "${POSTFIX_CONFIG_DIR}/main.cf" ] || [ ! -f "${POSTFIX_CONFIG_DIR}/master.cf" ]; then
    printf '%s\n' "Mount a complete Postfix configuration at ${POSTFIX_CONFIG_DIR}." >&2
    exit 1
fi

cp -a "${POSTFIX_CONFIG_DIR}/." /etc/postfix/
postfix check

exec postfix start-fg
