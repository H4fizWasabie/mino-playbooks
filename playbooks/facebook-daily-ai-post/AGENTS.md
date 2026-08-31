# Daily Facebook AI Post

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Daily Facebook AI update — one fresh, varied post (news + image or text) about AI developments, with anti-repeat exclusions and a Telegram report. Bounded research, then atomic execution.

Operated by the `content-creator` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
facebook-daily-ai-post/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-post/       (the contract: bounded research → commit → compose → illustrate → publish → log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
