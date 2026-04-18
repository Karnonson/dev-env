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
temp_root="${TMPDIR:-/tmp}/dev-env-speckit-validate"
target_dir="$temp_root/project"

cleanup() {
  rm -rf "$temp_root"
}
trap cleanup EXIT

mkdir -p "$target_dir"

bash "$repo_root/install.sh" --with-speckit --speckit-version "$speckit_version" --source-dir "$repo_root" "$target_dir"

cd "$target_dir"

test -f .specify/presets/orchestrator-workflow/preset.yml
test -f .specify/workflows/orchestrator-design-first/workflow.yml
test -f .github/agents/speckit.constitution.agent.md
test -f .github/agents/speckit.design.agent.md
test -f .github/agents/speckit.implement.agent.md
test -d .specify
test -d .devcontainer
test -d .vscode-prompts
test -d spec-kit  # spec-kit should be copied to target for preset dev path

echo "Speckit validation passed for version $speckit_version"