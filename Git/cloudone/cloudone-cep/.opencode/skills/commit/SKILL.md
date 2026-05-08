---
name: commit
description: Commit message guidelines — ensures all commits follow conventional commit format with proper types, scopes, and formatting rules.
---

## Commit Message Guidelines

### Format

Use conventional commit format:

```
type(scope): subject

body (optional)

footer (optional)
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code refactoring without feature changes
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `chore`: Build process, dependencies, or tooling changes
- `perf`: Performance improvements
- `ci`: CI/CD configuration changes

### Scopes

Use the affected module or area:

- `backend`, `frontend`, `shared`, `e2e`
- Or omit scope for cross-cutting changes

### Rules

1. Keep subject line under 50 characters
2. Use imperative mood ("add feature" not "added feature")
3. Do not end subject with a period
4. Separate subject from body with a blank line
5. Wrap body at 72 characters
6. Reference issue numbers in footer when applicable
7. Begin commit with lowercase letter

### Examples

```
feat(frontend): add organization settings page

fix(backend): resolve auth token expiration issue

docs: update getting started guide

refactor(shared): simplify validation utilities

chore: upgrade dependencies to latest versions
```
