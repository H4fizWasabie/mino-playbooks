# Gmail Daily Cleanup

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

Standing daily Gmail cleanup authorized by the owner. Use the authoritative runtime clock to calculate the 30-day cutoff. Process at most 30 messages per run. Scan once, retain the exact returned message IDs, call Gmail batch modify once with those exact IDs and `addLabelIds: ["TRASH"]`, and write a durable log. Do not re-scan, loop, or request confirmation.

Operated by the `chief-of-staff` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
gmail-daily-cleanup/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-cleanup/    (the contract: discover tools → scan once → batch trash once → log)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
