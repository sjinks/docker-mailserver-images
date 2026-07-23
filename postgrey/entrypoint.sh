#!/bin/sh

PATH=/usr/sbin:/usr/bin:/sbin:/bin

: "${POSTGREY_LISTEN:=0.0.0.0}"
: "${POSTGREY_PORT:=10030}"

if [ -z "${POSTGREY_DELAY}" ]; then
    POSTGREY_DELAY_ARG=""
else
    POSTGREY_DELAY_ARG="--delay=${POSTGREY_DELAY}"
fi

if [ -z "${POSTGREY_TEXT}" ]; then
    POSTGREY_TEXT_ARG=""
else
    POSTGREY_TEXT_ARG="--greylist-text=${POSTGREY_TEXT}"
fi

/usr/sbin/syslogd -n -O - -S &
pid1=$!

# shellcheck disable=SC2086
/usr/sbin/postgrey --inet="${POSTGREY_LISTEN}:${POSTGREY_PORT}" --user=postgrey --group=postgrey --dbdir=/var/lib/postgrey ${POSTGREY_DELAY_ARG} "${POSTGREY_TEXT_ARG}" &
pid2=$!

# shellcheck disable=SC2064
trap "kill ${pid1} ${pid2}" INT TERM
wait
