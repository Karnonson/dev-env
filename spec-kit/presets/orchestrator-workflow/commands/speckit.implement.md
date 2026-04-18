---
description: Coordinate implementation from the active Speckit artifacts, require analysis first, and execute backend before UI.
handoffs:
  - label: Implement Backend Slice
    agent: Backend Dev
    prompt: Implement the backend tasks from the active Speckit feature.
  - label: Implement UI Slice
    agent: UI Builder
    prompt: Implement the UI tasks from the active Speckit feature.
  - label: Review Changes
    agent: Code Reviewer
    prompt: Review the implementation for bugs, regressions, risks, and missing tests.
---

## User Input

```text
$ARGUMENTS
```

Treat `spec.md`, `plan.md`, and `tasks.md` as canonical.

## Outline

1. Read `.specify/feature.json` to find the active feature directory.
2. Read the active `spec.md`, `plan.md`, `tasks.md`, `.specify/memory/constitution.md`, and any recent `speckit.analyze` output if it exists.
3. Do not begin implementation if `speckit.analyze` has not been run or if unresolved critical consistency issues remain. Stop and tell the user to resolve them first.
4. Classify pending tasks into backend, UI, and shared buckets.
5. If the split is ambiguous, ask the user for confirmation before implementation begins.
6. Enforce execution order:
  - backend and shared foundation tasks that unblock APIs, data contracts, auth, or server behavior run first
  - UI tasks begin only after the backend dependencies they rely on are complete or explicitly stubbed
7. Prefer specialist execution:
  - backend tasks go to `Backend Dev`
  - UI tasks go to `UI Builder`
  - shared or sequencing-sensitive tasks must be called out explicitly before handoff
8. Require a concise checkpoint summary after the backend slice before starting the UI slice.
9. After specialist execution, prefer `Code Reviewer` before final verification.

Do not create a second backlog. Work from the active Speckit task list.