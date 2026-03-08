#!/usr/bin/env bash
# validate-artifacts.sh — Verify artifact integrity before auditors run.
# Runs on the host against vm_artifacts/.
# Called automatically by audit-run.py between sync and auditor steps.

set -euo pipefail

ARTIFACT_DIR="vm_artifacts"
ERRORS=0

fail() {
  echo "ERROR: $1" >&2
  ERRORS=$((ERRORS + 1))
}

########################################
# Check 1 — Required files exist
########################################

REQUIRED_FILES=(
  config.json
  metadata.json
  packages.txt
  ports.txt
  firewall.txt
  usage.json
)

for f in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$ARTIFACT_DIR/$f" ]]; then
    fail "Missing artifact file: $ARTIFACT_DIR/$f"
  fi
done

# If files are missing there is no point continuing
if [[ $ERRORS -gt 0 ]]; then
  echo "Artifact validation failed: $ERRORS error(s)" >&2
  exit 1
fi

########################################
# Check 2 — Files are not empty
########################################

for f in "${REQUIRED_FILES[@]}"; do
  if [[ ! -s "$ARTIFACT_DIR/$f" ]]; then
    fail "$f is empty"
  fi
done

########################################
# Check 3 — JSON syntax validation
########################################

JSON_FILES=(config.json metadata.json usage.json)

for f in "${JSON_FILES[@]}"; do
  if ! jq empty "$ARTIFACT_DIR/$f" 2>/dev/null; then
    fail "$f is not valid JSON"
  fi
done

########################################
# Check 4 — Required JSON keys
########################################

check_key() {
  local file="$1"
  local key="$2"
  if ! jq -e "has(\"$key\")" "$ARTIFACT_DIR/$file" > /dev/null 2>&1; then
    fail "$file is missing required key: $key"
  fi
}

check_key metadata.json generated_at_utc
check_key metadata.json collector_version

check_key config.json browser_tool_enabled
check_key config.json shell_tool_enabled
check_key config.json plugin_system_enabled
check_key config.json ollama_access_enabled
check_key config.json approved_llm_providers

check_key usage.json anthropic_calls
check_key usage.json openai_calls
check_key usage.json gemini_calls
check_key usage.json cap_threshold_warning

########################################
# Check 5 — packages.txt structure
########################################

if ! grep -q "^ii" "$ARTIFACT_DIR/packages.txt"; then
  fail "packages.txt does not contain expected dpkg entries (no lines starting with 'ii')"
fi

########################################
# Check 6 — ports.txt structure
########################################

if ! grep -q "LISTEN" "$ARTIFACT_DIR/ports.txt"; then
  fail "ports.txt contains no LISTEN entries"
fi

########################################
# Check 7 — firewall.txt structure
########################################

if ! grep -q "Status:" "$ARTIFACT_DIR/firewall.txt"; then
  fail "firewall.txt does not contain expected 'Status:' marker"
fi

########################################
# Result
########################################

if [[ $ERRORS -gt 0 ]]; then
  echo "Artifact validation failed: $ERRORS error(s)" >&2
  exit 1
fi

echo "Artifact validation successful"
