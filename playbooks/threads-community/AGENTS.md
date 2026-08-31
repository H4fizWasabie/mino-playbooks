# Threads Community Post — @AiThreads daily

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Autonomous playbook: one safe-reach Threads post daily at 11:00 tagged into the @AiThreads community (1M members). Even days = fresh funny observation about Malaysian dev life; odd days = trending GitHub repo spotlight. Never the same joke, repo, or idea twice.

Operated by the `content-creator` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
threads-community/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-post/       (the contract: select → compose → gate → publish → log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
