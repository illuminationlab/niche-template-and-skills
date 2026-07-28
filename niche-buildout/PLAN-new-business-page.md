# PLAN — Add a "Starting a New [NICHE] Business" page to future niche sites

**Status: IMPLEMENTED in the template + skills on 2026-07-28. Applies to FUTURE builds only (existing 5 sites untouched).**
Decisions locked: dedicated page · top-level nav link · "[niche] startup checklist" lead magnet (`form_location = startup-checklist`).
Author note: integrates into the existing research → build → launch flow. No live-site changes — future `/niche-build` runs pick it up automatically.

---

## The idea

A new page/section aimed at people who are **just starting** a business in the niche
(a new med spa, a new electrical contracting business, a new pest-control shop, etc.).
It answers: *"What's the process for starting this business — and how does [PRODUCT] help
if you don't have all the answers yet?"*

**Why this is worth adding to every future site:**
1. **SEO (top-of-funnel, low competition):** "how to start a [niche] business" style queries
   have real, steady search volume and far weaker commercial competition than the
   "[niche] software" terms. It brings in traffic our current pages don't target at all.
2. **Lead capture at the earliest possible moment:** a brand-new owner who finds us on day
   one has no existing software loyalty. If we're the ones who hand them the roadmap, we're
   the default when they're ready to buy. This is the cheapest customer we can win.
3. **Positioning:** it reframes the product from "switch to us" → "start right with us." A new
   owner's #1 fear is looking small/unprofessional and missing calls while they're still
   figuring it out. That is *exactly* what the AI receptionist + booking + follow-up solves.
4. **It plugs into an intent we already track:** the contact-form dropdown + drip-tag scheme
   already includes a `new-biz` lead type (`<prefix>-contact` with a "new business" option).
   Today nothing on the site drives that intent — this page becomes its front door.

---

## Recommended shape: a dedicated page (not just a homepage section)

- **File (template):** `new-business.html` (niche-agnostic filename; niche baked in at build)
- **URL:** `/new-business.html`
- **Plus a short entry-point block** on the homepage and in the Resources hub that links to it.
- Dedicated page > section because it can rank on its own for "start a [niche] business"
  queries and hold the full roadmap without bloating the homepage.

### SEO targeting (finalized per-niche during /niche-research)
- Primary: `how to start a [niche] business` / `starting a [niche] business`
- Secondary: `[niche] business startup checklist`, `[niche] business plan`,
  `how much does it cost to start a [niche] business`, `[niche] license requirements`
- Intent: informational → soft commercial. Match it: teach first, sell second.
- Schema: `Article` + `FAQPage` (JSON-LD). Optionally `HowTo` for the roadmap steps.

### Page structure (niche-agnostic skeleton; research fills the specifics)
- **H1:** `Starting a [niche] business? Here's the whole roadmap.`
- **Intro (empathy):** You don't need to have it all figured out. Most owners don't on day one.
  Here's the path — and the system that makes you look established from your first call.
