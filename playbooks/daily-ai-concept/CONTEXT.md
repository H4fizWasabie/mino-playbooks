# Daily AI-Concept Learning

Learn one agentic-AI concept daily and store it in the rotating 40-slot Mino library (curated, Mino-grounded, verified), with a one-line Telegram report.

## Folder Map

```
daily-ai-concept/
├── CONTEXT.md            (you are here — navigation hub)
├── config.md             (runner: description, status, agent, notify)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-learn-and-store/  (the contract: research → verify → store → report)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change daily behavior | `stages/01-learn-and-store/CONTEXT.md` — the contract IS the behavior | `runs/` contents |
| Tune research stance or voice | `persona/CONTEXT.md` → canonical persona in the agency roster (`/home/mino/.mino/agents/trend-researcher.md`) | stage internals |
| Check what was learned on a given day | newest `runs/<run-id>/stages/01-learn-and-store/output/` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with a written skip-reason log is a SUCCESS. The only true failure is ending a run without the declared output. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section (`stages/01-learn-and-store/CONTEXT.md`) and the actual error; most failures have a declared exit already (search unavailable → fall back per contract; verification fails → store nothing rather than a guessed fact).
2. **Adapt** within the contract's bounds — never broaden exploration, never loop to the call cap.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-learn-and-store/` owns the full daily loop — research, verification, library storage, and the one-line Telegram report — and declares its own inputs and outputs.
