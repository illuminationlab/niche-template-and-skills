# Niche Site Build-Out Checklist — Golf Courses

Reusable process for launching a new niche site (golf now; template for future ones).
Check items off as you go. The three skills that automate the heavy lifting are
`/niche-research` → `/niche-build` → `/niche-launch`.

Locked decisions for this build:
- **Niche:** golf courses / course operators
- **Tagline (working):** "One system that fills your calendar without making additional hires" (finalize wording)
- **Pricing:** $99/mo base access + pay-for-what-you-use beyond that (house standard — locked)
- **Brand:** house teal `#00b0b8` + navy `#002445` (default unless we deliberately override)
- **Positioning rule:** sell the OUTCOME (full calendar / tee sheet, no new hires) and present the
  toolkit as MODULAR ("use only what you need"), so it fits every client whether they arrive with a
  CRM, need texting, need scheduling, etc. Do NOT commit the homepage to a fixed feature set.

---

## Phase 0 — Pre-work (before /niche-research)
- [ ] Lock the niche + audience wording (e.g. "golf courses" / "course operators & GMs")
- [ ] Finalize the tagline
- [ ] Pick a brand name and **buy the domain on Namecheap** (this is a hard prerequisite — research runs against a locked domain)
- [ ] Pick a `NICHE_CODE` (2–3 lowercase letters, unique in REGISTRY.md — e.g. `gc`)
- [ ] Pick a `DRIP_TAG_PREFIX` (single word, unique — e.g. `golf`)
- [ ] Confirm accent color (default house teal/navy)
- [ ] Confirm the info@ email alias exists at the domain

## Phase 1 — Research (`/niche-research`)
- [ ] Run `/niche-research` (reserves the REGISTRY row, scaffolds the repo dir, fills the deep-research prompt)
- [ ] Human checkpoint: confirm the locked variables before the research agent runs
- [ ] Research agent produces `content.md` (8-page plan: Overview, Features, Use Cases, Resources, Pricing, About, Contact, Starting a Business)
- [ ] Review `content.md` — word count, headings, no fabricated stats, no free-trial language, outcome-led/modular positioning intact
- [ ] (Recommended) Live SEO pass with OpenSEO — rank winnable golf keywords, sharpen titles/meta before build

## Phase 2 — Build (`/niche-build`)
- [ ] Place master logo + square master image in the niche repo
- [ ] Run `/niche-build` (scaffolds from `_website-template`, resizes brand assets, injects every variable, applies `content.md`, builds the new-business page, bakes technical SEO)
- [ ] Decide booking flow: **Book a Demo → GHL booking page** (redirect or on-domain embed). No lead-capture forms unless you specifically want them (keeps n8n out of it)
- [ ] Definition-of-Done automated sweep passes (no leftover [BRACKET] tokens, shield favicon, one H1/page, canonical+OG+Twitter, JSON-LD, sitemap/robots/llms, mobile nav + lazy chat widget)
- [ ] Manual DoD review in a browser (layout, logo, pricing block, links)

## Phase 3 — Launch (`/niche-launch`)
- [ ] `git init` + create the GitHub repo + push first commit
- [ ] Coolify: create project + static app + attach domains (apex + www) + trigger deploy
- [ ] Namecheap DNS: point the domain at the Coolify server (records printed by the skill)
- [ ] Verify HTTPS cert issued + site live (HTTP 200)
- [ ] GHL drip tags + n8n switch branches — **only if the site has lead forms** (with GHL-booking-only, this is typically N/A)
- [ ] Promote the REGISTRY row from Planned → Live (date, domain, repo)

## Phase 4 — Post-launch verification
- [ ] All pages return 200; nav correct on every page
- [ ] Every "Book a Demo" resolves to the GHL booking page
- [ ] Homepage title/meta match the SEO plan; sitemap.xml / robots.txt / llms.txt resolve
- [ ] Add the domain to the daily live-site health check
- [ ] (Optional) dedicated high-ROI SEO landing page + 1–2 blog posts once the core site is live

---

### Golf-specific research notes (feed the deep-research prompt)
- Audience segments: public/daily-fee courses, semi-private, private clubs, municipals, resort courses, driving ranges/entertainment venues.
- What fills their "calendar": tee times, leagues/outings/events, lessons & clinics, memberships, F&B/banquets.
- Incumbents to know: GolfNow / Lightspeed Golf / Club Prophet / foreUP / Sagacity / Toptracer — note where they're expensive, locked-in, or missing AI/text follow-up.
- The wedge: one affordable system that fills the calendar and follows up — used only for the pieces each course is missing (CRM, texting, email, scheduling, reviews), no new hire required.
