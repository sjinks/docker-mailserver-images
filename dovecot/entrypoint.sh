#!/bin/sh

set -eu

: "${VMAIL_USER:=vmail}"
: "${VMAIL_GROUP:=mail}"
: "${VMAIL_UID:=150}"
: "${VMAIL_GID:=8}"
: "${DOVECOT_SQL_CONFIG:=/run/secrets/dovecot-sql.conf}"
: "${DOVECOT_TLS_MODE:=required}"
: "${DOVECOT_TLS_CERT:=/run/secrets/tls.crt}"
: "${DOVECOT_TLS_KEY:=/run/secrets/tls.key}"
: "${DOVECOT_LISTEN:=*}"
: "${DOVECOT_AUTH_PORT:=12345}"
: "${DOVECOT_LMTP_PORT:=24}"
: "${DOVECOT_QUOTA_PORT:=12340}"

if ! getent group "${VMAIL_GROUP}" > /dev/null; then
    groupadd --gid "${VMAIL_GID}" "${VMAIL_GROUP}"
fi

if ! id -u "${VMAIL_USER}" > /dev/null 2>&1; then
    useradd --uid "${VMAIL_UID}" --gid "${VMAIL_GROUP}" --home-dir /var/vmail --no-create-home --shell /usr/sbin/nologin "${VMAIL_USER}"
fi

if [ ! -r "${DOVECOT_SQL_CONFIG}" ]; then
    printf '%s\n' "Required configuration file is not readable: ${DOVECOT_SQL_CONFIG}" >&2
    exit 1
fi

if [ "${DOVECOT_TLS_MODE}" != "no" ]; then
    for file in "${DOVECOT_TLS_CERT}" "${DOVECOT_TLS_KEY}"; do
        if [ ! -r "${file}" ]; then
            printf '%s\n' "Required TLS file is not readable: ${file}" >&2
            exit 1
        fi
    done
fi

install -d -o "${VMAIL_USER}" -g "${VMAIL_GROUP}" -m 0750 /var/vmail
install -d -o "${VMAIL_USER}" -g "${VMAIL_GROUP}" -m 0750 /var/lib/dovecot/sieve

escape_sed() {
    printf '%s' "$1" | sed 's/[&|]/\\&/g'
}

vmail_user=$(escape_sed "${VMAIL_USER}")
vmail_group=$(escape_sed "${VMAIL_GROUP}")
vmail_uid=$(escape_sed "${VMAIL_UID}")
sql_config=$(escape_sed "${DOVECOT_SQL_CONFIG}")
tls_mode=$(escape_sed "${DOVECOT_TLS_MODE}")
tls_cert=$(escape_sed "${DOVECOT_TLS_CERT}")
tls_key=$(escape_sed "${DOVECOT_TLS_KEY}")
listen=$(escape_sed "${DOVECOT_LISTEN}")
auth_port=$(escape_sed "${DOVECOT_AUTH_PORT}")
lmtp_port=$(escape_sed "${DOVECOT_LMTP_PORT}")
quota_port=$(escape_sed "${DOVECOT_QUOTA_PORT}")

sed \
    -e "s|@VMAIL_USER@|${vmail_user}|g" \
    -e "s|@VMAIL_GROUP@|${vmail_group}|g" \
    -e "s|@VMAIL_UID@|${vmail_uid}|g" \
    -e "s|@LISTEN@|${listen}|g" \
    -e "s|@SQL_CONFIG@|${sql_config}|g" \
    -e "s|@TLS_MODE@|${tls_mode}|g" \
    -e "s|@TLS_CERT@|${tls_cert}|g" \
    -e "s|@TLS_KEY@|${tls_key}|g" \
    -e "s|@AUTH_PORT@|${auth_port}|g" \
    -e "s|@LMTP_PORT@|${lmtp_port}|g" \
    -e "s|@QUOTA_PORT@|${quota_port}|g" \
    /usr/local/share/dovecot.conf.template > /etc/dovecot/dovecot.conf

exec dovecot -F
