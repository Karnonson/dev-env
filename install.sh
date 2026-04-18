#!/usr/bin/env bash

set -euo pipefail

default_repo="Karnonson/dev-env"
default_ref="main"
repo="$default_repo"
ref="$default_ref"
force=0
target_dir="."
source_dir="${DEV_ENV_SOURCE_DIR:-}"

usage() {
  cat <<'EOF'
Usage: install.sh [options] [target-directory]

Install the dev-env .devcontainer and .vscode-prompts into a target project.

Options:
  --force             Replace existing .devcontainer and .vscode-prompts
  --ref REF           Git ref to download from (default: main)
  --repo OWNER/REPO   GitHub repo to download from (default: Karnonson/dev-env)
  --source-dir PATH   Use a local dev-env checkout instead of downloading
  -h, --help          Show this help text

Examples:
  ./install.sh .
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

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      force=1
      shift
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
cleanup() {
  if [[ -n "$temp_dir" && -d "$temp_dir" ]]; then
    rm -rf "$temp_dir"
  fi
}
trap cleanup EXIT

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

  find "$temp_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1
}

source_root="$(resolve_source_root)"

for asset in .devcontainer .vscode-prompts; do
  if [[ ! -d "$source_root/$asset" ]]; then
    echo "Missing required directory in source: $asset" >&2
    exit 1
  fi

  if [[ -e "$target_dir/$asset" && $force -ne 1 ]]; then
    echo "$target_dir/$asset already exists. Re-run with --force to replace it." >&2
    exit 1
  fi
done

for asset in .devcontainer .vscode-prompts; do
  if [[ -e "$target_dir/$asset" ]]; then
    rm -rf "$target_dir/$asset"
  fi

  cp -R "$source_root/$asset" "$target_dir/$asset"
done

echo "Installed dev-env into $target_dir"
echo "Next: open the project in VS Code and run 'Dev Containers: Reopen in Container'."