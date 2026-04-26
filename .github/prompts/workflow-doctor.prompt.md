---
name: workflow-doctor
description: "Audit the current workspace for Speckit, Orchestrator alignment, minimum Kite container contract readiness, stale workflow-agent references, and implementation-readiness for Backend Dev and UI Builder."
agent: agent
tools: [read, edit, search, execute, todo]
argument-hint: "Optional notes: scope=greenfield|brownfield, include-fixes=false"
---

# Workflow Doctor

Inspect the current workspace and report whether the AI development workflow is correctly wired for this setup.

## Goal

Diagnose workflow drift and readiness for this operating model:

- Speckit owns canonical feature artifacts.
- `Orchestrator` is the global workflow coordinator.
- `Strategist` is optional pre-workflow support for ambiguous ideas; the formal Speckit pipeline begins at feature setup (branch/context alignment) and `speckit.discover`.
- `Designer` runs after `speckit.specify` to create design direction and brand identity.
- `speckit.plan` runs after design and before `speckit.tasks`.
- `Backend Dev` and `UI Builder` are the primary implementation agents.
- `DevOps` handles CI/CD, deployment, and infrastructure concerns.
- Existing repos may keep their own `.devcontainer/` if that container satisfies the minimum Kite container contract.

## What To Check

1. Workspace structure and container contract

- Does `.specify/` exist?
- Do Speckit commands exist under `.github/agents/` or `.github/prompts/`?
- Does `specify version` run successfully?
- Is the `orchestrator-workflow` preset installed when the local preset directory is available?
- If `.devcontainer/` already exists, is it being preserved as an additive adoption path rather than treated as a blocker?
- Does the current container satisfy the minimum Kite container contract:
  - `kite` is available on `PATH`
  - required post-create setup or equivalent tooling is present
  - workspace-level `.github/` customizations are installed
  - `specify version`, `kite doctor .`, and either `kite install speckit .` or the bundled `./install.sh --with-speckit --source-dir <workspace-root> .` path can succeed from inside the container

2. Repo workflow rules

- Does `.github/copilot-instructions.md` exist?
- Does it mention Speckit artifact ownership?
- Does it point to `Orchestrator` rather than `Feature Workflow`?
- Does it state that `Backend Dev` and `UI Builder` are the primary implementation agents?
- For frontend, UX-heavy, or visual-system work, does it place `Designer` as the required post-specification design stage before planning?
- Does it include `speckit.plan` between design and tasks?
- Does it avoid requiring `brief.md` as part of the default lifecycle?
- Does it enforce a single feature slug across `feature/<slug>`, `specs/<slug>/`, and `.specify/feature.json`?

3. Stale or conflicting workflow setup

- Are there any remaining references to `Feature Workflow` in the workspace?
- Does a repo-local `.github/agents/feature-workflow.agent.md` still exist?
- Are there conflicting workflow instructions that could compete with `Orchestrator`?

4. Implementation readiness

- Can a feature move cleanly through this path?
  feature setup (branch/context alignment) -> `speckit.discover` -> `speckit.constitution` -> `speckit.specify` -> `Designer` (for frontend or UX-heavy work) -> `speckit.plan` -> `speckit.tasks` -> `speckit.analyze` -> `Backend Dev` / `UI Builder` -> `speckit.test` -> `Code Reviewer` -> `kite verify feature`
- Identify any missing step, missing file, or contradictory rule that breaks this path.
- If the repo keeps an existing `.devcontainer/`, identify the exact missing contract check instead of recommending blanket replacement.

## Execution Rules

- Default to read-only diagnosis.
- Do not edit files unless I explicitly pass `include-fixes=true`.
- If `include-fixes=true`, only apply safe, minimal fixes for naming drift and stale references. Do not install packages or restructure the repo.
- Prefer exact file references and concrete findings over generic advice.

## Output Format

Return these sections:

### Status

- Overall verdict: Healthy | Mostly healthy | Drift detected | Broken
- One-sentence summary of the biggest issue

### Findings

- List concrete findings with file references
- Prioritize workflow-breaking issues first

### Container Contract

- State whether the current container is good enough for the supported Kite workflow
- List the exact passed and failed contract checks
- Include the cheapest validation commands needed to confirm readiness

### Workflow Fit

- State whether the repo matches this target model:
  - `Orchestrator` coordinates
  - `Strategist` is optional idea-shaping support before the formal flow starts at discovery
  - `Designer` runs after `speckit.specify` for frontend or UX-heavy work, uses the user's color preferences, and writes to `.specify/memory/design-direction.md`
  - `speckit.plan` runs before `speckit.tasks`
  - Only `Backend Dev` and `UI Builder` implement repository changes
  - `DevOps` manages CI/CD and deployment
  - `speckit.test` runs after implementation as a test gate
  - `speckit.analyze` runs before implementation as the artifact consistency gate
  - `Code Reviewer` runs after testing before final verification
  - Existing repos can keep their own `.devcontainer/` when the minimum Kite container contract is satisfied

### Recommended Fixes

- Provide the smallest set of changes needed to reach the target model
- When container contract checks fail, recommend additive fixes and validation commands before suggesting container replacement

### Suggested Next Command

- Recommend the next most useful command or agent, such as:
  - `/bootstrap-speckit`
  - `Orchestrator`
  - `/speckit.constitution`
  - `/speckit.specify`
  - `/speckit.tasks`
  - `Backend Dev`
  - `UI Builder`
  - `Designer`
