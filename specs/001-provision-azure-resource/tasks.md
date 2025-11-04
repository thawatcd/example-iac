# Tasks: Provision Storage + AI multi-service + Search (same RG)

This file follows the project's tasks checklist format and is organized by user story.

Phase 1: Setup (project initialization)

- [X] T001 Initialize feature README and scaffold directories (examples, modules) - specs/001-provision-azure-resource/README.md
- [X] T002 Create `modules/storage-account/` skeleton with README and placeholders - modules/storage-account/README.md
- [X] T003 Create `modules/ai-multiservice-account/` skeleton with README and placeholders - modules/ai-multiservice-account/README.md
- [X] T004 Create `modules/cognitive-search/` skeleton with README and placeholders - modules/cognitive-search/README.md
- [X] T005 Create `examples/same-rg/` workspace scaffold: `main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars.example`, `backend.tf.example` - examples/same-rg/

Phase 2: Foundational (blocking prerequisites)

 - [X] T006 [P] [Foundational] Add centralized `providers.tf` example and pin Terraform & azurerm provider versions - examples/same-rg/providers.tf
- [ ] T007 [Foundational] Add backend example for Azure Storage Blob and documentation for container-per-subscription pattern - examples/same-rg/backend.tf.example
 - [X] T009 [Foundational] Add module-level `variables.tf` and `outputs.tf` templates in each module (storage-account, ai-multiservice-account, cognitive-search) - modules/storage-account/variables.tf, modules/ai-multiservice-account/variables.tf, modules/cognitive-search/variables.tf
- [ ] T009 [Foundational] Add module-level `variables.tf` and `outputs.tf` templates in each module (storage-account, ai-multiservice-account, cognitive-search) - modules/storage-account/variables.tf, modules/ai-multiservice-account/variables.tf, modules/cognitive-search/variables.tf
 - [X] T010 [Foundational] Add basic `README.md` with usage instructions and example `terraform init`/`plan`/`apply` steps - examples/same-rg/README.md

Local development (controlled)

 - [X] T026 Add local backend example `backend.local.tf` and a short README explaining its purpose and limitations - examples/same-rg/backend.local.tf.example
 - [X] T027 Add `scripts/init-local.sh` that performs `terraform init -backend=false` then copies/uses a local backend configuration for development; includes explicit warnings to migrate to remote backend before PR - scripts/init-local.sh
 - [X] T028 Add `scripts/switch-backend.sh` helper to migrate state between local and remote backends (uses `terraform init -migrate-state` with sample backend config) and documents manual steps - scripts/switch-backend.sh
 - [X] T029 Add safety check `scripts/check-no-committed-state.sh` to detect accidental `.tfstate` files in the repo and fail (for local pre-commit or CI checks) - scripts/check-no-committed-state.sh
 - [X] T030 Update `examples/same-rg/README.md` with a Local Development section that shows how to run locally with the local backend, how to migrate state to the remote backend, and a checklist of required gates before opening a PR (e.g., migrate state, run `terraform fmt`/`validate`, generate plan artifact) - examples/same-rg/README.md
- [ ] T029 Add safety check `scripts/check-no-committed-state.sh` to detect accidental `.tfstate` files in the repo and fail (for local pre-commit or CI checks) - scripts/check-no-committed-state.sh
- [ ] T030 Update `examples/same-rg/README.md` with a Local Development section that shows how to run locally with the local backend, how to migrate state to the remote backend, and a checklist of required gates before opening a PR (e.g., migrate state, run `terraform fmt`/`validate`, generate plan artifact) - examples/same-rg/README.md

 - [X] T031 [Foundational] Create and document remote backend provisioning script and Terraform example that configures Azure Storage Blob backend with locking enabled, soft-delete/retention, and encryption; include required RBAC roles for automation identities - infra/backend/provision-backend.md
 - [X] T032 [Foundational] Add `scripts/generate-plan-artifact.sh` that runs `terraform plan -out=plan.tfplan` and `terraform show -json plan.tfplan > plan.json` for local/CI usage; document attaching plan.json to PRs - scripts/generate-plan-artifact.sh
 - [X] T033 [Foundational] Add automated secrets-scan script and pre-commit instructions to detect plaintext secrets or committed `.tfstate` files - scripts/secrets-scan.sh
 - [X] T034 [Foundational] Convert optional Terratest scaffold into concrete unit/integration test tasks and add example tests for name formatting and tag presence - tests/integration/test_name_and_tags_suite
 - [X] T013 [US1] Add `modules/resource/outputs.tf` exposing `resource_name` and `resource_id` - modules/resource/outputs.tf
 - [X] T014 [US1] Wire resource group creation into `examples/same-rg/main.tf` using `modules/resource` and add example `terraform.tfvars.example` values for `project_name`, `env` - examples/same-rg/main.tf
 - [X] T015 [US1] Implement name normalization and format validation (fail-fast) in resource module with clear error messages - modules/resource/README.md
 - [X] T016 [US1] Add acceptance verification script for local run that validates resource name and tags via `az` CLI (example script) - examples/same-rg/verify_local.sh

Phase 4: User Story 2 - Module consumption (P2) [US2]

