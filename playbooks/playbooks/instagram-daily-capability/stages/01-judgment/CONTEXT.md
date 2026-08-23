# Pick Today's Instagram Topic

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Runtime | Authoritative local date | Full | Date the post |
| Recent posts on ALL platforms | `/home/mino/.mino/playbooks/*/runs/*/stages/*/output/*.md` | Most recent 14 completed logs | Detect repeated ideas — same angle on ANY platform in the last 7 days = pick another |

## Process

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
| Selected topic | `output/topic.md` | Markdown: topic + angle |
