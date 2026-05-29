---
name: niche-launch
description: Phase 3 of the niche-site launch flow. Initializes the git repo, creates the GitHub repo via gh, pushes the first commit, calls the Coolify API to create the project + static app + domains + trigger deploy, prints the Namecheap DNS records, prints the n8n switch-node + GHL drip-tag reminders, and promotes the registry row from Planned to Live. Use after /niche-build passes Definition of Done.
version: 1.0.0
user-invocable: true
argument-hint: "[product-name]"
---

# /niche-launch

Phase 3 of three: **research → build → launch**. Input: a niche repo that has passed `/niche-build`'s Definition of Done sweep. Output: a live site on Coolify at `https://<DOMAIN>` (pending DNS propagation).

Coolify API credentials + webhook URLs live in `~/.claude/env.local`. The Coolify helper lives at `_website-template/scripts/coolify.sh`.

## Preconditions (verify all before any external action)

1. Current working directory is the niche repo (or user passed `<product-name>` as arg)
2. `/niche-build` completed — `variables.json`, `NICHE-BUILD-PLAYBOOK.md` present, no `[BRACKET]` tokens remain
3. `gh auth status` shows an authenticated user
4. `~/.claude/env.local` exists and `COOLIFY_API_TOKEN` + `COOLIFY_BASE_URL` are set
5. REGISTRY row for `NICHE_CODE` is under Planned (not already Live)

If any precondition fails: stop and report which one.

## Step-by-step

### 1. Load variables

```bash
source ~/.claude/env.local
cd "/Users/laurenwilliams/Desktop/repos/niche-sites/<PRODUCT_NAME_PASCAL>"
```

Read `variables.json` for `NICHE_CODE`, `PRODUCT_NAME`, `DOMAIN`, etc.

### 2. Git init + initial commit

(Domain purchase is a prerequisite of `/niche-research`, so we do not re-check it here. If variables.json doesn't reference a domain, that's a `/niche-research` bug — stop and investigate.)

```bash
git init -b main
git add .
git commit -m "Initial site from _website-template for $PRODUCT_NAME

Built via /niche-build from _website-template@<shortsha>. Followed NICHE-BUILD-PLAYBOOK.md v4.0."
```

### 3. Create GitHub repo

Decide visibility: public by default (these are marketing sites with no secrets). Ask the user if they want private instead.

```bash
gh repo create "<PRODUCT_NAME_PASCAL>" --source=. --public --push --remote=origin
```

If the repo already exists: use `gh repo view <PRODUCT_NAME_PASCAL>` first; if owned by the user, set remote and push. If owned by someone else, stop.

### 4. Coolify — create project + app + domains + deploy

Source the helper:

```bash
source /Users/laurenwilliams/Desktop/repos/niche-sites/_website-template/scripts/coolify.sh
```

(a) Check if a project already exists for this niche. Use `coolify_list_projects | jq` and grep for a name matching `<NICHE_CODE>-site` or `<PRODUCT_NAME>`. If yes, capture its UUID; if no, create:

```bash
PROJECT_UUID=$(coolify_create_project "<NICHE_CODE>-site" "<PRODUCT_NAME> niche marketing site")
```

(b) Get the server UUID (Coolify usually has one):

```bash
SERVER_UUID=$(coolify_list_servers | jq -r '.[0].uuid')
```

(c) Create the static app pointing at the freshly pushed GitHub repo. The helper uses nixpacks' staticfile provider with nginx:alpine — its default nginx config already supports `.html` extension fallback, so `/contact` resolves to `/contact.html` automatically. **Do NOT set `custom_nginx_configuration` anywhere, ever, via API — see playbook Section 8 and Appendix D for the full gory story. If you do, the app is unrecoverable without delete+recreate.**

```bash
REPO_URL=$(gh repo view --json url -q .url)
APP_UUID=$(coolify_create_static_app \
  --project-uuid "$PROJECT_UUID" \
  --server-uuid "$SERVER_UUID" \
  --repo "$REPO_URL" \
  --branch main \
  --name "<PRODUCT_NAME_PASCAL>" \
  --domains "https://<DOMAIN>,https://www.<DOMAIN>")
```

(d) Add both www + non-www domains:

```bash
coolify_add_domain \
  --app-uuid "$APP_UUID" \
  --domains "https://<DOMAIN>,https://www.<DOMAIN>"
```

(e) Trigger the first deploy:

```bash
coolify_deploy --app-uuid "$APP_UUID"
```

If any of these calls returns an error or unexpected response, print the raw response and stop. Do NOT proceed to mark the registry Live on a partial deploy.

