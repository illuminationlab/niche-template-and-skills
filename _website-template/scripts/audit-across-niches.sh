#!/usr/bin/env bash
# audit-across-niches.sh — run a grep pattern across every live niche site
# under /repos/niche-sites/ and report which sites match.
#
# Usage:
#   bash scripts/audit-across-niches.sh '<grep_pattern>' [glob]
#
# Examples:
#   bash scripts/audit-across-niches.sh 'free trial'
#   bash scripts/audit-across-niches.sh '20-minute demo' '*.html'
#   bash scripts/audit-across-niches.sh 'aspect-ratio: 4/3' '*.css'
#
# Use this whenever you fix a bug in one niche site to check whether the
# same pattern exists in any of the others — per the cross-niche audit
# rule (playbook Section 11). If it does, fix-and-redeploy across all
# matched niches in the same session.

set -euo pipefail

PATTERN="${1:?Usage: bash scripts/audit-across-niches.sh '<grep_pattern>' [glob]}"
GLOB="${2:-*.html}"

NICHE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REGISTRY_PATH="$NICHE_ROOT/_website-template/REGISTRY.md"

# Derive the niche list from REGISTRY.md's "Live niches" table so adding a
# new niche row to the registry automatically extends this script's coverage
# (no manual array sync needed). Parses col 10 ("Repo" column) of each data
# row in the Live niches section, then takes the basename for the local dir.
read_niches_from_registry() {
  awk '
    /^## Live niches/   { in_live = 1; next }
    /^## /               { if (in_live) in_live = 0 }
    in_live && /^\| [a-z]/ {
      n = split($0, cols, "|")
      repo = cols[10]
      gsub(/`/, "", repo)
      gsub(/^ +| +$/, "", repo)
      m = split(repo, parts, "/")
      if (m > 0 && parts[m] != "") print parts[m]
    }
  ' "$REGISTRY_PATH"
}

# Portable across bash 3.2 (macOS default) and bash 4+ — avoid mapfile.
NICHES=()
if [[ -f "$REGISTRY_PATH" ]]; then
  while IFS= read -r niche; do
    [[ -n "$niche" ]] && NICHES+=("$niche")
  done < <(read_niches_from_registry)
fi
# Hard fallback if REGISTRY parsing yields nothing (avoid a silent no-op)
if [[ ${#NICHES[@]} -eq 0 ]]; then
  NICHES=("NeedleMoved" "RafterElite" "EngineGuild" "CallAndCrawl")
fi

echo "Pattern: $PATTERN"
echo "Glob:    $GLOB"
echo "Root:    $NICHE_ROOT"
echo "─────────────────────────────────────────────────────────"

ANY_MATCH=0
for niche in "${NICHES[@]}"; do
  niche_dir="$NICHE_ROOT/$niche"
  if [[ ! -d "$niche_dir" ]]; then
    echo "  SKIP   $niche (directory not found)"
    continue
  fi

  # `|| true` masks grep's exit-1 when no matches exist; otherwise pipefail
  # would kill the script before checking the next niche.
  count=$( { grep -riE "$PATTERN" --include="$GLOB" "$niche_dir" 2>/dev/null || true; } | wc -l | tr -d ' ')
  if [[ "$count" -gt 0 ]]; then
    ANY_MATCH=1
    printf "  ⚠️  %-15s %s match(es)\n" "$niche:" "$count"
    grep -riE "$PATTERN" --include="$GLOB" "$niche_dir" 2>/dev/null | head -3 | sed 's|^|       |'
    if [[ "$count" -gt 3 ]]; then echo "       ... and $((count - 3)) more"; fi
  else
    printf "  ✓  %-15s clean\n" "$niche:"
  fi
done

echo "─────────────────────────────────────────────────────────"
if [[ "$ANY_MATCH" -eq 0 ]]; then
  echo "All niches clean for pattern: $PATTERN"
  exit 0
else
  echo "One or more niches have the pattern. Apply the same fix across all"
  echo "matched niches AND to the template (so future niches don't inherit"
  echo "the bug). Then redeploy each affected niche via Coolify."
  exit 1
fi
