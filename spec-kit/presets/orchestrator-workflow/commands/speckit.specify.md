---
description: Turn the approved discovery and project standards into the canonical feature specification for the active feature.
handoffs:
  - label: Design System & Brand
    agent: speckit.design
    prompt: Create the design direction for the approved specification before planning starts.
  - label: Create Plan
    agent: speckit.plan
    prompt: Turn the approved specification and design direction into the canonical implementation plan.
---

## User Input

```text
$ARGUMENTS
```

Use this command after `speckit.discover` and `speckit.constitution` have established the active feature context. If no discovery artifact exists yet, treat the user input as the approved feature description only when it is specific enough to support a durable specification.

## Spec-First Rule

Before asking questions or drafting `spec.md`, share a short todo checklist so the user can steer the specification pass.

## Clarification Rules

When clarification is needed, ask exactly one question at a time and wait for the user's answer before asking the next one. Do not send a batched questionnaire unless the user explicitly asks for that format.

Use reasonable defaults for low-impact gaps. Surface at most 3 high-impact `[NEEDS CLARIFICATION: ...]` markers in the spec when a decision would materially change scope, user experience, privacy, or acceptance criteria.

## Interaction Example

```text
User: Turn the approved discovery into a Speckit specification.
Assistant: - [ ] Review discovery and constitution constraints
- [ ] Confirm the highest-risk ambiguity, if any
- [ ] Draft the canonical spec for design and planning

What access model should this feature assume for the first release?
```

## Outline

1. Read the active `specs/<feature>/discovery.md` when it exists and treat it as the primary source for problem statement, user context, assumptions, success metrics, and out-of-scope boundaries.
2. Read `.specify/memory/constitution.md` for project-level constraints, verification expectations, and quality bars that should shape the specification without leaking implementation details.
3. Confirm the active feature context stays aligned across the current branch, `.specify/feature.json`, and `specs/<feature>/`. Do not create a parallel feature directory or a second canonical spec for the same feature.
4. Before writing, check `.specify/templates/spec.md` and the rest of `.specify/templates/` for a matching specification template and follow it when present.
5. Write or update the canonical feature specification at `specs/<feature>/spec.md`.
6. Translate discovery into an implementation-ready but technology-agnostic spec that makes the following explicit:
   - problem statement and intended user value
   - prioritized user stories with independent acceptance scenarios
   - edge cases and out-of-scope boundaries
   - functional requirements that are testable and unambiguous
   - key entities when the feature involves meaningful data
   - measurable success criteria
   - assumptions, dependencies, and open risks
7. Keep the specification readable for non-technical stakeholders while making acceptance criteria precise enough for design and planning. Avoid implementation details such as specific libraries, frameworks, APIs, or file layouts.
8. When information is missing, ask exactly one clarifying question per turn. Make informed defaults when the impact is low; use `[NEEDS CLARIFICATION: ...]` only for unresolved decisions that materially affect the spec, and cap them at 3.
9. Open `specs/<feature>/spec.md` with the artifact front matter block described in `.specify/templates/artifact-front-matter.md`. Set `stage: specify`, `last_agent: speckit.specify`, refresh `updated_at`, and preserve `created_at` if it already exists.
10. End with a handoff-ready summary. For frontend, UX-heavy, or visually significant work, route next to `Designer` / `speckit.design`; otherwise indicate readiness for `speckit.plan`.