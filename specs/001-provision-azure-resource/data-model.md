# data-model.md

## Entities

- ResourceGroup
  - id: string
  - name: string (pattern: [resource-type]-[project]-[cloud]-[env]-[running-number])
  - location: string
  - tags: map

- StorageAccount
  - id, name, sku, kind, access_tier

- AIMultiServiceAccount
  - id, name, region, sku

- CognitiveSearchService
  - id, name, sku, partition_count

## Relationships

- ResourceGroup contains StorageAccount, AIMultiServiceAccount, CognitiveSearchService

## Validation Rules

- name must match regex: ^[a-z0-9][-a-z0-9]{0,60}$ (module will normalize/validate)
- tags must include: project, environment, owner, cost_center
