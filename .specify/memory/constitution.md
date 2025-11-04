<!--
Sync Impact Report

- Version change: template -> 1.0.0
- Modified principles:
	- (new) Infrastructure Modularity & Reuse
	- (new) Remote State & Locking
	- (new) Secure Secrets Handling
	- (new) Idempotent Naming, Tagging & Environments
	- (new) CI/CD, Testing & Policy-as-Code
- Added sections: Constraints & Security Requirements; Development Workflow
- Removed sections: placeholder tokens and examples (fully replaced)
- Templates updated: 
	- ✅ .specify/templates/plan-template.md
	- ✅ .specify/templates/spec-template.md
	- ✅ .specify/templates/tasks-template.md
- Follow-up TODOs: None required for immediate sync. If original ratification date is needed,
	set RATIFICATION_DATE in the Governance section.
-->

# IaC for AI Constitution

## Core Principles

### I. Infrastructure Modularity & Reuse (MUST)
All Terraform code MUST be organized into clear, versioned modules that encapsulate a single
concern (networking, identity, compute, platform services). Modules MUST be published and
referenced by version (git tag or registry version) rather than copied between environments.

Rationale: Modularization enforces separation of concerns, reduces duplication, and makes
auditing and upgrades predictable. Testable modules speed reviews and lower the risk of
drift or unintended changes.

### II. Remote State and Locking (MUST)
Terraform state MUST be stored remotely with locking enabled. The preferred backend is the
Azure Storage Account (Blob) backend with a dedicated container and access via Managed
Identity or a least-privileged service principal. Using Terraform Cloud/Enterprise is an
acceptable alternative if it provides remote state, locking, and team access controls.

Rationale: Remote state with locking prevents concurrent writes and accidental state
corruption. Centralized state storage enables auditing, role-based access, and safer
multi-person workflows.

### III. Secure Secrets Handling (MUST)
Secrets and sensitive values MUST NOT be stored in plaintext in code, variables files, or
unprotected state. Use Azure Key Vault (or an approved secrets manager) and reference
secrets at runtime via provider integration or CI secrets. Service principals and credentials
used by automation MUST have the minimal permissions required.

Rationale: Secrets in code or state are a critical risk. Centralized secret stores with
access controls reduce leak surface and enable rotation without code changes.

### IV. Idempotent Naming, Tagging & Environment Isolation (MUST)
All resources MUST follow a documented naming convention and include mandatory tags
(e.g., project, environment, owner, cost-center). Environments (dev, staging, prod) MUST be
separated by state, subscriptions, or resource groups to prevent accidental cross-env
impacts. Infrastructure changes MUST be idempotent and rollback-capable where possible.

Rationale: Consistent naming and tagging enable cost allocation, discovery, and automated
policies. Strict environment isolation prevents accidental resource sharing and privilege
escalation between environments.

### V. CI/CD, Testing & Policy-as-Code (MUST / SHOULD)
Every change to infrastructure MUST go through an automated pipeline that performs:
- formatting (terraform fmt), static validation (terraform validate, tflint), and provider
	version checks,
- a plan step that is surfaced in the PR for review,
- automated tests where feasible (unit/module tests, Terratest/integration tests), and
- approval gating for apply to non-development environments.

Organization-wide policies MUST be enforced through Azure Policy, OPA/Conftest, Sentinel,
or an equivalent policy-as-code mechanism; policy violations MUST block apply to protected
environments.

Rationale: Automation reduces manual error and enforces repeatable, auditable changes.
Policy-as-code ensures compliance is checked pre-apply rather than discovered post-apply.

## Constraints & Security Requirements

- Terraform CLI version: pinned to a supported major release (Terraform >= 1.5 recommended).
- AzureRM provider: pin provider versions in root and module constraints to avoid
	unintended upgrades during CI runs.
- Remote state backend: Azure Storage Blob with container, and soft-delete/retention
	configured per org policy. State encryption at rest MUST be enabled.
- Secrets: Use Azure Key Vault. Do not check secrets into git or variables files. State files
	are sensitive; access MUST be restricted.
- Least privilege: Automation identities (managed identities or service principals) MUST
	adhere to least-privilege principles and scoped roles.

## Development Workflow

- Local development: developers MUST run `terraform fmt` and `terraform validate` locally.
- Branch workflow: All infra changes MUST be made in feature branches. A Terraform plan
	artifact MUST be attached to the PR for review. Approval required from at least one
	platform maintainer for non-trivial changes to shared modules or production infra.
- CI gates: PR must pass linting (tflint/conftest), unit/module tests, and produce a
	plan; applies to protected environments must occur via the pipeline only.

## Governance

The Constitution is the authoritative policy for repository infrastructure practice. Amendments
require a Pull Request with an explicit migration plan and at least two approving maintainers.
Versioning follows semantic versioning with these rules:

- MAJOR: Backwards-incompatible governance changes (e.g., removal or redefinition of a
	Principle or fundamental workflow change).
- MINOR: Addition of a Principle or material expansion of guidance.
- PATCH: Clarifications, typos, or non-functional wording changes.

All PRs that change infrastructure code MUST reference the relevant Principle(s) and show
how the change complies. Compliance reviews will be performed during PR review and by
scheduled audits.

**Version**: 1.0.0 | **Ratified**: 2025-11-04 | **Last Amended**: 2025-11-04
