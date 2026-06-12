#!/usr/bin/env bash
# Pull the latest medspa-newsletter + humanizer from the backup repo and (re)install both.
# Run automatically as Step 0 of the medspa-newsletter skill so partner changes are always live.
set -euo pipefail

REPO="illuminationlab/niche-template-and-skills"
CACHE="$HOME/.claude/skills/.medspa-suite-src"
SKILLS="$HOME/.claude/skills"
SUITE="skills/medspa-newsletter-suite"

# Pull latest (clone on first run, hard-sync to origin/main thereafter)
if [ -d "$CACHE/.git" ]; then
  git -C "$CACHE" fetch --quiet origin
  git -C "$CACHE" reset --hard --quiet origin/main
else
  rm -rf "$CACHE"
  gh repo clone "$REPO" "$CACHE" 2>/dev/null || git clone --quiet "https://github.com/$REPO.git" "$CACHE"
fi

# Reinstall both skills from the latest commit
for s in medspa-newsletter humanizer; do
  rm -rf "${SKILLS:?}/$s"
  cp -R "$CACHE/$SUITE/$s" "$SKILLS/$s"
done

echo "Synced medspa-newsletter + humanizer from latest $REPO (origin/main)"
