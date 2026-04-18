#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "Active dev container profile: ${DEVCONTAINER_PROFILE:-base}"

corepack enable
corepack prepare pnpm@latest --activate

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sudo env UV_INSTALL_DIR=/usr/local/bin sh
fi

if [[ -f "$script_dir/bin/kite" ]]; then
  sudo install -m 0755 "$script_dir/bin/kite" /usr/local/bin/kite
  sudo rm -f /usr/local/bin/dev-env
fi


