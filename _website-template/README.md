# `_website-template` — Illumination Lab niche-site factory

Canonical source-of-truth for every Illumination Lab niche marketing site. Every new niche (`NeedleMoved`, `RafterElite`, and the hundred that follow) is built by copying this template into `/repos/niche-sites/<ProductName>/`, running the three-phase skill flow below, and launching to Coolify.

Each niche site is powered by Go High Level white-labeled for a specific industry. Pricing, Stripe links, webhook URLs, GHL calendar, and chatbot widget are shared across every niche and locked in at the template level — niche sites differ only in brand, copy, and domain.

---

## The three-phase flow

| Phase | Skill | Input | Output |
| --- | --- | --- | --- |
| **1. Research** | `/niche-research` | Niche name, code, product name, domain, accent color | `content.md` (7-page SEO + copy plan) in the niche repo, row reserved in `REGISTRY.md` |
| **2. Build** | `/niche-build` | `variables.json` + `content.md` + master logo + master square image | Complete static site in the niche repo, DoD sweep clean |
| **3. Launch** | `/niche-launch` | Clean niche repo + purchased domain | GitHub repo pushed, Coolify project + app + domains + deploy triggered, DNS records printed, REGISTRY row promoted to Live |

Each skill has explicit human checkpoints (⏸). Never skip them — they exist because the cost of a mis-configured drip tag or unchecked free-trial language at 50 sites is much higher than the cost of pausing once per site.

---

## Repo layout

```
_website-template/
├── README.md                   this file
├── REGISTRY.md                 multi-niche tag registry (single source of truth for NICHE_CODE uniqueness)
├── prompts/
│   ├── NICHE-BUILD-PLAYBOOK.md v4.0 — locked pricing, CSS architecture, Definition of Done
│   └── deep-research-prompt.md parameterized prompt for Phase 1 content research
├── scripts/
│   ├── coolify.sh              Coolify API helper (create project/app, add domains, deploy)
│   └── resize-brand.sh         Generates the 8-file brand asset set via macOS sips
├── css/styles.css              Template CSS, [ACCENT_COLOR] tokenized
├── js/main.js                  Template JS — unified form handler, SITE_CONFIG source_site injection
├── public/brand/               Empty in template; populated per-niche by resize-brand.sh
├── index.html   features.html  use-cases.html   resources.html
├── pricing.html about.html     contact.html     book-demo.html
├── privacy.html terms.html
└── resources/                  Blog index + individual post stubs + revenue calculator
```

---

## One-time setup (already done)

- `~/.claude/env.local` — Coolify token, webhooks, chatbot widget ID, GHL calendar URL, shared defaults. Permissions `600`.
- `~/.claude/skills/{niche-research,niche-build,niche-launch}/SKILL.md` — the three phase skills.
- `gh` CLI authenticated.

Verify setup:

```bash
# Should print the Coolify base URL and list servers + projects
bash /Users/laurenwilliams/Desktop/repos/niche-sites/_website-template/scripts/coolify.sh check
```

First-niche legal defaults: on the first build, `/niche-build` will ask for `IL_FORMATION_STATE`, `IL_GOVERNING_LAW`, and `IL_MAILING_ADDRESS` and write them back to `env.local`. Subsequent niches inherit them automatically.

---

## Adding a new niche — the full path

```
(a) Pick a NICHE_CODE. Confirm it's not in REGISTRY.md (Live, Planned, or Retired).
(b) Buy the domain at Namecheap.
(c) Create the master brand assets yourself:
    - master-logo.svg (or .png) — full-color logo
    - master-square.png — 1024×1024+, what favicon + apple-touch derive from
(d) /niche-research
    → produces content.md in /repos/niche-sites/<ProductName>/
(e) Drop your two master brand images into /repos/niche-sites/<ProductName>/ as master-logo.* and master-square.*
(f) /niche-build
    → scaffolds the site, resizes brand, applies content.md, runs DoD sweep
(g) /niche-launch
    → GitHub + Coolify + prints DNS records for Namecheap
(h) At Namecheap: set the two A records (@ and www) to the Coolify server IP
(i) In n8n: add a new branch to the switch node keyed on form_location = "<NICHE_CODE>"
(j) In GHL: create the 6 drip tags + workflows (see playbook Appendix A)
(k) /niche-launch prompts you to verify the live site in incognito; on confirmation it promotes
    the REGISTRY row from Planned to Live.
```

Steps (a)–(c) and (h)–(j) are the manual human-in-loop points. Everything else is automated.

---

## What's locked at the template level (do not override per-niche)

Any change to these should be made here in the template, not in an individual niche repo.

- **Pricing:** Three tiers + Stripe links. Locked in playbook Section 3 / Appendix C.
- **Setup fee:** $200, bundled into Stripe checkout.
- **Free trial:** OFF everywhere.
- **Webhooks:** `LEAD_WEBHOOK` + `NEWSLETTER_WEBHOOK`. Shared across all niches; the n8n switch routes by `form_location`.
- **GHL calendar:** Shared widget `McMT8bQnMFU8gw2dk8cY` on `chiefautomationexperts.com`.
- **Chatbot widget:** Shared `data-widget-id="685d4d4f63b8b7fec750e753"` — injected by `/niche-build` into every page except privacy + terms.
- **Fetch config:** `text/plain;charset=UTF-8` + `mode: 'no-cors'`. Deviation = silent CORS failure.
- **CSS architecture rules:** `.split-visual`, `.checklist`, `.stats-row`, `.page-hero`, `.announcement-bar`, `.site-header`. See playbook Section 6.
- **Copyright/legal shared fields:** `IL_LEGAL_ENTITY`, `IL_INTERNAL_EMAIL` (both in env.local).

---

## What varies per-niche

- `NICHE_CODE`, `PRODUCT_NAME`, `NICHE`, `DOMAIN`
- `ACCENT_COLOR` (+ secondary/background/text if different)
- `TAGLINE`, logo
- `content.md` — the 7-page copy generated in Phase 1
- `CONTACT_EMAIL` (per-niche like `hello@<domain>`; `INTERNAL_EMAIL` stays shared)
- Testimonial stand-ins — regenerated per-niche via the playbook's stand-in format
- Legal page specifics (HIPAA BAA clause only for healthcare-adjacent niches)

---

## Diagnosing issues

**First stop: playbook Appendix D (`prompts/NICHE-BUILD-PLAYBOOK.md`).** Every bug we've shipped to production and then fixed is logged there with root cause + fix. Before asking Claude to debug, check that table — it's faster than re-discovering a known issue.

---

## Future work

- RafterElite currently uses Next.js. Port its visual design into this template so new niches inherit the roofing-era polish (gold/slate theme, Inter + Space Grotesk fonts, dark radial-fade hero). Then migrate both NeedleMoved and RafterElite to use the template structure.
- n8n API automation — auto-add a switch branch per new niche on `/niche-launch`.
- GHL API automation — auto-create the 6 drip tags + workflows per new niche.
- Notion API — pull live pricing from the canonical pricing Notion page so template updates happen in one place.

None of these block the three-phase flow as it stands today.
