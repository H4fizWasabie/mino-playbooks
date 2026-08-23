## Inputs
- Candidate posts from 01-discover-posts
- Composio Reddit tools (active connection)
- Dedup file: `/home/mino/.mino/data/reddit-karma/commented-posts.md`
- Platform rules: `/home/mino/.mino/playbooks/shared/platform-rules.md` (read-only boilerplate: clock, exclusions, anti-skip, Telegram report)

## Process

1. Read the candidate posts from output/candidates.md.
2. Select AT MOST 2 posts per run, one per subreddit (never two from the same subreddit). For each, draft a genuinely helpful comment: 2-4 sentences, no links, no self-promo, adds real value to the conversation. Fewer, spaced-out comments beat a burst: a burst of 3+ looks like bot behavior and triggers Reddit rate limits and spam filters.
3. Post comments **one at a time, sequentially** — NEVER as a single batched call. Use **`REDDIT_POST_REDDIT_COMMENT`** via `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL`.
   - Required args: `thing_id` (the post fullname, e.g. `t3_abc123`), `text` (markdown comment)
   - Response path for created comment: `data.json.data.things[0].data.name`
   - If a call returns `successful=false` with status 200 and a rate-limit hint ("take a break", "too much"), **stop immediately — post nothing further this run**. The cooldown is ~9 minutes and the run cannot wait it out; retrying inside the same run only reinforces the rate limit.
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