---
name: new-feature
description: Full workflow for starting a new feature — asks clarifying questions, creates a worktree and branch, sets up the environment, implements the feature, and handles commit/PR/cleanup.
---

## Worktree Conventions

The repo uses git worktrees so multiple agents can work in parallel. The main worktree lives at `MAIN/`. Feature worktrees are created alongside it (e.g., `ZS--my-feature/`). Worktree directory names always use the branch name with all `/` replaced by `--` (e.g., branch `ZS/my-feature` → directory `ZS--my-feature`).

## Steps

1. Ask clarifying questions about the feature and get the GitHub issue number
2. Make a plan for how to implement the feature (e.g., which controllers/services/modules to modify or create)
3. In `MAIN/`, run `git fetch origin` to get the latest remote state
4. Create a new worktree with the feature branch: `git worktree add -b ZS/{description} ../ZS--{description} origin/develop` (run from `MAIN/`)
5. Run `pnpm install` inside the new worktree
6. Run `../setup-worktree.sh` to symlink the `.env` file and `test` dev script into the new worktree
7. Print a terminal name for Zachiah to copy: `OPENCODE {Human-Readable Very Short Description}` (so he can rename the terminal tab)
8. Work entirely inside the new worktree directory (`ZS--{description}/`) for all code changes
9. Ask Zachiah to look over the code
10. If he approves, do a final self-review of the code
11. Create a commit
12. Push the branch
13. Create a PR targeting `develop` that references the issue (e.g., "Fixes #123")
14. After the PR is merged, clean up the worktree (use the `cleanup-worktrees` skill or see "Removing a worktree" below)

## Removing a worktree

`setup-worktree.sh` symlinks `.env` and `test` into each worktree. These are gitignored/untracked, so `git worktree remove` will fail with "Directory not empty". To remove a worktree cleanly:

1. Delete the symlinks first: `rm ../{dir}/.env ../{dir}/test` (run from `MAIN/`)
2. Then remove the worktree: `git worktree remove ../{dir}` (run from `MAIN/`)
