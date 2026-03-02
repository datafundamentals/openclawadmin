# Agent Experimentation Program

**OKR & Governance Docs — v0.1**

---

## 1. Objective (O)

Safely experiment with OpenClaw / NanoClaw–class agents in a way that:

* avoids harm to others
* bounds financial and reputational risk
* preserves reversibility and clarity
* supports learning without archaeological complexity
* allows future expansion *without re-architecture*

This program optimizes for **bounded, observable, and reversible experimentation**, not autonomy.

---

## 2. Key Results (KRs)

1. Agent execution occurs only inside a **disposable Linux VM**.
2. The VM is **rebuildable from scratch in ≤ 30 minutes**.
3. No agent has access to **real-world identity credentials**.
4. All external API usage is **hard-capped and separately keyed**.
5. Host services (Elasticsearch, Ollama) are **least-privilege and explicitly gated**.
6. A nightly **SecurityCouncil audit** produces a human-reviewed report.
7. Capability expansion occurs only via **documented unlocks**, never ad hoc.

---

## 3. Risk Posture (Global)

**Risk Dial:** 5 / 10 across all categories (initially)

**Definition of 5:**

* Bounded blast radius
* Explicit permissions
* Monitoring before automation
* Reversible failure
* No silent drift

Per-category tuning is deferred until evidence demands it.

---

## 4. Architectural Intent (Phase 1)

### 4.1 Execution Environment

* **Disposable Linux VM**
* Stored as a **single dynamic disk file** on external SSD
* Initial disk cap: **40 GB** (expandable later)
* RAM: **12 GB**
* CPU: **4–6 cores**
* No shared folders
* No clipboard sync
* NAT networking only

The VM is treated as **hostile-adjacent** and non-sacred.

---

### 4.2 Host Integration (Explicit)

| Service            | Status      | Access Model                       |
| ------------------ | ----------- | ---------------------------------- |
| Elasticsearch      | Allowed     | Read-only API key, localhost-bound |
| Ollama             | **Not yet** | Localhost-bound, gated later       |
| Browser automation | **Not yet** | Explicit future unlock             |
| Shell execution    | **Not yet** | Explicit future unlock             |

All host services remain **non-networked except by intent**.

---

## 5. Capability State Matrix

### 5.1 Enabled (v0.1)

* LLM API calls (Anthropic / OpenAI / Gemini)
* Read-only filesystem access (sandbox directory only)
* Configuration inspection
* Log inspection
* Static dependency analysis

---

### 5.2 Explicitly Disabled (“Not Yet”)

These are **intentional constraints**, not omissions.

```
No browser tool
No shell tool
No plugin / skills marketplace
No write access to host filesystem
No Ollama access
No email, social, or identity integration
No autonomous remediation
```

Each disabled item must be unlocked via:

1. Written intent
2. Worst-case analysis
3. Mitigation strategy
4. OKR revision

---

## 6. SecurityCouncil (Phase 1)

### 6.1 Purpose

Provide **nightly, read-only audits** of the agent environment to detect:

* configuration drift
* unexpected exposure
* dependency changes
* cost anomalies
* disk growth
* policy violations

The SecurityCouncil **observes and reports**.
It does **not act**.

---

### 6.2 Structure

Four agents with strictly scoped roles:

1. **Configuration Auditor**

   * Enabled tools
   * Network exposure
   * Permission diffs

2. **Dependency Auditor**

   * Installed packages
   * Version drift
   * Unexpected additions

3. **Cost & Usage Auditor**

   * API call counts
   * Token usage
   * Cap proximity

4. **Exposure Auditor**

   * Open ports
   * Firewall state
   * Service bindings

---

### 6.3 Constraints

* Read-only access only
* No shell execution
* No external posting
* No remediation
* Output is a **human-readable report**

---

## 7. Rebuild Contract (v0.1)

### 7.1 What Lives *Inside* the VM

* Agent framework
* Audit tooling
* Temporary logs
* Disposable configs

### 7.2 What Lives *Outside* the VM

* OKR & governance docs
* API keys (stored separately)
* Elasticsearch data
* Ollama models
* Source code (GitHub)

### 7.3 What Must *Not* Survive Rebuild

* Logs
* Cached data
* Runtime state
* Experimental packages
* Ad hoc config changes

### 7.4 Rebuild Rule

> If the VM feels messy, confusing, or surprising — **rebuild instead of patch**.

---

## 8. Expansion Model (Future-Facing)

All future capability is expected to follow this ladder:

1. **OKR revision**
2. **Intent spec**
3. **Context constraints**
4. **Prompt design**
5. **Subtask execution**

Examples of future unlocks (documented but inactive):

* Ollama access via localhost proxy
* Browser tool with read-only mode
* Limited shell execution in sandbox
* Write-only Elasticsearch index
* Automated remediation (far future)

No unlock occurs without updating this document set.

---

## 9. Operating Principle

> The system must always be understandable by inspection.

If understanding requires memory, the system has already failed.

---

## 10. Status

* Context digestion: **complete**
* Risk posture: **set**
* Architecture: **defined**
* First capability: **SecurityCouncil**
* Next work: **intent engineering derived from this layer**
