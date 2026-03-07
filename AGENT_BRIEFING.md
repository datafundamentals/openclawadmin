# Agent Briefing — OpenClaw SecurityCouncil Repository

## Role

You are assisting with development of the **SecurityCouncil audit system** for the OpenClaw environment.

This repository implements a **deterministic VM security audit pipeline**.
Your role is to help maintain and improve the tooling, scripts, and documentation.

You are **not designing a new system**. You are working within an existing architecture.

---

# Core System Model

The system operates as a **read-only audit pipeline**:

```
VM
 ↓
collector (collect.sh)
 ↓
artifacts
 ↓
sync-from-vm.sh
 ↓
LLM auditors
 ↓
report aggregator
 ↓
SecurityCouncil report
```

Artifacts represent **observed system state**.

LLMs **analyze artifacts only** and do not control or modify the system.

---

# Key Directories

```
collector/
scripts/
prompts/
context/
schemas/
policies/
intent/

vm_artifacts/
vm_baseline/
vm_reports/
```

Important rules:

### vm_artifacts

Runtime artifacts pulled from the VM.

### vm_baseline

Approved baseline used for drift comparison.

### vm_reports

Generated reports.

These directories represent **system state** and should not be refactored.

---

# Artifact Contract

Artifacts produced by the collector:

```
config.json
metadata.json
packages.txt
ports.txt
firewall.txt
usage.json
```

These files represent the **source of truth** for audit analysis.

Auditors compare:

```
vm_artifacts/*
vs
vm_baseline/artifacts.baseline/*
```

---

# Volatile Fields

Some artifact fields change every run and must **not** be treated as drift:

### timestamps

```
timestamp_utc
generated_at_utc
```

### runtime identifiers

In `ports.txt`:

```
pid=
fd=
```

These represent runtime process state and should be ignored for drift detection.

Drift detection should focus on:

* services
* listening ports
* firewall rules
* installed packages
* configuration flags

---

# LLM Auditors

The system contains four auditors:

```
4.1 Configuration Auditor
4.2 Dependency Auditor
4.3 Cost & Usage Auditor
4.4 Exposure Auditor
```

Prompts live in:

```
prompts/
```

Auditors must follow strict constraints:

* read-only
* no shell execution
* no network access
* no remediation
* no speculation

Auditors produce **schema-constrained output**.

---

# Report Aggregator

Final report generation occurs via:

```
prompts/report-aggregator.txt
```

The aggregator must:

* synthesize auditor outputs
* determine overall system status
* produce a schema-compliant report

Possible statuses:

```
STABLE
DRIFT_DETECTED
POLICY_VIOLATION
INCONCLUSIVE
```

---

# Development Principles

Follow these principles when modifying this repository.

### 1. Do not redesign the system

This architecture is intentional.

Improve it incrementally rather than replacing components.

---

### 2. Never modify VM state

Agents must never perform actions that change system configuration.

All analysis must operate on **artifacts only**.

---

### 3. Preserve schema compatibility

Reports must remain compliant with:

```
schemas/security-council-report.md
```

---

### 4. Prefer deterministic behavior

Collector outputs and audit comparisons should aim for repeatable results across runs.

---

### 5. Artifacts are authoritative

When debugging:

Always inspect actual artifact files rather than relying on summaries.

---

# What the Agent May Do

Safe improvements include:

• improving scripts
• improving artifact documentation
• normalizing volatile fields
• improving prompt clarity
• improving report schema handling
• adding validation tooling

---

# What the Agent Must Not Do

Do **not**:

• introduce system automation that modifies VM state
• allow LLMs to run shell commands
• remove baseline comparison logic
• refactor artifact locations
• introduce network scanning or active probing

The system is intentionally **passive and observational**.

---

# Current System Status

The pipeline has successfully completed an end-to-end run.

Recent audit results:

```
Configuration: stable
Dependencies: stable
Exposure: SSH only
Firewall: deny-by-default
Usage: zero API calls
```

Overall system status:

```
STABLE
```

---

# How to Approach Tasks

When making changes:

1. Read relevant policies and schema files.
2. Inspect artifacts in `vm_artifacts`.
3. Compare with `vm_baseline`.
4. Maintain semantic drift detection.
5. Avoid changes that break the audit pipeline.

---

# If Uncertain

Prefer:

* small changes
* documentation updates
* clarifying comments

Avoid large structural changes without explicit instruction.

---

# End of Agent Briefing

---

## Why this works

When you paste this into **Codex CLI**, **Claude Code**, or **Copilot Workspace**, the agent now knows:

* what the system is
* what it must not break
* where the truth lives
* how drift detection works
* what directories are sacred

Without this, agents often:

* refactor directories
* collapse prompts
* remove baseline logic
* add automation you don’t want

This briefing prevents that.

---

## One last small recommendation

Also add this tiny file:

```
ARCHITECTURE.md
```

with just the diagram:

```
VM → collector → artifacts → auditors → aggregator → report
```

Agents look for `ARCHITECTURE.md` instinctively.

---

If you'd like, I can also show you one **very small improvement** to your collector that will eliminate most of the noisy diffs you saw today.
