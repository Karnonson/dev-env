# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- DevOps agent for CI/CD, deployment, and infrastructure work
- bundled `speckit.specify` command prompt for canonical feature specifications
- bundled `.specify/templates/spec.md` specification template and expanded `.specify/templates/plan.md` plan template
- `speckit.test` command for running project test suites after implementation
- `kite test`, `kite audit`, and `kite release` commands
- `.kite/config.yml` defaults for scaffold choices
- `docs/errors/*` recovery pages for `kite verify feature`
- Strategist-led SDD workflow with explicit gate at pipeline entry
- `shellcheck` and `yamllint` pre-installed in devcontainer
- `.github/copilot-instructions.md` for repo-level workflow alignment
- Full Orchestrator handoff buttons for every SDD stage

### Removed

- `kite new` host-side scaffolding command

### Changed

- Workflow reordered: Strategist → Discovery → Constitution → Specify → Designer → Plan → Tasks → Analyze → Implement → Test → Review → Verify
- Workflow gates now include rubric-style checklists in `orchestrator-design-first.yml`
- Designer now runs after specification (not before)
- Design direction written to `.specify/memory/design-direction.md`
- Orchestrator agents list includes all speckit commands
- `kite install speckit` and `--with-speckit` now ship the bundled specification and planning templates as part of the ready state
- `kite test` now resolves `smoke`/`standard`/`full` profiles into tiered verification (`unit`, `integration`, `e2e`, `a11y`, `perf`, `security`) and discovers package-manager workspaces plus common monorepo app folders
- `kite release` now uses `prepare` and `publish` steps with feature-branch gating, publish-time dry runs, and release-note previews sourced from merged PR titles plus `[Unreleased]`
- installer seeds `.kite/config.yml` without overwriting existing repo-local choices

### Fixed

- `install.sh` bare arithmetic bug (`$force_speckit_init -ne 1`)
- `install.sh` rm -rf safety (SC2115)
- `parse_help_target` shellcheck SC2195 warnings
- installer merge behavior for existing `.github/copilot-instructions.md`
- `kite doctor` and `kite status` now treat missing `speckit.test.md` as an incomplete bootstrap
- invalid top-level property in `.devcontainer/devcontainer.json`
