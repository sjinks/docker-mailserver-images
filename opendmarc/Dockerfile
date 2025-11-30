FROM debian:trixie-slim@sha256:18764e98673c3baf1a6f8d960b5b5a1ec69092049522abac4e24a7726425b016

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
