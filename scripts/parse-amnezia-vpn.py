#!/usr/bin/env python3
"""Extract Xray client settings from an Amnezia .vpn export."""

from __future__ import annotations

import base64
import json
import sys
import zlib
from pathlib import Path


def fail(message: str) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(1)


def decode_export(raw_text: str) -> dict:
    if not raw_text.startswith("vpn://"):
        fail("Expected file contents to start with 'vpn://'.")

    payload = raw_text[len("vpn://") :].strip()
    if not payload:
        fail("Amnezia export payload is empty.")

    padded = payload + ("=" * (-len(payload) % 4))

    try:
        blob = base64.urlsafe_b64decode(padded)
    except Exception as exc:  # pragma: no cover
        fail(f"Failed to base64url-decode Amnezia export: {exc}")

    if len(blob) < 5:
        fail("Decoded payload is too short.")

    try:
        decoded = zlib.decompress(blob[4:])
    except Exception as exc:  # pragma: no cover
        fail(f"Failed to decompress Amnezia payload: {exc}")

    try:
        return json.loads(decoded)
    except Exception as exc:  # pragma: no cover
        fail(f"Failed to decode decompressed JSON: {exc}")


def extract_xray_config(export_data: dict) -> dict:
    containers = export_data.get("containers")
    if not isinstance(containers, list) or not containers:
        fail("No containers found in Amnezia export.")

    xray_entry = None
    for container in containers:
        if isinstance(container, dict) and container.get("container") == "amnezia-xray":
            xray_entry = container.get("xray")
            break

    if not isinstance(xray_entry, dict):
        fail("No amnezia-xray container config found in export.")

    last_config = xray_entry.get("last_config")
    if not isinstance(last_config, str) or not last_config.strip():
        fail("No xray.last_config found in export.")

    try:
        return json.loads(last_config)
    except Exception as exc:  # pragma: no cover
        fail(f"Failed to parse xray.last_config JSON: {exc}")


def build_summary(config: dict) -> dict:
    outbounds = config.get("outbounds")
    if not isinstance(outbounds, list) or not outbounds:
        fail("Xray config has no outbounds.")

    outbound = outbounds[0]
    if not isinstance(outbound, dict):
        fail("First outbound in Xray config is not an object.")

    settings = outbound.get("settings", {})
    vnext = settings.get("vnext", [])
    if not isinstance(vnext, list) or not vnext:
        fail("Outbound has no vnext targets.")

    target = vnext[0]
    users = target.get("users", [])
    if not isinstance(users, list) or not users:
        fail("Outbound target has no users.")

    user = users[0]
    stream_settings = outbound.get("streamSettings", {})
    reality = stream_settings.get("realitySettings", {})

    result = {
        "address": target.get("address", ""),
        "port": target.get("port", ""),
        "id": user.get("id", ""),
        "flow": user.get("flow", ""),
        "encryption": user.get("encryption", "none"),
        "network": stream_settings.get("network", "tcp"),
        "security": stream_settings.get("security", "reality"),
        "fingerprint": reality.get("fingerprint", "chrome"),
        "serverName": reality.get("serverName", ""),
        "publicKey": reality.get("publicKey", ""),
        "shortId": reality.get("shortId", ""),
        "spiderX": reality.get("spiderX", ""),
        "raw_config": config,
    }

    required = ["address", "port", "id", "serverName", "publicKey", "shortId"]
    missing = [key for key in required if result.get(key) in ("", None, [])]
    if missing:
        fail(f"Parsed config is missing required keys: {', '.join(missing)}")

    return result


def main() -> None:
    if len(sys.argv) != 2:
        fail("Usage: parse-amnezia-vpn.py /path/to/client.amnezia.vpn")

    source = Path(sys.argv[1])
    if not source.is_file():
        fail(f"File not found: {source}")

    raw_text = source.read_text(encoding="utf-8").strip()
    export_data = decode_export(raw_text)
    xray_config = extract_xray_config(export_data)
    summary = build_summary(xray_config)
    print(json.dumps(summary))


if __name__ == "__main__":
    main()
