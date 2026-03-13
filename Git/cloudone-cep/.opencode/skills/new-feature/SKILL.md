---
name: new-feature
description: Full workflow for starting a new feature — asks clarifying questions, creates a worktree and branch, sets up the environment, implements the feature, and handles commit/PR/cleanup.
---

## Worktree Conventions

The repo uses git worktrees so multiple agents can work in parallel. The main worktree lives at `MAIN/`. Feature worktrees are created alongside it (e.g., `ZS--my-feature/`). Worktree directory names always use the branch name with all `/` replaced by `--` (e.g., branch `ZS/my-feature` → directory `ZS--my-feature`).

## Steps

1. Ask clarifying questions about the feature
2. Ask whether there is an existing GitHub issue number or whether to create a new one:
   - **Existing issue**: use that issue number going forward
   - **Create new issue**: create a GitHub issue (`gh issue create --repo cloud-one/cep`) and add it to the CEP project board (`gh project item-add 8 --owner cloud-one --url <issue-url>`). Use the new issue number going forward.
3. Make a plan for how to implement the feature (e.g., which controllers/services/modules to modify or create)
4. In `MAIN/`, run `git fetch origin` to get the latest remote state
5. Create a new worktree with the feature branch: `git worktree add -b ZS/{description} ../ZS--{description} origin/develop` (run from `MAIN/`)
6. Run `pnpm install` inside the new worktree
7. Run `../setup-worktree.sh` to symlink the `.env` file and `test` dev script into the new worktree
8. Rename this agent's tmux window: `tmux rename-window -t "$TMUX_PANE" '{Human-Readable Very Short Description}'`
9. Work entirely inside the new worktree directory (`ZS--{description}/`) for all code changes
10. Ask Zachiah to look over the code
11. If he approves, do a final self-review of the code
12. Create a commit
13. Push the branch
14. Create a PR targeting `develop` that references the issue (e.g., "Fixes #123")
15. After the PR is merged, clean up the worktree (use the `cleanup-worktrees` skill or see "Removing a worktree" below)

## Removing a worktree

`setup-worktree.sh` symlinks `.env` and `test` into each worktree. These are gitignored/untracked, so `git worktree remove` will fail with "Directory not empty". To remove a worktree cleanly:

1. Delete the symlinks first: `rm ../{dir}/.env ../{dir}/test` (run from `MAIN/`)
2. Then remove the worktree: `git worktree remove ../{dir}` (run from `MAIN/`)
