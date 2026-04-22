# kite

Reusable development container template for future projects.

This repository packages the following together:

- a multi-profile `.devcontainer/` setup for base, Python, TypeScript, and fullstack work
- repo-local `.kite/config.yml` defaults for picker-driven workflow choices
- workspace-managed VS Code prompt files in `.github/prompts/`
- workspace-managed VS Code custom agents in `.github/agents/`
- workspace-managed VS Code file-based instructions in `.github/instructions/`
- support docs under `docs/errors/` for guided CLI recovery
- repo-level workflow rules in `.github/copilot-instructions.md`
- repo-managed Speckit preset and workflow assets in `spec-kit/`

The bundled workflow follows a Strategist-led Software Design Document (SDD) cycle: Strategist clarifies the idea, constitution locks standards, Specify writes specs, Designer creates brand identity and design tokens, then the plan-tasks-analyze-implement-test-review pipeline runs on a feature branch.

When a future project uses this repository's dev container setup, VS Code automatically detects and loads the bundled prompts, agents, and instructions from their workspace folders without needing any installation step.

The installer copies `.devcontainer/`, `.github/prompts/`, `.github/agents/`, `.github/instructions/`, `.github/copilot-instructions.md`, and `docs/errors/` into the target project. It also seeds `.kite/config.yml` when that file is missing and preserves existing repo-local config choices. When the `.github/` folders or `.specify/` already exist, the installer merges in missing files by default and preserves the files that are already there. Speckit presets and workflows are installed directly into `.specify/` without leaving a separate `spec-kit/` directory in the target repo.

## Repository Layout

- `.devcontainer/`: container build, bootstrap, and profile-switching scripts
- `.kite/`: repo-local defaults for scaffold choices and future workflow decisions
- `.github/prompts/`: workspace-scoped slash-command prompt files
- `.github/agents/`: workspace-scoped custom agents
- `.github/instructions/`: workspace-scoped file-based instructions
- `docs/errors/`: short recovery guides for common `kite` failures
- `spec-kit/`: bundled Speckit preset and custom workflow assets
- `.speckit-version`: pinned Speckit CLI version used by the installer and CI
- `install.sh`: CLI installer for pulling this setup into another repository

## Install Into A Future Project

Quick paths:

1. Host bootstrap only: `curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- .`
2. Host bootstrap plus host Speckit bootstrap: `curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- --with-speckit .`
3. Host bootstrap first, then container-native Speckit bootstrap: `kite install speckit` after reopening in the container
4. Refresh copied workspace assets from inside the container: `kite update workspace`
5. Preview a workspace refresh without changing files: `kite update workspace --dry-run`
6. Diagnose the container-native setup: `kite doctor`
7. Check whether assets are current and Spec Kit is bootstrapped: `kite status`
8. Run the dedicated pre-merge feature-branch verification step: `kite verify feature`
9. Emit machine-readable status for scripts or CI: `kite status --json`
10. Print shell completion setup for manual shell wiring: `kite completion bash`
11. Run project tests with the repo default or explicit tiers: `kite test`, `kite test --tier integration`, or `kite test --profile full`
12. Audit dependencies for security vulnerabilities: `kite audit` or `kite audit --fix`
13. Scaffold a new project with kite and bundled Speckit assets: `kite new my-app --template fullstack --with-speckit`
14. Prepare a release on a feature branch: `kite release prepare --bump minor`
15. Publish it from `main` after merge: `kite release publish --bump minor --confirm`

From the target repository root:

````bash
# kite

[![CI](https://github.com/Karnonson/kite/actions/workflows/validate.yml/badge.svg)](https://github.com/Karnonson/kite/actions/workflows/validate.yml)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

kite is a container-native Speckit workflow CLI and reusable dev-container starter for future repositories. It installs workspace assets, bootstraps the bundled Spec Kit workflow, and adds branch-first verification, test, audit, and release commands inside the container.

## Quickstart

Install kite assets into an existing repository from the repository root:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- .
````

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

```bash

```
