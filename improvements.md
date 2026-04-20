# CLI Improvements Report

Validated against the current CLI surface in `.devcontainer/bin/kite`, `install.sh`, and `README.md` on 2026-04-19.

## What is already working well

- The CLI now covers more of the software lifecycle than before: `install`, `update`, `doctor`, `status`, `verify feature`, `test`, `audit`, `new`, and `release`.
- The branch-first workflow is explicit in both the CLI help and the Speckit workflow assets.
- Speckit bootstrap is staged in a temporary directory before syncing into the target repo, which is safer than mutating `.specify/` in place.
- `--source-dir` provides a reproducible local path for development and testing without forcing remote downloads.

## Highest-priority weaknesses

### 1. Reproducibility still depends on live remote state

The CLI still defaults to `Karnonson/dev-env@main`, and several commands execute remote code directly with `curl | bash` or compare against a freshly downloaded archive. This affects `kite install speckit`, `kite update workspace`, `kite new`, `kite doctor`, and `kite status`.

Why this matters:

- behavior changes when upstream `main` changes
- CI and onboarding flows depend on network availability
- teams cannot reliably say which dev-env version a target repo is using
- `curl | bash` is still the highest-risk supply-chain path in the tool

Improvement:

- treat `--source-dir` or a pinned local version manifest as the preferred path for updates inside an already-bootstrapped repo
- store the installed dev-env version or commit SHA in the target repo
- make remote self-update explicit instead of the default control path

Actionable fixes:

- add a `.dev-env-version` or `.kite/state.json` file to target repos
- make `kite update workspace` use the installed version by default and require `--remote` for network refresh
- replace `curl | bash` with archive download plus checksum validation when remote execution is unavoidable

### 2. Installer and health-check asset tracking have drifted apart

`install.sh` now treats `.github/copilot-instructions.md` as an installed asset, but `kite` still tracks only `.devcontainer`, `.github/prompts`, `.github/agents`, and `.github/instructions` in its `assets` array.

Why this matters:

- `kite status` and `kite doctor` cannot fully describe the real installed state
- teams can believe a workspace is current when one of the shipped repo-level rules is outdated or missing

Improvement:

- define a single shared asset manifest and have both installer and CLI read from it

Actionable fixes:

- move the asset list into one manifest file and consume it from both `install.sh` and `kite`
- extend `status` and `doctor` to include file assets, not just directories

### 3. Workspace refresh and Speckit refresh use conflicting semantics

`kite update workspace` is presented as a refresh command, but it force-replaces workspace assets. At the same time, Speckit refresh remains merge-missing by default unless `--force-speckit-init` is used.

Why this matters:

- local repo customizations under copied workspace assets can be wiped unexpectedly
- generated Speckit assets can stay stale for a long time because updates only fill gaps instead of replacing outdated generated files
- the word `refresh` currently means two different things depending on which asset class is being updated

Improvement:

- separate update modes clearly: `check`, `merge-missing`, `replace-generated`, and `replace-all`

Actionable fixes:

- add explicit flags such as `--merge`, `--replace-generated`, and `--replace-all`
- show a diff-style preview in dry-run output so users can see destructive changes before applying them
- treat generated Speckit files as replaceable by manifest rather than merge-missing forever

### 4. `kite verify feature` does not resolve the active feature canonically

The verification path still infers `tasks.md` from the current branch name under `specs/`, while the implementation workflow treats `.specify/feature.json` as canonical.

Why this matters:

- merge readiness can be reported without checking the actual active feature backlog
- branch naming conventions become part of correctness even though the workflow already has a canonical active-feature source

Improvement:

- resolve the active feature from `.specify/feature.json` first, then fall back to branch heuristics only when that file is absent

Actionable fixes:

- add `get_active_feature_dir()` to `kite` and reuse it across `verify`, `test`, `audit`, and future feature-aware commands
- keep the branch-based fallback only for non-Speckit repos
- switch merge-conflict collection to null-delimited parsing for shell robustness

### 5. `kite test` and `kite audit` are still root-only and monorepo-naive

The stack detection and execution logic only look for Python and Node markers in the target root. In a realistic fullstack repo with `frontend/` and `backend/` subprojects, the CLI will miss or mis-run checks.

There is also a doc/code mismatch: the help text says Python audit runs `pip audit` and `bandit`, but the current implementation only runs `pip-audit` and never invokes `bandit`.

