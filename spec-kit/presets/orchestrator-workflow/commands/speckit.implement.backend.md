---
description: Implement only the backend-oriented tasks from the active Speckit feature.
---

## User Input

```text
$ARGUMENTS
```

## Outline

1. Read `.specify/feature.json` to locate the active feature directory.
2. Load `spec.md`, `plan.md`, `tasks.md`, and `.specify/memory/constitution.md`.
3. Execute only backend-oriented tasks such as APIs, auth, data models, jobs, integrations, and server-side validation.
4. Mark completed backend tasks in `tasks.md`.
5. Report which UI or shared tasks remain.