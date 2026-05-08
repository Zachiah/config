---
name: new-feature
description: Full workflow for starting a new feature — asks clarifying questions, creates a worktree and branch, sets up the environment, implements the feature, and handles commit/PR/cleanup.
---

## Worktree Conventions

The repo uses git worktrees so multiple agents can work in parallel. The main worktree lives at `MAIN/`. Feature worktrees are created alongside it (e.g., `ZS--my-feature/`). Worktree directory names always use the branch name with all `/` replaced by `--` (e.g., branch `ZS/my-feature` → directory `ZS--my-feature`).

## Steps

1. Ask clarifying questions about the feature
2. Ask whether this should be an **E2E TDD'd feature** (see "E2E TDD Flow" below for what this means)
3. Ask whether there is an existing GitHub issue number or whether to create a new one:
   - **Existing issue**: use that issue number going forward
   - **Create new issue**: create a GitHub issue (`gh issue create --repo cloud-one/cep`) and add it to the CEP project board (`gh project item-add 8 --owner cloud-one --url <issue-url>`). Use the new issue number going forward.
4. Make a plan for how to implement the feature (e.g., which controllers/services/modules to modify or create)
5. In `MAIN/`, run `git fetch origin` to get the latest remote state
6. Create a new worktree with the feature branch: `git worktree add -b ZS/{description} ../ZS--{description} origin/develop` (run from `MAIN/`)
7. Run `pnpm install` inside the new worktree
8. Run `../setup-worktree.sh` to symlink the `.env` file and `test` dev script into the new worktree
9. Rename this agent's tmux window: `tmux rename-window -t "$TMUX_PANE" '{Human-Readable Very Short Description}'`
10. Set up tmux panes using the `setup-tmux` skill (use the new worktree as the working directory)
11. Work entirely inside the new worktree directory (`ZS--{description}/`) for all code changes
12. **If E2E TDD**: follow the "E2E TDD Flow" section below instead of steps 13–17
13. Ask Zachiah to look over the code
14. If he approves, do a final self-review of the code
15. Create a commit
16. Push the branch
17. Create a PR targeting `develop` that references the issue — always use `--base develop` explicitly (e.g., `gh pr create --base develop --title "..." --body "Fixes #123"`)
18. After the PR is merged, clean up the worktree (use the `cleanup-worktrees` skill or see "Removing a worktree" below)

**Note on E2E tests outside the TDD flow:** Declining E2E TDD does not mean the feature shouldn't have E2E tests. If the feature warrants Playwright tests, add them as part of the normal implementation — E2E TDD only changes the _order_ of work (tests-first in a separate commit on a draft PR), not whether tests are written at all.

## E2E TDD Flow

When Zachiah opts in to E2E TDD, replace steps 13–17 above with this sequence:

1. **Write failing Playwright E2E tests first.** Add one or more E2E tests that exercise the new feature. These tests should fail because the feature doesn't exist yet.
2. **Ask Zachiah to review the tests.** Wait for his approval before proceeding.
3. **Commit the tests** (after approval) and push the branch.
4. **Open a draft PR** targeting `develop` that references the issue — always use `--base develop` explicitly (e.g., `gh pr create --draft --base develop ...`). The CI checks are expected to fail at this point because the new tests fail.
5. **Implement the feature.** Write the actual code to make the E2E tests pass.
6. **Ask Zachiah to review the implementation.** Wait for his approval.
7. **Commit the implementation** (after approval) in a separate commit and push. The CI checks should now pass.
8. **Mark the PR as ready for review** (`gh pr ready`).

## Removing a worktree

`setup-worktree.sh` symlinks `.env` and `test` into each worktree. These are gitignored/untracked, so `git worktree remove` will fail with "Directory not empty". To remove a worktree cleanly:

1. Delete the symlinks first: `rm ../{dir}/.env ../{dir}/test` (run from `MAIN/`)
2. Then remove the worktree: `git worktree remove ../{dir}` (run from `MAIN/`)
