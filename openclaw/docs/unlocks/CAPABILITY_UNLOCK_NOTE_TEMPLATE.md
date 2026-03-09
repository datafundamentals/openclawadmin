# Capability Unlock Note Template

Use this file for every OpenClaw capability change.

- Date:
- Workstream ID: `OC-...`
- Capability to unlock:
- Requested by:

## 1. Intent

Why this capability is needed now and what concrete task it enables.

## 2. Worst-Case Outcome

Describe the failure mode with the largest plausible blast radius.

## 3. Mitigations

List controls that reduce the worst case.

- Control 1:
- Control 2:
- Control 3:

## 4. Guardrails and Limits

Exact constraints for this unlock.

- Scope:
- Duration:
- Data boundaries:
- Network boundaries:
- Cost limits:

## 5. Verification Plan

How to verify behavior stayed in bounds.

- Artifacts to inspect:
- SecurityCouncil sections to review:
- Expected report signal:

## 6. Rollback Plan

How to return to prior state within 30 minutes.

- Config/files to revert:
- Snapshot to restore:
- Validation steps after rollback:

## 7. Decision

- Status: `Approved` | `Rejected` | `Deferred`
- Decision timestamp (UTC):
- Approved by:
- Notes:
