# VM Setup Guide

This document covers everything needed to get the audit pipeline running
after either a fresh VM creation or a restore from the clean UTM snapshot.

---

## Current operating mode: Manual collection

The collector requires `sudo` for two commands (`ss` and `ufw`). Until it is
clear which capabilities OpenClaw will need, we are not granting passwordless
sudo on the VM. The audit is therefore run in two steps: collection on the VM
(interactive, sudo prompt is fine), then analysis on the host.

See the Future section at the bottom if this decision is ever revisited.

---

## Step 1 — Copy your SSH key to the VM (one time only)

Eliminates password prompts for SSH and rsync. Does not grant any extra
privileges — just replaces the password with a key for authentication.

```bash
ssh-copy-id pete@192.168.64.3
```

You will be asked for the VM password once. After this, SSH and rsync
connect silently.

---

## Step 2 — Sync the repo to the VM (after every restore or significant change)

```bash
./scripts/sync-to-vm.sh
```

---

## Step 3 — Run the audit (every time)

### Part A: Collect artifacts on the VM

```bash
ssh pete@192.168.64.3
cd ~/openclawadmin
./collector/collect.sh
exit
```

The collector will prompt for your sudo password once (for `ss` and `ufw`).
This is expected and intentional.

### Part B: Run the analysis on the host

```bash
python3 scripts/audit-run.py --skip-collect
```

This syncs the artifacts, runs the four auditors, runs the aggregator,
and writes the report to `vm_reports/`.

---

## Why the clean snapshot stays clean

The UTM snapshot captures the VM before any work was done.
This document is the bridge between that clean state and operational use.

Keeping them separate means:
- The snapshot is a reliable rollback point at any time
- Setup requirements are version-controlled here, not baked into the image
- Future changes to this process update this document, not the snapshot

---

## Troubleshooting

**SSH still asks for a password**
- Check the key was copied: a line from `~/.ssh/id_rsa.pub` should appear
  in `~/.ssh/authorized_keys` on the VM

**collector.sh fails on `ss` or `ufw`**
- These commands require sudo. Type your password when prompted — this is normal.

**exposure section is empty in the report**
- The collector likely failed silently on `ss` or `ufw`
- Re-run `./collector/collect.sh` on the VM and check for errors

**audit-run.py fails at sync step**
- Confirm the VM is running in UTM
- Confirm the VM IP hasn't changed after restore: `ssh pete@192.168.64.3`

---

## Future: Fully automated mode

If at some point passwordless sudo is deemed acceptable (after OpenClaw
capability decisions are settled), `scripts/vm-setup.sh` contains the
sudoers configuration needed to enable it. Review the security tradeoffs
documented in the git history before enabling.

When enabled, the full pipeline runs unattended as:

```bash
python3 scripts/audit-run.py
```
