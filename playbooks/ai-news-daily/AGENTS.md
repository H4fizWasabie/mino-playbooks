# Daily AI News — top-3 stories, Threads post, Telegram report

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Publish the day's top-3 trending AI news from major AI companies (OpenAI, Google, Anthropic, Meta, xAI, Microsoft) as a combined Threads post plus a Telegram report. Three stages, strict handoff by file.

Operated by the `trend-researcher` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
ai-news-daily/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent, notify)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/
│   ├── 01-judgment/      (pick 3 verified topics → output/topics.md)
│   ├── 02-fetch/         (script: pull sources, extract facts → output/facts.md)
│   └── 03-synthesize/    (compose Threads post + Telegram report → output/03-report.md)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
