---
name: time-machine-set-up
description: The disaster-recovery checklist for getting a brand-new machine (or a fresh Claude Code terminal) back to a fully-working Illumination Lab workstation. Installs and authenticates the GitHub CLI, sets the git identity, clones this backup repo, installs every skill into ~/.claude/skills/, rebuilds the ~/.claude/env.local secrets file, recreates the live working directories, and reconnects MCP servers. Run this FIRST on any new computer before /niche-research, /niche-build, /niche-launch, or /medspa-newsletter.
version: 1.0.0
user-invocable: true
argument-hint: ""
---

# /time-machine-set-up

**"Get me back to how I was on my old computer."**

This is the bootstrap checklist for a fresh Mac (or a brand-new Claude Code terminal with nothing configured). Work top to bottom. Each step is idempotent — safe to re-run — so if you're only missing one or two things, skip to the step you need.

The canonical backup of everything lives in this repo: **`illuminationlab/niche-template-and-skills`**. Skills, the website template, and the registry all come from here. The one thing NOT in the repo is secrets (`~/.claude/env.local`) — those are restored by hand in Step 6.

## What "done" looks like

- `gh auth status` shows an authenticated user
- `git config --global user.name` and `user.email` are set
- `~/.claude/skills/` contains: `niche-research`, `niche-build`, `niche-launch`, `needlemoved-daily` (symlinked to the repo), `medspa-newsletter`, `humanizer`, and `time-machine-set-up` (symlinked)
- `~/.claude/env.local` exists with every key in Step 6 populated
- `~/Desktop/repos/niche-sites/_website-template/` exists (symlinked to the repo)
- The routines in `routines.md` are recreated (daily backup, live-site health check, GHL VoiceAI prompt checker)
- `/mcp` shows Gmail, Google Calendar, Google Drive, and Semrush connected

---

## Step 0. Sanity check — what's already here

Run this first so you only do the work you actually need:

```bash
echo "git:  $(git --version 2>/dev/null || echo MISSING)"
echo "gh:   $(command -v gh >/dev/null && gh --version | head -1 || echo MISSING)"
echo "auth: $(gh auth status 2>&1 | grep -m1 'Logged in' || echo 'NOT logged in')"
echo "name: $(git config --global user.name || echo UNSET)"
echo "mail: $(git config --global user.email || echo UNSET)"
echo "skills:"; ls ~/.claude/skills 2>/dev/null || echo "  (none)"
echo "env.local: $([ -f ~/.claude/env.local ] && echo present || echo MISSING)"
echo "template:  $([ -d ~/Desktop/repos/niche-sites/_website-template ] && echo present || echo MISSING)"
```

---

## Step 1. Install the GitHub CLI (`gh`)

If `gh` is already installed (Step 0), skip to Step 2.

**With Homebrew** (if you have it):
```bash
brew install gh
```

**Without Homebrew** (no admin password needed — installs to `~/.local/bin`):
```bash
set -e
cd /tmp
TAG=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/cli/cli/releases/latest | sed -E 's#.*/tag/v?##')
ARCH=$([ "$(uname -m)" = "arm64" ] && echo arm64 || echo amd64)
FILE="gh_${TAG}_macOS_${ARCH}"
curl -fsSL -o gh.zip "https://github.com/cli/cli/releases/download/v${TAG}/${FILE}.zip"
unzip -oq gh.zip
mkdir -p "$HOME/.local/bin"
cp "${FILE}/bin/gh" "$HOME/.local/bin/gh"
chmod +x "$HOME/.local/bin/gh"
# Make it permanent on PATH for future shells
grep -qs 'HOME/.local/bin' ~/.zshrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"
gh --version
```

---

## Step 2. Authenticate to GitHub (interactive)

This step needs your input (browser approval), so **you** run it in the terminal — Claude can't click for you. In Claude Code, prefix with `!` to run it in-session:

```
! gh auth login --hostname github.com --git-protocol https --web
```

