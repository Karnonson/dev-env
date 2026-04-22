# `kite explain`

Show a plain-language description of a Speckit workflow stage.

## Usage

```bash
kite explain <stage>
```

## Stage Output

Each stage explains what happens, who runs it, which artifact it produces, and what to do next.

## Supported Stages

- `discover`
- `brief`
- `constitution`
- `specify`
- `design`
- `plan`
- `tasks`
- `analyze`
- `implement`
- `test`
- `review`
- `verify`
- `release`
- `operate`
- `learn`

## Examples

```bash
kite explain specify
kite explain plan
```

## Notes

This command is designed for non-technical users and junior engineers who need a lifecycle explanation without reading the underlying workflow files.
