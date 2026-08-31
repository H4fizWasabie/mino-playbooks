# Weekly Audit — Sunday judgment meat-grinder

*ICM Layer 0 — workspace identity and map. See CONTEXT.md for routing.*

The judgment meat-grinder. Reads all 7 days of post logs and scores Mino's own work: repeated angles, stale jokes, rubber-stamped image critiques, failed runs. Output is ADVICE — never self-modification of contracts or memory. Day-gated: runs only on Sunday (authoritative local date); on other days write the skip log and end without Telegram.

Operated by the `reality-checker` persona (workspace-owned; see `persona/CONTEXT.md`). Mino's outer rails — SOUL.md, the runtime MAP.md, memory, audit, cancellation, retries, output verification, and tool policy — are owned by the harness and always take precedence over this workspace's own contracts.

## Folder Map

```
weekly-audit/
├── AGENTS.md            (you are here — workspace identity and map)
├── CONTEXT.md            (routing, failure protocol, stage handoffs)
├── config.md             (runner: description, status, agent)
├── persona/              (persona pointer → agency roster; see Routing)
├── stages/01-audit/      (the contract: day gate → sample logs → score 4 dimensions → Telegram)
├── tools/link-check.sh   (routing health: links + orphans)
└── runs/                 (Mino-owned run state — never hand-edit state.json)
```

Read CONTEXT.md next for routing, the failure protocol, and stage handoffs.
