# kite

[![CI](https://github.com/Karnonson/kite/actions/workflows/validate.yml/badge.svg)](https://github.com/Karnonson/kite/actions/workflows/validate.yml)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

kite is a container-native Speckit workflow CLI and reusable dev-container starter for future repositories. It installs workspace assets, bootstraps the bundled Spec Kit workflow, and adds branch-first verification, test, audit, and release commands inside the container.

## Quickstart

Install kite assets into an existing repository from the repository root:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- .
```

If the target repository already has a `.devcontainer/` folder, the host installer stops instead of merging it. Re-run with `--force` to replace the existing workspace assets, or keep the existing container setup and refresh assets later from inside the container with `kite update workspace --merge`.

Reopen the repository in the dev container, then verify and bootstrap the workflow:

```bash
kite doctor .
kite install speckit .
kite status .
```

Scaffold a new repository instead of retrofitting an existing one:

```bash
kite new my-app --template fullstack --with-speckit
```

## Minimal Example

Preview a workspace refresh, inspect machine-readable status, and run the pre-merge guardrails:

```bash
kite update workspace --dry-run .
kite status --json .
kite verify feature .
```

## Documentation

- [Docs index](docs/index.md)
- [Getting started](docs/getting-started.md)
- [Common workflows](docs/usage/common-workflows.md)
- [CLI reference](docs/reference/index.md)
- [Error recovery guides](docs/errors/index.md)

## What kite installs

- `.devcontainer/` for the reusable development container setup
- `.github/prompts/`, `.github/agents/`, and `.github/instructions/` for workspace-scoped Copilot customizations
- `.github/copilot-instructions.md` for repo workflow conventions
- `.kite/config.yml` for repo-local scaffold and workflow defaults
- `docs/errors/` for CLI recovery pages linked from failure output
- `.specify/` assets when you run `kite install speckit` or use `--with-speckit`

## Contributing And License

Use [docs/index.md](docs/index.md) as the starting point for the CLI docs, [CONTRIBUTING.md](CONTRIBUTING.md) for contribution rules, and [CHANGELOG.md](CHANGELOG.md) for release history. The project is released under the [MIT License](LICENSE).
