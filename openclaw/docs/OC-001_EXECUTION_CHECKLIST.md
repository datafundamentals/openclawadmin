# OC-001 Execution Checklist

This checklist executes `OC-001` (install OpenClaw runtime with zero tools enabled) while preserving SecurityCouncil Mode B.

Reference unlock note:

- `openclaw/docs/unlocks/OC-001-install-openclaw-runtime-zero-tools.md`

## 0. Session Metadata

- Date:
- Operator:
- VM IP:
- UTM snapshot name (pre-install):
- OpenClaw source (repo URL or local tarball path):
- OpenClaw version/tag/commit:

## 1. Preflight (Host)

Run from host repo root:

```bash
pwd
./scripts/sync-to-vm.sh
```

Expected:

- Repo sync to VM completes without errors.

## 2. Snapshot Gate (UTM)

Before changing VM state:

- Confirm pre-install snapshot exists.
- If not, create one now.

Stop if this is not complete.

## 3. VM Directory Isolation

SSH to VM and create isolated runtime path:

```bash
ssh pete@<VM_IP>
mkdir -p /home/pete/openclaw-runtime
cd /home/pete/openclaw-runtime
```

Expected:

- OpenClaw runtime path exists and is outside SecurityCouncil repo paths.

## 4. Install OpenClaw Runtime (No Tools)

Install using your chosen source. Record exact commands used in Session Metadata.

Required constraints during this step:

- No browser tool enablement.
- No shell tool enablement.
- No plugin/skills marketplace enablement.
- No autonomous scheduler/loop enablement.
- No host mount configuration.

## 5. Locked Config File

Create OpenClaw config in `/home/pete/openclaw-runtime/` with explicit deny-by-default settings.

Minimum policy assertions (exact keys may vary by runtime):

- browser disabled
- shell disabled
- plugins disabled
- autonomous loop disabled
- filesystem scope limited to runtime directory or explicit safe path

Record config path in Session Metadata.

## 6. Smoke Test (Static Prompt)

Run one minimal prompt that does not use tools.

Expected:

- Runtime starts.
- Model response returns.
- No tool invocation attempts.

If any tool invocation occurs, stop and rollback config changes.

## 7. Post-Install SecurityCouncil Verification

From VM:

```bash
cd ~/openclawadmin
./collector/collect.sh
exit
```

From host:

```bash
./scripts/sync-from-vm.sh
./scripts/validate-artifacts.sh
./scripts/audit-run.py --skip-collect
```

Expected:

- Artifacts validate.
- Audit report generates successfully.
- Drift, if present, is intentional and explainable by OpenClaw install.

## 8. Decision Gate

Choose exactly one:

1. Promote baseline (intentional install and acceptable drift).
2. Keep current baseline and continue observing.
3. Roll back to pre-install snapshot.

Record decision:

- Decision:
- Timestamp (UTC):
- Reviewer:
- Notes:

## 9. Session Closeout

Create short execution note at:

- `openclaw/docs/unlocks/OC-001-execution-note.md`

Include:

- Exact install commands used
- Config path and key constraints
- Smoke test command and output summary
- Audit report path under `vm_reports/`
- Decision gate outcome
