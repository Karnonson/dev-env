# Specification Artifact Template

Use this structure for `specs/<feature>/spec.md` when no stronger repo-specific template exists.

# Feature Specification: [FEATURE NAME]

**Feature**: `[feature-name]` | **Created**: [DATE] | **Status**: Draft  
**Input**: Approved discovery or user description: "$ARGUMENTS"

## Overview *(mandatory)*

### Problem Statement

[Describe the user or business problem in plain language]

### Intended Outcome

[Describe the user value and the desired outcome when this feature succeeds]

## User Scenarios & Testing *(mandatory)*

<!--
  IMPORTANT: User stories should be PRIORITIZED as user journeys ordered by importance.
  Each story must be independently testable and deliver user value on its own.
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently and what value it delivers]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### User Story 3 - [Brief Title] (Priority: P3)

[Describe this user journey in plain language]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

### Edge Cases

- What happens when [boundary condition]?
- How does the system handle [error scenario]?

## Out Of Scope

- [Explicitly list non-goals or deferred work]

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST [specific capability]
- **FR-002**: System MUST [specific capability]
- **FR-003**: Users MUST be able to [key interaction]
- **FR-004**: System MUST [data requirement]
- **FR-005**: System MUST [behavior or rule]

*Example of marking unresolved high-impact choices:*

- **FR-006**: System MUST support [NEEDS CLARIFICATION: unresolved choice that materially affects scope or UX]

### Key Entities *(include if feature involves meaningful data)*

- **[Entity 1]**: [What it represents and the key attributes or relationships that matter]
- **[Entity 2]**: [What it represents and the key attributes or relationships that matter]

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: [Measurable user or business outcome]
- **SC-002**: [Measurable quality, speed, or completion metric]
- **SC-003**: [Observable adoption, accuracy, or satisfaction metric]

## Assumptions

- [Reasonable default chosen from discovery or repository context]
- [Scope boundary or dependency assumption]

## Dependencies And Constraints

- [Dependency on an existing system, team, or external input]
- [Policy, compliance, accessibility, security, or operational constraint]