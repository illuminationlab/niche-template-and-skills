# Agent Skills Library (vendored, external)

A curated subset of skills vendored from **[itallstartedwithaidea/agent-skills](https://github.com/itallstartedwithaidea/agent-skills)**
(MIT — see `LICENSE-upstream`). These are third-party **knowledge/reference** skills
(encoded patterns + code snippets), kept **separate from Illumination Lab's own action
skills** so they're easy to find and easy to pull out later.

- **Not auto-installed.** `install-all-skills.sh` uses an explicit allow-list and does not
  touch this folder. To activate any of these locally, symlink the specific
  `skills/agent-skills-library/<group>/<skill>` into `~/.claude/skills/`.
- **Layout:** three group folders; each skill is its own folder containing a single `SKILL.md`.
- **Selection rationale:** picked for fit with our stack — medspa niche sites, the NeedleMoved
  Next.js/Notion/Stripe pitch app, cold outreach, GHL, n8n pipelines, Notion CRM, and
  Coolify/Docker deploys. 19 of the source repo's 73 skills.

---

## google-ads-marketing/ — paid + SEO for medspa lead gen
| Skill | What it does |
|---|---|
| `landing-page-audit` | CRO + technical audit of post-click pages — pairs directly with our pitch/landing pages. |
| `google-ads-audit` | Full account audit via a 1,000-pattern knowledge base (the ads-side of our per-lead audits). |
| `keyword-research` | Systematic keyword discovery/expansion for both SEO and ad targeting. |
| `ad-copy-generation` | Responsive search ad (RSA) copy generation. |
| `conversion-tracking` | End-to-end Google Ads conversion measurement setup. |
| `competitor-analysis` | Turns auction/insights data into competitive intelligence. |
| `audience-targeting` | Full audience ecosystem targeting across the funnel. |
| `remarketing-strategy` | Cross-channel remarketing to re-engage leads (e.g. viewed-but-didn't-subscribe). |

## agent-engineering/ — building our own agents & skills
| Skill | What it does |
|---|---|
| `prompt-architecture` | Structural engineering of agent instructions (how we author SKILL.md). |
| `context-engineering` | Maximize output quality while minimizing token spend. |
| `mcp-server-creation` | Build MCP servers exposing tools/resources to agents (we consume GHL/Notion/Semrush MCPs). |
| `knowledge-base-injection` | TF-IDF/semantic pattern injection of domain expertise at the right moment. |
| `entity-memory-management` | Extract/persist/retrieve named entities across sessions. |

## dev-web-ops/ — the pitch app, sites, deploys, pipelines
| Skill | What it does |
|---|---|
| `react-best-practices` | 40+ React performance/correctness rules (needlemoved-pitch is Next.js/React). |
| `web-design-guidelines` | 100+ rules: accessibility, forms, typography, dark mode, performance. |
| `systematic-debugging` | Four-phase root-cause process (vs trial-and-error) — for deploy/build bugs. |
| `ci-cd-pipelines` | GitHub Actions CI/CD with quality gates — relevant to our Coolify deploy flow. |
| `secret-protection` | `.env` scanning, pre-commit hooks, rotation — we carry many API tokens. |
| `workflow-orchestration` | Visual flow-building with branching/parallel/error recovery (n8n-adjacent). |

---

*Vendored on 2026-07-21. To update, re-copy from the upstream repo; do not hand-edit these
files or upstream diffs get harder to reconcile.*
