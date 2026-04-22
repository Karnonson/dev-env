# `kite status`

Show whether the workspace assets are current and whether the bundled Spec Kit setup is bootstrapped.

## Usage

```bash
kite status [options] [target-directory]
```

## Options

- `--json`: Emit machine-readable JSON output.
- `--repo OWNER/REPO`: Compare against a different GitHub repository.
- `--ref REF`: Compare against a different Git ref.
- `--source-dir PATH`: Compare against a local kite checkout instead of downloading.
- `-h`, `--help`: Show the command help text.

## Examples

```bash
kite status .
kite status --json .
kite status --source-dir /path/to/kite .
```

## Notes

Use JSON output for scripts or CI jobs that need to gate on asset freshness or Speckit bootstrap state.
