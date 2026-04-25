# Project Workflow Conventions

## Speckit Awareness

- Treat Speckit as installed when the repo contains `.specify/` and Speckit agents or prompts under `.github/agents/` or `.github/prompts/`.
- When Speckit is installed, treat `specs/<feature>/discovery.md`, `spec.md`, `plan.md`, and `tasks.md` as the canonical feature artifacts when they exist.
- Do not create alternate feature specs, plans, or task lists under `team/` when canonical Speckit artifacts already exist.
- Before writing a canonical artifact under `specs/<feature>/` or `.specify/memory/`, check `.specify/templates/` for the matching template and follow it when present.

## Agent Workflow

- Prefer the user-level `Orchestrator` agent for end-to-end feature coordination so stage transitions stay consistent.
- `Strategist` is optional pre-workflow discovery support for ambiguous ideas, market-risk checks, or early problem shaping. Once a feature is approved, the formal custom Speckit flow starts at `feature start -> speckit.discover`.
- The formal SDD cycle is: **feature start -> speckit.discover -> speckit.constitution -> speckit.specify -> Designer / speckit.design (required for frontend or UX-heavy work) -> speckit.plan -> speckit.tasks -> speckit.analyze -> Backend Dev / UI Builder -> speckit.test -> Code Reviewer -> kite verify feature**.
- Discovery must start on the active feature branch, with `.specify/feature.json` aligned to that same feature identifier, never on `main`.
- Designer runs **after** `speckit.specify` for frontend or UX-heavy work. Use the user's explicit color preferences for the palette, and base the rest of the design system on Material Design 3 principles unless the repo already defines a stronger system. Designer writes to `.specify/memory/design-direction.md`. UI Builder reads this during implementation.
- Only Backend Dev and UI Builder may propose or apply repository implementation changes. All other agents stay in discovery, research, design, planning, or review mode and hand implementation handoffs back to those specialists.
- DevOps handles CI/CD, deployment, infrastructure, and production readiness as analysis and handoff guidance unless Backend Dev or UI Builder is explicitly executing the resulting repo changes.
- If Speckit is not installed yet and a durable idea note is useful before canonical discovery starts, store it under `team/agents/<agent-name>/YYYY-MM-DD-<feature-name>.md`.
- Let Speckit own specification, clarification, planning, tasks, and consistency analysis.
- Do implementation work on the active feature branch and keep `main` as the merge target only after verification and review are complete.
- After `speckit.tasks`, implementation agents must execute from the active `tasks.md` and reference relevant FR IDs, user stories, or task IDs from the matching Speckit artifact set.
- After `speckit.tasks`, prefer `speckit.analyze` before implementation.
- After implementation, run `speckit.test` to verify all tests pass.
- After tests pass, prefer `Code Reviewer` before final verification or merge.
- Every agent should begin meaningful work by sharing a short todo checklist so the user can steer before the task proceeds.
- Never guess what a user-named technology means. Treat names like `Mastra` as explicit constraints, and ask one clarification question if the role of the technology is still unclear.

## Document Ownership

- `specs/<feature>/` is the source of truth for feature requirements, scope, technical plan, tasks, and feature-specific supporting artifacts produced by Speckit.
- `.specify/memory/design-direction.md` is the canonical design system and brand identity reference for UI implementation.
- `team/agents/<agent-name>/` is for agent-specific research, option analysis, design notes, handoff briefs, and implementation notes that support the work but are not the canonical feature contract.
- `docs/` is for durable repo-wide documentation that applies across multiple features.
- If a decision recorded in `team/agents/` becomes normative for delivery, promote it into the active Speckit artifact or a repo-wide doc instead of leaving it only in team notes.

## Efficiency Rules

- Prefer updating the current feature's existing Speckit files instead of duplicating summaries in multiple places.
- Team documents should summarize decisions, rationale, open questions, and implementation notes; they should not restate full requirements already captured in `spec.md`.
- If Speckit is not installed in a repo, fall back to `team/agents/<agent-name>/` for discovery notes, planning notes, and handoff material until a canonical workflow is established.
