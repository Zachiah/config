# Zachiah's Project Instructions

## Project Overview

- This is the CloudOne CEP (Customer Engagement Platform)
- The repo uses git worktrees. Each worktree (e.g., `MAIN/`, `ZS--my-feature/`) is a full checkout containing:
  - `backend/` — built with NestJS, TypeScript, Drizzle ORM, and PostgreSQL
  - `frontend/` — built with Nuxt, TypeScript, Vue, and Tailwind CSS

## Git Conventions

- Branch naming: `ZS/{description}` (kebab-case description)
- Always ask for review before committing
- Reference GitHub issues in PR descriptions when applicable
- PRs should target the `develop` branch unless otherwise specified
- When running `git rebase --continue`, always use `GIT_EDITOR=true git rebase --continue` to avoid hanging on an interactive editor prompt

## Code Style

- Follow existing NestJS patterns (controllers, services, modules)
- Use Drizzle ORM for database queries
- Swagger/OpenAPI decorators on all controller endpoints
- Do not write comments in code unless the comment explains _why_ something non-obvious is happening (e.g., a weird pattern for performance reasons)
- When Zachiah says "temporarily", add a highly visible comment on the temporary code: `// TODO: REMOVE THIS IS TEMPORARY`. Put this comment on every line or block of temporary code, including imports.
- Never commit temporary code (lines marked `// TODO: REMOVE THIS IS TEMPORARY`). Before committing, either remove them or ask Zachiah whether to remove them.
- Never use `any`. Always use proper types — use `unknown` and narrow, generics, or specific types instead.
- Never import anything that Nuxt auto-imports (Vue APIs like `ref`, `computed`, `watch`, `onMounted`, etc., and components from the `components/` directory). If I notice a file I'm not working on has unnecessary imports that break this rule, mention it to Zachiah (e.g., "BTW this file had unnecessary imports").
- Always use `type` instead of `interface` unless Zachiah specifically directs otherwise. Use `&` (intersection) instead of `extends` for type composition.
- In Vue `<script setup>` files, colocate code by feature, not by type. Keep related state, computeds, watchers, and lifecycle hooks together rather than grouping all refs in one place and all `onMounted` calls in another.
- Always use `defineModel` instead of manually defining a prop + `update:modelValue` emit for two-way binding.

## Design Principles

- Keep mutable state as small as possible. Derive everything you can from the minimal state via computed properties. Make invalid states unrepresentable as much as possible.

## Worktree Safety

- **NEVER touch files in another worktree.** Only modify files within the worktree you've been told to work in.
- Before doing anything at all, ask Zachiah which worktree to work in if it hasn't already been clarified (e.g., from the "work on a new feature" flow or another prior instruction).
- A `WORKSPACE` worktree exists for one-off quick tasks. If there's no obvious current worktree for a task, ask Zachiah if he wants to use `WORKSPACE`.

## Compaction

- During compaction, write which worktree you are currently working in near the very top of the compaction summary so it is never lost.

## Workflow

- Always recheck `git status` / `git diff` before telling Zachiah the working tree is clean. He frequently codes alongside the conversation, so state can change at any time.
- After making any changes, run prettier on the files that were changed
- Always run prettier from within the relevant package directory (e.g., `frontend/`, `backend/`), not from the repo root

### Workflow Skills

The following workflows are available as OpenCode skills (in `.opencode/skills/`). Load the appropriate skill when Zachiah triggers one of these flows:

- **"Work on a new feature"** → load the `new-feature` skill
- **"Work on an existing feature"** → load the `existing-feature` skill
- **"Cleanup old worktrees"** → load the `cleanup-worktrees` skill
- **Committing changes** → load the `commit` skill before writing any commit message

## Meta

- When Zachiah says "remember", write what he says into this file (`AGENTS.md`) in the `cloudone-cep` directory above all of the worktree directories.
- Never touch the `.env` file

## Dev Script (`test`)

- A `test` bash script lives in the repo root (above the worktrees) and is symlinked into each worktree by `setup-worktree.sh`.
- Running `./test` from within a worktree will:
  1. Start the database via `docker-compose up db -d`
  2. Open `http://localhost:5173` in the default browser
  3. Run `pnpm run dev` (blocking — Ctrl+C to stop)
  4. After `pnpm dev` exits, automatically run `docker-compose down`
- Both `test` and `setup-worktree.sh` are excluded from git via `MAIN/.git/info/exclude`.

## Package Installation

Always use the pnpm catalog when installing packages:

1. Check if the package is already in the catalog (`pnpm-workspace.yaml`). If it is, just set the version to `catalog:` in `package.json` and run `pnpm install`.
2. Otherwise, install the package normally.
3. Add the installed version to the catalog in `pnpm-workspace.yaml`.
4. Switch the version in `package.json` to `catalog:`.
5. Run `pnpm install` again.
