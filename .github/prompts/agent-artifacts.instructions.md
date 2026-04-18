---
name: "Agent Artifact Convention"
description: "Use when creating or updating durable markdown artifacts, plans, briefs, implementation notes, design notes, or handoff documents from custom agents. Standardizes team/agents/[agent-name]/ paths, YYYY-MM-DD-[feature-name].md filenames, and update-in-place behavior."
---

# Agent Artifact Convention

- Default durable agent-authored documents live under team/agents/[agent-name]/.
- Use the filename format: YYYY-MM-DD-[feature-name].md.
- Update the existing feature document when continuing the same task instead of creating duplicates.
- Create a durable artifact only when the task benefits from a lasting record, handoff, or implementation note.
- Keep the document concise and include only the sections needed for the task.
- If an agent already defines a domain-specific storage rule, follow that explicit rule instead of the default.