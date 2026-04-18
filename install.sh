#!/usr/bin/env bash

set -euo pipefail

default_repo="Karnonson/dev-env"
default_ref="main"
repo="$default_repo"
ref="$default_ref"

# Read pinned version from .speckit-version if available (local or downloaded source)
default_speckit_version="0.7.0"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$script_dir/.speckit-version" ]]; then
  default_speckit_version="$(tr -d '[:space:]' < "$script_dir/.speckit-version")"
fi
speckit_version="${DEV_ENV_SPECKIT_VERSION:-$default_speckit_version}"
force=0
with_speckit=0
dry_run=0
target_dir="."
source_dir="${DEV_ENV_SOURCE_DIR:-}"

usage() {
  cat <<'EOF'
Usage: install.sh [options] [target-directory]

Install the dev-env .devcontainer and .vscode-prompts assets into a target project.

Options:
  --force             Replace existing .devcontainer and .vscode-prompts
  --dry-run           Show what would be installed without writing anything
  --with-speckit      Initialize Spec Kit and install the bundled preset/workflow
  --speckit-version V Pin the Spec Kit CLI version used for bootstrap (default: 0.7.0)
  --ref REF           Git ref to download from (default: main)
  --repo OWNER/REPO   GitHub repo to download from (default: Karnonson/dev-env)
  --source-dir PATH   Use a local dev-env checkout instead of downloading
  -h, --help          Show this help text

Examples:
  ./install.sh .
  ./install.sh --dry-run .
  ./install.sh --with-speckit .
  ./install.sh --with-speckit --speckit-version 0.7.0 .
  ./install.sh --force ../my-project
  curl -fsSL https://raw.githubusercontent.com/Karnonson/dev-env/main/install.sh | bash -s -- .
EOF
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

get_local_specify_version() {
  if ! command -v specify >/dev/null 2>&1; then
    return
  fi

  specify version 2>/dev/null | sed -nE 's/.*CLI Version[[:space:]]+([0-9.]+).*/\1/p' | head -n 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      force=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --with-speckit)
      with_speckit=1
      shift
      ;;
    --speckit-version)
      speckit_version="${2:?Missing value for --speckit-version}"
      shift 2
      ;;
    --ref)
      ref="${2:?Missing value for --ref}"
      shift 2
      ;;
    --repo)
      repo="${2:?Missing value for --repo}"
      shift 2
      ;;
    --source-dir)
      source_dir="${2:?Missing value for --source-dir}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      target_dir="$1"
      shift
      ;;
  esac
done

