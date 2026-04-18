#!/usr/bin/env bash

set -euo pipefail

profile="${1:-}"

case "$profile" in
  base|python|typescript)
    ;;
  *)
    echo "Usage: bash .devcontainer/switch-profile.sh {base|python|typescript}" >&2
    exit 1
    ;;
esac

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_path="$script_dir/devcontainer.json"
current_target="$(sed -nE 's/.*"target": "([^"]+)".*/\1/p' "$config_path" | head -n 1)"

if [[ -z "$current_target" ]]; then
  echo "Could not find a build target in $config_path" >&2
  exit 1
fi

if [[ "$current_target" == "$profile" ]]; then
  echo "Dev container profile is already set to '$profile'."
  exit 0
fi

sed -i -E '0,/"target": "[^"]+"/s//"target": "'"$profile"'"/' "$config_path"

echo "Dev container profile set to '$profile'."
echo "Next: run 'Dev Containers: Rebuild Container'."