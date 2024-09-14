FROM debian:bookworm-slim

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends postgrey && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh

VOLUME [ "/var/lib/postgrey", "/etc/postgrey" ]

ENTRYPOINT [ "/bin/sh", "-c", "/entrypoint.sh" ]
