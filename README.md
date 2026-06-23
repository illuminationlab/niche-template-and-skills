# niche-template-and-skills

**The institutional IP behind Illumination Lab's niche-site factory.**

This repo is the source-of-truth backup for two things:

1. **`_website-template/`** — the master HTML/CSS/JS template every new niche site is cloned from.
2. **`skills/`** — the three Claude Code skills that automate the niche-launch flow.

## Why this repo exists

Previously these lived only on Ryan's laptop. Losing the laptop would mean rebuilding the whole niche-site factory from scratch — months of accumulated playbook knowledge gone. This repo is the off-machine backup.

## Repo layout

```
niche-template-and-skills/
├── _website-template/              ← the master template (vanilla HTML/CSS/JS, nixpacks-deployable)
│   ├── index.html, about.html, ...  ← every page the template ships with
│   ├── css/styles.css              ← shared CSS (includes dropdown z-index fix, etc.)
│   ├── js/main.js                  ← shared form-submit + animation logic
│   ├── public/brand/                ← favicons, og images, etc.
│   ├── resources/                   ← /resources/index.html (newsletter form lives here)
│   ├── prompts/                     ← prompts used by the niche-research skill
│   ├── scripts/                     ← audit-across-niches.sh, etc.
│   ├── REGISTRY.md                  ← every Live niche tracked here; cross-niche audit reads from this
│   └── README.md                    ← template's own quick-reference
│
└── skills/                          ← Claude Code skills (Claude reads SKILL.md to know what to do)
    ├── niche-research/SKILL.md      ← Phase 1: research the niche, produce content.md
    ├── niche-build/SKILL.md         ← Phase 2: scaffold from _website-template, inject variables
    ├── niche-launch/SKILL.md        ← Phase 3: git init, push, Coolify deploy, DNS, registry update
    ├── medspa-newsletter-suite/     ← med-spa newsletter writer + humanizer (paired; self-syncing)
    ├── needlemoved-daily/           ← "Make Day N — <topic>": builds the 5-file NeedleMoved content folder in Drive
    └── time-machine-set-up/         ← new-machine disaster recovery + continuous backup + routines
```

## How the local copies stay in sync

Setup + sync is now automated by the **`time-machine-set-up`** skill (no more manual snapshotting):

- `niche-research`, `niche-build`, `niche-launch`, `needlemoved-daily`, and `time-machine-set-up`
  are **symlinked** from `~/.claude/skills/` into this repo checkout — so editing the live skill IS
  editing the repo working tree (no copy step, no drift).
- `medspa-newsletter` + `humanizer` are copy-based and **self-sync** from `origin/main` on each use
  (via the suite's `sync.sh`).
- A **daily backup routine** (`skills/time-machine-set-up/backup-sync.sh`, run by a LaunchAgent)
  commits + pushes this repo automatically, so changes land on GitHub without anyone remembering.

**New machine / fresh terminal:** run the `time-machine-set-up` skill — it installs `gh`, sets the
git identity, clones this repo, symlinks every skill into `~/.claude/skills/`, recreates the routines,
and rebuilds `~/.claude/env.local`. See `skills/time-machine-set-up/SKILL.md`.

To push an immediate snapshot by hand: `bash skills/time-machine-set-up/backup-sync.sh`.

## The niche-launch flow (TL;DR)

```
/niche-research <niche-keyword>  → produces content.md + variables.json in a new niche repo
/niche-build <product-name>      → scaffolds from _website-template, injects every variable,
                                    runs Definition of Done sweep
/niche-launch <niche-code>       → creates GitHub repo, pushes initial commit, calls Coolify API
                                    to create project + app + domains + trigger deploy,
                                    prints Namecheap DNS records, updates REGISTRY.md
```

Each phase has its own `SKILL.md` with detailed steps. Start with `skills/niche-research/SKILL.md`.

## Live niches built from this template (as of last update)

See `_website-template/REGISTRY.md` for the canonical, always-current list. Quick reference:

| Code | Product | Domain | Niche |
|------|---------|--------|-------|
| nm | NeedleMoved | needlemoved.com | Med spa |
| rf | Rafter Elite | rafterelite.com | Roofing |
| eg | EngineGuild | engineguild.com | Small engine repair |
| cc | Call and Crawl | callandcrawl.com | Pest control |

## Notes

- The template's `.gitignore` (already in this repo) excludes `content.md`, `NICHE-BUILD-PLAYBOOK.md`, `variables.json`, `research-brief.md`, and master brand images. Coolify's nixpacks publishes the repo root as `/`, and these files would leak publicly otherwise.
- The skills reference `~/.claude/env.local` for Coolify API tokens, n8n webhook URLs, GHL calendar URL, etc. That file is NOT in this repo — it's per-machine secrets and lives at the user's home dir.
- This repo does NOT contain the individual niche site repos. Those live as separate GitHub repos under the `illuminationlab` org (`NeedleMoved`, `rafterelite`, `EngineGuild`, `CallAndCrawl`).
