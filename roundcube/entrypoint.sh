#!/bin/sh

set -eu

: "${ROUNDCUBE_CONFIG_DIR:=/run/config/roundcube}"

if [ ! -f "${ROUNDCUBE_CONFIG_DIR}/config.inc.php" ]; then
    printf '%s\n' "Mount config.inc.php at ${ROUNDCUBE_CONFIG_DIR}." >&2
    exit 1
fi

cp "${ROUNDCUBE_CONFIG_DIR}/config.inc.php" /etc/roundcube/config.inc.php
sed -i 's#^listen =.*#listen = 9000#' /etc/php/8.4/fpm/pool.d/www.conf

exec php-fpm8.4 -F