- [ ] T017 [US2] Create `modules/storage-account` implementation wiring to accept `resource_group_name` and follow naming convention - modules/storage-account/main.tf
- [ ] T018 [US2] Create `modules/ai-multiservice-account` implementation accepting `resource_group_name` and configuration - modules/ai-multiservice-account/main.tf
- [ ] T019 [US2] Create `modules/cognitive-search` implementation accepting `resource_group_name` and sku settings - modules/cognitive-search/main.tf
- [ ] T020 [US2] Add example composition in `examples/same-rg/main.tf` to instantiate storage, ai multi-service, and cognitive search into the created resource group - examples/same-rg/main.tf
- [ ] T021 [US2] Add outputs in the example workspace to expose the three resource ids and names - examples/same-rg/outputs.tf

 - [X] T017 [US2] Create `modules/storage-account` implementation wiring to accept `resource_group_name` and follow naming convention - modules/storage-account/main.tf
 - [X] T018 [US2] Create `modules/ai-multiservice-account` implementation accepting `resource_group_name` and configuration - modules/ai-multiservice-account/main.tf
 - [X] T019 [US2] Create `modules/cognitive-search` implementation accepting `resource_group_name` and sku settings - modules/cognitive-search/main.tf
 - [X] T020 [US2] Add example composition in `examples/same-rg/main.tf` to instantiate storage, ai multi-service, and cognitive search into the created resource group - examples/same-rg/main.tf
 - [X] T021 [US2] Add outputs in the example workspace to expose the three resource ids and names - examples/same-rg/outputs.tf

 - [X] T032 [Foundational] Add `scripts/generate-plan-artifact.sh` that runs `terraform plan -out=plan.tfplan` and `terraform show -json plan.tfplan > plan.json` for local/CI usage; document attaching plan.json to PRs - scripts/generate-plan-artifact.sh
 - [X] T033 [Foundational] Add automated secrets-scan script and pre-commit instructions to detect plaintext secrets or committed `.tfstate` files - scripts/secrets-scan.sh
 - [X] T034 [Foundational] Convert optional Terratest scaffold into concrete unit/integration test tasks and add example tests for name formatting and tag presence - tests/integration/test_name_and_tags_suite

 - [X] T036 [CI] Add CI docs and RBAC helper script demonstrating required GitHub secrets and Azure RBAC steps - infra/ci/README.md, infra/ci/create-rbac.sh

Phase 5: Polish & Cross-Cutting Concerns

 - [X] T022 [P] Add `terraform fmt` and `terraform validate` check instructions for local runs and a small helper script `scripts/local-validate.sh` - scripts/local-validate.sh
 - [X] T023 Add documentation about `running_number` allocation and a simple local helper script that suggests the next available number by scanning resources (optional, non-atomic) - examples/same-rg/next_running_number.sh
 - [X] T024 Add a `CONTRIBUTING.md` section describing the constitution gates and required checks before merging - .github/CONTRIBUTING.md
 - [X] T025 [P] Add basic Terratest-style integration test scaffold (optional) to run minimal checks locally - tests/integration/README.md

 - [X] T031 [Foundational] Create and document remote backend provisioning script and Terraform example that configures Azure Storage Blob backend with locking enabled, soft-delete/retention, and encryption; include required RBAC roles for automation identities - infra/backend/provision-backend.md
- [ ] T032 [Foundational] Add `scripts/generate-plan-artifact.sh` that runs `terraform plan -out=plan.tfplan` and `terraform show -json plan.tfplan > plan.json` for local/CI usage; document attaching plan.json to PRs - scripts/generate-plan-artifact.sh
- [ ] T033 [Foundational] Add automated secrets-scan script and pre-commit instructions to detect plaintext secrets or committed `.tfstate` files - scripts/secrets-scan.sh
- [ ] T034 [Foundational] Convert optional Terratest scaffold into concrete unit/integration test tasks and add example tests for name formatting and tag presence - tests/integration/test_name_and_tags_suite

Dependencies and Order

- Dependency graph (high-level):
  - Phase 1 tasks (T001-T005) -> Phase 2 foundational tasks (T006-T010)
  - Foundational tasks -> US1 tasks (T011-T016)
  - US1 completion -> US2 tasks (T017-T021)
  - Polishing tasks can run in parallel where marked [P]

Parallel Execution Examples

- T006 and T007 can run in parallel (provider pinning vs backend doc) - they touch different files. Marked [P].
- Module implementations for storage, ai, search (T017-T019) can be developed in parallel once `modules/resource` is stable and exposes `resource_group_name` - marked [US2] but not marked [P] because they depend on resource module contract.
- Polish scripts (T022, T025) are parallelizable and marked [P].

Independent Test Criteria (per story)

- US1: Running `examples/same-rg/verify_local.sh` after `terraform apply` returns success (resource exists and name matches regex) and `az group show --name <name>` returns expected tags.
- US2: After composing modules in `examples/same-rg/main.tf`, the example outputs contain three resource ids and `az` CLI checks confirm each service exists.

Implementation Strategy (MVP first)

- MVP: Deliver `modules/resource` and a minimal `examples/same-rg` that provisions the Resource Group and verifies naming/tags (complete US1). That is the highest priority and minimal valuable increment.
- Iteration 2: Implement `modules/storage-account`, `modules/ai-multiservice-account`, and `modules/cognitive-search` and add them to the example workspace (US2).
- Iteration 3: Polish scripts, tests, and documentation.

Format Validation

- Total tasks: 34
- Tasks per story: US1: 6 (T011-T016), US2: 5 (T017-T021)
- All tasks use the required checklist format with Task IDs and file paths.
