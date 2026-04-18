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
bash "$repo_root/.devcontainer/bin/dev-env" install speckit --source-dir "$repo_root" "$cli_target_dir"

test -f "$cli_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"
test -f "$cli_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$cli_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"

mkdir -p "$update_target_dir"
bash "$repo_root/install.sh" --source-dir "$repo_root" "$update_target_dir"
rm -rf "$update_target_dir/.github/instructions"
printf 'stale\n' > "$update_target_dir/.github/prompts/stale.txt"

bash "$repo_root/.devcontainer/bin/dev-env" update workspace --source-dir "$repo_root" "$update_target_dir"

test -d "$update_target_dir/.github/instructions"
test ! -f "$update_target_dir/.github/prompts/stale.txt"

bash "$repo_root/.devcontainer/bin/dev-env" update workspace --with-speckit --source-dir "$repo_root" "$update_target_dir"

test -f "$update_target_dir/.specify/workflows/orchestrator-design-first/workflow.yml"
test -f "$update_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md"
test -f "$update_target_dir/.specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md"

echo "Speckit validation passed for version $speckit_version"