if [[ $# -gt 0 ]]; then
  echo "Unexpected arguments: $*" >&2
  usage >&2
  exit 1
fi

target_dir="$(cd "$target_dir" 2>/dev/null && pwd || true)"

if [[ -z "$target_dir" || ! -d "$target_dir" ]]; then
  echo "Target directory does not exist." >&2
  exit 1
fi

temp_dir=""
archive_path=""
cleanup() {
  if [[ -n "$temp_dir" && -d "$temp_dir" ]]; then
    rm -rf "$temp_dir"
  fi
}
trap cleanup EXIT

find_first_extracted_dir() {
  find "$temp_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1
}

run_speckit() {
  local local_version

  if command -v specify >/dev/null 2>&1; then
    local_version="$(get_local_specify_version)"

    if [[ -z "$local_version" || "$local_version" == "$speckit_version" ]]; then
      specify "$@"
      return
    fi
  fi

  if command -v uvx >/dev/null 2>&1; then
    uvx --from "git+https://github.com/github/spec-kit.git@v${speckit_version}" specify "$@"
    return
  fi

  if command -v specify >/dev/null 2>&1; then
    echo "Warning: local Spec Kit version ${local_version:-unknown} does not match requested ${speckit_version}; using local specify because uvx is unavailable." >&2
    specify "$@"
    return
  fi

  echo "Spec Kit requires 'specify' or 'uvx' when --with-speckit is used." >&2
  exit 1
}

resolve_source_root() {
  if [[ -n "$source_dir" ]]; then
    local resolved_source
    resolved_source="$(cd "$source_dir" 2>/dev/null && pwd || true)"

    if [[ -z "$resolved_source" || ! -d "$resolved_source" ]]; then
      echo "Source directory does not exist: $source_dir" >&2
      exit 1
    fi

    printf '%s\n' "$resolved_source"
    return
  fi

  require_command curl
  require_command tar
  require_command mktemp

  temp_dir="$(mktemp -d)"
  archive_path="$temp_dir/dev-env.tar.gz"
  archive_url="https://github.com/${repo}/archive/${ref}.tar.gz"

  echo "Downloading ${repo}@${ref}..."
  curl -fsSL "$archive_url" -o "$archive_path"
  tar -xzf "$archive_path" -C "$temp_dir"

  find_first_extracted_dir
}

bootstrap_speckit() {
  local preset_dir workflow_path

  if [[ -d "$target_dir/.specify" ]]; then
    echo "Spec Kit already exists in $target_dir; skipping initialization."
  else
    (
      cd "$target_dir"
      run_speckit init --here --offline --ai copilot --script sh --force --branch-numbering sequential
    )
  fi

  preset_dir="spec-kit/presets/orchestrator-workflow"
  workflow_path="spec-kit/workflows/orchestrator-design-first.yml"

  if [[ -f "$target_dir/$preset_dir/preset.yml" ]]; then
    (
      cd "$target_dir"
      run_speckit preset add --dev "$preset_dir" --priority 1
    )
  fi

  if [[ -f "$target_dir/$workflow_path" ]]; then
    (
      cd "$target_dir"
      run_speckit workflow add "$workflow_path"
    )
  fi
}

source_root="$(resolve_source_root)"

# Validate source directories
for asset in .devcontainer .vscode-prompts spec-kit; do
  if [[ ! -d "$source_root/$asset" ]]; then
    echo "Missing required directory in source: $asset" >&2
    exit 1
  fi
done

# Collect all conflicts before failing
conflicts=()
for asset in .devcontainer .vscode-prompts spec-kit; do
  if [[ -e "$target_dir/$asset" && $force -ne 1 ]]; then
    conflicts+=("$target_dir/$asset")
  fi
done

if (( ${#conflicts[@]} )); then
  printf '%s already exists.\n' "${conflicts[@]}" >&2
  echo "Re-run with --force to replace." >&2
  exit 1
fi

# Dry-run: report what would happen and exit
if [[ $dry_run -eq 1 ]]; then
  echo "Dry run — the following would be installed into $target_dir:"
  for asset in .devcontainer .vscode-prompts spec-kit; do
    if [[ -e "$target_dir/$asset" ]]; then
      echo "  replace $asset"
    else
      echo "  create  $asset"
    fi
  done
  if [[ $with_speckit -eq 1 ]]; then
    if [[ -d "$target_dir/.specify" ]]; then
      echo "  skip    .specify (already exists)"
    else
      echo "  create  .specify (Spec Kit init)"
    fi
    echo "  install preset: orchestrator-workflow → .specify/presets/"
    echo "  install workflow: orchestrator-design-first → .specify/workflows/"
  fi
  exit 0
fi

# Copy assets to target
for asset in .devcontainer .vscode-prompts spec-kit; do
  if [[ -e "$target_dir/$asset" ]]; then
    rm -rf "$target_dir/$asset"
  fi

  cp -R "$source_root/$asset" "$target_dir/$asset"
done

if [[ $with_speckit -eq 1 ]]; then
  bootstrap_speckit
fi

echo "Installed dev-env into $target_dir"
if [[ $with_speckit -eq 1 ]]; then
  echo "Spec Kit bootstrap completed with version target $speckit_version."
fi
echo "Next: open the project in VS Code and run 'Dev Containers: Reopen in Container'."