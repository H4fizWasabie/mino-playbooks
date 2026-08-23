# Curate and Publish Malaysian Daily News

## Inputs

| Source | File/Location | Scope | Why |
| --- | --- | --- | --- |
| Shared rules | `/home/mino/.mino/playbooks/shared/platform-rules.md` | Full | Platform boilerplate (clock, exclusions, anti-skip, Telegram report) |
| Runtime | Authoritative local clock | Current run | Establish the Malaysia date and freshness cutoff |
| Prior report | `/home/mino/.mino/playbooks/malaysian-news-daily/runs/*/stages/*/output/malaysian-news-report.md` | The most recent completed report only | Exclude previously used stories, URLs, events |
| Web research | Current Malaysian news search | Five required categories | Select fresh, credible, directly linked articles |

## Budget (HARD LIMITS — the run stops at 15 tool calls, so plan the whole run)

- **1 `read_file` for exclusions**: read ONLY the single most recent completed `malaysian-news-report.md`. Do not enumerate or read multiple run folders.
- **Searches:** exactly 1 `search_web` per category (5 total). You may spend at most 2 rescue searches across the whole run (max 7 total). Never exceed 7 `search_web` calls.
- **Target total tool calls for the run: 10–11** (1 read + 5–7 searches + 1 write + 1 publish + 1 Telegram). Keep it lean — every call is a turn and the runtime hard-stops at 15.
- If a category has no verified fresh story after its search, mark it `No suitable verified story found today` with a one-line explanation and move on. Do NOT broaden, refetch, or re-search the same category.
- If you only have a headline/topic but cannot verify a direct article URL within the budget, treat it as unverified and use the `No suitable verified story found today` fallback for that category.
- NEVER burn the budget perfecting a category. Completing the run with fallbacks is better than exhausting iterations and producing nothing.

## Process

1. Determine today's date and time from the authoritative runtime context. Read the single most recent completed `malaysian-news-report.md` and build a short exclusion list of its titles, URLs, events, and distinctive claims. Treat the same event as used even when a later article has a different headline, unless there is a clearly material new development.
2. Research current Malaysian news with exactly one search per category — politics, sports, entertainment, disasters, viral news — within the budget above. **Query for a SPECIFIC story, never a broad topic.** Broad queries ("Malaysia politics news today") return section/homepage/topic pages (Malay Mail homepage, NST section, SCMP tag page) which have no direct article URL and fail verification — the category then falls back. Instead search for a **named, newsworthy item** (a person + event + recent date, e.g. "Pulau Batu Puteh RCI report appeal court Aug 2026" or "Jeong Eunji solo concert Kuala Lumpur October 2026") so the top results are the individual article(s), not a landing page. Prefer reputable Malaysian or international publishers and direct article URLs. If your first query returns only homepages/tag pages, use ONE rescue per category (within the 2-rescue budget) with a more specific name+event; never publish a section or topic page as a story. **Shape each search and extract-once**: if a search result spills (a `[artifact: ... → N chars]` note — Mino spills tool results over ~4000 chars), do NOT page it chunk-by-chunk — pull the story titles/URLs you need in ONE pass and move on.
3. Select exactly one fresh story per category when credible reporting exists. De-duplicate across categories and against the prior report. Do not use section landing pages, search-result pages, unverifiable social posts, or invented URLs. If a category has no adequately verified fresh story, mark it `No suitable verified story found today` and explain briefly.
4. Verify the selected articles and summarize each in 2–4 concise sentences, preserving uncertainty and attribution. Include the article title, publisher, publication date when available, and direct URL. Clearly label all five categories.
5. Draft a Facebook-ready roundup with a short headline, the labeled summaries for VERIFIED categories only, **and EACH item MUST carry its DIRECT ARTICLE URL inline (the actual story link, not just the publisher name) — every verified story's URL goes in the post text. A post that lists source NAMES but omits the URLs is a FAILED post; rewrite with the URLs before publishing.** Also a brief note that the links are sources. If a category has no verified story, OMIT it entirely from the post — never mention the fallback, the failure, or the search process in the caption. The post must read as if the category was simply not included. Keep it readable and avoid sensational claims, especially for disasters and viral stories.
6. Publish the roundup immediately to Facebook Page `the Page` using page ID `YOUR_PAGE_ID` in a single `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT` call whose action `slug` is EXACTLY `FACEBOOK_CREATE_POST` (never a variant: not `facebook_post_create`, not `FACEBOOK_POST_CREATE`, not `FACEBOOK_PAGES_CREATE_PAGE_POST`), passing the complete caption as `message`, the page ID as a string, and `published: true`. Capture the returned post identifier. Do not blindly retry a non-idempotent publish if the result is ambiguous.
7. Write the complete verified report to the exact declared output path, including run date, five selected categories and URLs, exclusion/novelty decision, Facebook publication status and post ID, and the complete text posted.
8. **Send the owner exactly one Telegram message using `send_message` with `to="the owner"` — CRITICALLY, ONLY AFTER the Facebook publish call (step 6) has returned a post ID. Send the report strictly AFTER publishing, with the ACTUAL post ID in it — never before, never with a placeholder.** 
   
   ⚠️ CRITICAL SAFETY PROTOCOL FOR PARSE SUCCESS:
   - NEVER use raw line breaks in the message text; use single spaces to join everything.
   - NEVER use unescaped double quotes ("); use single quotes (') instead.
   - REQUIRED FORMAT: "[Brief 1-sentence intro]. • Headline 1 (Source) • Headline 2 (Source) • Headline 3 (Source) • Headline 4 (Source) • Headline 5 (Source). • FB Post ID: [ID]"
   - LIMIT: Maximum 150 words. Omit full URLs to keep the payload short. Do not send a second report on retry or failure.

## Tools
- `read_file`
- `search_web`
- `write_file`
- `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT`
- `send_message`

## Outputs

| Artifact | Location | Format |
 | --- | --- | --- |
| Stage report | `output/malaysian-news-report.md` | Markdown |
## Success

| Outcome | Required tool call |
| --- | --- |
| Post published | `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT` with slug `FACEBOOK_CREATE_POST` returned a post ID |