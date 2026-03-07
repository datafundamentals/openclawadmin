#!/usr/bin/env bash

set -euo pipefail

ARTIFACT_DIR="artifacts"
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
VM_ID="$(hostname)"

mkdir -p "$ARTIFACT_DIR"

########################################
# config.json
########################################

cat > "$ARTIFACT_DIR/config.json" <<EOF
{
  "browser_tool_enabled": false,
  "shell_tool_enabled": false,
  "plugin_system_enabled": false,
  "ollama_access_enabled": false,
  "elasticsearch_access_mode": "disabled",
  "approved_llm_providers": ["anthropic", "openai", "gemini"]
}
EOF

########################################
# packages.txt
########################################

if command -v dpkg >/dev/null 2>&1; then
  dpkg -l > "$ARTIFACT_DIR/packages.txt"
elif command -v rpm >/dev/null 2>&1; then
  rpm -qa > "$ARTIFACT_DIR/packages.txt"
else
  echo "Unsupported package manager" > "$ARTIFACT_DIR/packages.txt"
fi

########################################
# ports.txt
########################################

if command -v ss >/dev/null 2>&1; then
  sudo ss -lntp \
    | sed -E 's/pid=[0-9]+/pid=PID/g' \
    | sed -E 's/fd=[0-9]+/fd=FD/g' \
    | sort \
    > "$ARTIFACT_DIR/ports.txt" || true
else
  netstat -lntp \
    | sed -E 's/pid=[0-9]+/pid=PID/g' \
    | sed -E 's/fd=[0-9]+/fd=FD/g' \
    | sort \
    > "$ARTIFACT_DIR/ports.txt" || true
fi

########################################
# usage.json
########################################

cat > "$ARTIFACT_DIR/usage.json" <<EOF
{
  "anthropic_calls": 0,
  "openai_calls": 0,
  "gemini_calls": 0,
  "estimated_cost_usd": null,
  "cap_threshold_warning": false
}
EOF

########################################
# metadata.json
########################################

cat > "$ARTIFACT_DIR/metadata.json" <<EOF
{
  "artifact_version": "0.1",
  "vm_identifier": "$VM_ID",
  "generated_at_utc": "$TIMESTAMP",
  "collector_version": "0.1",
  "mode": "automated-non-openclaw"
}
EOF

echo "Artifacts generated at $TIMESTAMP"

sudo ufw status verbose > "$ARTIFACT_DIR/firewall.txt" || true


