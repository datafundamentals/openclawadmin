# Migration to OpenClaw Orchestration  
**v0.1**

This document defines prerequisites, triggers, and steps for migrating from Phase 1 (non-OpenClaw) to Phase 2 (OpenClaw-orchestrated).

---

## Preconditions (All Required)

1. **Stability**
   - 7 consecutive nightly runs without schema drift

2. **Cost Controls Proven**
   - API caps set and verified
   - No unexpected usage spikes

3. **Rollback Ready**
   - Ability to revert to Phase 1 within 30 minutes
   - Phase 1 scripts remain functional and tested

4. **Permissions Review**
   - Any OpenClaw tool permissions required for orchestration are documented
   - No new permissions are granted implicitly

5. **No Credentials Expansion**
   - No real-world identity credentials introduced by the migration

---

## Triggers (Any One)

- Need for richer scheduling / retries / queueing
- Need for multi-workflow orchestration beyond SecurityCouncil
- Desire to use OpenClaw’s native multi-agent coordination
- Phase 1 runner becomes a maintenance burden

---

## Migration Steps (High-Level)

1. Introduce OpenClaw orchestration in parallel (Mode B remains default)
2. Configure OpenClaw to run the existing SecurityCouncil prompts unchanged
3. Ensure artifact collection remains deterministic unless revised in `OKR.md`
4. Run in shadow mode for 3 nights:
   - Mode B report is generated
   - Mode C report is generated
   - Compare outputs (must be equivalent structurally)
5. Switch default schedule to Mode C
6. Mark Mode B docs as Deprecated (do not delete immediately)
7. Validate rollback still works

---

## Deprecation & Doc Hygiene

When Mode C becomes default:

- Any Mode A “manual procedure” sections must be removed or archived
- Mode B runbook must be marked **Deprecated**
- A single “Current Runbook” pointer must exist in `README.md`

---

## Rollback

Rollback is a first-class requirement.

If Mode C introduces:
- unexpected costs
- drift
- instability

Revert to Mode B immediately and record why in a changelog.