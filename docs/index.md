# Documentation

kite combines a reusable base devcontainer with a container-first CLI for installing workspace assets, bootstrapping Speckit, and enforcing a branch-first delivery flow.

Supported Kite workflows run inside a container that either uses the bundled `base` devcontainer or preserves the same contract in an existing repo-owned `.devcontainer/`.

## Start Here

- [Getting started](getting-started.md) for the container contract, safe base-container extension, and host-side prerequisites
- [Common workflows](usage/common-workflows.md) for day-to-day CLI usage patterns
- [CLI reference](reference/index.md) for command-by-command documentation
- [Error recovery guides](errors/index.md) for failure-specific next steps printed by `kite`

## Command Groups

### Workspace and container setup

- [kite install speckit](reference/install-speckit.md)
- [kite update workspace](reference/update-workspace.md)
- [kite doctor](reference/doctor.md)
- [kite status](reference/status.md)

### Project operations

- [kite test](reference/test.md)
- [kite audit](reference/audit.md)
- [kite release](reference/release.md)
- [kite verify feature](reference/verify-feature.md)

### Feature visibility

- [kite feature](reference/feature.md)
- [kite explain](reference/explain.md)

The recommended lifecycle is `feature setup (branch/context alignment) -> discover -> constitution -> specify -> design when needed -> plan -> tasks -> analyze -> implement -> test -> review -> verify -> release`. Legacy repos may still contain a `brief.md` artifact on disk, but the supported flow does not use it.

### Shell integration and help

- [kite completion](reference/completion.md)
- [kite help](reference/help.md)

## Related Files

- [README.md](../README.md) for the short project overview and quickstart
- [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidance
- [CHANGELOG.md](../CHANGELOG.md) for release history
