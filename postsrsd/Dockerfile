FROM debian:bookworm-slim@sha256:1537a6a1cbc4b4fd401da800ee9480207e7dc1f23560c21259f681db56768f63

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends postsrsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/postsrsd.secret

COPY rootfs/ /
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
