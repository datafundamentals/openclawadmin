# Roadmap  
**v0.1**

This document is the authoritative plan for how this program evolves over time.

If another document conflicts with this roadmap, the roadmap wins unless `OKR.md` explicitly overrides.

---

## Phase 0 — Governance Complete (Done)

### Exit Criteria
- OKR exists
- SecurityCouncil intent exists
- Report schema exists
- Baseline protocol exists
- Auditor context + prompts exist

### Status
✅ Complete

---

## Phase 1 — SecurityCouncil Outside OpenClaw (Current Target)

### Description
SecurityCouncil runs nightly, but orchestration and artifact collection are **not** performed by OpenClaw.

The system runs as:

1. Deterministic collector generates `artifacts/`
2. External LLM calls interpret artifacts via the auditor prompts
3. Aggregator produces a single report in schema format

### Why
- Minimizes blast radius
- Avoids granting OpenClaw tool access early
- Validates audit value before automation complexity

### Deliverables
- `policies/artifact-contract.md`
- Minimal collector script (non-agent)
- Minimal runner script (LLM calls)
- Reports written to a stable location
- Nightly schedule in the VM

### Exit Criteria
- Nightly report produced for 7 consecutive days
- Reports are diffable and stable
- No bill surprises (caps validated)
- No drift surprises (baseline + diffs functioning)

---

## Phase 2 — Optional: OpenClaw Orchestration (Future)

### Description
OpenClaw (or derivative) is permitted to orchestrate SecurityCouncil execution.

However, artifact collection remains deterministic unless explicitly revised by `OKR.md`.

### Preconditions
- `policies/migration-to-openclaw.md` satisfied
- All “not yet” constraints reviewed
- A rollback plan exists (return to Phase 1 within 30 minutes)

### Triggers (Any one is sufficient)
- Desire for multi-agent scheduling, retries, queues, or richer workflows
- Desire to manage more than SecurityCouncil through a unified orchestrator
- Evidence that Phase 1 runner is stable but limiting

### Exit Criteria
- OpenClaw can run SecurityCouncil nightly without changing report schema
- The system can revert to Phase 1 without loss of governance clarity