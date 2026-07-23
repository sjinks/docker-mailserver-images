# Local Testing

Docker Compose is for local integration testing. It does not imply that services
must be deployed on the same server.

Run these commands from the repository root:

```sh
cp .env.example .env
docker compose build
docker compose config
```

The `dependencies` profile starts the filter and policy services:

```sh
docker compose --profile dependencies up --build
```

The `mail` profile starts a MySQL and Dovecot development pair with intentionally
non-secret local credentials. It is only a configuration and connectivity
baseline, not a production mailbox setup:

```sh
docker compose --profile mail up --build
```

The profile uses a non-production virtual mailbox, `test@example.test`, and
passes it through Postfix, Amavis, and Dovecot entirely on the Compose network.
It does not publish SMTP or mail retrieval ports to the host.

The validated path is Postfix content filtering to Amavis on private TCP 10024,
Amavis reinjection to Postfix on private TCP 10025, and LMTP delivery to
Dovecot on private TCP 24.

The `web` profile starts an Nginx configuration fixture with an internal
`/healthz` endpoint:

```sh
docker compose --profile web up --build
```

The `apps` profile starts private Roundcube and PostfixAdmin PHP-FPM fixtures
with development-only database settings:

```sh
docker compose --profile apps up --build
```

Production TLS material, database credentials, and DKIM keys belong under
`test/secrets/` only for local testing. That directory is intentionally ignored
by Git. Do not use production credentials or private keys in the test stack.

Generate a local Dovecot certificate before starting the `mail` profile:

```sh
mkdir -p test/secrets
openssl req -x509 -newkey rsa:2048 -nodes -days 7 \
	-keyout test/secrets/tls.key \
	-out test/secrets/tls.crt \
	-subj '/CN=mail.test.invalid'
```

Before a production deployment, test SMTP delivery, submission authentication,
LMTP delivery, quota rejection, SRS rewriting, spam and virus handling, DKIM
signing, DMARC policy evaluation, and certificate renewal against the tenant's
private service endpoints.
