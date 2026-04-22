# `kite doctor`

Verify whether a target repository is ready for the container-native kite workflow.

## Usage

```bash
kite doctor [options] [target-directory]
```

## Checks

- `uv` availability
- `uvx` or `specify` availability
- Required workspace asset folders
- Whether workspace assets match the selected source
- Whether the bundled Spec Kit preset and workflow are installed

## Options

- `--speckit-version V`: Include a pinned Spec Kit version in suggested fix commands.
- `--repo OWNER/REPO`: Compare against a different GitHub repository.
- `--ref REF`: Compare against a different Git ref.
- `--source-dir PATH`: Compare against a local kite checkout instead of downloading.
- `-h`, `--help`: Show the command help text.

## Examples

```bash
kite doctor .
kite doctor --source-dir /path/to/kite .
```

## Notes

Use this command first when a repository is missing commands, reports outdated assets, or needs exact recovery instructions for bootstrapping.
