# Operating Modes  
**v0.1**

This document defines the allowed operating modes and the documentation rules for each mode.

Goal: avoid stale or misleading docs as the system evolves.

---

## Mode A — Manual

### Definition
A human performs steps interactively (copy/paste, manual CLI) to produce artifacts and/or reports.

### Allowed Use
- Bootstrapping and first dry run only
- Debugging a broken automated run

### Required Documentation
- A short “Manual Procedure” section may exist inside the relevant policy doc
- It must begin with: **"TEMPORARY: Manual Mode"**
- It must include a deprecation trigger (see below)

### Deprecation Trigger
The moment an automated runner exists for that function, the manual procedure must be:
- removed, or
- moved under an “Archived” heading with a bold warning

---

## Mode B — Automated (Non-OpenClaw)

### Definition
A deterministic collector and a minimal runner script execute on schedule.

### Allowed Use
- Phase 1 default mode
- Long-term acceptable if it remains simple and stable

### Documentation Rule
Mode B docs are the source of truth until Phase 2 migration is completed.

---

## Mode C — OpenClaw-Orchestrated

### Definition
OpenClaw schedules and executes SecurityCouncil workflows.

### Allowed Use
- Only after migration prerequisites are met
- Must preserve report schema
- Must preserve rollback path to Mode B

### Documentation Rule
When Mode C becomes default, Mode B docs must be marked:
- **"Deprecated"** at the top
- with a pointer to the new OpenClaw orchestration doc