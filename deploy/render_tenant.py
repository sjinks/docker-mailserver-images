#!/usr/bin/env python3
"""Validate and render host-specific tenant deployment bundles."""

import argparse
import json
import re
import shutil
import sys
from pathlib import Path


SERVICES = {
    "acme", "amavis", "clamav", "dovecot", "freshclam", "mysql", "nginx",
    "opendkim", "opendmarc", "postfix", "postfixadmin", "postgrey", "postsrsd",
    "roundcube", "spamassassin", "spf-policy",
}
TOKEN = re.compile(r"{{([A-Z][A-Z0-9_]*)}}")
SECRET_NAME = re.compile(r"(PASSWORD|SECRET|TOKEN|PRIVATE_KEY|API_KEY)", re.I)
RESERVED_VALUE_NAMES = {"TENANT_NAME", "HOST_NAME", "SERVICES"}


def fail(message):
    raise ValueError(message)


def validate_values(values, location):
    if not isinstance(values, dict):
        fail("{} values must be an object".format(location))
    for key, value in values.items():
        if not re.fullmatch(r"[A-Z][A-Z0-9_]*", key):
            fail("invalid value name: {}".format(key))
        if SECRET_NAME.search(key):
            fail("secret-like value {} belongs in a secret provider, not tenant.json".format(key))
        if not isinstance(value, (str, int, float, bool)):
            fail("value {} must be scalar".format(key))


def load_inventory(tenant_dir):
    inventory_path = tenant_dir / "tenant.json"
    try:
        data = json.loads(inventory_path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        fail("missing tenant.json")
    except json.JSONDecodeError as error:
        fail("invalid tenant.json: {}".format(error))

    if data.get("version") != 1:
        fail("tenant.json version must be 1")
    if not isinstance(data.get("tenant"), str) or not data["tenant"]:
        fail("tenant must be a non-empty string")
    validate_values(data.get("values"), "tenant")
    if not isinstance(data.get("hosts"), dict) or not data["hosts"]:
        fail("hosts must be a non-empty object")

    for host, definition in data["hosts"].items():
        if not re.fullmatch(r"[a-z0-9][a-z0-9-]*", host):
            fail("invalid host name: {}".format(host))
        if not isinstance(definition, dict):
            fail("host {} must be an object".format(host))
        services = definition.get("services")
        if not isinstance(services, list) or not services:
            fail("host {} must declare services".format(host))
        if len(set(services)) != len(services) or not set(services) <= SERVICES:
            fail("host {} declares unknown or duplicate services".format(host))
        if not isinstance(definition.get("template"), str):
            fail("host {} must declare a template".format(host))
        host_values = definition.get("values", {})
        validate_values(host_values, "host {}".format(host))
        if RESERVED_VALUE_NAMES.intersection(host_values):
            fail("host {} overrides a reserved value".format(host))
    return data


def render_template(source, values):
    missing = []

    def replace(match):
        key = match.group(1)
        if key not in values:
            missing.append(key)
            return match.group(0)
        return str(values[key])

    rendered = TOKEN.sub(replace, source)
    if missing:
        fail("template has missing values: {}".format(", ".join(sorted(set(missing)))))
    if TOKEN.search(rendered):
        fail("template contains unresolved tokens")
    return rendered


def render(tenant_dir, host, output_dir):
    inventory = load_inventory(tenant_dir)
    if host not in inventory["hosts"]:
        fail("unknown host: {}".format(host))
    if output_dir.exists() and any(output_dir.iterdir()):
        fail("output directory must be empty: {}".format(output_dir))

    host_definition = inventory["hosts"][host]
    template_path = tenant_dir / host_definition["template"]
    if not template_path.is_file():
        fail("missing host template: {}".format(template_path))

    values = {key: str(value) for key, value in inventory["values"].items()}
    values.update({key: str(value) for key, value in host_definition.get("values", {}).items()})
    values.update({
        "TENANT_NAME": inventory["tenant"],
        "HOST_NAME": host,
        "SERVICES": ",".join(host_definition["services"]),
    })
    output_dir.mkdir(parents=True, exist_ok=True)
    config_dir = tenant_dir / "config" / host
    if config_dir.exists():
        for source_path in config_dir.rglob("*"):
            relative_path = source_path.relative_to(config_dir)
            target_path = output_dir / "config" / relative_path
            if source_path.is_dir():
                target_path.mkdir(parents=True, exist_ok=True)
                continue
            target_path.parent.mkdir(parents=True, exist_ok=True)
            if source_path.suffix == ".tmpl":
                target_path = target_path.with_suffix("")
                target_path.write_text(
                    render_template(source_path.read_text(encoding="utf-8"), values),
                    encoding="utf-8",
                )
            else:
                shutil.copy2(source_path, target_path)
    (output_dir / "compose.yaml").write_text(
        render_template(template_path.read_text(encoding="utf-8"), values),
        encoding="utf-8",
    )
    (output_dir / "deployment.json").write_text(
        json.dumps({"tenant": inventory["tenant"], "host": host,
                    "services": host_definition["services"]}, indent=2) + "\n",
        encoding="utf-8",
    )


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    validate = subparsers.add_parser("validate")
    validate.add_argument("tenant", type=Path)
    render_command = subparsers.add_parser("render")
    render_command.add_argument("tenant", type=Path)
    render_command.add_argument("host")
    render_command.add_argument("output", type=Path)
    args = parser.parse_args()
    try:
        if args.command == "validate":
            load_inventory(args.tenant)
        else:
            render(args.tenant, args.host, args.output)
    except ValueError as error:
        print("error: {}".format(error), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
