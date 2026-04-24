#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
install_dir="/usr/local/bin"
completion_dir="/etc/bash_completion.d"
workspace_dir="${WORKSPACE_FOLDER:-${GITHUB_WORKSPACE:-$PWD}}"

run_with_optional_sudo() {
  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    "$@"
  fi
}

ensure_workspace_git_repo() {
  local target="$1"
  local current_branch

  if ! command -v git >/dev/null 2>&1; then
    echo "Skipping git initialization because git is not installed."
    return
  fi

  if git -C "$target" rev-parse --git-dir >/dev/null 2>&1; then
    return
  fi

  echo "Initializing a git repository in $target"
  if ! git -C "$target" init -b main >/dev/null 2>&1; then
    git -C "$target" init >/dev/null 2>&1
  fi
  git -C "$target" config --local init.defaultBranch main || true

  current_branch="$(git -C "$target" symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
  if [[ "$current_branch" == "master" ]] && ! git -C "$target" rev-parse --verify HEAD >/dev/null 2>&1; then
    git -C "$target" branch -m master main || true
  fi
}

if [[ ! -w "$install_dir" ]] && ! command -v sudo >/dev/null 2>&1; then
  install_dir="${HOME}/.local/bin"
  completion_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/bash-completion/completions"
fi

echo "Active dev container profile: ${DEVCONTAINER_PROFILE:-base}"

if [[ "${KITE_SKIP_NODE_BOOTSTRAP:-0}" != "1" ]]; then
  if command -v corepack >/dev/null 2>&1; then
    corepack enable
    corepack prepare pnpm@latest --activate
  else
    echo "Skipping pnpm activation because corepack is not installed."
  fi
fi

if [[ "${KITE_SKIP_UV_BOOTSTRAP:-0}" != "1" ]] && ! command -v uv >/dev/null 2>&1; then
  mkdir -p "$install_dir"
  if [[ "$install_dir" == "/usr/local/bin" ]]; then
    curl -LsSf https://astral.sh/uv/install.sh | run_with_optional_sudo env UV_INSTALL_DIR="$install_dir" sh
  else
    curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$install_dir" sh
  fi
fi

if [[ "${KITE_SKIP_KITE_INSTALL:-0}" != "1" ]] && [[ -f "$script_dir/bin/kite" ]]; then
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

ensure_workspace_git_repo "$workspace_dir"
