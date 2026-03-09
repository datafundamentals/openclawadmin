# Repository Boundaries

This repository contains two systems with different roles.

## 1) SecurityCouncil (Observer System)

Purpose: observe, audit, and report only.

Authoritative directories:

- `collector/`
- `context/`
- `intent/`
- `policies/`
- `prompts/`
- `schemas/`
- `scripts/` (SecurityCouncil pipeline scripts)
- `vm_artifacts/` (runtime state)
- `vm_baseline/` (approved reference state)
- `vm_reports/` (generated reports)

SecurityCouncil rules:

- Read-only posture.
- No remediation.
- No capability changes.
- No OpenClaw runtime orchestration unless Phase 2 migration criteria are met.

References:

- `OKR.md`
- `ROADMAP.md`
- `intent/security-council.md`
- `policies/migration-to-openclaw.md`

## 2) OpenClaw (Subject System)

Purpose: run bounded agent workflows inside the VM under a deny-by-default capability profile.

Authoritative directories:

- `openclaw/` (runtime configuration, wrappers, and docs)

OpenClaw rules in this repository:

- OpenClaw is the system under observation.
- OpenClaw changes must not bypass SecurityCouncil governance artifacts.
- Capability expansion must use explicit unlock notes.

## 3) Allowed Data Flow

Allowed:

1. OpenClaw executes inside VM.
2. Deterministic collector captures VM facts.
3. Artifacts are synced to `vm_artifacts/`.
4. Auditors compare against `vm_baseline/artifacts.baseline/`.
5. Aggregator writes report to `vm_reports/`.

Not allowed:

- Auditors modifying OpenClaw configuration.
- SecurityCouncil prompts issuing execution commands.
- Direct writes from OpenClaw into `vm_baseline/`.

## 4) Baseline and Runtime State Handling

- `vm_artifacts/` and `vm_reports/` are generated state. Do not hand-edit.
- `vm_baseline/` changes only via explicit baseline promotion and human approval.
- If runtime state is surprising, prefer VM rebuild over ad hoc patching.

## 5) Mode Clarity

Current default mode is Mode B (Automated, Non-OpenClaw orchestration).

- Mode B remains default until migration prerequisites in `policies/migration-to-openclaw.md` are satisfied.
- Mode C (OpenClaw-orchestrated SecurityCouncil) is future state and must preserve rollback to Mode B.

## 6) Workstream Labeling

To avoid mixed intent:

- Use `SC-...` labels for SecurityCouncil work.
- Use `OC-...` labels for OpenClaw work.

Guiding rule: observer and subject can share one repository, but not one responsibility.
