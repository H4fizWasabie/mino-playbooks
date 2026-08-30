## Inputs
- Candidate posts from 01-discover-posts
- Composio Reddit tools (active connection)
- Dedup file: `/home/mino/.mino/data/reddit-karma/commented-posts.md`
- Platform rules: `/home/mino/.mino/playbooks/shared/platform-rules.md` (read-only boilerplate: clock, exclusions, anti-skip, Telegram report)

## Process

1. Read the candidate posts from output/candidates.md.
2. Select AT MOST 1 post per run (single comment). This is a hard cap. The daily budget of ~2 comments is achieved by TWO scheduled runs (10:15 and 10:35 MYT), spaced 20 minutes apart — Reddit's ~9-minute per-account comment cooldown is cleared by the gap BETWEEN runs, never by sleeping inside a run. For the post selected, draft a genuinely helpful comment: 2-4 sentences, no links, no self-promo, adds real value to the conversation.
3. Post comments **one at a time, sequentially** — NEVER as a single batched call. Use **`REDDIT_POST_REDDIT_COMMENT`** via `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL`.
   - Required args: `thing_id` (the post fullname, e.g. `t3_abc123`), `text` (markdown comment)
   - Response path for created comment: `data.json.data.things[0].data.name`
   - **NEVER use `sleep` to wait out a rate limit or spacing rule** — the harness bash tool has a hard 2-minute timeout, so any `sleep` over 120s is killed mid-run (verified against mino v3.3.2 tool catalog 2026-08-29).
   - If a call returns `successful=false` with status 200 and a rate-limit hint ("take a break", "too much"), do NOT retry that same post and do NOT wait. Record the error and end the run; the next scheduled run (20 min later) will pick a fresh candidate. A skipped post due to rate limit is a valid logged outcome, not a failure.
   - "successful=true" means the API accepted the comment — it does NOT guarantee public visibility. Reddit's spam filter can remove comments from low-karma accounts; that is outside this stage's control.
   - Do NOT use `REDDIT_COMMENT` — that tool does not exist. Always use `REDDIT_POST_REDDIT_COMMENT`.
4. **After all comments are posted**, read the current dedup file at `/home/mino/.mino/data/reddit-karma/commented-posts.md` using `read_file`, then append the newly commented post URLs to it using `write_file` in append mode. This ensures future runs skip these posts.
5. Log all posted comments with their post URLs, returned comment IDs, and the full permalink (https://www.reddit.com<post path>/<comment id>/). State plainly in the log that visibility on Reddit is not verifiable from this environment — the permalink is for manual checking.

## Tools
- `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL` with tool_slug `REDDIT_POST_REDDIT_COMMENT`
- `read_file`
- `write_file`
- `send_message`

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Comment log | `output/karma-log.md` | Markdown |

## Path warning (IMPORTANT)
- `output/karma-log.md` is run-relative — resolve it to this stage's OWN run output directory: `/home/mino/.mino/playbooks/reddit-karma-builder/runs/<THIS-RUN-ID>/stages/02-comment-and-log/output/karma-log.md`.
- NEVER duplicate the `.mino` segment (`/home/mino/.mino/.mino/...` is WRONG) and never use a relative `.mino/...` prefix. The run id is the one from the CURRENT run — read it from the stage context, do not guess.
- Use `write_file` with the exact resolved path, mode=overwrite. The stage CANNOT complete unless the declared output was written by your own write_file call at that exact path.
## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- Comment post fails for one post → record the error, never retry the same post; continue with remaining candidates within the caps.
- Missing dedup ledger → treat as empty and create it.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
