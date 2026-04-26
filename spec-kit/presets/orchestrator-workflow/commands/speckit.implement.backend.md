---
description: Implement only the backend-oriented tasks from the active Speckit feature branch.
---

## User Input

```text
$ARGUMENTS
```

## Outline

1. Share a short todo checklist before touching the repo so the user can steer the backend slice.
2. Read `.specify/feature.json` to locate the active feature slug. Verify that the current git branch is `feature/<slug>` and that `specs/<slug>/` exists. If the branch, specs directory, or feature.json disagree on the slug, stop and fix the mismatch before proceeding.
3. Load `spec.md`, `plan.md`, `tasks.md`, `.specify/memory/constitution.md`, and `.specify/memory/design-direction.md` (when present for API contract alignment).
4. Confirm the current git branch is `feature/<slug>`. Do not implement backend changes on `main`, `master`, or an unrelated branch.
5. Execute only backend-oriented tasks such as APIs, auth, data models, jobs, integrations, and server-side validation.
6. Mark completed backend tasks in `tasks.md`.
7. Report which UI or shared tasks remain and whether the feature branch is ready for the UI slice.
