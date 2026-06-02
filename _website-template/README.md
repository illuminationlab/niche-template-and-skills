# Niche Site Factory — Instruction Manual

This template is the master copy for every Illumination Lab niche marketing site.
You copy it, fill in brand values, deploy. The design, copy structure, locked
infrastructure, and positioning rules stay consistent across every niche.

**Live examples built from this template:**
- NeedleMoved (`needlemoved.com`) — med spas

---

## Table of Contents

1. [How It Works](#how-it-works)
2. [Before You Start](#before-you-start)
3. [Step-by-Step: Launch a New Niche](#step-by-step-launch-a-new-niche)
4. [Token Reference](#token-reference)
5. [Choosing Your Accent Color](#choosing-your-accent-color)
6. [Design System](#design-system)
7. [Page-by-Page Guide](#page-by-page-guide)
8. [What NOT to Change](#what-not-to-change)
9. [Positioning Rules](#positioning-rules)
10. [Troubleshooting](#troubleshooting)

---

## How It Works

Every page in this template contains placeholder tokens like `[PRODUCT_NAME]`
and `[ACCENT_COLOR]`. You replace those tokens with real values for your niche,
and the entire 23-page site becomes a fully branded, production-ready build.

There is no build system, no Node, no npm. It is plain HTML and CSS.
The fill step is a single shell command. Deploy is a git push.

**Time from copy to live site: under 2 hours.**

---

## Before You Start

You need:

- [ ] **Product name** — the brand name for this niche (e.g. `RafterElite`)
- [ ] **Domain** — purchased and pointed to Coolify (e.g. `rafterelite.com`)
- [ ] **Accent color** — one hex, chosen for the industry (see [Choosing Your Accent Color](#choosing-your-accent-color))
- [ ] **Industry noun** — singular and plural, lowercase (e.g. `roofing company` / `roofing companies`)
- [ ] **Testimonial** — name, role, business name, city, and initials of a real or placeholder customer
- [ ] **NICHE_CODE registered** — open `REGISTRY.md`, confirm your 2–3 letter code is not taken, add a row

Do not start the fill step until all of the above are decided. Changing tokens
after filling is tedious.

---

## Step-by-Step: Launch a New Niche

### Step 1 — Reserve your niche code

Open `REGISTRY.md`. Add a row for your new niche. The `NICHE_CODE` must be unique
(2–3 lowercase letters, no spaces). This code appears in form hidden fields and
analytics so data does not get mixed across sites.

```
| RafterElite | re | rafterelite.com | roofing | In Progress |
```

---

### Step 2 — Copy the template

```bash
# From the root of this repo
cp -R _website-template/ ../niche-sites/RafterElite/
cd ../niche-sites/RafterElite/
```

If you are creating a standalone GitHub repo for this niche:

```bash
cp -R _website-template/ ~/projects/RafterElite/
cd ~/projects/RafterElite/
git init && git add -A
git commit -m "Init from _website-template"
```

---

### Step 3 — Create `variables.json`

Create this file at the root of the copied folder.
Every token in the template maps to a key here.

```json
{
  "PRODUCT_NAME":             "RafterElite",
  "NICHE_CODE":               "re",
  "DOMAIN":                   "rafterelite.com",
  "CONTACT_EMAIL":            "info@rafterelite.com",
  "NICHE_NOUN":               "roofing company",
  "NICHE_NOUN_PLURAL":        "roofing companies",
  "NICHE_NOUN_TITLE":         "Roofing Company",
  "NICHE_NOUN_PLURAL_TITLE":  "Roofing Companies",
  "ACCENT_COLOR":             "#D94F1E",
  "ACCENT_COLOR_BRIGHT":      "#E85D26",
  "ACCENT_COLOR_LIGHT":       "#F4956A",
  "ACCENT_COLOR_DEEP":        "#A83A10",
  "COPYRIGHT_YEAR":           "2026",
  "TESTIMONIAL_NAME":         "Marcus T.",
  "TESTIMONIAL_ROLE":         "Owner",
  "TESTIMONIAL_BUSINESS":     "Summit Roofing",
  "TESTIMONIAL_CITY":         "Nashville, TN",
  "TESTIMONIAL_INITIALS":     "MT"
}
```

> **Domain rule:** lowercase the product name, remove all spaces and punctuation, add `.com`.
> `Rafter Elite` → `rafterelite.com`
> `NeedleMoved` → `needlemoved.com`
> `The Lawn Pro` → `thelawnpro.com`

---

### Step 4 — Fill the template

Run the fill script from the repo root. It reads `variables.json` and replaces
every `[TOKEN]` in every `.html` and `.css` file.

```bash
bash scripts/fill-template.sh variables.json
```

The script outputs `Done.` when finished. If you see an error, check that
`python3` is available (`python3 --version`).

**What the script does:**
For each key in `variables.json`, it runs a `sed` replace across all HTML and
CSS files. Tokens are matched exactly — `[PRODUCT_NAME]` is replaced with the
value you provided. Order does not matter; each token is independent.

---

### Step 5 — Verify

```bash
# This should return zero results. Any output = unfilled token.
grep -r '\[' . --include="*.html" --include="*.css"
```

Then open the site locally and spot-check these five things:

```bash
python3 -m http.server 8080
# Open http://localhost:8080
```

**Checklist:**
- [ ] Announcement bar: `$199 a month, forever — for the first 100 customers`
- [ ] Logo shows correct brand name, accent color on crest
- [ ] Hero headline matches the niche (no `[TOKENS]` visible anywhere)
- [ ] Pricing page: $199/month, pay-to-use model, no contradictions
- [ ] Contact form submits without JS errors (check browser console)
- [ ] Book demo page: calendar iframe loads
- [ ] Footer: `A Chief Automation Experts company`
- [ ] Mobile: nav hamburger works, text readable

---

### Step 6 — Customise copy (optional but recommended)

The template ships with med-spa copy (NeedleMoved) as its starting point.
Tokens replace the brand name and niche nouns, but **industry-specific stats,
pain points, and feature descriptions should be updated** to reflect the real niche.

Pages that need the most copy attention:
- `index.html` — hero subhead, problem section stats, use-case cards
- `use-cases.html` — every use-case is currently written for med spas
- `features.html` — feature descriptions reference med-spa workflows
- `about.html` — the "who we help" paragraph
- `resources/blog/` — all four articles are med-spa topics; replace or archive

Pages that work as-is with tokens only:
- `pricing.html` — pricing model is industry-agnostic
- `contact.html` — generic enough to keep
- `book-demo.html` — generic enough to keep
- `privacy.html` / `terms.html` — legal text is generic

---

### Step 7 — Push to GitHub and deploy

```bash
git add -A
git commit -m "Launch RafterElite — roofing niche site"
git remote add origin https://github.com/illuminationlab/RafterElite.git
git push -u origin main
```

Coolify will detect the push and redeploy automatically.
DNS must be pointed to your Coolify server IP before the domain goes live.

Update `REGISTRY.md` — change the status from `In Progress` to `Live`.

---

## Token Reference

| Token | Description | Example |
|---|---|---|
| `[PRODUCT_NAME]` | Brand name, exact casing | `NeedleMoved` |
| `[NICHE_CODE]` | Unique 2–3 letter ID, lowercase | `nm` |
| `[DOMAIN]` | Domain, no `https://` | `needlemoved.com` |
| `[CONTACT_EMAIL]` | Public contact address | `info@needlemoved.com` |
| `[NICHE_NOUN]` | Industry noun, singular, lowercase | `med spa` |
| `[NICHE_NOUN_PLURAL]` | Industry noun, plural, lowercase | `med spas` |
| `[NICHE_NOUN_TITLE]` | Industry noun, singular, title case | `Med Spa` |
| `[NICHE_NOUN_PLURAL_TITLE]` | Industry noun, plural, title case | `Med Spas` |
| `[ACCENT_COLOR]` | Primary accent hex — text-safe on white | `#00A3AA` |
| `[ACCENT_COLOR_BRIGHT]` | Brighter accent — buttons and hero highlights | `#00B0B8` |
| `[ACCENT_COLOR_LIGHT]` | Light accent — hover states, tag backgrounds | `#3EC4CA` |
| `[ACCENT_COLOR_DEEP]` | Deep accent — pressed states, shadows | `#007177` |
| `[COPYRIGHT_YEAR]` | Year in footer | `2026` |
| `[TESTIMONIAL_NAME]` | Customer full name | `Sarah M.` |
| `[TESTIMONIAL_ROLE]` | Customer job title | `Owner` |
| `[TESTIMONIAL_BUSINESS]` | Customer business name | `Luminary Med Spa` |
| `[TESTIMONIAL_CITY]` | Customer city, state | `Austin, TX` |
| `[TESTIMONIAL_INITIALS]` | 1–2 letters for avatar circle | `SM` |

---

## Choosing Your Accent Color

The accent is the only color that changes between niches. Navy `#003058` is shared
by every site. Choose an accent that:

- Passes AA contrast on white (`#FFFFFF`) — test at [webaim.org/resources/contrastchecker](https://webaim.org/resources/contrastchecker) using `[ACCENT_COLOR]` (the text-safe variant)
- Feels right for the industry (see palette suggestions below)
- Is distinct from the navy so the crest reads clearly

**Palette suggestions by industry:**

| Industry | Accent | Bright | Light | Deep |
|---|---|---|---|---|
| Med spa / wellness | `#00A3AA` | `#00B0B8` | `#3EC4CA` | `#007177` |
| Roofing / construction | `#D94F1E` | `#E85D26` | `#F4956A` | `#A83A10` |
| Lawn / landscaping | `#2E7D32` | `#388E3C` | `#66BB6A` | `#1B5E20` |
| Dental / orthodontics | `#1565C0` | `#1976D2` | `#64B5F6` | `#0D47A1` |
| HVAC / home services | `#F57C00` | `#FB8C00` | `#FFCC80` | `#BF360C` |
| Legal / professional | `#4A148C` | `#6A1B9A` | `#CE93D8` | `#311B92` |
| Fitness / personal training | `#C62828` | `#D32F2F` | `#EF9A9A` | `#880E4F` |

To derive the four shades from one hex: Bright = base. Regular = 10% darker.
Light = 40% lighter. Deep = 25% darker. A tool like [coolors.co](https://coolors.co)
makes this fast.

---

## Design System

### Colors

| Variable | Value | Usage |
|---|---|---|
| `--navy` | `#003058` | Headings, nav text, navy sections, footer |
| `--navy-deep` | `#002445` | Hover on navy elements |
| `--color-accent` | `[ACCENT_COLOR]` | Body text links, inline highlights |
| `--color-accent-bright` | `[ACCENT_COLOR_BRIGHT]` | Buttons, logo crest, hero highlights |
| `--color-accent-light` | `[ACCENT_COLOR_LIGHT]` | Tag backgrounds, hover fills |
| `--color-accent-deep` | `[ACCENT_COLOR_DEEP]` | Button pressed states |
| `--color-bg` | `#FFFFFF` | Hero and light sections |
| `--color-bg-alt` | `#F7F9FB` | Alternating light sections |
| `--color-text` | `#0F2137` | Body text on light sections |

### Fonts

**Sora** — loaded from Google Fonts — used for all headings (`h1`–`h4`), the logo
wordmark, and display numbers. Weights 600, 700, 800.

**Manrope** — loaded from Google Fonts — used for body text, nav, buttons, captions.
Weights 400, 500, 600.

Both are loaded in `<head>` on every page. Do not swap these out per-niche.

### Section Types

Every page is built from three section types:

| Class | Background | Text | Use for |
|---|---|---|---|
| `.section` | White `#FFFFFF` | Navy `#0F2137` | Features, testimonials, default content |
| `.section-alt` | Off-white `#F7F9FB` | Navy `#0F2137` | Alternating content blocks |
| `.section-navy` | Navy `#003058` | White `#FFFFFF` | Impact stats, CTAs, social proof |

**Page rhythm** (follow this on every page):
Announcement bar → Header → Light hero → Navy impact → Light content → Navy CTA → Footer

---

## Page-by-Page Guide

| Page | File | Primary purpose | Key sections to customise |
|---|---|---|---|
| Home | `index.html` | First impression, conversion | Hero headline, problem stats, use-case cards, testimonial |
| Features | `features.html` | Capability catalogue | Feature descriptions, industry-specific workflow copy |
| Pricing | `pricing.html` | Remove objections, convert | FAQ — ensure pricing model matches the niche |
| Use Cases | `use-cases.html` | Show ROI for specific pain points | Every use-case card — rewrite for the niche's actual problems |
| About | `about.html` | Build trust | "Who we help" paragraph, origin story |
| Contact | `contact.html` | Capture inquiries | Minimal changes needed |
| Book Demo | `book-demo.html` | Book calls | Minimal changes needed — calendar is shared |
| Privacy | `privacy.html` | Legal compliance | Update contact email token, verify domain references |
| Terms | `terms.html` | Legal compliance | Same as privacy |
| Resources hub | `resources/index.html` | Content entry point | Minimal |
| Blog listing | `resources/blog.html` | SEO, authority | Replace med-spa article titles with niche topics |
| Playbook | `resources/playbook.html` | Lead magnet | Rewrite for niche marketing tactics |
| Revenue Calculator | `resources/revenue-calculator.html` | Interactive lead gen | Input labels are niche-specific — update them |
| Getting Started | `resources/getting-started.html` | Onboarding | Rewrite steps for the niche onboarding flow |
| Blog articles (×4) | `resources/blog/*.html` | SEO content | Replace or rewrite all four articles for the niche |

---

## What NOT to Change

These are shared across all niches and live in the master GHL/n8n accounts.
Changing them per-niche will break tracking, bookings, or chat.

| Element | Location | Why it is locked |
|---|---|---|
| GHL chat widget script | Bottom `<body>` on every page | Shared widget ID — routes to the same inbox |
| Contact form webhook URL | `contact.html` `data-webhook` attr | n8n workflow parses `source_site` to route per-niche |
| Book demo calendar embed | `book-demo.html` | Shared GHL calendar — appointment routing handled server-side |
| Stripe payment links | `pricing.html` CTA buttons | Shared Stripe account, products already created |
| `js/main.js` | `js/` directory | Handles announcement close, form submit, scroll reveals — do not fork per-niche |

If you need to change any of these, update the master (this template) and
re-fill all live niches, or handle routing at the n8n/GHL layer.

---

## Positioning Rules

Every niche site must follow these rules. They reflect the Chief Automation
Experts brand promise. If AI or Claude writes copy for a niche, paste these
rules into the prompt.

**1. Lead with the outcome, not the tool.**
✅ "We fill roofing companies' calendars."
❌ "Our AI-powered CRM automates your pipeline."

**2. Consultant framing — we work alongside their existing tools.**
✅ "Using the tools you already have, plus our automation library and consulting."
❌ "Replace your CRM with one platform that does everything."

**3. AI is surgical and after-hours — not a replacement.**
✅ "After-hours automated chat handles inbound messages while your team sleeps."
❌ "Voice AI replaces your receptionist."
❌ "AI handles all your customer communication."

**4. Pricing anchor is on every page.**
The announcement bar reads: `$199 a month, forever — for the first 100 customers.`
Do not remove it. Do not change the number without updating every live niche.

**5. Authority line is in every footer.**
`A Chief Automation Experts company`
This ties every niche back to the parent brand.

**6. No White-Label App feature card.**
The features page must not include a "White-Label App" or "Your Own App" card.

---

## Troubleshooting

**Tokens still visible after running the fill script**

The grep check `grep -r '\[' .` will catch them.
Common causes:
- Value in `variables.json` contains a `/` or `&` — these break `sed`. Escape them: `\/` and `\&`.
- Token was added to the template after the fill ran — re-run the script.
- File was not in a `.html` or `.css` extension — check if any `.js` files need filling.

**CSS not loading locally**

Open the file via a local server (`python3 -m http.server 8080`), not by
double-clicking the HTML file. Browsers block relative CSS loads from `file://`.

**Accent color looks wrong on the crest / logo**

The crest SVG in the header uses `var(--color-accent-bright)` from the CSS.
If the crest still shows the old color, hard-refresh the browser (Cmd+Shift+R).

**Calendar not loading on book-demo page**

The GHL embed requires the live domain to be whitelisted in GHL.
Go to GHL → Settings → Calendars → embed settings and add the new domain.

**Contact form not submitting**

The form posts to the n8n webhook. Check browser DevTools → Network for the
POST request. If it 404s, the webhook URL may have changed — update the
`data-webhook` attribute in `contact.html` and update this template.

**Coolify not deploying on push**

Check Coolify → project → deployment logs. Common causes: wrong branch set in
Coolify (should be `main`), or publish directory set to a subdirectory instead
of `/` (root).
