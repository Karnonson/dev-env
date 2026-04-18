---
description: Implement only the UI-oriented tasks from the active Speckit feature.
---

## User Input

```text
$ARGUMENTS
```

## Outline

1. Read `.specify/feature.json` to locate the active feature directory.
2. Load `spec.md`, `plan.md`, `tasks.md`, and `.specify/memory/constitution.md`.
3. Execute only UI-oriented tasks such as pages, components, forms, responsive layouts, accessibility, and interaction states.
4. Mark completed UI tasks in `tasks.md`.
5. Report which backend or shared tasks remain.