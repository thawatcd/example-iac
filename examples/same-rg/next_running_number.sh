#!/usr/bin/env bash
set -euo pipefail

# Non-atomic helper: suggests next running_number by scanning existing resources in the subscription using az
if ! command -v az >/dev/null 2>&1; then
  echo "az cli required for next_running_number.sh"
  exit 2
fi

project=${1:-}
env=${2:-}
if [ -z "$project" ] || [ -z "$env" ]; then
  echo "Usage: $0 <project> <env>"; exit 1
fi

prefix="rg-${project}-az-${env}-"
echo "Scanning resource groups for prefix: $prefix"
list=$(az group list -o tsv --query "[?starts_with(name, '${prefix}')].name" 2>/dev/null || true)
max=0
for rg in $list; do
  num=${rg##*-}
  num=$((10#$num))
  if [ $num -gt $max ]; then max=$num; fi
done
next=$((max + 1))
printf "%03d\n" $next
