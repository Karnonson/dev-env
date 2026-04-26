# Plan Artifact Template

Use this structure for `specs/<feature>/plan.md` when no stronger repo-specific template exists.

# Implementation Plan: [FEATURE NAME]

**Feature**: `[feature-name]` | **Date**: [DATE] | **Spec**: [link]  
**Input**: Feature specification from `specs/[feature-name]/spec.md`

## Summary

[Extract the primary requirement, user value, and the intended delivery approach]

## Technical Context

**Language/Version**: [e.g., Node 22, Python 3.12, or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., framework, SDKs, or NEEDS CLARIFICATION]  
**Storage**: [e.g., PostgreSQL, files, N/A]  
**Testing**: [e.g., unit/integration/e2e stack or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Linux CLI, web app, API service]  
**Project Type**: [e.g., cli, web-service, library, full-stack app]  
**Performance Goals**: [feature-relevant targets or N/A]  
**Constraints**: [feature flags, latency, compliance, rollout, or platform limits]  
**Scale/Scope**: [users, teams, data volume, or repository impact]

## Constitution Check

_GATE: Must pass before the plan is finalized and again whenever later changes materially alter scope._

- [List the constitutional rules this plan must satisfy]
- [Note any justified exception and why a simpler approach was rejected]

## Project Structure

### Documentation (this feature)

```text
specs/[feature-name]/
├── plan.md              # This file
├── research.md          # Optional: decisions that resolve plan unknowns
├── data-model.md        # Optional: entities and schema details when needed
├── quickstart.md        # Optional: feature-specific setup or validation flow
├── contracts/           # Optional: external or cross-boundary contracts
└── tasks.md             # Output from speckit.tasks
```

### Source Code (repository root)

```text
[Replace with the concrete directories this feature will touch]
```

**Structure Decision**: [Explain which directories are in scope and why]

## Technology Rationale

- [For each non-user-selected framework, library, or architecture choice: why this option was chosen over the main alternatives]
- [Summarize current best-practice guidance or link to `research.md` when the decision needed separate validation]

## Complexity Tracking

| Violation                      | Why Needed     | Simpler Alternative Rejected Because   |
| ------------------------------ | -------------- | -------------------------------------- |
| [e.g., extra service boundary] | [current need] | [why the simpler path is insufficient] |

## Delivery Phases

1. [Phase name and objective]
2. [Phase name and objective]

## Architecture And Contracts

- [Key technical decisions]
- [Data flow, API, schema, or integration impacts]
- [Call out user-mandated technology choices separately from planner-selected choices]

## Dependencies And Handoffs

- [Blocking prerequisite or sequence dependency]
- [Backend vs UI or cross-team handoff boundary]

## Verification Strategy

- [Required automated test tiers]
- [Manual checks, observability, or rollout validation]

## Rollout / Operations

- [Feature flags, migrations, monitoring, support notes]

## Risks And Mitigations

- [Risk] -> [Mitigation]

## Handoff To Tasks

- [What `speckit.tasks` should break down next]
