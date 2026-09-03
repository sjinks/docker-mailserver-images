FROM debian:trixie-slim@sha256:d7e12182ce18b85b93007c1dedf31f2d29e01ccf3182cc4017c709b6259bc132

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
