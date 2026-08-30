# 01-collect — inbox logging

the owner sends work items at random times ("log this" / "work report"). Log each verbatim
with a date into collect/week-items.md using the entry format in CONTRACT.md. Never
summarize early; drafting happens only Monday in stage 02.

## Recovery Protocol

- Telegram message arrives mid-run or twice: append once, dedupe by (date, verbatim text); a duplicate message is not a new item.
- `collect/week-items.md` missing: treat as empty, create it with a header, and log the item — never fabricate prior entries.
- Tool error on write: retry once; if it still fails, write the item to `output/pending-items.md` with a skip reason and end — the next append picks it up.
- Empty day / no items to log: that is a SUCCESS — end normally.
- Ending without appending the item (or without the skip artifact) is the only true failure.

## Tools

- read_file
- write_file
- edit_file

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Raw week log | `output/week-items.md` | Markdown (appended; canonical copy lives in `../../../collect/week-items.md`) |
