FROM debian:trixie-slim@sha256:62bd423aeee912639ca8ee681c2b762cb3e25137e0a92b20be455898a9f034ad

RUN \
    apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends busybox-syslogd dbconfig-no-thanks opendmarc publicsuffix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    install -d -m 0755 -o opendmarc -g opendmarc /etc/opendmarc && \
    install -d -m 0755 -o opendmarc -g opendmarc /etc/opendmarc/conf.d

COPY opendmarc.conf.base /etc/opendmarc/
COPY entrypoint.sh /usr/local/bin/

VOLUME [ "/etc/opendmarc/conf.d" ]
EXPOSE 8893
CMD [ "/usr/local/bin/entrypoint.sh" ]
