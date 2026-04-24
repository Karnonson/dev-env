---
description: Resolve the required verification tiers, run them against the active feature branch, and report results before code review.
handoffs:
  - label: Review Changes
    agent: Code Reviewer
    prompt: Review the implementation and test results for bugs, regressions, risks, and coverage gaps.
---

## User Input

```text
$ARGUMENTS
```

## Outline

1. Share a short todo checklist before running verification so the user can steer the test pass.
2. Read `.specify/feature.json` to locate the active feature directory.
2. Load the active `spec.md`, `plan.md`, `tasks.md`, `.specify/memory/constitution.md`, and `.kite/config.yml` when present.
3. Confirm the current git branch is the active feature branch. Do not run tests on `main` or `master` unless explicitly asked.
4. Resolve the required verification scope in this order:
   - explicit user-requested tiers or profiles from `$ARGUMENTS`
   - constitution-required verification defaults or mandatory extra tiers
   - `.kite/config.yml` `workflow.test_tier`
   - fallback profile `standard`
5. Support these concrete tiers: `unit`, `integration`, `e2e`, `a11y`, `perf`, `security`.
   - Compatibility profiles map to tier sets: `smoke` => `unit`, `standard` => `unit + integration`, `full` => `unit + integration + e2e + a11y + perf + security`.
6. Discover project roots in a monorepo-aware way by checking the repo root, common app folders, `packages/*`, and any package-manager workspace globs.
7. Run the resolved tiers using the repo's preferred runners. Prefer using `kite test --tier <tier>` or `kite test --profile <profile>` so the native CLI behavior stays aligned with repo defaults.
   - Python: `pytest` via `uv run pytest` or direct, with dedicated integration/perf folders when present
   - TypeScript: `pnpm run <script>`, `npm run <script>`, `npx vitest run`, `npx jest`, `npx playwright test`
   - Accessibility/perf/security: tier-specific scripts when present, plus `kite audit` for the security tier
8. If tests fail, read the error output and attempt to fix the failing tests or implementation at least once before reporting failure.
9. If a required tier cannot run because the repo lacks a runner or config, report that as a verification gap instead of silently skipping it.
10. Report test results:

- Total tests run, passed, failed, skipped
- Which tiers ran, which were skipped, and why
- Summary of any failures with file and line references
- Whether the feature branch is ready for code review

11. If no test framework is discovered for the required tiers, report that and recommend setting one up appropriate to the project stack.
12. When results are meaningful enough to persist (non-trivial runs, flakes, or pre-review summaries), check `.specify/templates/test-results.md` and the rest of `.specify/templates/` for a matching template before writing `specs/<feature>/test-results.md`. Open the file with the artifact front matter block described in `.specify/templates/artifact-front-matter.md`. Set `stage: test`, `last_agent: speckit.test`, refresh `updated_at`, and preserve `created_at` if it already exists.
