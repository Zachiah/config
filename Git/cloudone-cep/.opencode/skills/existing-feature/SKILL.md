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
6. Run `pnpm install` inside the worktree
7. Run `../setup-worktree.sh` to symlink the `.env` file and `test` dev script into the worktree
8. Print a terminal name for Zachiah to copy: `OPENCODE {Human-Readable Very Short Description}` (so he can rename the terminal tab)
9. Ask clarifying questions about what work needs to be done
10. Work entirely inside the worktree directory for all code changes
11. Ask Zachiah to look over the code
12. If he approves, do a final self-review of the code
13. Create a commit
14. Push the branch and print the PR URL (use `gh pr view --json url -q .url` to get it)
15. After the PR is merged, clean up the worktree (use the `cleanup-worktrees` skill or see "Removing a worktree" below)

## Removing a worktree

`setup-worktree.sh` symlinks `.env` and `test` into each worktree. These are gitignored/untracked, so `git worktree remove` will fail with "Directory not empty". To remove a worktree cleanly:

1. Delete the symlinks first: `rm ../{dir}/.env ../{dir}/test` (run from `MAIN/`)
2. Then remove the worktree: `git worktree remove ../{dir}` (run from `MAIN/`)