- **H2 — The roadmap (research supplies the niche-specific detail for each):**
  1. Licensing, certification & insurance for [niche] (what's legally required)
  2. Registering the business (entity, EIN, local permits)
  3. Tools, equipment & startup costs (realistic ranges)
  4. Setting your prices & quoting your first jobs
  5. Getting your first customers (Google Business Profile, reviews, local marketing)
  6. The systems that keep you from drowning (calls, booking, follow-up, reviews)
- **H2 — "You don't have the answers yet. That's what [PRODUCT] is for."**
  Map each early-stage fear → the feature that removes it:
  | New-owner fear | How [PRODUCT] handles it from day one |
  |---|---|
  | "I'll miss calls while I'm working / at my other job" | Voice AI answers 24/7, books the job, looks like a real front desk |
  | "I have no reviews / no reputation" | Automated review requests build a 5-star profile fast |
  | "I don't have time to chase leads" | Missed-call text-back + automated follow-up do it for you |
  | "I can't afford a receptionist, dispatcher, and marketer" | One system replaces all three at startup pricing |
  | "I don't know how to build a website / get found" | Funnels, booking pages, and GBP tie-in included |
- **H2 — FAQ (feeds FAQPage schema):** licensing, startup cost, "can I run this solo?",
  "when should I get software?", "do I need a website first?"
- **CTA:** `Book a Demo` and a soft `Get the [niche] startup checklist` lead magnet
  (ties to the Resources lead-magnet idea already in the research prompt).
- **Form wiring:** page CTA/contact routes with `form_location = new-biz`
  → drip tag `<DRIP_TAG_PREFIX>-newbiz` (confirm exact token vs. existing `new-biz`).

---

## Integration checklist (what to change, and where)

Order matters — change the source-of-truth first so every future build inherits it.

1. **Deep-research prompt** (`_website-template/prompts/deep-research-prompt.md`)
   - Add **PAGE 8 — STARTING A NEW [NICHE] BUSINESS** to the "7-PAGE CONTENT & SEO PLAN"
     (rename to 8-page). Spec it like the others: primary + 3–5 secondary keywords, meta
     title/desc, H1/H2s, the roadmap steps, the fear→feature table, FAQ, CTA.
   - Add a research instruction: *"Research the real startup process for a [niche] business —
     licensing/certification bodies, typical startup costs, first-customer channels, and the
     top 'how to start a [niche] business' search queries."*
   - Update the OUTPUT FORMAT block to include `## Page 8: Starting a New [Niche] Business`.
   - Update HARD CONSTRAINTS reminder (no fabricated costs/stats — cite ranges as ranges).

2. **Template** (`_website-template/`)
   - Add `new-business.html` (clone an existing content page's shell for nav/footer/head parity).
   - Add nav link (header + footer) — likely under Resources or as a top-level "Start a Business".
   - Add the URL to `sitemap.xml` and `llms.txt`. (robots.txt already allows.)
   - Add the homepage entry-point block + a Resources-hub link.
   - Bake `Article` + `FAQPage` JSON-LD stubs with `[BRACKET]` variables.

3. **niche-build skill** (`skills/niche-build/SKILL.md`)
   - Add a step to apply the Page 8 content from `content.md` to `new-business.html`.
   - Add nav-injection + sitemap/llms.txt entry for the new page.
   - Extend the Definition-of-Done sweep: new-business.html exists, is linked in nav, has the
     niche baked into H1/title, and has valid FAQPage schema.

4. **niche-research skill** (`skills/niche-research/SKILL.md`)
   - Update the "7-page" references to "8-page" so the checkpoint word-count/heading scan
     expects Page 8.

5. **REGISTRY / drip tags** — confirm the `new-biz` (or `newbiz`) `form_location` token is the
   one to use so the GHL drip tag `<prefix>-newbiz` is consistent across niches.

---

## Explicitly out of scope (for now)
- **No retrofit to the 5 live sites** (NeedleMoved, Rafter Elite, EngineGuild, Call and Crawl,
  WattsBooked). Template + skills only. We can backfill live sites in a later pass by running
  the Page-8 research per niche and dropping the page in.

## Decisions (locked 2026-07-28)
- **Dedicated page** — ✅ built as `new-business.html`.
- **Nav placement** — ✅ top-level "Start a Business" link (desktop + mobile) on every page.
- **Lead magnet** — ✅ "[niche] startup checklist" download, `form_location = startup-checklist`.

## Remaining launch-coordination item
- The new `startup-checklist` form type needs its own **n8n switch branch**
  (`<prefix>-startup-checklist`) added at `/niche-launch` time, same as the other lead forms.
  Already reflected in the niche-build skill's form-location table + prefixing sed — flag it
  for `/niche-launch` step 6 so brand-new-business leads route correctly.
