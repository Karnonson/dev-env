# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- DevOps agent for CI/CD, deployment, and infrastructure work
- `speckit.test` command for running project test suites after implementation
- `kite test`, `kite audit`, `kite new`, `kite release` commands
- Strategist-led SDD workflow with explicit gate at pipeline entry
- `shellcheck` and `yamllint` pre-installed in devcontainer
- `.github/copilot-instructions.md` for repo-level workflow alignment
- Full Orchestrator handoff buttons for every SDD stage

### Changed

- Workflow reordered: Strategist → Constitution → Specify → Designer → Plan → Tasks → Analyze → Implement → Test → Review → Verify
- Designer now runs after specification (not before)
- Design direction written to `.specify/memory/design-direction.md`
- Orchestrator agents list includes all speckit commands

### Fixed

- `install.sh` bare arithmetic bug (`$force_speckit_init -ne 1`)
- `install.sh` rm -rf safety (SC2115)
- `parse_help_target` shellcheck SC2195 warnings
- installer merge behavior for existing `.github/copilot-instructions.md`
- `kite new` option parsing for `--source-dir`, `--repo`, `--ref`, and `--speckit-version`
- `kite doctor` and `kite status` now treat missing `speckit.test.md` as an incomplete bootstrap
- invalid top-level property in `.devcontainer/devcontainer.json`
