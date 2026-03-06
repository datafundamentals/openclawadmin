# AGENT HANDOFF — OpenClaw SecurityCouncil System

## Purpose of the System

This repository implements a **deterministic audit system** for a VM environment called **SecurityCouncil**.

The goal is to periodically collect system state from a VM, compare it against an approved baseline, and generate a structured **SecurityCouncil audit report** using LLM-based auditors.

The system is designed to be:

* deterministic
* read-only
* baseline-driven
* schema-constrained

LLMs **analyze artifacts** but never modify the system.

---

# System Architecture

The system has five stages.

```
VM
 ↓
collector
 ↓
artifacts
 ↓
sync-to-host
 ↓
auditors (LLM prompts)
 ↓
report aggregator (LLM prompt)
 ↓
SecurityCouncil report
```

---

# Repository Layout

Current repository structure:

```
collector/
  collect.sh

scripts/
  sync-from-vm.sh
  sync-to-vm.sh

prompts/
  configuration-auditor.txt
  dependency-auditor.txt
  cost-usage-auditor.txt
  exposure-auditor.txt
  report-aggregator.txt

context/
  configuration-auditor.md
  dependency-auditor.md
  cost-usage-auditor.md
  exposure-auditor.md

schemas/
  security-council-report.md

policies/
  artifact-contract.md
  baseline.md
  migration-to-openclaw.md
  modes.md

intent/
  security-council.md

vm_artifacts/
  (runtime artifacts pulled from VM)

vm_baseline/
  artifacts.baseline/
    config.json
    firewall.txt
    metadata.json
    packages.txt
    ports.txt
    usage.json

vm_reports/
  (generated reports)

OKR.md
README.md
ROADMAP.md
```

---

# Artifact Collection

Artifacts are produced inside the VM by:

```
collector/collect.sh
```

The collector produces:

```
artifacts/
  config.json
  metadata.json
  packages.txt
  ports.txt
  firewall.txt
  usage.json
```

These are copied to the host with:

```
scripts/sync-from-vm.sh
```

and stored in:

```
vm_artifacts/
```

---

# Baseline Model

Approved baseline artifacts live in:

```
vm_baseline/artifacts.baseline/
```

Baseline promotion occurs manually when system state changes intentionally.

Promotion procedure (performed inside VM):

```
rm -rf baseline/artifacts.baseline
mkdir -p baseline
cp -R artifacts baseline/artifacts.baseline
```

Then sync to host.

Baseline comparison is **semantic**, not byte-for-byte.

---

# Volatile Fields

Some artifact fields are expected to change every run and must not be treated as drift:

### timestamps

```
timestamp_utc
generated_at_utc
```

### runtime identifiers

in `ports.txt`:

```
pid=
fd=
```

These represent runtime processes and should not trigger drift detection.

Auditors should compare:

* ports
* bound addresses
* services

but ignore PIDs and FDs.

---

# Auditors

There are four LLM auditors.

Each has a dedicated prompt.

| Auditor       | Section |
| ------------- | ------- |
| Configuration | 4.1     |
| Dependency    | 4.2     |
| Cost & Usage  | 4.3     |
| Exposure      | 4.4     |

Each auditor:

* reads artifacts
* compares with baseline
* produces schema-compliant output

Auditors are strictly **read-only**.

No shell execution.
No network calls.
No remediation.

---

# Report Aggregator

The final prompt:

```
prompts/report-aggregator.txt
```

This aggregates auditor outputs into the final report following:

```
schemas/security-council-report.md
```

The aggregator must:

* synthesize auditor outputs
* determine overall system status

Possible statuses:

```
STABLE
DRIFT_DETECTED
POLICY_VIOLATION
INCONCLUSIVE
```

---

# Current System State

The system has completed a full working cycle.

Recent test results:

Configuration: identical to baseline
Dependencies: identical (663 packages)
Usage: zero API calls
Exposure: only SSH exposed

Firewall posture:

```
default incoming: deny
allowed inbound: 22/tcp
```

System is currently:

```
Overall Status: STABLE
```

Environment is **pre-operational**.

---

# Known Limitations

The system currently cannot:

* compute cryptographic hashes (shell execution disabled)
* verify container image state
* inspect application-level dependency manifests
* compute token usage costs

These appear in the report's **Uncertainty Section**.

---

# Operational Workflow

Normal audit cycle:

```
1. VM: run collector
   ./collector/collect.sh

2. Host: pull artifacts
   ./scripts/sync-from-vm.sh

3. Run auditors (LLM prompts)

4. Run report aggregator

5. Store report in vm_reports/
```

---

# Design Principles

This project follows strict rules:

### 1. LLMs do not control systems

They only analyze artifacts.

### 2. Baseline is the authority

All drift detection is baseline-based.

### 3. Reports must be deterministic

Outputs follow strict schemas.

### 4. No remediation by LLMs

Reports are informational only.

### 5. Artifacts are the source of truth

Never trust summaries over files.

---

# Current Development Goal

Stabilize the system so repeated runs produce consistent audit results.

Future improvements may include:

* normalizing volatile artifact fields
* improved artifact schema
* automated nightly audit pipeline
* integration with OpenClaw agent framework

---

# What the Agent Should Do Next

If continuing development, prioritize:

1. Improve artifact contract documentation.
2. Normalize volatile fields during audit comparison.
3. Ensure auditors compare **semantic state** rather than raw text.
4. Harden collector outputs for deterministic comparison.

---

# End of Handoff

This document summarizes the architecture, state, and operational model needed for a coding agent to continue development.