Save `PROJECT_UUID`, `APP_UUID`, and `SERVER_UUID` back into `variables.json` under a `coolify` key so future redeploys / updates can target them without re-looking-up.

### 5. Print the DNS records

Tell the user explicitly (copy-paste ready):

```
At Namecheap → Manage <DOMAIN> → Advanced DNS → Host Records, set:

  Type   Host   Value            TTL
  A      @      <COOLIFY_SERVER_IP>   Auto
  A      www    <COOLIFY_SERVER_IP>   Auto

Remove any other records that conflict.
```

### 6. ⏸ MANUAL n8n STEP — add 3 switch branches (~2 min per niche)

The shared LEAD_WEBHOOK n8n workflow has a Switch node that branches on the exact value of `{{ $json.form_location }}`. Every niche site POSTs prefixed values, so the user must add 3 new branches for this niche.

Print this block for the user verbatim, substituting `<DRIP_TAG_PREFIX>` with the actual value from variables.json:

```
⏸ MANUAL n8n STEP — open the LEAD_WEBHOOK workflow switch node and add 3 branches:

     {{ $json.form_location }}  equals  <DRIP_TAG_PREFIX>-contact
     {{ $json.form_location }}  equals  <DRIP_TAG_PREFIX>-revenue-calculator
     {{ $json.form_location }}  equals  <DRIP_TAG_PREFIX>-playbook-download

Name each branch the same as the comparison value. Wire each to the same
downstream GHL nodes used by the existing niches' equivalent branches.

Newsletter (<DRIP_TAG_PREFIX>-newsletter) goes to a separate NEWSLETTER_WEBHOOK
workflow — nothing to add in this switch for newsletter.

Once the 3 branches are saved in n8n, say "continue" and I'll verify with a
test submission against one of the forms.
```

Then WAIT for the user to confirm. Do not print step 7/8/etc. until they say "continue" — this is a blocking HITL step. n8n changes aren't automated (no n8n MCP, no API key wired up).

After confirmation, optionally run a test POST against the niche's contact form webhook to verify n8n logs show the new branch firing:

```bash
curl -sS -X POST "$LEAD_WEBHOOK" \
  -H "Content-Type: text/plain;charset=UTF-8" \
  --data "{\"form_location\":\"${DRIP_TAG_PREFIX}-contact\",\"source_site\":\"${NICHE_CODE}\",\"first_name\":\"Launch\",\"last_name\":\"Test\",\"email\":\"info@illuminationlab.io\",\"business_name\":\"Launch Test Shop\",\"intent\":\"other\",\"submitted_at\":\"$(date -u +%FT%TZ)\"}"
```

(The test contact will show up in the n8n execution log tagged to the new branch — confirms wiring.)

### 7. Print the GHL drip-tag reminder

The shared n8n workflow auto-creates tags of the form `<DRIP_TAG_PREFIX>-<form_location>` — these fire into the SHARED GHL drip workflows which are niche-agnostic. For a standard build, no per-niche GHL setup is required.

Print for the user as a confirmation (not an action item):

```
DRIP_TAG_PREFIX reserved: <DRIP_TAG_PREFIX>

Tags that will auto-fire from this site:
  <DRIP_TAG_PREFIX>-contact       (from contact form)
  <DRIP_TAG_PREFIX>-newsletter    (from any newsletter signup)
  <DRIP_TAG_PREFIX>-calculator    (from revenue calculator lead form)
  <DRIP_TAG_PREFIX>-playbook      (from playbook download)

The shared GHL workflows will receive these contacts automatically. No new GHL
workflow or tag creation is required unless you want a custom per-niche drip
sequence on top of the shared base.
```

### 8. Probe for meta-file leakage (automatic — no human required)

Before handing off to the human checkpoint, run:

```bash
for path in content.md research-brief.md variables.json NICHE-BUILD-PLAYBOOK.md master-logo.svg master-square.png; do
  code=$(curl -sSIk -o /dev/null -w "%{http_code}" "https://<DOMAIN>/$path")
  echo "$code  /$path"
done
```

Every line must show `404`. If any show `200`, the niche repo's `.gitignore` didn't exclude that file before the first commit — the file is now public. Recovery: `git rm --cached <file>`, commit, push, trigger a redeploy.

### 9. ⏸ HUMAN CHECKPOINT — verify site loads

Ask the user to open `https://<DOMAIN>` in an **incognito window** once DNS has propagated (usually 5–30 min at Namecheap, up to 24h worst-case). Checklist:

