---
name: niche-build
description: Phase 2 of the niche-site launch flow. Scaffolds a new niche repo from `_website-template/`, resizes brand assets, injects every variable (brand tokens, webhooks, drip prefix, SITE_CONFIG, chatbot widget), applies `content.md` to each page, and runs the Definition of Done sweep. Use after /niche-research has produced content.md and the user has placed master logo + square master image in the niche repo.
version: 1.0.0
user-invocable: true
argument-hint: "[product-name]"
---

# /niche-build

Phase 2 of three: **research → build → launch**. Input: a niche repo at `/Users/ryangough/Desktop/repos/niche-sites/<PRODUCT_NAME_PASCAL>/` containing `variables.json`, `content.md`, and two master brand images. Output: a complete, deployable static site in the same directory, ready for `/niche-launch`.

The template lives at `/Users/ryangough/Desktop/repos/niche-sites/_website-template/`. The authoritative build rules live in `_website-template/prompts/NICHE-BUILD-PLAYBOOK.md` — **read that file in full before writing a single line of code.** The playbook overrides anything in this skill on any disagreement.

## Preconditions (verify all before any edit)

1. Niche repo exists at `/Users/ryangough/Desktop/repos/niche-sites/<PRODUCT_NAME_PASCAL>/`
2. `variables.json` exists in the niche repo with all Section 0 variables filled
3. `content.md` exists in the niche repo with all 7 pages written
4. Niche repo contains two master brand assets at known filenames:
   - `master-logo.svg` (or `.png`) — the full-color logo
   - `master-square.png` (or `.svg`) — square 1024×1024+ for favicon/apple-touch/android
5. `NICHE_CODE` row exists in `_website-template/REGISTRY.md` under Planned or Live

If any precondition fails: stop and tell the user exactly what's missing. Do not create placeholder masters.

## Step-by-step

### 1. Load variables

Source `~/.claude/env.local` and read the niche's `variables.json`. Merge the two — shared defaults (webhooks, chatbot widget ID, GHL calendar URL, Coolify server IP, INTERNAL_EMAIL, LEGAL_ENTITY) come from env.local; niche-specific values (NICHE_CODE, PRODUCT_NAME, DOMAIN, ACCENT_COLOR, TAGLINE, etc.) come from variables.json.

Any variable still missing? Ask the user via `AskUserQuestion` — do not fabricate defaults.

For legal pages on the first niche build: if `IL_FORMATION_STATE`, `IL_GOVERNING_LAW`, or `IL_MAILING_ADDRESS` are empty in env.local, ask the user once, then write the values back to env.local so subsequent builds inherit them.

### 2. ⏸ HUMAN CHECKPOINT — accent color locked

Show the accent color + brand variables. Per the playbook, accent color must be final before any CSS is written. Confirm with user before proceeding. (If they want to change it later, the site needs a full rebuild of the color variable — the playbook is emphatic on this.)

### 3. Resize brand assets

Run `bash _website-template/scripts/resize-brand.sh <master-logo> <master-square> <niche-repo>/public/brand/`. Verify the output contains all 8 expected files (logo-full-color, logo-header, favicon-16, favicon-32, favicon.svg if applicable, apple-touch-icon, android-chrome-192, android-chrome-512). If any is missing, stop.

### 4. Copy template files into the niche repo

Copy the following from `_website-template/` into the niche repo. Preserve `content.md`, `variables.json`, `public/brand/`, and `master-*` files — do not overwrite them.

- All `*.html` files at root
- `css/` and `js/` directories
- `resources/` directory
- **`.gitignore`** — excludes meta artifacts from ever being committed/shipped

Also write `_website-template/prompts/NICHE-BUILD-PLAYBOOK.md` to `<niche-repo>/NICHE-BUILD-PLAYBOOK.md` at the root for traceability — it stays in the workspace but the `.gitignore` keeps it out of git.

**Do NOT copy** `Dockerfile`, `default.conf`, `scripts/`, `prompts/`, `REGISTRY.md`, `README.md` — those are template-only files and should not end up in the niche repo. Nixpacks' staticfile provider on Coolify handles nginx config automatically, including `.html` extension fallback, so no Dockerfile is needed.

