# Stage 03 — render (mechanical)

Purpose: final draft → PDF → Telegram.

## Trigger

Only after the owner approves the stage-02 draft. Never self-triggered.

## Steps

1. Finalize `../02-synthesize/output/report-draft.md` into `output/report-final.md`.
2. Convert markdown → simple clean HTML (professional, printable, A4).
3. Render with `wkhtmltopdf` to `output/Weekly-Report-YYYY-MM-DD.pdf`
   (date = week-ending Sunday).
4. Verify the PDF exists and is non-trivial size, then send to the owner on Telegram with caption.
5. Archive: move `../../collect/week-items.md` → `week-items-YYYY-MM-DD.md` (week rollover).

## Output

- `output/Weekly-Report-YYYY-MM-DD.pdf` (delivered)
- `output/report-final.md`
- `collect/` reset for the new week.
