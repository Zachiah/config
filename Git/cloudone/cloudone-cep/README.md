# CloudOne CEP — Worktree Setup

This project uses git worktrees so multiple branches can be checked out side-by-side. Each worktree directory (e.g., `MAIN/`, `ZS--my-feature/`) is a full checkout of the repo.

## Setup

```bash
# Create the root directory
mkdir cloudone-cep && cd cloudone-cep

# Clone into MAIN/ and check out develop
git clone git@github.com:cloud-one/cep.git MAIN
cd MAIN && git checkout develop && cd ..

# Create the shared .env (edit with real values)
cp MAIN/.env.example .env

# Symlink .env and the dev script into each worktree
./setup-worktree.sh
```