**Why `.gitignore` matters here:** Coolify's nixpacks staticfile provider publishes the entire repo root as `/` on the public site. Without `.gitignore`, `content.md`, `NICHE-BUILD-PLAYBOOK.md`, `variables.json`, `research-brief.md`, and the master brand images all become publicly fetchable at `engineguild.com/content.md`, etc. — leaking internal pricing, build rules, and research notes. The template's `.gitignore` excludes all of these; the skill MUST copy it into the niche repo before the first `git add .`.

### 5. Replace tokens across all HTML + CSS

Derive accent-color variants from `variables.accent_color` before substituting:
- `ACCENT_COLOR_RGB` = hex converted to comma-separated RGB (e.g. `#C8102E` → `200, 16, 46`)
- `ACCENT_COLOR_LIGHT` = hex lightened ~25% (e.g. `#C8102E` → `#E53E4C`)
- `ACCENT_COLOR_DARK` = hex darkened ~25% (e.g. `#C8102E` → `#9C0B22`)

Use Python's `colorsys` or a manual HSL shift. Report all three derived values to the user alongside the locked `ACCENT_COLOR` for sanity-check before proceeding.

In every `.html` and `.css` file in the niche repo, run these substitutions with the values loaded in step 1:

```
[PRODUCT_NAME]            → variables.product_name
[DOMAIN]                  → variables.domain
[LEAD_WEBHOOK]            → env.LEAD_WEBHOOK
[NEWSLETTER_WEBHOOK]      → env.NEWSLETTER_WEBHOOK
[ACCENT_COLOR]            → variables.accent_color            (e.g. #C8102E)
[ACCENT_COLOR_URL]        → variables.accent_color URL-encoded (e.g. %23C8102E)
[ACCENT_COLOR_RGB]        → derived (e.g. 200, 16, 46)
[ACCENT_COLOR_LIGHT]      → derived (e.g. #E53E4C)
[ACCENT_COLOR_DARK]       → derived (e.g. #9C0B22)
[COPYRIGHT_YEAR]          → current year (e.g. 2026)
[TESTIMONIAL_NAME]        → fabricated full name appropriate for the niche (e.g. "Danielle Rivera")
[TESTIMONIAL_INITIALS]    → first letter of first + last name (e.g. "DR"), MUST match the name avatar circle
[TESTIMONIAL_ROLE]        → realistic role for niche owner (e.g. "Owner", "Operations Manager", "Founder")
[TESTIMONIAL_BUSINESS]    → fabricated business name matching the niche (e.g. "Lumen Aesthetics" for med spa)
[TESTIMONIAL_CITY]        → city + state matching a real cluster for the niche (e.g. "Scottsdale, AZ" for med spa)
```

Also: set the default `CONTACT_EMAIL` to `info@<DOMAIN>` (e.g. `info@engineguild.com`). The `info@` alias is always created at domain purchase. Only override if the user explicitly specifies a different customer-facing email.

**Fabricated testimonial guidance:** generate a believable name + business + city for the niche. The testimonial quote in the template already mentions the product replacing prior tools and improving conversion — keep that, just personalize the author. Pick a city that's a real industry cluster (med spas → Scottsdale/Miami/Beverly Hills; roofing → Dallas/Tampa; small engine repair → rural Midwest towns; pest control → Phoenix/Houston). NEVER ship `[TESTIMONIAL_*]`, `[Placeholder ...]`, `[Logo N]`, `[Client Name]`, or any other unreplaced bracket. NEVER ship a logo strip ("Trusted by X across the country" + [Logo 1][Logo 2]...) — fake logos look amateur and real logos require permissions you don't have.

After substitution, grep for any remaining `[BRACKET]` tokens in `.html`/`.css`:

```bash
grep -rn "\[[A-Z_]\+\]" <niche-repo> --include="*.html" --include="*.css"
```

If any remain, stop and report them. Do not proceed.

### 5b. Template-shipped defenses (already in place — verify, don't remove)

The `_website-template/` repo ships with two defensive patterns that exist in
response to past production bugs. **Never strip them during build:**

1. **Honeypot field on newsletter forms** — every form posting to
   `NEWSLETTER_WEBHOOK` includes:
   ```html
   <input type="text" name="company" tabindex="-1" autocomplete="off"
          aria-hidden="true"
          style="position:absolute;left:-9999px;width:1px;height:1px;opacity:0;pointer-events:none;">
   ```
   Bots fill this; real users can't see it. The shared n8n newsletter
   workflow inspects `body.company` and drops submissions where it's
   non-empty. Removing this field opens the GHL contact list to bot floods.

