# Zachiah's Project Instructions

I am working mostly on GUI for now so I don't have a ton of guidance for non GUI code yet.

## Project Overview

- The repo uses git worktrees. Each worktree (e.g., `MAIN/`, `ZS--my-feature/`) is a full checkout

## Git Conventions

- Before creating a new worktree, always pull latest `main` in `MAIN` first and create the new worktree based on that.
- Whenever setting up a new worktree, create `gui/.env` with:
  - `VITE_API_URL="https://api.dev.merget.ai"`
  - `VITE_AI_URL="https://agent.dev.merget.ai"`
- Branch naming: `ZS/{description}` (kebab-case description)
- Always ask for review before committing
- Always ask Zachiah for confirmation before amending commits or force pushing — never do these automatically
- When running `git rebase --continue`, always use `GIT_EDITOR=true git rebase --continue` to avoid hanging on an interactive editor prompt
- When Zachiah says "rebase [branch]" and there is no existing work context, treat it as a full rebase workflow:
  1. Load the `existing-feature` skill to set up the worktree for that branch.
  2. Before starting the rebase, ask Zachiah what level of review granularity he wants:
     - **1. Each commit with conflicts** — pause and review at each commit that has conflicts
     - **2. Inspect before force push** — complete the rebase, then review the result before force pushing
     - **3. No review** — rebase and force push without pausing
  3. Perform the rebase onto `main` (or the specified branch) and force push, following the chosen review level.
  4. After the rebase is complete (regardless of review level), always:
     - Write a list of every conflict encountered, showing what both sides had for each conflict.
     - Verify each conflict resolution one by one — most of the time both sides' changes need to be incorporated, which may be non-trivial.
     - Print the full list of conflicts and how each was resolved to Zachiah.
  5. After the rebase is complete, do **not** automatically clean up the worktree. Leave it in place until Zachiah explicitly says to clean it up.

## GUI Code Style

- Do not write comments in code unless the comment explains _why_ something non-obvious is happening (e.g., a weird pattern for performance reasons)
- When Zachiah says "temporarily", add a highly visible comment on the temporary code: `// TODO: REMOVE THIS IS TEMPORARY`. Put this comment on every line or block of temporary code, including imports.
- Never commit temporary code (lines marked `// TODO: REMOVE THIS IS TEMPORARY`). Before committing, either remove them or ask Zachiah whether to remove them.
- Never use `any`. Always use proper types — use `unknown` and narrow, generics, or specific types instead.
- Always use `type` instead of `interface` unless Zachiah specifically directs otherwise. Use `&` (intersection) instead of `extends` for type composition.
- Never use `switch` statements to exhaustively handle a union type. Instead, use a chain of `if` statements with an exhaustive `never` check at the end (`const _exhaustive: never = x; throw _exhaustive;`). Flag this pattern when reviewing code.
- Use tailwind instead of manual styles wherever possible. One exception would be custom keyframes
- For Svelte 5, in order to DRY duplicated templates within a single component (without splitting components), use snippets (`{#snippet ...}` / `{@render ...}`).

## Design Principles

- Keep mutable state as small as possible. Derive everything you can from the minimal state via computed properties. Make invalid states unrepresentable as much as possible.
- Prefer immutable patterns over mutation. For example, when building arrays conditionally, use spread with ternaries (`[...baseItems, ...(condition ? [item] : [])]`) instead of declaring a `let`/`const` array and pushing to it. This keeps mutations from spreading across the function over time.

## Worktree Safety

- **NEVER touch files in another worktree.** Only modify files within the worktree you've been told to work in.
- Before doing anything at all, ask Zachiah which worktree to work in if it hasn't already been clarified (e.g., from the "work on a new feature" flow or another prior instruction).

## Tmux Window Naming

- When working on someone else's PR via the existing-feature workflow, name the tmux window in the format: `${pr number} ${author} - ${name}`
- For Zachiah's own branches, use a short human-readable description.

## Workflow

- Always recheck `git status` / `git diff` before telling Zachiah the working tree is clean. He frequently codes alongside the conversation, so state can change at any time.
- After making any changes to files prettier formats when `npm run format` is run in `gui`, run prettier on the files that were changed

### Workflow Skills

The following workflows are available as OpenCode skills (in `.opencode/skills/`). Load the appropriate skill when Zachiah triggers one of these flows:

- **"Work on a new feature"** → load the `new-feature` skill
- **"Work on an existing feature"** → load the `existing-feature` skill
- **"Cleanup old worktrees"** → load the `cleanup-worktrees` skill
- **Committing changes** → load the `commit` skill before writing any commit message
- **"Setup tmux"** → load the `setup-tmux` skill

## Meta

- When Zachiah says "remember", write what he says into this file (`AGENTS.md`) in the `merget` directory above all of the worktree directories.
- Never trust markdown files in the actual codebase.

## Svelte MCP Tool Usage

- You are able to use the Svelte MCP server with comprehensive Svelte 5 and SvelteKit documentation.
- When asked about Svelte or SvelteKit topics, ALWAYS call `list-sections` first.
- After `list-sections`, analyze returned sections (especially `use_cases`) and call `get-documentation` for ALL sections relevant to the task.
- Whenever writing Svelte code before sending it to Zachiah, MUST run `svelte-autofixer` and keep running it until no issues or suggestions remain.
- After completing Svelte code, ask Zachiah whether he wants a playground link.
- Only call `playground-link` after Zachiah confirms, and NEVER call it if code was written to files in the project.
