# dev-env

Reusable development container template for future projects.

This repository packages three things together:

- a multi-profile `.devcontainer/` setup for base, Python, TypeScript, and fullstack work
- workspace-managed VS Code prompt files in `.github/prompts/`
- workspace-managed VS Code custom agents in `.github/agents/`
- workspace-managed VS Code file-based instructions in `.github/instructions/`
- repo-managed Speckit preset and workflow assets in `spec-kit/`

When a future project uses this repository's dev container setup, VS Code automatically detects and loads the bundled prompts, agents, and instructions from their workspace folders without needing any installation step.

The installer copies `.devcontainer/`, `.github/prompts/`, `.github/agents/`, and `.github/instructions/` into the target project. Speckit presets and workflows are installed directly into `.specify/` without leaving a separate `spec-kit/` directory in the target repo.

## Repository Layout

- `.devcontainer/`: container build, bootstrap, and profile-switching scripts
- `.github/prompts/`: workspace-scoped slash-command prompt files
- `.github/agents/`: workspace-scoped custom agents
- `.github/instructions/`: workspace-scoped file-based instructions
- `spec-kit/`: bundled Speckit preset and custom workflow assets
- `extras/`: optional prompts and customizations not installed by default
- `.speckit-version`: pinned Speckit CLI version used by the installer and CI
- `install.sh`: CLI installer for pulling this setup into another repository

## Install Into A Future Project

Quick paths:

1. Host bootstrap only: `curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- .`
2. Host bootstrap plus host Speckit bootstrap: `curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- --with-speckit .`
3. Host bootstrap first, then container-native Speckit bootstrap: `dev-env install speckit .` after reopening in the container
4. Refresh copied workspace assets from inside the container: `dev-env update workspace .`

From the target repository root:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- .
```

This installs `.devcontainer/`, `.github/prompts/`, `.github/agents/`, and `.github/instructions/` into the current project.

If those directories already exist and you want to replace them:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- --force .
```

To install the environment and bootstrap Speckit in the target project too:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- --with-speckit .
```

*Note: The `--with-speckit` flag requires `uv` (specifically `uvx`) or `specify` to be installed on your machine. If you don't have those, you can run the basic install command on your host machine, rebuild the container, and then run the `--with-speckit` command from inside the container where `uv` is available by default.*

That creates `.specify/` plus the generated Speckit command files under `.github/` without copying `spec-kit/` into the target repository.

If you prefer not to install Spec Kit from the host at all, use a two-step flow:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- .
```

Then reopen the project in the dev container and run:

```bash
dev-env install speckit .
```

The `dev-env` command is installed by `.devcontainer/post-create.sh`, so once the container is ready you can bootstrap Spec Kit without any extra host-machine dependencies.

If you later update this repository and want to refresh the copied `.devcontainer/` and `.github/` assets from inside the container, run:

```bash
dev-env update workspace .
```

If you want that refresh to also bootstrap or refresh the bundled Spec Kit setup in the target repo, run:

```bash
dev-env update workspace --with-speckit .
```

If the target already has `.specify/` and you intentionally want to reinitialize it, add `--force-speckit-init`.

You can also run the installer from a local checkout of this repository:

```bash
bash install.sh --source-dir "$PWD" ../my-project
```

## After Install

1. Open the target repository in VS Code.
2. Run `Dev Containers: Reopen in Container`.
3. VS Code will detect the bundled workspace customizations automatically.

Prompt files show up as slash commands in chat, for example `/bootstrap-speckit`.
Custom agents show up in the agent picker, not in the slash-command list.
Instructions files do not become slash commands. They are applied automatically when they match by `applyTo`, or can be added from the chat customizations UI.

## Update Bundled Customizations

Edit the files under these folders in this repository:

- `.github/prompts/`
- `.github/agents/`
- `.github/instructions/`

Modifications to these files are picked up by VS Code automatically, as they are part of the workspace context. No installation script is necessary!

## Troubleshooting Chat Customizations

If the files were installed but you do not see them in chat:

1. Open `Chat: Open Chat Customizations` and verify the prompts, agents, or instructions appear there.
2. In the Chat view, open the context menu and use Diagnostics to see any loading errors.
3. Reload the VS Code window.
4. Confirm you are checking the right UI surface:
   - prompt files: slash commands
   - custom agents: agent picker
   - instructions: automatic application or the instructions picker

## Installer Options

```bash
bash install.sh --help
```

Supported options:

- `--force`: replace existing `.devcontainer/`, `.github/prompts/`, `.github/agents/`, and `.github/instructions/`
- `--dry-run`: show what would be installed without writing anything
- `--with-speckit`: initialize Spec Kit and install the bundled preset and workflow
- `--speckit-only`: initialize or update only Spec Kit assets without reinstalling `.devcontainer/` or `.github/`
- `--force-speckit-init`: reinitialize Spec Kit even when `.specify/` already exists
- `--speckit-version`: pin the Spec Kit CLI version used for bootstrap
- `--ref`: install from a different Git ref
- `--repo`: install from a different GitHub repository
- `--source-dir`: install from a local dev-env checkout instead of downloading

## Speckit Customization

The bundled Speckit assets live under `spec-kit/`.

They are designed to support the workflow you described:

- `spec-kit/presets/orchestrator-workflow/` replaces `speckit.constitution` so the agent asks questions before drafting the constitution.
- `spec-kit/presets/orchestrator-workflow/commands/speckit.design.md` adds a design-system and UX step before specification.
- `spec-kit/presets/orchestrator-workflow/commands/speckit.implement.md` turns implementation into a stricter coordination step that requires analysis and sequences backend before UI.
- `spec-kit/workflows/orchestrator-design-first.yml` adds a design-first workflow with explicit analysis and backend/UI review gates.

## Speckit Stability

Yes, upstream Speckit changes can break a customization if it depends on internal file layouts or unpinned behavior.

This repo uses a safer approach:

1. Pin the bootstrap CLI version with `--speckit-version`.
2. Initialize with `specify init --offline` so template assets come from the pinned CLI bundle instead of a moving remote template.
3. Keep custom behavior in repo-owned preset and workflow files under `spec-kit/`, then apply them into the target repo's `.specify/` structure during install instead of hand-editing generated Speckit files.
4. Validate changes with `bash scripts/validate-speckit.sh` before adopting a new Speckit version.

The installer preserves an existing `.specify/` tree by default. Use `--force-speckit-init` only when you explicitly want to replace that state.

Recommended upgrade process:

1. Change the pinned Speckit version deliberately.
2. Run `bash scripts/validate-speckit.sh`.
3. Only adopt the new version after the validation passes.

Recommended approach for tailoring Speckit to your preferences:

1. Use a preset to replace or add command behavior.
2. Use a custom workflow to change the native stage order.
3. Keep repo-wide rules in `.github/copilot-instructions.md` so Speckit artifacts and your custom agents agree on ownership and handoff rules.

Example commands from a local `dev-env` checkout:

```bash
bash install.sh --with-speckit --source-dir "$PWD" ../my-project
cd ../my-project
specify workflow run orchestrator-design-first -i feature_name="Landing page redesign"
```

## Recommended GitHub Setup

Use this repository as a template repository if you want to start new projects from it directly. If you only want the environment layer, copy the two folders above into an existing repository instead.
