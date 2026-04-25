#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"

# Read pinned version from .speckit-version
default_speckit_version="0.7.0"
if [[ -f "$repo_root/.speckit-version" ]]; then
  default_speckit_version="$(tr -d '[:space:]' < "$repo_root/.speckit-version")"
fi
speckit_version="${DEV_ENV_SPECKIT_VERSION:-$default_speckit_version}"
temp_root="$(mktemp -d "${TMPDIR:-/tmp}/dev-env-speckit-validate.XXXXXX")"
target_dir="$temp_root/project"
partial_target_dir="$temp_root/partial-project"
archive_target_dir="$temp_root/archive-project"
archive_path="$temp_root/dev-env.tar.gz"
archive_manifest="$temp_root/archive-files.txt"
cli_target_dir="$temp_root/cli-project"
update_target_dir="$temp_root/update-project"
verify_target_dir="$temp_root/verify-project"
doctor_log="$temp_root/doctor.log"
status_log="$temp_root/status.log"
dry_run_log="$temp_root/update-dry-run.log"
status_json_log="$temp_root/status.json"

cleanup() {
  rm -rf "$temp_root"
}
trap cleanup EXIT

mkdir -p "$target_dir"

bash "$repo_root/install.sh" --with-speckit --speckit-version "$speckit_version" --source-dir "$repo_root" "$target_dir"

cd "$target_dir"

test -f .specify/presets/orchestrator-workflow/preset.yml
test -f .specify/presets/orchestrator-workflow/commands/speckit.discover.md
test -f .specify/presets/orchestrator-workflow/commands/speckit.plan.md
test -f .specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md
test -f .specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md
test -f .specify/presets/orchestrator-workflow/commands/speckit.test.md
test -f .specify/workflows/orchestrator-design-first/workflow.yml
test -f .specify/templates/artifact-front-matter.md
test -f .specify/templates/discovery.md
test -f .specify/templates/constitution.md
test -f .specify/templates/design-direction.md
test -f .specify/templates/plan.md
test -f .specify/templates/test-results.md
test -f .github/agents/speckit.constitution.agent.md
test -f .github/agents/speckit.design.agent.md
test -f .github/agents/speckit.implement.agent.md
grep -q "feature branch" .specify/presets/orchestrator-workflow/commands/speckit.implement.md
grep -q "Merge to \`main\` only" .specify/presets/orchestrator-workflow/commands/speckit.implement.md
grep -q "market-validation.md" .specify/presets/orchestrator-workflow/commands/speckit.discover.md
grep -q "command: speckit.discover" .specify/workflows/orchestrator-design-first/workflow.yml
grep -q "command: speckit.plan" .specify/workflows/orchestrator-design-first/workflow.yml
grep -q "id: start-feature" .specify/workflows/orchestrator-design-first/workflow.yml
test -d .specify
test -d .devcontainer
test ! -f .devcontainer/switch-profile.sh
test -d .github/prompts
test -d .github/agents
test -d .github/instructions
test -f .github/copilot-instructions.md
test ! -d spec-kit

mkdir -p "$partial_target_dir/.specify/memory"
printf 'KEEP_ME\n' > "$partial_target_dir/.specify/memory/constitution.md"
mkdir -p "$partial_target_dir/.devcontainer"
printf '{"name":"existing"}\n' > "$partial_target_dir/.devcontainer/devcontainer.json"
mkdir -p "$partial_target_dir/.github/instructions"
printf 'KEEP_AGENT_RULES\n' > "$partial_target_dir/.github/instructions/AI Agent Development.instructions.md"
mkdir -p "$partial_target_dir/.github"
printf 'KEEP_COPILOT_RULES\n' > "$partial_target_dir/.github/copilot-instructions.md"

bash "$repo_root/install.sh" --with-speckit --speckit-version "$speckit_version" --source-dir "$repo_root" "$partial_target_dir"

grep -qx 'KEEP_ME' "$partial_target_dir/.specify/memory/constitution.md"
grep -qx '{"name":"existing"}' "$partial_target_dir/.devcontainer/devcontainer.json"
test -f "$partial_target_dir/.devcontainer/bin/kite"
test -f "$partial_target_dir/.devcontainer/kite-post-create.sh"
test -f "$partial_target_dir/.devcontainer/README.kite.md"
grep -qx 'KEEP_AGENT_RULES' "$partial_target_dir/.github/instructions/AI Agent Development.instructions.md"
grep -qx 'KEEP_COPILOT_RULES' "$partial_target_dir/.github/copilot-instructions.md"
test -d "$partial_target_dir/.devcontainer"
test -d "$partial_target_dir/.github/prompts"
test -d "$partial_target_dir/.github/agents"
test -d "$partial_target_dir/.github/instructions"
test -f "$partial_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.design.md"
test -f "$partial_target_dir/.specify/templates/design-direction.md"

