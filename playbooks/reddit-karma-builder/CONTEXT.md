# Reddit Karma Builder — organic u/your-handle engagement

Daily Reddit karma builder for u/your-handle. Uses Composio Reddit tools (account alias: `owner-account`) to find trending posts in AI/tech and developer/builder subreddits and post genuinely helpful comments. Goal: organic karma growth following each subreddit's rules. Runs daily at 10:00 +08:00.

## Folder Map

```
reddit-karma-builder/
├── CONTEXT.md              (you are here — navigation hub)
├── config.md               (runner: description, status, agent)
├── persona/                (persona pointer → agency roster; see Routing)
├── stages/
│   ├── 01-discover-posts/  (self-bounding discovery: trending posts → output)
│   └── 02-comment-and-log/ (draft + post comments → output/karma-log.md)
├── tools/link-check.sh     (routing health: links + orphans)
└── runs/                   (Mino-owned run state — never hand-edit state.json)
```

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change one stage | that stage's `stages/NN-name/CONTEXT.md` — the contract IS the behavior | other stages' internals |
| Tune engagement voice | `persona/CONTEXT.md` → canonical persona in the agency roster (`/home/mino/.mino/agents/community-builder.md`) | stage internals |
| Check what was commented on a given day | newest `runs/<run-id>/stages/02-comment-and-log/output/karma-log.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with a written log (even "no suitable posts found") is a SUCCESS. The only true failure is ending a run without the declared output. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (Reddit API failure → do not retry, record the error; missing dedup ledger → treat as empty and create it; no fresh posts → log and end).
2. **Adapt** within the contract's bounds — max comment caps are hard; never broaden subreddits or re-search past the declared bounds.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

- `01-discover-posts` → `02-comment-and-log`: via declared stage outputs (selected posts with URLs + scores).
- `02-comment-and-log` posts the comments (Composio Reddit) and writes the durable log. It is the only stage with external side effects.
- Both stages respect the dedup ledger `/home/mino/.mino/data/reddit-karma/commented-posts.md` (runtime data, created on first use).
