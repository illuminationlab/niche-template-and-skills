# Onboarding / Kickoff Note — paste this as your FIRST message to Claude Code on the DO droplet

---

We're moving our workstation **from Claude Code on my Mac to Claude Code here on this DigitalOcean droplet.** You are the continuation of that same operation — nothing has changed except the machine. Before we do anything, get yourself oriented from this brief so I don't have to repeat things. Then confirm you've run `/time-machine-set-up` (or tell me what's missing).

## First actions
1. Read `~/niche-template-and-skills/niche-buildout/DO-DROPLET-SETUP.md` and confirm setup is complete (skills installed, `env.local` present, repos cloned, OpenSEO MCP connected).
2. Read your memory: `~/.claude/…/memory/MEMORY.md` and especially **`niche-build-preflight.md`** (the hardened build checklist). If memory files aren't here yet, this brief covers the essentials.
3. **Paths on THIS machine are different from the Mac.** Everything is under `~` (not `/Users/tyfriese`): template/skills `~/niche-template-and-skills`, niche repos `~/repos/niche-sites/<Name>`, secrets `~/.claude/env.local`. Any skill text that says `/Users/laurenwilliams/…` or `/Users/tyfriese/…` → translate to these paths.

## Who I am / what we do
Illumination Lab — we build and run **multi-niche marketing SaaS sites**. Each site sells the same all-in-one booking / CRM / AI-receptionist platform to one trade, on the same template, brand (teal `#00b0b8` + navy, shared CAE shield), and pricing.

## The 7 live niches (as of 2026-08-04)
| Code | Prefix | Product | Niche | Domain |
|---|---|---|---|---|
| nm | medspa | NeedleMoved | med spa | needlemoved.com |
| rf | roofer | Rafter Elite | roofing | rafterelite.com (Next.js) |
| eg | engine | EngineGuild | small engine repair | engineguild.com |
| cc | pest | Call and Crawl | pest control | callandcrawl.com |
| wb | electrician | WattsBooked | electrical | wattsbooked.com |
| ft | golf | FullTeeSheet | golf course | fullteesheet.com |
| lb | limo | LimoBooked | limousine | limobooked.com (launched 2026-08-03) |

Registry of record: `~/niche-template-and-skills/_website-template/REGISTRY.md`.

## The build pipeline
`name + buy domain` → **/niche-research** → approve `content.md` → **/niche-build** (needs master logo + square shield in the repo) → eyeball DoD → **/niche-launch** (git + GitHub `illuminationlab` org + Coolify + DNS + registry Live) → **/seo-optimizer**. Full prompt cookbook: `niche-buildout/BUILD-PROMPTS.md` (if present).

## Locked conventions — do not relitigate
- **Pricing (every site):** ONE plan — **$99/mo forever, first 270 customers, + pay-to-use** usage billing. No tiers. ONE shared Stripe link `https://buy.stripe.com/fZudR96yq9Y37COaL68Ra0c`. Announcement bar + header CTA use the "First 270: $99/mo Forever" language. WattsBooked's pricing.html is the reference layout.
- **Contact form:** standardized fields `name, company, email, phone, intent, message` (company key — NOT business_name; that caused `[undefined]` emails). Ship all 3 lead forms (contact / playbook / revenue-calculator).
- **Contact email everywhere = `clients@illuminationlab.io`** (the monitored inbox). Never `info@<domain>` — those bounce.
- **FAQPage JSON-LD** on every page with an FAQ accordion (SEO/AEO); template + skill now auto-generate it; DoD check (a15) enforces it.
- **form_location** values are prefixed per niche (`<prefix>-contact`, etc.) for the shared n8n switch.

## Infra + credentials (values live in `~/.claude/env.local`)
- **Hosting:** Coolify at `coolify.illuminationlab.io` on the **production** droplet `167.71.191.14` (this workstation droplet is separate). Manage via the Coolify API + `_website-template/scripts/coolify.sh`. ⚠️ Coolify auto-deploy is unreliable — every push needs a **manual redeploy** (coolify_deploy). Verify by comparing LIVE content, not the git-push heuristic.
- **DNS:** Namecheap (manual); A-records → `167.71.191.14`. Delete Namecheap's default parking CNAME (www) + URL-redirect (@) or they hijack the domain. LE cert issues after DNS resolves.
- **GitHub:** org `illuminationlab`; repos public (secrets gitignored).
- **n8n:** `LEAD_WEBHOOK` (switch routes by `form_location`) + separate `NEWSLETTER_WEBHOOK`. POST JSON as `Content-Type: text/plain;charset=UTF-8`. n8n changes are manual (no API).
- **GHL:** shared location `JgvEGzdf6TtIjKoC15X9`; booking widget `McMT8bQnMFU8gw2dk8cY`; chatbot widget `685d4d4f63b8b7fec750e753`.
- **OpenSEO** MCP for keyword/SERP/rank data (project "Default" `b992bcdb-de83-439d-a07b-b4ec459231f4`, US/en). Watch the credit balance (was ~160). No domain set on the project yet.

## Sandbox note
Any call to the Coolify host (`coolify.illuminationlab.io`) or direct-IP `--resolve` checks need the sandbox disabled (`dangerouslyDisableSandbox: true`). `coolify.sh` was fixed to use `/usr/bin/curl`.

## Current state (all done, verified live)
Hardened the template + skills; standardized all 7 sites to the single-plan pricing; **launched LimoBooked** (#7); backported FAQPage schema + logo alt to every niche; repointed all bouncing `info@<domain>` emails → `clients@illuminationlab.io`. Everything committed, pushed, redeployed, verified. All 7 sites return 200 with valid certs.

## Pending / open (mostly manual — mine to do, not yours)
1. **Cronjob → Codex** (pinned) — plan at `niche-buildout/PLAN-hermes-cronjob-codex.md`.
2. **Delete the `limo-contact` test lead** ("Test Testing / LAUNCH TEST") from n8n/GHL.
3. **Directory submissions** for LimoBooked — kit at `niche-buildout/LimoBooked-directory-listing-kit.md` (Capterra/G2/GetApp/Software Advice/GBP/NLA).
4. **OpenSEO rank tracking** — not set up yet; per-domain projects + money keywords (proposals discussed, LimoBooked + WattsBooked verified).
5. Optional: replicate LimoBooked's SEO play (FAQ + comparison guides + positioning) on the other 6 niches; rebuild `NICHE-BUILD-PLAYBOOK.md`.

## How I like to work
Act when you have enough info; give recommendations not surveys. Confirm before outward-facing/irreversible actions (pushes to prod, deploys). No fabricated stats on the sites — authentic, sourced, or qualitative only. Use subagents to fan out heterogeneous/parallel work. Report outcomes plainly (if something failed, say so with the output).

---

Once you've read this and confirmed setup, just say you're caught up and ready, and we'll pick up from the pending list — likely starting with OpenSEO rank tracking or replicating the SEO play across the other niches.
