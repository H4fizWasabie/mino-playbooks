# Weekly Audit — Sunday judgment meat-grinder

The judgment meat-grinder. Reads all 7 days of post logs and scores Mino's own work: repeated angles, stale jokes, rubber-stamped image critiques, failed runs. Output is ADVICE — never self-modification of contracts or memory. Day-gated: runs only on Sunday (authoritative local date); on other days write the skip log and end without Telegram.

## Folder Map

```
weekly-audit/
├── CONTEXT.md            (you are here — navigation hub)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-audit/      (the contract: day gate → sample logs → score 4 dimensions → Telegram)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change behavior | `stages/01-audit/CONTEXT.md` — the contract IS the behavior | `runs/` contents (other playbooks' logs are inputs, read in-stage) |
| Tune judgment stance | `persona/CONTEXT.md` → canonical persona in the agency roster (`/home/mino/.mino/agents/reality-checker.md`) | stage internals |
| Read a past audit | newest `runs/<run-id>/stages/01-audit/output/weekly-audit.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A written skip log on a non-Sunday is a SUCCESS, and an audit built on fewer samples than usual is still a SUCCESS if the sampling truth is recorded. The only true failure is ending without the declared output. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error; known failure modes have declared exits (read budget spent → score from what was read; test-traffic contamination → exclude per contract, never count it as findings).
2. **Adapt** within the contract's bounds — judge patterns, never people; never edit any contract, playbook, or memory file from inside the audit.
3. **Escalate** to the owner with the audit itself — that IS the deliverable; never a bare failure report without the audit.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

Single stage. `stages/01-audit/` owns the whole loop and declares its own inputs (the week's ALL_PLATFORMS logs, schedules.json, trace files) and outputs.
