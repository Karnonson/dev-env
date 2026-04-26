# `kite feature`

Show a one-screen status view for the active Speckit feature.

## Usage

```bash
kite feature [target-directory] [--json]
```

## Output

- Feature name, branch, current stage, and next lifecycle stage
- Checklist of canonical artifacts, marked done, pending, or skipped
- Last three artifacts changed by modification time
- A single recommended next action

The active feature is detected from `.specify/feature.json`, the current Git branch, or a sole directory under `specs/`.

## Lifecycle Notes

The default lifecycle shown in the recommendation line is `feature setup (branch/context alignment) -> discover -> constitution -> specify -> design when needed -> plan -> tasks -> analyze -> implement -> test -> review -> verify -> release`.

For backend-only or CLI features, create `.specify/memory/design-skipped.md` when you want to skip design explicitly before planning. If `plan.md` or a later artifact already exists, `kite feature` infers that design was intentionally skipped and stops blocking on it.

`kite feature` surfaces `implement` and `verify` as the next lifecycle stage even though those steps do not have durable artifact files of their own.

Legacy repositories may still keep a `brief.md` artifact on disk, but `kite feature` does not treat it as part of the recommended path between discovery and specification.

## Options

- `--json`: Emit machine-readable JSON for tooling.

## Examples

```bash
kite feature
kite feature --json
```

## Notes

Use this command when you need a fast handoff view before opening the deeper spec, plan, or task files.