- [ ] `https://<DOMAIN>` loads without cert errors
- [ ] `https://www.<DOMAIN>` loads and serves same content
- [ ] Favicon renders in the tab
- [ ] Contact form submits (test with your own email — check n8n execution log)
- [ ] Chatbot widget loads
- [ ] `book-demo.html` shows the GHL calendar

If any fails: diagnose using playbook Appendix D (Common Bug Reference).

### 10. Promote REGISTRY row from Planned → Live AND extend the Playwright fixture

Only after the user confirms the site loads.

**(a) Edit `_website-template/REGISTRY.md`:**
- Move the row from **Planned / reserved** to **Live niches**
- Fill in `Launched` column with today's date (YYYY-MM-DD)
- Fill in `Repo` column with `repos/niche-sites/<PRODUCT_NAME_PASCAL>`
- Fill in `Accent color` column with the locked hex

**(b) Append a row to `playwright-tests/fixtures/niches.json`** so every shared E2E test instantly extends to the new niche. Use Python (jq is fragile with our nested structure):

```bash
python3 <<EOF
import json, pathlib

fixture_path = pathlib.Path('/Users/laurenwilliams/Desktop/repos/playwright-tests/fixtures/niches.json')
vars_path = pathlib.Path('/Users/laurenwilliams/Desktop/repos/niche-sites/<PRODUCT_NAME_PASCAL>/variables.json')

niches = json.loads(fixture_path.read_text())
v = json.loads(vars_path.read_text())

# Skip if already present
if any(n['code'] == v['niche_code'] for n in niches):
    print(f"{v['niche_code']} already in fixtures — skipping")
else:
    new_entry = {
        'code': v['niche_code'],
        'drip_prefix': v['drip_tag_prefix'],
        'form_location_contact': f"{v['drip_tag_prefix']}-contact",
        'product_name': v['product_name'],
        'niche_keyword': v['niche'],
        'domain': v['domain'],
        'book_path': '/book-demo',
        'stack': 'vanilla',
        'accent_color_hex': v['accent_color'],
        'has_site_config': True,
        'has_legal_pages': True,
        'webhook_in_static_html': True,
        'notes': f"Built under v4.1 conventions. Launched {v.get('launched_at', 'recently')}."
    }
    niches.append(new_entry)
    fixture_path.write_text(json.dumps(niches, indent=2) + '\n')
    print(f"Added {v['niche_code']} ({v['product_name']}) to playwright-tests/fixtures/niches.json")
EOF
```

**(c) Smoke-run the Playwright suite against the new niche** to confirm the launch is fully landed:

```bash
cd /Users/laurenwilliams/Desktop/repos/playwright-tests
npm run test:niche -- '<NICHE_DRIP_PREFIX>'
```

Expected: every shared test passes against the new domain. If any fail, the launch isn't done yet — debug before declaring the niche Live.

**(d) Commit the fixture change** (the playwright-tests repo is git-tracked):

```bash
cd /Users/laurenwilliams/Desktop/repos/playwright-tests
git add fixtures/niches.json
git commit -m "Extend test fixture for <PRODUCT_NAME> launch"
git push 2>/dev/null || true   # only if user has set up a remote
```

REGISTRY.md sits in `_website-template/` which may or may not be git-tracked — save the edit either way.

### 11. End-of-turn summary

Three sentences max: site URL, Coolify project/app UUIDs recorded in variables.json, what the user still needs to do manually (n8n switch branch + GHL drip tags).

## Cross-niche audit rule (post-launch fix protocol)

Any fix applied to a single niche site after launch must be audited across every other live niche. The helper script runs the audit in one command:

```bash
bash /Users/laurenwilliams/Desktop/repos/niche-sites/_website-template/scripts/audit-across-niches.sh '<grep_pattern>' '<glob>'
```

If matches are found in any other niche, fix and redeploy each affected niche AND the template in the same session. See playbook Section 11 for the full rule.

## Invariants

- Never promote REGISTRY → Live before the user confirms the site loads
- Never force-push, `reset --hard`, or destroy a remote repo if the naming collides — stop and ask
- Never commit `~/.claude/env.local` or `variables.json` secrets to the niche repo's public GitHub
- All Coolify API errors are surfaced raw to the user — do not swallow them

## What this skill does NOT do

- It does not buy the domain (Namecheap is manual)
- It does not set DNS records (Namecheap API is out of scope — user clicks)
- It does not update the n8n workflow (n8n API automation is Phase 2)
- It does not create GHL drip tags or workflows (GHL API automation is Phase 2)
- It does not generate Google Drive folders or upload assets (user handles manually)
