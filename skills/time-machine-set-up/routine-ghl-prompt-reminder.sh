#!/usr/bin/env bash
# routine-ghl-prompt-reminder.sh — MONTHLY reminder to review the GHL VoiceAI
# agent prompts for efficiency. Posts a nudge to Google Chat. Report/reminder
# only — does NOT read or edit any GHL prompt, does NOT touch n8n.
#
# (Placeholder for the future automated checker: once GHL_API_KEY + GHL_LOCATION_ID
#  are set in ~/.claude/env.local, this can be upgraded to fetch + evaluate prompts.)
set -uo pipefail
[ -f "$HOME/.claude/env.local" ] && source "$HOME/.claude/env.local"

msg="🗓️ Monthly reminder: review the GHL VoiceAI agent prompts for efficiency.
Open GoHighLevel → VoiceAI agents → re-read each prompt and tighten anything bloated, stale, or unclear.
(When you're ready to automate this, add GHL_API_KEY + GHL_LOCATION_ID to ~/.claude/env.local.)"

if [ -n "${CHAT_WEBHOOK_URL:-}" ]; then
  payload=$(printf '%s' "$msg" | python3 -c 'import json,sys; print(json.dumps({"text": sys.stdin.read()}))')
  curl -sS -X POST -H 'Content-Type: application/json' -d "$payload" "$CHAT_WEBHOOK_URL" >/dev/null \
    && echo "ghl-reminder: posted to Google Chat." \
    || echo "ghl-reminder: FAILED to post to Chat webhook."
else
  echo "ghl-reminder: CHAT_WEBHOOK_URL not set — message would be:"; printf '%s\n' "$msg"
fi
