FROM debian:trixie-slim@sha256:f6b08b09a05725f9431502d3b5714f5c4576e82c1a84fa1debe0c24a7e0c3ec4

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
