FROM debian:trixie-slim@sha256:a99cfc517144bc59b1978475ec53b46ecabec7e43635402ee5b77cc54cd1b20a

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
