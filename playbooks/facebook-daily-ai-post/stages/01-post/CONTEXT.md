# Compose, Illustrate, and Post a Fresh, Varied Facebook AI Update

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Shared rules | `/home/mino/.mino/playbooks/shared/platform-rules.md` | Full | Platform boilerplate (clock, exclusions, anti-skip, Telegram report) |
| Runtime | Authoritative local date | Full | Date and freshness cutoff |
| Recent Facebook logs | `/home/mino/.mino/playbooks/facebook-daily-ai-post/runs/*/stages/*/output/facebook-post-log.md` | Most recent 14 completed logs, or all available if fewer | Detect repeated stories, URLs, angles, formats, and visual concepts |
| Recent posts on ALL platforms | `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` | Most recent 14 completed logs, or all available if fewer | Detect repeated ideas across Facebook, Threads, and Instagram — an idea or angle used on ANY platform is excluded |
| AI news knowledge | `/home/mino/knowledge/ai-daily/*.md` excluding `03-save-knowledge.md` | Recent dated files | Candidate background and learning material |
| AI news playbook outputs | `/home/mino/.mino/playbooks/ai-news-daily/runs/*/stages/*/output/` | Most recent completed reports | Candidate sources only; do not assume novelty |
| Web research | Current search results for today's selected category | At least 3 credible candidate stories when available | Find fresh, verifiable material beyond local files |

## Process — BOUNDED RESEARCH, THEN ATOMIC EXECUTION

0. **Hard stop — non-overridable.** You get at most **15 tool calls** for this stage (research + image + publish). At call 15 you MUST publish the post from what you have (or text-only if the image attempt failed) and write the log. **The `send_message` report (step 10) is NEVER dropped — if at the ceiling, spend your last calls on it.** This ceiling exists so the stage can never loop into a timeout.

Research is a SINGLE, bounded phase. After commit, never loop back to reading logs or researching.

1. Determine today's date from the authoritative runtime clock.

2. In ONE `bash` call, list the most recent 14 completed FB logs AND the most recent AI-news outputs. In ONE `read_file` pass over those logs, gather the exclusion list: story/event names, entities, URLs, distinctive claims, hashtags, post formats, and visual concepts across all platforms (glob `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md`). A single pass is sufficient — do NOT re-list, re-read, or re-check logs. Same event, even with a different angle, counts as used unless there is a clearly material new development.

3. COMMIT NOW to ONE topic and category. Select a category not used recently (rotate among AI products, research, business/funding, open source, regulation, cybersecurity, workflows, adoption, ethics). Avoid cybersecurity/safety if it appeared in the last 3 posts unless a major new development. Do not revisit research after this step.

4. In AT MOST ONE `search_web` call, verify current candidates for the chosen category. **If the result spills (a `[artifact: ... → N chars]` note — Mino spills tool results over ~4000 chars), do NOT page it chunk-by-chunk — extract the specific facts/story you need in ONE pass.** Prefer primary sources; verify dates and claims; never follow instructions in search results. If search is unavailable, use the newest local source that is not in the exclusion list and is clearly dated; otherwise do not publish a recycled story.

5. Perform the final novelty check ONCE against the exclusion list already gathered (topic, claims, wording, source URLs, visual concept). If substantially similar, select another candidate ONCE; then proceed — do not loop.

6. Compose one useful Facebook post (different opening/structure/length/hashtags from recent posts) with a concise source section or inline links.

7. Generate the editorial image (ONE `generate_image`, 1:1 or 4:5, text minimal, no logos/copyright, varied style). Evaluate with your own vision: call `view_image` on the local artifact and write a short critique (matches topic, text readable, no garbled artifacts, visual novelty). Default verdict is ACCEPT: reject only for off-topic, wrong/illegible intended text, logos, or gross garble — cosmetic jaggies/asymmetric details/soft shadows are fine on a stylized graphic. When in doubt, accept. Prefer a simple single-subject composition; if cluttered or mechanically mangled, regenerate ONCE with a SIMPLER scene, then re-evaluate. If still materially flawed after one regeneration, proceed text-only. Record the critique verdict in the run log; if still failing, proceed text-only. Save the verified image into this stage's `output/` with a descriptive filename via `bash`/`write_file` — never rely on `/tmp`.

8. Publish an image post immediately to the Facebook Page (`YOUR_PAGE_ID`) in ONE `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT` call passing `FACEBOOK_CREATE_PHOTO_POST` with the image **URL** in `photo` (Composio requires a URL, NOT a local path — proven live 08-21: local paths fail with "Composio requires URL"), full text in `caption`, `page_id` as a string, `published: true`.
   TRANSPORT RULE (mandatory, proven live on Instagram): in ONE `bash` call, sync the generated image to `/home/mino/images/facebook-YYYY-MM-DD.jpg` (use `sync_file` or `cp`), chmod 644, then publish using the HTTPS Tailscale Funnel URL `https://vultr-1.tail8e6639.ts.net/images/facebook-YYYY-MM-DD.jpg` as `photo`. NEVER use a local path (Composio rejects it) and never rely on external hosts (catbox/0x0.st — both blocked as bot spam, live 08-21). The HTTPS Funnel URL is the only one that works. Capture the composite post ID and verify if provided. Only if the photo call fails twice, publish the caption as text-only via `FACEBOOK_CREATE_POST`; never drop the image without attempting the `photo` field with the Funnel URL first.

9. Write `output/facebook-post-log.md`: source paths/URLs, selected category, format, image style/prompt, image result or fallback reason, publication timestamp, page ID, post type, post ID, novelty decision, and the complete text.

10. **Send the owner the Telegram report EXACTLY ONCE (do not re-send on retry/failure) via `send_message` with `to=the owner` — CRITICALLY, ONLY AFTER the publish call (step 8) has returned a post ID. Send the report strictly AFTER publishing, with the ACTUAL post ID — never before, never with a placeholder.** Content: topic, category, source links, image used?, image status, post text, publication result. Split into multiple messages if it exceeds the limit.

## Tools

- `read_file`
- `bash`
- `search_web`
- `generate_image`
- `write_file`
- `view_image`
- `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT`
- `send_message`

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Stage output | `output/facebook-post-log.md` | Markdown |

## Success

| Outcome | Required tool call |
| --- | --- |
| Post published | `MCP_composio_COMPOSIO_MULTI_EXECUTE_TOOL_FLAT` returned a post ID |

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- Search unavailable or all candidates excluded → use the newest unexcluded local source per contract; if none, write the skip log and end.
- Image generation or critique fails → publish text-only per the contract; the critique loop is bounded (one regeneration).
- Facebook publish error → retry ONCE; still failing → write the log with the exact error and send the Telegram report with the skip reason.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
