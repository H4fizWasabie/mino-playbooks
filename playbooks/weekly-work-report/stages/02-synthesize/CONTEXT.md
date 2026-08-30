# 02-synthesize — draft + review checkpoint

Monday 08:00 +08, backdated: organize LAST week's entries (Mon–Sun) from
collect/week-items.md into Accomplishments / Ongoing / Issues & blockers / Plans.
Write the draft, send it to the owner on Telegram, then STOP — render only after approval.
If the log is empty, tell the owner instead of fabricating.

## Recovery Protocol

- `collect/week-items.md` missing or empty: treat as an empty week — message the owner that no items were logged, write `output/skip-<week-ending>.md` noting it, and end. That is a SUCCESS.
- send_message to the owner fails: retry once; then write the draft anyway and log the delivery failure to `output/report-draft.md` header — the draft file is the product.
- Ambiguous or undated entries in the log: group by the entry's own date; entries without a date go under a "Date uncertain" note inside the relevant section — never invent dates.
- Do not silently regenerate from scratch on a change request: edit the existing draft per the routing rules; if the draft file is missing, rebuild from `collect/week-items.md` and note the rebuild in the draft header.
- Ending without `output/report-draft.md` (or the skip artifact) is the only true failure.

## Tools

- read_file
- write_file
- send_message

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Draft report | output/report-draft.md | Markdown |
