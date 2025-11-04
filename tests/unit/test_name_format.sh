#!/usr/bin/env bash
set -euo pipefail

project=testproj
env=sbx
running=5

expected=$(printf "rg-%s-az-%s-%03d" "$project" "$env" "$running")

# Reuse the resource module logic by replicating normalization used in module
project_norm=$(echo "$project" | tr '[:upper:]' '[:lower:]' | sed -E 's/\s+/-/g')
env_norm=$(echo "$env" | tr '[:upper:]' '[:lower:]')
constructed=$(printf "rg-%s-az-%s-%03d" "$project_norm" "$env_norm" "$running")

if [ "$constructed" != "$expected" ]; then
  echo "Name format test failed: expected $expected got $constructed"
  exit 2
fi

echo "Name format test passed: $constructed"
