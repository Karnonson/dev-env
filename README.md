# kite

[![CI](https://github.com/Karnonson/kite/actions/workflows/validate.yml/badge.svg)](https://github.com/Karnonson/kite/actions/workflows/validate.yml)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

kite is a container-first Speckit workflow CLI and reusable base devcontainer for future repositories. It installs workspace assets, keeps Copilot and Speckit guidance versioned with the repo, and adds branch-first verification, test, audit, and release commands inside the container.

## Quickstart

Supported Kite workflows run inside a dev container. Start from the bundled `base` container in a new repo, or keep your existing `.devcontainer/` and extend it so the same container contract still holds: `kite` is available in the container, the post-create setup runs, workspace `.github/` customizations stay present, and `kite doctor` plus `kite install speckit` work from the terminal.

After the repository opens in that container, verify and bootstrap the workflow:

```bash
kite doctor .
kite install speckit .
kite status .
```

If you need to copy the workspace assets into an existing repository first, the host-side bootstrap is available as a secondary path. It requires `curl` and `tar` on the host. Add `uvx` or `specify` only if you also want host-side Speckit bootstrap with `--with-speckit`.

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- .
```

If the target repository already has a `.devcontainer/` folder, the installer preserves it by default and refreshes the Kite-owned support files under `.devcontainer/bin/kite`, `.devcontainer/kite-post-create.sh`, and `.devcontainer/README.kite.md`. Use `--force` only when you intend to swap in the bundled container. After reopening in that container:

- run `bash .devcontainer/kite-post-create.sh` if `kite` is not yet on `PATH`
- if the workspace was not already a git repository, Kite initializes one on `main` during post-create so discovery can start on a feature branch immediately
- run `kite doctor .`

## Minimal Example

Preview a workspace refresh, inspect machine-readable status, and check the active feature handoff:

```bash
kite update workspace --dry-run .
kite status --json .
kite feature .
```

## Documentation

- [Docs index](docs/index.md)
- [Getting started](docs/getting-started.md)
- [Common workflows](docs/usage/common-workflows.md)
- [CLI reference](docs/reference/index.md)
- [Error recovery guides](docs/errors/index.md)

## What kite installs

- `.devcontainer/` for the single base devcontainer entrypoint and post-create setup
- `.github/prompts/`, `.github/agents/`, and `.github/instructions/` for workspace-scoped Copilot customizations
- `.github/copilot-instructions.md` for repo workflow conventions
- `.kite/config.yml` for repo-local scaffold and workflow defaults
- `docs/errors/` for CLI recovery pages linked from failure output
- `.specify/` assets when you run `kite install speckit` or use `--with-speckit`

## Contributing And License

Use [docs/index.md](docs/index.md) as the starting point for the CLI docs, [CONTRIBUTING.md](CONTRIBUTING.md) for contribution rules, and [CHANGELOG.md](CHANGELOG.md) for release history. The project is released under the [MIT License](LICENSE).
