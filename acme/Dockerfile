FROM debian:trixie-slim@sha256:28de0877c2189802884ccd20f15ee41c203573bd87bb6b883f5f46362d24c5c2

RUN \
    apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        certbot \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/

VOLUME [ "/etc/letsencrypt", "/var/lib/letsencrypt", "/var/log/letsencrypt", "/var/www/acme" ]

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
