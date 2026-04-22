---
name: bootstrap-speckit
description: "Bootstrap the bundled Spec Kit setup in the current workspace for GitHub Copilot and align the repo-local rules with my custom agents."
agent: agent
tools: [read, edit, search, execute, todo]
argument-hint: "Optional: version=v0.7.0, branch-numbering=sequential|timestamp, plus repo-specific notes"
---

# Bootstrap Spec Kit For This Workspace

Bootstrap GitHub Spec Kit in the current workspace and align the repo-local rules with my existing custom agents.

## Defaults

- Default Spec Kit version floor: `v0.7.0`
- Default branch numbering: `sequential`
- Default AI target for Spec Kit init: `copilot`
- Preferred bootstrap path in a Kite workspace: repo-local `./install.sh --with-speckit --source-dir <workspace-root> .`
- Preferred preset source for upstream fallback: workspace-local `spec-kit/presets/orchestrator-workflow` when available, otherwise `~/.config/Code/User/spec-kit-presets/orchestrator-workflow`

If I added extra text after this prompt, treat it as overrides or notes. Respect explicit overrides such as `version=...` or `branch-numbering=timestamp`.

## Goal

Produce a repo-local Spec Kit setup that works cleanly with my user-level agents.

That means:

1. Install or initialize Spec Kit in the current workspace for GitHub Copilot using the bundled local Kite path when it is available.
2. Ensure the repo has the core Spec Kit structure and commands.
3. Install my local `orchestrator-workflow` preset when it is available.
4. Create or update a lightweight repo-local alignment layer so this repo prefers Speckit for canonical feature artifacts and relies on my user-level `Orchestrator` agent instead of creating a repo-local workflow agent.
5. Preserve existing repo-specific rules and any existing `.devcontainer/` when possible instead of overwriting them blindly.

## Required Behavior

### 1. Detect current state first

Before changing anything:

- Find the workspace root.
- Check whether `.git/` exists.
- Check whether `.specify/` already exists.
- Check whether the workspace bundles Kite bootstrap assets: `install.sh`, `spec-kit/`, and `.speckit-version`.
- Check whether any Speckit command files already exist under `.github/agents/` or `.github/prompts/`.
- Check whether `.github/copilot-instructions.md` already exists.
- Check whether `.devcontainer/` already exists and treat that as an additive adoption case, not an automatic blocker.
- Check whether the repo already defines its own workflow agent. If it does, do not change it unless the user explicitly asks.

If Spec Kit is already installed, do **not** reinitialize it unless the user explicitly asks. In that case, only apply the repo-local alignment layer.
If `.specify/` exists but the expected Speckit command files are missing, treat that as a partial or customized install. Surface the state to the user and ask before reinitializing.

### 2. Install Spec Kit when missing

If `.specify/` is missing, initialize Spec Kit in the current workspace.

Preferred command when the current workspace already bundles Kite assets:

```bash
./install.sh --with-speckit --source-dir <workspace-root> .
```

Treat this bundled path as the default in a Kite workspace because it stages the local preset and workflow and keeps bootstrap behavior aligned with the installer.

Only if the bundled local path is unavailable, fall back to upstream init:

```bash
uvx --from git+https://github.com/github/spec-kit.git@v0.7.0 specify init --here --ai copilot --script sh --force --branch-numbering sequential
```

Adjust only when the user explicitly overrides the version or branch numbering.

Operational rules:

- If `uvx` is unavailable, check whether `uv` or `specify` is already installed.
- If neither `uvx`, `uv`, nor `specify` is available, stop and report the prerequisite gap clearly instead of improvising another installer.

### 2.25 Existing dev containers are additive, not blockers

- If `.devcontainer/` already exists, preserve it by default. Do not recommend replacing `devcontainer.json`, `Dockerfile`, or other repo-owned container files unless I explicitly ask for the bundled Kite container or an explicit force path.
- The supported brownfield path is: keep the existing `.devcontainer/`, install the Kite workflow assets, and validate the minimum Kite container contract after reopening in the container.
- Minimum Kite container contract:
   - `kite` is available on `PATH` inside the container.
   - Required post-create setup has run, or equivalent tooling is present inside the container.
   - The workspace-level `.github/` customizations are installed.
   - `specify version`, `kite doctor .`, and the bundled Speckit bootstrap path work inside the container.
