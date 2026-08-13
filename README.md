# skills

Claude skills, installed into the personal skills directory shared by Claude
Code and Claude Desktop.

## Layout

```
skills/          one directory per skill, named after the skill
tools/           repo scripts
```

## Skills

| Skill | Description |
|-------|-------------|
| `local-codecontext` | Read-only orientation on a codebase — a repo, directory, or set of files. Locates the target under `~/Documents/GitHub` or an explicit path, reads the README, manifest, and git history, and reports a synthesis. Reads files whole. Built-in tools only, no edits. |
| `local-unittest` | Write unit tests in the house style for C++ (GoogleTest), Go (standard `testing`), Python (pytest), and Java (JUnit 5 / Mockito). Covers naming, assertion style, mocks, fixtures, and failure/boundary coverage. |

## Scripts

| Script | Description |
|--------|-------------|
| `tools/install.sh` | Symlinks each `skills/<name>` directory into `~/.claude/skills/<name>`, replacing any existing entry. Directories without a `SKILL.md` are ignored. Run with `./tools/install.sh`. |
