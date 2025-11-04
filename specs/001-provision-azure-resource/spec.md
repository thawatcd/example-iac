
# Feature Specification: Provision Azure Resource (Terraform module)

**Feature Branch**: `001-provision-azure-resource`  
**Created**: 2025-11-04  
**Status**: Draft  
**Input**: User description: "Create a Terraform module and example to provision Azure resources with naming convention: [resource type]-[project name]-[Cloud name]-[environment]-[running number]. Project name and environment configurable via variables file. Example RG name: rg-inseedang-az-sbx-001"

## Constitution Alignment

This spec implements infrastructure governance items from the constitution:

- Terraform module: `modules/resource` (versioned, published via git tags or registry)
- Remote state backend: Azure Storage Blob (documented backend config in README)
- Secrets handling: Use Azure Key Vault; examples will reference Key Vault via provider
 - Environment isolation: Strong isolation — separate Azure subscription per environment; state
   backend and storage container/workspace scoped per-subscription. Production subscription MUST
   have strict RBAC and approval gates documented in the example pipeline.
- CI/CD gating: Pipeline MUST produce plan artifacts and run lint/validate steps


## User Scenarios & Testing *(mandatory)*

### User Story 1 - Provision example resource (Priority: P1)

As a platform engineer, I want a reusable Terraform module and example configuration
that provisions a single Azure resource (resource group) using the project's naming
convention so that teams can quickly create compliant resources for dev/staging/prod.

Why this priority: enables consistent, auditable resource creation and enforces naming
and tagging rules across environments.

Independent Test: Run the example Terraform configuration in a non-production
environment (local or CI) and verify the created resource's name, tags, and state storage.

Acceptance Scenarios:

1. Given an Azure subscription and service principal/managed identity with least-privilege,
   When the example `main.tf` is applied in the sandbox environment,
   Then a resource group named `rg-inseedang-az-sbx-001` is created with required tags.

2. Given a different environment variable (e.g., `env = "prod"`) and incremented running
  number, When the same module is applied, Then the resource name follows the pattern
  and the resource is created in the designated production subscription.

3. Given a CI pipeline invoking the module without a `running_number`, When the pipeline
  computes and injects a `running_number`, Then the created resource name uses the CI-assigned
  number and no collision occurs.

---

### User Story 2 - Module consumption (Priority: P2)

As a developer, I want the module to be consumable with minimal variables so that I can
reference it in my service's provisioning pipeline.

Independent Test: Instantiate the module in a small test workspace with variables
(`project_name`, `env`, `running_number`) and verify output variables and resource naming.

Acceptance Scenario:

1. Given module source and version, When a consumer invokes the module with `project_name = "inseedang"`,
   `env = "sbx"`, `running_number = 1`, Then outputs include the full resource name and resource id.

---

### Edge Cases

- Running number conflicts: if the requested running number already exists, behavior must
  be documented (recommendation: use automation to compute next available number; module
  should not modify existing resources).
- Missing tags or variables: module must fail fast with clear error messages when required
  variables are not provided.
- Secrets missing in Key Vault: CI should detect and fail pipeline if required secrets/roles
  are not accessible.
 - Subscription-level access issues: if the applying identity lacks permissions in the target
   subscription, the apply MUST fail with a clear error and documentation must show required
   roles for each environment.

- Running number allocation: CI-assigned autonumber is the recommended primary flow. The
  module MUST accept an optional `running_number` input; if omitted, CI MUST compute and
  inject a number during the pipeline. The module MUST validate the input format and fail
  fast if invalid. The CI allocation method (e.g., checking existing resource names or a
  small registry) is part of pipeline implementation and must be documented in `examples/`.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Provide a reusable Terraform module `modules/resource` that creates an Azure
  Resource Group (initial scope) and returns its id and name.
- **FR-002**: Naming convention MUST be enforced via variables and outputs; resource name
  format: `[resource-type]-[project-name]-[cloud]-[env]-[running-number]` (example: `rg-inseedang-az-sbx-001`).
- **FR-003**: `project_name` and `env` MUST be configurable via a variables file; `running_number`
  MUST be configurable (integer) and documented; module SHOULD support automated incrementing
  by external tooling (out of scope for the module).
  
  Implementation note: `running_number` MUST be an integer in the range 1..999. The canonical
  formatted form used in resource names is zero-padded to three digits (e.g., `001`, `042`, `123`).
  The module MUST validate `running_number` if provided and return a clear error when it's out
  of range or not an integer. When omitted, CI/tooling MUST inject a valid running number in the
  canonical format.
- **FR-004**: Module MUST pin provider versions and expose a `providers.tf` example for safe
  consumption; CI must run `terraform fmt` and `terraform validate` on module and example.
- **FR-005**: State backend configuration MUST be shown in example (Azure Storage Blob) and
  instructions included for enabling state locking and access control.
- **FR-006**: No plaintext secrets in the module or examples; demonstrate Key Vault integration
  in the example `examples/` folder.

*Assumptions*: The module focuses on Resource Groups initially; other resource types (VMs,
storage accounts) can be added later as separate modules or expansions.

### Key Entities

- **Module**: `modules/resource` — creates Azure resource group, enforces naming/tags
- **Example Workspace**: `examples/same-rg` — demonstrates variable file and backend
- **Variables**: `project_name` (string), `env` (string), `running_number` (number), `tags` (map)

## Success Criteria *(mandatory)*


### Measurable Outcomes

- **SC-001**: Applying the example configuration in a sandbox environment results in a
  created resource whose name exactly matches the naming pattern when given the same inputs.
- **SC-002**: The CI pipeline performs formatting, static validation, and policy checks,
  and produces a reviewable plan artifact for every PR that modifies the module or examples.
- **SC-003**: No secrets are committed to the repository; examples reference a centralized
  secrets store and a pipeline check verifies no plaintext secrets are present.
- **SC-004**: The module exposes outputs (resource_name, resource_id) and automated tests
  verify naming and tag presence in at least one environment.

## Clarifications

### Session 2025-11-04

- Q: Environment isolation model? → A: Separate subscription per environment (Option A)

- Q: running_number allocation? → A: CI-assigned autonumber (Option B)

Applied changes:

- The spec enforces strong isolation: each environment (dev/staging/prod) uses its own
  Azure subscription. The example and backend configuration will show how to scope state
  to a subscription's storage container. Production subscription is documented as requiring
  stricter RBAC and approval gating in the pipeline.


