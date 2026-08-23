# mino-playbooks

Real, production playbooks running on a live [Mino](https://github.com/H4fizWasabie/mino-oss) instance — daily news curation, social posting, morning briefings, cost reports, self-audits.

A **playbook** is Mino's scheduled automation format: a `CONTEXT.md` describing the overall contract, optional `persona.md` (voice) and `config.md` (schedule/description), and a `stages/` directory where each stage has its own `CONTEXT.md` contract and optionally a `script.sh` for mechanical steps. Stages run in order; each stage's output feeds the next; side-effecting steps (publishing, messaging) go through Mino tools so they land in the audit trail.

## Layout

playbooks live in `playbooks/`, one directory per playbook. Layout:
```
ai-news-daily/            Daily AI news: judge topics → fetch facts → synthesize report
daily-ai-concept/         Learn one AI concept per day and store it to memory
facebook-daily-ai-post/   Compose + publish one AI post with generated image
gmail-daily-cleanup/      Daily Gmail triage via script.sh + agent stage
instagram-daily-capability/  Topic judgment → caption → publish pipeline
malaysian-news-daily/     5-category Malaysian news roundup → Facebook + report
morning-briefing/         One-message 07:30 brief from overnight state
post-mortem/              Diagnose a failed run, report root cause
reddit-karma-builder/     Discover trending posts → comment helpfully
shared/                   Cross-playbook rules (platform rules, publish gates)
threads-community/        Daily Threads community post (funny / repo spotlight)
threads-replies/          Engage with replies on Threads posts
threads-tribal-battle/    Playful dev-tribe debate posts
threads-workplace-drama/  Serialized workplace-drama storytelling
weekly-audit/             Weekly evidence-based self-audit of all playbooks
weekly-cost/              Sunday token-spend + output report
```

Each playbook directory is self-contained:

| File | Role |
|---|---|
| `CONTEXT.md` | The playbook contract: purpose, schedule, inputs, outputs, safety rules |
| `persona.md` | Optional voice/persona for the writing stages |
| `config.md` | Schedule and description metadata |
| `stages/<NN-name>/CONTEXT.md` | That stage's contract — what goes in, what must come out |
| `stages/<NN-name>/script.sh` | Optional mechanical step (API calls, formatting) run outside the LLM |

## Patterns worth stealing

- **Stage contracts**: every stage's CONTEXT.md states inputs, outputs, and the failure condition — a stage that skips a mandatory step has *failed its contract*, not just underperformed.
- **Idempotent publishing**: send reports/publish posts EXACTLY ONCE, only after the side-effecting call returns a real ID — never on retry.
- **Mechanical vs judgment split**: deterministic work (fetching, jq formatting) lives in `script.sh`; judgment stays in CONTEXT.md prompts.
- **Shared rules**: `shared/platform-rules.md` centralizes cross-playbook constraints instead of duplicating them.
- **Self-audit**: `weekly-audit` scores the other playbooks' outputs against their contracts.

Personal identifiers (Telegram recipients, page/account IDs) are genericized to placeholders like `the owner`, `YOUR_PAGE_ID`, `owner-account`. Swap in your own values when adapting.

## License

MIT
