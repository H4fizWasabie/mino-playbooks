# Synthesize — compose the Threads post and the Telegram report (final stage)

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Previous stage | `../02-fetch/output/facts.md` | Full file | The verified facts to synthesize |
| Shared rules | `/home/mino/.mino/playbooks/shared/platform-rules.md` | Full | Platform boilerplate (clock, anti-skip, Telegram report rules) |
| Threads gate | `/home/mino/.mino/playbooks/shared/threads-gate.md` | Full | The composed Threads post must pass this gate |
| Runtime | Authoritative local date | Full | Date the report |

## Process

1. Read facts.md from the fetch stage. A story marked `Status: fetch failed` is reported as unverified — never invent details for it.
2. Compose ONE concise combined Threads post (≤ ~500 characters) covering the top stories. Run the Threads judgment gate (threads-gate.md) on it; rewrite ONCE if it fails; if it still fails, skip the post and note the reason.
3. **Publish the Threads post** via `threads_post`. Record the returned post ID. If publication fails (tool error, gate skip), record the failure reason and continue — do not block the rest of the pipeline.
4. Compose the Telegram report for the owner: the date, one line of significance per story, source URLs, the Threads post link (or skip reason), and the knowledge file path. Terse, structured, skimmable — the trend-researcher deliverable voice.
5. Write the knowledge file `/home/mino/knowledge/ai-daily/<YYYY-MM-DD>-ai-news.md` via write_file — exact dated filename from the run date (this is the playbook's primary output).
6. Send the owner the Telegram report EXACTLY ONCE via send_message with to=the owner (never re-send on retry or failure).
7. Write the complete report to the declared output `output/03-report.md` via write_file — exact path, including the published Threads post link/ID, report, and knowledge file path.
8. Verify the declared output exists before finishing.

## Tools

- write_file
- send_message
- threads_post

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Final report | `output/03-report.md` | Markdown: published Threads post link/ID, report, knowledge file path |