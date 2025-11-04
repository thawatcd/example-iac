# Provision remote backend for Terraform state

This folder contains a small Terraform example that provisions an Azure Resource Group, Storage Account and Blob Container suitable for use as a Terraform remote backend.

Usage (example):

```bash
cd infra/backend
terraform init
terraform apply -var="resource_group_name=rg-backend-demo" -var="storage_account_name=stbackenddemo" -var="location=eastus"
```

The module will create a storage account and a private blob container named `tfstate` by default. After provisioning, create a backend config in your example workspace with the storage account and container names and run `terraform init -migrate-state` to move local state.

RBAC notes:
- Grant your automation identity (CI service principal or managed identity) `Storage Blob Data Contributor` on the storage account to allow plan/apply operations and state locking.