2. **Header z-index fix in `styles.css`** — appended at the end of
   `styles.css` is a block beginning with the comment `header stacks above
   page content so the dropdown is clickable`. This sets:
   - `.header { position: relative; z-index: 50 }`
   - `.announcement-bar { z-index: 51 }`
   - `.dropdown { z-index: 10; padding 12px to close hover gap }`

   Without it, hero content (z-index: 2) paints over the absolute-positioned
   `.dropdown`, making the Resources menu unclickable. NeedleMoved shipped
   without this fix and required a post-launch patch (commit 57e49b9).

Both are verified by DoD checks `(a4)` and `(a5)` in Section 12.

### 6. Inject SITE_CONFIG + chatbot widget into every page

For **every** HTML file in the niche repo (including `privacy.html` and `terms.html` — v4.1 change):

1. Inside `<head>`, before the main.js script tag, insert:

    ```html
    <script>window.SITE_CONFIG = { source_site: "<NICHE_CODE>" };</script>
    ```

2. Inside `<body>` (near the closing `</body>`, after any page-level scripts but before `</body>`), insert the chatbot widget snippet. Pull the widget ID from `env.CHATBOT_WIDGET_ID`:

    ```html
    <script src="https://widgets.leadconnectorhq.com/loader.js"
            data-resources-url="https://widgets.leadconnectorhq.com/chat-widget/loader.js"
            data-widget-id="<CHATBOT_WIDGET_ID>"></script>
    ```

The chatbot renders on legal pages too — there's no compliance reason to exclude them, and users on privacy/terms are exactly the ones most likely to have support questions.

### 7. Prefix `form_location` hidden inputs with `DRIP_TAG_PREFIX`

The shared n8n switch node branches by the exact literal value of `{{ $json.form_location }}`. Every niche site must POST a prefixed form_location so the switch can route per-niche (e.g., `engine-contact` vs. `rafter-contact`).

The template HTML ships with **unprefixed** form_location values (clean canonical vocabulary):

| Page / context | Template value (unprefixed) |
| --- | --- |
| `contact.html` main form | `contact` |
| Any newsletter signup (resources hub, blog index, blog stub pages) | `newsletter` |
| `resources/revenue-calculator.html` lead form | `revenue-calculator` |
| `resources/playbook.html` download form | `playbook-download` |

During build, **run this substitution in every HTML file in the niche repo** — prepending `<DRIP_TAG_PREFIX>-` to each value:

```bash
PREFIX="$(jq -r .drip_tag_prefix variables.json)"   # e.g. "engine"
find . -name "*.html" -type f ! -path "./public/*" -exec sed -i '' \
  -e "s|name=\"form_location\" value=\"contact\"|name=\"form_location\" value=\"${PREFIX}-contact\"|g" \
  -e "s|name=\"form_location\" value=\"newsletter\"|name=\"form_location\" value=\"${PREFIX}-newsletter\"|g" \
  -e "s|name=\"form_location\" value=\"revenue-calculator\"|name=\"form_location\" value=\"${PREFIX}-revenue-calculator\"|g" \
  -e "s|name=\"form_location\" value=\"playbook-download\"|name=\"form_location\" value=\"${PREFIX}-playbook-download\"|g" \
  {} \;
```

Verify before moving on — every `form_location` value in the niche repo must start with `${PREFIX}-`:

```bash
grep -rh 'name="form_location"' --include="*.html" . | grep -oE 'value="[^"]+"' | sort -u
```

No unprefixed values should remain.

**Why prefix per-niche**: the shared LEAD_WEBHOOK n8n switch node has one branch per `<prefix>-<form_type>` value across every niche site. Three new branches per niche get added manually in n8n (see `/niche-launch` step 6). Newsletter is routed to a separate NEWSLETTER_WEBHOOK workflow — no switch branch needed there.

If a new form type ever needs its own branch, add the 5th entry to both the template HTML vocabulary and this substitution step — AND coordinate adding matching branches in the n8n switch before launching.

### 8. Ensure `main.js` auto-injects `source_site`

Open `<niche-repo>/js/main.js`. In the `initForms` function, inside the submit handler, after the `data` object is built, add (if missing):

