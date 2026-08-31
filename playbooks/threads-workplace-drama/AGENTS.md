# Threads Workplace Drama — daily Malaysian office vignette

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Publish one short workplace-drama story daily at 17:30. Not tribal, not AI — a 200-400 character vignette every Malaysian worker recognizes: toxic bosses, toxic managers, toxic work friends, workplace quirks, irresponsible moments. Ends with a comment bait. Story family rotates by day-of-year; the used-stories ledger guarantees no story repeats, ever.

Operated by the `narrative-designer` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
threads-workplace-drama/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-tell/       (the contract: rotate family → tell → gate → publish → ledger → log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
