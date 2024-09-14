#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

update-rules.sh &
pid1=$!
spamd.sh &
pid2=$!

# shellcheck disable=SC2064
trap "kill -TERM ${pid1} ${pid2}" TERM INT
wait
