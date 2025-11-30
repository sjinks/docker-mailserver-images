#!/bin/sh

set -e

PATH=/usr/sbin:/usr/bin:/sbin:/bin

/usr/sbin/syslogd -n -O - -S &
pid1=$!

cp -f /etc/opendkim/opendkim.conf.base /etc/opendkim.conf
for file in /etc/opendkim/conf.d/*.conf; do
    if [ -f "${file}" ]; then
        printf "\n\n#\n# %s\n#\n" "${file}" >> /etc/opendkim.conf
        cat "${file}" >> /etc/opendkim.conf
    fi
done

/usr/sbin/opendkim -x /etc/opendkim.conf -f &
pid2=$!

set +e
# shellcheck disable=SC2064
trap "kill ${pid1} ${pid2}" INT TERM
wait
