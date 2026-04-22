---
description: Create the design system, brand identity, and visual direction for the active feature based on the approved specification.
handoffs:
  - label: Create Plan
    agent: speckit.plan
    prompt: Plan the implementation phases using the approved spec and design direction.
---

## User Input

```text
$ARGUMENTS
```

Use this command after `speckit.specify` has produced a canonical spec. The design pass reads the specification and creates a coherent design system and brand identity that the implementation agents can follow.

## Clarification Rules

When clarification is needed, ask exactly one question at a time and wait for the user's answer before asking the next one. Do not send a multi-part style questionnaire unless the user explicitly asks for that format.

## Interaction Example

```text
User: Create the design direction for the analytics dashboard feature.
Assistant: Should the visual direction feel more conservative enterprise or more editorial and expressive?
User: Conservative enterprise.
Assistant: Are there any accessibility requirements beyond baseline WCAG AA?
```

## Outline

1. Read the active `specs/<feature>/spec.md` to understand the feature scope, user stories, and acceptance criteria.
2. Read `.specify/memory/constitution.md` for project-level design and quality constraints.
3. When information is missing, ask exactly one clarifying question per turn to remove ambiguity around typography, color system, brand identity, component patterns, accessibility standards, and responsive behavior.
4. Produce a comprehensive design direction document that covers:
   - brand identity: logo direction, color palette, typography scale, tone of voice
   - design tokens: colors, spacing, radii, elevation, borders, motion
   - component rules: buttons, inputs, cards, tables, navigation, dialogs, feedback states
   - page and layout inventory derived from the spec
   - interaction patterns: hover, focus, active, disabled, loading, error, empty, success states
   - accessibility requirements: contrast ratios, keyboard navigation, screen reader support
   - responsive breakpoints and behavior
   - any open risks or assumptions
5. Store the canonical design direction at `.specify/memory/design-direction.md` so implementation agents can reference it directly. Open the file with the artifact front matter block described in `spec-kit/templates/artifact-front-matter.md`. Set `stage: design`, `last_agent: speckit.design`, refresh `updated_at`, and preserve `created_at` if it already exists.
6. Keep durable design decisions in the canonical design-direction artifact by default. Do not create a parallel `team/agents/designer/...` note unless the user explicitly asks for one or there is no canonical home for material that must persist.
7. End with a handoff-ready summary for `speckit.plan`.
