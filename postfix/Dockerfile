FROM debian:trixie-slim@sha256:28de0877c2189802884ccd20f15ee41c203573bd87bb6b883f5f46362d24c5c2

RUN \
    apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    echo 'postfix postfix/mailname string mail.invalid' | debconf-set-selections && \
    echo 'postfix postfix/main_mailer_type string Internet Site' | debconf-set-selections && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libsasl2-modules \
        postfix \
        postfix-mysql \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/

VOLUME [ "/var/spool/postfix" ]

EXPOSE 25 465 587

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
