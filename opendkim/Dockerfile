FROM debian:bookworm-slim@sha256:d365f4920711a9074c4bcd178e8f457ee59250426441ab2a5f8106ed8fe948eb

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
    install -m 0644 -o opendkim -g opendkim /dev/null /etc/dkimkeys/keytable && \
    install -m 0644 -o opendkim -g opendkim /dev/null /etc/dkimkeys/signingtable && \
    install -m 0644 -o opendkim -g opendkim /dev/null /etc/dkimkeys/trustedhosts

COPY opendkim.conf /etc/opendkim.conf
COPY entrypoint.sh genkey /usr/local/bin/

VOLUME [ "/etc/dkimkeys" ]

CMD [ "/usr/local/bin/entrypoint.sh" ]
