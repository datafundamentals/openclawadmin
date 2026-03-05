#!/usr/bin/env bash
set -euo pipefail

VM_USER="${VM_USER:-pete}"
VM_IP="${VM_IP:-192.168.64.3}"
VM_DIR="${VM_DIR:-~/openclawadmin}"

mkdir -p vm_reports

rsync -az \
  "${VM_USER}@${VM_IP}:${VM_DIR}/reports/" ./vm_reports/ 2>/dev/null || true

echo "Pulled VM reports into ./vm_reports/"
