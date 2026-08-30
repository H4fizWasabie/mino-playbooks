# Threads Workplace Drama — daily Malaysian office vignette

Publish one short workplace-drama story daily at 17:30. Not tribal, not AI — a 200-400 character vignette every Malaysian worker recognizes: toxic bosses, toxic managers, toxic work friends, workplace quirks, irresponsible moments. Ends with a comment bait. Story family rotates by day-of-year; the used-stories ledger guarantees no story repeats, ever.

## Folder Map

```
threads-workplace-drama/
├── CONTEXT.md            (you are here — navigation hub)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-tell/       (the contract: rotate family → tell → gate → publish → ledger → log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change daily behavior | `stages/01-tell/CONTEXT.md` — the contract IS the behavior | `runs/` contents |
| Tune voice or storytelling taste | `persona/CONTEXT.md` → canonical persona in the agency roster (`/home/mino/.mino/agents/narrative-designer.md`) | stage internals |
| Check what was posted / why a day skipped | newest `runs/<run-id>/stages/01-tell/output/threads-drama-log.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with a written skip-reason log plus the ledger append is a SUCCESS. The only true failure is ending a run without the declared outputs. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (missing ledger → treat as empty and create it; posting tool error → retry once, then skip with reason; judgment gate fails twice → ledger + log note, no post).
2. **Adapt** within the contract's bounds — composite dramatizations only, never real people or companies.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report. The Telegram report is never dropped.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-tell/` owns the full daily loop and declares its own inputs (used-stories ledger — quarantined output, ALL_PLATFORMS exclusion glob, `threads_post`) and outputs.
