FROM debian:bookworm-slim@sha256:7d7629aae6193dd56c2bb5315f779bdae2c0237766547c6548f4680471be977a

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
