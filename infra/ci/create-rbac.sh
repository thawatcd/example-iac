#!/usr/bin/env bash
set -euo pipefail

echo "This script is a template showing how to provision storage + RBAC for CI. Edit before running."

# Parameters (example)
RESOURCE_GROUP=${1:-rg-backend-demo}
LOCATION=${2:-eastus}
STORAGE_ACCOUNT=${3:-stbackenddemo}
CONTAINER=${4:-tfstate}

# Create resource group
az group create -n "$RESOURCE_GROUP" -l "$LOCATION"

# Create storage account
az storage account create -n "$STORAGE_ACCOUNT" -g "$RESOURCE_GROUP" -l "$LOCATION" --sku Standard_LRS --https-only true

# Create container
az storage container create --name "$CONTAINER" --account-name "$STORAGE_ACCOUNT"

# Create service principal for CI (or use managed identity)
sp=$(az ad sp create-for-rbac -n "http://ci-${STORAGE_ACCOUNT}" --role "Storage Blob Data Contributor" --scopes "/subscriptions/")
echo "Service principal created (edit scope as needed): $sp"

echo "Grant the service principal 'Storage Blob Data Contributor' on the storage account explicitly (if above scope not correct):"
echo "az role assignment create --assignee <appId> --role 'Storage Blob Data Contributor' --scope /subscriptions/<sub>/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT"

echo "Create GitHub secrets: TF_STATE_STORAGE_ACCOUNT=$STORAGE_ACCOUNT, TF_STATE_CONTAINER=$CONTAINER, AZURE_TENANT_ID=<tenant>, AZURE_CLIENT_ID=<appId>"
