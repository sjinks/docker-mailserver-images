#!/bin/sh

set -eu

: "${SPF_POLICY_LISTEN:=0.0.0.0}"
: "${SPF_POLICY_PORT:=10031}"

exec socat \
    "TCP-LISTEN:${SPF_POLICY_PORT},bind=${SPF_POLICY_LISTEN},reuseaddr,fork" \
    EXEC:/usr/local/bin/policy-service.sh,stderr
