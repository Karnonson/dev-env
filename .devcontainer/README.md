# Dev Container Profiles

This workspace uses one dev container entrypoint with four Docker build targets.

- `base`: Shared tooling for mixed Python and TypeScript repositories.
- `python`: `base` plus common native libraries for Python web apps and agent backends.
- `typescript`: `base` plus extra browser-related system libraries for TypeScript web apps.
- `fullstack`: `base` plus both Python native libraries and browser system libraries.

The active profile is the `target` value in `.devcontainer/devcontainer.json`.

On container creation, `.devcontainer/post-create.sh` only finishes shared tool setup. The repo's VS Code chat customizations are workspace files, so VS Code discovers them directly from the repository instead of copying them into the container user's profile.

The same post-create step also installs a `kite` helper into `/usr/local/bin`. In a repo that already has this `.devcontainer/` folder, you can run `kite install speckit .` from the integrated terminal to bootstrap Spec Kit after the container is ready, `kite update workspace .` to refresh the copied workspace assets, `kite doctor .` to verify the setup, and `kite status .` to inspect whether the repo is current.

On Linux, switch profiles with:

```bash
bash .devcontainer/switch-profile.sh python
bash .devcontainer/switch-profile.sh typescript
bash .devcontainer/switch-profile.sh fullstack
bash .devcontainer/switch-profile.sh base
```

After switching, run `Dev Containers: Rebuild Container` in VS Code.

If you prefer to switch manually, edit the `build.target` field in `.devcontainer/devcontainer.json` and rebuild the container.

## Bundled VS Code Customizations

Store reusable workspace chat customizations in these folders:

- `.github/prompts/` for `*.prompt.md` slash commands
- `.github/agents/` for `*.agent.md` custom agents
- `.github/instructions/` for `*.instructions.md` file-based instructions

These files are versioned with the repo and loaded automatically by VS Code when the workspace opens.

If you update these files, reload the VS Code window if the customization UI does not refresh immediately.
