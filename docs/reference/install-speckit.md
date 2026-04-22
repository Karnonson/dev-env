# `kite install speckit`

Bootstrap the bundled Spec Kit preset and workflow into a target repository without reinstalling the workspace asset folders.

## Usage

```bash
kite install speckit [options] [target-directory]
```

## Options

- `--force-speckit-init`: Reinitialize Spec Kit when `.specify/` already exists.
- `--speckit-version V`: Pin the Spec Kit CLI version used for bootstrap.
- `--repo OWNER/REPO`: Download kite assets from a different GitHub repository.
- `--ref REF`: Download kite assets from a different Git ref.
- `--source-dir PATH`: Use a local kite checkout instead of downloading.
- `-h`, `--help`: Show the command help text.

## Examples

```bash
kite install speckit .
kite install speckit --force-speckit-init .
kite install speckit --source-dir /path/to/kite .
```

## When To Use It

Use this command inside the dev container after the workspace assets are already present. That is the normal path after a host bootstrap, and it is also the verification step after you extend an existing `.devcontainer/` without replacing it.

Host-side `--with-speckit` remains available as a secondary shortcut and requires `curl`, `tar`, and `uvx` or `specify` on the host.
