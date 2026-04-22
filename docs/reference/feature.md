# `kite feature`

Show a one-screen status view for the active Speckit feature.

## Usage

```bash
kite feature [target-directory] [--json]
```

## Output

- Feature name, branch, and current lifecycle stage
- Checklist of canonical artifacts, marked done or pending
- Last three artifacts changed by modification time
- A single recommended next action

The active feature is detected from `.specify/feature.json`, the current Git branch, or a sole directory under `specs/`.

## Lifecycle Notes

The default lifecycle shown in the recommendation line is `feature start -> discover -> constitution -> specify -> design -> plan -> tasks -> analyze -> implement -> test -> review`.

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
