---
name: commit
description: Commit message guidelines — ensures all commits follow conventional commit format with proper types, scopes, and formatting rules.
---

## Commit Message Guidelines

- Follow https://www.conventionalcommits.org/en/v1.0.0/
- Use this header format exactly: `<type>[optional scope][optional !]: <description>`.
- Use `feat` for new features and `fix` for bug fixes.
- Keep the description short, imperative, and immediately after `: `.
- Add an optional body only when extra context is useful; start it one blank line below the header.
- Add optional footers one blank line below the body (or below header if no body), using git trailer style like `Refs: #123`.
- Mark breaking changes with either `!` in the header (for example `feat(api)!: ...`) or a `BREAKING CHANGE: ...` footer.
- Keep `BREAKING CHANGE` uppercase when used as a footer token.
- Other types are allowed when they better match the change (for example `chore`, `docs`, `refactor`, `test`, `ci`, `perf`).
