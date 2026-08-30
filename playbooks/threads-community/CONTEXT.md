# Threads Community Post — @AiThreads daily

Autonomous playbook: one safe-reach Threads post daily at 11:00 tagged into the @AiThreads community (1M members). Even days = fresh funny observation about Malaysian dev life; odd days = trending GitHub repo spotlight. Never the same joke, repo, or idea twice.

## Folder Map

```
threads-community/
├── CONTEXT.md            (you are here — navigation hub)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-post/       (the contract: select → compose → gate → publish → log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change daily behavior | `stages/01-post/CONTEXT.md` — the contract IS the behavior | `runs/` contents |
| Tune voice or tone | `persona/CONTEXT.md` → canonical persona in the agency roster (`/home/mino/.mino/agents/content-creator.md`) | stage internals |
| Check what was posted / why a day skipped | newest `runs/<run-id>/stages/01-post/output/threads-community-log.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with a written skip-reason log is a SUCCESS. The only true failure is ending a run without the log file. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section (`stages/01-post/CONTEXT.md`) and the actual error; most failures have a declared exit already (missing dedup ledger → create it; judgment gate fails twice → skip with reason; posting tool errors → retry once, then skip with reason).
2. **Adapt** within the contract's bounds — never broaden exploration, never loop to the call cap.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-post/` owns the full daily loop and declares its own inputs (ALL_PLATFORMS exclusion glob, global gates under `../shared/`, repo dedup ledger) and outputs (run-relative `output/`).
