# `kite release`

Prepare a release on a feature branch, then publish it from the default branch.

## Usage

```bash
kite release prepare [options] [target-directory]
kite release publish [options] [target-directory]
kite release [options] [target-directory]
```

Without a subcommand, `kite release` is a legacy alias for `kite release publish`.

## Prepare Options

- `--bump TYPE`: Version bump type. Supported values are `major`, `minor`, and `patch`.
- `--skip-checks`: Skip `kite verify feature`, `kite test`, and `kite audit`.
- `--dry-run`: Preview only. This is the default behavior for `prepare`.

## Publish Options

- `--bump TYPE`: Version bump type. Supported values are `major`, `minor`, and `patch`.
- `--confirm`: Actually write version, changelog, commit, and tag changes.
- `--skip-checks`: Skip publish-time test and audit gates.
- `--dry-run`: Preview changes without writing. This is the default when `--confirm` is omitted.
- `-h`, `--help`: Show the command help text.

## Safety Model

- `prepare` runs merge-readiness plus test and audit on the feature branch.
- `publish` runs test and audit again on the default branch before mutating files or Git state.
- Release notes combine merged PR titles, when available, with the `[Unreleased]` section from `CHANGELOG.md`.

## Examples

```bash
kite release prepare .
kite release prepare --bump minor .
kite release publish --bump minor --confirm .
kite release publish --bump major --confirm --skip-checks .
```

## Recommended Flow

Run `prepare` on the feature branch, merge the branch, switch to the default branch, then run the publish step with `--confirm` enabled.
