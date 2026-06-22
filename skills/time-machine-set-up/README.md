# time-machine-set-up

**Disaster recovery for a new machine.** The one skill you run *first* on a fresh Mac (or a
brand-new Claude Code terminal with nothing configured) to get back to a fully-working
Illumination Lab workstation.

## What it does

Walks you, top to bottom, through:

1. Sanity-check what's already installed
2. Install the GitHub CLI (`gh`) — with or without Homebrew
3. Authenticate to GitHub + wire `gh` in as git's credential helper
4. Set your git identity
5. Clone this backup repo
6. Install every skill into `~/.claude/skills/`
7. Rebuild the `~/.claude/env.local` secrets file (restored by hand — not in the repo)
8. Recreate the live working directories (`~/Desktop/repos/niche-sites/_website-template/`)
9. Reconnect MCP servers (Gmail, Google Calendar, Google Drive, Semrush)
10. Verify everything

Every step is idempotent — safe to re-run if you're only missing a piece or two.

## Usage

On a new machine, once you have *this repo* cloned (or just this folder), open Claude Code and:

```
/time-machine-set-up
```

…then follow the steps. The interactive GitHub login (Step 2) is the only part you must run
yourself — prefix it with `!` in Claude Code so it runs in-session.

## Files

- `SKILL.md` — the full checklist Claude reads.
- `install-all-skills.sh` — copies every skill in this repo into `~/.claude/skills/` (Step 5).

## Note on secrets

`~/.claude/env.local` is **never** in this repo — it holds live API tokens. Step 6 lists every
required key and creates a blank template; you paste the real values from your old machine.
