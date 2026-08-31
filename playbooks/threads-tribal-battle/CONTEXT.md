# Threads Tribal Battle — daily @AiThreads arena post

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change daily behavior | `stages/01-provoke/CONTEXT.md` — the contract IS the behavior | `runs/` contents |
| Tune voice or provocation taste | `persona/CONTEXT.md` → this workspace's own `persona/content-creator.md` | stage internals |
| Check what was posted / why a day skipped | newest `runs/<run-id>/stages/01-provoke/output/threads-battle-log.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with a written skip-reason log is a SUCCESS. The only true failure is ending a run without the log file. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (posting tool error → retry once, then skip with reason; judgment gate fails twice → skip with reason; read spill → one-pass shaping).
2. **Adapt** within the contract's bounds — never broaden exploration, never loop to the call cap.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report. The Telegram report is never dropped.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-provoke/` owns the full daily loop and declares its own inputs (ALL_PLATFORMS exclusion glob, registered `threads_post` tool) and outputs.
