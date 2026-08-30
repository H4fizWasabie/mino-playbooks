# Gather Morning Facts (script stage)

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Runtime | Authoritative local date (Asia/Kuala_Lumpur) | Full | Date the brief |

## Process

1. The harness executes `script.sh` in this stage — zero inference.
2. The script queries: pending reminders (nearest 3), memory graph state, blocked/needs-you responsibilities, today's schedule, yesterday's published post titles.
3. It writes `output/facts.md` with all of it. Fail-fast on error (non-zero exit fails the run loudly).

## Tools

- none (the script does the work)

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Morning facts | `output/facts.md` | Markdown: reminders, memory, attention, schedule, yesterday's posts |

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- A data source fails (sqlite, reminders, schedules) → the script exits non-zero and the run fails loudly: fix the script, not the model. Never guess missing facts.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
