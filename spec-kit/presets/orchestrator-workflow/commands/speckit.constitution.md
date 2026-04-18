---
description: Create or update the project constitution after collecting the missing workflow and quality preferences first.
handoffs:
  - label: Define Design Direction
    agent: speckit.design
    prompt: Capture the design-system and UX expectations that should guide future feature specs.
  - label: Build Specification
    agent: speckit.specify
    prompt: Turn the approved feature direction into a Speckit specification.
---

## User Input

```text
$ARGUMENTS
```

You MUST collect missing preferences before drafting or updating `.specify/memory/constitution.md`.

## Required Questions

Ask targeted questions when the answer is not already explicit in the user input or repository context:

1. What kind of product or project is this repository for?
2. What are the non-negotiable engineering standards for code quality, testing, and review?
3. Should UI-heavy features go through a design-system or UX-definition step before specification?
4. Which implementation roles are primary in this repo: backend, UI, or both?
5. When work spans both backend and UI, should implementation be split by specialist instead of using a single generic implement pass?
6. Are there any stack-specific constraints, security rules, performance targets, or documentation requirements that must become constitutional rules?

If key answers are missing, stop after asking the minimum set of questions needed. Do not draft the constitution until the user answers.

## Outline

1. Read the existing constitution at `.specify/memory/constitution.md`.
2. Read repo context that can influence project rules, including `README.md`, `.github/copilot-instructions.md`, and any architecture docs.
3. Convert the gathered preferences into concrete constitutional rules.
4. Ensure the constitution captures, when requested by the user:
   - a mandatory design step for UI-heavy work before specification or implementation
   - the preferred use of backend and UI specialists for implementation
   - review, testing, and document-ownership expectations
5. Update `.specify/memory/constitution.md` in place.
6. Summarize the resulting principles and any follow-up commands the user should run next.