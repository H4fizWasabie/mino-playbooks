# Weekly Judgment Audit

## Process

1. **Day gate**: if the authoritative local date is NOT Sunday, write `output/weekly-audit.md` with "Skipped: not Sunday" and end. No Telegram.
2. Read the week's logs on a hard budget. Glob `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` for run dirs from the last 7 days, then SAMPLE: read at most the 10 most recent runs per playbook, and at most 2 output files per run. Keep the whole read/score phase within a 30-iteration budget — when the budget is spent, stop reading and score from what was read. Never continue reading past the budget. Before counting anything, read each sampled run's `state.json` and record its `session_id`. Runs from test sessions (`live-test*`, `temp-*`, `exp-*`, `manual*`, `pb-validate*`, or any one-off not named `scheduled-*`) are TEST traffic: they are excluded from all four dimension scores. Test activity is reported at most as one neutral line under a "Test activity" note — never as a dimension finding. A production-behavior claim built on test-session runs is an error, not a finding.
3. **Evidence discipline** (applies to every finding and count):
   - Every number you report must be produced by a command you ran THIS session. Quote the command and its actual output. Never report a count from memory, estimation, or a sample you did not take.
   - Every finding names the `session_id`(s) of the runs it is based on.
   - Before reporting a repeat/loop/streak claim, re-run its counting query once and confirm the number matches. If it does not, report the smaller verified number.
   - If evidence for a candidate finding fails these checks, drop it — a short truthful audit beats a long impressive one.
4. Score four dimensions, evidence-based (quote the log line when citing):
   - **Angle repetition**: do any posts (same or different platforms) carry the same idea, claim, or angle within 7 days? List each repeated pair.
   - **Stale jokes**: any punchline or format repeated across posts, or any of the banned jokes (VS Code / localhost) reappearing?
   - **Image rubber-stamps**: for logs with an image critique, does the critique name concrete observed details, or is it generic approval ("perfect fit", "looks great")? List weak critiques.
   - **Schedule health**: `schedules.json` last_error values, blocked runs in the trace (`schedule_fire_failed`), and any stage that hit its iteration cap.
5. Write the recommendations: for each finding — what to change, and the exact contract/step it applies to (file + section). Mark each as MUST / SHOULD / NICE. Do not apply any change yourself.
6. Send the owner the Telegram summary EXACTLY ONCE via `send_message` with to=the owner: the score per dimension (good/needs work), the top 3 findings with quotes, and the MUST recommendations.
7. Write the DECLARED output `output/weekly-audit.md` with the full report (findings, quotes, recommendations, scores).

## Tools

- `read_file`
- `bash`
- `write_file`
- `send_message`

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Audit report | `output/weekly-audit.md` | Markdown |
