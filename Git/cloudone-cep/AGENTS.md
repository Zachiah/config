# Zachiah's Project Instructions

## Project Overview

- This is the CloudOne CEP (Customer Engagement Platform)
- The repo uses git worktrees. Each worktree (e.g., `MAIN/`, `ZS--my-feature/`) is a full checkout containing:
  - `backend/` — built with NestJS, TypeScript, Drizzle ORM, and PostgreSQL
  - `frontend/` — built with Nuxt, TypeScript, Vue, and Tailwind CSS

## Git Conventions

- Branch naming: `ZS/{description}` (kebab-case description)
- Always ask for review before committing
- Always ask Zachiah for confirmation before amending commits or force pushing — never do these automatically
- Reference GitHub issues in PR descriptions when applicable
- PRs should target the `develop` branch unless otherwise specified
- When Zachiah says "rebase", always rebase onto `develop` unless he specifies a different branch
- When running `git rebase --continue`, always use `GIT_EDITOR=true git rebase --continue` to avoid hanging on an interactive editor prompt
- When rebasing a branch that has migrations and the commits being rebased onto also introduced migrations, don't try to merge the migration conflicts. Instead, discard all migration artifacts from our branch (migration files, snapshot changes, etc.) and re-run the migrate command to regenerate them cleanly on top of the new base.
- When Zachiah says "rebase [branch]" and there is no existing work context, treat it as a full rebase workflow:
  1. Load the `existing-feature` skill to set up the worktree for that branch.
  2. Before starting the rebase, ask Zachiah what level of review granularity he wants:
     - **1. Each commit with conflicts** — pause and review at each commit that has conflicts
     - **2. Inspect before force push** — complete the rebase, then review the result before force pushing
     - **3. No review** — rebase and force push without pausing
  3. Perform the rebase onto `develop` (or the specified branch) and force push, following the chosen review level.

## Generated Files

- `frontend/app/generated/` is gitignored. The SDK is regenerated at build/dev time via `pnpm run generate:openapi` in `backend/`. Don't waste time investigating whether it's tracked — it's not.

## Backend Configuration

- Never read environment variables directly (e.g., `process.env.FOO`) in backend code. Always use the split-out config files (`app.config.ts`, `cloudone.config.ts`, etc.) via NestJS `ConfigService`. If you see direct `process.env` usage in backend code outside of config files, flag it to Zachiah.
- This rule does not apply to the frontend, which uses `useRuntimeConfig`.

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
- Use `debug` for routine operation entry/success logs in services. Reserve `log` (info) for events meaningful to operators even when everything is working correctly (e.g., server startup, external service connections, scheduled job completions). If an operation fails, the exception filter already logs it — don't add explicit error logs for thrown exceptions.

## Design Principles

- Keep mutable state as small as possible. Derive everything you can from the minimal state via computed properties. Make invalid states unrepresentable as much as possible.
- Prefer immutable patterns over mutation. For example, when building arrays conditionally, use spread with ternaries (`[...baseItems, ...(condition ? [item] : [])]`) instead of declaring a `let`/`const` array and pushing to it. This keeps mutations from spreading across the function over time.
- Never cause layout shift during page load. If a component depends on async data (e.g., a select that needs options from a query), await the query before rendering rather than conditionally showing/hiding the component. Use `await query.suspense()` or equivalent to ensure data is available on first paint. Always check for this during review.

## Worktree Safety

- **NEVER touch files in another worktree.** Only modify files within the worktree you've been told to work in.
- Before doing anything at all, ask Zachiah which worktree to work in if it hasn't already been clarified (e.g., from the "work on a new feature" flow or another prior instruction).
- A `WORKSPACE` worktree exists for one-off quick tasks. If there's no obvious current worktree for a task, ask Zachiah if he wants to use `WORKSPACE`.

## Compaction

- During compaction, write which worktree you are currently working in near the very top of the compaction summary so it is never lost.

## Workflow

- Always recheck `git status` / `git diff` before telling Zachiah the working tree is clean. He frequently codes alongside the conversation, so state can change at any time.
- After making any changes, run prettier on the files that were changed
- **Never run prettier on markdown (`.md`) files.** Continue using prettier for all other filetypes.
- Always run prettier from within the relevant package directory (e.g., `frontend/`, `backend/`), not from the repo root

### Workflow Skills

The following workflows are available as OpenCode skills (in `.opencode/skills/`). Load the appropriate skill when Zachiah triggers one of these flows:

- **"Work on a new feature"** → load the `new-feature` skill
- **"Work on an existing feature"** → load the `existing-feature` skill
- **"Cleanup old worktrees"** → load the `cleanup-worktrees` skill
- **Committing changes** → load the `commit` skill before writing any commit message

## GitHub Issues

- When AI writes or updates a GitHub issue description, always append the following line at the very end: `*This description was written by AI.*`
- Issue descriptions should be **business-friendly** and concise: summarize what changed and why in a sentence or two. Don't list out every detail — just the gist. Technical terms are fine, but avoid implementation details like variable names, function signatures, or code-level specifics.
- Only update an issue description if it was written by AI (i.e., it contains the `*This description was written by AI.*` marker). Never overwrite human-written issue descriptions.
- When creating an issue on the CEP project board, set its status to **In Progress**.
- When work on an issue is complete (e.g., PR is merged or worktree is being cleaned up), move it to **Done** on the project board.

### CEP Project Board Commands

To find a project item ID for an issue:

```bash
gh project item-list 8 --owner cloud-one --format json --limit 100 | python3 -c "import json,sys; items = json.load(sys.stdin)['items']; [print(i['id']) for i in items if i.get('content',{}).get('number') == ISSUE_NUMBER]"
```

To set an issue's status on the board:

```bash
gh project item-edit --project-id PVT_kwDOAL3HVs4BLvoJ --id ITEM_ID --field-id PVTSSF_lADOAL3HVs4BLvoJzg7Of-I --single-select-option-id OPTION_ID
```

Status option IDs:
- Backlog/Ideation: `2e31d460`
- Todo: `f75ad846`
- In Progress: `47fc9ee4`
- Blocked: `7bc18143`
- Ready For Review: `359d290d`
- Done: `98236657`

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
