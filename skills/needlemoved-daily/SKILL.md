---
name: needlemoved-daily
description: Build one day of NeedleMoved med-spa content into a dated Google Drive folder. Triggered by "Make Day N — <topic>" (or "build the NeedleMoved article for <topic>"). Writes the copy via the medspa-newsletter skill (writer → humanizer), then produces FIVE files into a new folder inside the Illumination Lab, LLC shared drive → NeedleMoved: (1) Facebook Post doc, (2) Newsletter doc with image-placement markers, (3) Image Brief doc, (4) Newsletter HTML email, (5) Article HTML web — all on-brand with the real booking link baked in. Also handles "look at the images in the folder and place them" by mapping uploaded images to their slots by aspect ratio.
version: 1.0.0
user-invocable: true
argument-hint: "[day-number] [topic]"
allowed-tools:
  - Read
  - Write
  - Bash
  - Skill
  - AskUserQuestion
  - mcp__claude_ai_Google_Drive__search_files
  - mcp__claude_ai_Google_Drive__create_file
  - mcp__claude_ai_Google_Drive__get_file_metadata
  - mcp__claude_ai_Google_Drive__read_file_content
---

# /needlemoved-daily

The repeatable daily content engine for **NeedleMoved** (Illumination Lab's med-spa brand). One
command turns a day's topic into a complete content folder in Google Drive, ready for the user to
add images and post.

**Audience of the content:** med-spa owners. **Voice/process:** the `medspa-newsletter` skill
(blended Halbert/Ogilvy/Sugarman, then the mandatory humanizer pass). This skill is the
*orchestrator* — it calls that writer, then packages the output into five files.

## Trigger

- "Make Day N — <topic>" / "build the NeedleMoved article for <topic>" / "do today's NeedleMoved content."
- **Never auto-run.** Only build when the user explicitly asks for a specific day/topic.

## Constants (shared, do not hardcode secrets here)

- **Brand palette:** teal `#00b0b8`, navy `#002445` (light teal `#4fd1d6`, dark `#007a80`).
- **Booking link (CTA):** `https://api.chiefautomationexperts.com/widget/booking/McMT8bQnMFU8gw2dk8cY`
  (also in `~/.claude/env.local` as `GHL_CALENDAR_URL`).
- **Destination:** Google Drive shared drive **Illumination Lab, LLC → NeedleMoved**, folder id
  `1UAaA2pWtmAaj6bLRvzWC3rXpiH3QXtYR`. Verify it each run (see Step 2) — don't trust a stale id.

## Preconditions (check before building)

1. **Google Drive connector is authenticated.** If Drive tools aren't available, tell the user to
   run `/mcp` → "claude.ai Google Drive" → Authenticate, then continue.
2. The `medspa-newsletter` + `humanizer` skills are installed (they ship in this same repo). If
   missing, run `bash skills/medspa-newsletter-suite/install.sh`.

## Drive connector limits (design around these)

The claude.ai Drive connector is **create-only**: it can create files/folders but **cannot edit
an existing doc, cannot delete, and cannot embed an image inside a Google Doc.** Consequences:
- Generate every file **complete on the first pass** — never leave `{{BOOKING_LINK}}` or a TODO that
  forces a re-create. Re-creating spawns duplicates the user must trash by hand.
- Doc image references are **filename-agnostic markers** ("[ HEADER IMAGE — your ~1200×600 banner ]"),
  NOT hardcoded filenames, so they never need rewriting when the user's filenames differ.
- **Recommended order to avoid all rework:** ask the user to upload the 3 images FIRST, then build —
  so real Drive image IDs go straight into the HTML. If the user prefers to build first (the usual
  flow), the HTML ships with placeholder `src` + clear comments, and the "place them" phase (Step 5)
  wires real IDs by re-creating ONLY the 2 HTML files.

## Step 1 — Write the copy (via medspa-newsletter)

Run the `medspa-newsletter` skill on the day's topic/fact (writer → humanizer, per that skill).
You need, for this one issue:
- **Article (Facebook post)** body — the long-form version.
- **Newsletter** version — 3 subject lines, preview text, body, one CTA, P.S.
- **Sources** block (kept separate, never inside the copy).
Keep the CTA pointed at the booking link above. Use only sourced stats (the user's input or
`medspa-newsletter/reference/facts.md`); never invent a stat or source.

## Step 2 — Locate + verify the NeedleMoved folder

```
search_files: title = 'NeedleMoved' and mimeType = 'application/vnd.google-apps.folder'
```
Confirm its parent is the *Illumination Lab, LLC* shared drive (not the older "Illumination Lab"
branding folder). Use that folder's id as the parent for the day folder.

## Step 3 — Create the dated day folder

Title format: **`Day N — Title`** (no date — just the day number and topic title).
```
create_file: mimeType application/vnd.google-apps.folder, parentId = <NeedleMoved id>
```

## Step 4 — Create the FIVE files in that folder

All `parentId` = the new day folder. Docs: `contentMimeType: text/plain` (auto-converts to a Google
Doc). HTML: `contentMimeType: text/html` **with `disableConversionToGoogleType: true`** so they stay
real `.html` files.

1. **`1 — Facebook Post`** (Doc) — title line + the article body + a "SOURCES (reference only)" block.
2. **`2 — Newsletter (GHL)`** (Doc) — in order: a top `[ HEADER IMAGE — insert at top, your ~1200×600
   banner ]` marker, the 3 subject options, preview text, body, CTA (real link), P.S., then an
   **IMAGE PLACEMENT SUMMARY** (which shape goes where), then the SOURCES block.
3. **`3 — Image Brief`** (Doc) — three images with exact size + placement + content direction.
   **All three are standard deliverables — the user always makes the Story too, so never label any
   image "optional."**
   - In-feed graphic **1080×1350 (4:5)** → Facebook post + Article HTML hero.
   - Header banner **1200×600 (2:1)** → newsletter header + HTML email header.
   - Stat card / Story **1080×1920 (9:16)** → FB/IG Story (too tall for the email body).
   Include the hard rules: brand colors only, NeedleMoved logo, one idea, legible on a phone, no
   fabricated screenshots, no medical/clinical claims.
4. **`4 — Newsletter (HTML email).html`** — fill `templates/newsletter-email.html`: replace
   `{{TITLE}} {{SUBJECT_1..3}} {{PREVIEW}} {{H1}} {{BODY_PARAGRAPHS}} {{CTA_TEXT}} {{BOOKING_URL}}
   {{PS}} {{HEADER_IMG_SRC}}`. `{{BODY_PARAGRAPHS}}` = the newsletter body as `<p class="p">…</p>`
   blocks (wrap key stats in `<span class="stat">`). If no image yet, set `{{HEADER_IMG_SRC}}` to
   `https://via.placeholder.com/1200x600` and leave the comment explaining the swap.
5. **`5 — Article (HTML web).html`** — fill `templates/article-web.html`: replace `{{EYEBROW}}`
   (the pillar, e.g. "Speed to Lead"), `{{H1}} {{LEAD}} {{BODY_PARAGRAPHS}} {{CTA_TEXT}}
   {{BOOKING_URL}} {{PS}} {{HERO_IMG_SRC}}`.

Read the two template files from this skill's `templates/` folder and substitute — keep the CSS
intact so brand styling is consistent.

## Step 5 — Output, then (later) place images

After building, give the user the folder link + the 5 file links, and a one-line reminder of which
3 images to make (with sizes).

**When the user later says "look at the images in the folder and place them" (or similar):**
1. `search_files: parentId = '<day folder id>'` and list the image files actually present.
2. Map each to a slot by **aspect ratio**, NOT by name (names vary wildly):
   - ~2:1 (e.g. 1200×600) → newsletter header → HTML email `{{HEADER_IMG_SRC}}`.
   - ~4:5 (e.g. 1080×1350) → Facebook post + Article HTML hero `{{HERO_IMG_SRC}}`.
   - ~9:16 (e.g. 1080×1920) → FB/IG Story (not the email body).
   Get dimensions from `get_file_metadata` (imageMediaMetadata) when available; if a file's role is
   genuinely ambiguous, **ask the user which is which — do not guess.**
3. Re-create the 2 HTML files with the real image `src`
   (`https://drive.google.com/uc?export=view&id=<FILE_ID>`). Tell the user the connector can't delete,
   so list the superseded HTML versions to trash. (The Docs don't need re-creating — their markers
   are filename-agnostic.)

## Guardrails

- Truth only — sourced stats, never invented. No medical/clinical claims. One CTA per piece.
- Always use the real booking link, never the `{{BOOKING_LINK}}` placeholder.
- Don't auto-create future days. Don't touch n8n. Don't post anywhere — this skill produces the
  Drive folder only; the user posts.

## After a successful build
The day's folder + 5 files are the deliverable. The repo (skills, templates) is backed up to GitHub
by the daily backup routine; nothing to commit per run unless the skill itself changed.
