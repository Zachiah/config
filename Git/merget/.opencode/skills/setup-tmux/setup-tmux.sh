#!/usr/bin/env bash
set -euo pipefail

DIR="${1:?Usage: setup-tmux.sh <working-directory>}"

# $TMUX_PANE is set by tmux in every shell it spawns — it identifies
# the pane this script is running in (i.e., OpenCode's pane).
# Using explicit -t on EVERY tmux command avoids races with the user
# clicking around or other OpenCode instances changing the active pane.
OPENCODE_PANE="${TMUX_PANE:?Not running inside tmux}"

# 1. Split OpenCode's pane vertically (bottom 25%).
#    -P -F prints the new pane's ID so we can target it explicitly.
BOTTOM_PANE=$(tmux split-window -v -t "$OPENCODE_PANE" -p 25 -c "$DIR" -P -F '#{pane_id}')

# 2. Split the bottom pane horizontally (right 33%).
#    Explicitly targets BOTTOM_PANE — no reliance on "active pane".
tmux split-window -h -t "$BOTTOM_PANE" -p 33 -c "$DIR"

# 3. Return focus to OpenCode's pane.
tmux select-pane -t "$OPENCODE_PANE"
