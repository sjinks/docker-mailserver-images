FROM debian:trixie-slim@sha256:1d3c811171a08a5adaa4a163fbafd96b61b87aa871bbc7aa15431ac275d3d430

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends busybox-syslogd postgrey && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh

VOLUME [ "/var/lib/postgrey", "/etc/postgrey" ]

ENTRYPOINT [ "/entrypoint.sh" ]
