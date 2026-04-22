# Getting Started

Use this guide when you want to install kite into an existing repository or scaffold a new repository with the bundled dev-container workflow.

## Prerequisites

- A Git repository you can edit locally
- VS Code with Dev Containers for the container-native workflow
- Docker or another container runtime supported by Dev Containers
- Optional: `uvx` or `specify` on the host if you want host-side `--with-speckit` bootstrap

## Install Into An Existing Repository

From the target repository root, install the workspace assets:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- .
```

If the target repository already contains `.devcontainer/`, the host installer treats that as a conflict and exits instead of merging the folder. Use one of these paths:

- Replace the existing workspace assets explicitly:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- --force .
```

- Keep the existing container setup, reopen the repository in the container, and use the container-native refresh command later:

```bash
kite update workspace --merge .
```

The host installer already merges missing files for `.github/` workspace assets, `docs/errors/`, and `.kite/config.yml`, but `.devcontainer/` itself is replaced only when you opt into `--force`.

Open the repository in VS Code and reopen it in the container. After the container is ready, verify the setup and bootstrap the bundled Speckit workflow:

```bash
kite doctor .
kite install speckit .
kite status .
```

If you want the host install to bootstrap Speckit immediately too, use:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- --with-speckit .
```

That path requires `uvx` or `specify` on the host machine.

## Scaffold A New Repository

Create a new project with kite assets and the bundled Spec Kit setup:

```bash
kite new my-app --template fullstack --with-speckit
```

The scaffold records your chosen template, license, deploy target, and default verification profile in `.kite/config.yml` so later commands can reuse the same defaults.

## Refresh An Existing Workspace

Preview the refresh before changing files:

```bash
kite update workspace --dry-run .
```

Preserve existing files and only fill in missing assets:

```bash
kite update workspace --merge .
```

Refresh the workspace and bundled Speckit setup together:

```bash
kite update workspace --with-speckit .
```

## First Commands To Run

Use these commands after the container opens:

```bash
kite doctor .
kite status --json .
kite feature .
```

- `kite doctor` checks tool availability, workspace assets, and bundled Spec Kit readiness.
- `kite status --json` prints machine-readable state for scripts or CI.
- `kite feature` shows the active feature, artifact status, and the next recommended action.

## Common Pitfalls

- Host-side `--with-speckit` fails when `uvx` or `specify` is not installed. Run the base install first, reopen in the container, then use `kite install speckit .`.
- `kite update workspace` is destructive by default. Use `--dry-run` or `--merge` when the target repository already contains local workspace customizations.
- `kite verify feature` expects a real feature branch, a clean working tree, and completed active tasks. When a check fails, follow the linked page under [errors/index.md](errors/index.md).
- `kite completion bash` emits the Bash completion script. Load it in the current shell with `source <(kite completion bash)` when needed.
