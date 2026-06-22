#!/usr/bin/env bash
# routine-health-check.sh — daily live-site health check (REPORT ONLY).
#
# Reads the Live niche domains from _website-template/REGISTRY.md, does a plain
# HTTPS GET against each, checks the response code and TLS cert expiry, and posts
# a summary to your Google Chat webhook (CHAT_WEBHOOK_URL in ~/.claude/env.local).
#
# GUARDRAILS (see routines.md):
#   - GET only. Never POSTs to a form or webhook. Never touches n8n
#     (LEAD_WEBHOOK / NEWSLETTER_WEBHOOK are NOT read or called here).
#   - No deploys, no DNS, no registry edits. Read + report only.
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
