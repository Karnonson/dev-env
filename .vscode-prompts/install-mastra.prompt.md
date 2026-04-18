---
name: install-mastra
description: "Guide for adding Mastra Skills to a project: commands, verification, and git tips."
---

# Install Mastra Skills into a Project

This skill documents how to add the official Mastra Skills to a repository for local development or global/user installation.

## Prerequisites

- Node.js >= 20 and npm (or compatible `npx`)
- Network access to fetch the skills repository

## Project-level installation (recommended for repo-scoped development)

Run this to copy the official Mastra skills into your project under `./.agents/skills`:

```bash
npx skills add mastra-ai/skills --copy -y
```

- `--copy` places files in `./.agents/skills/mastra` (useful for review and committing if desired)
- `-y` skips interactive confirmation

```

## Install to a specific agent or subset of skills

- Install only particular skills: `--skill <skill-name>`
- Install to specific agents: `--agent <agent-name>`

Examples:

```bash
npx skills add mastra-ai/skills --agent claude-code --copy -y
npx skills add mastra-ai/skills --skill mastra --copy -y
```

## Verify installation

```bash
# List installed skills (project scope)
npx skills ls

# Or JSON output
npx skills ls --json

# Inspect the installed Mastra skill files
ls -la ./.agents/skills/mastra
cat ./.agents/skills/mastra/SKILL.md
```

## Uninstall / cleanup

To remove installed skills use the CLI removal commands (see `npx skills --help`):

```bash
# interactive remove
npx skills remove

# remove a named skill (project or global flags apply)
npx skills remove mastra -y
```

## Security & review

Skills run with broad agent permissions. Always review installed files under `./.agents/skills/mastra` before trusting or committing them into a repository.

## Notes

- The official Mastra Skills repository: https://github.com/mastra-ai/skills
- Use `--copy` when you prefer to keep a repository-local copy for versioning or review.
