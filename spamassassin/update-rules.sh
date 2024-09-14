#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

while true; do
    sleep 86400
    su debian-spamd -s /bin/sh -c 'sa-update' && R=0 || R=$?
    case "${R}" in
        0)
        ;;
        1)
            exit 0
        ;;
        *)
            exit "${R}"
        ;;
    esac

    if [ -f /run/spamd.pid ]; then
        pid=$(cat /run/spamd.pid)
        kill -SIGHUP "${pid}"
    fi
done
