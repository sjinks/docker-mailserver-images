# Tenant Deployment

`tenants/<name>/tenant.json` contains only non-secret tenant facts: image
references, domains, service placement, and private DNS endpoints. A host lists
the services it owns and a Compose template to render. Never add passwords,
private keys, ACME credentials, or certificates to this file.

Render a host bundle on the target host or trusted deployment runner:

```sh
python3 deploy/render_tenant.py validate tenants/example
python3 deploy/render_tenant.py render tenants/example mx-1 generated/mx-1
docker compose -f generated/mx-1/compose.yaml config
```

The renderer copies only `config/<host>/` into the generated bundle. Secret
files are supplied out of band under `generated/<host>/secrets/`, which is
ignored by Git. Docker Compose mounts these as files under `/run/secrets`.

## Placement Samples

`tenants/all-in-one` places every service on one host. `tenants/all-separate`
uses host-local template values to place every service on its own host. Both are
non-deployable placement references: add complete service configuration, private
DNS endpoints, firewall rules, and fresh secrets before use.

## New Deployment Order

1. Create private DNS records and firewall rules for the declared service graph.
2. Generate new per-tenant secrets: database passwords, DKIM keys, SRS secret,
   ACME account, and initial TLS material.
3. Create least-privilege database accounts and initialize empty PostfixAdmin
   and Roundcube schemas.
4. Deploy MySQL and Dovecot with empty Maildir and Sieve volumes, then validate
   IMAP, LMTP, quota status, and authentication over private endpoints.
5. Deploy ClamAV, FreshClam, SpamAssassin, Postgrey, PostSRSd, SPF, OpenDKIM,
   OpenDMARC, and Amavis. Verify each private interface from its intended peer.
6. Deploy Postfix with remote policy, milter, content-filter, auth, quota, and
   LMTP endpoints. Validate inbound SMTP and authenticated submission.
7. Issue certificates, deploy Nginx and the PHP-FPM application services, then
   validate Roundcube and PostfixAdmin.
8. Publish MX and client DNS only after DKIM, DMARC, SRS, spam, virus,
   quota, backup, and certificate-renewal acceptance tests pass.

Use one host bundle per deployment target. A service can move to another host by
changing its inventory placement and configuration endpoint, without rebuilding
an image or sharing a host filesystem.
