# `kite audit`

Run dependency audits and basic security checks.

## Usage

```bash
kite audit [options] [target-directory]
```

## Options

- `--fix`: Attempt to auto-fix audit findings.
- `-h`, `--help`: Show the command help text.

## Checks

- Committed `.env` files with potential secrets
- Python dependency vulnerabilities through `pip-audit`
- JavaScript dependency vulnerabilities through `npm audit` or `pnpm audit`

## Monorepo Support

`kite audit` automatically discovers subprojects and audits each one.

## Examples

```bash
kite audit .
kite audit --fix .
```

## Notes

Use this command directly when you want security checks without the rest of the release flow.
