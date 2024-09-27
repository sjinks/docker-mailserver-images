FROM debian:bookworm-slim@sha256:7d7629aae6193dd56c2bb5315f779bdae2c0237766547c6548f4680471be977a

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends postsrsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/postsrsd.secret

COPY rootfs/ /
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
