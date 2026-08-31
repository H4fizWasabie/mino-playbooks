# Weekly Cost — Sunday spend + output report

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change one stage | that stage's `stages/NN-name/CONTEXT.md` — the contract IS the behavior | other stages' internals |
| Tune report voice | `persona/CONTEXT.md` → this workspace's own `persona/reality-checker.md` | stage internals |
| Read a past report | newest `runs/<run-id>/stages/02-synthesize/output/weekly-cost.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A written skip log on a non-Sunday is a SUCCESS. A report with zero-cost weeks shown honestly is a SUCCESS. The only true failure is ending without the declared output. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (usage_log in state.db unreadable → mechanical exits 1 loudly; missing cost_usd → fallback prices per contract; schedules.json missing → treat as no issues).
2. **Adapt** within the contract's bounds — compute costs from state.db usage_log with fixed per-model prices, never estimate from memory; report what the data shows.
3. **Escalate** to the owner with the report itself — that IS the deliverable; never a bare failure report without it.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

- `01-mechanical` → `02-synthesize`: via `../01-mechanical/output/raw-cost.md` (spend table, post counts, issues).
- `02-synthesize` composes and sends EXACTLY ONE Telegram message to the owner and writes the final report. It is the only stage that sends messages.