- If the contract is incomplete, explain the exact missing piece and the smallest validation or remediation command instead of treating the existing `.devcontainer/` as a hard blocker.

### 2.5 Install my local preset when available

If the bundled local install path succeeded, do **not** rerun separate preset or workflow installation unless validation shows the bundled preset is still missing.

If you had to fall back to upstream `specify init`, and a workspace-local preset exists at `spec-kit/presets/orchestrator-workflow/preset.yml`, prefer it.

Otherwise, if the user-level preset exists at `~/.config/Code/User/spec-kit-presets/orchestrator-workflow/preset.yml`, use that.

When a preset source exists:

- Check whether `orchestrator-workflow` is already installed with `specify preset list`.
- If it is not installed, run:

```bash
specify preset add --dev <preset-path> --priority 1
```

- If it is already installed, leave it in place.
- If neither preset directory exists, continue without failing and report that the workspace is running without the custom preset.

### 3. Align the repo with my custom agents

After Spec Kit exists, create or update this repo-local file:

- `.github/copilot-instructions.md`

This repo-local alignment should make the repo behave like this:

- Speckit owns the canonical feature lifecycle.
- `specs/<feature>/discovery.md`, `spec.md`, `plan.md`, and `tasks.md` are canonical when present.
- Discovery goes through `Strategist` and optionally `Marketer`.
- `Backend Dev` and `UI Builder` are the primary implementation agents.
- `Designer` is an optional post-specification design stage for visual direction, UX decisions, or design-system work on UI-heavy features.
- The default lifecycle is `Strategist -> feature start -> speckit.discover -> speckit.constitution -> speckit.specify -> Designer / speckit.design -> speckit.plan -> speckit.tasks -> speckit.analyze -> Backend Dev / UI Builder -> speckit.test -> Code Reviewer -> kite verify feature`.
- `brief.md` is not part of the default lifecycle or canonical artifact set.
- Before discovery writes canonical artifacts, the feature branch and `.specify/feature.json` must be aligned to the same feature identifier.
- Run `speckit.analyze` after `speckit.tasks` and before implementation.
- Implementation happens on feature branches, not `main`, and merge to `main` only after review and verification pass.
- After implementation, prefer `Code Reviewer` before final verification or merge.
- The primary orchestrator is my user-level `Orchestrator` agent.
- Supporting notes belong under `team/agents/<agent>/YYYY-MM-DD-[feature-name].md` and must not duplicate canonical Speckit artifacts.
- Do **not** create a repo-local workflow agent unless I explicitly ask for one.

If `.github/copilot-instructions.md` already exists, merge the missing rules with the smallest possible change and preserve unrelated repo-specific instructions.

## Repo-Local Baseline Content

If `.github/copilot-instructions.md` does not exist, create it with this baseline content:

```md
# Project Workflow Conventions

## Speckit Awareness

- Treat Speckit as installed when the repo contains `.specify/` and Speckit agents or prompts under `.github/agents/` or `.github/prompts/`.
- When Speckit is installed, treat `specs/<feature>/discovery.md`, `spec.md`, `plan.md`, and `tasks.md` as the canonical feature artifacts when they exist.
- Do not create alternate feature specs, plans, or task lists under `team/` when canonical Speckit artifacts already exist.

## Agent Workflow

- Prefer the user-level `Orchestrator` agent for end-to-end feature coordination so stage transitions stay consistent.
- The full SDD cycle is: `Strategist -> feature start -> speckit.discover -> speckit.constitution -> speckit.specify -> Designer / speckit.design -> speckit.plan -> speckit.tasks -> speckit.analyze -> Backend Dev / UI Builder -> speckit.test -> Code Reviewer -> kite verify feature`.
- Use Strategist to explore and pressure-test ideas first. After approval, start the feature branch and active feature context, then route through `speckit.discover`, `speckit.constitution`, and `speckit.specify` before planning implementation.
- Designer runs **after** `speckit.specify` to create design direction and brand identity. Designer writes to `.specify/memory/design-direction.md`. UI Builder reads this during implementation.
- Backend Dev and UI Builder are the primary implementation agents.
- DevOps handles CI/CD, deployment, infrastructure, and production readiness.
- If Speckit is not installed yet and a durable idea note is useful before canonical discovery starts, store it under `team/agents/<agent-name>/YYYY-MM-DD-<feature-name>.md`.
- Once a feature direction is approved, align the feature branch with `.specify/feature.json`, then start the canonical front-of-lifecycle sequence with `speckit.discover`, `speckit.constitution`, and `speckit.specify`.
- Let Speckit own specification, clarification, planning, tasks, and consistency analysis.
- Do implementation work on the active feature branch and keep `main` as the merge target only after verification and review are complete.
- After `speckit.tasks`, implementation agents must execute from the active `tasks.md` and reference relevant FR IDs, user stories, or task IDs from the matching Speckit artifact set.
- After `speckit.tasks`, prefer `speckit.analyze` before implementation.
- After implementation, run `speckit.test` to verify all tests pass.
- After tests pass, prefer `Code Reviewer` before final verification or merge.

## Document Ownership

- `specs/<feature>/` is the source of truth for feature requirements, scope, technical plan, tasks, and feature-specific supporting artifacts produced by Speckit.
- `.specify/memory/design-direction.md` is the canonical design system and brand identity reference for UI implementation.
- `team/agents/<agent-name>/` is for agent-specific research, option analysis, design notes, handoff briefs, and implementation notes that support the work but are not the canonical feature contract.
- `docs/` is for durable repo-wide documentation that applies across multiple features.
- If a decision recorded in `team/agents/` becomes normative for delivery, promote it into the active Speckit artifact or a repo-wide doc instead of leaving it only in team notes.

## Efficiency Rules

- Prefer updating the current feature's existing Speckit files instead of duplicating summaries in multiple places.
- Team documents should summarize decisions, rationale, open questions, and implementation notes; they should not restate full requirements already captured in `spec.md`.
- If Speckit is not installed in a repo, fall back to `team/agents/<agent-name>/` for discovery notes, planning notes, and handoff material until a canonical workflow is established.
```

## Constraints

- Do not modify my user-level agents or prompt files.
- Do not create alternate repo-local specs, plans, or tasks outside the standard Speckit locations.
- Do not create `.github/agents/feature-workflow.agent.md` unless I explicitly ask for a repo-local workflow agent.
- Do not install optional Spec Kit extensions or presets unless the user explicitly asks.
- Do not treat an existing `.devcontainer/` as an automatic blocker.
- Do not replace existing repo-owned container files by default.
- If the workspace already has a conflicting orchestration system, surface the conflict before making destructive changes.

## Optional Brownfield Note

If the workspace is an existing codebase and the user explicitly wants architecture discovery or brownfield adoption help, you may mention the community brownfield bootstrap extension as an optional follow-up. Do not install it by default.

## Validation

Before finishing, verify:

- `.specify/` exists.
- At least one Speckit command file exists under `.github/agents/` or `.github/prompts/`.
- When the bundled Kite preset is present, `speckit.plan` exists locally and the default lifecycle does not require `speckit.brief`.
- If the local preset exists, `orchestrator-workflow` is installed.
- `.github/copilot-instructions.md` exists and includes the Speckit-awareness workflow rules.
- If the repo keeps an existing `.devcontainer/`, report whether it satisfies the minimum Kite container contract and list the exact commands you used to validate it.
- The instructions point this repo to the user-level `Orchestrator` agent rather than requiring a repo-local workflow agent.

## Final Response Format

Report:

1. The exact initialization command used.
2. Whether you used the bundled local Kite path or an upstream fallback.
3. Whether Spec Kit was newly initialized or already present.
4. Whether the `orchestrator-workflow` preset was installed, already present, or unavailable.
5. Whether an existing `.devcontainer/` was preserved and how you validated the minimum Kite container contract.
6. Which files were created or updated.
7. Any prerequisite or environment issues encountered.
8. The next commands I should run, usually:
   - `/speckit.discover`
   - `/speckit.constitution`
   - `/speckit.specify`
   - use `Orchestrator` for orchestration
```
