# `_website-template` — Clear & Confident Niche Site Factory

Canonical source-of-truth for every Illumination Lab niche marketing site.
Every new niche (`NeedleMoved`, `RafterElite`, etc.) is built by copying this template,
filling its tokens, and deploying to Coolify.

---

## Design System

| Element | Value |
|---|---|
| Primary brand | Navy `#003058` |
| Accent | `[ACCENT_COLOR]` — unique per niche (e.g. teal `#00A3AA` for NeedleMoved) |
| Accent bright | `[ACCENT_COLOR_BRIGHT]` (e.g. `#00B0B8`) |
| Accent light | `[ACCENT_COLOR_LIGHT]` (e.g. `#3EC4CA`) |
| Accent deep | `[ACCENT_COLOR_DEEP]` (e.g. `#007177`) |
| Heading font | **Sora** (600/700/800) |
| Body font | **Manrope** (400/500/600) |
| Light section bg | `#FFFFFF` / `#F7F9FB` |
| Navy section bg | `#003058` with white text |

**Layout pattern:** light hero → navy impact section → light features → navy CTA → light footer

---

## Tokens

Replace every `[TOKEN]` with the niche-specific value before deploying.

| Token | What it is | Example (NeedleMoved) |
|---|---|---|
| `[PRODUCT_NAME]` | Brand name, exact casing | `NeedleMoved` |
| `[NICHE_CODE]` | Short lowercase identifier, no spaces | `nm` |
| `[DOMAIN]` | Domain without `https://` — product name lowercased, all spaces/punctuation removed + `.com` | `needlemoved.com` |
| `[CONTACT_EMAIL]` | Public contact email | `info@needlemoved.com` |
| `[NICHE_NOUN]` | Industry noun, singular lowercase | `med spa` |
| `[NICHE_NOUN_PLURAL]` | Industry noun, plural lowercase | `med spas` |
| `[NICHE_NOUN_TITLE]` | Industry noun, singular title case | `Med Spa` |
| `[NICHE_NOUN_PLURAL_TITLE]` | Industry noun, plural title case | `Med Spas` |
| `[ACCENT_COLOR]` | Primary accent hex (text-safe on white) | `#00A3AA` |
| `[ACCENT_COLOR_BRIGHT]` | Brighter accent (buttons, highlights) | `#00B0B8` |
| `[ACCENT_COLOR_LIGHT]` | Light accent (hover states, tags) | `#3EC4CA` |
| `[ACCENT_COLOR_DEEP]` | Deep accent (pressed states) | `#007177` |
| `[COPYRIGHT_YEAR]` | Current year | `2026` |
| `[TESTIMONIAL_NAME]` | Full name | `Sarah M.` |
| `[TESTIMONIAL_ROLE]` | Job title | `Owner` |
| `[TESTIMONIAL_BUSINESS]` | Business name | `Luminary Med Spa` |
| `[TESTIMONIAL_CITY]` | City, State | `Austin, TX` |
| `[TESTIMONIAL_INITIALS]` | 1–2 initials for avatar | `SM` |

> **Domain rule:** strip all spaces and punctuation, lowercase.
> `Rafter Elite` → `rafterelite.com` | `NeedleMoved` → `needlemoved.com`

---

## Creating a New Niche Site

### 1. Copy the template

```bash
cp -R _website-template/ repos/niche-sites/[ProductName]/
cd repos/niche-sites/[ProductName]/
```

### 2. Create `variables.json`

```json
{
  "PRODUCT_NAME": "RafterElite",
  "NICHE_CODE": "re",
  "DOMAIN": "rafterelite.com",
  "CONTACT_EMAIL": "info@rafterelite.com",
  "NICHE_NOUN": "roofing company",
  "NICHE_NOUN_PLURAL": "roofing companies",
  "NICHE_NOUN_TITLE": "Roofing Company",
  "NICHE_NOUN_PLURAL_TITLE": "Roofing Companies",
  "ACCENT_COLOR": "#E85D26",
  "ACCENT_COLOR_BRIGHT": "#F06830",
  "ACCENT_COLOR_LIGHT": "#F4956A",
  "ACCENT_COLOR_DEEP": "#B84318",
  "COPYRIGHT_YEAR": "2026",
  "TESTIMONIAL_NAME": "Marcus T.",
  "TESTIMONIAL_ROLE": "Owner",
  "TESTIMONIAL_BUSINESS": "Summit Roofing",
  "TESTIMONIAL_CITY": "Nashville, TN",
  "TESTIMONIAL_INITIALS": "MT"
}
```

