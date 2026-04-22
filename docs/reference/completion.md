# `kite completion`

Emit the Bash completion script for `kite`.

## Usage

```bash
kite completion
kite completion bash
```

## Supported Shells

- `bash`

Other shell names fail with an unsupported-shell error.

## Examples

Load completion into the current shell session:

```bash
source <(kite completion bash)
```

Print the completion script explicitly:

```bash
kite completion bash
```

## Notes

The dev container installs Bash completion automatically during post-create, so manual wiring is mainly useful for ad hoc shells.
