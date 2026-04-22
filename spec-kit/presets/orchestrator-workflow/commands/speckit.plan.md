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

Use this command after `speckit.specify` and, when applicable, `speckit.design` have produced the canonical feature artifacts.

## Clarification Rules

When clarification is needed, ask exactly one question at a time and wait for the user's answer before asking the next one. Do not send a batched implementation questionnaire unless the user explicitly asks for that format.

## Interaction Example

```text
User: Create the implementation plan for this feature.
Assistant: Is there a required rollout constraint, such as a feature flag or staged release?
User: Yes, ship it behind a feature flag.
Assistant: Are there any cross-team dependencies that affect sequencing?
```

## Outline

1. Read the active `specs/<feature>/spec.md`.
2. Read `.specify/memory/constitution.md` for project-level constraints and verification expectations.
3. Read `.specify/memory/design-direction.md` when it exists and treat its UI, accessibility, and responsive decisions as planning inputs rather than optional notes.
4. When information is missing, ask exactly one clarifying question per turn to remove ambiguity around architecture, sequencing, dependencies, verification, delivery risk, and rollout constraints.
5. Write the canonical implementation plan to `specs/<feature>/plan.md`.
6. Structure the plan so `speckit.tasks` can execute from it directly. Cover:
   - implementation phases and sequencing
   - architecture, contracts, and data-flow decisions that matter to delivery
   - dependencies, prerequisites, and handoff boundaries
   - verification strategy derived from the constitution and feature risk
   - rollout, migration, or operational considerations when relevant
   - open risks, assumptions, and mitigations
7. When `.specify/memory/design-direction.md` exists, fold the design requirements into the plan sections they affect instead of creating a second durable planning note.
8. Open `specs/<feature>/plan.md` with the artifact front matter block described in `spec-kit/templates/artifact-front-matter.md`. Set `stage: plan`, `last_agent: speckit.plan`, refresh `updated_at`, and preserve `created_at` if it already exists.
9. Keep the plan implementation-ready and decision-oriented. Do not create a second backlog or a default `team/agents` planning artifact.
10. End with a handoff-ready summary for `speckit.tasks`.
