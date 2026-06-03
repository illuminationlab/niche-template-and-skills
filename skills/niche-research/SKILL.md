---
name: niche-research
description: Phase 1 of the niche-site launch flow. Reserves a NICHE_CODE in the registry, collects the variables needed to fill the deep-research prompt, scaffolds the niche repo directory, and runs a research subagent to produce the 7-page SEO content plan (`content.md`). Use when starting a brand-new niche site — before /niche-build.
version: 1.0.0
user-invocable: true
argument-hint: "[niche-code] [product-name]"
---

# /niche-research

Phase 1 of three: **research → build → launch**. This skill produces the `content.md` that `/niche-build` applies to every page of the new niche site.

The canonical template + prompts + registry live at `/Users/laurenwilliams/Desktop/repos/niche-sites/_website-template/`. Read `_website-template/prompts/deep-research-prompt.md` and `_website-template/REGISTRY.md` before proceeding.

## Prerequisite (before this skill runs)

**The domain must already be purchased at Namecheap (or the registrar of your choice) before `/niche-research` runs.** Every niche starts with a locked domain — we don't pick a name, reserve a code, then discover the domain is taken. The skill assumes the user provides a domain they already own.

## Inputs you must collect (before anything is written)

Ask the user for any that weren't passed as arguments. Use `AskUserQuestion` with one question per field, or a single prompt covering all of them:

| Variable | Example | Notes |
| --- | --- | --- |
| `NICHE_CODE` | `eg` | 2–3 lowercase letters. Must NOT appear in `_website-template/REGISTRY.md` under Live, Planned, or Retired. Drives `window.SITE_CONFIG.source_site`. |
| `DRIP_TAG_PREFIX` | `engine` | Niche-descriptor keyword used in GHL drip tags (`<prefix>-<form_location>`). Also must be unique in REGISTRY.md. Single word, lowercase, no hyphens (e.g. `engine`, `medspa`, `roofer`, `florist`). |
| `PRODUCT_NAME` | `EngineGuild` | Proper noun — how the brand is written in copy. Becomes the niche repo directory name (PascalCase, no spaces). |
| `NICHE` | `small engine repair` | Short form used in body copy ("built for small engine repair businesses"). |
| `NICHE_PLURAL` | `small engine repair shops` | Plural form (may equal NICHE for mass nouns). |
| `DOMAIN` | `engineguild.com` | **Already purchased.** No protocol, no `www.` |
| `TAGLINE` | `Stop juggling notebooks and voicemails. Run your whole shop from one place.` | One sentence. |
| `ACCENT_COLOR` | `#00b0b8` | Hex. **House brand default = teal `#00b0b8` + navy `#002445`** (all live sites use it). Only deviate if the user explicitly asks for a per-niche color. **Must be locked before build — no mid-build color changes.** |

House brand (default for every new niche unless the user overrides): teal accent `#00b0b8`, navy secondary `#002445`. The navy lives in the logo art (generated per-niche), not in a CSS token — the site CSS only needs the teal accent ramp. Derived teal ramp the build will produce: `ACCENT_COLOR_RGB` = `0, 176, 184`, `ACCENT_COLOR_LIGHT` = `#4fd1d6`, `ACCENT_COLOR_DARK` = `#007a80`.

On accent color, the build skill auto-derives `ACCENT_COLOR_RGB` (comma-separated RGB triplet), `ACCENT_COLOR_LIGHT` (~25% lighter variant), and `ACCENT_COLOR_DARK` (~25% darker variant) from the hex. Confirm the derived light/dark variants with the user before build if the accent is unusual (i.e. not the teal default).

## Step-by-step

### 1. Verify NICHE_CODE **and** DRIP_TAG_PREFIX are both free

```bash
grep -nE "^\| $NICHE_CODE " /Users/laurenwilliams/Desktop/repos/niche-sites/_website-template/REGISTRY.md || echo "CODE FREE"
grep -nE "\| $DRIP_TAG_PREFIX " /Users/laurenwilliams/Desktop/repos/niche-sites/_website-template/REGISTRY.md || echo "PREFIX FREE"
```

If EITHER identifier is already in any row (Live, Planned, or Retired), **stop** and ask the user for a different value. Do not proceed — GHL tag collisions and duplicate source_site values are silent and hard to untangle.

### 2. Reserve both identifiers in REGISTRY.md

