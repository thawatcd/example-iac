# examples/same-rg

This example composes modules to provision a Resource Group and additional services
in the same resource group. It demonstrates how to configure variables and backends.

Local development: See `../../scripts/init-local.sh` for a safe local init flow (backend=false).

Local backend example: `backend.local.tf.example` shows how to store state locally for quick iteration.
Before creating a PR, migrate state to the remote backend using `scripts/switch-backend.sh` and ensure
the remote backend meets the organization's state locking and retention policies.
