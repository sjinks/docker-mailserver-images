#!/bin/sh

set -eu

: "${POSTFIXADMIN_CONFIG_DIR:=/run/config/postfixadmin}"

if [ ! -f "${POSTFIXADMIN_CONFIG_DIR}/config.local.php" ]; then
    printf '%s\n' "Mount config.local.php at ${POSTFIXADMIN_CONFIG_DIR}." >&2
    exit 1
fi

cp "${POSTFIXADMIN_CONFIG_DIR}/config.local.php" /etc/postfixadmin/config.local.php
sed -i 's#^listen =.*#listen = 9000#' /etc/php/8.4/fpm/pool.d/www.conf

exec php-fpm8.4 -F
