# Common Workflows

Use these flows when you want the shortest path through the most common kite operations. Supported Kite workflows run inside a dev container that uses the bundled `base` container or another container that preserves the same contract.

## Bootstrap An Existing Repository

Use the host only to copy the workspace assets into the repository. This step requires `curl` and `tar`:

```bash
curl -fsSL https://raw.githubusercontent.com/Karnonson/kite/main/install.sh | bash -s -- .
```

Reopen the repository in the container, then finish bootstrap there:

```bash
kite doctor .
kite install speckit .
kite status .
```

If you also want host-side Speckit bootstrap, add `--with-speckit`; that additionally requires `uvx` or `specify`.

## Extend The Base Container Safely

Keep the bundled `.devcontainer/devcontainer.json` on the `base` target and layer repo-specific packages, devcontainer features, and settings on top. Preserve the post-create step that installs `kite`, and keep the workspace `.github/` customizations versioned with the repo.

If the repository already owns its own `.devcontainer/`, follow the same contract instead of replacing the folder unless you explicitly want the bundled base container.

When the installer preserves an existing `.devcontainer/`, it also refreshes `.devcontainer/bin/kite`, `.devcontainer/kite-post-create.sh`, and `.devcontainer/README.kite.md`. After reopening in that container, run `bash .devcontainer/kite-post-create.sh` once if `kite` is not yet on `PATH`.

After rebuilding the container, validate the workspace:

```bash
kite doctor .
kite update workspace --dry-run .
```

## Refresh From A Local kite Checkout

Compare a target repository against a local clone of this repository:

```bash
kite doctor --source-dir /path/to/kite .
kite update workspace --source-dir /path/to/kite --dry-run .
kite update workspace --source-dir /path/to/kite --merge .
```

This is the safest path when you are iterating on kite itself and want to test the current checkout instead of downloading from GitHub.

## Run Pre-Merge Verification

Use the feature status screen, then run the guards that block merge-readiness:

```bash
kite feature .
kite test --profile full .
kite audit .
kite verify feature .
```

`kite verify feature` checks branch cleanliness, merge conflicts, and active Speckit task completion. The extra `test` and `audit` steps are useful when you want the same verification profile that `kite release prepare` uses.

## Prepare And Publish A Release

Run release preparation on the feature branch:

```bash
kite release prepare --bump minor .
```

After the feature branch merges to the default branch, publish the release:

```bash
kite release publish --bump minor --confirm .
```

Omit `--confirm` or add `--dry-run` when you want a preview instead of writing version, changelog, commit, and tag changes.

## Explain The Lifecycle To The Team

Use `kite explain` when you need a plain-language explanation of a step in the default lifecycle:

```bash
kite explain constitution
kite explain plan
```

The default progression is `feature start -> discover -> constitution -> specify -> design -> plan -> tasks -> analyze -> implement -> test -> review`. Legacy repositories may still contain a `brief.md` artifact on disk, but it is not part of the recommended default flow.

This is useful for onboarding or for non-technical collaborators who need the intent of a stage without opening the underlying prompt or workflow files.