```javascript
// Inject source_site from window.SITE_CONFIG (set per-site in <head>)
if (window.SITE_CONFIG && window.SITE_CONFIG.source_site) {
  data.source_site = window.SITE_CONFIG.source_site;
}
```

### 9. Apply `content.md` to pages

Read `<niche-repo>/content.md`. Map each of the 7 page sections to the corresponding HTML file:

| content.md section | HTML file |
| --- | --- |
| Page 1: Overview | `index.html` |
| Page 2: Features | `features.html` |
| Page 3: Use Cases | `use-cases.html` |
| Page 4: Resources | `resources.html` (+ blog post outlines feed individual `resources/blog/*.html` stubs if they exist in template) |
| Page 5: Pricing | `pricing.html` (merge with locked pricing block from playbook Section 3 — locked pricing wins on conflict) |
| Page 6: About Us | `about.html` |
| Page 7: Contact Us | `contact.html` |

For each page:
- Replace the hero copy (headline, subheadline, CTAs) with content.md copy
- Replace the `<title>` and `<meta name="description">` with the SEO block from content.md
- Replace body sections, preserving the template's section skeleton (hero, features grid, FAQ accordion, etc. all stay — only the text content swaps)
- Keep playbook CSS classes intact — do not rewrite markup structure, only text nodes
- For testimonials: use content.md's stand-ins (first-name + last-initial + city) — do NOT leave NeedleMoved's names
- For Pricing: the Stripe links, tier names, and feature lists are LOCKED from playbook Section 3 / Appendix C — content.md's pricing copy only affects the framing paragraph, FAQ, and comparison table text

`book-demo.html`: no content.md section. The page stays as the GHL calendar embed per playbook Section 4d — just confirm the iframe src still uses the shared `McMT8bQnMFU8gw2dk8cY` widget ID.

### 10. Generate the legal pages

`privacy.html` and `terms.html` in the template are NeedleMoved's legal content. Rewrite them using the legal variables (`LEGAL_ENTITY`, `FORMATION_STATE`, `GOVERNING_LAW`, `EFFECTIVE_DATE`, `CONTACT_EMAIL`, `MAILING_ADDRESS`) per playbook Section 9. Include GDPR, CCPA, retention, cookie policy, and dispute resolution clauses — full text, not placeholders. Keep the "HIPAA Business Associate" section only if the niche is healthcare-adjacent; remove for non-HIPAA niches.

### 11. Bump `?v=` cache-bust

