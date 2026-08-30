# Weekly Cost + Output Report — Stage 02 (Synthesize)

LLM final stage. Reads the raw report from stage 01, composes the Telegram
message, sends EXACTLY ONCE to the owner, and writes the final output with the
exact message text.

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Stage 01 output | `../01-mechanical/output/raw-cost.md` | Full | Raw numbers: spend table, post counts, schedule issues |
| Shared rules | `/home/mino/.mino/playbooks/shared/platform-rules.md` | Full | Platform boilerplate (clock, exclusion, anti-skip) |

## Process

1. READ AT MOST 3 LOGS — sample the 3 most recent stage output files across
   all playbooks to check for any obvious anomalies worth a one-line note.
   **If not written by iteration 8, write it NOW** with what you have.
2. Read `../01-mechanical/output/raw-cost.md` (the stage 01 raw report).
3. Compose the Telegram message: 💰 **Weekly cost report** header, spend
   summary, output summary, issues list. The message is the report itself,
   formatted for Telegram.
4. Send via `send_message` with to=the owner, EXACTLY ONCE. Schema: `{message,
   to}`.
5. Write the DECLARED output `output/weekly-cost.md` with the full report
   AND the exact message text sent.

## Tools

- read_file
- send_message
- write_file

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Final report | `output/weekly-cost.md` | Markdown: raw report + sent message text |

## Success

`send_message` returns a 15+ digit message ID confirming Telegram delivery.
File-write success = `output/weekly-cost.md` exists and was written by this
stage.

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- Zero-cost week or zero posts → report it honestly; an empty week is data, not an error.
- send_message failed after the report was composed → do NOT re-send on retry; EXACTLY ONE message per run.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
