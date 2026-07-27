---
name: seo-optimizer
description: >-
  Optimize ANYTHING for the best possible SEO — a single page, a block of copy, a full URL, or just a topic/keyword. Runs LIVE keyword + SERP research every time it's invoked (never from memory), then rewrites and annotates the input across on-page, technical, content-quality, and AI-answer-engine SEO, and returns a scorecard with prioritized fixes. Use when the user says "optimize this for SEO", "SEO this page/copy", "improve rankings", "make this rank", "SEO audit", or hands over a URL/page/topic to strengthen for search.
version: 1.0.0
user-invocable: true
argument-hint: "[url | file path | topic | paste of copy]  (optional: target keyword)"
---

# /seo-optimizer

Point this at anything and it makes it rank. It **always does fresh research at run time** — search volumes, competitors, and SERP features change constantly, so this skill never optimizes from memory or stale assumptions.

## Data sources (research is mandatory, every run)

1. **OpenSEO** (preferred, when configured) — live keyword volume, difficulty, SERP, and competitor data. Look for an `OPENSEO_API_KEY` (or an `openseo` MCP connection). If present, use it for the hard numbers. *If it's NOT configured, say so once, then continue with web research — do not skip research.*
2. **Web research** (always available fallback) — `WebSearch` + `WebFetch` for: the live SERP for the target term, "People Also Ask" questions, autocomplete/related searches, and the top 3–5 ranking competitors' angle, headings, and depth.

> **If neither is available, STOP and tell the user** — this skill's whole value is current data. Do not fabricate volumes or difficulty.

## Step 1 — Figure out what you were handed + the goal

Classify the input:
- **A file path / page** → read it, audit + rewrite it in place (or output the changes).
- **A URL** → `WebFetch` it, audit what's live.
- **Raw copy** → optimize the text.
- **A topic or keyword only** → produce an SEO content brief (what to write to rank).

Confirm (or infer) the **target audience, the primary keyword/topic, and the goal** (rank a page / write new content / fix a specific problem). If the primary keyword is unclear, propose one from research and say so.

## Step 2 — Research NOW (do not skip)

Run these every time:
- **Primary + secondary keywords** — pick a realistic primary (intent-matched, winnable) and 3–8 secondary/long-tail terms. Use OpenSEO volume/difficulty if available; otherwise infer demand from autocomplete, related searches, and PAA.
- **Search intent** — informational / commercial / transactional / navigational. The page must match it or it won't rank.
- **SERP + competitors** — look at who ranks for the primary term: their angle, heading structure, depth/word count, and what they're missing (your opening).
- **People Also Ask / related questions** — capture them; they become H2s, FAQ entries, and schema.

Report the keyword set + intent + the competitor gap in 3–5 lines before optimizing.

## Step 3 — Optimize across ALL layers

Rewrite/annotate the input against this rubric. Only touch what applies to the input type.

**On-page**
- **Title tag:** ≤60 chars, primary keyword near the front, compelling.
- **Meta description:** ≤160 chars, includes the keyword + a reason to click (not keyword-stuffed).
- **URL slug:** short, hyphenated, keyword-bearing.
- **H1:** exactly one, keyword-led, matches the title's promise.
- **Headings (H2/H3):** logical outline; work in secondary keywords + PAA questions naturally.
- **Body:** match intent, cover the topic more completely than the competitors, front-load the answer, keep it readable (short paragraphs, lists). No keyword stuffing.
- **Internal links:** link to/from related pages with descriptive anchor text.
- **Images:** descriptive `alt` text with keywords where natural; compress; lazy-load below the fold.

**Technical**
- Canonical tag, correct and self-referencing.
- **Structured data (JSON-LD):** the right schema type (Organization, WebSite, Product/SoftwareApplication, FAQPage, Article, LocalBusiness, BreadcrumbList) — valid, matching the visible content.
- OpenGraph + Twitter tags matching the title/description.
- `robots.txt`, `sitemap.xml`, `llms.txt` present and correct.
- Mobile-friendly + fast (defer third-party widgets, no layout shift, responsive).

**Content quality / E-E-A-T**
- Demonstrate real experience/expertise; be specific, not generic.
- Freshness (dates, current facts). Original angle, not a rehash.
- Answer the query fully — aim to be the most complete result, not the longest.

**AI answer-engine optimization (AEO/GEO)** — increasingly where traffic goes
- Keep `llms.txt` accurate.
- Use clear, extractable answers (a direct answer sentence under each question heading).
- FAQ schema for question-shaped queries.
- Allow reputable AI crawlers in `robots.txt` (GPTBot, ClaudeBot, PerplexityBot, OAI-SearchBot, Google-Extended).

## Step 4 — Output

Return, in this order:
1. **SEO scorecard** — the rubric above with ✓ / ⚠ / ✗ per item and a 1-line reason for each gap.
2. **The optimized version** — the rewritten title/meta/headings/body (or the full brief, for topic-only input). Ready to paste or apply.
3. **Prioritized fix list** — highest-impact first (e.g. "1. Rewrite H1 to lead with primary keyword; 2. Add FAQPage schema; 3. Cut title to 58 chars"). Note which fixes need a human (e.g. building backlinks, page-speed infra).
4. **The research basis** — the keyword set + volumes/difficulty (or "estimated from web research; connect OpenSEO for exact numbers") so the user can trust the choices.

## Invariants
- **Always research at run time.** Never optimize from memory or generic best-practice alone.
- **Never fabricate metrics.** If you don't have real volume/difficulty (no OpenSEO), say the numbers are estimates and show your basis.
- **Match search intent first.** Perfect on-page SEO on an intent-mismatched page still won't rank.
- **Don't keyword-stuff.** Modern SEO rewards natural, complete, useful content.
- **Preserve meaning + brand voice** when rewriting — optimize, don't blandify.

## Configuring OpenSEO (one-time, for live data)
Add your key so runs use exact metrics instead of estimates:
- As an env var: put `OPENSEO_API_KEY="..."` in `~/.claude/env.local`, **or**
- As an MCP connection named `openseo` (endpoint `https://app.openseo.so/mcp`), authorized once.
Until then the skill runs on web research and clearly labels metrics as estimates.

## Works well alongside
- The niche-site flow (`/niche-research` → `/niche-build`): run this on a page's copy before build, or on a live page after launch.
- The vendored `agent-skills-library/google-ads-marketing/keyword-research` and `landing-page-audit` skills for deeper ads/landing-page angles.