(
  cd "$partial_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" status --source-dir "$repo_root" > "$status_log"
)
grep -q "Workspace status: current" "$status_log"
grep -q "Speckit status: ready" "$status_log"

bash "$repo_root/install.sh" --force --with-speckit --force-speckit-init --speckit-version "$speckit_version" --source-dir "$repo_root" "$partial_target_dir"

test -f "$partial_target_dir/.github/agents/speckit.constitution.agent.md"
test -f "$partial_target_dir/.specify/presets/orchestrator-workflow/preset.yml"
test -f "$partial_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$partial_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"
test ! -d "$partial_target_dir/spec-kit"

printf 'STALE PLAN TEMPLATE\n' > "$partial_target_dir/.specify/templates/plan.md"
printf 'STALE PROMPT\n' > "$partial_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.plan.md"
printf 'STALE WORKFLOW\n' > "$partial_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"

bash "$repo_root/install.sh" --with-speckit --speckit-version "$speckit_version" --source-dir "$repo_root" "$partial_target_dir"

test ! -f "$partial_target_dir/spec-kit"
grep -q "Plan-First Rule" "$partial_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.plan.md"
grep -q "Plan Artifact Template" "$partial_target_dir/.specify/templates/plan.md"
grep -q 'id: "orchestrator-design-first"' "$partial_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"

mkdir -p "$archive_target_dir"
while IFS= read -r -d '' repo_file; do
  if [[ -e "$repo_root/$repo_file" ]]; then
    printf '%s\0' "$repo_file" >> "$archive_manifest"
  fi
done < <(git -C "$repo_root" ls-files --cached --others --exclude-standard -z)

tar -czf "$archive_path" -C "$repo_root" --null -T "$archive_manifest" --transform "s|^|$(basename "$repo_root")/|"
DEV_ENV_ARCHIVE_URL="file://$archive_path" bash "$repo_root/install.sh" --with-speckit --speckit-version "$speckit_version" "$archive_target_dir"

test -f "$archive_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"
test -f "$archive_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$archive_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"

mkdir -p "$cli_target_dir"
bash "$repo_root/install.sh" --source-dir "$repo_root" "$cli_target_dir"

(
  cd "$cli_target_dir"
  if bash "$repo_root/.devcontainer/bin/kite" doctor --source-dir "$repo_root" > "$doctor_log"; then
    echo "Expected kite doctor to fail before Spec Kit bootstrap" >&2
    exit 1
  fi
)

grep -q "Fix: kite install speckit --source-dir $repo_root" "$doctor_log"

(
  cd "$cli_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" status --source-dir "$repo_root" > "$status_log"
)
grep -q "Workspace status: current" "$status_log"
grep -q "Speckit status: action needed" "$status_log"

(
  cd "$cli_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" status --json --source-dir "$repo_root" > "$status_json_log"
)
grep -q '"workspaceStatus":"current"' "$status_json_log"
grep -q '"status":"action-needed"' "$status_json_log"

(
  cd "$cli_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" install speckit --source-dir "$repo_root"
)

test -f "$cli_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"
test -f "$cli_target_dir/.specify/templates/plan.md"
test -f "$cli_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$cli_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"

(
  cd "$cli_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" doctor --source-dir "$repo_root" > "$doctor_log"
)
grep -q "Doctor status: ready" "$doctor_log"

(
  cd "$cli_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" status --source-dir "$repo_root" > "$status_log"
)
grep -q "Workspace status: current" "$status_log"
grep -q "Speckit status: ready" "$status_log"

(
  cd "$cli_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" status --json --source-dir "$repo_root" > "$status_json_log"
)
grep -q '"state":"bootstrapped"' "$status_json_log"
grep -q '"status":"ready"' "$status_json_log"

rm -f "$cli_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.test.md"

(
  cd "$cli_target_dir"
  if bash "$repo_root/.devcontainer/bin/kite" doctor --source-dir "$repo_root" > "$doctor_log"; then
    echo "Expected kite doctor to fail for a corrupted bundled Spec Kit state" >&2
    exit 1
  fi
)

grep -q "bundled Spec Kit preset/workflow is incomplete" "$doctor_log"

(
  cd "$cli_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" status --source-dir "$repo_root" > "$status_log"
)
grep -q "Spec Kit: partial" "$status_log"
grep -q "Speckit status: action needed" "$status_log"

bash "$repo_root/install.sh" --speckit-only --with-speckit --speckit-version "$speckit_version" --source-dir "$repo_root" "$cli_target_dir"

