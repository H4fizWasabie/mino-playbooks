# Arena Post — One Tribe vs Another

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Shared rules | `/home/mino/.mino/playbooks/shared/platform-rules.md` | Full | Platform boilerplate (clock, exclusions, anti-skip, Telegram report) |
| Shared gate | `/home/mino/.mino/playbooks/shared/threads-gate.md` | Full | Threads judgment gate |
| Runtime | Authoritative local date | Full | Date the post |
| Recent posts on ALL platforms | `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` | Most recent 14 completed logs, or all available if fewer | Same idea or angle in any of them in the last 7 days = pick another |

## Process

0. **Hard stop — non-overridable.** You get at most **10 tool calls** for this stage. At call 10 you MUST write the log (published or skip-reason) from what you have. This ceiling exists so the stage can never loop into a timeout. **The `send_message` report (step 9) is NEVER dropped — a run that writes the log but skips Telegram has failed its contract; if at the ceiling, spend your last calls on it.**

1. Read the most recent logs across ALL platforms (glob `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md`) to build the exclusion list. Do not reuse an idea, angle, or punchline from any platform in the last 7 days. **Shape the reads/extracts**: if a log/glob dump spills (a `[artifact: ... → N chars]` note — Mino spills tool results over ~4000 chars), do NOT page it chunk-by-chunk — pull the titles/topics you need in ONE pass. **If the recent logs are unavailable, that is NOT a skip reason** — read this playbook's own run log first for the side-rotation check, treat the rest of the exclusion list as empty, and proceed.
2. Choose the arena from the rotation bank (day-of-year mod 7, computed from the run header timestamp): 0=vibe coders vs real developers; 1=self-proclaimed engineers vs actual engineers; 2=programming language dispute (PHP vs Go vs JS); 3=Codex vs Claude; 4=LLM intelligence: reasoning vs pattern-matching; 5=AI users vs non-users; 6=open source vs proprietary. Optionally search_web for a fresh Malaysian dev-circle controversy and prefer it if it is materially different from the last 7 days of posts.
3. Pick a side — randomly, but never the same side as the previous arena post (check this playbook's own log first).
4. Compose the inciter post, under 500 characters: a spicy-but-defensible claim for your side, one jab at the other side aimed at their BEHAVIOR (never a person, never identity), and end with a question that forces a reply. 1-2 hashtags. Do not tag any community.
5. Judgment gate — before posting, self-review must pass all: (a) mocks behavior, never identity or named persons; (b) no politics, religion, race, royalty, or defamation; (c) the claim is defensible — you could argue it in a comment; (d) the embarrassment test: you should be comfortable explaining this post to a business contact. If any fail, rewrite ONCE with the failure in mind; if it still fails, skip the day: write the log with the reason and do NOT post.
6. Publish with the registered `threads_post` tool.
7. Write `output/threads-battle-log.md` with date, arena, side taken, exact post text, and post ID (or skip reason).
8. **Send the owner the Telegram report EXACTLY ONCE via `send_message` with to=the owner — CRITICALLY, ONLY AFTER the `threads_post` call has returned a post ID (step 6 must complete first). Send the report strictly AFTER publishing, with the ACTUAL post ID in it — never before, never with a placeholder like "pending".** Content: arena, side, post text, post ID (or skip reason).

## Tools

- `threads_post`
- `search_web`
- `read_file`
- `write_file`
- `send_message`

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Battle log | `output/threads-battle-log.md` | Markdown |

## Success

| Outcome | Required tool call |
| --- | --- |
| Post published | `threads_post` returned a post ID |
