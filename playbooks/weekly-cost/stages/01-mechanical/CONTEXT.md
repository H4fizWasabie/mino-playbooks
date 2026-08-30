# Weekly Cost + Output Report — Stage 01 (Mechanical)

Deterministic computation only. Zero inference. Writes raw report data to
`output/raw-cost.md`; the synthesize stage handles message composition
and Telegram delivery.

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Runtime | Authoritative local date (Asia/Kuala_Lumpur) | Full | Day gate: skip unless Sunday |
| Usage log | `/home/mino/.mino/state.db` table `usage_log` | 7-day window (SQL-filtered) | Per-model spend (prefer recorded cost_usd) |
| Published outputs | `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` | Last 7 days | Posts-per-playbook count |
| Schedules | `/home/mino/.mino/schedules.json` | Full | Detect lingering last_error values |

## Prices (FALLBACK only — legacy records without real cost)

| Model | Input | Cache | Output |
| --- | --- | --- | --- |
| tencent/hy3:tencent | $0.132 | $0.033 | $0.528 |
| deepseek/deepseek-v4-flash-0731:deepinfra | $0.08 | $0.016 | $0.18 |
| qwen/qwen3.7-flash | $0.03 | $0.006 | $0.13 |
| anything else | check openrouter.ai pricing for that model | |

## Process

1. Day gate: if local day-of-week ≠ Sunday, write "Skipped: not Sunday" to
   output and exit 0. (Respects WEEKLY_COST_FORCE for test-only runs.)
2. ONE sqlite query over `state.db` table `usage_log` (successor of the retired usage.jsonl): 7-day window → GROUP BY model with SUM(in/out tokens, cost_usd) —
   real provider-reported `cost_usd` wins (issue #76); the fallback prices table (below) applies ONLY for uncosted legacy records.
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

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- usage_log missing/unreadable → exit 1 loudly (the run fails; fix the script, not the model).
- Records without cost_usd → use the fallback prices table above for those records only.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
