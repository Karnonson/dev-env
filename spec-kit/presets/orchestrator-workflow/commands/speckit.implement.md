---
description: Coordinate implementation from the active Speckit artifacts, require analysis first, execute backend before UI, and run tests before review.
handoffs:
  - label: Implement Backend Slice
    agent: Backend Dev
    prompt: Implement the backend tasks from the active Speckit feature.
  - label: Implement UI Slice
    agent: UI Builder
    prompt: Implement the UI tasks from the active Speckit feature.
  - label: Run Tests
    agent: speckit.test
    prompt: Discover and run the project test suite against the active feature branch.
  - label: Review Changes
    agent: Code Reviewer
    prompt: Review the implementation for bugs, regressions, risks, and missing tests.
---

# Speckit Implement

## User Input

```text
$ARGUMENTS
```

Treat `spec.md`, `plan.md`, and `tasks.md` as canonical.

## Outline

1. Read `.specify/feature.json` to find the active feature directory.
1. Read the active `spec.md`, `plan.md`, `tasks.md`, `.specify/memory/constitution.md`, `.specify/memory/design-direction.md` (when present), and any recent `speckit.analyze` output if it exists.
1. Confirm the current git branch is the active feature branch. If the repo is on `main`, `master`, or another unrelated branch, create or switch to the correct feature branch before editing.
1. Do not begin implementation if `speckit.analyze` has not been run or if unresolved critical consistency issues remain. Stop and tell the user to resolve them first.
1. Classify pending tasks into backend, UI, and shared buckets.
1. If the split is ambiguous, ask the user for confirmation before implementation begins.
1. Enforce execution order:

- backend and shared foundation tasks that unblock APIs, data contracts, auth, or server behavior run first
- UI tasks begin only after the backend dependencies they rely on are complete or explicitly stubbed

1. Prefer specialist execution:

- backend tasks go to `Backend Dev`
- UI tasks go to `UI Builder`
- shared or sequencing-sensitive tasks must be called out explicitly before handoff

1. Require a concise checkpoint summary after the backend slice before starting the UI slice.
1. After specialist execution, route to `speckit.test` to run the project's test suite. All tests must pass before code review.
1. After tests pass, prefer `Code Reviewer` before final verification.
1. Merge to `main` only after the feature branch is green: implementation complete, tests passing, review addressed, and repo checks passing. If the user did not explicitly ask for a merge, report merge readiness instead of merging.

Do not create a second backlog. Work from the active Speckit task list.