(
  cd "$cli_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" doctor --source-dir "$repo_root" > "$doctor_log"
)
grep -q "Doctor status: ready" "$doctor_log"

mkdir -p "$update_target_dir"
bash "$repo_root/install.sh" --source-dir "$repo_root" "$update_target_dir"
rm -rf "$update_target_dir/.github/instructions"
printf 'stale\n' > "$update_target_dir/.github/prompts/stale.txt"

(
  cd "$update_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" update workspace --dry-run --source-dir "$repo_root" > "$dry_run_log"
)
test -f "$update_target_dir/.github/prompts/stale.txt"
grep -q "replace .github/prompts" "$dry_run_log"
grep -q "create  .github/instructions" "$dry_run_log"

(
  cd "$update_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" update workspace --source-dir "$repo_root"
)

test -d "$update_target_dir/.github/instructions"
test ! -f "$update_target_dir/.github/prompts/stale.txt"

(
  cd "$update_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" update workspace --with-speckit --source-dir "$repo_root"
)

test -f "$update_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"
test -f "$update_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$update_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"

(
  cd "$update_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" > "$status_log"
)
grep -q "container-native Speckit workflow" "$status_log"
grep -q "work on a feature branch" "$status_log"
if grep -q "new <name>" "$status_log"; then
  echo "Unexpected legacy new <name> hint in kite status output" >&2
  exit 1
fi

(
  cd "$update_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" help update workspace > "$status_log"
)
grep -q -- "--dry-run" "$status_log"

(
  cd "$update_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" help doctor > "$status_log"
)
grep -q "Verify whether the target repo is ready" "$status_log"

(
  cd "$update_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" help status > "$status_log"
)
grep -q -- "--json" "$status_log"

(
  cd "$update_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" help test > "$status_log"
)
grep -q -- "--tier" "$status_log"
grep -q -- "--profile" "$status_log"

bash "$repo_root/.devcontainer/bin/kite" completion bash > "$status_log"
grep -q "complete -F _kite_completion kite" "$status_log"

mkdir -p "$verify_target_dir"
git init --initial-branch main "$verify_target_dir" >/dev/null 2>&1
printf 'base\n' > "$verify_target_dir/README.md"
git -C "$verify_target_dir" add README.md
git -C "$verify_target_dir" -c user.name='Test User' -c user.email='test@example.com' commit -m 'Initial commit' >/dev/null

bash "$repo_root/install.sh" --with-speckit --source-dir "$repo_root" "$verify_target_dir"
git -C "$verify_target_dir" add .
git -C "$verify_target_dir" -c user.name='Test User' -c user.email='test@example.com' commit -m 'Bootstrap dev-env' >/dev/null
git -C "$verify_target_dir" switch -c 001-verify-flow >/dev/null

mkdir -p "$verify_target_dir/specs/001-verify-flow"
printf -- '- [x] Verification task\n' > "$verify_target_dir/specs/001-verify-flow/tasks.md"
printf 'feature work\n' > "$verify_target_dir/feature.txt"
git -C "$verify_target_dir" add specs/001-verify-flow/tasks.md feature.txt
git -C "$verify_target_dir" -c user.name='Test User' -c user.email='test@example.com' commit -m 'Feature work' >/dev/null

(
  cd "$verify_target_dir"
  bash "$repo_root/.devcontainer/bin/kite" verify feature > "$doctor_log"
)
grep -q "active feature branch: 001-verify-flow" "$doctor_log"
grep -q "tracked tasks are complete in specs/001-verify-flow/tasks.md" "$doctor_log"
grep -q "Verification status: ready for merge review" "$doctor_log"

git init --initial-branch master "$temp_root/master-branch-repo" >/dev/null 2>&1
bash "$repo_root/install.sh" --with-speckit --source-dir "$repo_root" "$temp_root/master-branch-repo"
test "$(git -C "$temp_root/master-branch-repo" symbolic-ref --short HEAD)" = "main"
test "$(git -C "$temp_root/master-branch-repo" config --local init.defaultBranch)" = "main"

echo "Speckit validation passed for version $speckit_version"


post_create_target_dir="$temp_root/post-create-project"
mkdir -p "$post_create_target_dir"
(
  cd "$post_create_target_dir"
  WORKSPACE_FOLDER="$post_create_target_dir" \
  KITE_SKIP_NODE_BOOTSTRAP=1 KITE_SKIP_UV_BOOTSTRAP=1 KITE_SKIP_KITE_INSTALL=1 \
    bash "$repo_root/.devcontainer/post-create.sh"
)

git -C "$post_create_target_dir" rev-parse --git-dir >/dev/null
grep -q '^ref: refs/heads/main$' <(git -C "$post_create_target_dir" symbolic-ref HEAD)
