#!/usr/bin/env bash

set -euo pipefail

default_repo="Karnonson/dev-env"
default_ref="main"
repo="$default_repo"
ref="$default_ref"
force=0
with_speckit=0
dry_run=0
force_speckit_init=0
speckit_only=0
target_dir="."
source_dir="${DEV_ENV_SOURCE_DIR:-}"
default_speckit_version="0.7.0"
speckit_version=""
bootstrap_temp_dir=""

usage() {
  cat <<EOF
Usage: install.sh [options] [target-directory]

Install the dev-env .devcontainer and workspace chat customization assets into a target project.

Options:
  --force             Replace existing workspace assets (.devcontainer, .github/*, docs/errors); preserve repo-local .kite/config.yml
  --dry-run           Show what would be installed without writing anything
  --with-speckit      Initialize Spec Kit and install the bundled preset/workflow
  --speckit-only      Only install Spec Kit assets; do not copy dev-env workspace files
  --force-speckit-init Reinitialize Spec Kit when .specify already exists
  --speckit-version V Pin the Spec Kit CLI version used for bootstrap (default: $default_speckit_version)
  --ref REF           Git ref to download from (default: main)
  --repo OWNER/REPO   GitHub repo to download from (default: Karnonson/dev-env)
  --source-dir PATH   Use a local dev-env checkout instead of downloading
  -h, --help          Show this help text

Examples:
  ./install.sh .
  ./install.sh --dry-run .
  ./install.sh --with-speckit .
  ./install.sh --with-speckit --force-speckit-init .
  ./install.sh --with-speckit --speckit-only .
  ./install.sh --with-speckit --speckit-version $default_speckit_version .
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

has_speckit_templates() {
  local required_file
  local required_files=(
    .specify/presets/orchestrator-workflow/preset.yml
    .specify/presets/orchestrator-workflow/commands/speckit.discover.md
    .specify/presets/orchestrator-workflow/commands/speckit.brief.md
    .specify/presets/orchestrator-workflow/commands/speckit.constitution.md
    .specify/presets/orchestrator-workflow/commands/speckit.design.md
    .specify/presets/orchestrator-workflow/commands/speckit.implement.md
    .specify/presets/orchestrator-workflow/commands/speckit.implement.backend.md
    .specify/presets/orchestrator-workflow/commands/speckit.implement.ui.md
    .specify/presets/orchestrator-workflow/commands/speckit.test.md
    .specify/workflows/orchestrator-design-first/workflow.yml
    .github/agents/speckit.constitution.agent.md
    .github/agents/speckit.design.agent.md
    .github/agents/speckit.implement.agent.md
  )

  for required_file in "${required_files[@]}"; do
    if [[ ! -f "$target_dir/$required_file" ]]; then
      return 1
    fi
  done

  return 0
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
    --speckit-only)
      speckit_only=1
      shift
      ;;
    --force-speckit-init)
      force_speckit_init=1
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

if [[ $speckit_only -eq 1 && $with_speckit -ne 1 ]]; then
  echo "--speckit-only requires --with-speckit." >&2
  exit 1
fi

if ! target_dir="$(cd -- "$target_dir" 2>/dev/null && pwd)"; then
  echo "Target directory does not exist." >&2
  exit 1
fi

temp_dir=""
archive_path=""
cleanup() {
  if [[ -n "$temp_dir" && -d "$temp_dir" ]]; then
    rm -rf "$temp_dir"
  fi
  if [[ -n "$bootstrap_temp_dir" && -d "$bootstrap_temp_dir" ]]; then
    rm -rf "$bootstrap_temp_dir"
  fi
}
trap cleanup EXIT

asset_merges_missing_by_default() {
  case "$1" in
    .github/prompts|.github/agents|.github/instructions|.github/copilot-instructions.md|docs/errors)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

merge_missing_tree() {
  local source_path="$1"
  local target_path="$2"
  local source_entry rel_path target_entry

  mkdir -p "$target_path"

  while IFS= read -r -d '' source_entry; do
    rel_path="${source_entry#"$source_path"/}"
    target_entry="$target_path/$rel_path"

    if [[ -d "$source_entry" ]]; then
      mkdir -p "$target_entry"
    elif [[ ! -e "$target_entry" ]]; then
      mkdir -p "$(dirname "$target_entry")"
      cp -R "$source_entry" "$target_entry"
    fi
  done < <(find "$source_path" -mindepth 1 -print0)
}

replace_tree() {
  local source_path="$1"
  local target_path="$2"

  rm -rf "$target_path"
  mkdir -p "$(dirname "$target_path")"
  cp -R "$source_path" "$target_path"
}

merge_missing_file() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"
  if [[ ! -f "$target_path" ]]; then
    cp "$source_path" "$target_path"
  fi
}

sync_repo_local_kite_config() {
  local source_config_dir="$1/.kite"
  local target_config_dir="$2/.kite"

  if [[ ! -d "$source_config_dir" ]]; then
    return
  fi

  merge_missing_tree "$source_config_dir" "$target_config_dir"
}

ensure_git_main_branch_preference() {
  local current_branch

  if ! command -v git >/dev/null 2>&1; then
    return
  fi

  if ! git -C "$target_dir" rev-parse --git-dir >/dev/null 2>&1; then
    return
  fi

  git -C "$target_dir" config --local init.defaultBranch main || true

  current_branch="$(git -C "$target_dir" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
  if [[ "$current_branch" == "master" ]] && ! git -C "$target_dir" rev-parse --verify HEAD >/dev/null 2>&1; then
    git -C "$target_dir" branch -m master main || true
  fi
}

replace_matching_files() {
  local source_dir="$1"
  local target_dir_path="$2"
  local pattern="$3"

  mkdir -p "$target_dir_path"
  find "$target_dir_path" -maxdepth 1 -type f -name "$pattern" -delete
  find "$source_dir" -maxdepth 1 -type f -name "$pattern" -exec cp {} "$target_dir_path/" \;
}

stage_speckit_bootstrap() {
  local preset_dir="$1"
  local workflow_path="$2"

  bootstrap_temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/dev-env-speckit-init.XXXXXX")"

  (
    cd "$bootstrap_temp_dir"
    run_speckit init --here --offline --ai copilot --script sh --force --branch-numbering sequential
    if [[ -f "$preset_dir/preset.yml" ]]; then
      run_speckit preset add --dev "$preset_dir" --priority 1
    fi
    if [[ -f "$workflow_path" ]]; then
      run_speckit workflow add "$workflow_path"
    fi
  )
}

sync_staged_speckit_bootstrap() {
  if [[ $force_speckit_init -eq 1 ]]; then
    replace_tree "$bootstrap_temp_dir/.specify" "$target_dir/.specify"
    if [[ -d "$bootstrap_temp_dir/.github/agents" ]]; then
      replace_matching_files "$bootstrap_temp_dir/.github/agents" "$target_dir/.github/agents" 'speckit*.agent.md'
    fi
    if [[ -d "$bootstrap_temp_dir/.github/prompts" ]]; then
      replace_matching_files "$bootstrap_temp_dir/.github/prompts" "$target_dir/.github/prompts" 'speckit*.prompt.md'
    fi
    return
  fi

  if [[ -d "$bootstrap_temp_dir/.specify" ]]; then
    merge_missing_tree "$bootstrap_temp_dir/.specify" "$target_dir/.specify"
  fi
  if [[ -d "$bootstrap_temp_dir/.github/agents" ]]; then
    merge_missing_tree "$bootstrap_temp_dir/.github/agents" "$target_dir/.github/agents"
  fi
  if [[ -d "$bootstrap_temp_dir/.github/prompts" ]]; then
    merge_missing_tree "$bootstrap_temp_dir/.github/prompts" "$target_dir/.github/prompts"
  fi
}

find_extracted_source_root() {
  local devcontainer_dir extracted_root

  devcontainer_dir="$(find "$temp_dir" -mindepth 2 -maxdepth 4 -type d -name .devcontainer | head -n 1 || true)"
  if [[ -n "$devcontainer_dir" ]]; then
    dirname "$devcontainer_dir"
    return
  fi

  extracted_root="$(find "$temp_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  if [[ -z "$extracted_root" ]]; then
    echo "Failed to locate source root in downloaded archive." >&2
    exit 1
  fi

  printf '%s\n' "$extracted_root"
}

run_speckit() {
  local local_version

  local_version="$(get_local_specify_version)"

  if command -v specify >/dev/null 2>&1; then
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

  echo "Spec Kit requires 'specify' or 'uvx' to run. If you don't have 'uv' on your host machine, you can run this script again from inside the dev container after it finishes building!" >&2
  exit 1
}

resolve_source_root() {
  if [[ -n "$source_dir" ]]; then
    local resolved_source

    if ! resolved_source="$(cd -- "$source_dir" 2>/dev/null && pwd)"; then
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
  archive_url="${DEV_ENV_ARCHIVE_URL:-https://github.com/${repo}/archive/${ref}.tar.gz}"

  echo "Downloading ${repo}@${ref}..." >&2
  curl -fsSL "$archive_url" -o "$archive_path"
  tar -xzf "$archive_path" -C "$temp_dir"

  find_extracted_source_root
}

bootstrap_speckit() {
  local preset_dir workflow_path

  if has_speckit_templates && [[ $force_speckit_init -ne 1 ]]; then
    echo "Spec Kit already exists in $target_dir; skipping initialization."
  else
    preset_dir="$source_root/spec-kit/presets/orchestrator-workflow"
    workflow_path="$source_root/spec-kit/workflows/orchestrator-design-first.yml"
    stage_speckit_bootstrap "$preset_dir" "$workflow_path"
    sync_staged_speckit_bootstrap
  fi

  ensure_git_main_branch_preference
}

source_root="$(resolve_source_root)"

if [[ -f "$source_root/.speckit-version" ]]; then
  default_speckit_version="$(tr -d '[:space:]' < "$source_root/.speckit-version")"
fi

if [[ -z "$speckit_version" ]]; then
  speckit_version="${DEV_ENV_SPECKIT_VERSION:-$default_speckit_version}"
fi

load_asset_manifest() {
  local manifest_path="$1"
  assets=()
  if [[ -f "$manifest_path" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      line="${line%%#*}"
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      [[ -z "$line" ]] && continue
      assets+=("$line")
    done < "$manifest_path"
  else
    assets=(
      .devcontainer
      .github/prompts
      .github/agents
      .github/instructions
      .github/copilot-instructions.md
    )
  fi
}

load_asset_manifest "$source_root/.dev-env-assets"

# Validate source assets
if [[ $speckit_only -ne 1 ]]; then
  for asset in "${assets[@]}"; do
    if [[ ! -e "$source_root/$asset" ]]; then
      echo "Missing required asset in source: $asset" >&2
      exit 1
    fi
  done
fi

if [[ $with_speckit -eq 1 && ! -d "$source_root/spec-kit" ]]; then
  echo "Missing required directory in source: spec-kit (needed for --with-speckit)" >&2
  exit 1
fi

# Dry-run: report what would happen and exit
if [[ $dry_run -eq 1 ]]; then
  echo "Dry run - the following would be installed into $target_dir:"
  if [[ $speckit_only -ne 1 ]]; then
    for asset in "${assets[@]}"; do
      if [[ -e "$target_dir/$asset" && $force -eq 1 ]]; then
        echo "  replace $asset"
      elif [[ -e "$target_dir/$asset" ]] && asset_merges_missing_by_default "$asset"; then
        echo "  merge   $asset"
      elif [[ -e "$target_dir/$asset" ]]; then
        echo "  conflict $asset"
      else
        echo "  create  $asset"
      fi
    done
    if [[ -d "$source_root/.kite" ]]; then
      if [[ -e "$target_dir/.kite" ]]; then
        echo "  merge   .kite"
      else
        echo "  create  .kite"
      fi
    fi
  fi
  if [[ $with_speckit -eq 1 ]]; then
    if has_speckit_templates && [[ $force_speckit_init -ne 1 ]]; then
      echo "  skip    .specify bootstrap (already initialized)"
    elif [[ $force_speckit_init -eq 1 ]]; then
      echo "  replace .specify bootstrap files via specify init --force"
    else
      echo "  merge   missing .specify and Speckit .github files via specify init"
    fi
    if [[ $force_speckit_init -eq 1 ]]; then
      echo "  replace preset: orchestrator-workflow -> .specify/presets/"
      echo "  replace workflow: orchestrator-design-first -> .specify/workflows/"
    else
      echo "  merge   preset: orchestrator-workflow -> .specify/presets/"
      echo "  merge   workflow: orchestrator-design-first -> .specify/workflows/"
    fi
  fi
  exit 0
fi

if [[ $speckit_only -ne 1 ]]; then
  # Collect all conflicts before failing
  conflicts=()
  for asset in "${assets[@]}"; do
    if [[ -e "$target_dir/$asset" && $force -ne 1 ]] && ! asset_merges_missing_by_default "$asset"; then
      conflicts+=("$target_dir/$asset")
    fi
  done

  if (( ${#conflicts[@]} )); then
    printf '%s already exists.\n' "${conflicts[@]}" >&2
    echo "Re-run with --force to replace." >&2
    exit 1
  fi

  # Copy assets to target
  for asset in "${assets[@]}"; do
    if asset_merges_missing_by_default "$asset" && [[ $force -ne 1 ]]; then
      if [[ -d "$source_root/$asset" ]]; then
        if [[ -d "$target_dir/$asset" ]]; then
          merge_missing_tree "$source_root/$asset" "$target_dir/$asset"
        else
          mkdir -p "$(dirname "$target_dir/$asset")"
          cp -R "$source_root/$asset" "$target_dir/$asset"
        fi
      else
        merge_missing_file "$source_root/$asset" "$target_dir/$asset"
      fi
      continue
    fi

    if [[ -e "$target_dir/$asset" ]]; then
      rm -rf "${target_dir:?}/$asset"
    fi

    mkdir -p "$(dirname "$target_dir/$asset")"
    cp -R "$source_root/$asset" "$target_dir/$asset"
  done

  sync_repo_local_kite_config "$source_root" "$target_dir"
fi

if [[ $with_speckit -eq 1 ]]; then
  bootstrap_speckit
fi

# Write installed version stamp
if [[ $speckit_only -ne 1 ]]; then
  local_sha=""
  if command -v git >/dev/null 2>&1 && git -C "$source_root" rev-parse --git-dir >/dev/null 2>&1; then
    local_sha="$(git -C "$source_root" rev-parse --short HEAD 2>/dev/null || true)"
  fi
  {
    printf 'ref=%s\n' "$ref"
    printf 'repo=%s\n' "$repo"
    printf 'sha=%s\n' "${local_sha:-unknown}"
    printf 'date=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } > "$target_dir/.dev-env-version"
fi

if [[ $speckit_only -eq 1 ]]; then
  echo "Installed Spec Kit customization into $target_dir"
else
  echo "Installed dev-env into $target_dir"
fi
if [[ $with_speckit -eq 1 ]]; then
  echo "Spec Kit bootstrap completed with version target $speckit_version."
fi
if [[ $speckit_only -eq 0 ]]; then
  echo "Next: open the project in VS Code and run 'Dev Containers: Reopen in Container'."
fi