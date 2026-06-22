#!/usr/bin/env bash
# Install every Illumination Lab skill from this repo into ~/.claude/skills/
# by SYMLINKING — so editing the installed skill IS editing the repo working
# tree (no copy step, no drift). The daily backup routine then just commits+pushes.
# Idempotent: re-running re-points the symlinks.
# Used by Step 5 of the time-machine-set-up skill.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

# Standalone skills: symlink ~/.claude/skills/<name> -> <repo>/skills/<name>
for s in niche-research niche-build niche-launch time-machine-set-up; do
  src="$REPO_ROOT/skills/$s"
  dst="$SKILLS_DIR/$s"
  if [ -d "$src" ]; then
    rm -rf "$dst"               # remove any prior copy or stale link
    ln -s "$src" "$dst"
    echo "symlinked: $s -> $src"
  else
    echo "skip (not found): $s"
  fi
done

# Med-spa suite manages itself via its own sync.sh (rm -rf + cp into ~/.claude/skills).
# That design is copy-based on purpose (it git-pulls fresh each use), so we DON'T
# symlink it — we just run its installer so the live copies exist on this machine.
if [ -f "$REPO_ROOT/skills/medspa-newsletter-suite/install.sh" ]; then
  echo "running medspa-newsletter-suite installer (copy-based, self-syncing)..."
  bash "$REPO_ROOT/skills/medspa-newsletter-suite/install.sh"
fi

echo
echo "Done. ~/.claude/skills now contains:"
ls -l "$SKILLS_DIR"
