# SecurityCouncil Report Schema

**v0.1**

---

## 1. Purpose

Defines the required structure of every SecurityCouncil audit report.

All reports must conform to this schema.
Free-form prose is not allowed outside defined sections.

---

## 2. Metadata Block (Required)

```yaml
report_version: 0.1
okr_version: <string>
intent_version: <string>
vm_identifier: <string>
timestamp_utc: <ISO8601>
execution_mode: read-only
auditors:
  - configuration
  - dependency
  - cost_usage
  - exposure
```

---

## 3. Executive Summary (Human-Readable)

### 3.1 Overall Status

One of:

* STABLE
* DRIFT_DETECTED
* POLICY_VIOLATION
* INCONCLUSIVE

### 3.2 Summary Paragraph

Plain language summary of:

* what changed
* what did not change
* whether attention is required

No urgency language.
No speculation.
No remediation instructions.

---

## 4. Auditor Sections (Structured)

Each auditor must produce the following sections.

---

### 4.1 Configuration Auditor

#### Baseline Hash

Hash or fingerprint of expected configuration.

#### Current Hash

Hash of current configuration.

#### Drift Detected

```yaml
drift: true | false
changed_items:
  - <item>
```

#### Observations

Bullet list of factual statements only.

---

### 4.2 Dependency Auditor

#### Installed Package Count

#### Version Changes

```yaml
version_changes:
  - package: <name>
    from: <version>
    to: <version>
```

#### Unexpected Packages

```yaml
unexpected:
  - <package>
```

#### Observations

Factual only.

---

### 4.3 Cost & Usage Auditor

#### API Usage Summary

```yaml
anthropic_calls: <int>
openai_calls: <int>
gemini_calls: <int>
estimated_cost_usd: <float>
```

#### Threshold Status

```yaml
cap_threshold_warning: true | false
```

#### Observations

---

### 4.4 Exposure Auditor

#### Listening Ports

```yaml
listening:
  - port: <int>
    service: <name>
    bound_to: <interface>
```

#### Policy Violations

```yaml
policy_violation: true | false
details:
  - <item>
```

#### Observations

---

## 5. Uncertainty Section (Required)

If any auditor could not determine a state:

```yaml
uncertainties:
  - auditor: <name>
    issue: <description>
    reason: <explanation>
```

Silence implies confidence.

---

## 6. Non-Findings Section (Required)

Explicit confirmation of:

* No browser tool detected
* No shell tool detected
* No plugin system active
* No outbound network modification
* No write access to host

If any item cannot be confirmed, it must move to Uncertainty.

---

## 7. Output Constraints

The report must:

* Be deterministic in structure
* Be diff-friendly
* Avoid emotional language
* Avoid remediation instructions
* Avoid external links
* Avoid speculation

---

## 8. Storage Policy

Reports must be:

* Written inside VM sandbox
* Retained for N days (to be defined)
* Not exported automatically

---

## 9. Guiding Rule

> The report must reduce ambiguity, not create narrative.
