FROM debian:bookworm-slim@sha256:a629e796d77a7b2ff82186ed15d01a493801c020eed5ce6adaa2704356f15a1c

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends postsrsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/postsrsd.secret

COPY rootfs/ /
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
