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
    └── niche-launch/SKILL.md        ← Phase 3: git init, push, Coolify deploy, DNS, registry update
```

## How the local copies stay in sync

The "live" copies are at:
- `~/Desktop/repos/niche-sites/_website-template/`
- `~/.claude/skills/niche-research/`, `niche-build/`, `niche-launch/`

This repo is currently a **manual snapshot**. When you change the template or a skill locally:

```bash
# From this repo's checkout
cp -R ~/Desktop/repos/niche-sites/_website-template ./_website-template
cp -R ~/.claude/skills/niche-research ./skills/niche-research
cp -R ~/.claude/skills/niche-build ./skills/niche-build
cp -R ~/.claude/skills/niche-launch ./skills/niche-launch
git add -A
git commit -m "Sync template + skills from local working state"
git push
```

A future enhancement would be to symlink the live locations to checkouts of this repo so changes are tracked automatically. For now, snapshot-on-significant-change is fine.

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
