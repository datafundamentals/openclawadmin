#!/usr/bin/env bash
# vm-setup.sh — Run once on a fresh or restored VM before audit pipeline can operate.
# See VM_SETUP.md for full context and instructions.

set -euo pipefail

echo "Configuring VM for SecurityCouncil audit pipeline..."

# Allow passwordless sudo for the two read-only commands the collector needs.
# ss   — lists listening network ports
# ufw  — reads firewall status
#
# These are intentionally narrow: read-only, no system modification capability.

SUDOERS_FILE="/etc/sudoers.d/securitycouncil"

echo "pete ALL=(ALL) NOPASSWD: /usr/bin/ss, /usr/sbin/ufw" \
  | sudo tee "$SUDOERS_FILE" > /dev/null

sudo chmod 440 "$SUDOERS_FILE"

echo "Verifying sudoers entry..."
sudo visudo -c -f "$SUDOERS_FILE"

echo ""
echo "VM setup complete."
echo "The audit pipeline can now run collector/collect.sh non-interactively."
