# Post-Mortem — diagnose Mino's own failure from its own trace

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change behavior | `stages/01-diagnose/CONTEXT.md` — the contract IS the behavior | `runs/` contents, raw trace files (the harness post_mortem tool extracts them) |
| Tune diagnostic stance | `persona/CONTEXT.md` → this workspace's own `persona/reality-checker.md` | stage internals |
| Read a past post-mortem | newest `runs/<run-id>/stages/01-diagnose/output/` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A post-mortem that honestly reports "no failed runs found" or "evidence inconclusive" is a SUCCESS. The only true failure is ending without the declared ticket. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (no failed run → write the ticket saying so; harness tool returns thin evidence → render the ticket from what was returned, never re-scan with bash).
2. **Adapt** within the contract's bounds — cite evidence, never reconstruct from memory.
3. **Escalate** to the owner with the ticket itself — that IS the deliverable; never a bare failure report without the ticket.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-diagnose/` owns the whole loop — the harness `post_mortem` tool extracts trace evidence; the stage renders the ticket and declares its own outputs.
