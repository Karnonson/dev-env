# Verify Feature: Incomplete Tasks

Close or deliberately defer open work in the active `tasks.md` before merge review.

Why it happens:

- The active Speckit task list is part of the contract for the feature branch.
- Open checklist items usually mean scope, verification, or follow-up work is still unresolved.

Fix:

```bash
grep -nE '^\s*-\s*\[ \]' specs/my-feature/tasks.md
kite feature
```

The `kite verify feature` output shows the exact `tasks.md` path it found for the current branch.
