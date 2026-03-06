VM → collector → artifacts → auditors → aggregator → report

SecurityCouncil audits the VM environment that hosts OpenClaw.

OpenClaw is the system under observation, not part of the audit system itself.

## Boundary

SecurityCouncil is the external audit layer for the VM that will host OpenClaw.

OpenClaw itself is not yet implemented in this repository.
When implemented, it should be structured in three layers:

1. Core runtime
2. Tools / capabilities
3. Policy / permission layer

SecurityCouncil remains external and authoritative.