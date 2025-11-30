#!/bin/sh

set -e

PATH=/usr/sbin:/usr/bin:/sbin:/bin

/usr/sbin/syslogd -n -O - -S &
pid1=$!

cp -f /etc/opendmarc/opendmarc.conf.base /etc/opendmarc.conf
for file in /etc/opendmarc/conf.d/*.conf; do
    if [ -f "${file}" ]; then
        printf "\n\n#\n# %s\n#\n" "${file}" >> /etc/opendmarc.conf
        cat "${file}" >> /etc/opendmarc.conf
    fi
done

/usr/sbin/opendmarc -c /etc/opendmarc.conf -P /run/opendmarc/opendmarc.pid -f &
pid2=$!

set +e
# shellcheck disable=SC2064
trap "kill ${pid1} ${pid2}" INT TERM
wait
