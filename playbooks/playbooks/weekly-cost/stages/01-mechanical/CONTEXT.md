# Weekly Cost + Output Report — Stage 01 (Mechanical)

Deterministic computation only. Zero inference. Writes raw report data to
`output/raw-cost.md`; the synthesize stage handles message composition
and Telegram delivery.

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Runtime | Authoritative local date (Asia/Kuala_Lumpur) | Full | Day gate: skip unless Sunday |
| Usage log | `/home/mino/.mino/usage.jsonl` | Last 200k lines, 7-day window | Per-model spend (prefer recorded cost_usd) |
| Published outputs | `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` | Last 7 days | Posts-per-playbook count |
| Schedules | `/home/mino/.mino/schedules.json` | Full | Detect lingering last_error values |

## Process

1. Day gate: if local day-of-week ≠ Sunday, write "Skipped: not Sunday" to
   output and exit 0. (Respects WEEKLY_COST_FORCE for test-only runs.)
2. ONE bash pipeline over `usage.jsonl`: tail 200k → jq filter 7-day window →
   group_by model → {model, calls, in, out, cost}. Prefer recorded
   `cost_usd`; defer to fallback prices table ONLY for uncosted legacy records.
3. ONE `find … -newermt '7 days ago'` over playbook output dirs → count
   completed logs per playbook.
4. ONE `jq` scan of `schedules.json` for non-empty `last_error`.
5. Compose markdown table (Spend / Output / Issues), write to
   `output/raw-cost.md`, print to stdout.
6. Exit 0 on success; exit 1 on data unreadable.

## Tools

- none

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Raw report | `output/raw-cost.md` | Markdown table: Spend, Output, Issues |
