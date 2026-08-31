# Publish to Instagram + Report (FINAL STAGE)

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Previous stage | `../02-compose/output/caption.md` | Full file | Caption + image URL, or a SKIP sentinel |
| Previous stage | `../02-compose/output/url-verified.md` | Full file | HTTPS verification receipt from Stage 02, or a SKIP sentinel |
| Shared rules | `~/.mino/playbooks/shared/platform-rules.md` | Full | Telegram report rules |

## Process

0. **Hard stop — non-overridable.** You get at most **8 tool calls** for this stage. At call 8 you MUST finish from what you have — BUT the `send_message` report (step 6) is NEVER dropped: if at the ceiling, spend your last calls on it (the log write or a retry can wait, the report cannot). This ceiling exists so the stage can never loop into a timeout.
0.5. **SKIP passthrough (check first).** If `../02-compose/output/caption.md` starts with `SKIP:`, do not call any Instagram/MCP tool. Use `write_file` to write `output/instagram-post.md` containing exactly that same `SKIP: ...` line, send ONE Telegram report to the owner noting today's post is already live (quote the SKIP line), and STOP.
1. Read `../02-compose/output/url-verified.md`. If the file does not exist or does NOT contain `Status: 200` AND `Content-Type: image/jpeg`, write `output/failure.md` with reason "url-verified.md receipt missing or incomplete", send Telegram report to the owner via send_message, and STOP. Do NOT proceed.
2. Read `../02-compose/output/caption.md`. Extract the caption as ONLY the text between the `CAPTION_START` and `CAPTION_END` marker lines, verbatim, excluding the marker lines themselves — never the raw file content, never anything outside those markers. Read the image URL from the `IMAGE_URL:` line.
2.5 **PRE-PUBLISH GUARD (non-overridable):** Extract the image URL from caption.md's `IMAGE_URL:` line and the URL from url-verified.md. ALL three conditions must hold or ABORT:
    (a) Both URLs match exactly (character-for-character).
    (b) The URL starts with `https://vultr-1.tail8e6639.ts.net/images/`.
    (c) The URL does NOT contain `http://149.28.146.30`.
    If ANY check fails: write `output/failure.md` with the specific failed check, send Telegram failure report to the owner via send_message, and STOP. Do NOT call any Instagram/MCP tool.
3. In ONE call: resolve the account with MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL, tool_slug INSTAGRAM_GET_USER_INFO, arguments_json `{"ig_user_id":"me"}`.
4. In ONE call: create the container with tool_slug INSTAGRAM_POST_IG_USER_MEDIA, arguments_json with ig_user_id, the caption extracted in step 2 (between the markers, nothing else), and the image URL.
5. In ONE call: publish with tool_slug INSTAGRAM_POST_IG_USER_MEDIA_PUBLISH, arguments_json with ig_user_id and creation_id.
6. In ONE write_file call: write the log to `output/instagram-post.md` with date, topic, caption, image URL, and the post ID returned by the owning tool (never an invented ID).
7. In ONE send_message call: send the owner the Telegram report EXACTLY ONCE with the topic, post text, image URL, post ID (or the verified failure) with to=the owner. **CRITICALLY, ONLY AFTER the publish call (step 5) returned a post ID — send the report strictly AFTER publishing, with the ACTUAL post ID in it, never before, never with a placeholder. This step is MANDATORY.**

## Tools

- read_file
- MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL
- write_file
- send_message

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Post log | `output/instagram-post.md` | Markdown: date, topic, caption, URL, post ID — OR exactly a `SKIP: ...` line |

## Success

| Outcome | Required tool call |
| --- | --- |
| Post published | MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL returned a real post/creation ID |
## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- Instagram publish error → retry ONCE; still failing → write the durable log with the exact error and skip reason; never publish unverified parameters.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
