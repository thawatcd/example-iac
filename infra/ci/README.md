# CI Integration guide

This document explains what secrets and RBAC are required to run the example GitHub Actions workflow `.github/workflows/terraform-ci.yml`.

Required GitHub secrets (set in repo settings):

- `AZURE_TENANT_ID` - Azure tenant id
- `AZURE_CLIENT_ID` - client id (if using service principal) or leave empty for OIDC
- `TF_STATE_STORAGE_ACCOUNT` - storage account name used for remote state
- `TF_STATE_CONTAINER` - container name used for remote state

If using OIDC federated credentials (recommended), create an Azure AD App registration and configure a federated credential scoped to GitHub Actions. Grant the app a Managed Identity or service principal and assign the `Storage Blob Data Contributor` role on the storage account.

See `create-rbac.sh` for an example az CLI sequence to create the storage account, container, and assign roles to a service principal.
