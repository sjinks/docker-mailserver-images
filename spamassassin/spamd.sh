#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ARGS=""

if [ -n "${SPAMD_MIN_SPARE}" ]; then
    ARGS="${ARGS} --min-spare=${SPAMD_MIN_SPARE}"
fi

if [ -n "${SPAMD_MAX_SPARE}" ]; then
    ARGS="${ARGS} --max-spare=${SPAMD_MAX_SPARE}"
fi

if [ -n "${SPAMD_MIN_CHILDREN}" ]; then
    ARGS="${ARGS} --min-children=${SPAMD_MIN_CHILDREN}"
fi

if [ -n "${SPAMD_MAX_CHILDREN}" ]; then
    ARGS="${ARGS} --max-children=${SPAMD_MAX_CHILDREN}"
fi

if [ -n "${SPAMD_MAX_CONNECTIONS}" ]; then
    ARGS="${ARGS} --max-conn-per-child=${SPAMD_MAX_CONNECTIONS}"
fi

if [ ! -e /var/lib/spamassassin/identity ]; then
    razor-admin -home=/var/lib/spamassassin -register
fi

su debian-spamd -s /bin/sh -c 'sa-update'

# shellcheck disable=SC2086
exec spamd ${ARGS} \
    --username=debian-spamd \
    --groupname=debian-spamd \
    --listen=0.0.0.0:783 \
    --allowed-ips=0.0.0.0/0 \
    --helper-home-dir=/var/lib/spamassassin \
    --pidfile=/run/spamd.pid \
    --syslog=stderr \
    --nouser-config
