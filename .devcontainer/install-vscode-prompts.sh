#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_dir="$script_dir/../.vscode-prompts"

if [[ ! -d "$source_dir" ]]; then
  echo "No VS Code prompt assets found at $source_dir"
  exit 0
fi

destinations=(
  "$HOME/.vscode-server/data/User/prompts"
  "$HOME/.vscode-server-insiders/data/User/prompts"
  "$HOME/.config/Code/User/prompts"
  "$HOME/.config/Code - Insiders/User/prompts"
)

copied_count=0

for destination in "${destinations[@]}"; do
  mkdir -p "$destination"

  while IFS= read -r -d '' file; do
    install -m 0644 "$file" "$destination/$(basename "$file")"
    copied_count=$((copied_count + 1))
  done < <(find "$source_dir" -maxdepth 1 -type f \( -name "*.agent.md" -o -name "*.instructions.md" -o -name "*.prompt.md" \) -print0 | sort -z)
done

echo "Installed $copied_count VS Code customization files across ${#destinations[@]} locations."