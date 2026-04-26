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

Python audits ignore common toolchain packages (`pip`, `setuptools`, and `wheel`) by default so environment-managed CVEs do not block release gates. Extend that list in `.kite/config.yml` under `audit.python.ignore_packages` when your workspace needs extra exclusions.
