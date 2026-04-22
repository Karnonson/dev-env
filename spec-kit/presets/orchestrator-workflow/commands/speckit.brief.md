---
description: Turn approved discovery findings into a plain-language product brief that stakeholders can sign off before specification.
handoffs:
  - label: Lock Project Standards
    agent: speckit.constitution
    prompt: Update the project constitution so the approved brief can move into technical specification with clear standards.
---

## User Input

```text
$ARGUMENTS
```

Use this command after `speckit.discover` has produced a canonical discovery artifact. The brief is a one-page, non-technical statement of the feature that stakeholders can review before technical specification begins.

## Outline

1. Read `specs/<feature>/discovery.md`.
2. Read `specs/<feature>/market-validation.md` when it exists.
3. Read repository context that adds product or delivery constraints, including `README.md`, `.github/copilot-instructions.md`, and any relevant docs.
4. Ask only the questions needed to remove ambiguity around the desired outcome, key constraints, success metric, non-goals, and approval status.
5. Draft `specs/<feature>/brief.md` in plain language. Cover:
   - the problem
   - the primary user
   - the promised outcome and value
   - rough scope and constraints
   - one primary success metric
   - explicit non-goals
   - open assumptions or unresolved risks
6. Require explicit user sign-off before moving into technical specification. If the brief is awaiting sign-off, leave the artifact in an in-review state and clearly ask for approval.
7. Open the file with the artifact front matter block described in `spec-kit/templates/artifact-front-matter.md`. Set `stage: brief`, `last_agent: speckit.brief`, refresh `updated_at`, and preserve `created_at` if it already exists.
8. End with the next recommended handoff: `speckit.constitution`, then `speckit.specify`.
