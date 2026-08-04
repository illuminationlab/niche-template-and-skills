#!/usr/bin/env bash
# One-shot: install Claude Code + clone everything on a fresh Ubuntu droplet.
set -e

echo ">>> installing packages (node, git, gh, tmux)..."
apt-get update -y
apt-get install -y curl git tmux jq ripgrep
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
if ! type -p gh >/dev/null; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list
  apt-get update -y && apt-get install -y gh
fi

echo ">>> installing Claude Code..."
npm install -g @anthropic-ai/claude-code
mkdir -p ~/.claude/skills

echo ">>> cloning repos..."
cd ~ && [ -d niche-template-and-skills ] || git clone https://github.com/illuminationlab/niche-template-and-skills.git
mkdir -p ~/repos/niche-sites && cd ~/repos/niche-sites
for r in NeedleMoved EngineGuild CallAndCrawl WattsBooked FullTeeSheet RafterElite LimoBooked; do
  [ -d "$r" ] || git clone https://github.com/illuminationlab/$r.git
done

echo ">>> installing skills..."
for d in ~/niche-template-and-skills/skills/*/; do ln -sf "$d" ~/.claude/skills/; done

echo ""
echo "=================================================="
echo "DONE. Now, in order:"
echo "  1) gh auth login        <- so Claude can push"
echo "  2) send secrets from your Mac (see the message)"
echo "  3) claude               <- log in, then paste the note"
echo "=================================================="
