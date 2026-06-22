#!/usr/bin/env bash
# install-routines.sh — (re)create every recurring routine as a macOS LaunchAgent.
# Run by Step 5b of /time-machine-set-up so routines are restored on any new machine.
# Idempotent: re-running rewrites + reloads the agents. See routines.md for the manifest.
#
# Routines (all report/backup only — NO n8n, NO deploys, NO DNS):
#   1. backup-sync          daily  6:43pm   commit+push this repo to GitHub
#   2. health-check         daily  7:08am   GET each live domain, post to Chat
#   3. ghl-prompt-reminder  monthly 1st 8:06am  Chat reminder to review GHL VoiceAI prompts
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LA="$HOME/Library/LaunchAgents"
mkdir -p "$LA" "$HOME/.claude/logs"
PATHVAL="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# write_agent <label> <script> <calendar-dict-inner-xml>
write_agent() {
  local label="$1" script="$2" cal="$3"
  local plist="$LA/$label.plist"
  cat > "$plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$label</string>
  <key>ProgramArguments</key>
  <array><string>/bin/bash</string><string>$SKILL_DIR/$script</string></array>
  <key>EnvironmentVariables</key>
  <dict><key>PATH</key><string>$PATHVAL</string><key>HOME</key><string>$HOME</string></dict>
  <key>StartCalendarInterval</key>
  <dict>$cal</dict>
  <key>StandardOutPath</key><string>$HOME/.claude/logs/${label##*.}.out.log</string>
  <key>StandardErrorPath</key><string>$HOME/.claude/logs/${label##*.}.err.log</string>
</dict>
</plist>
EOF
  launchctl unload "$plist" 2>/dev/null || true
  launchctl load "$plist"
  echo "loaded: $label"
}

write_agent "io.illuminationlab.backup-sync"         "backup-sync.sh" \
  "<key>Hour</key><integer>18</integer><key>Minute</key><integer>43</integer>"
write_agent "io.illuminationlab.health-check"         "routine-health-check.sh" \
  "<key>Hour</key><integer>7</integer><key>Minute</key><integer>8</integer>"
write_agent "io.illuminationlab.ghl-prompt-reminder"  "routine-ghl-prompt-reminder.sh" \
  "<key>Day</key><integer>1</integer><key>Hour</key><integer>8</integer><key>Minute</key><integer>6</integer>"

echo
echo "Active Illumination Lab routines:"
launchctl list | grep illuminationlab || echo "(none — check for errors above)"
echo
echo "NOTE: health-check + ghl-reminder post to Google Chat via CHAT_WEBHOOK_URL"
echo "      in ~/.claude/env.local. Set that (Step 6) or they'll only log locally."
