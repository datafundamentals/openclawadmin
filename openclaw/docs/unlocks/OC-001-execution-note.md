# OC-001 Execution Note

- Date: 2026-03-09
- Workstream ID: `OC-001`
- Unlock note: `openclaw/docs/unlocks/OC-001-install-openclaw-runtime-zero-tools.md`

## Installed Version

- Source: `https://github.com/openclaw/openclaw.git`
- Tag: `v2026.3.7`
- Commit: `42a1394`
- Runtime path (VM): `/home/pete/openclaw-runtime/openclaw`

## Locked Profile

- Config path (VM): `/home/pete/.openclaw/openclaw.json`
- Key constraints applied:
  - `tools.profile: "minimal"`
  - `tools.deny: ["*"]`
  - `tools.elevated.enabled: false`
  - `plugins.enabled: false`
  - `plugins.deny: ["*"]`
  - `browser.enabled: false`
  - `browser.evaluateEnabled: false`
  - `cron.enabled: false`
  - `gateway.tailscale.mode: "off"`

## Smoke Test

- Command:
  - `pnpm openclaw agent --agent main --message "Reply with exactly: LOCKED_OK" --thinking low`
- Result:
  - `LOCKED_OK`

## SecurityCouncil Verification

- Artifacts sync: completed
- Artifact validation: successful
- Drift check: material drift in `packages.txt` only
- Audit report path:
  - `vm_reports/2026-03-09T11-41-05Z/security-council-report.md`

## Noted Warnings (Non-Blocking)

- `scripts/sync-from-vm.sh` reported missing VM path `/home/pete/openclawadmin/reports` during report pull.
- This did not block artifact sync, validation, or audit report generation.
- Host note: use `./scripts/audit-run.py --skip-collect` (not `python3 scripts/audit-run.py --skip-collect`) so the repo's managed interpreter/dependencies are used.

## Decision Gate Outcome

- Decision: `Keep current baseline and continue observing`
- Reason:
  - Install and locked-profile validation succeeded.
  - Intentional dependency drift is present after install.
  - Continue observation for additional runs before baseline promotion.
