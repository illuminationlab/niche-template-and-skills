# PLAN — Recreate the "Hermes Daily Report" cronjob in Codex

**Status: PLANNED — build when Codex credits are available. Nothing created yet.**
Purpose: preserve the exact job definition so it can be stood up fast, and lay out the
recreation steps + the few things to confirm first.

---

## 1. What the current job is (captured verbatim from the live output)

- **Name:** Hermes Daily Report
- **Current job_id:** `9bc2be558ff6` (the existing instance — for reference only)
- **Schedule (DECIDED):** run daily, **send at 7:00 AM America/New_York** (wall-clock, DST-aware). *(The original instance generated at 13:00 UTC; we're moving the send to 7am ET.)*
- **What it reports:** a Claude spend/usage summary for the **previous UTC day**, against a
  **$20.00/day budget**, plus a 7-day trend.
- **Auth model:** authenticates to Claude via an **OAuth subscription**, so the dollar figures
  are the **API-equivalent value** of usage (token counts × published model pricing), **not a
  metered invoice**. Framed as a spike-detection signal, not accounting.
- **Delivery:** a chat message to the user, with a management footer
  ("stop reminder Hermes Daily Report").

### Exact report format to reproduce
```
📋 Hermes Daily Report — generated <DATE> <TIME> UTC

💸 Claude Spend — <PREV_DATE> (UTC)
🟢 Within budget ($<SPENT> of $20.00)      # 🟢 within / 🟡 near / 🔴 over

• Spend (estimated): $<SPENT>
• Sessions: <N> | API calls: <N>
• Tokens: <TOTAL> total (in <IN> / out <OUT> / cache-read <CR> / cache-write <CW>)
• By model: <breakdown or —>

7-day trend (daily est. spend; avg $<AVG>/day):
  <DATE>   $<AMT>  <bar>
  ... (7 rows) ...            ← <TODAY> marker on the latest row

Note: figures are estimated (token counts × published model pricing). This instance
authenticates via an OAuth subscription, so these are the API-equivalent value of usage,
not a metered invoice. Right signal for spotting usage spikes.
```

---

## 2. Break the job into components (so it ports cleanly)

| Component | Current (Claude/Hermes) | What it needs in Codex |
|---|---|---|
| **Trigger / schedule** | Daily 13:00 UTC cron | A scheduler in the Codex environment (see §3) |
| **Data source** | Claude usage/token logs for the OAuth account | Access to the same usage data from Codex (**confirm — see §4**) |
| **Report generator** | Prompt/logic that formats the numbers above | A script or Codex prompt that emits the same format |
| **Delivery** | Message to user + management footer | Same channel Codex uses to reach you (**confirm**) |
| **Budget/thresholds** | $20/day; 🟢/🟡/🔴 | Same constants, carried over |

---

## 3. Recreation steps (when credits return)

**Recommended mechanism: macOS `launchd` (or `cron`) invoking Codex non-interactively.**
Codex is a CLI agent; the reliable way to run it on a schedule on this Mac is an OS-level
timer that calls the Codex CLI with the report prompt/script.

1. **Write the report generator** — a small script (or a fixed Codex prompt) that:
   - Determines "yesterday" in UTC.
   - Pulls the usage numbers for that day from the data source (see §4).
   - Computes the 7-day trend + average and renders the ASCII bars.
   - Emits the exact format block from §1.
2. **Wrap it for Codex** — a one-shot Codex invocation (non-interactive/headless) that runs
   the generator and sends the message. Keep the prompt/script in the repo so it's versioned.
3. **Schedule it** — a `launchd` plist (preferred on macOS; survives reboots) or a `cron`
   entry set to fire **7:00 AM America/New_York daily** (set the job's TZ to America/New_York
   so it stays 7am through DST — do NOT hardcode a fixed UTC offset).
4. **Wire delivery** — point the output at whatever channel Codex uses to message you (same as
   how Codex already reports back). Include the "stop/manage" footer text.
5. **Test once manually** before enabling the schedule — run the one-shot, confirm the format
   and the numbers match a known day.
6. **Record it** — add the new job_id + schedule here so we have a live reference.

**Alternative:** if the Codex environment has its own native scheduled-tasks/routines feature,
use that instead of launchd and skip step 3's OS timer — but keep the same generator + format.

---

## 4. Decisions LOCKED (2026-07-28)

1. **Data source — RESOLVED:** Codex **can** read Claude's usage/token data, so the job is
   **fully self-contained in Codex** — it pulls the numbers itself, no dependency on the
   Claude side. (Verify the exact access path — log file / export / OAuth account — at build.)
2. **Scheduler — RESOLVED (send time):** run **daily, send at 7:00 AM America/New_York**
   (wall-clock, DST-aware). Mechanism: **prefer Codex-native scheduling if it exists, else
   macOS `launchd`** (cron as last resort). Confirm which mechanism the instant you build.
3. **Delivery — RESOLVED:** deliver via the **same channel Codex already uses** to message you.
4. **Budget — RESOLVED:** **keep $20.00/day** with the 🟢/🟡/🔴 thresholds, unchanged.

Only remaining build-time confirms: the exact Codex API for scheduling (native vs launchd) and
the exact Claude-usage data path — both verifiable in seconds once you're in Codex with credits.

---

## 5. Ready-to-run checklist (for the day credits are back)
- [ ] Re-confirm the two build-time items from §4 (Codex scheduling mechanism + Claude-usage data path).
- [ ] Write/port the report generator script (format from §1).
- [ ] Wrap as a one-shot Codex invocation.
- [ ] Add launchd plist / cron entry to fire 7:00 AM America/New_York daily (or native schedule).
- [ ] Manual test run → verify format + numbers.
- [ ] Enable schedule; record new job_id + schedule back into this file.
