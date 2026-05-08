# Zachiah's Project Instructions

## Project Overview

- This is the CloudOne CEP (Customer Engagement Platform)
- The repo uses git worktrees. Each worktree (e.g., `MAIN/`, `ZS--my-feature/`) is a full checkout containing:
  - `backend/` — built with NestJS, TypeScript, Drizzle ORM, and PostgreSQL
  - `frontend/` — built with Nuxt, TypeScript, Vue, and Tailwind CSS
- The `scripting-engine/` directory at the repo root is the **old** standalone scripting engine project (Nuxt 4 + Cloudflare). The scripting engine has been ported into the CEP as a feature. All new scripting engine work happens in the CEP's `backend/` and `frontend/` directories, not in `scripting-engine/`. The old directory is kept for reference only.
- When porting code from the old scripting engine into the CEP, copy it exactly unless there's a genuine reason to change it (e.g., adapting to NestJS patterns, fixing a bug, or matching CEP conventions). If you do change something, tell Zachiah what you did differently and ask if that's okay.

## Git Conventions

- When fetching reveals two remote branches that differ only in casing (e.g., `feat/PM/foo` vs `feat/pm/foo`), always ask Zachiah which one to use before creating a worktree. Patrick often ends up with duplicate branches like this.
- Before creating a new worktree, always pull latest `develop` in `MAIN` first and create the new worktree based on that.
- Branch naming: `ZS/{description}` (kebab-case description)
- Always ask for review before committing
- Always ask Zachiah for confirmation before amending commits or force pushing — never do these automatically
- Reference GitHub issues in PR descriptions when applicable
- PRs should target the `develop` branch unless otherwise specified
- When Zachiah says "rebase", always rebase onto `develop` unless he specifies a different branch
- When running `git rebase --continue`, always use `GIT_EDITOR=true git rebase --continue` to avoid hanging on an interactive editor prompt
- Before starting any rebase, check whether the commits being rebased onto introduced migration changes and whether our branch also has migration changes. If both sides have migrations, don't try to merge the migration conflicts. Instead, discard all migration artifacts from our branch (migration files, snapshot changes, etc.) and re-run `pnpm run db:generate` from the worktree root to regenerate them cleanly on top of the new base.
- When Zachiah says "rebase [branch]" and there is no existing work context, treat it as a full rebase workflow:
  1. Load the `existing-feature` skill to set up the worktree for that branch.
  2. Before starting the rebase, ask Zachiah what level of review granularity he wants:
     - **1. Each commit with conflicts** — pause and review at each commit that has conflicts
     - **2. Inspect before force push** — complete the rebase, then review the result before force pushing
     - **3. No review** — rebase and force push without pausing
  3. Perform the rebase onto `develop` (or the specified branch) and force push, following the chosen review level.
  4. After the rebase is complete (regardless of review level), always:
     - Write a list of every conflict encountered, showing what both sides had for each conflict.
     - Verify each conflict resolution one by one — most of the time both sides' changes need to be incorporated, which may be non-trivial.
     - Print the full list of conflicts and how each was resolved to Zachiah.
  5. After the rebase is complete, do **not** automatically clean up the worktree. Leave it in place until Zachiah explicitly says to clean it up.

## Migrations

- Always generate migrations by running `pnpm run db:generate` **from the worktree root** (not from `backend/`). The root script proxies to `backend/scripts/db-generate.cjs`, which wraps `drizzle-kit generate` and ensures the migration gets a descriptive name.
- The script will prompt for a migration name interactively, or you can pass one via `--name`:
  ```bash
  pnpm run db:generate -- --name add-users-table
  ```
- Never call `drizzle-kit generate` directly — always go through the `db:generate` script so migrations are named consistently.

## Generated Files

- `frontend/app/generated/` is gitignored. The SDK is regenerated at build/dev time via `pnpm run generate:openapi` in `backend/`. Don't waste time investigating whether it's tracked — it's not.

## Backend Configuration

- Never read environment variables directly (e.g., `process.env.FOO`) in backend code. Always use the split-out config files (`app.config.ts`, `cloudone.config.ts`, etc.) via NestJS `ConfigService`. If you see direct `process.env` usage in backend code outside of config files, flag it to Zachiah.
- This rule does not apply to the frontend, which uses `useRuntimeConfig`.

## Code Style

