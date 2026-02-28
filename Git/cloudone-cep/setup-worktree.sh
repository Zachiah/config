#!/usr/bin/env bash
#
# Sets up a worktree directory:
#   1. Symlinks the top-level .env into the worktree (if not already present)
#   2. Symlinks the top-level dev script (test) into the worktree (if not already present)
#
# Run from the cloudone-cep root (the directory containing this script),
# or from within a worktree via ../setup-worktree.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"
DEV_SCRIPT="$SCRIPT_DIR/test"

if [ ! -f "$ENV_FILE" ]; then
  echo "Error: $ENV_FILE not found"
  exit 1
fi

if [ ! -f "$DEV_SCRIPT" ]; then
  echo "Warning: $DEV_SCRIPT not found — skipping dev script symlink"
fi

for dir in "$SCRIPT_DIR"/*/; do
  dir_name="$(basename "$dir")"

  # Skip hidden directories (e.g., .opencode)
  [[ "$dir_name" == .* ]] && continue

  # Symlink .env
  target_env="$dir.env"
  if [ -e "$target_env" ] || [ -L "$target_env" ]; then
    echo "Skipping $dir_name/ — .env already exists"
  else
    ln -s "$ENV_FILE" "$target_env"
    echo "Linked .env → $dir_name/"
  fi

  # Symlink dev script
  if [ -f "$DEV_SCRIPT" ]; then
    target_dev="$dir/test"
    if [ -e "$target_dev" ] || [ -L "$target_dev" ]; then
      echo "Skipping $dir_name/ — test script already exists"
    else
      ln -s "$DEV_SCRIPT" "$target_dev"
      echo "Linked test → $dir_name/"
    fi
  fi
done
