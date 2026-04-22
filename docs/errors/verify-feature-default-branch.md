# Verify Feature: Default Branch

Run `kite verify feature` from a feature branch, not from `main`.

Why it happens:

- The gate is meant to confirm a branch is ready to merge into the default branch.
- Running it on `main` bypasses the branch-first Speckit workflow.

Fix:

```bash
git checkout -b feat/my-feature
kite verify feature
```