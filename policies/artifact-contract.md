# Artifact Contract

**v0.1**
Phase 1 — Non-OpenClaw Orchestrated Mode

---

## 1. Purpose

Defines the deterministic artifacts that must exist before SecurityCouncil auditors run.

SecurityCouncil interprets artifacts.
It does not collect them.

Artifact collection must be:

* Deterministic
* Non-LLM
* Non-exploratory
* Reproducible
* Side-effect free

---

## 2. Artifact Directory Structure

Inside the VM:

```text
artifacts/
├── config.json
├── packages.txt
├── ports.txt
├── usage.json
└── metadata.json
```

Artifacts are overwritten on each run.
They are not append-only logs.

---

## 3. Artifact Definitions

### 3.1 `config.json`

Represents agent and system configuration state relevant to policy.

Must include:

```json
{
  "browser_tool_enabled": false,
  "shell_tool_enabled": false,
  "plugin_system_enabled": false,
  "ollama_access_enabled": false,
  "elasticsearch_access_mode": "read-only | disabled",
  "approved_llm_providers": ["anthropic", "openai", "gemini"],
  "timestamp_utc": "<ISO8601>"
}
```

Source:

* Static configuration files
* Explicit feature flags
* Known runtime flags

No secrets included.

---

### 3.2 `packages.txt`

Plain text output of installed packages and versions.

Example source command (Ubuntu example):

```
dpkg -l
```

Or equivalent package manager listing.

Must include:

* Package name
* Version
* Status

No filtering or interpretation.

---

### 3.3 `ports.txt`

Plain text list of listening services inside the VM.

Example source command:

```
ss -lntp
```

Or equivalent.

Must include:

* Port
* Protocol
* Bound interface
* Process name (if available)

No network scanning beyond local system.

---

### 3.4 `usage.json`

Represents locally observable API usage signals.

Must include:

```json
{
  "anthropic_calls": <int>,
  "openai_calls": <int>,
  "gemini_calls": <int>,
  "estimated_cost_usd": <float | null>,
  "cap_threshold_warning": false,
  "timestamp_utc": "<ISO8601>"
}
```

Source:

* Local logs
* Local accounting files
* Pre-existing usage counters

Must not:

* Call external APIs
* Query billing dashboards
* Validate API keys

If data unavailable:

* Set values to null
* Record absence in metadata.json

---

### 3.5 `metadata.json`

Describes artifact generation context.

Must include:

```json
{
  "artifact_version": "0.1",
  "vm_identifier": "<string>",
  "generated_at_utc": "<ISO8601>",
  "collector_version": "<string>",
  "mode": "automated-non-openclaw"
}
```

This file ensures:

* Traceability
* Mode awareness
* Future migration clarity

---

## 4. Artifact Generation Rules

Artifact generation:

* Must not require LLMs
* Must not modify system configuration
* Must not modify firewall rules
* Must not create network traffic beyond localhost
* Must not include secrets

Artifacts are read-only inputs for auditors.

---

## 5. Scheduling (Phase 1)

Nightly execution order:

1. Run deterministic collector script
2. Write artifacts
3. Invoke SecurityCouncil auditors using artifacts
4. Write report to `reports/YYYY-MM-DD.md`

If artifact generation fails:

* Auditors must not run
* Failure must be logged

---

## 6. Migration Compatibility

In Phase 2 (OpenClaw orchestration):

* Artifact generation remains deterministic unless `OKR.md` changes
* OpenClaw may schedule the collector
* Artifact format must remain stable unless schema version increments
* `metadata.json.mode` must change to:

  * `"openclaw-orchestrated"`

---

## 7. Versioning

Changes to artifact structure require:

1. Update to this document
2. Schema review
3. Baseline review
4. Version increment in `artifact_version`

---

## 8. Guiding Principle

> Collect facts deterministically.
> Interpret them probabilistically.