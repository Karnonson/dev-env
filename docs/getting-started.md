# Getting Started

Use this guide when you want to install kite into an existing repository or prepare the next repository with the bundled workflow. kite is container-first: the supported path is to work inside a dev container based on the bundled `base` container or another container that preserves the same contract.

## Prerequisites

- A Git repository you can edit locally
- VS Code with Dev Containers for the container-native workflow
- Docker or another container runtime supported by Dev Containers
- For optional host-side bootstrap from GitHub: `curl` and `tar`
- For optional host-side `--with-speckit`: `uvx` or `specify`

## The Kite Container Contract

- `kite` runs inside the container
- The post-create setup runs before first use
- Workspace `.github/` customizations remain in the repository
- `kite doctor .` and `kite install speckit .` work in the integrated terminal

## Use The Bundled Base Container

If the repository already contains Kite's `.devcontainer/`, reopen it in the container and finish setup there:

```bash
kite doctor .
kite install speckit .
kite status .
```

## Install Into An Existing Repository

Use the host only to copy the workspace assets into a repository that does not already contain them:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- .
```

After the files are in place, reopen the repository in the container and finish bootstrap there:

```bash
kite doctor .
kite install speckit .
kite status .
```

If the target repository already contains `.devcontainer/`, the host installer preserves that folder by default. It refreshes the Kite-owned support files under `.devcontainer/bin/kite`, `.devcontainer/kite-post-create.sh`, and `.devcontainer/README.kite.md` without replacing the repo-owned container definition files. Use `--force` only when you intentionally want to replace the existing workspace assets with the bundled base container:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- --force .
```

When you keep an existing `.devcontainer/`, reopen the repository in that container. If `kite` is not yet on `PATH`, run the additive Kite support script once:

```bash
bash .devcontainer/kite-post-create.sh
```

Then confirm the container contract and use the safer refresh path for missing workspace assets:

```bash
kite doctor .
kite update workspace --merge .
```

## Extend The Base Container Safely

Keep `.devcontainer/devcontainer.json` on the `base` target and layer repo-specific packages, devcontainer features, environment variables, and forwarded ports on top of that base.

Preserve the post-create step that installs `kite` inside the container. In the bundled setup, that is:

```bash
bash .devcontainer/post-create.sh
```

If you manage your own `.devcontainer/`, keep equivalent behavior so `kite`, Bash completion, and the workspace-level `.github/` customizations remain available after container creation.

After you change the container, rebuild it and verify the workspace:

```bash
kite doctor .
kite status .
```

## Optional Host-side Speckit Bootstrap

If you want the host installer to bootstrap Speckit immediately too, add `--with-speckit`:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- --with-speckit .
```

That shortcut is secondary to the container flow and requires `curl`, `tar`, and `uvx` or `specify` on the host.

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
- `kite feature` shows the active feature, artifact status, and the next recommended action in the default lifecycle.

## Common Pitfalls

- Host-side bootstrap needs `curl` and `tar`. If either is missing, the GitHub `install.sh` path fails before it copies any assets.
- Host-side `--with-speckit` also needs `uvx` or `specify`. If that is missing, run the base install first, reopen in the container, then use `kite install speckit .` from the container terminal.
- `kite update workspace` is destructive by default. Use `--dry-run` or `--merge` when the target repository already contains local workspace customizations.
- `kite verify feature` expects a real feature branch, a clean working tree, and completed active tasks. When a check fails, follow the linked page under [errors/index.md](errors/index.md).
- `kite completion bash` emits the Bash completion script. Load it in the current shell with `source <(kite completion bash)` when needed.