It prints a one-time code, opens github.com (you're already signed in), you paste the code and click **Authorize**. Then wire `gh` in as git's credential helper so plain `git push`/`git pull` use it too:

```bash
gh auth setup-git
gh auth status   # expect: "Logged in to github.com account <you>" with scopes repo, read:org, gist
```

---

## Step 3. Set your git identity

```bash
git config --global user.name  "tyfriese"
git config --global user.email "info@illuminationlab.io"
```

(Swap the name/email if a teammate is setting up their own machine.)

---

## Step 4. Clone this backup repo

```bash
mkdir -p ~/Desktop/repos
cd ~/Desktop/repos
gh repo clone illuminationlab/niche-template-and-skills
```

Everything else is restored from this checkout.

---

## Step 5. Install every skill into `~/.claude/skills/`

From the repo you just cloned:

```bash
bash ~/Desktop/repos/niche-template-and-skills/skills/time-machine-set-up/install-all-skills.sh
```

This **symlinks** `niche-research`, `niche-build`, `niche-launch`, and `time-machine-set-up`
into `~/.claude/skills/` — so editing an installed skill IS editing the repo working tree (no
copy step, no drift, and the daily backup just commits + pushes). It then runs the medspa
suite's own installer (`medspa-newsletter` + `humanizer` are copy-based on purpose — they
git-pull fresh on every use). Verify:

```bash
ls -l ~/.claude/skills
# niche-*, needlemoved-daily, and time-machine-set-up show as symlinks (->) into the repo;
# humanizer + medspa-newsletter are real dirs.
```

Also symlink the live website template to the repo so template edits are tracked too:

```bash
mkdir -p ~/Desktop/repos/niche-sites
ln -s ~/Desktop/repos/niche-template-and-skills/_website-template \
      ~/Desktop/repos/niche-sites/_website-template 2>/dev/null || true
```

> **Known gotcha:** `niche-research`, `niche-build`, and `niche-launch` currently hardcode `/Users/laurenwilliams/Desktop/repos/niche-sites/...` paths. On a machine with a different home directory those paths won't resolve. Until the skills are made portable (use `$HOME`/`~`), either edit the path in the (now symlinked, so repo-tracked) skill or work from Lauren's account. The medspa suite and this skill are already home-dir-agnostic.

## Step 5b. Recreate the recurring routines

Routines run as macOS **LaunchAgents** (they fire on schedule whether or not Claude is open).
They don't survive a wipe — rebuild them from the repo with one command:

```bash
bash ~/Desktop/repos/niche-template-and-skills/skills/time-machine-set-up/install-routines.sh
```

That (re)creates and loads all three:

1. **Daily backup to GitHub** (6:43pm) — `backup-sync.sh` commits + pushes this repo.
2. **Live-site health check** (7:08am daily) — GET every Live domain in `REGISTRY.md`, post results to Chat.
3. **GHL VoiceAI prompt reminder** (monthly, 1st @ 8:06am) — Chat reminder to review the prompts.

Health-check + GHL reminder post to **Google Chat** via `CHAT_WEBHOOK_URL` (set in Step 6) — until
that's set they only write to `~/.claude/logs/`. The full manifest (schedules, actions, upgrade
notes) is in **`routines.md`**.

**Guardrail:** every routine is read/report/backup only — **no routine calls n8n** (`LEAD_WEBHOOK`/`NEWSLETTER_WEBHOOK`), triggers deploys, or changes DNS/registry. After recreating, confirm each one stays clean. See `routines.md` for the full guardrails.

Verify they loaded:
```bash
launchctl list | grep illuminationlab   # expect backup-sync, health-check, ghl-prompt-reminder
```

---

## Step 6. Rebuild the secrets file `~/.claude/env.local`

**This file is NOT in the repo** (it holds live API tokens) — you restore it by hand. Create it and paste in your real values. The keys below are every secret the skills reference:

