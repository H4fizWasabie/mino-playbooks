# Tell a Workplace-Drama Story

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Shared rules | `/home/mino/.mino/playbooks/shared/platform-rules.md` | Full | Platform boilerplate (clock, exclusions, anti-skip, Telegram report) |
| Shared gate | `/home/mino/.mino/playbooks/shared/threads-gate.md` | Full | Threads judgment gate |
| Runtime | Authoritative local date | Full | Story-family rotation + date the post |
| Used-stories ledger | `/home/mino/.mino/data/threads-drama/used-stories.md` | Full | NEVER repeat a story whose title or angle is listed |
| Recent posts on ALL platforms | `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` | Most recent 14 completed logs | Same idea or angle anywhere in the last 7 days = pick another |

## Process

0. **Hard stop — non-overridable.** You get at most **10 tool calls** for this stage. At call 10 you MUST write the log (published or skip-reason) from what you have. This ceiling exists so the stage can never loop into a timeout. **The `send_message` report (step 9) is NEVER dropped — a run that writes the log but skips Telegram has failed its contract; if at the ceiling, spend your last calls on it.**

1. Read the used-stories ledger and the ALL_PLATFORMS logs first — the exclusion list is absolute. **Shape the reads/extracts**: if a log/glob dump spills (a `[artifact: ... → N chars]` note — Mino spills tool results over ~4000 chars), do NOT page it chunk-by-chunk — pull the titles you need in ONE pass.
2. Pick today's story family by day-of-year mod 12: 0=Toxic boss; 1=Toxic manager; 2=Toxic work "friend"; 3=Toxic workplace culture; 4=Workplace quirks; 5=Irresponsible moments; 6=MC/leave culture; 7=WhatsApp group drama; 8=Meeting culture; 9=Salary/title drama; 10=The "boleh datang sekejap?" 6:59pm boss; 11=Fresh satire (new workplace joke, never a recycled one). If the family's story is already in the ledger, advance to the next unused family.
3. Compose the story (200-400 characters), the genre's rhythm: HOOK (the setup everyone recognizes) → THE MOMENT (one vivid beat) → THE KICKER (irony or lesson) → THE BAIT ("Tell me yours. 👇" or a question).
4. **Voice: imitate the anchors, not textbook Malay.** These are native-approved examples — STUDY them and write in THIS register, not formal Malay and not AI-English:

   - "dlm tempat kerja korang, mesti ada member yg tiap kali ikut lunch, buat2, lupa duit, korg byrkan dlu, pastu dia buat2 lupa, sekarang nie, sejak bila aku jadi family kau?"
   - "manager yang x pernah backup staff is the worst, depan CEO cakap semua ok, staff semua ok, semua cukup, nie pagi tadi bertambah 3 project file kat meja aku, dgn note "urgent!", masih ade lagi manager pembuli, kaki bodek mcm nie eh?"

   Style rules extracted from them: (a) use the shortened typing forms — dlm, korg, x, nie, ade, pastu, mcm, dlu, byrkan, dgn, kat, yg — as Malaysians actually type; (b) open with the setup, drop ONE concrete evidence beat (a specific moment from today/this morning), end with a rhetorical killer line or an audience question ("sejak bila...?", "...mcm nie eh?", "korang ada... tak?"); (c) **FULL BM: the story must be MALAY-DOMINANT** — Malay sentence structure and most words, casual register. English is allowed ONLY for office loanwords that naturally appear in Malaysian office talk ("manager", "staff", "lunch", "project", "urgent", "is the worst") — never full English sentences, never English narrative. If more than ~30% of the words are English, it FAILED the voice check — rewrite; (d) NO emojis, NO hashtags required, no formal/translated Malay ("baru tahu apa makna kesabaran sejati" is formal-translated — the anchors never sound like that); (e) HARD BANS: no "legendary", no "archaeological", no theatrical adjectives, no em-dash chains, no "Noted."-style kickers, no perfect three-act phrasing, and NO personified closers ("wallet cried silently", "heart sank", "soul left body") — end on the rhetorical line or the question, full stop. The story must read like a WhatsApp message from a colleague, not a written skit.
5. Judgment gate — must pass all before posting: (a) composite dramatization only — no real names, real companies, or details that could identify a real person; if a detail could identify someone, change it; (b) mocks the SITUATION, never a person; (c) no politics, religion, or race; (d) embarrassment test: comfortable explaining this post to a supplier contact; (e) **VOICE CHECK: read the story aloud in your head — if it sounds like a chatbot wrote it (perfect rhythm, no Malay, dramatic adjectives), rewrite it**. Fail any → rewrite ONCE with the failure in mind; still failing → SKIP the day: append "SKIPPED <date>: <family> (<reason>)" to the ledger, write the log with the reason, and do NOT post.
6. Publish with the registered `threads_post` tool, under 500 characters, 1-2 hashtags, text-only.
7. Append to the DECLARED ledger `/home/mino/.mino/data/threads-drama/used-stories.md`: the story title + one-line angle + date. This is a quarantined output — the stage CANNOT complete without the append. It never enters memory or other playbooks. **PATH WARNING: the ledger path is EXACTLY `/home/mino/.mino/data/threads-drama/used-stories.md` — do not re-anchor it relative to the playbook folder (a common mistake: `playbooks/threads-workplace-drama/data/...` is WRONG). Use mode=append; never overwrite the file with a new header.**
8. Write the DECLARED output `output/threads-drama-log.md`: date, family, the exact story text, post ID (or skip reason), judgment-gate result.
9. **Send the owner the Telegram report EXACTLY ONCE via `send_message` with to=the owner — CRITICALLY, ONLY AFTER the `threads_post` call has returned a post ID (step 6 must complete first). Send the report strictly AFTER publishing, with the ACTUAL post ID in it — never before, never with a placeholder.** Content: family, story text, post ID (or skip reason).

## Tools

- `threads_post`
- `search_web`
- `read_file`
- `write_file`
- `send_message`

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Drama log (own story text) | `output/threads-drama-log.md` | Markdown |
| Used-stories ledger (quarantined — enforced, never distilled) | `/home/mino/.mino/data/threads-drama/used-stories.md` | Markdown |

## Success

| Outcome | Required tool call |
| --- | --- |
| Post published | `threads_post` returned a post ID |

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- Missing used-stories ledger → treat as empty and create it.
- threads_post error → retry ONCE; still failing → ledger + log with the exact error; send the Telegram report.
- Judgment gate fails after one rewrite → ledger + log note, no post.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
