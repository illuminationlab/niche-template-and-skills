# Multi-Niche Registry

Canonical source of truth for every niche site under Illumination Lab. Every row must be reserved before starting a build.

Each niche has **two identifiers** that must be unique across every row ever created (live, planned, or retired):

- **`NICHE_CODE`** — 2–3 lowercase letters. Used as `window.SITE_CONFIG.source_site` on every page, carried on every form POST. Example: `eg`.
- **`DRIP_TAG_PREFIX`** — the niche-descriptor keyword used as the GHL drip tag prefix. Tag format is `<DRIP_TAG_PREFIX>-<form_location>` (e.g. `engine-calculator`, `engine-newsletter`, `medspa-contact`). Example: `engine`.

Both identifiers must be unique — never reuse a retired code OR a retired drip prefix, because old GHL tags with that prefix may still exist.

## Live niches

| NICHE_CODE | DRIP_TAG_PREFIX | PRODUCT_NAME | NICHE | Domain | Accent color | Status | Launched | Repo |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| nm | medspa | NeedleMoved | Med Spa | needlemoved.com | `#E8B4A0` | Live | 2025-xx-xx | `repos/niche-sites/NeedleMoved` |
| rf | roofer | Rafter Elite | Roofing | rafterelite.com | `#c8960a` | Live (Next.js — to be ported) | 2025-xx-xx | `repos/niche-sites/RafterElite` |
| eg | engine | EngineGuild | small engine repair | engineguild.com | `#C8102E` | Live | 2026-04-23 | `repos/niche-sites/EngineGuild` |
| cc | pest | Call and Crawl | pest control | callandcrawl.com | `#6b3a1f` (+ `#2d6a2d`) | Live | 2026-04-26 | `repos/niche-sites/CallAndCrawl` |

## Planned / reserved

| NICHE_CODE | DRIP_TAG_PREFIX | PRODUCT_NAME | NICHE | Domain | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| (none yet) | | | | | |

## Retired (do not reuse these codes or drip prefixes)

| NICHE_CODE | DRIP_TAG_PREFIX | PRODUCT_NAME | Reason | Date retired |
| --- | --- | --- | --- | --- |
| (none yet) | | | | |

---

## How to reserve a new row

1. **Pick a `NICHE_CODE`** — 2–3 lowercase letters, not in any row above (live, planned, or retired). Easy to remember, not confusable with another. All lowercase, no digits, no hyphens.
2. **Pick a `DRIP_TAG_PREFIX`** — a short descriptive keyword for the niche audience (e.g., `engine`, `medspa`, `roofer`, `dentist`, `florist`). Also not in any row above. All lowercase, no spaces, use single word or compound like `medspa`.
3. Add a row to **Planned / reserved** BEFORE `/niche-research` starts — never mid-build. Both identifiers must be in this file to prevent collisions on any concurrent session.
4. After `/niche-launch` completes successfully, move the row to **Live niches** with the launch date, domain, and repo path filled in.
5. If a niche is ever killed: move its row to **Retired** with the reason. Do not delete it — old GHL tags may still exist with that prefix.

---

## What each identifier controls

### `NICHE_CODE` (e.g. `eg`)
- `window.SITE_CONFIG.source_site` on every page of the site (carried on every form POST to n8n)
- Coolify project slug (e.g. `eg-site`, `rf-site`, `nm-site`)

### `DRIP_TAG_PREFIX` (e.g. `engine`)
- Every GHL drip tag uses this prefix combined with `form_location`:
  - `engine-contact` (contact form submit, demo / switching / new-biz / pricing / other)
  - `engine-calculator` (revenue calculator lead form)
  - `engine-playbook` (playbook download)
  - `engine-newsletter` (newsletter signup, wherever it appears)
- The shared n8n workflow constructs the tag by concatenating the prefix with the `form_location` value. New niches automatically route to the right GHL drip workflow once the prefix is reserved.
