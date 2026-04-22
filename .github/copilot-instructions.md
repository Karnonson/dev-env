# Project Workflow Conventions

## Speckit Awareness

- Treat Speckit as installed when the repo contains `.specify/` and Speckit agents or prompts under `.github/agents/` or `.github/prompts/`.
- When Speckit is installed, treat `specs/<feature>/discovery.md`, `brief.md`, `spec.md`, `plan.md`, and `tasks.md` as the canonical feature artifacts when they exist.
- Do not create alternate feature specs, plans, or task lists under `team/` when canonical Speckit artifacts already exist.

## Agent Workflow

- Prefer the user-level `Orchestrator` agent for end-to-end feature coordination so stage transitions stay consistent.
- The full SDD cycle is: **Strategist → speckit.discover → speckit.brief → speckit.constitution → speckit.specify → Designer / speckit.design → speckit.plan → speckit.tasks → speckit.analyze → Backend Dev / UI Builder → speckit.test → Code Reviewer → kite verify feature**.
- Use Strategist to explore and pressure-test ideas first. After approval, route through `speckit.discover` and `speckit.brief`, then `speckit.constitution` to lock project standards before specification.
- Designer runs **after** `speckit.specify` to create design direction and brand identity. Designer writes to `.specify/memory/design-direction.md`. UI Builder reads this during implementation.
- Backend Dev and UI Builder are the primary implementation agents.
- DevOps handles CI/CD, deployment, infrastructure, and production readiness.
- If Speckit is not installed yet and a durable idea note is useful before canonical discovery starts, store it under `team/agents/<agent-name>/YYYY-MM-DD-<feature-name>.md`.
- Once a feature direction is approved, start the canonical front-of-lifecycle sequence with `speckit.discover`, then `speckit.brief`, `speckit.constitution`, and `speckit.specify`.
- Let Speckit own specification, clarification, planning, tasks, and consistency analysis.
- Do implementation work on the active feature branch and keep `main` as the merge target only after verification and review are complete.
- After `speckit.tasks`, implementation agents must execute from the active `tasks.md` and reference relevant FR IDs, user stories, or task IDs from the matching Speckit artifact set.
- After `speckit.tasks`, prefer `speckit.analyze` before implementation.
- After implementation, run `speckit.test` to verify all tests pass.
- After tests pass, prefer `Code Reviewer` before final verification or merge.

## Document Ownership

- `specs/<feature>/` is the source of truth for feature requirements, scope, technical plan, tasks, and feature-specific supporting artifacts produced by Speckit.
- `.specify/memory/design-direction.md` is the canonical design system and brand identity reference for UI implementation.
- `team/agents/<agent-name>/` is for agent-specific research, option analysis, design notes, handoff briefs, and implementation notes that support the work but are not the canonical feature contract.
- `docs/` is for durable repo-wide documentation that applies across multiple features.
- If a decision recorded in `team/agents/` becomes normative for delivery, promote it into the active Speckit artifact or a repo-wide doc instead of leaving it only in team notes.

## Efficiency Rules

- Prefer updating the current feature's existing Speckit files instead of duplicating summaries in multiple places.
- Team documents should summarize decisions, rationale, open questions, and implementation notes; they should not restate full requirements already captured in `spec.md`.
- If Speckit is not installed in a repo, fall back to `team/agents/<agent-name>/` for briefs, plans, and handoff notes until a canonical workflow is established.