```bash
mkdir -p ~/.claude
cat > ~/.claude/env.local <<'EOF'
# ── Coolify (deploy host) ──────────────────────────────
export COOLIFY_API_TOKEN=""        # Coolify > Keys & Tokens > API tokens
export COOLIFY_BASE_URL=""         # e.g. https://coolify.yourhost.com/api/v1
export COOLIFY_SERVER_UUID=""      # the target server's UUID (and/or IP)

# ── Lead / newsletter webhooks (n8n) ───────────────────
export LEAD_WEBHOOK=""             # n8n contact-form webhook URL
export NEWSLETTER_WEBHOOK=""       # n8n newsletter-signup webhook URL

# ── Chat / booking widgets ─────────────────────────────
export CHATBOT_WIDGET_ID=""        # site chatbot widget id
export GHL_CALENDAR_URL=""         # GoHighLevel booking calendar URL

# ── Routine delivery + GHL access (used by the routines) ──
export CHAT_WEBHOOK_URL=""         # Google Chat incoming-webhook URL (routine reports post here)
export GHL_API_KEY=""              # GoHighLevel API key/token (VoiceAI prompt-checker routine)
export GHL_LOCATION_ID=""          # GHL location/sub-account id for the VoiceAI agents

# ── Shared business / legal defaults ───────────────────
export INTERNAL_EMAIL=""           # where lead notifications go
export LEGAL_ENTITY=""             # legal company name on the sites
export IL_FORMATION_STATE=""       # e.g. Wyoming
export IL_GOVERNING_LAW=""         # e.g. Wyoming
export IL_MAILING_ADDRESS=""       # registered mailing address
EOF
chmod 600 ~/.claude/env.local
echo "Created ~/.claude/env.local — now open it and paste the real values."
```

> Where the real values come from: copy them from your old machine's `~/.claude/env.local`, or from wherever you keep these secrets. **Never commit this file** to any repo (the niche site repos are public). Some keys (`IL_FORMATION_STATE`, `IL_GOVERNING_LAW`, `IL_MAILING_ADDRESS`) get filled in once by `/niche-build` on the first legal-page build and written back here — fine to leave blank initially.

Confirm it loads cleanly:
```bash
source ~/.claude/env.local && echo "env.local sourced OK"
```

---

## Step 7. Recreate the live working directories

The skills + README expect the website template at a known live path:

```bash
mkdir -p ~/Desktop/repos/niche-sites
cp -R ~/Desktop/repos/niche-template-and-skills/_website-template ~/Desktop/repos/niche-sites/_website-template
ls ~/Desktop/repos/niche-sites/_website-template/REGISTRY.md && echo "template in place"
```

The individual live niche sites (`NeedleMoved`, `rafterelite`, `EngineGuild`, `CallAndCrawl`) are separate repos under the `illuminationlab` org — clone any you need to work on:

```bash
cd ~/Desktop/repos/niche-sites
for r in NeedleMoved rafterelite EngineGuild CallAndCrawl; do gh repo clone "illuminationlab/$r"; done
```

---

## Step 8. Reconnect MCP servers

The Illumination Lab workflow uses these connectors: **Gmail, Google Calendar, Google Drive, Semrush**. Check what's connected:

```
/mcp
```

Reconnect any that are missing through the same flow you use in Claude (connectors / `/mcp` authenticate). These are tied to your Claude account, so signing in usually restores them — just re-authorize each if prompted.

---

## Step 9. Final verification

Re-run the Step 0 sanity check. Everything should now report present/installed/logged-in. Then smoke-test a skill:

```
/niche-research --help     (or just describe a niche to confirm the skill loads)
```

You're back to where you were. 🎉

---

## Keeping this repo current (continuous, never-ending backup)

The point of this whole setup: **never be blindsided by losing a computer's files.** Because the
live skills + template are **symlinked** into this repo (Step 5), every edit you make is already
in the repo working tree — no manual copy step. Two layers keep GitHub current:

1. **The daily backup routine** (Step 5b / `routines.md`) reviews the day's changes and runs
   `backup-sync.sh` to commit + push. This is the safety net — at most a day of work is ever
   un-pushed.
2. **On-demand backup** — any time you finish something you don't want to risk, run:
   ```bash
   bash ~/.claude/skills/time-machine-set-up/backup-sync.sh
   ```
   It commits + pushes if anything changed, and is a quiet no-op if not.

`backup-sync.sh` also refreshes the copy-based medspa suite into the repo before pushing, so
those two skills are backed up too (they self-sync forward via their own `sync.sh` on use).

**When you add / change / remove anything** — a new skill, a template tweak, a new routine —
it flows to GitHub automatically. The only thing to remember by hand: if you add or change a
**routine**, update `routines.md` so the routine list itself stays backed up and restorable.
