# OpenClaw Admin Repository

Current operating mode: **Mode B (Automated, Non-OpenClaw Orchestration)**.

This repository currently runs SecurityCouncil as an external audit system for the VM that hosts OpenClaw.

## Start Here

1. `OKR.md`
2. `ROADMAP.md`
3. `BOUNDARIES.md`
4. `VM_SETUP.md`

## Two-Lane Model

1. SecurityCouncil lane (observer): audit pipeline and governance docs.
2. OpenClaw lane (subject): runtime setup and bounded use-case docs under `openclaw/`.

Boundary rule: SecurityCouncil observes OpenClaw; it does not operate OpenClaw by default.

## Key Paths

- SecurityCouncil governance: `policies/`, `intent/`, `schemas/`, `context/`, `prompts/`
- SecurityCouncil runtime state: `vm_artifacts/`, `vm_baseline/`, `vm_reports/`
- OpenClaw docs and controls: `openclaw/docs/`
- Unlock note template: `openclaw/docs/unlocks/CAPABILITY_UNLOCK_NOTE_TEMPLATE.md`

## Migration Reminder

OpenClaw-orchestrated SecurityCouncil (Mode C) is deferred until prerequisites in `policies/migration-to-openclaw.md` are met.
