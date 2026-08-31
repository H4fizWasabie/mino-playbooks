# Daily AI News — top-3 stories, Threads post, Telegram report

See AGENTS.md for workspace identity and the folder map.

## Routing

| Task | Go To | Do NOT Load |
|------|-------|-------------|
| Understand or change one stage | that stage's `stages/NN-name/CONTEXT.md` — the contract IS the behavior | other stages' internals |
| Tune research stance or voice | `persona/CONTEXT.md` → this workspace's own `persona/trend-researcher.md` | stage internals |
| Check what was published on a given day | newest `runs/<run-id>/stages/03-synthesize/output/03-report.md` | — |
| Verify wiring after edits | `tools/link-check.sh` | — |

## Failure Protocol (fix-or-adapt)

A day with fewer than 3 stories — or zero, logged honestly — is a SUCCESS. The only true failure is a placeholder output or a missing declared file. When something breaks, navigate the workspace and recover in-contract:

1. **Diagnose** — read the failing contract section and the actual error. Known failure modes have declared exits: blocked/paywalled source → drop and pick an alternative (see Source Quality Rules in `stages/01-judgment/`); fetch fails → mark `fetch failed`, continue; all sources fail → `## No stories today`.
2. **Adapt** within the contract's bounds — never re-search past the declared caps.
3. **Escalate** to the owner only what genuinely blocked the day, with evidence and the recovery already attempted — never a bare failure report.
4. After any structural fix, run `tools/link-check.sh` before declaring done.

- **Run data is read-only outside stage execution** (harness write guard). Never hot-patch `runs/<id>/...` mid-run; recovery of a failed run = fix the contract (these docs), then re-run — the harness resumes at the first incomplete stage.

## Stage Handoffs

- `01-judgment` → `02-fetch`: via `../01-judgment/output/topics.md` (topics + verified source URLs).
- `02-fetch` → `03-synthesize`: via `../02-fetch/output/facts.md` (extracted facts per story).
- `03-synthesize` publishes (Threads + Telegram) and writes the durable log. It is the only stage that sends messages.
