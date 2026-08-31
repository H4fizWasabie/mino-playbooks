# Daily Facebook AI Post

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change daily behavior | `stages/01-post/CONTEXT.md` — the contract IS the behavior | `runs/` contents |
| Tune voice or image taste | `persona/CONTEXT.md` → this workspace's own `persona/content-creator.md` | stage internals |
| Check what was posted / why a day skipped | newest `runs/<run-id>/stages/01-post/output/facebook-post-log.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with a written skip-reason log is a SUCCESS. The only true failure is ending a run without the log file. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (search unavailable → use newest unexcluded local source; image generation fails → publish text-only per contract; category exhausted → rotate per step 3).
2. **Adapt** within the contract's bounds — after the COMMIT step, never loop back to research; work with what you have.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report. The Telegram report is never dropped; if at the tool-call ceiling, spend the last calls on it.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-post/` owns the full daily loop — exclusion gathering, bounded research, image + caption composition, Facebook publish, durable log, Telegram report.
