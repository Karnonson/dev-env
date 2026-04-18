---
name: workflow-doctor
description: "Audit the current workspace for Speckit, Orchestrator alignment, stale workflow-agent references, and implementation-readiness for Backend Dev and UI Builder."
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
- `Backend Dev` and `UI Builder` are the primary implementation agents.
- `Designer` is optional and used before `speckit.specify` when design direction or UX decisions are unresolved.

## What To Check

1. Workspace structure

- Does `.specify/` exist?
- Do Speckit commands exist under `.github/agents/` or `.github/prompts/`?
- Does `specify version` run successfully?
- Is the `orchestrator-workflow` preset installed when the local preset directory is available?

2. Repo workflow rules

- Does `.github/copilot-instructions.md` exist?
- Does it mention Speckit artifact ownership?
- Does it point to `Orchestrator` rather than `Feature Workflow`?
- Does it state that `Backend Dev` and `UI Builder` are the primary implementation agents?
- Does it place `Designer` as an optional pre-specification design stage?

3. Stale or conflicting workflow setup

- Are there any remaining references to `Feature Workflow` in the workspace?
- Does a repo-local `.github/agents/feature-workflow.agent.md` still exist?
- Are there conflicting workflow instructions that could compete with `Orchestrator`?

4. Implementation readiness

- Can a feature move cleanly through this path?
  `Strategist` -> optional `Marketer` -> optional `Designer` -> `speckit.specify` -> `speckit.plan` -> `speckit.tasks` -> `speckit.analyze` -> `Backend Dev` / `UI Builder` -> `Code Reviewer` -> tests
- Identify any missing step, missing file, or contradictory rule that breaks this path.

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

### Workflow Fit

- State whether the repo matches this target model:
  - `Orchestrator` coordinates
  - `Backend Dev` and `UI Builder` implement
  - `Designer` is optional and upstream of `speckit.specify` when design decisions are unresolved
  - `speckit.analyze` runs before implementation as the artifact consistency gate
  - `Code Reviewer` runs after implementation before final verification

### Recommended Fixes

- Provide the smallest set of changes needed to reach the target model

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