The template uses `?v=13` (NeedleMoved's last version). Reset to `?v=1` in every `<link rel="stylesheet">` and `<script>` tag across the niche repo. Subsequent edits bump to `v=2`, `v=3`, etc.

```bash
grep -rln 'styles.css?v=\|main.js?v=' <niche-repo> --include="*.html" \
  | xargs sed -i '' -E 's|(styles\.css\?v=)[0-9]+|\11|g; s|(main\.js\?v=)[0-9]+|\11|g'
```

### 12. ⏸ Definition of Done automated sweep

Run these checks (in order) from the niche repo root. Report each failure — do NOT fix silently.

```bash
# (a) No leftover [UPPER_SNAKE_CASE] variable tokens
grep -rn "\[[A-Z_]\+\]" . --include="*.html" --include="*.css" --include="*.js" \
  | grep -v node_modules \
  | grep -v "NICHE-BUILD-PLAYBOOK.md"

# (a2) No mixed-case bracket placeholders that the (a) regex misses.
# Catches "[Placeholder Client Name]", "[Practice Name]", "[City]", "[Client Name]",
# "[Author]", "[Logo 1]" through "[Logo 9]", and similar human-written placeholders.
# Past launches shipped these because the (a) regex above only matched all-caps tokens.
grep -rnE "\[(Placeholder|Logo|Client|Practice|Author|Owner|Name|City|State|Title)[^\]]*\]" . \
  --include="*.html" --include="*.css" \
  | grep -v "NICHE-BUILD-PLAYBOOK.md"

# (a3) No fake [Logo N] markers. The "Trusted by X across the country" + logo
# strip was removed from the template — never re-add it. Real logos require
# partner-brand permissions you don't have; fake logos look amateur. The header
# prose ("trusted by ... across the country") is fine in copy on its own; only
# the [Logo 1][Logo 2]... markers are banned.
grep -rnE "\[Logo [0-9]+\]" . --include="*.html"

# (a4) Honeypot field must exist in every newsletter form. The template
# ships with a hidden `<input name="company">` inside each form that posts to
# NEWSLETTER_WEBHOOK. Real users can't see it (CSS-hidden off-screen); bots
# happily fill it. n8n's newsletter workflow drops submissions where company
# is non-empty. If the honeypot is missing on any newsletter form, the form
# is unprotected — past audits found bots flooding the GHL contact list when
# this was absent. Fix: re-add the hidden input from the template.
for f in $(grep -rln 'NEWSLETTER_WEBHOOK\|eec95ff5' --include="*.html" . | head -20); do
  if ! grep -q 'name="company"' "$f"; then
    echo "  MISSING HONEYPOT: $f"
  fi
done

# (a5) Dropdown z-index fix must exist in styles.css. Without it, the
# .header (z-index: 1) is painted UNDER hero content (.hero-content z-index: 2),
# making the Resources dropdown invisible/unclickable. The fix is a 12-line
# block at the end of styles.css that bumps .header to z-index: 50 and adds
# padding to .dropdown to close the hover gap. The template's styles.css
# ships with this fix. If it's missing, the dropdown menu fails on every page
# with a hero section.
grep -c "header stacks above page content" css/styles.css >/dev/null && \
  echo "  ✓ dropdown z-index fix present in styles.css" || \
  echo "  MISSING: dropdown z-index fix in css/styles.css — Resources menu will be unclickable"

# (b) No free-trial language
grep -rniE "free trial|try .*free|start free|14[- ]day free" . --include="*.html" \
  | grep -vE "(COUPON|NO free trial|ban list|FREE_TRIAL = NO)"

# (c) No fake 555 phone numbers
grep -rnE "\b555[- ]?[0-9]{4}\b" . --include="*.html"

# (d) No NeedleMoved/needlemoved leakage
grep -rni "needlemoved" . --include="*.html"

# (e) No /webhook-test/ URLs
grep -rn "/webhook-test/" . --include="*.html"

# (f) All pages have unique titles + meta descriptions
for f in *.html; do
  echo "=== $f ==="
  grep -o '<title>[^<]*</title>' "$f"
  grep -o '<meta name="description"[^>]*>' "$f"
done
```

Any non-empty output from a-e = build not done. Don't mark the task complete.

### 13. ⏸ Definition of Done manual checklist

Print the full DoD checklist from playbook Section 11 to the user with obvious checkboxes. They read through in a browser (open `index.html` locally) and confirm each section:

- Global (layout, logo, favicon, footer, titles, announcement bar)
- Forms & routing (production webhook, text/plain + no-cors, intent routing, SITE_CONFIG)
- Pricing (all three Stripe links correct, $200 setup fee line, pay-as-you-go framing, FAQ)
- CSS (split-visual, checklist, stats-row, page-hero rules from Section 6)

Do not proceed to `/niche-launch` until the user says "continue" or equivalent. The launch step pushes to production — the DoD is the last line of defense.

### 14. End-of-turn summary

Two sentences. What was built, DoD status, next step is `/niche-launch`.

## Cross-niche audit rule (when fixing a build issue post-launch)

If a fix applied to this niche could plausibly exist in any other live niche, run:

```bash
bash /Users/ryangough/Desktop/repos/niche-sites/_website-template/scripts/audit-across-niches.sh '<pattern>' '*.html'
```

If the script exits 1, fix the matched niches AND the template before this build is "done." See playbook Section 11 for the full rule.

## Invariants

- The playbook overrides this skill on any disagreement
- Pricing tiers + Stripe links are LOCKED — never modify
- No free-trial language makes it into the build, even if content.md suggested it (sanitize during apply)
- Accent color is set once in CSS via `--color-accent: <hex>` and every usage is `var(--color-accent)` — never a second hardcoded hex
- Testimonials use the stand-in format — never real or fabricated business names
- Legal pages are rewritten from scratch per the variables — do not carry NeedleMoved legal text

## What this skill does NOT do

- It does not run `git` or push to GitHub. That is `/niche-launch`.
- It does not call the Coolify API. That is `/niche-launch`.
- It does not update REGISTRY.md status from Planned → Live. That is `/niche-launch`.
- It does not generate logos or photography. User supplies masters before this skill runs.
