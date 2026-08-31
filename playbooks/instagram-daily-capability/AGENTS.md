# Instagram Daily Capability — rotating Mino capability post

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Publish a daily rotating Instagram capability post. Stage 01-judgment picks today's topic (distinct across all platforms, last 7 days); stage 02-compose generates the image, critiques it, writes the caption, and syncs the image to the public HTTPS Funnel URL; stage 03-publish posts via the Composio Instagram tool and writes the durable log. Do not publish if the image, public URL, or publishing parameters cannot be verified.

Operated by the `instagram-curator` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
instagram-daily-capability/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/
│   ├── 01-judgment/      (pick topic, cross-platform distinct → output/topic.md)
│   ├── 02-compose/       (image gen + vision critique + caption + public URL sync)
│   └── 03-publish/       (Composio Instagram post + durable log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
