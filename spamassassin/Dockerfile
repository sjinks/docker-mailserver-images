FROM debian:trixie-slim@sha256:f6e2cfac5cf956ea044b4bd75e6397b4372ad88fe00908045e9a0d21712ae3ba

RUN \
    apt-get update -q && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        gnupg \
        libmail-dkim-perl \
        libmail-dmarc-perl \
        libmail-spf-perl \
        pyzor \
        razor \
        spamassassin \
        spamd \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    install -d -m 0700 -o debian-spamd -g debian-spamd /etc/spamassassin/sa-update-keys && \
    razor-admin -home=/var/lib/spamassassin/ -create && \
    echo "razor_config /var/lib/spamassassin/razor-agent.conf" >> /etc/mail/spamassassin/local.cf && \
    echo "pyzor_options --homedir /var/lib/spamassassin" >> /etc/mail/spamassassin/local.cf && \
    echo "razorhome = /var/lib/spamassassin" >> /var/lib/spamassassin/razor-agent.conf

COPY entrypoint.sh spamd.sh update-rules.sh /usr/local/bin/

VOLUME [ "/var/lib/spamassassin" ]
CMD [ "/usr/local/bin/entrypoint.sh" ]
