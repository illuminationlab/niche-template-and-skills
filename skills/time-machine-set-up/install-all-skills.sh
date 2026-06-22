#!/usr/bin/env bash
# Install every Illumination Lab skill from this repo into ~/.claude/skills/.
# Idempotent: re-running overwrites the installed copies with the latest from this checkout.
# Used by Step 5 of the time-machine-set-up skill.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

# Standalone skills that live one-per-folder under skills/
for s in niche-research niche-build niche-launch time-machine-set-up; do
  if [ -d "$REPO_ROOT/skills/$s" ]; then
    rm -rf "${SKILLS_DIR:?}/$s"
    cp -R "$REPO_ROOT/skills/$s" "$SKILLS_DIR/$s"
    echo "installed: $s"
  else
    echo "skip (not found): $s"
  fi
done

# Med-spa suite has its own installer (writer + humanizer) — delegate to it.
if [ -f "$REPO_ROOT/skills/medspa-newsletter-suite/install.sh" ]; then
  echo "running medspa-newsletter-suite installer..."
  bash "$REPO_ROOT/skills/medspa-newsletter-suite/install.sh"
fi

echo
echo "Done. ~/.claude/skills now contains:"
ls "$SKILLS_DIR"
