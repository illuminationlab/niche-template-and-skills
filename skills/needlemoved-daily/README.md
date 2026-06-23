# needlemoved-daily

The daily content engine for **NeedleMoved** (Illumination Lab's med-spa brand). One command builds
a full day of content into a dated Google Drive folder so anyone on the team can run the exact same
process after a `git pull`.

## What it does

Trigger: **"Make Day N — <topic>"**

1. Writes the copy via the `medspa-newsletter` skill (writer → humanizer).
2. Creates a folder `Day N — Title` in the *Illumination Lab, LLC* shared drive →
   **NeedleMoved**.
3. Drops in **5 files**, complete and on-brand (real booking link baked in):
   1. `1 — Facebook Post` (Doc)
   2. `2 — Newsletter (GHL)` (Doc, with image-placement markers)
   3. `3 — Image Brief` (Doc — sizes + placement)
   4. `4 — Newsletter (HTML email).html`
   5. `5 — Article (HTML web).html`
4. Later, on **"look at the images in the folder and place them,"** maps the user's uploaded images
   to their slots **by aspect ratio** and wires real image URLs into the HTML.

## Requirements

- **Google Drive connector** authenticated (`/mcp` → claude.ai Google Drive → Authenticate).
- The `medspa-newsletter` + `humanizer` skills installed (same repo: `bash
  skills/medspa-newsletter-suite/install.sh`).

## Good to know

- The Drive connector is **create-only** (no edit / delete / in-doc images). The skill is built to
  produce each file complete on the first pass so there's no cleanup. Fastest path with zero rework:
  **upload the 3 images first, then build.**
- Brand: teal `#00b0b8` / navy `#002445`. Booking link is stored as `GHL_CALENDAR_URL` in
  `~/.claude/env.local`.
- `templates/` holds the email + web-article HTML the skill fills in — edit those to restyle every
  future day at once.

## Files

- `SKILL.md` — the full process Claude follows.
- `templates/newsletter-email.html` — email-safe HTML newsletter template.
- `templates/article-web.html` — styled web-article template.
