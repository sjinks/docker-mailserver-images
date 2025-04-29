FROM debian:bookworm-slim@sha256:4b50eb66f977b4062683ff434ef18ac191da862dbe966961bc11990cf5791a8d

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends postsrsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/postsrsd.secret

COPY rootfs/ /
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
