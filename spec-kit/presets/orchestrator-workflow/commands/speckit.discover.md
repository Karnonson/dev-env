---
description: Run a guided discovery pass, optionally validate market risk, and write the canonical discovery artifact for the feature.
handoffs:
  - label: Lock Project Standards
    agent: speckit.constitution
    prompt: Turn the approved discovery artifact into project-level standards before specification starts.
---

## User Input

```text
$ARGUMENTS
```

Use this command when the user has a feature idea but needs a structured artifact that captures the problem, user, outcome, and success signal before technical specification starts.

## Clarification Rules

When clarification is needed, ask exactly one question at a time and wait for the user's answer before asking the next one. Do not send a batched questionnaire unless the user explicitly asks to answer in bulk.

## Interaction Example

```text
User: We need a better onboarding experience.
Assistant: Who is the primary user for this onboarding flow?
User: New self-serve team admins.
Assistant: What specific outcome should improve for them?
```

## Outline

1. Identify the canonical feature identifier from the user input. If the name is still ambiguous, ask exactly one question to choose a stable identifier, then wait for the answer before continuing.
2. Before writing any canonical artifact, start or align the active feature context:
  - ensure the current git branch is the correct feature branch for this work, not `main`, `master`, or an unrelated branch
  - when the repo uses numbered Speckit-style feature names, keep that same identifier across the branch, `specs/<feature>/`, and `.specify/feature.json`
  - ensure `.specify/feature.json` exists and its `name` matches the feature identifier that discovery will write
  - if the branch and persisted feature context disagree, fix the mismatch before continuing
3. Read repository context that can shape discovery, including `README.md`, `.github/copilot-instructions.md`, and any product or architecture docs that already describe the audience or business context.
4. Run a short discovery interview. When information is missing, ask exactly one clarifying question per turn. After each answer, decide whether another question is still required. Ask only the minimum questions needed to capture:
   - problem statement in plain language
   - target user and their context
   - jobs to be done or desired outcome
   - numbered assumptions
   - the riskiest assumption to test first
   - one primary and one secondary success metric
   - out-of-scope items
5. If audience or market-fit confidence is materially uncertain, offer an optional Marketer pass before finalizing discovery. When the user wants that evidence:
   - run the Marketer agent
   - store the durable output at `specs/<feature>/market-validation.md`
   - fold the key findings back into the discovery artifact
  If the user declines, record that market validation was skipped.
6. Write the canonical discovery artifact to `specs/<feature>/discovery.md`.
7. Open the file with the artifact front matter block described in `spec-kit/templates/artifact-front-matter.md`. Set `stage: discover`, `last_agent: speckit.discover`, refresh `updated_at`, and preserve `created_at` if it already exists.
8. Keep the artifact plain-language and decision-oriented. Surface open risks explicitly instead of smoothing them over.
9. Do not create `specs/<feature>/brief.md` as part of this workflow.
10. End with a handoff-ready summary for `speckit.constitution`.
