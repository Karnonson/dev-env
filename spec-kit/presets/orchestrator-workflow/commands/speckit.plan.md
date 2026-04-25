---
description: Turn the approved specification and design direction into the canonical implementation plan for the active feature.
handoffs:
  - label: Generate Tasks
    agent: speckit.tasks
    prompt: Turn the approved implementation plan into a concrete task list for the active feature.
---

## User Input

```text
$ARGUMENTS
```

Use this command after `speckit.specify` and, for frontend or UX-heavy work, after `speckit.design` have produced the canonical feature artifacts.

## Plan-First Rule

Before asking questions or drafting `plan.md`, share a short todo checklist so the user can steer the planning pass.

## Clarification Rules

When clarification is needed, ask exactly one question at a time and wait for the user's answer before asking the next one. Do not send a batched implementation questionnaire unless the user explicitly asks for that format.

When the user names a technology, framework, or service in their response, treat that name as authoritative context. Do not redefine it, map it to a different category, or guess why it is present. If the role of a user-selected technology is unclear, ask one clarification question instead.

## Interaction Example

```text
User: Create the implementation plan for this feature.
Assistant: - [ ] Review the active spec and constraints
- [ ] Confirm whether a design pass is required before planning
- [ ] Capture the delivery phases, risks, and verification strategy

Is there a required rollout constraint, such as a feature flag or staged release?
User: Yes, ship it behind a feature flag.
Assistant: Are there any cross-team dependencies that affect sequencing?
```

## Outline

1. Read the active `specs/<feature>/spec.md`.
2. Read `.specify/memory/constitution.md` for project-level constraints and verification expectations.
3. When `.specify/memory/design-direction.md` exists, read it and treat its UI, accessibility, and responsive decisions as required planning inputs rather than optional notes.
4. For frontend, UX-heavy, or visually significant work, require `.specify/memory/design-direction.md` before finalizing the plan. If that artifact is missing, stop and route to `Designer` / `speckit.design` instead of guessing UI decisions. For non-UI work, continue without it when no design artifact exists.
5. Before writing, check `.specify/templates/plan.md` and the rest of `.specify/templates/` for a matching plan template and follow it when present.
6. When information is missing, ask exactly one clarifying question per turn to remove ambiguity around architecture, sequencing, dependencies, verification, delivery risk, rollout constraints, and the role of user-specified technologies.
7. Structure the plan so `speckit.tasks` can execute from it directly. Cover:
   - delivery phases and sequencing
   - architecture, contracts, and data-flow decisions that materially affect delivery
   - dependencies, prerequisites, and handoff boundaries
   - verification strategy derived from the constitution and feature risk
   - rollout, migration, and operational considerations when relevant
   - open risks, assumptions, and mitigations
8. When `.specify/memory/design-direction.md` exists, fold those design requirements into the affected plan sections instead of treating them as a parallel planning artifact.
9. Write the canonical implementation plan to `specs/<feature>/plan.md`.
10. Open `specs/<feature>/plan.md` with the artifact front matter block described in `.specify/templates/artifact-front-matter.md`. Set `stage: plan`, `last_agent: speckit.plan`, refresh `updated_at`, and preserve `created_at` if it already exists.
11. Keep the plan implementation-ready and decision-oriented. Do not create a second backlog or a default `team/agents` planning artifact.
12. End with a concise handoff summary for `speckit.tasks`.
