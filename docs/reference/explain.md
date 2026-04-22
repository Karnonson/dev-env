# `kite explain`

Show a plain-language description of a lifecycle stage.

## Usage

```bash
kite explain <stage>
```

## Stage Output

Each stage explains what happens, who runs it, which artifact it produces, and what to do next.

## Default Lifecycle Stages

- `discover`
- `constitution`
- `specify`
- `design`
- `plan`
- `tasks`
- `analyze`
- `implement`
- `test`
- `review`

## Additional Operational Stages

- `verify`
- `release`
- `operate`
- `learn`

## Examples

```bash
kite explain constitution
kite explain plan
```

## Notes

Use this command when you want a plain-language explanation of the current step without opening the underlying workflow files. It is especially useful for onboarding, handoffs, and non-technical collaborators.

The default path moves from `discover` straight into `constitution` and `specify`. Legacy repositories may still keep a `brief.md` artifact on disk, but `kite explain` does not treat `brief` as a supported stage.
