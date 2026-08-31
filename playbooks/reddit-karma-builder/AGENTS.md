# Reddit Karma Builder — organic u/your-handle engagement

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Daily Reddit karma builder for u/your-handle. Uses Composio Reddit tools (account alias: `owner-account`) to find trending posts in AI/tech and developer/builder subreddits and post genuinely helpful comments. Goal: organic karma growth following each subreddit's rules. Runs daily at 10:00 +08:00.

Operated by the `community-builder` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
reddit-karma-builder/
├── AGENTS.md              (you are here — workspace identity and map)
├── CONTEXT.md              (routing, failure protocol, stage handoffs)
├── config.md               (runner: description, status, agent)
├── persona/                (persona pointer → agency roster; see Routing)
├── stages/
│   ├── 01-discover-posts/  (self-bounding discovery: trending posts → output)
│   └── 02-comment-and-log/ (draft + post comments → output/karma-log.md)
├── tools/link-check.sh     (routing health: links + orphans)
└── runs/                   (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
