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
