# Verify Feature: Unknown Branch

Give the work a named branch before running the merge-readiness gate.

Why it happens:

- Detached `HEAD` states do not tell `kite` which feature branch is being reviewed.
- Merge review should happen on a named feature branch, not on an anonymous checkout.

Fix:

```bash
git checkout -b feat/my-feature
kite verify feature
```