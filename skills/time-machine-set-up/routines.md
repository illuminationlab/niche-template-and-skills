# Routines manifest

The source-of-truth list of every recurring routine the Illumination Lab workstation
should have. **This file is the backup** — if routines are lost (new machine, factory
reset, `scheduled_tasks.json` gone), `/time-machine-set-up` Step 5b recreates them from
this list via the `/schedule` skill.

When you add, change, or remove a routine: **update this file too**, then the daily backup
pushes it to GitHub. The routine list and the routines themselves never drift apart.

## Guardrails (apply to EVERY routine here)

- **Strictly routine.** A routine only reads/reports/backs-up. It must NOT trigger
  production side-effects.
- **No n8n.** No routine may call, link to, or "check in" with n8n webhooks
  (`LEAD_WEBHOOK`, `NEWSLETTER_WEBHOOK`, or any n8n URL). Those are live lead/newsletter
  pipelines — a routine firing them would create phantom leads/sends. Health checks hit
  domains with plain GET requests only; they never POST to a form/webhook.
- **No deploys, no DNS changes, no registry promotion** from a routine. Those stay manual
  (`/niche-launch`).

> Post-setup check (requested): after these are created, audit each one and confirm none of
> them connect to or depend on n8n. See the n8n guardrail above.

---

## 1. Daily backup to GitHub

- **What:** Review the day's work, and if the live skills/template/manifest changed in any
  meaningful way, commit + push this repo to GitHub. Smart, not blind — skip trivial/no-op
  diffs; write a real commit message describing what changed.
- **Why:** Continuous off-machine backup so a freak file-loss never sets us back more than a day.
- **Schedule:** Daily (off-peak, e.g. ~6:40pm local).
- **Action:** run `skills/time-machine-set-up/backup-sync.sh`, or have Claude review the diff
  first and then run it. Because live skills are symlinked into the repo, the working tree is
  already current — this just commits + pushes.
- **n8n:** none. Pure git.

## 2. Live-site health check

- **What:** GET each live niche domain (from `_website-template/REGISTRY.md`) and report any
  that are down, returning non-200, or have an expiring/invalid TLS cert. Report only.
- **Why:** Catch a dead deploy or DNS/cert problem before a client/visitor does.
- **Schedule:** Daily (e.g. ~7:10am local).
- **Action:** read the Live rows from `REGISTRY.md`, `curl -sS -o /dev/null -w '%{http_code}'`
  each domain (plain GET, never a form POST), summarize failures.
- **n8n:** none — GET only, never touches `LEAD_WEBHOOK`/`NEWSLETTER_WEBHOOK`.

## 3. GHL VoiceAI prompt checker

- **What:** Weekly review of the GoHighLevel prompts powering the VoiceAI agents. Read each
  agent's current prompt, evaluate for efficiency/clarity/drift, and report suggested
  tightenings. **Report only — does not edit live prompts.**
- **Why:** Keep the VoiceAI agent prompts as lean and effective as possible over time.
- **Schedule:** Weekly (e.g. Mon ~8:05am local).
- **Action:** TODO — fill in how the GHL prompts are accessed (GHL API endpoint + which
  agents/locations, or the GHL dashboard URL). Credentials/URLs go in `~/.claude/env.local`,
  not here. Once that's known, the routine fetches each prompt and produces an efficiency report.
- **n8n:** none — reads GHL only, reports back; no n8n, no live prompt writes.

---

## How to (re)create these on a new machine

Step 5b of `/time-machine-set-up` does this: for each routine above, invoke the `/schedule`
skill with the schedule + action described. Keep `recurring: true` and make them durable so
they survive restarts. After creating, run the n8n guardrail audit.
