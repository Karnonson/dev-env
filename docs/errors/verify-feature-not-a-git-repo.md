# Verify Feature: Not A Git Repo

Run `kite verify feature` only inside a Git repository.

Why it happens:

- `kite verify feature` checks branch state, merge conflicts, and task progress.
- None of those checks are available before the repo is initialized.

Fix:

```bash
git init
git checkout -b feat/my-feature
kite verify feature
```