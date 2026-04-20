---
description: Implement only the UI-oriented tasks from the active Speckit feature branch.
---

## User Input

```text
$ARGUMENTS
```

## Outline

1. Read `.specify/feature.json` to locate the active feature directory.
2. Load `spec.md`, `plan.md`, `tasks.md`, `.specify/memory/constitution.md`, and `.specify/memory/design-direction.md` (the canonical design system and brand identity guide).
3. Confirm the current git branch matches the active feature work. Do not implement UI changes on `main` or `master`.
4. Execute only UI-oriented tasks such as pages, components, forms, responsive layouts, accessibility, and interaction states.
5. Mark completed UI tasks in `tasks.md`.
6. Report which backend or shared tasks remain and whether the feature branch is ready for verification and merge review.