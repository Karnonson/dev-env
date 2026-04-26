# `kite test`

Detect the project stack, resolve the configured verification profile, and run the matching test tiers.

## Usage

```bash
kite test [options] [target-directory]
```

## Options

- `--tier T`: Run a specific tier. Supported values are `unit`, `integration`, `e2e`, `a11y`, `perf`, `security`, and `all`. Repeat the flag to combine tiers.
- `--profile P`: Expand a saved verification profile. Supported values are `smoke`, `standard`, and `full`.
- `--e2e`: Backward-compatible alias for `--tier e2e`.
- `-h`, `--help`: Show the command help text.

## Monorepo Support

`kite test` automatically discovers root projects, common app folders, package-manager workspaces, and `packages/*`-style subprojects.

## Examples

```bash
kite test .
kite test --tier integration .
kite test --profile full .
kite test --e2e .
```

## Notes

The default profile comes from `.kite/config.yml` when present. Edit that file directly when you want to change the preferred verification profile for future test runs.

For Python projects, the `unit` tier targets `tests/` or `test/` and automatically excludes `tests/integration/`, `integration/`, or `test/integration/` when those folders exist. Kite prints the exact pytest target path for both the unit and integration tiers.
