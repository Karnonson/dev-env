---
description: Implement only the backend-oriented tasks from the active Speckit feature branch.
---

## User Input

```text
$ARGUMENTS
```

## Outline

1. Read `.specify/feature.json` to locate the active feature directory.
2. Load `spec.md`, `plan.md`, `tasks.md`, `.specify/memory/constitution.md`, and `.specify/memory/design-direction.md` (when present for API contract alignment).
3. Confirm the current git branch matches the active feature work. Do not implement backend changes on `main` or `master`.
4. Execute only backend-oriented tasks such as APIs, auth, data models, jobs, integrations, and server-side validation.
5. Mark completed backend tasks in `tasks.md`.
6. Report which UI or shared tasks remain and whether the feature branch is ready for the UI slice.