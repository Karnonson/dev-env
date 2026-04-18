#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source_dir="$script_dir/../.vscode-prompts"

if [[ ! -d "$source_dir" ]]; then
  echo "No VS Code prompt assets found at $source_dir"
  exit 0
fi

declare -a prompt_destinations=()
declare -a agent_destinations=(
  "$HOME/.copilot/agents"
)
declare -a instruction_destinations=(
  "$HOME/.copilot/instructions"
)

add_unique_destination() {
  local array_name="$1"
  local destination="$2"
  local -n destinations_ref="$array_name"
  local existing

  for existing in "${destinations_ref[@]:-}"; do
    if [[ "$existing" == "$destination" ]]; then
      return
    fi
  done

  destinations_ref+=("$destination")
}

add_user_data_destinations() {
  local user_dir="$1"
  local profiles_dir="$user_dir/profiles"
  local profile_dir

  add_unique_destination prompt_destinations "$user_dir/prompts"
  add_unique_destination agent_destinations "$user_dir/prompts"
  add_unique_destination instruction_destinations "$user_dir/prompts"

  if [[ ! -d "$profiles_dir" ]]; then
    return
  fi

  while IFS= read -r -d '' profile_dir; do
    add_unique_destination prompt_destinations "$profile_dir/prompts"
    add_unique_destination agent_destinations "$profile_dir/prompts"
    add_unique_destination instruction_destinations "$profile_dir/prompts"
  done < <(find "$profiles_dir" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
}

copy_matching_files() {
  local pattern="$1"
  local array_name="$2"
  local -n destinations_ref="$array_name"
  local file_count=0
  local destination
  local file

  while IFS= read -r -d '' file; do
    file_count=$((file_count + 1))
    for destination in "${destinations_ref[@]}"; do
      mkdir -p "$destination"
      install -m 0644 "$file" "$destination/$(basename "$file")"
    done
  done < <(find "$source_dir" -maxdepth 1 -type f -name "$pattern" -print0 | sort -z)

  echo "$file_count"
}

add_user_data_destinations "$HOME/.vscode-server/data/User"
add_user_data_destinations "$HOME/.vscode-server-insiders/data/User"
add_user_data_destinations "$HOME/.config/Code/User"
add_user_data_destinations "$HOME/.config/Code - Insiders/User"

prompt_copied_count="$(copy_matching_files "*.prompt.md" prompt_destinations)"
agent_copied_count="$(copy_matching_files "*.agent.md" agent_destinations)"
instruction_copied_count="$(copy_matching_files "*.instructions.md" instruction_destinations)"

echo "Installed $prompt_copied_count prompt files across ${#prompt_destinations[@]} prompt locations."
echo "Installed $agent_copied_count agent files across ${#agent_destinations[@]} agent locations."
echo "Installed $instruction_copied_count instruction files across ${#instruction_destinations[@]} instruction locations."