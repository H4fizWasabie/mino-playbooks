# Threads Workplace Drama — daily Malaysian office vignette

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change daily behavior | `stages/01-tell/CONTEXT.md` — the contract IS the behavior | `runs/` contents |
| Tune voice or storytelling taste | `persona/CONTEXT.md` → this workspace's own `persona/narrative-designer.md` | stage internals |
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
