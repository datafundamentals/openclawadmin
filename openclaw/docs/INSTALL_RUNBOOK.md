# OpenClaw Install Runbook (v0)

This runbook installs OpenClaw inside the VM while preserving current SecurityCouncil posture.

Scope of this runbook:

- Install OpenClaw in a separate VM path.
- Keep SecurityCouncil in Mode B.
- Start with deny-by-default capabilities.

## 1. Preconditions

Before install, verify:

1. VM is running and reachable over SSH.
2. SecurityCouncil pipeline can still run end-to-end.
3. API keys used for OpenClaw are separate, capped, and non-identity.
4. No change to host integration policy is being made in this step.

## 2. Directory Layout in VM

Use a separate runtime path for OpenClaw, for example:

- `/home/pete/openclaw-runtime/`

Do not install OpenClaw into SecurityCouncil artifact directories.

## 3. Initial Capability Profile (Locked)

Start with all high-risk capabilities disabled:

- browser tool: disabled
- shell tool: disabled
- plugin/skills marketplace: disabled
- host filesystem mounts: disabled
- autonomous scheduling/loops: disabled
- external integrations (email/social/identity): disabled

Only allow model calls using capped keys.

## 4. Install Procedure

1. Snapshot/restore point available in UTM.
2. Install OpenClaw runtime files in `/home/pete/openclaw-runtime/`.
3. Create environment file with dedicated capped keys.
4. Write a local OpenClaw config that enforces the locked capability profile.
5. Run a minimal smoke test with a static prompt and no tools.
6. Record what was installed (version, commit/tag, config file path).

## 5. Post-Install Governance Steps

Immediately after install:

1. Run collector on VM.
2. Sync artifacts to host.
3. Run `scripts/validate-artifacts.sh`.
4. Run full audit (`./scripts/audit-run.py --skip-collect` after manual collect).
5. Review report for unexpected exposure or dependency drift.

If install is intentional and clean, perform baseline promotion only with explicit human approval.

## 6. First Week Operating Constraints

- Manual start only.
- One bounded use case at a time.
- No new capabilities unless an unlock note is approved.
  Use `openclaw/docs/unlocks/CAPABILITY_UNLOCK_NOTE_TEMPLATE.md`.
- If behavior is surprising, revert to clean snapshot and re-run.

## 7. Candidate Low-Risk Use Cases

1. Summarize local markdown/doc content from a whitelisted directory.
2. Draft structured ticket text from provided artifacts.
3. Reformat existing SecurityCouncil report content without external actions.

## 8. Exit Criteria for This Runbook

This v0 runbook is complete when:

1. OpenClaw is installed in isolated VM path.
2. Locked profile is enforced and verified.
3. SecurityCouncil nightly run still works.
4. Baseline decision (promote or revert) is explicitly recorded.
