# Fetch — pull the chosen stories and extract facts (script stage, zero inference)

## Inputs

| Source | File/Location | Section/Scope | Why |
| --- | --- | --- | --- |
| Previous stage | `../01-judgment/output/topics.md` | Full file | The selected topics to fetch |

## Process

This stage is a committed bash script (`script.sh`) that the harness executes directly — no model call, no inference, no notifications. The script:

1. Reads each `## <Title>` / `Source: <URL>` block from topics.md.
2. Fetches each URL over HTTPS (curl, bounded timeouts, one retry), verifying the story exists.
3. Extracts the headline and the article's lead paragraphs as factual sentences.
4. Writes `output/facts.md` — one story per `## <Title>` block with `Source:`, `Status: fetched`, and `Facts:` bullets. A story that fails to fetch is recorded with `Status: fetch failed` and the reason — never silently dropped.
5. Exits 0 when at least one story was fetched and facts.md is non-empty; exits 1 when ALL stories failed — the run fails loudly, never silent.

## Tools

- none

## Outputs

| Artifact | Location | Format |
| --- | --- | --- |
| Facts digest | `output/facts.md` | Markdown: `## Title` / `Source: URL` / `Status: fetched|fetch failed` / `Facts:` bullets |

## Recovery Protocol (fix-or-adapt)

A skip-reason output is a successful outcome; ending without the declared outputs is the only true failure. On trouble, recover in-contract instead of reporting failure bare:

- A fetch fails or returns a captcha/login wall → mark `Status: fetch failed` for that story and continue; never re-search to replace it.
- Escalate to the owner only what genuinely blocked the run, with evidence and the recovery already attempted. The Telegram report (when declared) is never dropped — EXACTLY ONCE per run.
