#!/usr/bin/env bash
# Continuous backup: push the current state of this repo to GitHub.
#
# Because the live skills + template are SYMLINKED into this repo (see
# install-all-skills.sh), the repo working tree always reflects your latest
# edits — so backup is just "commit anything changed, then push".
#
# Designed to be run by the daily backup ROUTINE (see routines.md), or by hand
# any time you want an immediate off-machine snapshot.
#
# Safe + quiet: exits 0 with a message when there's nothing to back up.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

# The medspa suite is copy-based; refresh its snapshot from the live copies so it
# gets backed up too (the niche-* + time-machine skills are symlinked, so already live).
for s in medspa-newsletter humanizer; do
  if [ -d "$HOME/.claude/skills/$s" ]; then
    rm -rf "skills/medspa-newsletter-suite/$s"
    cp -R "$HOME/.claude/skills/$s" "skills/medspa-newsletter-suite/$s"
  fi
done

git add -A

if git diff --cached --quiet; then
  echo "backup-sync: nothing changed — repo already matches GitHub."
  exit 0
fi

STAMP="${1:-$(git diff --cached --name-only | wc -l | tr -d ' ') files}"
git commit -q -m "Backup sync: $STAMP

Automated snapshot of live skills + template state.

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
git push -q origin main
echo "backup-sync: committed + pushed to origin/main."
git --no-pager log --oneline -1
