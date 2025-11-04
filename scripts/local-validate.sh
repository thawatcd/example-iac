#!/usr/bin/env bash
set -euo pipefail

echo "Running terraform fmt check..."
cd examples/same-rg
terraform fmt -check

echo "Running terraform validate..."
terraform validate

echo "Local validation passed"
