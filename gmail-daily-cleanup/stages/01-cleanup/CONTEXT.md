## Read
- The authoritative runtime clock.

## Process
1. Discover the Gmail fetch and batch-modify tool schemas and confirm an active Gmail connection.
2. Scan once for up to 20 inbox promotional messages older than 30 days. Use the FLAT tool `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT` with tool_slug GMAIL_FETCH_EMAILS, and request the message IDs INLINE in the response (ids_only true if supported) so the exact IDs are in the tool output — never rely on a remote artifact or workbench file for the IDs.
3. Use the exact IDs from the tool output in one batch modify call (tool_slug GMAIL_BATCH_MODIFY_MESSAGES, arguments_json with the IDs and addLabelIds TRASH).
4. Write the durable cleanup log to output/cleanup-log.md (exact path) with the count trashed and the IDs.
5. Send the owner the Telegram report EXACTLY ONCE (do not re-send on retry or failure) with the count trashed, the log path, and any error via `send_message` with to=the owner.

## Tools
- `MCP_composio_COMPOSIO_SEARCH_TOOLS`
- `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT`
- `write_file`
- `send_message`

## Write
- `output/cleanup-log.md`

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Stage output | `output/cleanup-log.md` | Markdown |
