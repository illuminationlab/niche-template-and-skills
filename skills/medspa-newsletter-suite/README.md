# Med-Spa Newsletter Suite

A **paired** Claude Code skill bundle for Illumination Lab. Two skills that always run
back-to-back:

1. **`medspa-newsletter`** — the writer. Turns a topic / fact / batch of facts into finished
   med-spa newsletter issues (agency → med-spa-owner audience) in a blended
   Halbert / Ogilvy / Sugarman direct-response voice.
2. **`humanizer`** — the editor. Strips AI writing tells (based on Wikipedia's "Signs of AI
   writing"). Original skill by @blader (https://github.com/blader/humanizer).

## The hard rule: writer → humanizer → output
The writer's draft is **never** the final product. As Step 4 of its process, `medspa-newsletter`
**always** invokes `humanizer` with a copy-aware directive (strip AI tells, preserve the P.S.,
the single bold CTA, the rhythm, and a deliberate em-dash or two). They run one after the other,
every time, in that order.

## Always-latest: sync before each use
Step 0 of the writer runs `medspa-newsletter/sync.sh`, which git-pulls this repo and reinstalls
**both** skills from the newest commit — so if a partner updates the suite, every machine picks
it up automatically the next time the skill is used.

## Install (first time, on a new machine)
```bash
# clone the backup repo, then run the suite's sync script — it installs both skills
gh repo clone illuminationlab/niche-template-and-skills /tmp/ntas
bash /tmp/ntas/skills/medspa-newsletter-suite/medspa-newsletter/sync.sh
```
Or run `install.sh` in this folder. Both skills land in `~/.claude/skills/`:
`~/.claude/skills/medspa-newsletter/` and `~/.claude/skills/humanizer/`.

## Editing the suite
Edit the files in this bundle, commit, and push to `main`. Every teammate's next use of the
skill pulls the change automatically (via Step 0 sync). Do not hand-edit the installed copies
in `~/.claude/skills/` — they get overwritten on each sync.

## Usage
In Claude Code: "write a newsletter on <topic>", "turn these facts into newsletters", or
`/medspa-newsletter`. Output: 3 subject lines + preview + ~150–220-word body + CTA + P.S.,
with sources listed **separately** (never inside the newsletter copy) for you to approve.
