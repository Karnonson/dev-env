#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
install_dir="/usr/local/bin"
completion_dir="/etc/bash_completion.d"

run_with_optional_sudo() {
  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    "$@"
  fi
}

if [[ ! -w "$install_dir" ]] && ! command -v sudo >/dev/null 2>&1; then
  install_dir="${HOME}/.local/bin"
  completion_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion/completions"
fi

echo "Active dev container profile: ${DEVCONTAINER_PROFILE:-base}"

if command -v corepack >/dev/null 2>&1; then
  corepack enable
  corepack prepare pnpm@latest --activate
else
  echo "Skipping pnpm activation because corepack is not installed."
fi

if ! command -v uv >/dev/null 2>&1; then
  mkdir -p "$install_dir"
  if [[ "$install_dir" == "/usr/local/bin" ]]; then
    curl -LsSf https://astral.sh/uv/install.sh | run_with_optional_sudo env UV_INSTALL_DIR="$install_dir" sh
  else
    curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$install_dir" sh
  fi
fi

if [[ -f "$script_dir/bin/kite" ]]; then
  mkdir -p "$install_dir"
  if [[ "$install_dir" == "/usr/local/bin" ]]; then
    run_with_optional_sudo install -m 0755 "$script_dir/bin/kite" "$install_dir/kite"
    run_with_optional_sudo mkdir -p "$completion_dir"
    bash "$script_dir/bin/kite" completion bash | run_with_optional_sudo tee "$completion_dir/kite" >/dev/null
    run_with_optional_sudo rm -f /usr/local/bin/dev-env
  else
    install -m 0755 "$script_dir/bin/kite" "$install_dir/kite"
    mkdir -p "$completion_dir"
    bash "$script_dir/bin/kite" completion bash > "$completion_dir/kite"
    rm -f "$install_dir/dev-env"
  fi

  if [[ ":$PATH:" != *":$install_dir:"* ]]; then
    echo "kite was installed to $install_dir/kite. Add $install_dir to PATH if it is not already available in new shells."
  fi
fi


