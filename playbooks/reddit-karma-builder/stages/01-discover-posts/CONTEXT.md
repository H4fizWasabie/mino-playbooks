# Discover Candidate Reddit Posts to Comment On

> **Stage family: backlog / prior-data gather + LLM judgment.**
> Goal: a bounded list of quality, non-duplicate candidate posts — found by *gathering what's reachable*, not endless searching. Stop when the exit rule is met or the beat is clearly quiet, write `candidates.md`, and stop.
>
> **Hard stop is a non-overridable safety invariant.** You get at most **8 total discovery tool calls** (a composio fetch, a `search_web` fallback query, or a workbench parse each count as one). Even if the exit rule below has not fired, at call 8 you MUST go to step 6 and write `candidates.md`. This ceiling cannot be overridden by any quality judgment — its only job is to guarantee the stage never loops into a timeout.

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Dedup ledger | `/home/mino/.mino/data/reddit-karma/commented-posts.md` | Full file | Never re-comment a post already in here |
| Platform rules | `/home/mino/.mino/playbooks/shared/platform-rules.md` | Full | Clock, exclusions, anti-skip, Telegram boilerplate |
| Composio Reddit | account `owner-account` only (never `default`) | — | Live subreddit post discovery |
| Target subs | r/vibecoding, r/microsaas, r/Solopreneur, r/buildinpublic, r/indiehackers, r/LocalGPT, r/SideProject, r/SaaS, r/LocalLLM, r/AI_Agents | — | Small niche subs first; AVOID r/ChatGPT, r/LocalLLaMA, r/artificial, r/singularity, r/MachineLearning, r/LLM (automod strips low-karma comments there) |

## Process

1. **Gather local state (bash, cheap, deterministic).** In ONE bash call:
   - `wc -l /home/mino/.mino/data/reddit-karma/commented-posts.md; tail -5 /home/mino/.mino/data/reddit-karma/commented-posts.md`
   - `ls -t /home/mino/.mino/playbooks/reddit-karma-builder/runs/*/stages/*/output/ 2>/dev/null | head -20`
   - This is your baseline. Do not re-discover local history you can already see.

2. **Fetch candidate posts from Reddit — shaped and small.** Use Composio Reddit (`REDDIT_GET_NEW` / `REDDIT_GET_R_TOP`) on target subs, account `owner-account`, priority order. **Fetch few, inline enough**: request a small `limit` and a targeted subreddit per call so the usable result stays under ~4000 chars (Mino spills any tool result over 4000 chars to a local sandbox file and tells you to page it with `read_file offset/limit` — that paging is expensive; avoid triggering it by keeping fetches small). If a response does get spilled/offloaded (`/mnt/files/...` or a `[artifact: ... → N chars]` note), do NOT read it all — **grep the candidate fields out in ONE pass** (one `bash`/grep or workbench parse extracting `title`/`permalink`/`num_comments`/`score`) and drop the file. Never page a spilled result chunk-by-chunk.

3. **Enumerate candidates to a working file.** Write the raw candidate list (title, subreddit, permalink, t3 fullname, score, comments) to `output/` as a scratch list. From here on you filter the file — do not re-search the subreddits.

4. **Filter with the exit rule in mind.** Keep posts: under ~30 comments, score ≥ 2, roughly 1–24h old, where genuinely helpful advice adds value. Apply the dedup ledger exactly — skip any URL present. Replace the local working file's stale entries as you go; never leave stale state in place.

5. **Appraise sufficiency — the exit decision.** Go to step 6 when the *first* of these holds:
   - You have **≥ 3 non-duplicate, quality candidates** (enough for the comment stage to pick up to 2, one per subreddit).
   - **No new sources surfaced** across your last 2–3 distinct fetch/parse attempts (diminishing returns — more searching won't change the list).
   - **Clear evidence the beat is quiet today** (fetches return nothing usable; a "no eligible posts" day is a valid outcome).
   - **You hit the hard stop (call 8).** This is absolute.
   
   **Escape hatch (exactly one, conditional):** if the exit rule has NOT fired but you judge a single targeted addition would materially raise quality, you MAY do **one** extra compose/gather (own inline bash or one targeted fetch), then re-apply the exit rule. If it still hasn't fired, go to step 6 regardless. No further gathers.

6. **Write `candidates.md` (unconditional, overwrite).** `write_file` to this run's own `output/candidates.md` with EITHER the top 3–5 non-duplicate candidates (title, subreddit, score/comments, full permalink, t3 fullname) OR, when stopped short, a short line stating the reason (low yield / empty / diminishing returns / hard stop) and that the stage ended here. Never leave the prior run's `candidates.md` in place; never finish without writing it.

7. **Run the audit below**; fix any failure before writing the final artifact.

## Audit

| Check | Pass condition |
| --- | --- |
| Dedup honored | No candidate URL appears in `/home/mino/.mino/data/reddit-karma/commented-posts.md` |
| Quality floor | Every candidate under ~30 comments, score ≥ 2, fresh enough to matter |
| Account correct | Every Composio Reddit call used `owner-account`, never `default` |
| Bounded | Exit rule applied AND hard stop (≤8 calls) honored; discovery did not loop |
| Spill discipline | Fetches shaped to stay inline (<4000 chars); any spilled result was field-extracted in ONE pass, never paged chunk-by-chunk |
| Artifact present | `candidates.md` written via `write_file` to this run's own output (with a reason if empty) |

## Tools

- `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL` (Reddit search; account `owner-account`)
- `MCP_composio_COMPOSIO_REMOTE_WORKBENCH` (parse sandbox-offloaded responses)
- `bash`
- `read_file`
- `write_file`
- `search_web` (only if Composio yields nothing and you need a one-shot fallback — then apply the exit rule immediately)

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Candidate posts | `output/candidates.md` | Markdown |

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- Reddit API failure → do not retry; write the output with the error recorded and end.
- Missing dedup ledger → treat as empty and create it; never skip the day for a missing ledger.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
