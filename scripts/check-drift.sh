#!/usr/bin/env bash
# check-drift.sh — Deterministic drift detection between vm_artifacts and baseline.
# No LLMs. No file modification. Host-side only.
#
# Exit codes:
#   0 — no material drift
#   1 — material drift detected
#   2 — missing file or configuration error

set -euo pipefail

BASELINE="vm_baseline/artifacts.baseline"
CURRENT="vm_artifacts"
DRIFT=()

########################################
# Check 1 — Artifact presence
########################################

REQUIRED=(config.json packages.txt ports.txt firewall.txt usage.json)

for f in "${REQUIRED[@]}"; do
  if [[ ! -f "$BASELINE/$f" ]]; then
    echo "ERROR: Missing $BASELINE/$f" >&2
    exit 2
  fi
  if [[ ! -f "$CURRENT/$f" ]]; then
    echo "ERROR: Missing $CURRENT/$f" >&2
    exit 2
  fi
done

########################################
# Check 2 — config.json
# Strip volatile timestamp fields before comparing.
########################################

norm_json() {
  jq -S 'del(.timestamp_utc, .generated_at_utc)' "$1"
}

if ! diff <(norm_json "$BASELINE/config.json") \
          <(norm_json "$CURRENT/config.json") > /dev/null 2>&1; then
  DRIFT+=("config.json")
fi

########################################
# Check 3 — usage.json
# Strip volatile timestamp fields before comparing.
########################################

if ! diff <(norm_json "$BASELINE/usage.json") \
          <(norm_json "$CURRENT/usage.json") > /dev/null 2>&1; then
  DRIFT+=("usage.json")
fi

########################################
# Check 4 — ports.txt
# Normalize PIDs and FDs before comparing.
# (collector already does this; normalization here is defensive.)
########################################

norm_ports() {
  sed -E 's/pid=[0-9]+/pid=PID/g' "$1" \
    | sed -E 's/fd=[0-9]+/fd=FD/g' \
    | sort
}

if ! diff <(norm_ports "$BASELINE/ports.txt") \
          <(norm_ports "$CURRENT/ports.txt") > /dev/null 2>&1; then
  DRIFT+=("ports.txt")
fi

########################################
# Check 5 — firewall.txt
########################################

if ! diff "$BASELINE/firewall.txt" \
          "$CURRENT/firewall.txt" > /dev/null 2>&1; then
  DRIFT+=("firewall.txt")
fi

########################################
# Check 6 — packages.txt
########################################

if ! diff "$BASELINE/packages.txt" \
          "$CURRENT/packages.txt" > /dev/null 2>&1; then
  DRIFT+=("packages.txt")
fi

########################################
# Result
########################################

if [[ ${#DRIFT[@]} -eq 0 ]]; then
  echo "No material drift detected"
  exit 0
fi

echo "Material drift detected:"
for f in "${DRIFT[@]}"; do
  echo "  - $f"
done
exit 1
