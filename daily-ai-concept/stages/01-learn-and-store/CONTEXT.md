# Learn One Agentic-AI Concept and Store It in the Mino Library

The daily AI-concept library: exactly one curated, Mino-grounded fact per concept, refreshed oldest-first. Pick one concept, research it (bounded), rewrite its fact in place, verify it, report one line. Never loop, never duplicate, never fabricate.

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Curriculum | `/home/mino/.mino/playbooks/daily-ai-concept/curriculum.txt` | Full list | Ordered seed of ~40 concepts; owner-editable |
| Library facts | `/home/mino/.mino/memories/ai_concept_*.md` | All | The current library; rotation is driven by each fact's `at` |
| Recent consolidation | `remember` results for the chosen concept | Recent facts | Lived experience to fold into the rewrite (read-only) |
| Web research | `search_web` | At most 1–2 calls | Fresh, verifiable definition of the concept |

## Library invariants (never break)

- The library is exactly ONE fact per concept, id `ai_concept_<slug>`.
- NEVER create a second fact for a concept — update the existing one in place.
- NEVER delete a library fact.
- Consolidation and other processes never write library facts — only this playbook does.
- Facts stay bounded (~150 words): what it is, how Mino uses it, one-line changelog.

## Process — ONE CONCEPT, BOUNDED RESEARCH, VERIFIED WRITE

0. **Hard stop — non-overridable.** You get at most **10 tool calls** for this stage. At call 10 you MUST finish with whatever remains, BUT the `send_message` step (step 8) is NEVER dropped — if you are at the ceiling, spend your last calls on the fact + learn-log + the single `send_message`; the Telegram report is a required completion, not optional. This ceiling exists so the stage can never loop into a timeout.

1. In ONE `bash` call, list the library facts (`ls /home/mino/.mino/memories/ai_concept_*.md`) and `read_file` the curriculum list.

2. PICK the concept: the first curriculum name with no `ai_concept_<slug>` fact. If all exist, pick the fact with the OLDEST `at` (rotation — refresh oldest-first). Do not pick a concept learned this week unless it is the oldest.

3. RUN `remember` on the chosen concept name to surface recent consolidated facts and older notes touching it — fold anything useful into the rewrite (read-only; never modify those facts).

4. RESEARCH — bounded: at most ONE `search_web` call for the concept. Extract the definition from the results. If it fails or returns nothing usable, ONE retry; if still empty, write from your own reliable knowledge and mark the fact "no external verification this round". COMMIT NOW — do not research further, do not loop. **If a search result spills (a `[artifact: ... → N chars]` note — Mino spills tool results over ~4000 chars), do NOT page it chunk-by-chunk — extract the definition you need in ONE pass and move on.**

5. WRITE the fact in place via `save_note` (or `manage_memory`): id `ai_concept_<slug>`, subject `AI concept: <Name>`, body bounded ~150 words:
   - **What it is** — 2–3 sentences distilled from the search result (only what the source supports; no invented detail).
   - **How Mino uses this** — tie it to Mino's ACTUAL components: `remember`/`save_note`/`manage_memory`, the loop and iteration awareness, `session_notes`, FTS + embeddings, graph edges, consolidation, context preview, tool schemas, `send_message`. This line is the lens.
   - **v<N>:** one line — what changed vs the previous version (or "first version").
   If the fact id already exists, UPDATE it in place — never create a duplicate.

6. VERIFY-THEN-CLAIM: after writing, run `remember` on the concept name and confirm the fact is retrievable. Only then declare the concept learned. Never report "learned" without the fact on the shelf.

7. Write `output/learn-log.md`: date, concept, round number, search source, one-line changelog, verification result.

8. Send the owner ONE Telegram line via `send_message` (to=the owner), exactly once: "today's concept: <Name> — <one-line what it is> — how I use it: <one line>". **This step is MANDATORY — the stage is NOT complete without it. A run that writes the fact + learn-log but skips `send_message` has failed its contract. Do not let the hard stop, the exit rule, or "wrap up now" drop this call.**

## Tools

- `read_file`
- `bash`
- `remember`
- `search_web`
- `save_note`
- `manage_memory`
- `write_file`
- `send_message`

## Outputs
| Artifact | Path |
| --- | --- |
| learn log | output/learn-log.md |
