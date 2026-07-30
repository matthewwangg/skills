# skills

Claude skills, versioned in one place and installed into the personal skills
directory shared by Claude Code and Claude Desktop.

## Layout

```
skills/          one directory per skill, named after the skill
tools/           repo scripts
```

## Skills

| Skill | Trigger |
|-------|---------|
| _none yet_ | |

## Scripts

| Script | Purpose |
|--------|---------|
| `tools/install.sh` | Symlinks every skill in `skills/` into `~/.claude/skills/` |

### `tools/install.sh`

```bash
./tools/install.sh
```

Links each `skills/<name>` directory into `~/.claude/skills/<name>`, replacing
any existing entry. Directories without a `SKILL.md` are ignored. Because the
entries are symlinks, edits in this repo take effect without reinstalling.
