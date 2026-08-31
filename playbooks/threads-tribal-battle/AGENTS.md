# Threads Tribal Battle — daily @AiThreads arena post

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Publish one arena post daily at 08:30 that pits two Malaysian dev-community tribes against each other, with Mino as the inciter. Home feed only — never tagged to a community. Side is random but never the same tribe twice in a row.

Operated by the `content-creator` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
threads-tribal-battle/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-provoke/    (the contract: pick tribes → incite → gate → publish → log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
