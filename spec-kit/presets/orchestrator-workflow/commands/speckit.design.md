---
description: Define the design-system and UX direction for the active feature before specification.
handoffs:
  - label: Create Speckit Spec
    agent: speckit.specify
    prompt: Build the feature specification using the approved design direction.
---

## User Input

```text
$ARGUMENTS
```

Use this command when a feature needs visual direction, UX clarification, or design-system decisions before `speckit.specify`.

## Outline

1. Identify the feature goal from the user input and any active Speckit artifacts.
2. Ask only the questions needed to remove ambiguity around flows, screens, states, typography, color system, components, accessibility, and responsive behavior.
3. Produce a concise design brief that covers:
   - the user journey and key interactions
   - the design-system decisions or reusable components required
   - the page, component, and state inventory the spec should account for
   - any open risks or assumptions
4. Store supporting design notes under `team/agents/designer/YYYY-MM-DD-<feature-name>.md` when a durable record is useful.
5. End with a handoff-ready summary for `speckit.specify`.