FROM debian:trixie-slim@sha256:28de0877c2189802884ccd20f15ee41c203573bd87bb6b883f5f46362d24c5c2

RUN \
    apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        dovecot-core \
        dovecot-imapd \
        dovecot-lmtpd \
        dovecot-managesieved \
        dovecot-mysql \
        dovecot-pop3d \
        dovecot-sieve \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY dovecot.conf.template /usr/local/share/dovecot.conf.template
COPY entrypoint.sh /usr/local/bin/

VOLUME [ "/var/lib/dovecot", "/var/vmail" ]

EXPOSE 24 110 143 993 995 4190 12340 12345

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
