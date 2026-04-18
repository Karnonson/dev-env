# dev-env

Reusable development container template for future projects.

This repository packages two things together:

- a multi-profile `.devcontainer/` setup for base, Python, and TypeScript work
- repo-managed VS Code chat customizations in `.vscode-prompts/`

When a future project reuses this repository's dev container files, the container post-create step installs the bundled custom agents, instructions, and prompts into the container user's VS Code prompt directories automatically.

## Repository Layout

- `.devcontainer/`: container build, bootstrap, and profile-switching scripts
- `.vscode-prompts/`: source-controlled VS Code user customizations copied into the container on create
- `install.sh`: CLI installer for pulling this setup into another repository

## Install Into A Future Project

From the target repository root:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- .
```

This installs `.devcontainer/` and `.vscode-prompts/` into the current project.

If those directories already exist and you want to replace them:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- --force .
```

You can also run the installer from a local checkout of this repository:

```bash
bash install.sh ../my-project
```

## After Install

1. Open the target repository in VS Code.
2. Run `Dev Containers: Reopen in Container`.
3. After the container is created, your bundled customizations will be installed automatically.

## Update Bundled Customizations

Edit the files under `.vscode-prompts/` in this repository.

To re-install them inside an already running container:

```bash
bash .devcontainer/install-vscode-prompts.sh
```

## Installer Options

```bash
bash install.sh --help
```

Supported options:

- `--force`: replace existing `.devcontainer/` and `.vscode-prompts/`
- `--ref`: install from a different Git ref
- `--repo`: install from a different GitHub repository
- `--source-dir`: install from a local dev-env checkout instead of downloading

## Recommended GitHub Setup

Use this repository as a template repository if you want to start new projects from it directly. If you only want the environment layer, copy the two folders above into an existing repository instead.