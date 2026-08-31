# Threads Replies — engage the good fires, quarantine the spam

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Engage with replies on recent Threads battle and community posts — answer the good fires, quarantine spam, never reply twice. The shared quarantine digest is a mandatory declared output of every run.

Operated by the `community-builder` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
threads-replies/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-engage/     (the contract: fetch replies → quarantine → classify → dedup-gate → reply → digest)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
