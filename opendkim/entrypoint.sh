#!/bin/sh

PATH=/usr/sbin:/usr/bin:/sbin:/bin

/usr/sbin/syslogd -n -O - -S &
pid1=$!

/usr/sbin/opendkim -u opendkim -p inet:8891@0.0.0.0 -P /run/opendkim/opendkim.pid -f &
pid2=$!

# shellcheck disable=SC2064
trap "kill ${pid1} ${pid2}" INT TERM
wait
