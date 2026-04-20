# Contributing

## Getting Started

1. Fork and clone this repository.
2. Open in VS Code and reopen in the dev container.
3. All tools (`shellcheck`, `yamllint`, `jq`, `uv`, etc.) are available inside the container.

## Making Changes

- Create a feature branch from `main`.
- Follow the SDD workflow: Strategist → Constitution → Specify → Design → Plan → Tasks → Analyze → Implement → Test → Review → Verify.
- Run `kite doctor` to verify setup health.
- Run `bash scripts/validate-speckit.sh` before submitting.

## Shell Scripts

- Run `shellcheck .devcontainer/bin/kite install.sh` before committing changes to bash files.
- The CI pipeline runs shellcheck automatically.

## Commit Conventions

- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation-only changes
- `refactor:` for non-functional code changes
- `ci:` for CI/CD changes

## PR Expectations

- Update `CHANGELOG.md` under `[Unreleased]`.
- Update `README.md` if the change affects user-facing commands or workflow.
- For agent or prompt changes, update `copilot-instructions.md` if workflow rules change.
- Request a review from a docs-aware reviewer when touching public surface.
