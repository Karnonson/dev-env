---
description: Create or update the project constitution after collecting the missing workflow and quality preferences first.
handoffs:
  - label: Build Specification
    agent: speckit.specify
    prompt: Turn the approved feature direction into a Speckit specification.
---

## User Input

```text
$ARGUMENTS
```

You MUST collect missing preferences before drafting or updating `.specify/memory/constitution.md`. Before asking questions or drafting the artifact, share a short todo checklist so the user can steer the constitution pass.

When clarification is needed, ask exactly one question at a time and wait for the user's answer before asking the next one. Do not send the full question list as a single questionnaire unless the user explicitly asks for that format.

## Required Questions

Use these as question areas, not as a batched script. Start with the highest-leverage gap and ask at most one question per turn when the answer is not already explicit in the user input or repository context:

1. What kind of product or project is this repository for?
2. What are the non-negotiable engineering standards for code quality, testing, review, feature branching, and merge readiness?
3. Should UI-heavy features go through a design-system or UX-definition step after specification and before planning or implementation?
4. Which implementation roles are primary in this repo: backend, UI, or both?
5. When work spans both backend and UI, should implementation be split by specialist instead of using a single generic implement pass?
6. Are there any stack-specific constraints, security rules, performance targets, or documentation requirements that must become constitutional rules?
7. What is the default verification profile or tier set for feature work: `smoke`, `standard`, `full`, or an explicit combination such as `unit + integration + security`?

If key answers are missing, stop after the first unanswered question that blocks progress. Do not draft the constitution until the user answers.

## Interaction Example

```text
User: Set up the constitution for this repo.
Assistant: What kind of product or project is this repository for?
User: A CLI tool for feature orchestration.
Assistant: What are the non-negotiable engineering standards for code quality, testing, review, feature branching, and merge readiness?
```

## Outline

1. Read the existing constitution at `.specify/memory/constitution.md`.
2. Read repo context that can influence project rules, including `README.md`, `.github/copilot-instructions.md`, and any architecture docs.
3. Convert the gathered preferences into concrete constitutional rules.
4. Ensure the constitution captures, when requested by the user:
  - a mandatory design step for UI-heavy work after specification and before planning or implementation
   - the preferred use of backend and UI specialists for implementation
  - the default verification profile or tier set required before review or merge
  - any mandatory `a11y`, `perf`, or `security` tiers for risky or user-facing changes
  - a feature-branch workflow where work stays off `main` until verification and review are complete
  - review, testing, and document-ownership expectations

5. Before writing, check `.specify/templates/constitution.md` and the rest of `.specify/templates/` for a matching constitution template and follow it when present.
6. Update `.specify/memory/constitution.md` in place.
7. Ensure the file opens with the artifact front matter block described in `.specify/templates/artifact-front-matter.md`. Set `stage: constitution`, `last_agent: speckit.constitution`, refresh `updated_at`, and preserve `created_at` if it already exists.
8. Summarize the resulting principles and any follow-up commands the user should run next.
