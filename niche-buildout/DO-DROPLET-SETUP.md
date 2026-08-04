# Claude Code on a Dedicated DO Droplet — Setup

Goal: a persistent, shared **Illumination Lab workstation** running **Claude Code (CLI)** on its own small DigitalOcean droplet — **separate from the production Coolify droplet** (`167.71.191.14`). Anyone with SSH to this box shares the same Claude environment. This is the "Hermes lives in the droplet" pattern, done safely.

> Use Claude **Code**, not the Desktop app. Desktop is a GUI chat window and can't run on a headless server; Claude Code is terminal-native and is the only one that can actually do the work.

## 1. Create the droplet (DO dashboard)
- **Ubuntu 24.04 LTS**
- Basic / Regular, **2 GB RAM minimum** (4 GB comfortable — Node + Claude Code)
- Region: closest to you
- **Add your SSH key**
- Name it e.g. `il-claude-workstation`
- ⚠️ Do NOT reuse the production Coolify droplet.

## 2. SSH in
```
ssh root@<NEW_DROPLET_IP>
```

## 3. Install prerequisites
```
apt update && apt -y upgrade
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -   # Node 20 LTS
apt install -y nodejs git ripgrep tmux jq
type -p gh >/dev/null || (apt install -y wget && \
  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
  apt update && apt install -y gh)
node -v && git --version && gh --version
```

## 4. Install Claude Code
```
npm install -g @anthropic-ai/claude-code
claude --version
```

## 5. Authenticate Claude Code
- **Subscription login:** run `claude`, pick login, open the printed URL on any browser, paste the code back. **Best for headless/automation:** an API key —
```
export ANTHROPIC_API_KEY=...        # from console.anthropic.com
echo 'export ANTHROPIC_API_KEY=...' >> ~/.bashrc
```

## 6. GitHub auth
```
gh auth login       # or: echo <TOKEN> | gh auth login --with-token
gh auth status
```

## 7. Clone the repos
```
cd ~ && git clone https://github.com/illuminationlab/niche-template-and-skills.git
mkdir -p ~/repos/niche-sites && cd ~/repos/niche-sites
for r in NeedleMoved EngineGuild CallAndCrawl WattsBooked FullTeeSheet RafterElite LimoBooked; do gh repo clone illuminationlab/$r; done
```

## 8. Install the skills
```
mkdir -p ~/.claude/skills
for d in ~/niche-template-and-skills/skills/*/; do ln -s "$d" ~/.claude/skills/; done
ls ~/.claude/skills
```

## 9. Recreate `env.local` — SECRETS (transfer securely, NEVER paste in a shared note)
From your Mac:
```
scp ~/.claude/env.local root@<NEW_DROPLET_IP>:~/.claude/env.local
```
Holds the Coolify API token, n8n webhooks, GHL location, legal vars. **Do not commit it or put its contents in any message.**

## 10. Bring the memory over (so Claude remembers everything)
From your Mac:
```
scp -r ~/.claude/projects/-Users-tyfriese/memory root@<NEW_DROPLET_IP>:~/il-memory
```
On the droplet, place it where the new project's memory dir lives (or let `/time-machine-set-up` wire it). The onboarding note (below) also carries the essentials in prose, so Claude is caught up even before the files land.

## 11. Finish provisioning
Start `claude` and run **`/time-machine-set-up`** — it wires skills, git identity, working dirs, and MCP.

## 12. MCP
- **OpenSEO** — add to `~/.claude.json` → `mcpServers`: `{ "openseo": { "type": "http", "url": "https://app.openseo.so/mcp" } }`, then re-auth via the OAuth prompt.
- claude.ai connectors (Google Drive / Gmail) usually need a browser — may not work headless. OpenSEO + Coolify/GitHub-via-API are fine.

## 13. Run in a durable session
```
tmux new -s claude
claude
```
Detach `Ctrl-b d`, reattach `tmux attach -t claude`. Survives SSH disconnects. For automations: `claude -p "<prompt>"` from cron.

## Paths change on the droplet
On the Mac everything was under `/Users/tyfriese/…`. On the droplet it's `~` (e.g. `/root`): template/skills at `~/niche-template-and-skills`, niche repos at `~/repos/niche-sites`, secrets at `~/.claude/env.local`. The onboarding note tells the new Claude this.
