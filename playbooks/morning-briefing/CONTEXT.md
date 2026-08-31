# Morning Briefing — daily 07:30 one-message brief

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change one stage | that stage's `stages/NN-name/CONTEXT.md` — the contract IS the behavior | other stages' internals |
| Tune briefing voice | `persona/CONTEXT.md` → this workspace's own `persona/chief-of-staff.md` | stage internals |
| Read a past brief | newest `runs/<run-id>/stages/02-synthesize/output/morning-brief.md` | — |
| Change what facts are gathered | `stages/01-gather/script.sh` (mechanical — edit the script, not the model) | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A brief that honestly says "source unavailable" for a missing source is a SUCCESS. The only true failure is zero messages or two messages. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (script non-zero exit → run fails loudly, fix the script; sqlite/reminder source unavailable → say so in the brief, never guess).
2. **Adapt** within the contract's bounds — facts only, from tools and files. EXACTLY ONE `send_message` per run, never re-sent on retry.
3. **Escalate** to the owner with the brief itself — that IS the deliverable; never a bare failure report without it.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

- `01-gather` → `02-synthesize`: via `../01-gather/output/facts.md` (reminders, memory state, blocked tasks, schedule, yesterday's posts).
- `02-synthesize` composes and sends EXACTLY ONE Telegram message to the owner and writes the durable brief. It is the only stage that sends messages.
