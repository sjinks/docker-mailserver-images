# Mail Service Architecture

## Goals

- One long-running service per container.
- A service may run on a different host from every dependency.
- Images contain software and startup logic only. Tenant configuration, keys,
  certificates, and passwords are injected at deployment time.
- All non-public service interfaces are reachable only through the private
  network.

## Service Interfaces

| Service | Public interfaces | Private interfaces | Persistent state |
| --- | --- | --- | --- |
| Postfix | SMTP 25, submission 587, SMTPS 465 | Amavis SMTP, Dovecot auth and LMTP, quota status, SPF, Postgrey, PostSRSd, DKIM and DMARC milters | mail queue |
| Dovecot | IMAP 143/993, POP3 110/995, ManageSieve 4190 | auth 12345, LMTP 24, quota status 12340 | Maildir, Sieve state |
| Amavis | none | filter SMTP and Postfix reinjection SMTP | quarantine when enabled |
| ClamAV daemon | none | clamd 3310 | virus database, shared read-only with the daemon |
| FreshClam | none | none | virus database, shared write access with the updater |
| SpamAssassin | none | spamd 783 | rules and Razor/Pyzor data |
| Postgrey | none | policy TCP | greylist database and allowlists |
| PostSRSd | none | TCP canonical maps 10001 and 10002 | stable SRS secret |
| OpenDKIM | none | milter TCP 8891 | DKIM private keys and mapping tables |
| OpenDMARC | none | milter TCP 8893 | optional reports and state |
| MySQL | none | MySQL 3306 | PostfixAdmin and Roundcube databases |
| Nginx | HTTP 80 and HTTPS 443 | FastCGI or HTTP to web applications | ACME challenge files |
| Roundcube | none | FastCGI or HTTP from Nginx, MySQL | application configuration |
| PostfixAdmin | none | FastCGI or HTTP from Nginx, MySQL | application configuration |
| ACME controller | HTTP challenge when selected | certificate distribution | ACME account and certificates |

## Mail Flow

1. Postfix applies SPF policy, quota status, Postgrey, and reputation checks.
2. OpenDKIM and OpenDMARC run as separate Postfix milters. OpenDKIM is the
   sole DKIM signer in the target architecture; Amavis DKIM signing is disabled.
3. Postfix sends content to Amavis. Amavis calls ClamAV and SpamAssassin over
   the private network, then reinjects accepted mail into Postfix.
4. Postfix uses LMTP to deliver virtual mail to Dovecot. It must not depend on
   a local `dovecot-lda` executable or a shared Unix socket.
5. Dovecot reads users and quota limits from MySQL, tracks usage with its count
  backend, and owns Maildir and Sieve data.

## Network Rules

- Expose only SMTP, submission, SMTPS, IMAP, POP3, ManageSieve, HTTP, and HTTPS
  through host firewalls or load balancers as required by the tenant.
- Keep MySQL, LMTP, Dovecot auth, quota status, filter SMTP, policy services,
  milters, clamd, and spamd private.
- SpamAssassin defaults to accepting only loopback clients. Deployments that
  place Amavis elsewhere must set `SPAMD_ALLOWED_IPS` to narrowly scoped private
  mesh CIDRs or addresses.
- Use the standalone SPF policy service through Postfix
  `check_policy_service inet:<private-host>:10031`; do not rely on a Postfix
  process-local policy spawn when services may be deployed separately.
- Use stable private DNS names and explicit host and port configuration. Do not
  use `localhost` for cross-service references.
- Restrict the Dovecot auth listener to the private network. It carries SMTP
  authentication traffic and must never be publicly routable.

## Configuration and Secrets

Each tenant has an inventory that maps services to hosts and private DNS names.
Non-secret values include domains, ports, endpoints, quota defaults, and feature
switches. Use Docker secrets, SOPS, Vault, or an equivalent mechanism for:

- MySQL credentials and application keys
- Dovecot SQL configuration
- DKIM private keys
- PostSRSd secret
- TLS certificates and private keys
- ACME account credentials

Do not commit tenant credentials, live certificates, DKIM keys, Maildir data,
or database dumps to this repository.

The Postfix and Amavis images intentionally require mounted configuration rather
than attempting to infer a deployment from environment variables. Their complete
configuration controls mail routing and policy, and must be reviewed as tenant
configuration alongside the secrets it references.

Nginx likewise requires a complete mounted configuration. The ACME container
only renews existing certificates; initial issuance is an explicit deployment
job using the same persistent ACME state and challenge webroot. Mount renewed
certificate material read-only into each TLS consumer, rather than sharing a
writable certificate volume between hosts.

Roundcube and PostfixAdmin run as separate PHP-FPM services. Nginx is their only
public-facing peer and connects over private FastCGI. Each application receives
its own mounted PHP configuration, including a least-privilege database account;
neither application image is responsible for issuing mail-server credentials.

## Current Baseline Notes

The inspected host uses a PostfixAdmin-compatible MySQL schema, Dovecot virtual
Maildir storage, Dovecot quota status on TCP 12340, Amavis filtering, ClamAV,
SpamAssassin, Postgrey, and PostSRSd. Its configured OpenDMARC milter is
inactive. The container design deliberately does not preserve that fail-open
configuration.
