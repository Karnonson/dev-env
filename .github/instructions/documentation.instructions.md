---
name: documentation.instructions
description: "Use when: docs, README, quickstart, documentation. Standardize README vs docs structure, quickstarts, and PR expectations."
applyTo: "**"
---

Purpose

Standardize how repositories present quickstarts, README content, and long-form docs so documentation is discoverable, consistent, and easy to maintain.

Scope

This instruction applies to this repository. Place quickstarts and one-line summaries in the repository README.md and long-form, structured documentation in a `docs/` directory.

Quick rules

- README.md:
  - 1–2 sentence project summary at the top.
  - Badges (CI, license, coverage) beneath the title.
  - Concise Quickstart with copy-paste commands in a fenced code block.
  - Minimal example showing primary use-case.
  - Link to docs index (docs/index.md).
  - License and contribution pointer.

- docs/:
  - `index.md` — overview + links to key guides and quickstart.
  - `getting-started.md` — full install, environment setup, common pitfalls.
  - `usage/` — tutorials and how-tos.
  - `reference/` — CLI/API/config reference (one file per command or endpoint).
  - `architecture.md`, `contributing.md`, `release-notes.md`.

Style & conventions

- Use short headings and imperative voice.
- Provide runnable, minimal examples and platform notes where required.
- Prefer cross-references instead of duplicating content.
- Keep code examples copy-paste ready; avoid ellipses in commands.

Docs site & build

If the repo publishes a docs site (mkdocs, Docusaurus, Sphinx, etc.) keep the site config near `docs/` and include a build snippet in `README.md`:

```sh
mkdocs build
# or
npm run build
```

Versioning & releases

- Update `release-notes.md` and API/CLI reference when public surface changes.
- Add migration notes for breaking changes.

PR / commit expectations

- Use a `docs:` commit prefix for doc-only changes.
- For feature or API changes, update docs and README in the same PR.
- Document changes in the PR description and request a docs-aware reviewer.

Maintenance

- Assign docs ownership and ensure at least one docs-aware reviewer for PRs touching public surface or behavior.

Discovery and keyword guidance

- Keep the `description` field above explicit and include trigger keywords ("docs", "README", "quickstart", "documentation") so agents can find this instruction.
- Avoid overly broad `applyTo` patterns unless the instruction should always be included; this file uses `applyTo: "**"` intentionally for repo-wide coverage.

Caveats

- Place very long tutorials in `docs/` rather than README.
- When editing this instruction, update the `description` with any new trigger keywords to keep discovery effective.