Why this matters:

- fullstack repos are common, and this CLI is explicitly aimed at fullstack use
- root-only detection makes test and audit pass/fail behavior unreliable
- help text over-promises security coverage that the code does not actually provide

Improvement:

- make test and audit project-aware rather than root-aware
- treat Python and Node subprojects as separate units when both exist

Actionable fixes:

- search for `pyproject.toml`, `package.json`, `pnpm-lock.yaml`, and `playwright.config.*` below the root and run checks per discovered project
- allow project config to declare named workspaces and preferred commands
- either implement `bandit` or remove it from help text until it exists
- replace the `node -e` package-script probe with a more direct and less brittle parser

### 6. `kite new` is too opinionated for a reusable engineering template

`kite new` creates a repo, writes a minimal README, installs assets, optionally adds CI, and then auto-commits with a synthetic `kite` identity.

Why this matters:

- automatic commits are surprising and hard to undo cleanly in scripted environments
- the generated CI assumes root-level `uv`, `ruff`, `pnpm`, `lint`, `test`, and `build` commands without inspecting the actual scaffolded repo
- the scaffolder is trying to act like a project generator, but it has no project contract or config input beyond a coarse template name

Improvement:

- keep scaffolding minimal by default and move opinionated setup behind explicit opt-in flags or templates

Actionable fixes:

- remove the automatic initial commit or gate it behind `--git-init-commit`
- split CI templates into repo-probed variants or template-owned files instead of inline heredocs
- add a post-scaffold checklist rather than pretending the generated project is fully production-ready

### 7. `kite release` is too light for production-grade release management

The current release flow bumps a version, edits `CHANGELOG.md` with a simple `sed`, creates a commit, and tags the repo. It does not run tests, build checks, or `kite verify feature` before mutating the repo.

Why this matters:

- a release command should be one of the safest commands in the tool, not one of the most state-mutating
- the current implementation assumes very simple `package.json`, `pyproject.toml`, and changelog formats
- there is no release confirmation step once mutation starts

Improvement:

- make release a gated pipeline, not just a version-edit helper

Actionable fixes:

- require a clean `kite test`, `kite audit`, and `kite verify feature` or `kite verify release` before bumping versions
- add `--confirm` for the mutating path and keep dry-run as the default behavior for first use
- support configurable changelog strategies instead of hardcoded `sed` replacement
- separate `prepare release` from `publish release`

### 8. The CLI needs repo-level configuration instead of hardcoded workflow assumptions

The help text and behavior encode one workflow directly into the shell script. That is useful for this repo, but the project is positioned as a reusable dev environment for future teams with different release, test, or stack layouts.

Why this matters:

- reusable tooling should adapt to a project contract rather than forcing all repos into one implicit layout
- `verify`, `test`, `audit`, `new`, and `release` all need repo-specific behavior if this is meant to scale beyond one house style

Improvement:

- introduce a repo-local config file such as `.kite/config.yml`

Actionable fixes:

- support configuration for workflow stages, default branch, project roots, verification commands, release rules, and CI expectations
- have `kite doctor` validate the config and show the effective resolved workflow

## Lower-level shell robustness issues

### `find` expression in Python test discovery should be grouped

The current Python test detection uses `find ... -name 'test_*.py' -o -name '*_test.py'` without grouping. It should use parentheses so `-maxdepth` and the search intent apply predictably.

### Null-delimited parsing should be preferred for git file lists

The current merge-conflict parsing uses newline-delimited output. It works for normal repos, but `-z` parsing is the safer shell pattern.

### JSON generation is still hand-rolled

The existing `json_escape` and `json_array` helpers are serviceable for simple output, but the CLI is now complex enough that a safer serialization path would reduce edge cases over time.

## Recommended implementation order

### Phase 1: Trust and correctness

1. Unify the installer and CLI asset manifest.
2. Make active-feature resolution canonical across `verify`, `test`, and `audit`.
3. Remove the doc/code mismatch in Python audit coverage.

### Phase 2: Safe lifecycle automation

1. Redesign update modes so destructive and non-destructive paths are explicit.
2. Make release require verification gates before mutating the repo.
3. Make `kite new` stop short of auto-committing unless explicitly requested.

### Phase 3: Scale to real repos

1. Add `.kite/config.yml`.
2. Make `test` and `audit` monorepo-aware.
3. Add installed-version tracking so remote drift stops being the default behavior.