---
name: daily-marketing-engine
description: |
  The daily marketing engine. Takes ONE hand-made daily topic (an interview MD dropped in
  the shared "Chief Automation Experts" Google Drive) and fans it out across EVERY live niche
  site — same core idea, unique per-niche context — running a chain of specialist agents:
  writer -> humanizer -> SEO -> designer -> QA gate -> publisher (auto), then email + social
  (drafts). Each step is its own all-time-professional agent. Use when a new interview MD lands,
  or the user says "run the daily marketing engine" / "run the daily engine for <topic>".
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Agent
  - Skill
  - AskUserQuestion
---

# Daily Marketing Engine

One deliberate human input per day (a voice interview → an MD brief) becomes **niche-specific
content on every site**, published organically and drafted for email + social. It is **one
workflow made of specialist agents** — each step is handed to a dedicated sub-agent that is a
world-class professional at that one job, and nothing advances until the step before it is done
to a publishable standard.

> **Trust model:** the blog auto-publishes and (when flipped on) email auto-sends. That is only
> safe because of the **QA GATE** (Step 6) — a dedicated skeptic agent that refuses to ship
> anything off-brand, fabricated, non-compliant, or robotic. Never weaken or skip it.

## The input — the interview MD
Your partner does the voice "interview," which exports one Markdown file to the shared Drive
folder **"Chief Automation Experts"**
(`https://drive.google.com/drive/u/1/folders/19OzV_-EwUi2xjxMYVmlnSmzvqfLfrO7o`). Expected shape
(be forgiving — infer what's missing):

```
# Daily Topic — <YYYY-MM-DD>
topic: <the ONE universal idea, e.g. "answering every call after hours">
angle: <the hook / point of view>
audience takeaway: <what an operator should feel/do>
key points:
  - ...
  - ...
facts/sources: <any REAL facts to use, each with a source. If none, leave blank.>
notes: <anything else from the interview>
```

**One topic → all niches.** The same topic is rewritten uniquely for each live niche's audience
(electricians, limo operators, golf courses, etc.) — same core idea, that niche's context,
language, and examples. Never copy one niche's article into another.

## Preconditions
1. The interview MD is available (path passed in, or the most recent new `.md` in the Drive
   folder — see the Trigger section).
2. `~/.claude/env.local` is sourced (Coolify token, GHL, webhooks).
3. Live niches + repos come from `_website-template/REGISTRY.md`. Each niche's **money keyword**
   comes from the keyword-tracking repo (`seo-keyword-tracking-by-niche-site/<Site>/keywords.md`).
4. Coolify app UUIDs live in each niche's `variables.json` (`coolify.app_uuid`) or via
   `coolify_list` — needed to redeploy after publish.

## Orchestration — fan out, then chain
1. **Parse the topic** once (Step 0) → a niche-agnostic brief.
2. **Fan out across every live niche** (run niches in parallel; cap concurrency ~4). For each
   niche, run the specialist chain **Steps 1→9 in order**. A niche that FAILS the QA gate is
   held as a draft-only for that niche and reported — it does NOT block the others.
3. **Summarize** at the end: per niche — published URL, QA verdict, email/social draft paths.

Spawn each step as its own sub-agent (`Agent`) using the specialist prompt below, so each is a
focused professional with a clean context. Pass the niche's facts (from REGISTRY + keyword repo
+ the brand block below) into every agent.

---

## Shared brand + truth rules (inject into EVERY agent)
- **Pricing (locked):** $99/mo forever for the first 270 customers + pay-to-use. One Stripe link
  `https://buy.stripe.com/fZudR96yq9Y37COaL68Ra0c`. **No free-trial language, ever.**
- **Audience:** the niche's *operators* (B2B), not consumers. Sell the outcome (more booked jobs,
  no new hires), present the platform as the quiet machine behind it.
