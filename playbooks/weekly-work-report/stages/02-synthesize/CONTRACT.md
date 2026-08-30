# Stage 02 — synthesize (draft + review checkpoint)

Purpose: turn the week's raw log into a professional draft report for the owner's review.

## Trigger

Scheduled Monday 08:00 +08. Report covers the PREVIOUS week (Mon–Sun, backdated).

## Input

- `../../collect/week-items.md` (all entries dated within the report week)
- Nothing else. Do not invent items; if the log is empty, tell the owner instead of fabricating.

## Steps

1. Organize entries into: Accomplishments / Ongoing work / Issues & blockers / Plans for next week.
2. Write `output/report-draft.md` — plain professional English, procurement-appropriate,
   no AI-flavored filler. Numbers and PO references only from the log.
3. Send the draft to the owner on Telegram with: "Draft for week ending YYYY-MM-DD — review?"
4. STOP. Do not render the PDF until the owner approves or requests edits.

## Checkpoint

Human review is mandatory. Edits → revise draft → re-send. Approval → proceed to stage 03.

## Output

- `output/report-draft.md`
- One Telegram message containing the draft.
