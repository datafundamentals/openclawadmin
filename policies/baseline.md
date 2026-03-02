# Baseline Capture Protocol

**v0.1**

---

## 1. Purpose

Defines how the **initial trusted baseline** of the agent execution environment is captured.

All SecurityCouncil audits compare current state **only** against an approved baseline.

---

## 2. When a Baseline Is Captured

A baseline may be captured only when:

* The VM has been freshly built or intentionally reset
* All configuration aligns with `OKR.md`
* All constraints in `intent/security-council.md` are satisfied
* No experimental capabilities are enabled

Baseline capture is a **human-initiated event**.

---

## 3. What the Baseline Includes

The baseline must include:

### 3.1 Configuration State

* Enabled tools
* Disabled tools
* Permission flags
* Network bindings
* Feature toggles

### 3.2 Dependency State

* Installed packages
* Package versions
* Dependency manifests
* Container images (if applicable)

### 3.3 Exposure State

* Listening ports
* Bound interfaces
* Firewall configuration (summary only)

### 3.4 Resource State (Snapshot)

* Disk usage
* Memory allocation
* CPU allocation

---

## 4. What the Baseline Must NOT Include

The baseline must not include:

* Secrets or API keys
* Logs
* Runtime data
* Cached responses
* User content
* Any data requiring redaction

---

## 5. Baseline Artifacts

A baseline consists of:

* A structured baseline file (machine-readable)
* A human-readable summary
* A cryptographic hash of the baseline contents

Baseline artifacts are:

* Stored inside the VM sandbox
* Versioned
* Immutable once approved

---

## 6. Approval Process

Baseline approval requires:

1. Human review of baseline summary
2. Explicit confirmation that:

   * No prohibited capabilities are enabled
   * No unexpected dependencies exist
3. Manual approval recorded by timestamp

Baselines are **never auto-approved**.

---

## 7. Baseline Evolution

A new baseline may be created only when:

* Capabilities are intentionally unlocked
* Architecture is revised
* OKR or Intent documents change

Old baselines remain retained for historical comparison.

---

## 8. SecurityCouncil Relationship

* SecurityCouncil auditors compare **current state → baseline**
* Baseline mismatch is reported as:

  * DRIFT_DETECTED or
  * POLICY_VIOLATION
* SecurityCouncil may not modify baselines

---

## 9. Guiding Rule

> If the baseline is unclear, the system is already out of control.

---

## 10. Status

* Baseline capture: **manual**
* Baseline enforcement: **informational**
* Automation: **explicitly deferred**

---

## Why This Locks the System

Once this file exists:

* “Drift” becomes a measurable concept
* Auditors become deterministic
* Prompts become derivable
* You can reset the VM *without losing meaning*

This is the last governance-layer document.

Everything after this is **derivative engineering**.
