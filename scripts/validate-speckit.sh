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
test -f .specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md
test -f .specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md
test -f .specify/workflows/orchestrator-design-first/workflow.yml
test -f .github/agents/speckit.constitution.agent.md
test -f .github/agents/speckit.design.agent.md
test -f .github/agents/speckit.implement.agent.md
test -d .specify
test -d .devcontainer
test -d .github/prompts
test -d .github/agents
test -d .github/instructions
test ! -d spec-kit

mkdir -p "$partial_target_dir/.specify/memory"
printf 'KEEP_ME\n' > "$partial_target_dir/.specify/memory/constitution.md"

if bash "$repo_root/install.sh" --with-speckit --speckit-version "$speckit_version" --source-dir "$repo_root" "$partial_target_dir"; then
  echo "Expected installer to refuse reinitializing an existing .specify tree without --force-speckit-init" >&2
  exit 1
fi

grep -qx 'KEEP_ME' "$partial_target_dir/.specify/memory/constitution.md"
test ! -d "$partial_target_dir/.devcontainer"
test ! -d "$partial_target_dir/.github/prompts"
test ! -d "$partial_target_dir/.github/agents"
test ! -d "$partial_target_dir/.github/instructions"

bash "$repo_root/install.sh" --with-speckit --force-speckit-init --speckit-version "$speckit_version" --source-dir "$repo_root" "$partial_target_dir"

test -f "$partial_target_dir/.github/agents/speckit.constitution.agent.md"
test -f "$partial_target_dir/.specify/presets/orchestrator-workflow/preset.yml"
test -f "$partial_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$partial_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"
test ! -d "$partial_target_dir/spec-kit"

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

if bash "$repo_root/.devcontainer/bin/kite" doctor --source-dir "$repo_root" "$cli_target_dir" > "$doctor_log"; then
  echo "Expected kite doctor to fail before Spec Kit bootstrap" >&2
  exit 1
fi

grep -q "Fix: kite install speckit --source-dir $repo_root $cli_target_dir" "$doctor_log"

bash "$repo_root/.devcontainer/bin/kite" status --source-dir "$repo_root" "$cli_target_dir" > "$status_log"
grep -q "Workspace status: current" "$status_log"
grep -q "Speckit status: action needed" "$status_log"

bash "$repo_root/.devcontainer/bin/kite" status --json --source-dir "$repo_root" "$cli_target_dir" > "$status_json_log"
grep -q '"workspaceStatus":"current"' "$status_json_log"
grep -q '"status":"action-needed"' "$status_json_log"

bash "$repo_root/.devcontainer/bin/kite" install speckit --source-dir "$repo_root" "$cli_target_dir"

test -f "$cli_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"
test -f "$cli_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$cli_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"

bash "$repo_root/.devcontainer/bin/kite" doctor --source-dir "$repo_root" "$cli_target_dir" > "$doctor_log"
grep -q "Doctor status: ready" "$doctor_log"

bash "$repo_root/.devcontainer/bin/kite" status --source-dir "$repo_root" "$cli_target_dir" > "$status_log"
grep -q "Workspace status: current" "$status_log"
grep -q "Speckit status: ready" "$status_log"

bash "$repo_root/.devcontainer/bin/kite" status --json --source-dir "$repo_root" "$cli_target_dir" > "$status_json_log"
grep -q '"state":"bootstrapped"' "$status_json_log"
grep -q '"status":"ready"' "$status_json_log"

rm -f "$cli_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.design.md"

if bash "$repo_root/.devcontainer/bin/kite" doctor --source-dir "$repo_root" "$cli_target_dir" > "$doctor_log"; then
  echo "Expected kite doctor to fail for a corrupted bundled Spec Kit state" >&2
  exit 1
fi

grep -q "bundled Spec Kit preset/workflow is incomplete" "$doctor_log"

bash "$repo_root/.devcontainer/bin/kite" status --source-dir "$repo_root" "$cli_target_dir" > "$status_log"
grep -q "Spec Kit: partial" "$status_log"
grep -q "Speckit status: action needed" "$status_log"

if bash "$repo_root/install.sh" --with-speckit --speckit-version "$speckit_version" --source-dir "$repo_root" "$cli_target_dir"; then
  echo "Expected installer to refuse a corrupted bundled Spec Kit state without --force-speckit-init" >&2
  exit 1
fi

mkdir -p "$update_target_dir"
bash "$repo_root/install.sh" --source-dir "$repo_root" "$update_target_dir"
rm -rf "$update_target_dir/.github/instructions"
printf 'stale\n' > "$update_target_dir/.github/prompts/stale.txt"

bash "$repo_root/.devcontainer/bin/kite" update workspace --dry-run --source-dir "$repo_root" "$update_target_dir" > "$dry_run_log"
test -f "$update_target_dir/.github/prompts/stale.txt"
grep -q "replace .github/prompts" "$dry_run_log"
grep -q "create  .github/instructions" "$dry_run_log"

bash "$repo_root/.devcontainer/bin/kite" update workspace --source-dir "$repo_root" "$update_target_dir"

test -d "$update_target_dir/.github/instructions"
test ! -f "$update_target_dir/.github/prompts/stale.txt"

bash "$repo_root/.devcontainer/bin/kite" update workspace --with-speckit --source-dir "$repo_root" "$update_target_dir"

test -f "$update_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"
test -f "$update_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$update_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"

bash "$repo_root/.devcontainer/bin/kite" help update workspace > "$status_log"
grep -q -- "--dry-run" "$status_log"

bash "$repo_root/.devcontainer/bin/kite" help doctor > "$status_log"
grep -q "Verify whether the target repo is ready" "$status_log"

bash "$repo_root/.devcontainer/bin/kite" help status > "$status_log"
grep -q -- "--json" "$status_log"

echo "Speckit validation passed for version $speckit_version"