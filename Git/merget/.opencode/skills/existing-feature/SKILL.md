---
name: existing-feature
description: Full workflow for resuming work on an existing feature branch — finds or creates the worktree, sets up the environment, implements changes, and handles commit/PR/cleanup.
---

## Worktree Conventions

The repo uses git worktrees so multiple agents can work in parallel. The main worktree lives at `MAIN/`. Feature worktrees are created alongside it (e.g., `ZS--my-feature/`). Worktree directory names always use the branch name with all `/` replaced by `--` (e.g., branch `ZS/my-feature` → directory `ZS--my-feature`).

## Steps

1. Ask Zachiah for the branch name
2. In `MAIN/`, run `git fetch origin` to get the latest remote state
3. Check if a worktree for that branch already exists: `git worktree list` (run from `MAIN/`)
4. If the worktree **does not** exist, create it: `git worktree add -b {branch} ../{dir} origin/{branch}` (run from `MAIN/`). The `-b` flag creates a local branch tracking the remote ref, avoiding a detached HEAD.
5. If the worktree **already exists**, just navigate to it and make sure it's up to date: `git pull` (run from within the worktree)
6. Ask Zachiah if he wants to set up the environment. If yes, run `npm install` inside the worktree's `gui` folder.
7. Rename this agent's tmux window: `tmux rename-window -t "$TMUX_PANE" '{Human-Readable Very Short Description}'`
8. Set up tmux panes using the `setup-tmux` skill (use the worktree as the working directory)
9. Ask clarifying questions about what work needs to be done
10. Work entirely inside the worktree directory for all code changes
11. Ask Zachiah to look over the code
12. If he approves, do a final self-review of the code
13. Create a commit
14. Push the branch and print the PR URL (use `gh pr view --json url -q .url` to get it)
15. After the PR is merged, clean up the worktree (use the `cleanup-worktrees` skill)
