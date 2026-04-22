# `kite new`

Scaffold a new project with kite assets.

## Usage

```bash
kite new [options] <project-name>
```

## Options

- `--template TYPE`: Dev container profile to scaffold. Supported values are `base`, `python`, `typescript`, and `fullstack`.
- `--license ID`: License choice to record in `.kite/config.yml`.
- `--deploy-target T`: Deploy target to record in `.kite/config.yml`.
- `--test-tier T`: Default test profile or tier to record in `.kite/config.yml`.
- `--with-speckit`: Also bootstrap the bundled Spec Kit setup.
- `--speckit-version V`: Pin the Spec Kit CLI version.
- `--git-init-commit`: Create an initial Git commit after scaffolding.
- `--repo OWNER/REPO`: Download kite assets from a different repository.
- `--ref REF`: Download kite assets from a different ref.
- `--source-dir PATH`: Use a local kite checkout.
- `-h`, `--help`: Show the command help text.

## Behavior

- In interactive terminals, missing choice flags open guided pickers.
- Selected choices are written to `.kite/config.yml` for later review.

## Examples

```bash
kite new my-app
kite new my-app --template fullstack --license Apache-2.0 --deploy-target flyio --with-speckit
kite new my-app --git-init-commit
```

## Outputs

The scaffold creates the project directory, installs the workspace assets, and optionally bootstraps Speckit and the initial Git commit.