### 3. Fill the template

Use the fill script (one-liner — no external deps):

```bash
#!/usr/bin/env bash
# Usage: bash scripts/fill-template.sh variables.json
VARS=$1
for key in $(python3 -c "import json,sys; d=json.load(open('$VARS')); [print(k) for k in d]"); do
  val=$(python3 -c "import json; d=json.load(open('$VARS')); print(d['$key'])")
  find . -type f \( -name "*.html" -o -name "*.css" \) \
    -exec sed -i '' "s/\[$key\]/$val/g" {} \;
done
echo "Done. Verify with: grep -r '\[' . --include='*.html' --include='*.css'"
```

Or manually with `sed`:

```bash
# Example for one token
find . -type f \( -name "*.html" -o -name "*.css" \) \
  -exec sed -i '' 's/\[PRODUCT_NAME\]/RafterElite/g' {} \;
```

### 4. Verify no tokens remain

```bash
grep -r '\[' . --include="*.html" --include="*.css"
# Should return zero results
```

### 5. Test locally

```bash
open index.html   # or: python3 -m http.server 8080
```

Spot-check:
- [ ] Announcement bar shows correct brand + pricing
- [ ] Logo crest accent color matches `[ACCENT_COLOR_BRIGHT]`
- [ ] No `[TOKEN]` strings visible anywhere
- [ ] Contact form POSTs to correct webhook
- [ ] Book demo calendar loads

### 6. Push to GitHub + deploy

```bash
git init && git add -A
git commit -m "Launch [ProductName] — [NicheNoun] niche site"
git remote add origin https://github.com/illuminationlab/[ProductName].git
git push -u origin main
# Coolify will auto-deploy on push
```

---

## Locked Infrastructure (never edit per-niche)

| Element | Location | Notes |
|---|---|---|
| GHL chat widget | bottom of every `<body>` | `leadconnectorhq.com` script — widget ID is shared |
| Contact webhook | `contact.html` form `data-webhook` attr | n8n cloud URL |
| Book demo calendar | `book-demo.html` `<!-- GHL calendar embed -->` | Shared GHL calendar |
| Stripe pricing links | `pricing.html` CTA buttons | Do not change per-niche |
| `js/main.js` | `js/` directory | Handles form submit, announcement close, scroll effects |

---

## Repo Layout

```
_website-template/
├── README.md                   ← this file
├── REGISTRY.md                 ← niche registry (NICHE_CODE uniqueness)
├── prompts/                    ← AI research & build prompts
├── scripts/                    ← fill-template.sh, deploy helpers
├── index.html                  ← Home
├── features.html
├── pricing.html
├── use-cases.html
├── about.html
├── contact.html
├── book-demo.html
├── privacy.html
├── terms.html
├── css/styles.css              ← Full design system (navy + accent tokens)
├── js/main.js                  ← Locked — shared across all niches
├── assets/logo-mark.png        ← Crest mark (recolored per accent in CSS)
└── resources/
    ├── index.html
    ├── blog.html
    ├── playbook.html
    ├── revenue-calculator.html
    ├── getting-started.html
    └── blog/
        ├── ai-medical-aesthetics.html
        ├── client-retention.html
        ├── med-spa-tech-stack.html
        └── reduce-no-shows.html
```

---

## Positioning Rules (enforce across all niches)

These apply to every niche — do not drift from them when writing niche copy:

- **Lead with outcome:** "We fill [NICHE_NOUN_PLURAL]' calendars" — not features
- **Consultant framing:** "Using the tools you already have + our automation library + consulting" — not "replace your stack"
- **AI is surgical:** "After-hours automated chat" / "research assistant" — not "AI replaces your team"  
- **Pricing anchor:** "$199/month forever — first 100 customers" in announcement bar on every page
- **Footer:** always ends with "A Chief Automation Experts company"
- **No White-Label App card** in features
