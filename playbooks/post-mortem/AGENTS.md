# Post-Mortem — diagnose Mino's own failure from its own trace

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Diagnose Mino's most recent failed run from its own trace, with cited evidence, and write a wayfinder-style ticket. On-demand, not scheduled.

Operated by the `reality-checker` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
post-mortem/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent, notify)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-diagnose/   (the contract: harness post_mortem tool → evidence → ticket)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
