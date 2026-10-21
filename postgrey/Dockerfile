FROM debian:trixie-slim@sha256:62bd423aeee912639ca8ee681c2b762cb3e25137e0a92b20be455898a9f034ad

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends busybox-syslogd postgrey && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh

VOLUME [ "/var/lib/postgrey", "/etc/postgrey" ]

ENTRYPOINT [ "/entrypoint.sh" ]
