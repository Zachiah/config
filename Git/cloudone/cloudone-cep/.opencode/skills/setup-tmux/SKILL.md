---
name: setup-tmux
description: Set up tmux panes — splits two terminal panes below the current one (side by side, 1/4 screen height, 2/3 + 1/3 width), cd'd into the current worktree or project root.
---

## Steps

1. Determine the working directory:
   - If you are currently working in a worktree (e.g., `ZS--my-feature/`, `WORKSPACE/`, `MAIN/`), use that worktree's absolute path.
   - If no worktree context has been established, use the project root (`/Users/zachiahsawyer/Git/cloudone-cep`).

2. Run the script, passing the directory as the only argument:

   ```bash
   /Users/zachiahsawyer/Git/cloudone-cep/.opencode/skills/setup-tmux/setup-tmux.sh '{dir}'
   ```

   Replace `{dir}` with the resolved absolute path from step 1.

That's it. The script handles everything: capturing OpenCode's pane ID, splitting, and returning focus.

## Notes

- The resulting layout is:
  ```
  ┌─────────────────────────────────┐
  │                                 │
  │         OpenCode (75%)          │
  │                                 │
  ├─────────────────────┬───────────┤
  │   left terminal     │   right   │
  │      (2/3)          │   (1/3)   │
  └─────────────────────┴───────────┘
  ```