- **Contact:** `clients@illuminationlab.io`. Booking widget `McMT8bQnMFU8gw2dk8cY`.
- **TRUTH ONLY:** every statistic must come from the interview MD's `facts/sources` (with a real
  source) or be independently verifiable and cited. **Never invent a stat, source, testimonial,
  or customer name.** If a claim has no source, make it qualitative, not numeric.
- Voice: authoritative but human. It must read like one expert wrote it to one operator.

---

## Step 0 — Topic Parser  (agent: "parser")
**You are a sharp editorial strategist.** Read the interview MD. Output a clean, niche-agnostic
brief: the one topic, the angle, 3–5 key points, the operator takeaway, and the verified facts
(with sources) that may be used. Flag any fact lacking a source as "qualitative-only." Return
structured JSON: `{topic, angle, takeaway, key_points[], facts[], caveats}`.

## Step 1 — Writer  (agent: "writer", per niche)
**You are a world-class B2B content writer + direct-response copywriter** (the Halbert/Ogilvy/
Sugarman school — see `medspa-newsletter/reference/copywriting-playbook.md` for the house voice).
Write a **descriptive, genuinely useful blog article (~800–1,300 words)** that translates the
day's topic into THIS niche's world — its jargon, its daily pain, real examples for that trade.
Structure: a hook that earns the read → the problem in the operator's own terms → the idea, with
the verified facts woven in (specifics, cited) → how a system solves it (the platform, named
lightly, outcome-first) → a clear single CTA (book a demo / see pricing). One idea, deeply. No
fluff, no invented stats, no free-trial language. Output the article body (markdown) + a proposed
`<title>` (≤60 chars) and meta description (≤160).

## Step 2 — Humanizer  (reuse the `humanizer` skill, per niche)
Run the **`humanizer`** skill on the article with the direct-response preservation directive
(same as medspa-newsletter Step 4): strip AI tells (filler, hedging, synonym cycling, fake "-ing"
analyses, em-dash overuse, rule-of-three spam, promo inflation), but PRESERVE deliberate craft
(one bold CTA, rhythm, first/second person). Run the preservation guard afterward. **Mandatory —
never present un-humanized copy.**

## Step 3 — SEO  (reuse `seo-optimizer` principles, per niche)
**You are a technical + AEO SEO lead.** Optimize the article to rank: title/meta/H1 lead with the
niche's **money keyword** (from `seo-keyword-tracking-by-niche-site/<Site>/keywords.md` — target
the long-tail money term, not consumer fat-head); logical H2/H3 with secondary + PAA-style
questions; front-loaded answers; internal links to that site's pricing/features/relevant pages
with descriptive anchors; a real **FAQ section + FAQPage JSON-LD**; image alt text. Do NOT keyword-
stuff or change the meaning/voice. Append any NEW long-tail terms you surface to that site's
`keywords.md` (per the keyword-logging process).

