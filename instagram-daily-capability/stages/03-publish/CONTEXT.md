# Publish to Instagram + Report (FINAL STAGE)

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Previous stage | `../02-compose/output/caption.md` | Full file | Caption + verified image URL |
| Shared rules | `~/.mino/playbooks/shared/platform-rules.md` | Full | Telegram report rules |

## Process

0. **Hard stop — non-overridable.** You get at most **8 tool calls** for this stage. At call 8 you MUST finish from what you have — BUT the `send_message` report (step 6) is NEVER dropped: if at the ceiling, spend your last calls on it (the log write or a retry can wait, the report cannot). This ceiling exists so the stage can never loop into a timeout.

1. Read the caption and image URL from `../02-compose/output/caption.md`.
2. In ONE call: resolve the account with MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL, tool_slug INSTAGRAM_GET_USER_INFO, arguments_json `{"ig_user_id":"me"}`.
3. In ONE call: create the container with tool_slug INSTAGRAM_POST_IG_USER_MEDIA, arguments_json with ig_user_id, the caption, and the image URL from caption.md (the HTTPS Tailscale Funnel URL — never the HTTP datacenter IP).
4. In ONE call: publish with tool_slug INSTAGRAM_POST_IG_USER_MEDIA_PUBLISH, arguments_json with ig_user_id and creation_id.
5. In ONE write_file call: write the log to `output/instagram-post.md` (exact path) with date, topic, caption, image URL, and the post ID returned by the owning tool (never an invented ID).
6. In ONE send_message call: send the owner the Telegram report EXACTLY ONCE (never re-send on retry or failure) with the topic, post text, image URL, post ID (or the verified failure) with to=the owner. **CRITICALLY, ONLY AFTER the publish call (step 4) returned a post ID — send the report strictly AFTER publishing, with the ACTUAL post ID in it, never before, never with a placeholder. This step is MANDATORY: a run that publishes and writes the log but skips the Telegram report has failed its contract.**

## Tools

- read_file
- MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL
- write_file
- send_message

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Post log | `output/instagram-post.md` | Markdown: date, topic, caption, URL, post ID |

## Success

| Outcome | Required tool call |
| --- | --- |
| Post published | MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL returned a real post/creation ID |
