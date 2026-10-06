FROM debian:trixie-slim@sha256:a29215f6a35e51e22adffa17f89e9d2ef06214e64a2bad10d765c46aea49f11f

RUN \
    apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        busybox-syslogd \
        libopendbx1-mysql libopendbx1-pgsql libopendbx1-sqlite3 \
        opendkim opendkim-tools \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    install -d -m 0755 -o opendkim -g opendkim /etc/opendkim && \
    install -d -m 0755 -o opendkim -g opendkim /etc/opendkim/conf.d && \
    install -m 0644 -o opendkim -g opendkim /dev/null /etc/dkimkeys/keytable && \
    install -m 0644 -o opendkim -g opendkim /dev/null /etc/dkimkeys/signingtable && \
    install -m 0644 -o opendkim -g opendkim /dev/null /etc/dkimkeys/trustedhosts

COPY opendkim.conf.base /etc/opendkim/
COPY entrypoint.sh genkey /usr/local/bin/

VOLUME [ "/etc/dkimkeys", "/etc/opendkim/conf.d" ]
EXPOSE 8891
CMD [ "/usr/local/bin/entrypoint.sh" ]