Edit `_website-template/REGISTRY.md`: add a row under **Planned / reserved** with `NICHE_CODE`, `DRIP_TAG_PREFIX`, `PRODUCT_NAME`, `NICHE`, `DOMAIN`, status `Planned`. Do this BEFORE writing anything else so both identifiers are permanently claimed even if the session is interrupted.

### 3. Create the niche repo directory

```bash
mkdir -p "/Users/laurenwilliams/Desktop/repos/niche-sites/$PRODUCT_NAME_PASCAL/public/brand"
```

Where `$PRODUCT_NAME_PASCAL` is the product name with spaces removed (e.g. `RafterElite`, `NeedleMoved`). This matches the existing sibling-folder convention in `/repos`.

### 4. Save a `variables.json` to the new niche repo

Write `/Users/laurenwilliams/Desktop/repos/niche-sites/$PRODUCT_NAME_PASCAL/variables.json` containing every variable collected in step 0 plus the shared defaults from `~/.claude/env.local` (LEAD_WEBHOOK, NEWSLETTER_WEBHOOK, CHATBOT_WIDGET_ID, etc.). `/niche-build` will read this file next phase — do not require the user to re-type variables.

### 5. Fill the deep-research prompt

Read `_website-template/prompts/deep-research-prompt.md`. Substitute `[NICHE]`, `[NICHE_PLURAL]`, `[WEBSITE_NAME]` (= `PRODUCT_NAME`), `[WEBSITE_URL]` (= `https://$DOMAIN`). Save the filled prompt to `/Users/laurenwilliams/Desktop/repos/niche-sites/$PRODUCT_NAME_PASCAL/research-brief.md`.

### 6. ⏸ HUMAN CHECKPOINT — confirm variables before research

Display a summary of the locked variables and the path to `research-brief.md`. Wait for the user to say "continue" (or similar). Do not spawn the research agent until confirmed — research runs are expensive and re-doing them for a wrong variable wastes a lot.

### 7. Run the research subagent

Spawn a general-purpose Agent with this prompt (inlined, self-contained):

> Use `WebSearch` and `WebFetch` extensively to conduct deep research on the `[NICHE]` industry. Your goal: produce a complete, publish-ready markdown file matching the structure in `/Users/laurenwilliams/Desktop/repos/niche-sites/$PRODUCT_NAME_PASCAL/research-brief.md`. Read that file in full first — it is your authoritative prompt. Do multiple rounds of search covering: (a) biggest pain points in `[NICHE]` businesses, (b) language/terminology used by practitioners on Reddit/forums/industry blogs, (c) top competitor CRM/marketing tools already used in this niche and their gaps, (d) common objections to switching software, (e) high-value SEO keywords. Then write all 7 pages (Overview, Features, Use Cases, Resources, Pricing, About, Contact) in full per the deliverable spec in the brief. Do NOT truncate. Do NOT include free-trial language. Do NOT invent statistics or company names. Testimonial stand-ins use first name + last initial + city only. Write the final markdown to `/Users/laurenwilliams/Desktop/repos/niche-sites/$PRODUCT_NAME_PASCAL/content.md` — single file, complete. Return a 5-line summary only (the file is the deliverable).

Run in foreground (you need the result to continue). Budget ~8–15 minutes of agent time.

### 8. ⏸ HUMAN CHECKPOINT — review `content.md`

After the research agent finishes, print:
- Word count of `content.md`
- Section headings extracted from the file (so user can scan completeness)
- Any flags from a quick sanity scan: "free trial" mentions, fake stats like `\d+%`, specific company names that look fabricated

Tell the user to open `content.md`, review, and either approve or ask for revisions. Do not proceed to `/niche-build` on their behalf — `/niche-build` is a separate user invocation.

### 9. End-of-turn summary

Two sentences only. What was reserved, what file was produced, next step is `/niche-build`.

## Invariants

- Never create the niche repo directory under any name other than PascalCase product name (matches `/repos/niche-sites/NeedleMoved`, `/repos/niche-sites/RafterElite` siblings)
- Never skip REGISTRY reservation — even if the user is impatient
- Never spawn the research agent before the HITL confirmation at step 6
- The filled research-brief.md stays in the repo permanently (for traceability)
- `content.md` is written by the subagent, not by this skill directly — never fill it in yourself

## What this skill does NOT do

- It does not build pages, copy template files, or touch `/public/brand/`. That is `/niche-build`.
- It does not push to GitHub or call Coolify. That is `/niche-launch`.
- It does not generate logos. User supplies the master logo + square master image before `/niche-build`.
