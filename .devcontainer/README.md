# Base Dev Container

This workspace ships one bundled dev container profile: `base`. `.devcontainer/devcontainer.json` stays pinned to `build.target: "base"`, and there is no bundled profile-switching flow.

On container creation, `.devcontainer/post-create.sh` finishes the shared setup, installs the `kite` helper into `/usr/local/bin`, and enables Bash completion for new Bash terminals. The repo's VS Code chat customizations stay in the workspace, so VS Code discovers them directly from the checked-out files.

## Container-First Workflow

For an existing repo, open the workspace in the bundled container first and then use the CLI from the integrated terminal:

- `kite install speckit .` to bootstrap the bundled Spec Kit preset and workflow
- `kite update workspace .` to refresh copied workspace assets
- `kite doctor .` to verify container tooling and workspace readiness
- `kite status .` to inspect workspace asset and Spec Kit status

Running `kite` with no arguments opens a small terminal home screen with the main commands and the branch-first Speckit workflow summary.

## Extending Base

Customize the bundled `base` container with normal repo-level edits instead of switching profiles:

- Add Dev Container Features in `.devcontainer/devcontainer.json` for extra runtimes or tools.
- Add Ubuntu packages or native libraries in `.devcontainer/Dockerfile` when the repo needs extra system dependencies.
- Make small Dockerfile edits for framework-specific setup that should be versioned with the repo.

After changing the container config, rebuild the container in VS Code.

This dev container also avoids pre-forwarding a batch of common development ports. Forward ports manually from VS Code when the active repo actually needs one.

## Bundled VS Code Customizations

Store reusable workspace chat customizations in these folders:

- `.github/prompts/` for `*.prompt.md` slash commands
- `.github/agents/` for `*.agent.md` custom agents
- `.github/instructions/` for `*.instructions.md` file-based instructions

These files are versioned with the repo and loaded automatically by VS Code when the workspace opens.

If you update these files, reload the VS Code window if the customization UI does not refresh immediately.
