# Verify Feature: Dirty Working Tree

Checkpoint or stash local edits before running the merge-readiness gate.

Why it happens:

- Uncommitted changes make it unclear what is actually being reviewed.
- The gate assumes the branch is already in a reviewable state.

Fix:

```bash
git status --short
git stash push -u -m "pre-verify cleanup"
kite verify feature
```

If the changes are ready to keep, commit them instead of stashing them.