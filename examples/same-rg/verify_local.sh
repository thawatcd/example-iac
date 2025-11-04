#!/usr/bin/env bash
set -euo pipefail

if ! command -v az >/dev/null 2>&1; then
  echo "az cli not found; install Azure CLI to run this verification"
  exit 2
fi

RG_NAME=$(terraform output -raw resource_group_name || true)
if [ -z "${RG_NAME}" ]; then
  echo "resource_group_name output not found. Run 'terraform apply' first."
  exit 1
fi

echo "Checking resource group: ${RG_NAME}"
rg_json=$(az group show --name "${RG_NAME}" -o json)
if [ -z "${rg_json}" ]; then
  echo "Resource group ${RG_NAME} not found in subscription"
  exit 2
fi

echo "Resource group exists. Verifying tags..."
proj_tag=$(jq -r '.tags.project // empty' <<<"${rg_json}")
env_tag=$(jq -r '.tags.environment // empty' <<<"${rg_json}")

echo "project tag: ${proj_tag}
env tag: ${env_tag}"

if [ -z "${proj_tag}" ] || [ -z "${env_tag}" ]; then
  echo "Required tags missing on resource group"
  exit 3
fi

echo "Verification passed"
