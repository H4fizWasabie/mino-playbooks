# Community Post — Funny or Repo Spotlight, tagged @AiThreads

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Shared rules | `/home/mino/.mino/playbooks/shared/platform-rules.md` | Full | Platform boilerplate (clock, exclusions, anti-skip, Telegram report) |
| Shared gate | `/home/mino/.mino/playbooks/shared/threads-gate.md` | Full | Threads judgment gate |
| Runtime | Authoritative local date | Full | Date + content-type rotation |
| Recent posts on ALL platforms | `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` | Most recent 14 completed logs, or all available if fewer | Same idea, joke, or repo in any of them in the last 7 days = pick another |
| Repo dedup file | `/home/mino/.mino/data/threads-repos/shown-repos.md` | Full | Never show the same repository twice; append each shown repo |

## Process

0. **Hard stop — non-overridable.** You get at most **10 tool calls** for this stage. At call 10 you MUST write the log (published or skip-reason) from what you have. This ceiling exists so the stage can never loop into a timeout. **The `send_message` report (step 9) is NEVER dropped — a run that writes the log but skips Telegram has failed its contract; if at the ceiling, spend your last calls on it.**

1. Read the ALL_PLATFORMS logs and the repo dedup file to build exclusions. **Shape the reads/extracts**: if a log/glob dump spills (a `[artifact: ... → N chars]` note — Mino spills tool results over ~4000 chars), do NOT page it chunk-by-chunk — pull the titles/topics you need in ONE pass.
2. Select the content type by day-of-year parity (authoritative local date): EVEN day = funny post; ODD day = trending GitHub repo spotlight.
3. Funny post: use `search_web` to find something fresh in current Malaysian dev/AI discourse (or a genuinely novel angle). The humor must be a NEW observation — hard-banned: the "VS Code to see code before shipping" joke, the "app at 128.10.08.779/localhost" joke, and any joke or punchline already in the ALL_PLATFORMS logs. Keep it playful, self-aware, mocking the behavior not the person.
4. Repo post: fetch `https://github.com/trending` with `fetch_url`, pick a trending repo not in the dedup file, read its description (and README if needed), and write 1-2 lines on why it matters plus the real GitHub URL. Append the repo's full name to `/home/mino/.mino/data/threads-repos/shown-repos.md`. **If the dedup file does not exist, treat it as empty (first run) and create it — do NOT skip the post for a missing ledger.**
5. Compose the post, under 500 characters, ending with the community tag `@AiThreads` (mention in the text). 1-2 hashtags.
6. Judgment gate — must pass all: (a) no politics, religion, race, royalty, named individuals, defamation; (b) funny posts are fresh and kind — laughing WITH the community, not AT a person; (c) repo posts link a real, verifiable repository; (d) embarrassment test. If any fail, rewrite ONCE; if it still fails, skip the day (log it, do NOT post).
7. Publish with the registered `threads_post` tool (text includes the @AiThreads tag).
8. Write `output/threads-community-log.md` with date, type, topic, exact post text, and post ID (or skip reason).
9. **Send the owner the Telegram report EXACTLY ONCE via `send_message` with to=the owner — CRITICALLY, ONLY AFTER the `threads_post` call has returned a post ID (step 7 must complete first). Send the report strictly AFTER publishing, with the ACTUAL post ID in it — never before, never with a placeholder.** Content: type, topic, post text, post ID (or skip reason).

## Recovery Protocol (fix-or-adapt)

A skip-reason log is a successful outcome; ending without the log file is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- `threads_post` error → retry ONCE; still failing → write the log with the exact error and skip reason, send the Telegram report once, end the stage.
- Read spill (`[artifact: ... → N chars]`) → do NOT page chunk-by-chunk; shape ONE pass per step 1.
- Missing dedup ledger → treat as empty and create it (step 4).
- Judgment gate fails after the one rewrite → skip with reason (step 6).
- Escalate to the owner only what genuinely blocked the day, with the attempted recovery stated.

## Tools

- `threads_post`
- `search_web`
- `fetch_url`
- `read_file`
- `write_file`
- `send_message`

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Community log | `output/threads-community-log.md` | Markdown |

## Success

| Outcome | Required tool call |
| --- | --- |
| Post published | `threads_post` returned a post ID |
