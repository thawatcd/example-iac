# Contributing

This repository follows the project constitution for Terraform and Azure. Before opening a PR, please ensure:

- You used modules for new resources and pinned provider versions.
- No plaintext secrets are committed; secrets must reference Key Vault or CI secrets.
- State is stored in the remote backend for shared environments. For local dev, use the local backend and migrate state before opening PRs.
- Run the following checks locally:

```bash
./scripts/local-validate.sh
scripts/check-no-committed-state.sh
scripts/secrets-scan.sh
```

- CI will run `terraform fmt`, `terraform validate`, and produce a plan artifact. If your change touches shared state backends or adds new resource containers, coordinate with infra owners.
