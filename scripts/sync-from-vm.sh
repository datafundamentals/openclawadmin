#!/usr/bin/env bash
set -euo pipefail

VM_USER="${VM_USER:-pete}"
VM_IP="${VM_IP:-192.168.64.3}"
VM_DIR="${VM_DIR:-/home/pete/openclawadmin}"

mkdir -p vm_artifacts vm_baseline vm_reports

echo "Pulling artifacts from ${VM_USER}@${VM_IP}:${VM_DIR}/artifacts/"
rsync -av "${VM_USER}@${VM_IP}:${VM_DIR}/artifacts/" ./vm_artifacts/

echo "Pulling baseline from ${VM_USER}@${VM_IP}:${VM_DIR}/baseline/"
rsync -av "${VM_USER}@${VM_IP}:${VM_DIR}/baseline/" ./vm_baseline/ || true

echo "Pulling reports from ${VM_USER}@${VM_IP}:${VM_DIR}/reports/"
rsync -av "${VM_USER}@${VM_IP}:${VM_DIR}/reports/" ./vm_reports/ || true

echo "Done."
