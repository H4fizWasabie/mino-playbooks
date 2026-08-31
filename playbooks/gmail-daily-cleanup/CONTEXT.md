# Gmail Daily Cleanup

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change daily behavior | `stages/01-cleanup/CONTEXT.md` — the contract IS the behavior | `runs/` contents |
| Tune judgment stance | `persona/CONTEXT.md` → this workspace's own `persona/chief-of-staff.md` | stage internals |
| Check what was cleaned on a given day | newest `runs/<run-id>/stages/01-cleanup/output/` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with a written log (even "0 messages eligible") is a SUCCESS. The only true failure is ending a run without the declared output. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (Composio tool discovery fails → record and end; batch modify partial failure → record exact IDs affected; IDs not returned inline → rescan is forbidden, log and end).
2. **Adapt** within the contract's bounds — never re-scan, never loop, never exceed the 30-message cap.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-cleanup/` owns the full daily loop and declares its own inputs and outputs.
