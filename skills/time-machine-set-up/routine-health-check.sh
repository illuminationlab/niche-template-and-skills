#!/usr/bin/env bash
# routine-health-check.sh — daily live-site health check + git/redeploy check (REPORT ONLY).
#
# Reads the Live niche domains from _website-template/REGISTRY.md, does a plain
# HTTPS GET against each, checks the response code and TLS cert expiry, THEN scans
# the illuminationlab GitHub org for any commits pushed in the last 24h (so you know
# which repos need a manual Coolify redeploy — the auto-deploy webhook is broken).
# Posts one combined summary to your Google Chat webhook (CHAT_WEBHOOK_URL).
#
# GUARDRAILS (see routines.md):
#   - GET only. Never POSTs to a form or webhook. Never touches n8n
#     (LEAD_WEBHOOK / NEWSLETTER_WEBHOOK are NOT read or called here).
#   - No deploys, no DNS, no registry edits. Read + report only.
#   - The git check is read-only `gh` (list repos + read commits). It never pushes,
#     deploys, or redeploys — it only tells you a manual redeploy is needed.
#
# If CHAT_WEBHOOK_URL is unset it prints the report to stdout (so it still works
# under the LaunchAgent log before the webhook is configured).
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REGISTRY="$REPO_ROOT/_website-template/REGISTRY.md"
[ -f "$HOME/.claude/env.local" ] && source "$HOME/.claude/env.local"

# --- parse Live domains (column 6 of the Live niches table) ---
domains=$(awk '
  /^## Live niches/   { in_live = 1; next }
  /^## /              { if (in_live) in_live = 0 }
  in_live && /^\| [a-z]/ {
    n = split($0, c, "|"); d = c[6]; gsub(/^ +| +$/, "", d);
    if (d != "" && d != "Domain") print d
  }
' "$REGISTRY")

[ -z "$domains" ] && { echo "health-check: no Live domains found in REGISTRY.md"; exit 0; }

problems=0
lines=""
while IFS= read -r d; do
  [ -z "$d" ] && continue
  code=$(curl -sS -A "IL-health-check" --max-time 20 -o /dev/null -w '%{http_code}' "https://$d" 2>/dev/null || echo "000")
  # TLS days-to-expiry (best effort)
  days="?"
  end=$(echo | openssl s_client -servername "$d" -connect "$d:443" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
  if [ -n "$end" ]; then
    ends=$(date -j -f "%b %d %T %Y %Z" "$end" +%s 2>/dev/null || echo "")
    [ -n "$ends" ] && days=$(( (ends - $(date +%s)) / 86400 ))
  fi
  status="OK"
  if [ "$code" != "200" ]; then status="DOWN (HTTP $code)"; problems=$((problems+1));
  elif [ "$days" != "?" ] && [ "$days" -lt 14 ]; then status="cert expires in ${days}d"; problems=$((problems+1)); fi
  mark=$([ "$status" = "OK" ] && echo "✅" || echo "⚠️")
  lines="${lines}${mark} ${d} — HTTP ${code}, cert ${days}d — ${status}"$'\n'
done <<< "$domains"

if [ "$problems" -eq 0 ]; then
  header="✅ Live-site health check: all sites OK"
else
  header="⚠️ Live-site health check: ${problems} issue(s) need attention"
fi
report="${header}"$'\n'"${lines}"

# --- git / redeploy check (report only; read-only gh; no n8n, no deploys) ---
# Scans every repo in the illuminationlab org for commits on its default branch in
# the last 24h. If any, remind to manually redeploy in Coolify (webhook is broken).
GH="$(command -v gh || true)"
for c in "$HOME/.local/bin/gh" /opt/homebrew/bin/gh /usr/local/bin/gh; do
  [ -x "$c" ] && GH="$c" && break
done
if [ -n "${GH:-}" ]; then
  since=$(date -u -v-24H +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -d '24 hours ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null)
  repos=$("$GH" repo list illuminationlab --limit 200 --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null)
  # Repos that are NOT deployed on Coolify — commits here never need a redeploy, so
  # they're skipped in the nag below (space-padded list; add tooling/source-only repos).
  # niche-template-and-skills is source/tooling (template + skills + routines), and the
  # daily backup-sync commits to it, so without this it would false-flag every day.
  not_deployed=" illuminationlab/niche-template-and-skills "
  if [ -n "$repos" ]; then
    pushed=""
    while IFS= read -r r; do
      [ -z "$r" ] && continue
      case "$not_deployed" in *" $r "*) continue ;; esac
      # On HTTP errors (e.g. 409 "empty repository") gh ignores -q and dumps the raw
      # error JSON + exits non-zero -> the `|| n=0` catches that so a status code like
      # 409 can never be misread as a commit count. On success -q returns the count.
      n=$("$GH" api "repos/$r/commits?since=$since&per_page=100" -q 'if type=="array" then length else 0 end' 2>/dev/null) || n=0
      n=${n//[^0-9]/}; [ -z "$n" ] && n=0
      if [ "$n" -gt 0 ]; then
        pushed="${pushed}⚠️ ${r} — ${n} commit(s) in 24h — redeploy in Coolify to see changes"$'\n'
      fi
    done <<< "$repos"
    if [ -n "$pushed" ]; then
      git_report="⚠️ Git: repos pushed in the last 24h (manual redeploy needed):"$'\n'"${pushed}"
    else
      git_report="✅ Git: no pushes/commits in the last 24h — no redeployment needed"
    fi
  else
    git_report="ℹ️ Git: could not list illuminationlab repos (check gh auth in this context)"
  fi
else
  git_report="ℹ️ Git: check skipped — gh CLI not found"
fi
report="${report}"$'\n'"${git_report}"

if [ -n "${CHAT_WEBHOOK_URL:-}" ]; then
  # Google Chat incoming webhook expects {"text": "..."}
  payload=$(printf '%s' "$report" | python3 -c 'import json,sys; print(json.dumps({"text": sys.stdin.read()}))')
  curl -sS -X POST -H 'Content-Type: application/json' -d "$payload" "$CHAT_WEBHOOK_URL" >/dev/null \
    && echo "health-check: posted to Google Chat ($problems issue(s))." \
    || echo "health-check: FAILED to post to Chat webhook."
else
  echo "health-check: CHAT_WEBHOOK_URL not set — printing report:"
  printf '%s\n' "$report"
fi
