# research.md

## Decisions

- Decision: Use Terraform modules per resource and an example workspace that composes them.
  - Rationale: Clear separation of concerns, reuse, and independent testing.
  - Alternatives: Single monolithic TF root (rejected — harder to reuse and test).

- Decision: State backend = Azure Storage Blob with container per subscription.
  - Rationale: Remote state with locking and subscription-scoped containers reduces risk.

- Decision: running_number allocation by CI (pipeline computes next available number or uses a small registry pattern).
  - Rationale: Minimizes human error and collisions; documented in examples.

## Research Tasks

- RT-001: Document provider and Terraform version compatibility and pinning recommendations.
- RT-002: Document required RBAC roles for the applying identity per subscription.
- RT-003: Outline CI pattern for autonumber allocation (scan vs counter) and recommend an implementation.

