# `kite verify feature`

Run the pre-merge checklist for the current feature branch.

## Usage

```bash
kite verify feature [target-directory]
```

## Checks

- Working tree clean
- Not on the default branch
- No merge conflicts in tracked files
- Active Speckit tasks file has all tasks marked done

## Recovery

On failure, kite prints why the check matters, concrete next commands, and the matching page under [../errors/index.md](../errors/index.md).

## Examples

```bash
kite verify feature .
```

## Notes

Use this command before opening final merge review or before running `kite release prepare`.
