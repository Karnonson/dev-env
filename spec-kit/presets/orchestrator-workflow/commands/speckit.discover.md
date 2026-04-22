---
description: Run a guided discovery pass, optionally validate market risk, and write the canonical discovery artifact for the feature.
handoffs:
  - label: Draft Product Brief
    agent: speckit.brief
    prompt: Turn the approved discovery artifact into a plain-language product brief before constitution and specification.
---

## User Input

```text
$ARGUMENTS
```

Use this command when the user has a feature idea but needs a structured artifact that captures the problem, user, outcome, and success signal before technical specification starts.

## Outline

1. Identify the feature slug from the user input. If the name is still ambiguous, ask only the minimum question needed to choose a stable feature name.
2. Read repository context that can shape discovery, including `README.md`, `.github/copilot-instructions.md`, and any product or architecture docs that already describe the audience or business context.
3. Run a short discovery interview. Ask only the minimum questions needed to capture:
   - problem statement in plain language
   - target user and their context
   - jobs to be done or desired outcome
   - numbered assumptions
   - the riskiest assumption to test first
   - one primary and one secondary success metric
   - out-of-scope items
4. If audience or market-fit confidence is materially uncertain, offer an optional Marketer pass before finalizing discovery. When the user wants that evidence:
   - run the Marketer agent
   - store the durable output at `specs/<feature>/market-validation.md`
   - fold the key findings back into the discovery artifact
     If the user declines, record that market validation was skipped.
5. Write the canonical discovery artifact to `specs/<feature>/discovery.md`.
6. Open the file with the artifact front matter block described in `spec-kit/templates/artifact-front-matter.md`. Set `stage: discover`, `last_agent: speckit.discover`, refresh `updated_at`, and preserve `created_at` if it already exists.
7. Keep the artifact plain-language and decision-oriented. Surface open risks explicitly instead of smoothing them over.
8. End with a handoff-ready summary for `speckit.brief`.
