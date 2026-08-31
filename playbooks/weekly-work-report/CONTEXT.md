# Weekly Work Report — workspace navigation

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|---|---|---|
| Understand a stage's behavior | that stage's `stages/NN-*/CONTEXT.md` | other stages' contracts |
| Tune voice / persona | `persona/CONTEXT.md` → edit `persona/procurement-officer.md` directly | stage internals |
| Check past runs | newest `runs/<run-id>/.../output/` | — |
| Verify wiring | `tools/link-check.sh` (must print "Routing health OK") | — |
| Change schedule/delivery/params | `config.md` | stage contracts |
| Log a new work item mid-week | append to `collect/week-items.md` per `stages/01-collect/CONTRACT.md` | stages 02/03 |

## Failure Protocol (fix-or-adapt)

1. Diagnose: read the stage's CONTEXT.md recovery protocol and the run's last artifact — locate the failing step, not the symptom.
2. Adapt in-contract: fix within the stage's declared tools and contract (e.g. retry once, treat a missing log as empty, skip with a written reason).
3. Escalate with evidence only: if no in-contract exit exists, report to the owner with the exact file paths and tool errors — never a bare "it failed".

Run-data write-guard: run data is read-only outside stage execution. Recovery = fix the contract (CONTEXT.md/CONTRACT.md), then re-run — the harness resumes at the first incomplete stage. Never hand-edit `state.json` or a run's outputs to force completion.

## Stage Handoffs

- 01-collect → 02-synthesize: `/home/mino/.mino/playbooks/weekly-work-report/collect/week-items.md` (raw dated entries) — 02 reads it, never edits the log.
- 02-synthesize → 03-render: the draft under 02's `output/` (report-draft.md) — 03 renders it ONLY after the owner approves the draft on Telegram.
- 03-render → archive: moves the week's log to `collect/archive/week-items-<date>.md` and starts a fresh `week-items.md`.