## Step 4 — Designer  (agent: "designer", per niche)
**You are a brand designer.** Produce, using CODE (no paid image tool):
- A **branded blog header** and a **square social card** as self-contained **HTML/SVG** (house
  teal `#00b0b8` + navy, the niche's shield/wordmark), rendered/exported to PNG.
- **Image briefs** (ready-to-paste prompts) for any photoreal/illustrative image the user may
  want to generate by hand in Claude.ai.
Keep everything on-brand and consistent across niches. No stock-photo dependency.

## Step 5 — Email + Social drafts  (agents: "email", "social", per niche)
- **Email agent** — you are the `medspa-newsletter`-grade direct-response writer, generalized to
  this niche. Build a **send-ready HTML newsletter** off the same topic (subject ×3, preheader,
  ~150–220-word body, one CTA to the booking link, P.S.). Include a **compliant footer**
  (unsubscribe + physical mailing address) so it is CAN-SPAM-safe. Output = **DRAFT** (write to
  the Drive day-folder). Flip-to-auto: when the user enables it, hand the HTML to n8n/GHL to send
  to that niche's list.
- **Social agent** — you are a social strategist. Draft 2–3 platform posts (short-form + a
  LinkedIn-style long-form) that tease the article and **drive traffic to the published blog URL**,
  plus an **audience/targeting note** (who to reach, hashtags, best time). Output = **DRAFT** (no
  accounts connected yet — build it, keep it a draft).

## Step 6 — ██ QA GATE ██  (agent: "qa", per niche — the trust mechanism)
**You are a ruthless brand + compliance auditor. Default to REJECT.** The niche does not publish
or send until you PASS it. Check, and fail on ANY violation:
- **Fabricated content:** any stat/source/testimonial/customer name not traceable to the brief's
  verified facts → FAIL. (This is the #1 check.)
- **Brand/pricing:** wrong pricing, any free-trial language, off-brand voice, consumer (not
  operator) framing → FAIL.
- **Human read:** still sounds AI (survived tells, robotic rhythm) → FAIL back to humanizer.
- **Links:** internal links broken or pointing off-site/wrong page → FAIL.
- **Niche fit:** generic or copied-from-another-niche context → FAIL.
- **SEO basics:** missing/duplicate title/meta, no H1, no FAQ schema → FAIL.
- **Email only:** missing unsubscribe or mailing address (CAN-SPAM) → FAIL.
Return `{verdict: PASS|FAIL, blocking_issues[], notes}`. On FAIL, route back to the specific step,
fix, re-run QA. Never override QA to hit a deadline.

## Step 7 — Publisher  (agent: "publisher", per niche — ONLY on QA PASS)
Add the article as a **new blog post** in the niche repo, matching that site's existing
`resources/blog/*.html` template exactly (head SEO tags, canonical, og/twitter, `SITE_CONFIG`,
Plausible `pa-` tag, chatbot loader, FAQPage JSON-LD, footer, `?v=` bump). Then: add its card to
`resources/blog.html`, add its URL to `sitemap.xml`, drop in the generated header/social images,
**commit + push + redeploy** (Coolify app UUID from `variables.json`), and **verify the URL is
live (HTTP 200)**. For the Next.js niche (RafterElite) publish via the app's blog structure, not
raw HTML, and confirm `next build` compiled. Report the live URL.

## Step 8 — Package to Drive  (agent: "packager", per niche)
Write everything into a dated per-niche folder under the shared Drive (like `needlemoved-daily`
does): the published article (HTML + link), the email HTML draft, the social post drafts +
targeting note, the image briefs + generated graphics. This is the human-review record even
though the blog auto-published.

## Step 9 — Summary
Three lines per niche: published URL + QA verdict + email/social draft locations. Flag any niche
held as draft-only (QA fail) with the reason.

---

## The Trigger — watch the Drive folder (infra, not the skill itself)
A skill runs when invoked; it does not watch a folder. Pair this skill with a **routine/cron on
the DO droplet** (or an n8n Google-Drive trigger) that:
1. Polls the "Chief Automation Experts" Drive folder every ~15 min for a NEW `.md`.
2. On a new file, invokes this skill headless: `claude -p "run the daily marketing engine on <path>"`.
3. Moves/marks the MD as processed so it doesn't re-run.
Recommended: **Drive folder + polling routine** (fewest moving parts, rides the Drive workflow you
already use). Upgrade to an n8n webhook later if you want it instant.

## Flip-to-auto switches (v1 defaults)
- **Blog:** AUTO-publish (on, gated by QA).
- **Email:** DRAFT (default). Flip to auto only once (a) the agents are proven over real runs and
  (b) per-niche GHL lists exist — then wire the Email step's handoff to n8n/GHL send.
- **Social:** DRAFT (no accounts yet). Flip on once social accounts are connected.

## Guardrails
- Truth only — no invented stats/sources/testimonials. QA enforces this.
- Locked pricing + no free-trial language, every asset.
- QA gate is mandatory and cannot be overridden.
- Each niche is independent — one niche's failure never blocks the rest.
- Log new keywords to the keyword-tracking repo; keep everything on-brand.