- Follow existing NestJS patterns (controllers, services, modules)
- Use Drizzle ORM for database queries — prefer the select/insert/update/delete API (`this.db.select()...`) over the query API (`this.db.query...`)
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
- Never use `switch` statements to exhaustively handle a union type. Instead, use a chain of `if` statements with an exhaustive `never` check at the end (`const _exhaustive: never = x; throw _exhaustive;`). Flag this pattern when reviewing code.
- Public APIs must never expose `id` for any model that has a `sid`. Always use `sid` in API responses, DTOs, and controller parameters. If you notice `id` being exposed on a model that has a `sid` — in any context, not just code you're actively working on — flag it to Zachiah.
- All TanStack Query keys in the frontend must go through the centralized `queryKeys` object in `frontend/app/lib/query-keys.ts`. Never use inline query key arrays (e.g., `queryKey: ['foo', id]`). If you notice an inline query key — during code review, while reading a file, or anywhere else — flag it to Zachiah.
- Properties in response DTOs should almost never be optional. The value will still be present in the response (as a literal `null`), so the property itself is not absent — mark it as required with a nullable type instead. If you notice optional properties in response DTOs, flag it to Zachiah.
- All response DTOs must be named `{ThingName}ResponseDto` and all request DTOs must be named `{ThingName}RequestDto`. If you notice DTOs that don't follow this convention, flag it to Zachiah.

## Design Principles

- Keep mutable state as small as possible. Derive everything you can from the minimal state via computed properties. Make invalid states unrepresentable as much as possible.
- Prefer immutable patterns over mutation. For example, when building arrays conditionally, use spread with ternaries (`[...baseItems, ...(condition ? [item] : [])]`) instead of declaring a `let`/`const` array and pushing to it. This keeps mutations from spreading across the function over time.
- Never cause layout shift during page load. If a component depends on async data (e.g., a select that needs options from a query), await the query before rendering rather than conditionally showing/hiding the component. Use `await query.suspense()` or equivalent to ensure data is available on first paint. Always check for this during review.

## Worktree Safety

- **NEVER touch files in another worktree.** Only modify files within the worktree you've been told to work in.
- Before doing anything at all, ask Zachiah which worktree to work in if it hasn't already been clarified (e.g., from the "work on a new feature" flow or another prior instruction).
- A `WORKSPACE` worktree exists for one-off quick tasks. If there's no obvious current worktree for a task, ask Zachiah if he wants to use `WORKSPACE`.

## Tmux Window Naming

- When working on someone else's PR via the existing-feature workflow, name the tmux window in the format: `${pr number} ${author} - ${name}` (e.g., `339 Pierce - Agent Presence`).
- For Zachiah's own branches, use a short human-readable description.

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
- **"Setup tmux"** → load the `setup-tmux` skill

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

## E2E Tests

- Run E2E tests using `pnpm run test:e2e` from the worktree root. This runs `scripts/e2e.sh`, which spins up a separate database, backend, and frontend, runs Playwright, then cleans up.
- To run a specific test file: `pnpm run test:e2e -- e2e/my-test.spec.ts`
- During the E2E TDD flow:
  - After writing the failing tests (before asking Zachiah to review), run them and confirm they **fail** as expected.
  - After implementing the feature (before asking Zachiah to review), run them and confirm they **pass**.

## Dev Script (`test`)

- A `test` bash script lives in the repo root (above the worktrees) and is symlinked into each worktree by `setup-worktree.sh`.
- Running `./test` from within a worktree will:
  1. Start the database via `docker-compose up db -d`
  2. Open `http://localhost:5173` in the default browser
  3. Run `pnpm run dev` (blocking — Ctrl+C to stop)
  4. After `pnpm dev` exits, automatically run `docker-compose down`
- Both `test` and `setup-worktree.sh` are excluded from git via `MAIN/.git/info/exclude`.

## Lockfile Conflicts

- When `pnpm-lock.yaml` has conflicts, just run `pnpm install` — pnpm handles conflicted lockfiles automatically. No need to accept either side or manually resolve.

## Package Installation

Always use the pnpm catalog when installing packages:

1. Check if the package is already in the catalog (`pnpm-workspace.yaml`). If it is, just set the version to `catalog:` in `package.json` and run `pnpm install`.
2. Otherwise, install the package normally.
3. Add the installed version to the catalog in `pnpm-workspace.yaml`.
4. Switch the version in `package.json` to `catalog:`.
5. Run `pnpm install` again.
