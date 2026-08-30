# Stage 01 — collect (inbox)

Purpose: capture work items the owner sends at random times, tagged as work-report material.

## Trigger

Ad-hoc. the owner says "log this", "this is for work report", or sends items outright.

## Steps

1. Append each item to `../../collect/week-items.md` using the entry format below.
2. Do NOT summarize, judge, or reorganize — log verbatim facts with a date.
3. Never synthesize early. Drafting happens only in stage 02 on Monday.

## Entry format

```
## YYYY-MM-DD — <short title>
- <what happened / task / PO / delivery / issue>, as the owner stated it
```

## Week rollover

Week = Monday–Sunday. The current open file is `week-items.md`. After a report is
generated, archive it to `week-items-YYYY-MM-DD.md` (week-ending Sunday date).

## Output

- `collect/week-items.md` grows; no other artifact. No notification to the owner unless
  an item is ambiguous (then ask one clarifying question).
