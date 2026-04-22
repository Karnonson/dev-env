# Verify Feature: Merge Conflicts

Resolve conflict markers before sending the branch to merge review.

Why it happens:

- Conflict markers mean the code shown to reviewers is not the code that will actually merge.
- The gate blocks until the working tree is consistent again.

Fix:

```bash
git diff --name-only --diff-filter=U
git add path/to/resolved-file
kite verify feature
```