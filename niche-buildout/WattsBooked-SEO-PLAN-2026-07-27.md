# WattsBooked SEO Plan — Live OpenSEO Data (2026-07-27)

**Status: PROPOSED — nothing implemented. Awaiting approve/reject.**
Data source: OpenSEO (live DataForSEO), US / English. Research pass = 2 seeds (171 keywords),
3 SERP validations. Credits used ~130 of 500 (≈370 remaining).

---

## TL;DR — the finding

WattsBooked is currently aimed at the **crowded** keyword cluster ("electrician scheduling
software" — KD 9 but the live SERP is wall-to-wall funded SaaS: Housecall Pro, Jobber,
ServiceTitan, FieldPulse, Workiz, BuildOps). It is **not** aimed at the **open, higher-value**
cluster it could own today: the **answering-service** terms — KD 0, high buyer intent, and a
SERP full of beatable old-school human answering services with only a few AI upstarts.

**Single highest-ROI action:** build a dedicated `answering-service.html` page. It targets
KD-0 terms worth up to **$264 CPC** and there is currently **no page** competing for them.

---

## Winnable keywords, ranked by ROI (real volume / KD / CPC)

### Tier 1 — own these now (KD ≤ 20, buyer intent, beatable SERP)
| Keyword | Vol | KD | CPC | Target home |
|---|---|---|---|---|
| ai answering service | 2,400 | 18 | $51 | Blog pillar |
| best answering service for small business | 720 | 11 | $208 | Blog / listicle |
| virtual receptionist for small business | 320 | 19 | $152 | Answering page |
| answering service costs | 260 | 4 | $62 | Blog (pricing) |
| ai answering service for small business | 260 | 17 | $83 | Answering page |
| software for electricians | 260 | 10 | $161 | Features |
| answering service for contractors | 170 | **0** | $109 | Answering page |
| best ai answering service | 210 | 16 | $60 | Answering page |
| scheduling software for electricians | 90 | 9 | **$307** | Homepage |
| crm for electricians | 90 | **0** | $161 | Features / CRM |
| electrician answering service | 70 | **0** | **$264** | **New page H1** |
| best software for electrical contractors | 70 | 8 | $179 | Features |
| electrical billing software | 70 | 0 | $183 | Features |
| best crm for electrical contractors | 50 | 0 | $37 | Blog / comparison |
| automated answering service for small business | 70 | 2 | $81 | Answering page |

### Tier 2 — content plays (informational, high volume, winnable)
| Keyword | Vol | KD | Angle |
|---|---|---|---|
| electrical estimating software | 1,300 | 5 | Adjacent-demand blog (if quoting/estimating is a feature) |
| housecall pro vs jobber | 880 | 0 | Competitor-shopper comparison → pivot to WattsBooked |
| auto attendant phone system | 480 | 10 | Supporting blog for answering cluster |
| answering service cost per month | 70 | 5 | Pricing FAQ / blog |

### Skip (competitor-brand navigational — no value)
`jobber login`, `servicetitan`, `housecall pro sign in`, all `quickbooks *`.

---

## SERP competitor notes (from live pulls)

- **electrician scheduling software (KD 9):** AI Overview + FieldVibe, Housecall Pro, Jobber,
  FieldPulse, ServiceTitan, Workiz, BuildOps + listicles (myquoteiq, koalendar, workyard) +
  Reddit. Hard room. Winnable long-term with a strong product page; not the first target.
