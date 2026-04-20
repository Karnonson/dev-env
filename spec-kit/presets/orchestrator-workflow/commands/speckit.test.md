---
description: Discover the project test framework, run tests against the active feature branch, and report results before code review.
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

1. Read `.specify/feature.json` to locate the active feature directory.
2. Load the active `spec.md`, `plan.md`, `tasks.md`, and `.specify/memory/constitution.md`.
3. Confirm the current git branch is the active feature branch. Do not run tests on `main` or `master` unless explicitly asked.
4. Discover the project's test framework by checking for:
   - Python: `pytest.ini`, `pyproject.toml` with `[tool.pytest]`, `setup.cfg` with `[tool:pytest]`, or test files matching `test_*.py` / `*_test.py`
   - TypeScript/JavaScript: `vitest.config.*`, `jest.config.*`, `playwright.config.*`, or `package.json` with test scripts
   - General: a `Makefile` with a `test` target, or scripts in `package.json`
5. Run the discovered test suite using the repo's preferred runner. Prefer:
   - Python: `pytest` (via `uv run pytest` or direct)
   - TypeScript: `pnpm test`, `npm test`, or `npx vitest run`
   - E2E: `npx playwright test` when Playwright config exists
6. If tests fail, read the error output and attempt to fix the failing tests or implementation at least once before reporting failure.
7. Report test results:
   - Total tests run, passed, failed, skipped
   - Summary of any failures with file and line references
   - Whether the feature branch is ready for code review
8. If no test framework is discovered, report that and recommend setting one up appropriate to the project stack.
