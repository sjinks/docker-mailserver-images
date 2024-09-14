#!/bin/sh

PATH=/usr/sbin:/usr/bin:/sbin:/bin

: "${SRS_DOMAIN:?}"
: "${SRS_FORWARD_PORT:=10001}"
: "${SRS_REVERSE_PORT:=10002}"
: "${SRS_EXCLUDE_DOMAINS:=}"
: "${SRS_SEPARATOR:=+}"
: "${SRS_HASHLENGTH:=4}"
: "${SRS_HASHMIN:=4}"
: "${SRS_EXTRA_OPTIONS:=}"

if [ ! -f /etc/postsrsd.secret ]; then
    dd if=/dev/urandom bs=24 count=1 2>/dev/null | base64 -w0 > /etc/postsrsd.secret
fi

# Can't use `exec` because `postsrsd` blocks signals
# shellcheck disable=SC2086,SC2248
/usr/sbin/postsrsd \
    ${SRS_EXTRA_OPTIONS} -d "${SRS_DOMAIN}" \
    -l 0.0.0.0 -f "${SRS_FORWARD_PORT}" -r "${SRS_REVERSE_PORT}" \
    -s /etc/postsrsd.secret \
    -a "${SRS_SEPARATOR}" -n "${SRS_HASHLENGTH}" -N "${SRS_HASHMIN}" \
    -u postsrsd \
    -X"${SRS_EXCLUDE_DOMAINS}"