- **electrician answering service (KD 0):** ResponsiveAnswering, Houston Answering, Signpost,
  MAP, AnswerForce, AnswerUnited, AnswerPro (traditional human services) + AI upstarts
  heyrosie (#4), oncrew (#10), agentzap (#16), smith.ai (#18). **Gap: no electrician-native
  platform doing answering + booking + CRM in one.** This is WattsBooked's opening.
- **crm for electricians (KD 0):** AI Overview + Reddit + listicles (myquoteiq, bigcontacts,
  buildops, pipedrive) + one EMD (crmforelectricians.com). Winnable with a focused CRM
  section/page + a comparison blog post.

---

## Proposed changes (exact)

### 1. NEW PAGE — `answering-service.html`  ★ highest ROI
- **Title:** `Electrician Answering Service — AI, 24/7 | WattsBooked` (54 chars)
- **Meta:** `WattsBooked is the AI answering service built for electricians — answers every
  call 24/7, flags emergencies, books jobs, and logs the lead. From $99/mo.` (≤160)
- **H1:** `The 24/7 AI answering service built for electricians`
- **Primary target:** electrician answering service (KD 0, $264)
- **Secondary:** answering service for contractors (KD 0), ai answering service for small
  business (KD 17), virtual receptionist for small business (KD 19), best ai answering service.
- **H2 outline (works in secondary terms + PAA):**
  1. Never miss another service call
  2. Built for electricians, not a generic call center
  3. How the AI answering service works (answer → qualify → flag emergency → book → log)
  4. AI answering service vs. a traditional answering service (comparison table)
  5. Answering service pricing for electricians (→ internal link to /pricing)
  6. FAQ (What is an electrician answering service? How much does it cost? Is it a real
     person or AI? Does it book jobs? After-hours?) — **add FAQPage JSON-LD**
- **Schema:** Service + FAQPage JSON-LD.
- **Internal links:** from homepage nav + features + use-cases; link out to /pricing, /book-demo.
- **Sitemap/llms.txt:** add the new URL.

### 2. Homepage — `index.html`  (POSITIONING DECISION — see options)
- Current title: `Electrician CRM & AI Receptionist | WattsBooked`
- **Option A (recommended — lead with answering service):**
  `Electrician Answering Service & CRM Software | WattsBooked` (58)
  - H1 keeps the current hook line; add "answering service" into the subhead/first paragraph.
- **Option B (keep "AI Receptionist" primary):**
  `Electrician AI Receptionist, CRM & Booking | WattsBooked` (55)
  - Still add an "answering service" section + internal link lower on the page.
- Meta (either option): work in "answering service" + "scheduling software for electricians"
  once, naturally.

### 3. Features — `features.html`
- Current title: `Electrical Contractor Software & AI Tools | WattsBooked`
- **New title:** `Electrician Software: CRM, Scheduling & AI | WattsBooked` (56)
  - Captures "software for electricians" (260/KD10), "electrician software", "best software
    for electrical contractors" (KD 8).
- Add a **CRM sub-section** with an H2 `CRM for electricians` to target crm for electricians
  (KD 0) + best crm for electrical contractors (KD 0).
- Add "electrical billing software" (KD 0) to the invoicing feature copy.

### 4. Use-cases — `use-cases.html` (minor)
- Current title: `WattsBooked Use Cases for Electricians` (not keyword-led)
- **New title:** `Electrician Use Cases: Booking, CRM & AI | WattsBooked` (54)

### 5. Blog posts (2)
- **A. "AI answering service for electricians: how it works + what it costs"**
  - Targets: ai answering service (2,400/KD18), answering service costs (260/KD4), answering
    service cost per month (KD 5), ai answering service for small business.
  - Direct-answer intro sentence + cost table + FAQPage schema. Internal link → /answering-service.
- **B. "Housecall Pro vs Jobber (2026): honest comparison for electricians"**
  - Targets: housecall pro vs jobber (880/KD0). Neutral comparison, then a "third option built
    only for electricians" section → WattsBooked. Captures competitor-shopper traffic.

---

## Prioritized implementation order (highest impact first)

1. **Build `answering-service.html`** (new demand capture, KD-0, $264 CPC). — biggest win
2. **Retarget homepage title/meta** (pending positioning A vs B decision).
3. **Retarget features title + add CRM sub-section + billing copy.**
4. **Blog post A** (AI answering service — 2,400 vol pillar).
5. **Blog post B** (Housecall Pro vs Jobber — competitor capture).
6. Minor: use-cases title; add new URLs to sitemap.xml + llms.txt.
7. Human/infra (not code): build a few relevant backlinks; keep page speed clean.

---

## Open decision needed before implementing
- **Homepage positioning: Option A (answering-service-led) vs Option B (keep AI Receptionist
  primary).** Everything else is additive and non-controversial.

## What was NOT changed
Nothing. No files edited, no commits, no deploy. This doc is the only new file and is a
planning artifact (safe to delete or keep out of commits).

## Research basis
2 OpenSEO seeds — "electrician scheduling software" (105 related) + "electrician answering
service" (66 related) = 171 keywords with real volume/KD/intent/CPC. 3 live SERP pulls
(electrician scheduling software, electrician answering service, crm for electricians).
~130 credits spent, ~370 remaining if we want deeper research (e.g. more seeds for the blog
cluster or a site audit).
