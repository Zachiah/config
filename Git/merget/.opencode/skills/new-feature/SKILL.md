---
name: new-feature
description: Full workflow for starting a new feature — asks clarifying questions, creates a worktree and branch, sets up the environment, implements the feature, and handles commit/PR/cleanup.
---

## Worktree Conventions

The repo uses git worktrees so multiple agents can work in parallel. The main worktree lives at `MAIN/`. Feature worktrees are created alongside it (e.g., `ZS--my-feature/`). Worktree directory names always use the branch name with all `/` replaced by `--` (e.g., branch `ZS/my-feature` → directory `ZS--my-feature`).

## Steps

1. Ask clarifying questions about the feature.
2. Make a plan for how to implement the feature.
3. In `MAIN/`, update local `main` before branching: `git checkout main && git pull --ff-only origin main`.
4. Create a new worktree with the feature branch from the updated local `main`: `git worktree add -b ZS/{description} ../ZS--{description} main` (run from `MAIN/`).
5. Run `npm install` inside the new worktree's `gui` folder.
6. Rename this agent's tmux window: `tmux rename-window -t "$TMUX_PANE" '{Human-Readable Very Short Description}'`.
7. Set up tmux panes using the `setup-tmux` skill (use the new worktree as the working directory).
8. Work entirely inside the new worktree directory (`ZS--{description}/`) for all code changes.
9. Ask Zachiah to look over the code.
10. If he approves, do a final self-review of the code.
11. Create a commit.
12. Push the branch.
13. Create a PR targeting `main` that references the issue and requests `ved-merget` and `fady-merget` as reviewers.
14. After the PR is merged, clean up the worktree (use the `cleanup-worktrees` skill).
