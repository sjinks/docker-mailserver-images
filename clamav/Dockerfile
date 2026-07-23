FROM debian:trixie-slim@sha256:28de0877c2189802884ccd20f15ee41c203573bd87bb6b883f5f46362d24c5c2

RUN \
    apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        clamav-daemon \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY clamd.conf.template /usr/local/share/clamd.conf.template
COPY entrypoint.sh /usr/local/bin/

VOLUME [ "/var/lib/clamav" ]

EXPOSE 3310

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
