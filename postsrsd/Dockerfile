FROM debian:bookworm-slim@sha256:d365f4920711a9074c4bcd178e8f457ee59250426441ab2a5f8106ed8fe948eb

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends postsrsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/postsrsd.secret

COPY rootfs/ /
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
