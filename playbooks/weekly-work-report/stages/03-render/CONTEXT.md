# 03-render — final report as DOCX (after the owner's review/OK)

Trigger: only after the owner approves the draft from stage 02.

Steps:
1. Read the approved draft (stages/02-synthesize/output/report-draft.md — the draft under stage 02's output/).
2. Fill it into the letterhead template using python-docx (installed, verified v1.2.0):
   - template: ../../assets/letterhead-template.docx (letterhead lives in headers/footers — do NOT modify them)
   - append to the document BODY: title "WEEKLY WORK REPORT", week-ending date line, then sections: Accomplishments / Ongoing Work / Issues and Blockers / Plans for Next Week
   - plain professional formatting: bold section headings, normal paragraphs, bullet lists for items
3. Save as /home/mino/.mino/playbooks/weekly-work-report/output/Weekly-Work-Report-<week-ending YYYY-MM-DD>.docx
4. NO PDF conversion — the owner converts to PDF himself.
5. Send the .docx to the owner via send_document, caption: weekly work report + week-ending date.
6. Archive: move collect/week-items.md content into collect/archive (week-items-<date>.md) and start a fresh empty week-items.md.

## Recovery Protocol

- Template missing or corrupt (`../../assets/letterhead-template.docx`): retry the read once; if still broken, report to the owner with the exact path — do NOT build the DOCX without letterhead from scratch and call it final.
- python-docx error on a section: retry once; if a specific section fails, render the remaining sections, log the skipped section to `output/render-log.md`, and end.
- send_document to the owner fails: retry once; then log the failure + local file path to `output/render-log.md` — the .docx file itself is the product.
- Archive step fails (e.g. `collect/archive/` unwritable): do NOT delete `collect/week-items.md`; leave it in place and log the archive failure — next render will re-archive.
- Ending without the .docx saved under `output/` is the only true failure.

## Tools

- read_file
- bash
- write_file
- send_document

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Render log | output/render-log.md | Markdown |
| Weekly report DOCX | /home/mino/.mino/playbooks/weekly-work-report/output/Weekly-Work-Report-<week-ending-date>.docx | DOCX (this playbook's own output/ dir; quarantined from the ALL_PLATFORMS glob per its absolute path) |

Output: the sent .docx path + archive confirmation, logged to output/render-log.md.
