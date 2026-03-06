#!/usr/bin/env bash
set -euo pipefail

VM_USER="${VM_USER:-pete}"
VM_IP="${VM_IP:-192.168.64.3}"
VM_DIR="${VM_DIR:-~/openclawadmin}"

# Always sync the whole repo, excluding VM-local artifacts and reports.
rsync -az --delete \
  --exclude '.git/' \
  --exclude 'artifacts/' \
  --exclude 'baseline/' \
  --exclude 'reports/' \
  --exclude '*.log' \
  ./ "${VM_USER}@${VM_IP}:${VM_DIR}/"

echo "Synced repo to ${VM_USER}@${VM_IP}:${VM_DIR}"
