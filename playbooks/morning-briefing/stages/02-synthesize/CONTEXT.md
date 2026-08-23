# Compose + Send Morning Brief (FINAL STAGE)

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Previous stage | `../01-gather/output/facts.md` | Full file | The gathered morning facts |

## Process

1. Read `../01-gather/output/facts.md`.
2. Compose ONE Telegram message, tight sections: 🌅 **Overnight** (yesterday's posts), ⏰ **Reminders** (nearest 3), 🧠 **Memory** (one line), ⚠️ **Needs attention** (blocked/needs_you, or 'none'), 📅 **Today** (the day's scheduled playbooks with times). Brief, ordered, plain — a competent assistant's memo.
3. Send via `send_message` with to=the owner, EXACTLY ONCE (never re-send on retry or failure).
4. Write the DECLARED output `output/morning-brief.md` with the same content (the message text verbatim).
5. If you have not written the output by iteration 8, write it NOW with what you have.

## Tools

- read_file
- send_message
- write_file

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Brief | `output/morning-brief.md` | Markdown: the sent message text |
