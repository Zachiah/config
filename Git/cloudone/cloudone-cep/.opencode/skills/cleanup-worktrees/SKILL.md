---
name: cleanup-worktrees
description: Clean up stale git worktrees by checking for merged PRs and removing worktrees that are no longer needed.
---

## Steps

1. In `MAIN/`, run `git worktree list` to get all current worktrees
2. For each worktree that is **not** `MAIN` or `WORKSPACE`:
   a. Determine the branch name from the worktree listing
   b. Use `gh pr list --head {branch} --state merged` to check if there is a merged PR for that branch
   c. If a merged PR exists:
      1. **Update linked issue descriptions** (see "Updating issue descriptions" below)
      2. Remove the worktree (see "Removing a worktree" below)
   d. If no merged PR exists, skip it and mention it to Zachiah (e.g., "Skipping ZS--my-feature — no merged PR found")
3. After processing all worktrees, run `git worktree prune` from `MAIN/` to clean up any stale worktree references
4. Summarize what was removed and what was kept

## Updating issue descriptions

When a merged PR is found, check if it closes a GitHub issue (look for "Closes #N" or "Fixes #N" in the PR body, or use `gh pr view {number} --json closingIssuesReferences`).

For each linked issue:
1. Fetch the issue body with `gh issue view {number} --json body`
2. Check if the description ends with `*This description was written by AI.*`
3. **If it does**: read the full PR diff, then update the issue description to reflect what was actually done. Keep it concise and business-friendly — a sentence or two summarizing the gist, not a detailed list. Avoid code-level details like variable names or function signatures. Always keep the `*This description was written by AI.*` line at the end.
4. **If it does not**: leave the issue description alone — it was written by a human.
5. **Move the issue to Done** on the CEP project board (regardless of whether the description was updated).

## Removing a worktree

`setup-worktree.sh` symlinks `.env` and `test` into each worktree. These are gitignored/untracked, so `git worktree remove` will fail with "Directory not empty". To remove a worktree cleanly:

1. Delete the symlinks first: `rm ../{dir}/.env ../{dir}/test` (run from `MAIN/`)
2. Then remove the worktree: `git worktree remove ../{dir}` (run from `MAIN/`)
