# OC-001 Capability Unlock Note

- Date: 2026-03-09
- Workstream ID: `OC-001`
- Capability to unlock: Install OpenClaw runtime in VM with zero tools enabled
- Requested by: Human operator

## 1. Intent

Install OpenClaw runtime files inside the VM so controlled experimentation can begin, while keeping execution constrained to model-only interactions and preserving SecurityCouncil Mode B as the governing observer.

## 2. Worst-Case Outcome

OpenClaw is installed with unintended capabilities (for example shell/browser/plugins or broader filesystem/network access), creating an unreviewed expansion of execution power inside the VM and causing unclear drift against policy.

## 3. Mitigations

- Control 1: Install into isolated path `/home/pete/openclaw-runtime/`, separate from SecurityCouncil paths.
- Control 2: Deny-by-default config at first launch (shell/browser/plugins/autonomous loops disabled).
- Control 3: Immediate post-install artifact collection and SecurityCouncil audit before any non-smoke-test usage.

## 4. Guardrails and Limits

- Scope: Runtime installation and smoke test only. No workflow automation.
- Duration: Single setup session.
- Data boundaries: Only local VM files required for runtime setup. No host mounts.
- Network boundaries: Package/model provider traffic required for install/start only. No extra integrations.
- Cost limits: Use dedicated capped API keys; no uncapped keys.

## 5. Verification Plan

How to verify behavior stayed in bounds.

- Artifacts to inspect:
  - `vm_artifacts/config.json`
  - `vm_artifacts/metadata.json`
  - `vm_artifacts/ports.txt`
  - `vm_artifacts/packages.txt`
- SecurityCouncil sections to review:
  - 4.1 Configuration Auditor
  - 4.2 Dependency Auditor
  - 4.4 Exposure Auditor
- Expected report signal:
  - Configuration reflects tool-disabled posture.
  - Dependency drift limited to intentional OpenClaw/runtime packages.
  - Exposure remains policy-consistent (no unexpected listening services).

## 6. Rollback Plan

How to return to prior state within 30 minutes.

- Config/files to revert:
  - Remove `/home/pete/openclaw-runtime/`.
  - Remove OpenClaw env/config files created during setup.
- Snapshot to restore:
  - Restore clean UTM snapshot taken before install session.
- Validation steps after rollback:
  - Run collector on VM.
  - Sync artifacts to host.
  - Run `scripts/validate-artifacts.sh`.
  - Run `python3 scripts/audit-run.py --skip-collect`.
  - Confirm return to expected baseline posture.

## 7. Decision

- Status: `Approved`
- Decision timestamp (UTC): 2026-03-09T00:00:00Z
- Approved by: Human operator
- Notes: This unlock grants installation only, not capability expansion beyond model-only use.
