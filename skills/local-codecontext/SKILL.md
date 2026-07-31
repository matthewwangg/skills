---
name: local-codecontext
description: Build working context on a codebase before doing anything to it — a whole repo, a subdirectory, or a set of files. Use whenever code is named or referenced — "gather context on X", "look at the Y directory", "what does Z do", "what's the state of W" — or when a task requires understanding how something is laid out first.
allowed-tools: Read, Glob, Grep, Bash
---

# local-codecontext

Read-only. Find the code, learn its state, report what matters. The target may
be a whole repository, a single directory, or a handful of files — scale the
steps below to the scope given.

## Locate

Code lives under `~/Documents/GitHub`, one directory per repo. If given a name
rather than a path, match on it instead of guessing:

```bash
ls -d ~/Documents/GitHub/*<name>*
```

If nothing matches, say so and ask. Do not search the wider filesystem. If given
an explicit path to a directory or file, use it directly.

## Read state

Pull what applies to the scope, in this order, stopping once you have enough:

| Source | What it gives |
|--------|---------------|
| `README.md` | Intent and setup. May be stale. |
| manifest | `go.mod`, `CMakeLists.txt`, `pyproject.toml`, `package.json` |
| `git ls-files <path>` | Real layout, ignored paths already excluded |
| `git log --oneline -15 -- <path>`, `git status` | Where work stopped |

For a directory or a few files, skip the repo-wide sources and go straight to
the files themselves and their immediate imports.

Read every file whole. No line ranges, no `head`, no truncated reads — partial
reads produce confident wrong conclusions about code you have not seen. If a
file is too large to read whole, say so rather than reading part of it.

Use `Grep` to decide which files to read, then read those files in full. Read
interfaces and headers before implementations.

## Report

Lead with what the code is and its current state in two or three sentences, then
the layout, then whatever was asked. Synthesize — do not read files back. Flag
contradictions between the README and the code.

## Boundaries

Reading only. No edits, no builds, no tests, no branches, no commits unless
asked separately.
