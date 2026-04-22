# `kite update workspace`

Refresh the copied workspace assets and support docs in a target repository.

## Usage

```bash
kite update workspace [options] [target-directory]
```

## Update Modes

- Default behavior replaces workspace assets from the selected source and can overwrite local edits.
- `--merge` only adds missing files and preserves existing assets.

If `.kite/config.yml` is missing, kite seeds the source default. Existing `.kite/config.yml` files are preserved.

## Options

- `--merge`: Fill in missing files without overwriting existing assets.
- `--dry-run`: Preview what would change without writing files.
- `--with-speckit`: Refresh workspace assets and bootstrap the bundled Spec Kit setup.
- `--force-speckit-init`: Reinitialize Spec Kit when `.specify/` already exists.
- `--speckit-version V`: Pin the Spec Kit CLI version used for bootstrap.
- `--repo OWNER/REPO`: Download kite assets from a different GitHub repository.
- `--ref REF`: Download kite assets from a different Git ref.
- `--source-dir PATH`: Use a local kite checkout instead of downloading.
- `-h`, `--help`: Show the command help text.

## Examples

```bash
kite update workspace .
kite update workspace --merge .
kite update workspace --dry-run .
kite update workspace --with-speckit .
```

## Notes

Use `--dry-run` before destructive refreshes, especially when the target repository contains local changes under `.devcontainer/`, `.github/`, or `docs/errors/`.
