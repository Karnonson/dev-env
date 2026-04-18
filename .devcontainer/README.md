# Dev Container Profiles

This workspace uses one dev container entrypoint with three Docker build targets.

- `base`: Shared tooling for mixed Python and TypeScript repositories.
- `python`: `base` plus common native libraries for Python web apps and agent backends.
- `typescript`: `base` plus extra browser-related system libraries for TypeScript web apps.

The active profile is the `target` value in `.devcontainer/devcontainer.json`.

On container creation, `.devcontainer/post-create.sh` also installs the repo's VS Code chat customizations from `.vscode-prompts/` into the container user's prompt directories. This makes your custom agents, instructions, and prompts available in future repositories that reuse this dev container setup.

On Linux, switch profiles with:

```bash
bash .devcontainer/switch-profile.sh python
bash .devcontainer/switch-profile.sh typescript
bash .devcontainer/switch-profile.sh base
```

After switching, run `Dev Containers: Rebuild Container` in VS Code.

If you prefer to switch manually, edit the `build.target` field in `.devcontainer/devcontainer.json` and rebuild the container.

## Bundled VS Code Customizations

Store reusable user-level chat customizations in `.vscode-prompts/`.

The installer copies supported files into these locations when the container is created:

- `~/.vscode-server/data/User/prompts`
- `~/.vscode-server-insiders/data/User/prompts`
- `~/.config/Code/User/prompts`
- `~/.config/Code - Insiders/User/prompts`

Supported file types:

- `*.agent.md`
- `*.instructions.md`
- `*.prompt.md`

If you update files in `.vscode-prompts/`, rebuild the container or run `bash .devcontainer/install-vscode-prompts.sh` inside the container to refresh the installed copies.
