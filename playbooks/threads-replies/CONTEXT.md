# Threads Replies — engage the good fires, quarantine the spam

Engage with replies on recent Threads battle and community posts — answer the good fires, quarantine spam, never reply twice. The shared quarantine digest is a mandatory declared output of every run.

## Folder Map

```
threads-replies/
├── CONTEXT.md            (you are here — navigation hub)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-engage/     (the contract: fetch replies → quarantine → classify → dedup-gate → reply → digest)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change behavior | `stages/01-engage/CONTEXT.md` — the contract IS the behavior | `runs/` contents, `/home/mino/.mino/data/threads-replies/raw.md` |
| Tune engagement voice | `persona/CONTEXT.md` → canonical persona in the agency roster (`/home/mino/.mino/agents/community-builder.md`) | stage internals |
| Check what was replied on a given day | `runs/<run-id>/stages/01-engage/output/` + the quarantine digest `/home/mino/.mino/data/threads-replies/digest.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A run with zero replies and a written digest is a SUCCESS. The only true failure is ending without the digest written to its exact declared path. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (`threads_get_replies` empty → still overwrite the digest with a fresh header; fetch spill → small limits + one-pass bash pre-filter, never page chunk-by-chunk).
2. **Adapt** within the contract's bounds — the hard exact-ID dedup gate is never bypassed; a failed publication means remove that reserved ledger line and move on, never retry the same candidate.
3. **Escalate** to the owner only what genuinely blocked the run, with evidence and the recovery already attempted — never a bare failure report. The Telegram report is never dropped.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-engage/` owns the full loop — it reads the latest battle + community logs for post IDs, fetches and quarantines replies under `/home/mino/.mino/data/threads-replies/`, and is the only stage that posts replies or sends messages.
