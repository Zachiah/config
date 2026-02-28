---
name: cleanup-worktrees
description: Clean up stale git worktrees by checking for merged PRs and removing worktrees that are no longer needed.
---

## Steps

1. In `MAIN/`, run `git worktree list` to get all current worktrees
2. For each worktree that is **not** `MAIN` or `WORKSPACE`:
   a. Determine the branch name from the worktree listing
   b. Use `gh pr list --head {branch} --state merged` to check if there is a merged PR for that branch
   c. If a merged PR exists, remove the worktree (see "Removing a worktree" below)
   d. If no merged PR exists, skip it and mention it to Zachiah (e.g., "Skipping ZS--my-feature — no merged PR found")
3. After processing all worktrees, run `git worktree prune` from `MAIN/` to clean up any stale worktree references
4. Summarize what was removed and what was kept

## Removing a worktree

`setup-worktree.sh` symlinks `.env` and `test` into each worktree. These are gitignored/untracked, so `git worktree remove` will fail with "Directory not empty". To remove a worktree cleanly:

1. Delete the symlinks first: `rm ../{dir}/.env ../{dir}/test` (run from `MAIN/`)
2. Then remove the worktree: `git worktree remove ../{dir}` (run from `MAIN/`)
