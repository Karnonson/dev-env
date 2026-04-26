---
description: Implement only the UI-oriented tasks from the active Speckit feature branch.
---

## User Input

```text
$ARGUMENTS
```

## Outline

1. Share a short todo checklist before touching the repo so the user can steer the UI slice.
2. Read `.specify/feature.json` to locate the active feature slug. Verify that the current git branch is `feature/<slug>` and that `specs/<slug>/` exists. If the branch, specs directory, or feature.json disagree on the slug, stop and fix the mismatch before proceeding.
3. Load `spec.md`, `plan.md`, `tasks.md`, `.specify/memory/constitution.md`, and `.specify/memory/design-direction.md` (the canonical design system and brand identity guide).
4. Confirm the current git branch is `feature/<slug>`. Do not implement UI changes on `main`, `master`, or an unrelated branch.
5. Execute only UI-oriented tasks such as pages, components, forms, responsive layouts, accessibility, and interaction states.
6. Mark completed UI tasks in `tasks.md`.
7. Report which backend or shared tasks remain and whether the feature branch is ready for verification and merge review.
