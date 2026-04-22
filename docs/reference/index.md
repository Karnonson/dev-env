# CLI Reference

These pages document the current `kite` command surface from the help text implemented in `.devcontainer/bin/kite`.

The supported product story is container-first: run `kite` inside a repository opened in the bundled `base` devcontainer or in an existing container that preserves the same `kite`, post-create, and workspace-asset contract. Where the live help text still exposes compatibility items, these docs call out the recommended defaults.

## Command Basics

- Most commands accept an optional `[target-directory]`. When omitted, kite uses the current working directory.
- Source-aware commands accept `--repo`, `--ref`, or `--source-dir` so you can compare against a different GitHub repository, ref, or local checkout.
- `kite help <command>` prints the local help output for a command without leaving the terminal.

## Workspace Commands

- [kite install speckit](install-speckit.md)
- [kite update workspace](update-workspace.md)
- [kite doctor](doctor.md)
- [kite status](status.md)

## Project Commands

- [kite test](test.md)
- [kite audit](audit.md)
- [kite release](release.md)
- [kite verify feature](verify-feature.md)

## Feature Commands

- [kite feature](feature.md)
- [kite explain](explain.md)

The recommended lifecycle is `feature start -> discover -> constitution -> specify -> design -> plan -> tasks -> analyze -> implement -> test -> review`. `brief` remains legacy artifact language rather than a recommended default stage.

## Shell Integration And Help

- [kite completion](completion.md)
- [kite help](help.md)
