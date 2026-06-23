#!/usr/bin/env bash
# routine-ghl-prompt-reminder.sh — MONTHLY reminder to review the GHL VoiceAI
# agent prompts for efficiency. Posts a nudge to Google Chat. Report/reminder
# only — does NOT read or edit any GHL prompt, does NOT touch n8n.
#
# (Placeholder for the future automated checker: once GHL_API_KEY + GHL_LOCATION_ID
#  are set in ~/.claude/env.local, this can be upgraded to fetch + evaluate prompts.)
set -uo pipefail
[ -f "$HOME/.claude/env.local" ] && source "$HOME/.claude/env.local"

# Seasonal closing line — changes with the month (holidays, closures, hours, promos
# to make sure the Voice AI agents reflect — the stuff that's easy to forget).
month=$(date +%m)
case "$month" in
  01) season="Heads up for the season: Valentine's Day is about six weeks out, so the agents should be ready to mention any specials and gift cards. Double-check your MLK Day hours too." ;;
  02) season="Heads up for the season: Valentine's Day is here. Make sure the agents promote any offers and gift cards, and that your Presidents' Day hours are set." ;;
  03) season="Heads up for the season: spring break and Easter are close. Confirm the agents reflect any adjusted hours and can suggest spring skincare refreshes." ;;
  04) season="Heads up for the season: Mother's Day in May is the big one, so start prepping the agents to promote Mother's Day packages and gift cards. Confirm any Easter closure." ;;
  05) season="Heads up for the season: Mother's Day is here (your busiest weekend) and Memorial Day closes the month. Double-check promos, gift cards, and holiday hours in the agents." ;;
  06) season="Heads up for the season: Father's Day and wedding season are on. Make sure the agents can speak to event-ready treatments, and have your July 4th hours ready." ;;
  07) season="Heads up for the season: it's peak vacation time. Confirm the agents reflect July 4th and any staff days off, so callers aren't offered slots you can't staff." ;;
  08) season="Heads up for the season: back-to-school and Labor Day are coming. Set the agents up for any end-of-summer offers and confirm Labor Day hours." ;;
  09) season="Heads up for the season: holiday prep starts now. Have the agents begin teasing fall treatments and gift cards, and confirm Labor Day hours." ;;
  10) season="Heads up for the season: Halloween and the holiday rush are near. Confirm any October offers, and remember the clocks change soon if any messaging is time-based." ;;
  11) season="Heads up for the season: Thanksgiving closure plus Black Friday and Cyber Monday are the headline. Make sure the agents push your holiday offers and gift cards, and have the Thanksgiving hours right." ;;
  12) season="Heads up for the season: holiday closures and gift-card season are in full swing. Confirm the agents have your Christmas and New Year hours, and point callers to gift cards and January openings." ;;
  *)  season="Heads up for the season: check that the agents reflect any upcoming holidays, closures, or seasonal offers." ;;
esac

msg="*Review the GHL Voice AI agents*

Monthly check-in: give your Voice AI agents a quick read-through and make sure they still sound right, answer accurately, and book the way you want.

${season}"

if [ -n "${CHAT_WEBHOOK_URL:-}" ]; then
  payload=$(printf '%s' "$msg" | python3 -c 'import json,sys; print(json.dumps({"text": sys.stdin.read()}))')
  curl -sS -X POST -H 'Content-Type: application/json' -d "$payload" "$CHAT_WEBHOOK_URL" >/dev/null \
    && echo "ghl-reminder: posted to Google Chat." \
    || echo "ghl-reminder: FAILED to post to Chat webhook."
else
  echo "ghl-reminder: CHAT_WEBHOOK_URL not set — message would be:"; printf '%s\n' "$msg"
fi
