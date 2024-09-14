#!/bin/sh

if [ -z "${POSTGREY_DELAY}" ] ; then
    POSTGREY_DELAY_ARG=""
else
    POSTGREY_DELAY_ARG="--delay=${POSTGREY_DELAY}"
fi

if [ -z "${POSTGREY_TEXT}" ] ; then
    POSTGREY_TEXT_ARG=""
else
    POSTGREY_TEXT_ARG="--greylist-text=${POSTGREY_TEXT}"
fi

# shellcheck disable=SC2086
exec /usr/sbin/postgrey --inet=0.0.0.0:10030 --user=postgrey --group=postgrey --dbdir=/var/lib/postgrey ${POSTGREY_DELAY_ARG} "${POSTGREY_TEXT_ARG}"
