# Artifact Front Matter Standard

Every canonical Speckit artifact under `specs/<feature>/` and
`.specify/memory/` should open with a YAML front matter block so tooling
(notably `kite feature`) can derive the current lifecycle stage, freshness,
and ownership without heuristics.

## Required block

```yaml
---
stage: <discover|constitution|specify|design|plan|tasks|analyze|implement|test|review|verify|release|operate|learn>
feature: <feature-slug>
status: <draft|in-review|approved|archived>
owner: <human-name-or-role>
last_agent: <agent-name>
created_at: <YYYY-MM-DD>
updated_at: <YYYY-MM-DD>
---
```

## Field reference

| Field        | Purpose                                     | Notes                                                                                                                           |
| ------------ | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `stage`      | Lifecycle stage this artifact belongs to    | Must match one of the supported stages listed by `kite explain`. Legacy optional artifacts such as `brief` may keep their historical stage value when needed. |
| `feature`    | Feature slug                                | Matches the directory name under `specs/` and `.specify/feature.json` name.                                                     |
| `status`     | Editorial state                             | `draft` while being written; `in-review` when awaiting review; `approved` once signed off; `archived` for superseded artifacts. |
| `owner`      | Accountable human or role                   | Example: `@karnon`, `Product`, `Backend Dev`.                                                                                   |
| `last_agent` | Last agent to touch the file                | Example: `Designer`, `speckit.plan`, `Backend Dev`.                                                                             |
| `created_at` | ISO date the artifact was first written     | Immutable.                                                                                                                      |
| `updated_at` | ISO date of the most recent meaningful edit | Update when content changes.                                                                                                    |

## Applies to

Canonical artifacts:

- `specs/<feature>/discovery.md`
- `specs/<feature>/spec.md`
- `specs/<feature>/plan.md`
- `specs/<feature>/tasks.md`
- `specs/<feature>/analyze.md`
- `specs/<feature>/test-results.md`
- `specs/<feature>/review.md`
- `specs/<feature>/release.md`
- `specs/<feature>/operate.md`
- `specs/<feature>/learn.md`
- `.specify/memory/constitution.md`
- `.specify/memory/design-direction.md`

Optional compatibility artifact:

- `specs/<feature>/brief.md`

Optional but recommended for durable team notes under
`team/agents/<agent>/<YYYY-MM-DD>-<feature>.md`.

## Example

```markdown
---
stage: plan
feature: order-history-export
status: in-review
owner: Backend Dev
last_agent: speckit.plan
created_at: 2025-02-12
updated_at: 2025-02-14
---

# Technical Plan — Order History Export

...
```

## Agent guidance

Speckit command prompts and custom agents SHOULD:

1. Check `.specify/templates/` for the most specific matching artifact template before drafting a canonical artifact.
2. Emit this block as the first lines of any new canonical artifact.
3. Update `updated_at`, `status`, and `last_agent` whenever they edit an
   existing artifact.
4. Leave `created_at` unchanged after the first write.

Humans editing artifacts manually should update `updated_at` at minimum.

## Tooling contract

`kite feature` uses artifact presence plus these fields to report the
current stage and freshness. Missing front matter is tolerated but
downgrades reporting to "unknown" for that file.
