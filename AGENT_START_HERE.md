# Agent Start Here

PRIORITY RULE: Human is to do all git add, commit and push operations. Never migrate from one ticket or task to the next, without permission from the human, who will commit between tickets/tasks.

Read these files in this exact order before making any changes inside this folder:

1. `AGENT_BRIEFING.md`
2. `ARCHITECTURE.md`
3. `AGENT_HANDOFF.md`

Rules:

- Do not redesign the architecture.
- Do not move directories unless explicitly instructed.
- Treat `vm_baseline/` as approved reference state.
- Treat `vm_artifacts/` and `vm_reports/` as runtime/generated state.
- Work tickets in order.
- Complete and verify one ticket before starting the next.
- Prefer small, deterministic changes.
- When uncertain, inspect files rather than inferring.

First task after reading:
- Summarize the current architecture and ticket 001 in your own words before editing anything.