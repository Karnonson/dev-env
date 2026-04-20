#!/usr/bin/env python3
"""Fix run_release function — rewrite it completely with correct --confirm, --skip-checks gates"""
import re

with open("/home/karnon/Dev-FullStack/dev-env/.devcontainer/bin/kite", "r") as f:
    content = f.read()

# Find and replace the entire run_release function
old_fn = re.search(
    r'run_release\(\) \{.*?^  echo "Push with: git push origin \$default_branch --tags"\n\}',
    content, re.DOTALL | re.MULTILINE
)

if not old_fn:
    print("ERROR: Could not find run_release function boundaries")
    exit(1)

new_fn = r'''run_release() {
  local bump_type="patch" release_dry_run=0 confirm=0 skip_checks=0
  local version_info version_file current_version new_version tag_name

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --bump)
        bump_type="${2:?Missing value for --bump}"
        shift 2
        ;;
      --dry-run)
        release_dry_run=1
        shift
        ;;
      --confirm)
        confirm=1
        shift
        ;;
      --skip-checks)
        skip_checks=1
        shift
        ;;
      *) break ;;
    esac
  done

  case "$bump_type" in
    major|minor|patch) ;;
    *)
      echo "Unknown bump type: $bump_type (expected: major, minor, patch)" >&2
      return 1
      ;;
  esac

  echo "Release target: $target_dir"

  if ! command -v git >/dev/null 2>&1 || ! git -C "$target_dir" rev-parse --git-dir >/dev/null 2>&1; then
    echo "[warn] Not a git repository"
    return 1
  fi

  local current_branch
  current_branch="$(git -C "$target_dir" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
  local default_branch
  default_branch="$(default_branch_name "$target_dir")"

  if [[ "$current_branch" != "$default_branch" ]]; then
    echo "[warn] Releases should be cut from $default_branch (currently on $current_branch)"
    return 1
  fi

  if [[ -n "$(git -C "$target_dir" status --porcelain)" ]]; then
    echo "[warn] Working tree is not clean; commit changes first"
    return 1
  fi

  version_info="$(bump_version "$bump_type")"
  if [[ -z "$version_info" ]]; then
    return 1
  fi

  read -r version_file current_version new_version _ <<< "$version_info"
  tag_name="v$new_version"

  echo "Version source: $version_file"
  echo "Current version: $current_version"
  echo "New version: $new_version ($bump_type bump)"
  echo "Tag: $tag_name"

  if [[ $release_dry_run -eq 1 ]]; then
    echo ""
    echo "Dry run - no changes written"
    return 0
  fi

  if [[ $confirm -ne 1 ]]; then
    echo ""
    echo "Dry run (default). To apply this release, re-run with --confirm."
    return 0
  fi

  # Pre-release verification gates
  if [[ $skip_checks -ne 1 ]]; then
    echo ""
    echo "Running pre-release checks..."

    echo ""
    if ! run_test; then
      echo ""
      echo "[error] Tests failed. Fix before releasing, or use --skip-checks to bypass."
      return 1
    fi

    echo ""
    if ! run_audit; then
      echo ""
      echo "[warn] Audit has findings. Review before releasing, or use --skip-checks to bypass."
      return 1
    fi

    echo ""
    echo "Pre-release checks passed."
  fi

  # Update version in source file
  case "$version_file" in
    package.json)
      (cd "$target_dir" && node -e "
        const fs = require('fs');
        const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
        pkg.version = '$new_version';
        fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
      ")
      ;;
    pyproject.toml)
      sed -i "s/^version = \"$current_version\"/version = \"$new_version\"/" "$target_dir/pyproject.toml"
      ;;
    VERSION)
      printf '%s\n' "$new_version" > "$target_dir/VERSION"
      ;;
  esac

  # Update CHANGELOG.md if it exists
  if [[ -f "$target_dir/CHANGELOG.md" ]]; then
    local release_date
    release_date="$(date +%Y-%m-%d)"
    sed -i "s/^## \[Unreleased\]/## [Unreleased]\n\n## [$new_version] - $release_date/" "$target_dir/CHANGELOG.md"
  fi

  git -C "$target_dir" add -A
  git -C "$target_dir" commit -m "release: v$new_version"
  git -C "$target_dir" tag -a "$tag_name" -m "Release $tag_name"

  echo ""
  echo "Release $tag_name created"
  echo "Push with: git push origin $default_branch --tags"
}'''

content = content[:old_fn.start()] + new_fn + content[old_fn.end():]

with open("/home/karnon/Dev-FullStack/dev-env/.devcontainer/bin/kite", "w") as f:
    f.write(content)

print("run_release function rewritten successfully")
