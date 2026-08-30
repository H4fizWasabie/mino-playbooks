# Instagram Daily Capability — rotating Mino capability post

Publish a daily rotating Instagram capability post. Stage 01-judgment picks today's topic (distinct across all platforms, last 7 days); stage 02-compose generates the image, critiques it, writes the caption, and syncs the image to the public HTTPS Funnel URL; stage 03-publish posts via the Composio Instagram tool and writes the durable log. Do not publish if the image, public URL, or publishing parameters cannot be verified.

## Folder Map

```
instagram-daily-capability/
├── CONTEXT.md            (you are here — navigation hub)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/
│   ├── 01-judgment/      (pick topic, cross-platform distinct → output/topic.md)
│   ├── 02-compose/       (image gen + vision critique + caption + public URL sync)
│   └── 03-publish/       (Composio Instagram post + durable log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change one stage | that stage's `stages/NN-name/CONTEXT.md` — the contract IS the behavior | other stages' internals |
| Tune visual or caption taste | `persona/CONTEXT.md` → canonical persona in the agency roster (`/home/mino/.mino/agents/instagram-curator.md`) | stage internals |
| Check what was posted on a given day | newest `runs/<run-id>/stages/03-publish/output/` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with a written skip-reason log is a SUCCESS. The only true failure is a placeholder output or an unverified publish. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (image fails critique → regenerate ONCE with the specific fix; public URL unreachable → do not publish, log the skip; topic repeats a recent post → pick another per stage 01).
2. **Adapt** within the contract's bounds — the vision critique loop is bounded (one regeneration); never loop past declared caps.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report. The Telegram report is never dropped.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

- `01-judgment` → `02-compose`: via `../01-judgment/output/topic.md` (topic + angle).
- `02-compose` → `03-publish`: via `../02-compose/output/` (image + public URL + caption).
- `03-publish` posts via Composio and writes the durable log. It is the only stage with the external side effect.
