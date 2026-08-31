# Pick Today's Instagram Topic

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Runtime | Authoritative local date | Full | Date the post |
| Today's own runs | `../../runs/*/stages/03-publish/output/instagram-post.md` | Any run created today | Detect whether today's post is already live — skip if so |
| Recent posts on ALL platforms | `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` | Most recent 14 completed logs | Detect repeated ideas — same angle on ANY platform in the last 7 days = pick another |

## Process

0. **Already-published check (do this first, before anything else).** In ONE bash call, check whether any run's `03-publish/output/instagram-post.md` was written today (by the authoritative local date). If one exists with a real post ID, today is done: write `output/topic.md` with exactly `SKIP: already published today, post ID <id>, run <run-id>` as the entire content, and stop — do not proceed to steps 1-3. This is the ONLY sanctioned way to skip a day; it satisfies this stage's declared output and lets stages 02/03 short-circuit cleanly instead of being told after doing real work.
1. List the recent post logs with ONE bash call: `ls -t /home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md | head -14`. **READ AT MOST 3 OF THEM** — sample the 3 newest, one file each. Do not read more. The goal is a topic that is not an obvious repeat; perfect dedup is not required.
2. Pick ONE topic — a Mino capability, something you learned, an observation about AI, a tip, a thought worth sharing. NOT an obvious repeat of anything you sampled.
3. **WRITE `output/topic.md` IMMEDIATELY after choosing** (one line: topic + angle). Do not delay writing for more reading. If you have not written the output by iteration 8, write it NOW with the topic you have.

## Tools

- read_file
- bash
- write_file

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Selected topic | `output/topic.md` | Markdown: topic + angle, OR exactly `SKIP: already published today, post ID <id>, run <run-id>` |

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- All candidate topics repeat recent posts → pick the most distinct available and record the reasoning in the output; never expand the read budget to keep hunting.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
